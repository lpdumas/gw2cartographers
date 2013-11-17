window.Carto ?= {}
Carto.Maps   ?= {}

class Carto.Maps.pve extends Carto.Map

  regions: ["Black Citadel","Blazeridge Steppes","Bloodtide Coast","Brisban Wildlands","Caledon Forest","Cursed Shore","Diessa Plateau","Divinity's Reach","Dredgehaunt Cliffs","Fields of Ruin","Fireheart Rise","Frostgorge Sound","Gendarran Fields","Harathi Hinterlands","Hoelbrak","Iron Marches","Kessex Hills","Lion's Arch","Lornar's Pass","Malchor's Leap","Metrica Province","Mount Maelstrom","Plains of Ashford","Queensdale","Rata Sum","Snowden Drifts","Southsun Cove","Sparkfly Fen","Straits of Devastation","The Grove","Timberline Falls","Wayfarer Foothills"]

  constructor: (containerId) ->
    super(containerId)

    @mapFloorData = []
    @markerIcons  = {}
    @UI           = {}
    @UI.rectangle = {}
    @UI.markers   = {}

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
      waypoint : L.icon(getIconsOptions('waypoints'))
      poi      : L.icon(getIconsOptions('poi'))

    callback()

  handleUI: (data) =>
    console?.log "====================="
    for key, region of data.regions
      for k, map of region.maps
        for region in @regions when map.name is region
          @UI.rectangle[map.name] = new Carto.UI.Area(map.continent_rect, map.name, @map)
          @UI.markers[map.name]   = {}
          @handlePOIcreation(map.name, map.points_of_interest)


  handlePOIcreation: (regionName, poiArray) =>
    @UI.markers[regionName]["points_of_interest"] = {}
    @UI.markers[regionName]["waypoints"] = {}

    for poi in poiArray
      coord  = Carto.helpers.LatLng poi.coord, @map
      markerInfos =
        coord: coord
        name: poi.name
        data: poi

      if poi.type isnt "waypoint"
        markerInfos.icon = @markerIcons["poi"]
        marker = @createMarker(markerInfos)
        @UI.markers[regionName]["points_of_interest"][poi.poi_id] = marker
      else
        markerInfos.icon = @markerIcons["waypoint"]
        marker = @createMarker(markerInfos)
        @UI.markers[regionName]["waypoints"][poi.poi_id] = marker

      # marker.addTo @map





