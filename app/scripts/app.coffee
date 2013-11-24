window.Carto ?= {}

DEFAULTS =
  mapType: 'pve'

Carto.init = ->
  window.OVERLAYUI = $('.js-overlay-ui')
  myMap = new Carto.Maps[DEFAULTS.mapType]('leaflet-map')

  $("select").select2
    width: 165

  ko.applyBindings myMap

$ Carto.init
# $(document).on 'ready',
