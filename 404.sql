UPDATE urls SET count = count + 1 
  WHERE '/' || path || '/' = sqlpage.path()
RETURNING 'redirect' AS component,
  url AS link
;

SELECT 'status_code' AS component, 404 AS status;