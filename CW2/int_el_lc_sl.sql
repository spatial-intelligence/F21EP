{{ config(materialized='table') }}

SELECT *
FROM dblink(
  'dbname=datahub user=pgusername password=pgpassword host=localhost port=5432',
  $$
  -- create temp table
  CREATE TEMP TABLE tmp_points AS
  SELECT ST_GeomFromText(wkt, 27700) AS geom_bng
  FROM dblink(
      'dbname=pgusername user=pgusername password=pgpassword host=localhost port=5432',
      'SELECT ST_AsText(geom_bng) AS wkt FROM f21ep_cw2.waterornot_points'
  ) AS t(wkt text);

  -- now query raster
  SELECT p.geom_bng,
         ST_Value(lc.rast, 1, p.geom_bng, true) AS lc_value,
         ST_Value(el.rast, 1, p.geom_bng, true) AS el_value,
         ST_Value(sl.rast, 1, p.geom_bng, true) AS sl_value
  FROM tmp_points p
  CROSS JOIN LATERAL (
      SELECT rast
      FROM landcover.lcm2024 lc
      WHERE ST_Intersects(lc.rast, p.geom_bng)
      LIMIT 1
  ) lc
  CROSS JOIN LATERAL (
      SELECT rast
      FROM elevation.dtm50 el
      WHERE ST_Intersects(el.rast, p.geom_bng)
      LIMIT 1
  ) el
  CROSS JOIN LATERAL (
      SELECT rast
      FROM elevation.slope50 sl
      WHERE ST_Intersects(sl.rast, p.geom_bng)
      LIMIT 1
  ) sl;
  $$
) AS t(
  geom_bng geometry,
  lc_value double precision,
  el_value double precision,
  sl_value double precision
)
