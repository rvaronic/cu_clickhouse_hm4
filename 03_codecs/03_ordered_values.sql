SELECT
    event_no,
    t_zstd,
    toInt64(toUnixTimestamp(t_zstd))
      - toInt64(toUnixTimestamp(
          toDateTime('2026-10-20 00:00:00', 'UTC')
        )) AS seconds_from_start
FROM takt.hw_codec_ordered
ORDER BY event_no
LIMIT 6;
