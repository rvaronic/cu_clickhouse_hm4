EXPLAIN indexes = 1
SELECT
    country,
    count() AS events_total,
    countIf(played_seconds < 20) AS events_under_20,
    round(
        100.0 * (countIf(played_seconds < 20) / count()),
        2
    ) AS under_20_percent
FROM takt.hw_events_country
WHERE ended_at >= toDateTime('2026-10-24 00:00:00', 'UTC')
  AND ended_at <  toDateTime('2026-10-25 00:00:00', 'UTC')
  AND country = 'DE'
GROUP BY country
ORDER BY country
SETTINGS
    max_threads = 4,
    use_query_cache = 0,
    use_query_condition_cache = 0,
    optimize_move_to_prewhere = 0;
