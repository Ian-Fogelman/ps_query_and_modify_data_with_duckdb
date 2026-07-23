-- ============================================================
-- Module 1 | Clip 1.2 — Filtering Rows with WHERE
-- Demo file: m1_filtering_where.sql
-- Dataset:   data/users.csv, data/posts.csv
-- ============================================================


-- Query 1 — Basic equality
SELECT Id, DisplayName, Reputation
FROM 'data/users.csv'
WHERE Id = 1;
-- Expected: 1 row — Jeff Atwood, Rep 63031


-- Query 2 — Greater-than comparison
SELECT DisplayName, Reputation
FROM 'data/users.csv'
WHERE Reputation > 100000
ORDER BY Reputation DESC;
-- Expected: small group — Jon Skeet tops at 1,389,256


-- Query 3 — AND (both conditions must be true)
SELECT DisplayName, Reputation, UpVotes
FROM 'data/users.csv'
WHERE Reputation > 50000
  AND UpVotes > 2000;
-- Expected: tighter list than Query 2 — both conditions must hold


-- Query 4 — OR (either condition is enough)
SELECT DisplayName, Reputation
FROM 'data/users.csv'
WHERE DisplayName = 'Jon Skeet'
   OR DisplayName = 'Jeff Atwood';
-- Expected: exactly 2 rows


-- Query 5 — IS NULL
SELECT DisplayName, Reputation
FROM 'data/users.csv'
WHERE AboutMe IS NULL
ORDER BY Reputation DESC
LIMIT 10;
-- Expected: top 10 high-rep users with no AboutMe (33,231 total have no bio)


-- Query 6 — IS NOT NULL combined with numeric filter
SELECT DisplayName, Reputation, UpVotes
FROM 'data/users.csv'
WHERE AboutMe IS NOT NULL
  AND Reputation > 10000
ORDER BY Reputation DESC
LIMIT 10;
-- Expected: engaged high-rep users who filled out their profile


-- Query 7 — Multi-condition filter on posts
SELECT Title, Score, AnswerCount
FROM 'data/posts.csv'
WHERE PostTypeId = 1
  AND AcceptedAnswerId IS NULL
  AND Score > 100
ORDER BY Score DESC
LIMIT 10;
-- Expected: 1,865 questions qualify; top row — "What and where are the stack and heap?" Score=9225
