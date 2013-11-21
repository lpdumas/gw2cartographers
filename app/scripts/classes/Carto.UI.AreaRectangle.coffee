window.Carto ?= {}
Carto.UI     ?= {}
class Carto.UI.AreaRectangle
  constructor: (bounds, name, map) ->
    @defaultStyle =
      color: "white"
      weight: 0
      fill: false

    @activeStyle =
      color: "white"
      weight: 0
      fill: true
      fillOpacity: 0.2

    @hiddenStyle =
      fill: false

    sw = Carto.helpers.LatLng bounds[0], map
    ne = Carto.helpers.LatLng bounds[1], map

    @bounds = new L.LatLngBounds(sw, ne)

    @rect = new L.rectangle(@bounds, @defaultStyle).addTo(map)

    labelDivIcon = new L.divIcon
      className : 'leaflet-area-name'
      html      : "<span class=\"leaflet-area-name-label\">#{name}</span>"

    @label = L.marker(@bounds.getCenter(), {icon: labelDivIcon}).addTo(map)

    @bindEvents()

  bindEvents: ->
    over = =>
      @rect.setStyle @activeStyle

    out = =>
      @rect.setStyle @defaultStyle

    click = =>
      $(@).trigger 'click'

    @rect.on "mouseover", over
    @rect.on "mouseout", out
    @rect.on "click", click

    @label.on "mouseover", over
    @label.on "mouseout", out
    @label.on "click", click

  unBindEvents: ->
    @label.off "mouseover"
    @label.off "mouseout"
    @label.off "click"

    @rect.off "mouseover"
    @rect.off "mouseout"
    @rect.off "click"

  hide: ->
    @rect.setStyle @hiddenStyle
    @unBindEvents()

  show: ->
    @rect.setStyle @defaultStyle
    @bindEvents()
