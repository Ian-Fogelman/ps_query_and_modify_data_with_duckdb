-- ============================================================
-- Module 3 | Clip 3.3 — Loading Data with INSERT and COPY
-- Demo file: m3_insert_copy.sql
-- Dataset:   data/tags.csv
-- ============================================================


-- Query 1 — Create an empty staging table (WHERE 1=0 copies schema, no rows)
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
-- Expected: 0 rows — correct schema, empty container


-- Query 2 — INSERT INTO from a filtered query
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
-- Expected: 5 rows — javascript, php, html, css, c# (all > 500,000 posts)


-- Query 3 — INSERT OR REPLACE for upsert behavior
CREATE OR REPLACE TABLE tags_managed (
    Id      INTEGER PRIMARY KEY,
    TagName VARCHAR,
    Count   INTEGER
);

INSERT INTO tags_managed VALUES (1, 'javascript', 2479947);
INSERT INTO tags_managed VALUES (2, 'php',        1456271);

-- Simulate an update: javascript's count has changed
INSERT OR REPLACE INTO tags_managed VALUES (1, 'javascript', 2501000);

SELECT * FROM tags_managed ORDER BY Id;
-- Expected: javascript row replaced (Count=2501000), php row untouched


-- Query 4 — COPY FROM for bulk ingest
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
-- Expected: 1000 rows

SELECT TagName, Count
FROM tags_full
ORDER BY Count DESC
LIMIT 5;
-- Expected: javascript, php, html, css, c# — same top 5 as the filtered insert
