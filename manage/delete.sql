SET user = sqlpage.run_sql('manage/_session.sql')->>0;

INSERT INTO history(action, by, path) VALUES('delete', $user->>'email', $path);
DELETE FROM urls WHERE path = $path
  RETURNING 'redirect' AS component, 'index.sql' AS link;
