SELECT 'dynamic' AS component,
    sqlpage.run_sql('manage/_session.sql') AS properties;

DELETE FROM urls WHERE path = $path
  RETURNING 'redirect' AS component, 'index.sql' AS link;
