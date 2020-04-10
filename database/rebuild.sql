--rebuild articles_nice 
TRUNCATE articles_nice RESTART IDENTITY;

INSERT INTO articles_nice
	(SELECT * FROM articles 
	WHERE json_array_length(authors) > 1 AND json_array_length(authors) <= 10)
ON CONFLICT DO NOTHING;

--rebuild authors
TRUNCATE authors RESTART IDENTITY;

INSERT INTO authors
	(SELECT people->>'affiliation', people->>'last_name', people->>'first_name', people->>'full_name'
	FROM (SELECT json_array_elements(authors) as people 
		FROM articles_nice) as mau
	WHERE people->>'affiliation' <> '')
ON CONFLICT DO NOTHING;

UPDATE authors
SET affiliation = '["' || affiliation || '"]'
WHERE affiliation NOT LIKE('[%');

UPDATE authors 
SET affiliation = '["National Research Center \"Kurchatov Institute\", 123182 Moscow, Russia"]'
WHERE affiliation LIKE('%National%Kurchatov%');

--rebuild universities
TRUNCATE universities RESTART IDENTITY;

INSERT INTO universities
	SELECT json_array_elements(affiliation::json)::text
	FROM authors 
ON CONFLICT DO NOTHING;

--rebuild auth_uni
TRUNCATE auth_uni RESTART IDENTITY;

INSERT INTO auth_uni
	(SELECT author_id, aff_id AS mas
	FROM (SELECT author_id, json_array_elements(affiliation::json) as nice
		FROM authors) AS aaa LEFT JOIN universities ON ((aaa.nice)::text = universities.affiliation));
	
--rebuild art_auth
TRUNCATE art_auth RESTART IDENTITY;
INSERT INTO art_auth
	(SELECT recid, author_id
	FROM (SELECT recid, json_array_elements(authors) AS myau FROM articles_nice) AS lul
			LEFT JOIN authors ON (lul.myau->>'full_name' = authors.full_name)
	WHERE author_id IS NOT NULL);
	
--rebuild uni_ids
WITH help AS (SELECT auth_id, array_agg(uni_id) AS mas
	FROM auth_uni
	GROUP BY auth_id)
UPDATE art_auth
SET uni_ids = help.mas
FROM help
WHERE author_id = help.auth_id;