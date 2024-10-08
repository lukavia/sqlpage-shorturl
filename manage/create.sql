SELECT 'dynamic' AS component,
    sqlpage.run_sql('manage/_session.sql') AS properties;

INSERT INTO urls(path, url) VALUES(:path,:url)
  RETURNING 'redirect' AS component, 'index.sql' AS link;