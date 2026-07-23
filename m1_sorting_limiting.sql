-- ============================================================
-- Module 1 | Clip 1.3 — Sorting and Limiting Results
-- Demo file: m1_sorting_limiting.sql
-- Note: Queries in this clip use fictional slide tables
--       (history, employees) for concept illustration.
--       They are not runnable against the Stack Overflow CSVs.
-- ============================================================


-- Slide 8 — Sorting with ORDER BY (ASC / DESC)
-- history table: duck breed release dates
SELECT name, release_date
FROM history
ORDER BY release_date DESC;
-- Result (from slide):
--   Variegata  03/09/2026
--   Andium     09/16/2025
--   Eatoni     09/09/2024
--   SnowDuck   06/03/2024


-- Slide 9 — NULL sort order (NULLS FIRST / NULLS LAST)
-- employees table: manager_id is NULL for top-level employees
SELECT name, manager_id
FROM employees
ORDER BY manager_id
NULLS FIRST;
-- Result (from slide):
--   Ada    NULL
--   Priya  NULL
--   Marcus 1
--   Dana   2
--   Ren    2


-- Slide 11 — ORDER BY ALL (DuckDB extension)
-- Sorts by every column in the SELECT list, left to right
SELECT name, release_date
FROM history
ORDER BY ALL;


-- Slide 11 — ORDER BY ordinal position
-- Numbers refer to column position in the SELECT list
SELECT name, release_date
FROM history
ORDER BY 1, 2;


-- Slide 13 — Top-N query with LIMIT
SELECT name, hire_date
FROM employees
ORDER BY hire_date DESC
LIMIT 5;


-- Slide 13 — Pagination with LIMIT + OFFSET
-- OFFSET 3 skips the first 3 rows; LIMIT 3 returns the next 3 (page 2)
SELECT name, salary
FROM employees
ORDER BY salary DESC
LIMIT 3 OFFSET 3;


-- Slide 14 — FILTER clause on an aggregate (concept preview)
-- FILTER scopes an aggregate to a subset of rows
-- Full example covered in clip 1.5/1.6
SELECT
    sum(i)                          AS total,
    sum(i) FILTER (i % 2 = 0)      AS evens,
    sum(i) FILTER (i % 2 = 1)      AS odds
FROM generate_series(1, 10) tbl(i);
-- Expected: total=55, evens=30, odds=25
