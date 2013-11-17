window.Carto ?= {}
Carto.Maps   ?= {}

class Carto.Maps.pve extends Carto.Map

  regions: ["Black Citadel","Blazeridge Steppes","Bloodtide Coast","Brisban Wildlands","Caledon Forest","Cursed Shore","Diessa Plateau","Divinity's Reach","Dredgehaunt Cliffs","Fields of Ruin","Fireheart Rise","Frostgorge Sound","Gendarran Fields","Harathi Hinterlands","Hoelbrak","Iron Marches","Kessex Hills","Lion's Arch","Lornar's Pass","Malchor's Leap","Metrica Province","Mount Maelstrom","Plains of Ashford","Queensdale","Rata Sum","Snowden Drifts","Southsun Cove","Sparkfly Fen","Straits of Devastation","The Grove","Timberline Falls","Wayfarer Foothills"]

  constructor: (containerId) ->
    super(containerId)

    @markerIcons  = {}
    @areas        = {}

    @tiles = L.tileLayer "https://tiles.guildwars2.com/1/1/{z}/{x}/{y}.jpg",
      minZoom: 0,
      maxZoom: 7,
      continuousWorld: true

    @tiles.addTo @map

    # Starting a async series call to the GW2 API
    async.series
      generateMarkerIcons : @generateMarkerIcons
      getRegionsData      : @getRegionsData
    , @handleUI


  getRegionsData: (callback) =>
    _onSingleAreaFetched = (data) =>
      console?.log "#{data.name} fetched..."

    _onAllAreaFetched = (data) =>
      callback(data)

    _onAreaFetchFail = (data) =>

    floorInfosJSONPath = "https://api.guildwars2.com/v1/map_floor.json?continent_id=1&floor=1"

    oboe(floorInfosJSONPath)
    .node('regions.*', _onSingleAreaFetched)
    .done(_onAllAreaFetched)
    .fail(_onAreaFetchFail)

  generateMarkerIcons: (callback) =>
    getIconsOptions = (name) =>
      options =
        iconUrl: "/images/icons/#{name}.png"
        iconRetinaUrl: "/images/icons/#{name}.png"
        iconSize: [32, 32],
        iconAnchor: [16,16]

    @markerIcons =
      waypoints   : L.icon(getIconsOptions('waypoints'))
      poi         : L.icon(getIconsOptions('poi'))
      skillpoints : L.icon(getIconsOptions('skillpoints'))
      tasks       : L.icon(getIconsOptions('tasks'))

    callback()

  handleUI: (data) =>
    console?.log "====================="
    for key, region of data.regions
      for k, area of region.maps
        for region in @regions when area.name is region
          @areas[area.name] = new Carto.Maps.Area area, @

      # marker.addTo @map





