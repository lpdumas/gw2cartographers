window.Carto   ?= {}
Carto.Maps     ?= {}

class Carto.Maps.Area
  constructor: (areaInfos, @parent) ->
    @name            = areaInfos.name
    @rectangleCoords = areaInfos.continent_rect
    @rectangle       = new Carto.UI.AreaRectangle(@rectangleCoords, @name, @parent.map)
    @markers         =
      points_of_interest : {}
      waypoints          : {}
      tasks              : {}
      skill_challenges   : {}

    @handlePOIcreation(areaInfos.points_of_interest)
    @handleSkillChallengesCreation(areaInfos.skill_challenges)
    @handleTasksCreation(areaInfos.tasks)

    $(@rectangle).on 'click', @setActive

  handlePOIcreation: (poiArray) ->
    for poi in poiArray
      coord  = Carto.helpers.LatLng poi.coord, @parent.map
      markerInfos =
        coord: coord
        name: poi.name
        data: poi

      if poi.type isnt "waypoint"
        markerInfos.icon = @parent.markerIcons["poi"]
        marker = Carto.helpers.CreateMarker(markerInfos)
        @markers["points_of_interest"][poi.poi_id] = marker

      else
        markerInfos.icon = @parent.markerIcons["waypoints"]
        marker = Carto.helpers.CreateMarker(markerInfos)
        @markers["waypoints"][poi.poi_id] = marker

  handleSkillChallengesCreation: (skillsArray) ->
    for key, skillpoint of skillsArray
      coord  = Carto.helpers.LatLng skillpoint.coord, @parent.map

      markerInfos =
        coord: coord
        name: "Skill challenge"
        data: skillpoint

      markerInfos.icon = @parent.markerIcons["skillpoints"]
      marker = Carto.helpers.CreateMarker(markerInfos)
      @markers["skill_challenges"][key] = marker

  handleTasksCreation: (tasksArray) ->
    for task in tasksArray
      coord  = Carto.helpers.LatLng task.coord, @parent.map

      markerInfos =
        coord: coord
        name: task.objective
        data: task

      markerInfos.icon = @parent.markerIcons["tasks"]
      marker = Carto.helpers.CreateMarker(markerInfos)
      @markers["tasks"][task.task_id] = marker

  setInactive: () ->
    @rectangle.show()
    for markerType, markersObject of @markers
      for key, marker of markersObject
        @parent.map.removeLayer marker

  setActive: () =>
    @parent.closeActiveArea(false)
    @parent.setActiveArea(@)
    @rectangle.hide()

    @parent.map.setMaxBounds @rectangle.bounds.pad(0.9)
    @parent.map.panTo @rectangle.bounds.getCenter()

    @parent.addToMap(markersObject) for markerType, markersObject of @markers

