SELECT 'dynamic' AS component,
    sqlpage.run_sql('manage/_session.sql') AS properties;

INSERT INTO history(action, by, path, url) VALUES('create', (SELECT email FROM user_sessions WHERE session_id = sqlpage.cookie('session_id')), :path, :url);
INSERT INTO urls(path, url) VALUES(:path, :url)
  RETURNING 'redirect' AS component, 'index.sql' AS link;