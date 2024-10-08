SELECT 'dynamic' AS component,
    sqlpage.run_sql('manage/_session.sql') AS properties;

INSERT INTO history(action, by, path, url) VALUES('update', (SELECT email FROM user_sessions WHERE session_id = sqlpage.cookie('session_id')), $path, :url);
UPDATE urls SET url = :url WHERE path = $path
  RETURNING 'redirect' AS component, 'index.sql' AS link;