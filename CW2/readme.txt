The CW2 raster dblink doesn't seem to be working anymore with server timeouts. It's not clear why as we tested this from our accounts, a student account created for testing purposes, and from dbt on the StudentVM. Whilst IT investigate we've come up with an alt. you can use for your CW2 which is to run this dblink command against a vector version of the pixel values for the 8k points.

In other words you'll need to run 4 dblink queries from dbt.
These will all be from your copy of the 8000 points (downloaded from S3 Min.io bucket) and in your PG DB, and the various extra attribute tables.

For the elevation, slope, landcover you can use this new template SQL which queries a vector copy of the values for landcover, elevation, slope:

https://github.com/spatial-intelligence/F21EP/blob/main/CW2/updated_elev_slope_lc.sqlLinks to an external site. 

For the Index of Multiple Dep. you can use the existing template (as it should work fine given it was vector data anyway):
https://github.com/spatial-intelligence/F21EP/blob/main/CW2/ind_mutl_dep_draft.sqlLinks to an external site. 


In other words - all queries are now between vector spatial data tables held in your DB and datahub.
