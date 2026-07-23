-- ============================================================
-- Clip 2.2 — Troubleshooting Joins
-- Demo file: troubleshooting_joins.sql
-- Dataset:   data/posts.csv, data/users.csv, data/badges.csv
-- ============================================================


-- ============================================================
-- PROBLEM 1: Silent row loss from INNER JOIN
-- ============================================================

-- Step 1a: Baseline — how many questions exist before any join?
SELECT COUNT(*) AS total_questions
FROM 'data/posts.csv'
WHERE PostTypeId = '1';
-- Expected: 9792


-- Step 1b: How many survive an INNER JOIN to users?
SELECT COUNT(*) AS matched_questions
FROM 'data/posts.csv'   AS p
INNER JOIN 'data/users.csv' AS u
    ON p.OwnerUserId = u.Id
WHERE p.PostTypeId = '1';
-- Expected: 8898
-- Gap: 894 questions silently dropped (no matching user)


-- ============================================================
-- PROBLEM 2: Duplicate rows / fan-out from one-to-many join
-- ============================================================

-- User mmcdole (Id=2635) has 1 question and 15 badges.
-- Joining posts to badges produces 15 rows for that one question.
SELECT
    p.Id        AS post_id,
    p.Title,
    b.Name      AS badge_name
FROM 'data/posts.csv'   AS p
INNER JOIN 'data/badges.csv' AS b
    ON p.OwnerUserId = b.UserId
WHERE p.OwnerUserId = '2635'
  AND p.PostTypeId  = '1';
-- Expected: 15 rows — same post_id repeated once per badge


-- Fix option: aggregate badges before joining to avoid fan-out
SELECT
    p.Id                    AS post_id,
    p.Title,
    p.Score,
    badge_summary.badge_count,
    badge_summary.badge_names
FROM 'data/posts.csv' AS p
INNER JOIN (
    SELECT
        UserId,
        COUNT(*)                        AS badge_count,
        STRING_AGG(Name, ', ')          AS badge_names
    FROM 'data/badges.csv'
    GROUP BY UserId
) AS badge_summary
    ON p.OwnerUserId = badge_summary.UserId
WHERE p.OwnerUserId = '2635'
  AND p.PostTypeId  = '1';
-- Expected: 1 row — fan-out eliminated by pre-aggregating badges


-- ============================================================
-- PROBLEM 3: Unexpected NULLs after LEFT JOIN
-- ============================================================

-- Step 3a: Count matched vs unmatched questions after LEFT JOIN
SELECT
    COUNT(*) FILTER (WHERE u.Id IS NULL)     AS unmatched_questions,
    COUNT(*) FILTER (WHERE u.Id IS NOT NULL) AS matched_questions
FROM 'data/posts.csv'   AS p
LEFT JOIN 'data/users.csv' AS u
    ON p.OwnerUserId = u.Id
WHERE p.PostTypeId = '1';
-- Expected: unmatched=894, matched=8898


-- Step 3b: Inspect a sample of the unmatched questions
SELECT
    p.Id,
    p.Title,
    p.OwnerUserId,
    u.DisplayName
FROM 'data/posts.csv'   AS p
LEFT JOIN 'data/users.csv' AS u
    ON p.OwnerUserId = u.Id
WHERE p.PostTypeId = '1'
  AND u.Id IS NULL
LIMIT 5;
-- Expected: DisplayName is NULL for all rows
-- OwnerUserId values exist but those users are not in the 50k user sample
