SELECT *
FROM dblink(
  'dbname=datahub user=youPGusername password=yourPGpassword host=localhost port=5432',
  $$
  WITH pts AS (
      SELECT *
      FROM dblink(
        'dbname=youPGusername user=youPGusername password=yourPGpassword host=localhost port=5432',
        'SELECT id, geom_bng FROM f21ep_cw2.waterornot_points'
      ) AS p(id int, geom_bng geometry)
  )
  SELECT p.id, p.geom_bng, px.pixel_value
  FROM pts p
  LEFT JOIN f21ep_cw2.scenicornot8k_lc px  -- or f21ep_cw2.scenicornot8k_elevation -- or f21ep_cw2.scenicornot8k_slope
    ON px.geom_bng && p.geom_bng
   AND ST_Intersects(px.geom_bng, p.geom_bng)
  $$
) AS result(pt int, geom_bng geometry, pixel_value float);

