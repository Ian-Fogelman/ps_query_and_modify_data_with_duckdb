-- Clip 3.4 — Managing Views
-- Demo file: m3_views.sql
-- Dataset: data/users.csv, data/posts.csv


-- Query 1 — CREATE OR REPLACE VIEW
CREATE OR REPLACE VIEW active_users AS
SELECT
    CAST(Id         AS INTEGER) AS Id,
    DisplayName,
    CAST(Reputation AS INTEGER) AS Reputation,
    CAST(Views      AS INTEGER) AS ProfileViews,
    LastAccessDate
FROM 'data/users.csv'
WHERE CAST(Id          AS INTEGER) > 0
  AND CAST(Reputation  AS INTEGER) >= 100
  AND LastAccessDate >= '2021-01-01';

SELECT DisplayName, Reputation, LastAccessDate
FROM active_users
ORDER BY Reputation DESC
LIMIT 5;


-- Query 2 — Query the view with additional filters
SELECT
    COUNT(*)                        AS active_user_count,
    ROUND(AVG(Reputation), 0)       AS avg_reputation,
    MAX(Reputation)                 AS max_reputation
FROM active_users;


-- Query 3 — Use the view in a JOIN
SELECT
    u.DisplayName,
    u.Reputation,
    COUNT(p.Id)                                    AS question_count,
    ROUND(AVG(CAST(p.Score AS DOUBLE)), 1)         AS avg_score
FROM active_users AS u
INNER JOIN 'data/posts.csv' AS p
    ON CAST(p.OwnerUserId AS INTEGER) = u.Id
WHERE p.PostTypeId = '1'
GROUP BY u.DisplayName, u.Reputation
ORDER BY avg_score DESC
LIMIT 5;


-- Query 4 — DROP VIEW IF EXISTS
DROP VIEW IF EXISTS active_users;

-- Confirm it's gone
SELECT *
FROM active_users
LIMIT 1;
