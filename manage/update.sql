SET user = sqlpage.run_sql('manage/_session.sql')->>0;

INSERT INTO history(action, by, path, url) VALUES('update', $user->>'email', $path, :url);
UPDATE urls SET url = :url WHERE path = $path
  RETURNING 'redirect' AS component, 'index.sql' AS link;