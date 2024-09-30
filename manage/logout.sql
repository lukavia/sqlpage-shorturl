-- remove the session cookie
select 'cookie' as component, 'session_id' as name, true as remove;
-- remove the session from the database
delete from user_sessions where session_id = sqlpage.cookie('session_id')
returning 'redirect' as component, -- Redirect the user to the home page
    '/' as link;
