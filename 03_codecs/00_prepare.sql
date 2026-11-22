-- Выполнять команды по одной. Блок пересоздаёт таблицы задания 3.
DROP TABLE IF EXISTS takt.hw_codec_mixed;
DROP TABLE IF EXISTS takt.hw_codec_ordered;

CREATE TABLE takt.hw_codec_ordered
(
    event_no       UInt64,
    t_zstd         DateTime('UTC') CODEC(ZSTD(1)),
    t_delta        DateTime('UTC') CODEC(Delta, ZSTD(1)),
    t_double_delta DateTime('UTC') CODEC(DoubleDelta, ZSTD(1))
)
ENGINE = MergeTree
ORDER BY event_no
SETTINGS
    index_granularity = 8192,
    index_granularity_bytes = 0,
    min_bytes_for_wide_part = 0,
    min_rows_for_wide_part = 0;

CREATE TABLE takt.hw_codec_mixed
AS takt.hw_codec_ordered
ENGINE = MergeTree
ORDER BY (cityHash64(event_no), event_no)
SETTINGS
    index_granularity = 8192,
    index_granularity_bytes = 0,
    min_bytes_for_wide_part = 0,
    min_rows_for_wide_part = 0;

INSERT INTO takt.hw_codec_ordered
SELECT
    number,
    toDateTime('2026-10-20 00:00:00', 'UTC')
        + toIntervalSecond(number) AS event_time,
    event_time,
    event_time
FROM numbers(500000);

INSERT INTO takt.hw_codec_mixed
SELECT * FROM takt.hw_codec_ordered;

OPTIMIZE TABLE takt.hw_codec_ordered FINAL;
OPTIMIZE TABLE takt.hw_codec_mixed FINAL;
