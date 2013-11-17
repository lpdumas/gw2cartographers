window.Carto ?= {}
Carto.Maps   ?= {}

class Carto.Maps.pve extends Carto.Map

  regions: ["Black Citadel","Blazeridge Steppes","Bloodtide Coast","Brisban Wildlands","Caledon Forest","Cursed Shore","Diessa Plateau","Divinity's Reach","Dredgehaunt Cliffs","Fields of Ruin","Fireheart Rise","Frostgorge Sound","Gendarran Fields","Harathi Hinterlands","Hoelbrak","Iron Marches","Kessex Hills","Lion's Arch","Lornar's Pass","Malchor's Leap","Metrica Province","Mount Maelstrom","Plains of Ashford","Queensdale","Rata Sum","Snowden Drifts","Southsun Cove","Sparkfly Fen","Straits of Devastation","The Grove","Timberline Falls","Wayfarer Foothills"]

  constructor: (containerId) ->
    super(containerId)

    @mapFloorData = []
    @UI           = {}
    @UI.rectangle = {}
    @UI.markers   = {}

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

  _onAllAreaFetched: (data) =>
    console?.log "====================="
    for key, region of data.regions
      for k, map of region.maps
        for region in @regions when map.name is region
          @UI.rectangle[map.name] = new Carto.UI.Area(map.continent_rect, map.name, @map)
          @UI.markers[map.name]   = {}

          @handlePOIcreation(map.name, map.points_of_interest)

  _onAreaFetchFail: (data) =>

  handlePOIcreation: (regionName, poiArray) =>
    # console?.log regionName
    # console?.log poiArray
    @UI.markers[regionName]["points_of_interest"] = []
    @UI.markers[regionName]["waypoints"] = []

    for poi in poiArray
      if poi.type isnt "waypoint"
        coord  = @map.unproject(poi.coord, @map.getMaxZoom())

        myIcon = L.icon
          iconUrl: '/images/icons/poi.png'
          iconRetinaUrl: '/images/icons/poi.png'
          iconSize: [32, 32],
          iconAnchor: [16,16]

        marker = new L.Marker coord,
          title: poi.name,
          icon: myIcon
        @UI.markers[regionName]["points_of_interest"].push marker
        marker.addTo @map

      else
        coord  = @map.unproject(poi.coord, @map.getMaxZoom())

        myIcon = L.icon
          iconUrl: '/images/icons/waypoints.png'
          iconRetinaUrl: '/images/icons/waypoints.png'
          iconSize: [32, 32],
          iconAnchor: [16,16]

        marker = new L.Marker coord,
          title: poi.name,
          icon: myIcon
        @UI.markers[regionName]["waypoints"].push marker
        marker.addTo @map





