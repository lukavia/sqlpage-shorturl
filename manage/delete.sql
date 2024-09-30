SELECT 'redirect' AS component, 'login.sql' AS link
    WHERE NOT EXISTS(SELECT * FROM user_sessions WHERE session_id = sqlpage.cookie('session_id'));

DELETE FROM urls WHERE path = $path
  RETURNING 'redirect' AS component, 'index.sql' AS link;
