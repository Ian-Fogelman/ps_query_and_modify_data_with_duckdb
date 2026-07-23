-- Clip 3.6 — Performance and Correctness Habits
-- Demo file: m3_performance_habits.sql
-- Dataset: data/users.csv, data/posts.csv


-- Query 1 — EXPLAIN: reading the plan
EXPLAIN
SELECT DisplayName, CAST(Reputation AS INTEGER) AS Reputation
FROM 'data/users.csv'
WHERE CAST(Reputation AS INTEGER) > 50000
ORDER BY Reputation DESC;


-- Query 2 — EXPLAIN ANALYZE: actual vs. estimated
EXPLAIN ANALYZE
SELECT DisplayName, CAST(Reputation AS INTEGER) AS Reputation
FROM 'data/users.csv'
WHERE CAST(Reputation AS INTEGER) > 50000
ORDER BY Reputation DESC;


-- Query 3 — The LIMIT habit during exploration
-- Good habit: add LIMIT while exploring
SELECT *
FROM 'data/posts.csv'
LIMIT 10;


-- Query 4 — Row count sanity checks
SELECT 'users'    AS source, COUNT(*) AS row_count FROM 'data/users.csv'
UNION ALL
SELECT 'posts'    AS source, COUNT(*) AS row_count FROM 'data/posts.csv'
UNION ALL
SELECT 'tags'     AS source, COUNT(*) AS row_count FROM 'data/tags.csv'
UNION ALL
SELECT 'badges'   AS source, COUNT(*) AS row_count FROM 'data/badges.csv'
UNION ALL
SELECT 'comments' AS source, COUNT(*) AS row_count FROM 'data/comments.csv'
UNION ALL
SELECT 'votes'    AS source, COUNT(*) AS row_count FROM 'data/votes.csv'
ORDER BY row_count DESC;


-- Query 5 — NULL check pattern
SELECT
    COUNT(*)                           AS total_rows,
    COUNT(OwnerUserId)                 AS has_owner,
    COUNT(*) - COUNT(OwnerUserId)      AS missing_owner,
    COUNT(AcceptedAnswerId)            AS has_accepted_answer,
    COUNT(*) - COUNT(AcceptedAnswerId) AS no_accepted_answer,
    COUNT(Title)                       AS has_title,
    COUNT(*) - COUNT(Title)            AS missing_title
FROM 'data/posts.csv'
WHERE PostTypeId = '1';
