window.Carto ?= {}

DEFAULTS =
  mapType: 'pve'

Carto.init = ->
  myMap = new Carto.Maps[DEFAULTS.mapType]()


$(document).on 'ready', Carto.init
