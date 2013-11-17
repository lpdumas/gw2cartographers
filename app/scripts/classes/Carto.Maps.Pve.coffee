window.Carto ?= {}
Carto.Maps   ?= {}

class Carto.Maps.pve extends Carto.Map

  regions: [
    "Black Citadel",
    "Blazeridge Steppes",
    "Bloodtide Coast",
    "Brisban Wildlands",
    "Caledon Forest",
    "Cursed Shore",
    "Diessa Plateau",
    "Divinity's Reach",
    "Dredgehaunt Cliffs",
    "Fields of Ruin",
    "Fireheart Rise",
    "Frostgorge Sound",
    "Gendarran Fields",
    "Harathi Hinterlands",
    "Hoelbrak"
    "Iron Marches",
    "Kessex Hills",
    "Lion's Arch",
    "Lornar's Pass",
    "Malchor's Leap",
    "Metrica Province",
    "Mount Maelstrom",
    "Plains of Ashford",
    "Queensdale",
    "Rata Sum",
    "Snowden Drifts",
    "Southsun Cove"
    "Sparkfly Fen",
    "Straits of Devastation",
    "The Grove",
    "Timberline Falls",
    "Wayfarer Foothills",
  ]

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

  _onSingleAreaFetched: (data) =>
    console?.log "#{data.name} fetched..."
    # for key, map of data.maps when data.name isnt "Steamspur Mountains"
      # @regionsInfos.push map

    #   areaUI = new Carto.UI.Area(map.map_rect, map.name, @map)
    #   @areaPolygons[key] = areaUI

  _onAllAreaFetched: (data) =>
    console?.log "====================="
    for key, region of data.regions
      for k, map of region.maps
        for region in @regions when map.name is region
          console?.log map.name
          @regionsInfos.push map
          areaUI = new Carto.UI.Area(map.continent_rect, map.name, @map)

          @areaPolygons[map.name] = areaUI

    # console?.log @areaPolygons

  _onAreaFetchFail: (data) =>