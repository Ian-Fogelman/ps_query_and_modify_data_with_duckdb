-- ============================================================
-- Module 2 | Clip 2.5 — Reusing Logic with CTEs and Views
-- Demo file: m2_ctes_views.sql
-- Dataset:   data/posts.csv, data/users.csv
-- ============================================================


-- Query 1 — The problem: nested subquery (hard to read)
SELECT
    u.DisplayName,
    u.Reputation,
    sub.question_count,
    sub.avg_score
FROM (
    SELECT
        OwnerUserId,
        COUNT(*)                              AS question_count,
        ROUND(AVG(CAST(Score AS DOUBLE)), 1)  AS avg_score
    FROM 'data/posts.csv'
    WHERE PostTypeId = '1'
    GROUP BY OwnerUserId
    ORDER BY question_count DESC
    LIMIT 5
) AS sub
INNER JOIN 'data/users.csv' AS u
    ON sub.OwnerUserId = u.Id;
-- Expected: Thomas Owens (46 q, avg 41.1), GateKiller (44 q, avg 99.0), etc.


-- Query 2 — Same logic rewritten as a CTE (readable top to bottom)
WITH top_askers AS (
    SELECT
        OwnerUserId,
        COUNT(*)                              AS question_count,
        ROUND(AVG(CAST(Score AS DOUBLE)), 1)  AS avg_score
    FROM 'data/posts.csv'
    WHERE PostTypeId = '1'
      AND OwnerUserId != ''
    GROUP BY OwnerUserId
    ORDER BY question_count DESC
    LIMIT 5
)
SELECT
    u.DisplayName,
    u.Reputation,
    t.question_count,
    t.avg_score
FROM top_askers AS t
INNER JOIN 'data/users.csv' AS u
    ON t.OwnerUserId = u.Id
ORDER BY t.question_count DESC;
-- Expected: identical result to Query 1, logic now reads top to bottom


-- Query 3 — Chained CTEs: two named steps in one WITH clause
WITH top_askers AS (
    SELECT
        OwnerUserId,
        COUNT(*)                              AS question_count,
        ROUND(AVG(CAST(Score AS DOUBLE)), 1)  AS avg_score
    FROM 'data/posts.csv'
    WHERE PostTypeId = '1'
      AND OwnerUserId != ''
    GROUP BY OwnerUserId
    ORDER BY question_count DESC
    LIMIT 10
),
ranked_askers AS (
    SELECT
        t.OwnerUserId,
        t.question_count,
        t.avg_score,
        u.DisplayName,
        u.Reputation
    FROM top_askers AS t
    INNER JOIN 'data/users.csv' AS u
        ON t.OwnerUserId = u.Id
)
SELECT *
FROM ranked_askers
ORDER BY avg_score DESC;
-- Expected: GateKiller tops by avg_score (99.0), Thomas Owens tops by question_count (46)


-- Query 4 — CREATE VIEW: save a query definition for reuse
CREATE OR REPLACE VIEW top_question_askers AS
SELECT
    u.DisplayName,
    u.Reputation,
    COUNT(p.Id)                            AS question_count,
    ROUND(AVG(CAST(p.Score AS DOUBLE)), 1) AS avg_score
FROM 'data/posts.csv' AS p
INNER JOIN 'data/users.csv' AS u
    ON p.OwnerUserId = u.Id
WHERE p.PostTypeId = '1'
GROUP BY u.DisplayName, u.Reputation
ORDER BY question_count DESC;


-- Query the view like a table
SELECT *
FROM top_question_askers
LIMIT 10;
-- Expected: Thomas Owens (46, 41.1), GateKiller (44, 99.0), Niyaz (42, 48.0), Guy (42, 24.6)
