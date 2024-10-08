-- If the oauth_state cookie does not match the state parameter in the query string, then the request is invalid (CSRF attack)
-- and we should redirect the user to the login page.
select 'redirect' as component, 'login.sql' as link where sqlpage.cookie('oauth_state') != $state;

-- Exchange the authorization code for an access token
set authorization_code_request = json_object(
    'url', sqlpage.environment_variable('OIDC_TOKEN_ENDPOINT'),
    'method', 'POST',
    'headers', json_object(
        'Content-Type', 'application/x-www-form-urlencoded'
    ),
    'body', 'grant_type=authorization_code'
        || '&code=' || $code
        || '&redirect_uri=' || sqlpage.protocol() || '://' || sqlpage.header('host') || sqlpage.path()
        || '&client_id=' || sqlpage.environment_variable('OIDC_CLIENT_ID')
        || '&client_secret=' || sqlpage.environment_variable('OIDC_CLIENT_SECRET')
);
set access_token = sqlpage.fetch($authorization_code_request);

-- Redirect the user to the login page if the access token could not be obtained
select 'redirect' as component, 'result.sql?error=' || CAST($access_token->>'error' AS TEXT) as link where $access_token->>'error' is not null;

-- At this point we have $access_token which contains {"access_token":"eyJ...", "scope":"openid profile email" }

-- Fetch the user's profile
set profile_request = json_object(
    'url', sqlpage.environment_variable('OIDC_USERINFO_ENDPOINT'),
    'method', 'GET',
    'headers', json_object(
        'Authorization', 'Bearer ' || ($access_token->>'access_token')
    )
);
set user_profile = sqlpage.fetch($profile_request);

-- Redirect the user to the login page if the user's profile could not be obtained
select 'redirect' as component, 'result.sql?error=' || CAST($user_profile->>'error' AS TEXT) as link where $user_profile->>'error' is not null;

-- at this point we have $user_profile which contains {"sub":"0cc01234","email_verified":false,"name":"John Smith","preferred_username":"demo","given_name":"John","family_name":"Smith","email":"demo@example.com"}

select 'redirect' as component, 'result.sql?error=User Not Allowed' as link WHERE NOT EXISTS(SELECT 1 FROM users_allowed WHERE $user_profile->>'email' LIKE email);

-- Now we have a valid access token, we can create a session for the user
-- in our database
insert into user_sessions(session_id, user_id, email, oidc_token, `name`, given_name, family_name, picture, last_used)
    values(sqlpage.random_string(32), $user_profile->>'sub', $user_profile->>'email', $access_token->>'id_token', $user_profile->>'name', $user_profile->>'given_name', $user_profile->>'family_name', $user_profile->>'picture', current_timestamp)
    returning 'cookie' as component, 'session_id' as name, session_id as value, 'lax' as same_site;

-- Redirect the user to the home page
select 'redirect' as component, 'index.sql' as link;