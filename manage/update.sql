SELECT 'redirect' AS component, 'login.sql' AS link
    WHERE NOT EXISTS(SELECT * FROM user_sessions WHERE session_id = sqlpage.cookie('session_id'));

UPDATE urls SET url = :url WHERE path = $path
  RETURNING 'redirect' AS component, 'index.sql' AS link;