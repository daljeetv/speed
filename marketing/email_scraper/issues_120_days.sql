SELECT
      opened.id
    , opened.repo_id
    ,  opened.actor_login 
    , opened.html_url
    , opened.opened_created_at
    , closed.closed_created_at
    , TIMESTAMP_DIFF(closed.closed_created_at, opened.opened_created_at, DAY) as length_in_days
    , opened.repo_name
    , opened.stars
    , opened.labels
    , best_actor_for_repo.actor_login as best_solver
FROM (
  SELECT
      gd.id as id
    , rs.repo_id repo_id
    , JSON_EXTRACT_SCALAR(payload, "$.issue.html_url") as html_url
    , LOWER(JSON_EXTRACT_SCALAR(payload, '$.issue.labels[0].name')) as labels
    , repo.name as repo_name
    , repo.url
    , actor.login actor_login
    , created_at as opened_created_at
    , stars
  FROM
    `githubarchive.day.201*` gd
  INNER JOIN 
    `fh-bigquery.github_extracts.repo_stars` rs ON gd.repo.name = rs.repo_name
  WHERE
    type = 'IssuesEvent'
  AND
    JSON_EXTRACT_SCALAR(payload, "$.action") = 'opened'
) opened
LEFT JOIN
(
  SELECT
    gd.id as id
    , JSON_EXTRACT_SCALAR(payload, "$.issue.html_url") as html_url
    , repo.url
    , actor.login as actor_login
    , created_at as closed_created_at
  FROM
  `githubarchive.day.201*` gd
  WHERE
    type = 'IssuesEvent'
  AND
    JSON_EXTRACT_SCALAR(payload, "$.action") = 'closed'
) closed
ON opened.html_url = closed.html_url AND opened.url = closed.url
JOIN (
   SELECT 
      e.*
   FROM
   (
      SELECT
        c.repo_url
      , c.repo_name
      , MAX(c.number_of_issues_closed_by_actor) as number_of_issues_closed_by_actor
      FROM
      (
       SELECT
       repo.url repo_url
        , repo.name as repo_name
        , COUNT(created_at) as number_of_issues_closed_by_actor
       FROM
       `githubarchive.day.201*` gd
       WHERE
       type = 'IssuesEvent'
       AND
       payload LIKE '%"action":"closed"%'
       GROUP BY
       repo.url, repo.name
      ) c
      GROUP BY c.repo_url, c.repo_name
  ) d
  JOIN
    (
      SELECT
      actor.login as actor_login
      , repo.url repo_url
      , repo.name as repo_name
      , COUNT(created_at) as number_of_issues_closed_by_actor
     FROM
      `githubarchive.day.201*` gd
     WHERE
      type = 'IssuesEvent'
     AND
     payload LIKE '%"action":"closed"%'
     GROUP BY actor_login, repo_url, repo_name
    ) e
  ON d.repo_url = e.repo_url AND d.repo_name = e.repo_name and d.number_of_issues_closed_by_actor = e.number_of_issues_closed_by_actor
) best_actor_for_repo
ON opened.repo_name = best_actor_for_repo.repo_name
WHERE 
  opened_created_at < TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 120 DAY) AND opened_created_at > TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 121 DAY)
  AND closed_created_at IS NULL
  AND opened.opened_created_at is not null
--   AND stars is not null
--   AND stars > 3000
ORDER BY opened_created_at desc, stars desc
-- LIMIT 16000
