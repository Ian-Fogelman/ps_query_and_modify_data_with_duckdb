-- ============================================================
-- Module 1 | Clip 1.4 — Computing New Columns
-- Demo file: m1_computing_columns.sql
-- Dataset:   data/users.csv
-- ============================================================


-- Query 1 — Arithmetic: subtraction (net votes)
SELECT
    DisplayName,
    UpVotes,
    DownVotes,
    UpVotes - DownVotes AS net_votes
FROM 'data/users.csv'
WHERE Id > 0
ORDER BY net_votes DESC
LIMIT 10;
-- Expected top row: VonC — UpVotes=68498, DownVotes=405, net_votes=68093


-- Query 2 — Arithmetic: percentage with type casting and NULLIF guard
SELECT
    DisplayName,
    UpVotes,
    DownVotes,
    ROUND(UpVotes * 100.0 / NULLIF(UpVotes + DownVotes, 0), 1) AS upvote_pct
FROM 'data/users.csv'
WHERE Id > 0
  AND UpVotes + DownVotes > 50
ORDER BY upvote_pct DESC
LIMIT 10;
-- Expected top rows: Jarrod Dixon 98.8%, C. K. Young 96.1%, Jon Galloway 95.9%


-- Query 3 — String concatenation: building a display label
SELECT
    DisplayName || ' (Rep: ' || Reputation || ')' AS user_label
FROM 'data/users.csv'
WHERE Id > 0
ORDER BY CAST(Reputation AS INTEGER) DESC
LIMIT 10;
-- Expected top row: "Jon Skeet (Rep: 1389256)"


-- Query 4 — String concatenation: building a URL
SELECT
    DisplayName,
    'https://stackoverflow.com/users/' || Id AS profile_url
FROM 'data/users.csv'
WHERE Id > 0
ORDER BY CAST(Reputation AS INTEGER) DESC
LIMIT 5;
-- Expected: navigable Stack Overflow profile URLs per user


-- Query 5 — Multiple computed columns together
SELECT
    DisplayName || ' (#' || Id || ')' AS user_label,
    UpVotes - DownVotes               AS net_votes,
    ROUND(UpVotes * 100.0 / NULLIF(UpVotes + DownVotes, 0), 1) AS upvote_pct
FROM 'data/users.csv'
WHERE Id > 0
  AND UpVotes + DownVotes > 100
ORDER BY net_votes DESC
LIMIT 10;
-- Expected top row: "VonC (#6309)", net_votes=68093, upvote_pct=99.4
