SET user = sqlpage.run_sql('manage/_session.sql')->>0;

SELECT 'shell' AS component, 'Short URL' AS title,
    (SELECT json_object("title", given_name, "image", picture) FROM user_sessions WHERE session_id = sqlpage.cookie('session_id')) AS menu_item,
    'logout' AS menu_item;

SELECT 'form' AS component,
    iIF($path is null, 'create.sql', 'update.sql?path=' || $path) AS action,
    iIF($path is null, 'Add', 'Update') || ' Short URL' AS validate,
    'primary' AS color,
    'pill' AS shape;
SELECT 'path' AS name,
    'Path' AS label,
    2 AS width, 
    TRUE AS required,
    $path AS value,
    iIF($path is null, false, true) AS disabled,
    '^[a-zA-Z0-9-]+$' AS pattern;
SELECT 'url' AS name,
    'URL' AS label,
    8 AS width,
    TRUE AS required,
    (SELECT url from urls WHERE path = $path) AS value,
    '^[Hh][Tt][Tt][Pp][Ss]?:\/\/(?:(?:[a-zA-Z\u00a1-\uffff0-9]+-?)*[a-zA-Z\u00a1-\uffff0-9]+)(?:\.(?:[a-zA-Z\u00a1-\uffff0-9]+-?)*[a-zA-Z\u00a1-\uffff0-9]+)*(?:\.(?:[a-zA-Z\u00a1-\uffff]{2,}))(?::\d{2,5})?(?:\/[^\s]*)?$' AS pattern;


SELECT 'table' AS component,
    TRUE AS search,
    TRUE AS sort,
    'No Short URLs' AS empty_description,
    'action' as markdown;
SELECT 
    sqlpage.protocol() || '://' || sqlpage.header('host') || RTRIM(sqlpage.path(),'manage/index.sql') || '/' || path AS path, 
    url,
    count as used,
    '[edit](?path=' || path || ') [delete](delete.sql?path=' || path || ')' as action
  FROM urls;