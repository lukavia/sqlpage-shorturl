-- remove the session cookie
SELECT 'cookie' AS component, 'session_id' AS name, true AS remove;
-- remove the session from the database
delete from user_sessions where session_id = sqlpage.cookie('session_id');
SELECT 'redirect' AS component, -- Redirect the user to the home page
    '/' AS link;
