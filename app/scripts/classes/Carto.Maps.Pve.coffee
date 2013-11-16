window.Carto ?= {}
Carto.Maps   ?= {}
console?.log Carto
class Carto.Maps.pve extends Carto.Map
  constructor: (containerId) ->
    super(containerId)

    @regionsInfos = []
    @areaPolygons = {}

    @tiles = L.tileLayer "https://tiles.guildwars2.com/1/1/{z}/{x}/{y}.jpg",
      minZoom: 0,
      maxZoom: 7,
      continuousWorld: true

    @tiles.addTo @map

    floorInfosJSONPath = "https://api.guildwars2.com/v1/map_floor.json?continent_id=1&floor=1"

    oboe(floorInfosJSONPath)
    .node('regions.*', @_onSingleAreaFetched)
    .done(@_onAllAreaFetched)
    .fail(@_onAreaFetchFail)

    console?.log "hello from the pve map constructor"

  _onSingleAreaFetched: (data) =>
    for key, map of data.maps when data.name isnt "Steamspur Mountains"
      @regionsInfos.push map

    #   areaUI = new Carto.UI.Area(map.map_rect, map.name, @map)
    #   @areaPolygons[key] = areaUI

  _onAllAreaFetched: (data) =>
    console?.log "json is back.."
    for key, zone of @regionsInfos
      areaUI = new Carto.UI.Area(zone.continent_rect, zone.name, @map)


  _onAreaFetchFail: (data) =>