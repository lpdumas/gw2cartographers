window.Carto ?= {}
Carto.helpers = {}

Carto.helpers.LatLng = (coord, map) ->
  coord = map.unproject(coord, map.getMaxZoom())
