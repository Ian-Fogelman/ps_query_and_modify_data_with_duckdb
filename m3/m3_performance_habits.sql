-- ============================================================
-- Module 3 | Clip 3.6 — Performance and Correctness Habits
-- Demo file: m3_performance_habits.sql
-- Dataset:   data/users.csv, data/posts.csv
-- ============================================================


-- Query 1 — EXPLAIN: read the execution plan without running the query
EXPLAIN
SELECT DisplayName, CAST(Reputation AS INTEGER) AS Reputation
FROM 'data/users.csv'
WHERE CAST(Reputation AS INTEGER) > 50000
ORDER BY Reputation DESC;
-- Expected: plan tree showing SEQ_SCAN -> FILTER -> PROJECTION -> ORDER_BY (read bottom-up)


-- Query 2 — EXPLAIN ANALYZE: actual row counts and timing per node
EXPLAIN ANALYZE
SELECT DisplayName, CAST(Reputation AS INTEGER) AS Reputation
FROM 'data/users.csv'
WHERE CAST(Reputation AS INTEGER) > 50000
ORDER BY Reputation DESC;
-- Expected: SEQ_SCAN reads ~50000 rows; FILTER passes ~312; total time < 50ms


-- Query 3 — LIMIT habit: always cap rows when exploring a new dataset
SELECT *
FROM 'data/posts.csv'
LIMIT 10;
-- Expected: 10 rows back immediately — reveals column names, types, and nulls at a glance


-- Query 4 — Row count sanity check across all source files
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
-- Expected: votes/posts/comments/users/badges=50000 each; tags=1000


-- Query 5 — NULL check pattern: COUNT(*) vs COUNT(column) reveals missing values
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
-- Expected: 28451 questions; 548 missing owner; ~14609 no accepted answer; 0 missing title
