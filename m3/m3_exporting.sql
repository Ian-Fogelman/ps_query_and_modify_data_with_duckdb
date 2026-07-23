-- ============================================================
-- Module 3 | Clip 3.5 — Exporting Results
-- Demo file: m3_exporting.sql
-- Dataset:   data/users.csv, data/posts.csv, data/tags.csv
-- ============================================================


-- Query 1 — COPY TO CSV
COPY (
    SELECT
        CAST(Id         AS INTEGER) AS Id,
        DisplayName,
        CAST(Reputation AS INTEGER) AS Reputation,
        CAST(Views      AS INTEGER) AS ProfileViews,
        LastAccessDate
    FROM 'data/users.csv'
    WHERE CAST(Id         AS INTEGER) > 0
      AND CAST(Reputation AS INTEGER) >= 10000
    ORDER BY Reputation DESC
    LIMIT 100
)
TO 'output/top_users.csv' (FORMAT CSV, HEADER TRUE);

SELECT * FROM 'output/top_users.csv' LIMIT 5;
-- Expected: Jon Skeet tops list — Rep 1389256, ProfileViews 176163


-- Query 2 — COPY TO Parquet
COPY (
    SELECT
        CAST(p.Id        AS INTEGER)  AS PostId,
        p.Title,
        CAST(p.Score     AS INTEGER)  AS Score,
        CAST(p.ViewCount AS INTEGER)  AS ViewCount,
        p.CreationDate,
        p.Tags
    FROM 'data/posts.csv' AS p
    WHERE p.PostTypeId = '1'
      AND p.Title IS NOT NULL
    ORDER BY Score DESC
)
TO 'output/questions.parquet' (FORMAT PARQUET);

SELECT PostId, Title, Score, ViewCount
FROM 'output/questions.parquet'
LIMIT 5;
-- Expected: Score and ViewCount read back as integers (schema preserved in file)


-- Query 3 — COPY TO JSON
COPY (
    SELECT
        TagName,
        CAST(Count AS INTEGER) AS PostCount
    FROM 'data/tags.csv'
    ORDER BY CAST(Count AS INTEGER) DESC
    LIMIT 20
)
TO 'output/top_tags.json' (FORMAT JSON);

SELECT * FROM 'output/top_tags.json' LIMIT 5;
-- Expected: javascript=2479947, php=1456271, html=1167742, css=787138, c#=632905
