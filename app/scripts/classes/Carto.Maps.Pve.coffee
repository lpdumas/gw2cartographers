window.Carto ?= {}
Carto.Maps   ?= {}

class Carto.Maps.pve extends Carto.Map

  regions: ["Black Citadel","Blazeridge Steppes","Bloodtide Coast","Brisban Wildlands","Caledon Forest","Cursed Shore","Diessa Plateau","Divinity's Reach","Dredgehaunt Cliffs","Fields of Ruin","Fireheart Rise","Frostgorge Sound","Gendarran Fields","Harathi Hinterlands","Hoelbrak","Iron Marches","Kessex Hills","Lion's Arch","Lornar's Pass","Malchor's Leap","Metrica Province","Mount Maelstrom","Plains of Ashford","Queensdale","Rata Sum","Snowden Drifts","Southsun Cove","Sparkfly Fen","Straits of Devastation","The Grove","Timberline Falls","Wayfarer Foothills"]

  constructor: (containerId) ->
    super(containerId)
    @$toolbar         = null
    @activeArea       = null
    @worldSelect      = null
    @worldDataFetched = ko.observable(false)
    @worlds           = ko.observableArray()
    @activeAreaName   = ko.observable()
    @markerIcons      = {}
    @areas            = {}

    @apiPath =
      floor :      "https://api.guildwars2.com/v1/map_floor.json?continent_id=1&floor=1"
      staticFloor: "/floor.json"
      world :      "https://api.guildwars2.com/v1/world_names.json?lang=en"

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
    staticfloorInfosJSONPath =

    _onSingleAreaFetched = (data) =>
      console?.log "#{data.name} fetched..."

    _onAllAreaFetched = (data) =>
      callback(data)

    _onAreaFetchFail = (data) =>
      console?.log "There seems to be a problem with the guildwars2 API ... getting static data"
      oboe(@apiPath.staticFloor)
      .node('regions.*', _onSingleAreaFetched)
      .done(_onAllAreaFetched)
      .fail(_onAreaFetchFail)

    oboe(@apiPath.floor)
    .node('regions.*', _onSingleAreaFetched)
    .done(_onAllAreaFetched)
    .fail(_onAreaFetchFail)

  getWorldDataAsync: ->
    _onWorldDataFetched = (worldData) =>
      console?.log worldData
      for worldObject in worldData
        @worlds.push worldObject

      @worldDataFetched(true)
      @worldSelect = $(".js-world-select")
      @worldSelect.select2
        width: 165

    _onWorldDataFetchFail = (data) =>
      console?.log data
      console?.log "There seems to be a problem with the guildwars2 world API ... getting static data"

    oboe(@apiPath.world)
    .done(_onWorldDataFetched)
    .fail(_onWorldDataFetchFail)

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

    for key, region of data?.regions
      for k, area of region.maps
        for region in @regions when area.name is region
          @areas[area.name] = new Carto.Maps.Area area, @


    @$toolbar = $(JST["app/views/overlay-ui-pve-toolbar.hbs"]())
    OVERLAYUI.append @$toolbar

    @getWorldDataAsync()

    # Applying KnockoutJS binding
    ko.applyBindings @

  setActiveArea: (area) =>
    @activeArea = area
    @$toolbar.addClass 'active'
    @activeAreaName @activeArea.name

  closeActiveArea: (shouldZoomOut = true) =>
    @activeArea?.setInactive()
    @$toolbar.removeClass 'active'
    @setDefaultBounds()
    @map.setView(@map.getCenter(), 0) if shouldZoomOut
      # marker.addTo @map





