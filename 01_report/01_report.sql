SELECT
    country,
    count() AS events_total,
    countIf(played_seconds < 20) AS events_under_20,
    round(
        100.0 * (countIf(played_seconds < 20) / count()),
        2
    ) AS under_20_percent
FROM takt.listening_events
WHERE ended_at >= toDateTime('2026-10-20 00:00:00', 'UTC')
  AND ended_at <  toDateTime('2026-10-27 00:00:00', 'UTC')
GROUP BY country
ORDER BY country;
