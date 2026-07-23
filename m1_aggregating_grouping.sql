-- ============================================================
-- Module 1 | Clips 1.5 & 1.6 — Aggregating, Grouping, and Filtering Groups
-- Demo file: m1_aggregating_grouping.sql
-- Dataset:   data/posts.csv, data/badges.csv
-- ============================================================


-- Query 1 — COUNT(*) vs COUNT(column): the NULL distinction
SELECT
    COUNT(*)                AS total_questions,
    COUNT(AcceptedAnswerId) AS questions_with_accepted_answer
FROM 'data/posts.csv'
WHERE PostTypeId = '1';
-- Expected: total_questions=9792, questions_with_accepted_answer=7927
-- Gap of 1,865 = questions where AcceptedAnswerId is NULL


-- Query 2 — SUM, AVG, MIN, MAX on question scores
SELECT
    SUM(CAST(Score AS INTEGER))           AS total_score,
    ROUND(AVG(CAST(Score AS DOUBLE)), 2)  AS avg_score,
    MIN(CAST(Score AS INTEGER))           AS lowest_score,
    MAX(CAST(Score AS INTEGER))           AS highest_score
FROM 'data/posts.csv'
WHERE PostTypeId = '1';
-- Expected: total=635712, avg=64.92, min=-8, max=9225


-- Query 3 — COUNT DISTINCT
SELECT
    COUNT(*)               AS total_badge_rows,
    COUNT(DISTINCT Name)   AS distinct_badge_names,
    COUNT(DISTINCT UserId) AS users_with_any_badge
FROM 'data/badges.csv';
-- Expected: total=50000, distinct names=26, distinct users=10283


-- Query 4 — GROUP BY with multiple aggregates
SELECT
    Name,
    COUNT(*)               AS times_awarded,
    COUNT(DISTINCT UserId) AS unique_recipients
FROM 'data/badges.csv'
GROUP BY Name
ORDER BY times_awarded DESC;
-- Expected: 26 rows; Teacher leads at 8,215


-- Query 5 — HAVING: filter groups after aggregation
SELECT
    Name,
    COUNT(*) AS times_awarded
FROM 'data/badges.csv'
GROUP BY Name
HAVING COUNT(*) > 3000
ORDER BY times_awarded DESC;
-- Expected: 8 badge names — Teacher (8215) through Critic (3119)


-- Query 6 — WHERE and HAVING together
SELECT
    AnswerCount,
    COUNT(*) AS question_count
FROM 'data/posts.csv'
WHERE PostTypeId = '1'
GROUP BY AnswerCount
HAVING COUNT(*) > 500
ORDER BY CAST(AnswerCount AS INTEGER);
-- Expected: 7 rows — AnswerCount 2-8, highest bucket is 3 answers (1,375 questions)
