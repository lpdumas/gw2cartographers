window.Carto ?= {}

DEFAULTS =
  mapType: 'pve'

Carto.init = ->
  window.OVERLAYUI = $('.js-overlay-ui')
  myMap = new Carto.Maps[DEFAULTS.mapType]('leaflet-map')

$ Carto.init
# $(document).on 'ready',
