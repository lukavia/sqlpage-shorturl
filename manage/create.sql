SELECT 'redirect' AS component, '/login.sql' AS link
    WHERE NOT EXISTS(SELECT * FROM user_sessions WHERE session_id = sqlpage.cookie('session_id'));

INSERT INTO urls(path, url) VALUES(:path,:url)
  RETURNING 'redirect' AS component, '/' AS link;