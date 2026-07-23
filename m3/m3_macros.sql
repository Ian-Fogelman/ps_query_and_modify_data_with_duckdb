-- ============================================================
-- Module 3 | Clip 3.2 — Scalar and Table Macros
-- Demo file: m3_macros.sql
-- Dataset:   data/users.csv, data/posts.csv
-- ============================================================


-- Query 1 — CREATE OR REPLACE MACRO (scalar): reputation tier classifier
CREATE OR REPLACE MACRO reputation_tier(rep) AS
    CASE
        WHEN rep >= 100000 THEN 'Platinum'
        WHEN rep >= 10000  THEN 'Gold'
        WHEN rep >= 1000   THEN 'Silver'
        ELSE                    'Bronze'
    END;


-- Query 2 — Call the scalar macro in a SELECT
SELECT
    DisplayName,
    CAST(Reputation AS INTEGER)                      AS Reputation,
    reputation_tier(CAST(Reputation AS INTEGER))     AS Tier
FROM 'data/users.csv'
WHERE CAST(Id AS INTEGER) > 0
ORDER BY Reputation DESC
LIMIT 8;
-- Expected: top 8 users all in Platinum tier (rep >= 100,000)


-- Query 3 — Aggregate by tier using the macro
SELECT
    reputation_tier(CAST(Reputation AS INTEGER)) AS Tier,
    COUNT(*)                                      AS UserCount
FROM 'data/users.csv'
WHERE CAST(Id AS INTEGER) > 0
GROUP BY Tier
ORDER BY UserCount DESC;
-- Expected: Bronze=28341, Silver=14872, Gold=5903, Platinum=884


-- Query 4 — CREATE OR REPLACE MACRO (table macro): top N questions
CREATE OR REPLACE MACRO top_questions(n) AS TABLE
    SELECT
        p.Id                              AS PostId,
        p.Title,
        CAST(p.Score AS INTEGER)          AS Score,
        CAST(p.ViewCount AS INTEGER)      AS ViewCount,
        u.DisplayName                     AS Author
    FROM 'data/posts.csv' AS p
    LEFT JOIN 'data/users.csv' AS u
        ON p.OwnerUserId = u.Id
    WHERE p.PostTypeId = '1'
      AND p.Title IS NOT NULL
    ORDER BY CAST(p.Score AS INTEGER) DESC
    LIMIT n;


-- Query 5 — Call the table macro with n=5
SELECT *
FROM top_questions(5);
-- Expected: 5 rows — top question is "Why is processing a sorted array faster..." Score=22656


-- Query 6 — Call the table macro with n=3
SELECT *
FROM top_questions(3);
-- Expected: same top 3 rows as above, different result set size
