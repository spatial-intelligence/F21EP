
--add a PK index
ALTER TABLE f21ep_cw2.waterornot_points ADD column id serial;


SELECT *
FROM dblink(
  'dbname=datahub user=pgusername password=pgpassword host=localhost port=5432',
  $$
  WITH pts AS (
      SELECT *
      FROM dblink(
        'dbname=pgusername user=pgusername password=pgpassword host=localhost port=5432',
        'SELECT id, geom_bng FROM f21ep_cw2.waterornot_points'
      ) AS p(id int, geom_bng geometry)
  )
  SELECT p.id, p.geom_bng, imd.la_decile
  FROM pts p
  LEFT JOIN index_dep.imd_uk2019 imd
    ON imd.geom && p.geom_bng
   AND ST_Intersects(imd.geom, p.geom_bng)
  $$
) AS result(pt int, geom geometry, la_decile int);

