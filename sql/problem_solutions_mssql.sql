/*==============================================================
1. Users who did not login in the past 5 months
Assumption: Current date = '2024-06-28'
Return: user_name
==============================================================*/

SELECT u.user_name
FROM users AS u
WHERE NOT EXISTS (
    SELECT 1
    FROM logins AS l
    WHERE l.user_id = u.user_id
      AND l.login_timestamp >= DATEADD(MONTH, -5, '2024-06-28')
);



/*==============================================================
2. Quarterly analysis:
   Number of users and sessions per quarter
Return:
    quarter_first_day,
    user_cnt,
    session_cnt
Order: newest quarter to oldest
==============================================================*/

SELECT
    DATEADD(
        QUARTER,
        DATEDIFF(QUARTER, 0, login_timestamp),
        0
    ) AS quarter_first_day,
    COUNT(DISTINCT user_id) AS user_cnt,
    COUNT(*) AS session_cnt
FROM logins
GROUP BY DATEADD(
             QUARTER,
             DATEDIFF(QUARTER, 0, login_timestamp),
             0
         )
ORDER BY quarter_first_day DESC;



/*==============================================================
3. Users who logged in during January 2024
   but not in November 2023
Return: user_id
==============================================================*/

SELECT DISTINCT l.user_id
FROM logins AS l
WHERE l.login_timestamp >= '2024-01-01'
  AND l.login_timestamp < '2024-02-01'
  AND NOT EXISTS (
      SELECT 1
      FROM logins AS n
      WHERE n.user_id = l.user_id
        AND n.login_timestamp >= '2023-11-01'
        AND n.login_timestamp < '2023-12-01'
  );



/*==============================================================
4. Quarterly session analysis with percentage change
Return:
    quarter_first_day,
    session_cnt,
    prev_session_cnt,
    session_pct_change
==============================================================*/

WITH cte_quarter_data AS (
    SELECT
        DATEADD(
            QUARTER,
            DATEDIFF(QUARTER, 0, login_timestamp),
            0
        ) AS quarter_first_day,
        COUNT(DISTINCT user_id) AS user_cnt,
        COUNT(*) AS session_cnt
    FROM logins
    GROUP BY DATEADD(
                 QUARTER,
                 DATEDIFF(QUARTER, 0, login_timestamp),
                 0
             )
)

SELECT
    quarter_first_day,
    user_cnt,
    session_cnt,
    LAG(session_cnt) OVER (
        ORDER BY quarter_first_day
    ) AS prev_session_cnt,
    ROUND(
        (
            (session_cnt - LAG(session_cnt) OVER (
                ORDER BY quarter_first_day
            )) * 100.0
        ) /
        NULLIF(
            LAG(session_cnt) OVER (
                ORDER BY quarter_first_day
            ),
            0
        ),
        2
    ) AS session_pct_change
FROM cte_quarter_data
ORDER BY quarter_first_day DESC;



/*==============================================================
5. User with the highest session score for each day
Return:
    login_date,
    user_name,
    score
==============================================================*/

WITH cte_session_score AS (
    SELECT
        user_id,
        CAST(login_timestamp AS DATE) AS login_date,
        SUM(session_score) AS score
    FROM logins
    GROUP BY
        user_id,
        CAST(login_timestamp AS DATE)
),
cte_user_rank AS (
    SELECT
        user_id,
        login_date,
        score,
        RANK() OVER (
            PARTITION BY login_date
            ORDER BY score DESC
        ) AS score_rank
    FROM cte_session_score
)

SELECT
    r.login_date,
    u.user_name,
    r.score
FROM cte_user_rank AS r
INNER JOIN users AS u
    ON r.user_id = u.user_id
WHERE r.score_rank = 1
ORDER BY r.login_date;



/*==============================================================
6. Users who logged in every single day
   since their first login
Assumption:
    Current date = '2024-06-28'
Return: user_id
==============================================================*/

SELECT
    l.user_id
FROM logins AS l
GROUP BY l.user_id
HAVING DATEDIFF(
           DAY,
           MIN(CAST(login_timestamp AS DATE)),
           '2024-06-28'
       ) + 1 =
       COUNT(DISTINCT CAST(login_timestamp AS DATE));



/*==============================================================
7. Dates with no logins
Return: no_login_date
==============================================================*/

WITH r_cte AS (
    SELECT
        MIN(CAST(login_timestamp AS DATE)) AS login_date,
        CAST('2024-06-28' AS DATE) AS last_date
    FROM logins

    UNION ALL

    SELECT
        DATEADD(DAY, 1, login_date),
        last_date
    FROM r_cte
    WHERE DATEADD(DAY, 1, login_date) <= last_date
)

SELECT
    r.login_date AS no_login_date
FROM r_cte AS r
WHERE NOT EXISTS (
    SELECT 1
    FROM logins AS l
    WHERE CAST(l.login_timestamp AS DATE) = r.login_date
)
ORDER BY no_login_date
OPTION (MAXRECURSION 0);