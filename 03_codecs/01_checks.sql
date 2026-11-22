-- Выполнять два запроса отдельно.
WITH toDateTime('2026-10-20 00:00:00', 'UTC') AS base
SELECT
    source,
    count() AS rows_count,
    uniqExact(event_no) AS unique_ids,
    min(event_no) AS first_id,
    max(event_no) AS last_id,
    countIf(
        t_zstd != base + toIntervalSecond(event_no)
        OR t_delta != t_zstd
        OR t_double_delta != t_zstd
    ) AS bad_rows
FROM
(
    SELECT 'ordered' AS source, *
    FROM takt.hw_codec_ordered
    UNION ALL
    SELECT 'mixed' AS source, *
    FROM takt.hw_codec_mixed
)
GROUP BY source
ORDER BY source;

SELECT
    table,
    part_type,
    count() AS active_parts,
    sum(rows) AS events
FROM system.parts
WHERE database = 'takt'
  AND active
  AND table IN ('hw_codec_ordered', 'hw_codec_mixed')
GROUP BY table, part_type
ORDER BY table;
