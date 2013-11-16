window.Carto ?= {}
Carto.UI     ?= {}
class Carto.UI.Area
  constructor: (bounds, name, map) ->
    defaultStyle =
      color: "black"
      weight: 4,
      fill: true,
      fillOpacity: 0.5

    activeStyle =
      color: "black"
      weight: 4
      fill: false

    sw = map.unproject(bounds[0], map.getMaxZoom())
    ne = map.unproject(bounds[1], map.getMaxZoom())
    bounds = new L.LatLngBounds(sw, ne)

    @rect = new L.rectangle(bounds, defaultStyle).addTo(map)