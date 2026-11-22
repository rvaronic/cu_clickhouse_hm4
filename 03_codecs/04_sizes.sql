SELECT
    table,
    column,
    sum(column_data_uncompressed_bytes) AS uncompressed_bytes,
    sum(column_data_compressed_bytes) AS compressed_bytes,
    round(
        sum(column_data_uncompressed_bytes)
        / nullIf(sum(column_data_compressed_bytes), 0),
        2
    ) AS compression_ratio
FROM system.parts_columns
WHERE database = 'takt'
  AND active
  AND table IN ('hw_codec_ordered', 'hw_codec_mixed')
  AND column IN ('t_zstd', 't_delta', 't_double_delta')
GROUP BY table, column
ORDER BY table, column;
