SET user_email = (SELECT email FROM user_sessions WHERE session_id = sqlpage.cookie('session_id') AND unixepoch(current_timestamp) - unixepoch(last_used) < 30 * 60);
SELECT $user_email as email;

SELECT 'redirect' AS component, 'login.sql' AS link
    WHERE $user_email IS NULL;

UPDATE user_sessions SET last_used = current_timestamp WHERE session_id = sqlpage.cookie('session_id')