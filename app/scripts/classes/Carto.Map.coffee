window.Carto ?= {}
class Carto.Map
  constructor: (containerId) ->

    @map = L.map(containerId,
      minZoom: 0
      maxZoom: 7
      crs: L.CRS.Simple
    ).setView([0, 0], 0)

    southWest = Carto.helpers.LatLng [0,32768], @map
    northEast = Carto.helpers.LatLng [32768,0], @map

    @map.setMaxBounds new L.LatLngBounds(southWest, northEast)

  createMarker: (markerInfos) ->

    marker = new L.Marker markerInfos.coord,
      title: markerInfos.name,
      icon: markerInfos.icon

    marker.data = markerInfos.data
    return marker



