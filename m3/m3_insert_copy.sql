-- Clip 3.3 — Loading Data with INSERT and COPY
-- Demo file: m3_insert_copy.sql
-- Dataset: data/tags.csv


-- Query 1 — Create a staging table (empty shell)
CREATE TABLE IF NOT EXISTS tags_staging AS
SELECT
    CAST(Id    AS INTEGER) AS Id,
    TagName,
    CAST(Count AS INTEGER) AS Count,
    ExcerptPostId,
    WikiPostId
FROM 'data/tags.csv'
WHERE 1 = 0;

SELECT COUNT(*) AS row_count FROM tags_staging;


-- Query 2 — INSERT INTO from a query
INSERT INTO tags_staging
SELECT
    CAST(Id    AS INTEGER),
    TagName,
    CAST(Count AS INTEGER),
    ExcerptPostId,
    WikiPostId
FROM 'data/tags.csv'
WHERE CAST(Count AS INTEGER) > 500000;

SELECT TagName, Count
FROM tags_staging
ORDER BY Count DESC;


-- Query 3 — INSERT OR REPLACE for upsert behavior
CREATE OR REPLACE TABLE tags_managed (
    Id      INTEGER PRIMARY KEY,
    TagName VARCHAR,
    Count   INTEGER
);

INSERT INTO tags_managed VALUES (1, 'javascript', 2479947);
INSERT INTO tags_managed VALUES (2, 'php',        1456271);

-- Now simulate an update: javascript's count has changed
INSERT OR REPLACE INTO tags_managed VALUES (1, 'javascript', 2501000);

SELECT * FROM tags_managed ORDER BY Id;


-- Query 4 — COPY FROM for bulk ingest
-- Start fresh
DROP TABLE IF EXISTS tags_full;

CREATE TABLE tags_full (
    Id            INTEGER,
    TagName       VARCHAR,
    Count         INTEGER,
    ExcerptPostId VARCHAR,
    WikiPostId    VARCHAR
);

COPY tags_full FROM 'data/tags.csv' (HEADER TRUE);

SELECT COUNT(*) AS total_tags FROM tags_full;

SELECT TagName, Count
FROM tags_full
ORDER BY Count DESC
LIMIT 5;
