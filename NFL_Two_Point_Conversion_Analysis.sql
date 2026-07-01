--Q1. What is the total number of 2-point conversion attempts by play type?
SELECT 
    'Passing' AS play_type,
    COUNT("playId") AS total_attempts
FROM twopointpassrec

UNION ALL

SELECT 
    'Rushing' AS play_type,
    COUNT("playId") AS total_attempts
FROM twopointrush;


--Q2. What is the success rate for passing vs rushing 2-point conversions?
SELECT 
    'Passing' AS play_type,
    COUNT("playId") AS total_attempts,
    COUNT(CASE WHEN "twoPtPassConv" = 'good' THEN 1 END) AS successful_attempts,
    ROUND(
        COUNT(CASE WHEN "twoPtPassConv" = 'good' THEN 1 END) * 100.0 / COUNT("playId"),
        2
    ) AS success_rate_percent
FROM twopointpassrec

UNION ALL

SELECT 
    'Rushing' AS play_type,
    COUNT("playId") AS total_attempts,
    COUNT(CASE WHEN "twoPtRushResult" = 'good' THEN 1 END) AS successful_attempts,
    ROUND(
        COUNT(CASE WHEN "twoPtRushResult" = 'good' THEN 1 END) * 100.0 / COUNT("playId"),
        2
    ) AS success_rate_percent
FROM twopointrush;

--Q3. Which positions were targeted the most on 2-point conversion passes?
SELECT
    "twoPointRecPosition" AS targeted_position,
    COUNT("playId") AS total_targets
FROM twopointpassrec
WHERE "twoPointRecPosition" IS NOT NULL
GROUP BY "twoPointRecPosition"
ORDER BY total_targets DESC;

--Q4. Which positions had the highest success rate on 2-point conversion targets?
--Only includes positions with at least 10 targets
SELECT
    "twoPointRecPosition" AS targeted_position,
    COUNT("playId") AS total_targets,
    COUNT(CASE WHEN "twoPtPassConv" = 'good' THEN 1 END) AS successful_targets,
    ROUND(
        COUNT(CASE WHEN "twoPtPassConv" = 'good' THEN 1 END) * 100.0 / COUNT("playId"),
        2
    ) AS success_rate_percent
FROM twopointpassrec
WHERE "twoPointRecPosition" IS NOT NULL
GROUP BY "twoPointRecPosition"
HAVING COUNT("playId") >= 10
ORDER BY success_rate_percent DESC;

--Q5. Which rushers had the most 2-point conversion rushing attempts?
SELECT
    "twoPtRushPosition" AS rusher_position,
    COUNT("playId") AS rushing_attempts
FROM twopointrush
GROUP BY "twoPtRushPosition"
ORDER BY rushing_attempts DESC;

--Q6. Which rusher had the highest 2-point rushing conversion rate?
--Only includes positions with more than 5 rushes
SELECT
    "twoPtRushPosition" AS rusher_position,
    COUNT("playId") AS total_rush_attempts,
    COUNT(CASE WHEN "twoPtRushResult" = 'good' THEN 1 END) AS successful_rushes,
    ROUND(
        COUNT(CASE WHEN "twoPtRushResult" = 'good' THEN 1 END) * 100.0 / COUNT("playId"),
        2
    ) AS rushing_conversion_rate_percent
FROM twopointrush
GROUP BY "twoPtRushPosition"
HAVING COUNT("playId") >= 5
ORDER BY rushing_conversion_rate_percent DESC;

--Q7. Which players were involved in the most 2-point conversion attempts?
SELECT
    player_position,
    COUNT("playId") AS total_attempts_involved
FROM (
    -- Receivers
    SELECT
        "twoPointRecPosition" AS player_position
    FROM twopointpassrec
    WHERE "twoPointRecPosition" IS NOT NULL

    UNION ALL

    -- Rushers
    SELECT
        "twoPtRushPosition" AS player_position
    FROM twopointrush
) AS combined_players
GROUP BY player_position
HAVING COUNT("playId") > 10
ORDER BY total_attempts_involved DESC;