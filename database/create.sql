CREATE TABLE IF NOT EXISTS articles_json
(
    "json" json
);

CREATE TABLE IF NOT EXISTS articles
(
    recid integer PRIMARY KEY,
    reference json,
    title text,
    publication_date integer,
    authors json
);

CREATE TABLE IF NOT EXISTS articles_nice
(
    recid integer,
    reference json,
    title text,
    publication_date integer,
    authors json
);

CREATE TABLE IF NOT EXISTS authors
(
    affiliation text,
    last_name text,
    first_name text,
    full_name text UNIQUE,
	author_id serial PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS universities
(
    affiliation text,
    aff_id serial PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS art_auth
(
    article_id integer,
    author_id integer,
    uni_ids integer[]
);

CREATE TABLE IF NOT EXISTS auth_uni
(
    auth_id integer,
    uni_id integer
);

CREATE TABLE IF NOT EXISTS collab
(
    uni1 integer,
    uni2 integer,
    num integer
)