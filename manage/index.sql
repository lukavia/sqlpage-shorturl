SET user_email = (SELECT email FROM user_sessions WHERE session_id = sqlpage.cookie('session_id'));

SELECT 'redirect' AS component, 'login.sql' AS link
    WHERE NOT EXISTS(SELECT * FROM user_sessions WHERE session_id = sqlpage.cookie('session_id'));

SELECT 'shell' AS component, 'Short URL' AS title,
    (SELECT json_object("title", given_name, "image", picture) FROM user_sessions WHERE session_id = sqlpage.cookie('session_id')) AS menu_item,
    (CASE WHEN $user_email IS NULL THEN 'login' ELSE 'logout' END) AS menu_item;

SELECT 'form' AS component,
    'create.sql' AS action,
    'Add Short URL' AS validate,
    'primary' AS color,
    'pill' AS shape;
SELECT 'path' AS name,
    'Path' AS label,
    2 AS width, 
    TRUE AS required,
    '^[a-zA-Z0-9-]+$' AS pattern;
SELECT 'url' AS name,
    'URL' AS label,
    8 AS width,
    TRUE AS required,
    '^[Hh][Tt][Tt][Pp][Ss]?:\/\/(?:(?:[a-zA-Z\u00a1-\uffff0-9]+-?)*[a-zA-Z\u00a1-\uffff0-9]+)(?:\.(?:[a-zA-Z\u00a1-\uffff0-9]+-?)*[a-zA-Z\u00a1-\uffff0-9]+)*(?:\.(?:[a-zA-Z\u00a1-\uffff]{2,}))(?::\d{2,5})?(?:\/[^\s]*)?$' AS pattern;


SELECT 'table' AS component,
    TRUE AS search,
    TRUE AS sort,
    'No Short URLs' AS empty_description,
    'action' as markdown;
SELECT 
    sqlpage.protocol() || '://' || sqlpage.header('host') || RTRIM(sqlpage.path(),'manage/index.sql') || '/' || path AS path, 
    url,
    '[delete](delete.sql?path=' || path || ')' as action
  FROM urls;