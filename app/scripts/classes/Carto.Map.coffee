window.Carto ?= {}
class Carto.Map
  constructor: (containerId) ->

    @map = L.map(containerId,
      minZoom: 0
      maxZoom: 7
      crs: L.CRS.Simple
    ).setView([0, 0], 0)

    southWest = Carto.helpers.LatLng [0,36768], @map
    northEast = Carto.helpers.LatLng [36768,0], @map

    @map.setMaxBounds new L.LatLngBounds(southWest, northEast)


  addToMap: (markersObjet) =>
    for key, marker of markersObjet
      marker.addTo @map
