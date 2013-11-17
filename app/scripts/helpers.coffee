window.Carto ?= {}
Carto.helpers = {}

Carto.helpers.LatLng = (coord, map) ->
  coord = map.unproject(coord, map.getMaxZoom())

Carto.helpers.CreateMarker = (markerInfos) ->
  marker = new L.Marker markerInfos.coord,
    title: markerInfos.name,
    icon: markerInfos.icon

  marker.data = markerInfos.data
  return marker
