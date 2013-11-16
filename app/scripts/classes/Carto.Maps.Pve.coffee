window.Carto ?= {}
Carto.Maps   ?= {}
console?.log Carto
class Carto.Maps.pve extends Carto.Map
  constructor: ->
    console?.log "hello from the pve map constructor"