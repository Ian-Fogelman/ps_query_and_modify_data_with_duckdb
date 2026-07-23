-- ============================================================
-- Module 2 | Clip 2.1 — Joining Datasets
-- Demo file: m2_joining_datasets.sql
-- Dataset:   data/posts.csv, data/users.csv
-- ============================================================


-- ── Slide examples (illustrative — fictional orders/customers tables) ──

-- Slide 4 — INNER JOIN syntax pattern
-- SELECT
--     o.order_id,
--     c.customer_name
-- FROM   orders o
-- INNER JOIN customers c
--     ON o.customer_id = c.customer_id;

-- Slide 7 — LEFT JOIN syntax pattern
-- SELECT
--     o.order_id,
--     c.customer_name
-- FROM   orders o
-- LEFT JOIN customers c
--     ON o.customer_id = c.customer_id;


-- ── Runnable demo queries against Stack Overflow data ──

-- Query 1 — INNER JOIN: posts + users (matched questions only)
SELECT
    p.Id          AS post_id,
    p.Title,
    p.Score,
    u.DisplayName,
    u.Reputation
FROM 'data/posts.csv'   AS p
INNER JOIN 'data/users.csv' AS u
    ON p.OwnerUserId = u.Id
WHERE p.PostTypeId = '1'
ORDER BY p.Score DESC
LIMIT 10;
-- Expected: 8,898 questions survive the join (894 silently dropped)
-- Top rows include high-scoring questions with known authors


-- Query 2 — LEFT JOIN: keep all questions (matched + unmatched)
SELECT
    p.Id          AS post_id,
    p.Title,
    p.Score,
    u.DisplayName,
    u.Reputation
FROM 'data/posts.csv'   AS p
LEFT JOIN 'data/users.csv' AS u
    ON p.OwnerUserId = u.Id
WHERE p.PostTypeId = '1'
ORDER BY u.DisplayName NULLS LAST
LIMIT 15;
-- Expected: all 9,792 questions returned
-- Unmatched rows (894) show NULL for DisplayName and Reputation
