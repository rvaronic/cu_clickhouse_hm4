DROP TABLE IF EXISTS takt.hw_events_country;
DROP TABLE IF EXISTS takt.hw_events_time;

CREATE TABLE takt.hw_events_time
AS takt.listening_events
ENGINE = MergeTree
ORDER BY (ended_at)
SETTINGS
    index_granularity = 8192,
    index_granularity_bytes = 0;

CREATE TABLE takt.hw_events_country
AS takt.hw_events_time
ENGINE = MergeTree
ORDER BY (country, ended_at)
SETTINGS
    index_granularity = 8192,
    index_granularity_bytes = 0;

INSERT INTO takt.hw_events_time
SELECT *
FROM takt.listening_events
WHERE ended_at >= toDateTime('2026-10-13 00:00:00', 'UTC')
  AND ended_at <  toDateTime('2026-10-27 00:00:00', 'UTC');

INSERT INTO takt.hw_events_country
SELECT * FROM takt.hw_events_time;

OPTIMIZE TABLE takt.hw_events_time FINAL;
OPTIMIZE TABLE takt.hw_events_country FINAL;

SELECT
    table,
    count() AS active_parts,
    sum(rows) AS events
FROM system.parts
WHERE database = 'takt'
  AND active
  AND table IN ('hw_events_time', 'hw_events_country')
GROUP BY table
ORDER BY table;

SHOW CREATE TABLE takt.hw_events_time;
SHOW CREATE TABLE takt.hw_events_country;
