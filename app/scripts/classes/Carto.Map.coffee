window.Carto ?= {}
class Carto.Map
  constructor: (containerId) ->
    console?.log containerId

    @map = L.map(containerId,
      minZoom: 0
      maxZoom: 7
      crs: L.CRS.Simple
    ).setView([0, 0], 0)

    southWest = @map.unproject([0,32768], @map.getMaxZoom())
    northEast = @map.unproject([32768,0], @map.getMaxZoom())

    @map.setMaxBounds new L.LatLngBounds(southWest, northEast)

    onMapClick = (e) =>
      console.log("You clicked the map at " + @map.project(e.latlng))

    @map.on("click", onMapClick)

