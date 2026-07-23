-- ============================================================
-- Module 2 | Clip 2.4 — CASE and COALESCE
-- Demo file: m2_case_coalesce.sql
-- Dataset:   data/users.csv
-- ============================================================


-- Query 1 — CASE: classify users into reputation tiers
SELECT
    DisplayName,
    Reputation,
    CASE
        WHEN CAST(Reputation AS INTEGER) >= 10000 THEN 'Expert'
        WHEN CAST(Reputation AS INTEGER) >= 1000  THEN 'Established'
        WHEN CAST(Reputation AS INTEGER) >= 100   THEN 'Contributor'
        ELSE 'Newcomer'
    END AS reputation_tier
FROM 'data/users.csv'
WHERE Id > 0
ORDER BY CAST(Reputation AS INTEGER) DESC
LIMIT 12;
-- Expected top rows: Jon Skeet, VonC, Martijn Pieters — all 'Expert'


-- Query 2 — CASE with GROUP BY: count users per tier
SELECT
    CASE
        WHEN CAST(Reputation AS INTEGER) >= 10000 THEN 'Expert'
        WHEN CAST(Reputation AS INTEGER) >= 1000  THEN 'Established'
        WHEN CAST(Reputation AS INTEGER) >= 100   THEN 'Contributor'
        ELSE 'Newcomer'
    END AS reputation_tier,
    COUNT(*) AS user_count
FROM 'data/users.csv'
WHERE Id > 0
GROUP BY reputation_tier
ORDER BY user_count DESC;
-- Expected: Established=18569, Contributor=16476, Newcomer=8180, Expert=6761


-- Query 3 — COALESCE: replace NULL/empty AboutMe with a fallback
SELECT
    DisplayName,
    Reputation,
    COALESCE(NULLIF(AboutMe, ''), 'No bio provided') AS bio
FROM 'data/users.csv'
WHERE Id > 0
ORDER BY CAST(Reputation AS INTEGER) DESC
LIMIT 8;
-- Expected: Jon Skeet and Jeff Atwood -> 'No bio provided'
--           Jon Galloway -> '<p>Technical Evangelist...'


-- Query 4 — CASE and COALESCE together in one SELECT
SELECT
    DisplayName,
    CASE
        WHEN CAST(Reputation AS INTEGER) >= 10000 THEN 'Expert'
        WHEN CAST(Reputation AS INTEGER) >= 1000  THEN 'Established'
        WHEN CAST(Reputation AS INTEGER) >= 100   THEN 'Contributor'
        ELSE 'Newcomer'
    END                                           AS tier,
    COALESCE(NULLIF(AboutMe, ''), 'No bio provided') AS bio
FROM 'data/users.csv'
WHERE Id > 0
ORDER BY CAST(Reputation AS INTEGER) DESC
LIMIT 5;
-- Expected: top 5 by rep, each with tier label and cleaned bio
