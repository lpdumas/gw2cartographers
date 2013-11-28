window.Carto ?= {}
class Carto.Map
  constructor: (containerId) ->

    @map = L.map(containerId,
      minZoom: 0
      maxZoom: 7
      crs: L.CRS.Simple
    ).setView([0, 0], 0)

    @defaultSouthWest = Carto.helpers.LatLng [0,36768], @map
    @defaultNorthEast = Carto.helpers.LatLng [36768,0], @map

    @setDefaultBounds()

  addToMap: (markersObjet) =>
    for key, marker of markersObjet
      marker.addTo @map

  setDefaultBounds: ->
    @map.setMaxBounds new L.LatLngBounds(@defaultSouthWest, @defaultNorthEast)
