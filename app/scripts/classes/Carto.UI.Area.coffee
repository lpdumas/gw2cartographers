window.Carto ?= {}
Carto.UI     ?= {}
class Carto.UI.Area
  constructor: (bounds, name, map) ->
    defaultStyle =
      color: "white"
      weight: 0
      fill: false

    activeStyle =
      color: "white"
      weight: 0
      fill: true
      fillOpacity: 0.2

    sw = Carto.helpers.LatLng bounds[0], map
    ne = Carto.helpers.LatLng bounds[1], map
    bounds = new L.LatLngBounds(sw, ne)

    @rect = new L.rectangle(bounds, defaultStyle).addTo(map)

    labelDivIcon = new L.divIcon
      className : 'leaflet-area-name'
      html      : "<span class=\"leaflet-area-name-label\">#{name}</span>"

    label = L.marker(bounds.getCenter(), {icon: labelDivIcon}).addTo(map)

    over = =>
      @rect.setStyle activeStyle
    out = =>
      @rect.setStyle defaultStyle

    @rect.on "mouseover", over
    @rect.on "mouseout", out

    label.on "mouseover", over
    label.on "mouseout", out