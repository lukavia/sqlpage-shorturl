SELECT 'redirect' AS component,
  url AS link
  FROM urls WHERE '/' || path || '/' = sqlpage.path();

SELECT 'status_code' AS component, 404 AS status;