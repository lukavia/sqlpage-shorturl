SET user = sqlpage.run_sql('manage/_session.sql')->>0;

INSERT INTO history(action, by, path, url) VALUES('create', $user->>'email', :path, :url);
INSERT INTO urls(path, url) VALUES(:path, :url)
  RETURNING 'redirect' AS component, 'index.sql' AS link;