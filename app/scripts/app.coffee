window.Carto ?= {}

DEFAULTS =
  mapType: 'pve'

Carto.init = ->
  myMap = new Carto.Maps[DEFAULTS.mapType]('leaflet-map')

$ Carto.init
# $(document).on 'ready',
