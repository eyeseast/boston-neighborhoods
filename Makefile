

SHAPEFILES = data/mbta_rapid_transit/MBTA_ARC.shp \
	data/mbtabus/MBTABUSROUTES_ARC.shp \
	data/townsurvey/TOWNSSURVEY_POLY.shp \
	data/townsurvey/TOWNSSURVEY_POLY.shp \
	data/trains/TRAINS_ARC.shp

# routes only
ROUTES = data/mbta_rapid_transit/MBTA_ARC.json \
	data/mbtabus/MBTABUSROUTES_ARC.json \
	data/trains/TRAINS_ARC.json

# include points
POINTFILES = data/mbta_rapid_transit/MBTA_NODE.json \
	data/mbtabus/MBTABUSSTOPS_PT.json \
	data/trains/TRAINS_NODE.json

# zips
data/mbta_rapid_transit.zip:
	wget -O $@ http://wsgw.mass.gov/data/gispub/shape/state/mbta_rapid_transit.zip

data/mbtabus.zip:
	wget -O $@ http://wsgw.mass.gov/data/gispub/shape/state/mbtabus.zip

data/townsurvey.zip:
	wget -O $@ http://wsgw.mass.gov/data/gispub/shape/state/townssurvey_shp.zip

data/trains.zip:
	wget -O $@ http://wsgw.mass.gov/data/gispub/shape/state/trains.zip

data/mbta_rapid_transit/MBTA_ARC.shp: data/mbta_rapid_transit.zip
	mkdir -p $(dir $@)
	unzip -d $(dir $@) $<
	touch $@

data/mbta_rapid_transit/MBTA_ARC.json: data/mbta_rapid_transit/MBTA_ARC.shp
	ogr2ogr -f GeoJSON -t_srs EPSG:4326 $@ $<

data/mbta_rapid_transit/MBTA_NODE.json: data/mbta_rapid_transit/MBTA_ARC.shp
	ogr2ogr -f GeoJSON -t_srs EPSG:4326 $@ $(basename $@).shp

data/mbtabus/MBTABUSROUTES_ARC.shp: data/mbtabus.zip
	mkdir -p $(dir $@)
	unzip -d $(dir $@) $<
	touch $@

data/mbtabus/MBTABUSROUTES_ARC.json: data/mbtabus/MBTABUSROUTES_ARC.shp
	ogr2ogr -f GeoJSON -t_srs EPSG:4326 $@ $<

data/mbtabus/MBTABUSSTOPS_PT.json: data/mbtabus/MBTABUSROUTES_ARC.shp
	ogr2ogr -f GeoJSON -t_srs EPSG:4326 $@ $(basename $@).shp

data/townsurvey/TOWNSSURVEY_POLY.shp: data/townsurvey.zip
	mkdir -p $(dir $@)
	unzip -d $(dir $@) $<
	touch $@

data/townsurvey/TOWNSSURVEY_POLY.json: data/townsurvey/TOWNSSURVEY_POLY.shp
	ogr2ogr -f GeoJSON -t_srs EPSG:4326 $@ $<

data/trains/TRAINS_ARC.shp: data/trains.zip
	mkdir -p $(dir $@)
	unzip -d $(dir $@) $<
	touch $@

data/trains/TRAINS_ARC.json: data/trains/TRAINS_ARC.shp
	ogr2ogr -f GeoJSON -t_srs EPSG:4326 $@ $<

data/trains/TRAINS_NODE.json: data/trains/TRAINS_ARC.shp
	ogr2ogr -f GeoJSON -t_srs EPSG:4326 $@ $(basename $@).shp

shapefiles: $(SHAPEFILES)

data/stations.json: $(POINTFILES)
	topojson -p -- $(POINTFILES) > $@

data/routes.json: $(ROUTES)
	topojson -p -- $(ROUTES) > $@

clean:
	rm -r data/mbtabus
	rm -r data/mbta_rapid_transit
	rm -r data/townsurvey
	rm -r data/trains
	rm data/*.json
