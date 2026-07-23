-- ============================================================
-- Module 2 | Clip 2.3 — String and Date Functions
-- Demo file: m2_string_date_functions.sql
-- Dataset:   data/users.csv, data/posts.csv
-- ============================================================


-- ── Slide reference examples (runnable standalone) ──────────

-- Slide 11 — String function reference
SELECT
    UPPER('hello')               AS upper_example,   -- 'HELLO'
    LOWER('HELLO')               AS lower_example,   -- 'hello'
    TRIM('  hi  ')               AS trim_example,    -- 'hi'
    SUBSTR('DuckDB', 1, 4)       AS substr_example,  -- 'Duck'
    STRING_SPLIT('a,b,c', ',')   AS split_example;   -- [a, b, c]


-- Slide 13 — Date function reference
SELECT
    DATE_TRUNC('month', DATE '2026-07-15')                     AS date_trunc_example,  -- 2026-07-01
    DATE_DIFF('day', DATE '2026-01-01', DATE '2026-07-07')     AS date_diff_example,   -- 187
    DATE_PART('year', DATE '2026-07-07')                       AS date_part_example,   -- 2026
    DATE '2026-07-07' + INTERVAL 30 DAY                        AS date_add_example,    -- 2026-08-06
    STRFTIME(DATE '2026-07-07', '%B %d, %Y')                   AS strftime_example;    -- 'July 07, 2026'


-- ── Demo queries against Stack Overflow data ─────────────────

-- Query 1 — String functions on DisplayName
SELECT
    DisplayName,
    UPPER(DisplayName)          AS name_upper,
    LOWER(DisplayName)          AS name_lower,
    SUBSTR(DisplayName, 1, 4)   AS first_four_chars,
    LENGTH(DisplayName)         AS name_length
FROM 'data/users.csv'
WHERE Id > 0
LIMIT 8;
-- Expected: Jeff Atwood -> JEFF ATWOOD / jeff atwood / Jeff / 11


-- Query 2 — Case-insensitive search with LOWER + LIKE
SELECT Id, DisplayName, Reputation
FROM 'data/users.csv'
WHERE LOWER(DisplayName) LIKE '%atwood%'
  AND Id > 0;
-- Expected: 1 row — Jeff Atwood, Rep 63031


-- Query 3 — Date functions on CreationDate
SELECT
    Id,
    Title,
    CreationDate,
    DATE_TRUNC('year', CreationDate::DATE)         AS creation_year,
    DATE_PART('month', CreationDate::DATE)         AS creation_month,
    DATE_DIFF('day', CreationDate::DATE, CURRENT_DATE) AS days_since_posted
FROM 'data/posts.csv'
WHERE PostTypeId = '1'
ORDER BY CreationDate
LIMIT 5;
-- Expected: oldest posts from 2008-07-31, days_since_posted ~6,500+


-- Query 4 — GROUP BY with DATE_TRUNC: questions per year
SELECT
    DATE_TRUNC('year', CreationDate::DATE) AS year,
    COUNT(*)                               AS questions_posted
FROM 'data/posts.csv'
WHERE PostTypeId = '1'
GROUP BY year
ORDER BY year;
-- Expected: 2008=1349, 2009=2634 (peak year), 2010=2117, ...
