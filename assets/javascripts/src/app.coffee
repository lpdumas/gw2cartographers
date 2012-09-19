# CONSTANT
window.LANG = (()->
  # This is needed because we want to reload the page each time
  # the lang is change. So our lang switch method is gonna compare the 
  # hash lang to this constant. If it detect a change, 
  # it will reload the page
  hash = window.location.hash
  regex = /^#\/*(en|fr)\/*/
  match = regex.exec(hash);
  if match
    match[1]
  else
    "en"
)()

window.LOCAL_STORAGE = (()->
  if window['localStorage']?
    return yes
  else
    return no
)()

##################
#--CARTOGRAPHER--
###############{{{
Cartographer.initiate = ()->
  # Instanciating the template loader
  @templates = new Cartographer.TemplatesLoader()
  
  # Telling the templateLoader to load defaults template
  @templates.loadDefaults(()=>

    # Intanciating the map when all defaults templates
    # are loaded
    @currentMap = new Cartographer.CustomMap('#map',
      "onLoad" : ()->
    )
    @mapHasLoaded()
  )

Cartographer.mapHasLoaded = ()->
  @router = new Cartographer.router()

Cartographer.switchLang = (lang)->
  if window.LANG isnt lang
    url = "http://#{window.location.hostname}/#{window.location.hash}"
    window.location = url
    window.location.reload(true)

Cartographer.highlighMarker = (target)->
  if _.isObject(target) 
    @currentMap.panToCoord(target)
  else
    @currentMap.panToMarker(target)
    
Cartographer.toggleCat = (cats)->
  @currentMap.highlightsCat(cats)

Cartographer.showInfo = ()->
  modal = new Cartographer.Modalbox("info")
  content="""
  <h1>Hey there fellow explorers!</h1>
  <p class="big">Welcome to gw2cartographers, a Guildwars 2 interactive map. This map is 100% crowdsourced! So if you want to add / edit / remove some points, here is how:</p>
  <h2>Adding points</h2>
  <p>Simply click on the «+» next to the desired point label inside the drop down menu</p>
  """
  modal.setContent(content)
  modal.open()

# }}}

##################
#---CLASSES------
###############{{{
  
###
# class Cartographer.TemplatesLoader {{{
###
class Cartographer.TemplatesLoader
  constructor: ()->
    @templates =
      "confirmBox" :
        name :"confirmBox"
        path : "assets/javascripts/templates/confirmBox._"
        version : 1
        src : ""
        loadOnStart: yes
      "customInfoWindow" : 
        name :"customInfoWindow"
        path : "assets/javascripts/templates/customInfoWindow._"
        version : 3
        src : ""
        loadOnStart: yes
      "markersOptions" : 
        name :"markersOptions"
        path: "assets/javascripts/templates/markersOptions._"
        version : 1
        src : ""
        loadOnStart: yes
      "areasSummary" : 
        name :"areasSummary"
        path: "assets/javascripts/templates/areasSummary._"
        version: 1
        src : ""
        loadOnStart: yes
    
  get: (templateName, callback)->
    handleCallback = (template)=>
      if callback?
        callback(template)
      else
        retu
    if LOCAL_STORAGE
      localTemplate = localStorage.getItem(templateName)
      localTemplateVersion = localStorage.getItem("#{templateName}Version")
      if @templates[templateName]? and @templates[templateName].src isnt ""
          if callback? then callback(@templates[templateName].src) else return @templates[templateName].src
      else if localTemplate && (localTemplateVersion? and parseInt(localTemplateVersion) is @templates[templateName].version)
        @templates[templateName].src = localTemplate
        if callback? then callback(localTemplate) else return localTemplate
      else if @templates[templateName]?
        $.get(@templates[templateName].path, (e)=>
          localStorage.setItem(templateName, e);
          @templates[templateName].src = e
          localStorage.setItem("#{templateName}Version", @templates[templateName].version);
          callback(e)
        )
    else
      $.get(@templates[templateName].path, (e)=>
        callback(e)
      )
      
  loadDefaults: (callback)->
    templateToLoad = _.filter(@templates, (template, name)-> return template.loadOnStart)
    @queue = templateToLoad.length
    _.each(templateToLoad, (template ,name)=>
      @get(template.name, ()=>
        @queue--
        if @queue is 0
          callback()
      )
    )
###
#}}} 
###
      
###
# class Cartographer.ModalBox {{{
###
class Cartographer.Modalbox
  constructor: (idModal) ->
    if _.isString(idModal)
      idModal = ' id="'+idModal+'"'
    else
      idModal = ""
    
    @modal   = $('<div class="modal"'+idModal+'><div class="padding"></div></div>')
    @overlay = $('<span class="overlay"></span>')
    $('body').append(@modal)
    $('body').append(@overlay)

    @overlay.bind('click', @close)

  open: ()->
    @modal.addClass('visible')
    @overlay.addClass('visible')

  close: (callback) =>
    callback = if _.isFunction(callback) then callback else ()->
    @modal.addClass('fadding')
    @overlay.addClass('fadding')
    t = setTimeout(()=>
      @modal.removeClass('visible fadding')
      @overlay.removeClass('visible fadding')
      callback()
    , 150)

  setContent: (content) ->
    @modal.find('.padding').html(content)

###
#}}} 
###

###
# class Cartographer.Confirmbox {{{
###
class Cartographer.Confirmbox extends Cartographer.Modalbox
  constructor: (template) ->
    super
    @modal.addClass('confirm-box')
    @template = template
    @overlay.unbind('click')

  initConfirmation: (contentString, callback)->
    confirmMessage = { confirmMessage : contentString}
    confirmBoxContent = $(@template(confirmMessage))
    acceptBtn = confirmBoxContent.find('#accept')
    deniedBtn = confirmBoxContent.find('#denied')
    @modal.find('.padding').html(confirmBoxContent)

    acceptBtn.bind('click', ()=>
      callback(yes)
      @close()
    )
    deniedBtn.bind('click', ()=>
      callback(no)
      @close()
    )

    @open();
###
#}}} 
###

###
# class Cartographer.CustomMap {{{
###
class Cartographer.CustomMap
  constructor: (HTMLMapWrapperID, opts)->
    # --TODO--
    # Get rid of non-template HTML
    @markersOptionsMenu = $('#markers-options')
    
    @startLat = 15.443090823463786
    @startLng = 7.294921875
    
    @defaultCat = "explore"
    
    #---Globals----
    @localStorageKey  = "gw2c_markers_config_01"
    @blankTilePath = 'tiles/00empty.jpg'
    
    @areaSummaryBoxes = []
    @markersImages = {}
    @mapMarkersObject = {}

    @draggableMarker  = false
    @visibleMarkers   = true
    @canToggleMarkers = true
    @currentOpenedInfoWindow = false
    @activeArea = null

    @currentMapVersion = 1;
    
    @initCustomMap("map")
    
    @editInfoWindowTemplate = _.template(Cartographer.templates.get("customInfoWindow"))
    confirmBoxTemplate = _.template(Cartographer.templates.get("confirmBox"));
    @confirmBox = new Cartographer.Confirmbox(confirmBoxTemplate)
    

    @handleLocalStorageLoad(()=>
      @initializeAreaSummaryBoxes()
      @setAllMarkers()
      @hideMarkersOptionsMenu()
      @bindMapEvents()
      @addMenuIcons()
      @addTools = $('.menu-marker a.add')
      @addTools.each((index, target)=>
        $(target).bind('click', @handleAddTool)
      )
      opts.onLoad()
    )
    
    # google.maps.event.addListenerOnce(@map, 'idle', ()=>
    #       @handleLocalStorageLoad(()=>
    #         

    #         
    #         # UI
    #         $('#destroy').bind('click', @destroyLocalStorage)
    #         $('#send').bind('click', @sendMapForApproval)
    #         
    #         
    #         opts.onLoad()
    #       )
    # )
    
  bindMapEvents: ()->
    @map.on('zoomend', (e)=>
      zoomLevel = e.target._zoom
      if zoomLevel == 4
        # @canToggleMarkers = false
        @hideMarkersOptionsMenu()
        # @setAllMarkersVisibility(false)
        # @setAreasInformationVisibility(true)
        # if @currentOpenedInfoWindow then @currentOpenedInfoWindow.close()
      else if zoomLevel > 4
        # @canToggleMarkers = true
        @showMarkersOptionsMenu()
        # @setAllMarkersVisibility(true)
        # @setAreasInformationVisibility(false)
      else if zoomLevel < 4
        # @canToggleMarkers = false
        @hideMarkersOptionsMenu()
        # @setAllMarkersVisibility(false)
        # @setAreasInformationVisibility(false)
        # if @currentOpenedInfoWindow then @currentOpenedInfoWindow.close()
      
    )
    # google.maps.event.addListener(@map, 'zoom_changed', (e)=>
    #     zoomLevel = @map.getZoom()
    #     if zoomLevel == 4
    #       @canToggleMarkers = false
    #       @hideMarkersOptionsMenu()
    #       @setAllMarkersVisibility(false)
    #       @setAreasInformationVisibility(true)
    #       if @currentOpenedInfoWindow then @currentOpenedInfoWindow.close()
    #     else if zoomLevel > 4
    #       @canToggleMarkers = true
    #       @showMarkersOptionsMenu()
    #       @setAllMarkersVisibility(true)
    #       @setAreasInformationVisibility(false)
    #     else if zoomLevel < 4
    #       @canToggleMarkers = false
    #       @hideMarkersOptionsMenu()
    #       @setAllMarkersVisibility(false)
    #       @setAreasInformationVisibility(false)
    #       if @currentOpenedInfoWindow then @currentOpenedInfoWindow.close()
    # )
    # google.maps.event.addListener(@map, 'click', (e)=>
    #   console.log "Lat : #{e.latLng.lat()}, Lng : #{e.latLng.lng()}"
    # )
    
  highlightMarker: (marker)->
    if @currentOpenedInfoWindow then @currentOpenedInfoWindow.close()
    marker.setVisible(true)
    if !marker.infoWindow?
      @createInfoWindow(marker)
      @currentOpenedInfoWindow = marker.infoWindow
      marker.infoWindow.open()
    else
      marker.infoWindow.open()
      @currentOpenedInfoWindow = marker.infoWindow
  
  panToCoord: (coord)->
    for markersCat, markersObjects of @mapMarkersObject
      for markerType, markerTypeObject of markersObjects.marker_types
        for marker in markerTypeObject.markers
          if coord.lat is marker.position.lat().toString() and coord.lng is marker.position.lng().toString()
            # @highlightMarker(marker)
            marker.trigger('click', ['test'])
            
  panToMarker: (markerId)->
    clickOnMarker = (marker)=>
      time = 0
      if marker.area? and marker.area isnt @activeArea
        marker.area.areaSummary.setActive()
        # time it takes to animate to the marker
        time = 1000
      
      t = setTimeout(()=>
        marker.fire('click', {'src' : 'url'})
      , time)
      
    for markersCat, markersObjects of @mapMarkersObject
      for markerType, markerTypeObject of markersObjects.marker_types
        for marker in markerTypeObject.markers
          if parseInt(markerId) is marker.id_marker
            clickOnMarker(marker)
  
  initCustomMap: (wrap)->
    @map = new L.Map(wrap, 
      center: new L.LatLng(10.044584984211879, 10.3271484375)
      zoom: 4,
      maxZoom: 7,
      minZoom: 3
    )

    tileUrl = 'tiles/{z}_{x}_{y}.jpg'
    layer = new L.TileLayer(tileUrl, {maxZoom: 7})
    @map.addLayer(layer)
      
  
  handleLocalStorageLoad: (callback)->
    if window.LOCAL_STORAGE and @getConfigFromLocalStorage()
      confirmMessage = Traduction["notice"]["localDetected"][LANG]
      @confirmBox.initConfirmation(confirmMessage, (e)=>
        if e
          loadedConfig = @getConfigFromLocalStorage()
          @MarkersConfig = loadedConfig.markers
        else
          @MarkersConfig = Markers
        callback()
      )
    else
      @MarkersConfig = Markers
      callback()
    
  getConfigFromLocalStorage: () ->
    json = localStorage.getItem(@localStorageKey)
    return JSON.parse(json)
  
  addMarker:(markerInfo, otherInfo, isNew, defaultValue) ->
    latLng = new L.LatLng(markerInfo.lat, markerInfo.lng)
    iconsize = 32;
    iconmid = iconsize / 2;
    iconPath = Metadata.icons_path + otherInfo.icon
    markersType = otherInfo["markersType"]
    markersCat = otherInfo["markersCat"]

    markerVisibility = if markersCat is isNew then yes else no
    
    if not @markersImages[markersType]?
      image = new L.icon(
        iconUrl: iconPath,
        iconSize: [iconsize, iconsize],
        iconAnchor: [iconmid, iconmid],
        popupAnchor: [iconmid, iconmid]
      )
      
      @markersImages[markersType] = image
    
    isMarkerDraggable = if markerInfo.draggable? then markerInfo.draggable else false
    
    if defaultValue?
      markerTitle = defaultValue[LANG]["title"] || defaultValue[LANG]["name"]
    else
      markerTitle = markerInfo["data_translation"][LANG]["title"]
    
    options = 
      draggable: isMarkerDraggable
      clickable : true
      icon : @markersImages[markersType]
      title : markerTitle
    marker = new L.Marker(latLng, options)
    
    if defaultValue?
      marker["data_translation"] = defaultValue
      marker["hasDefaultValue"] = true
    else
      marker["data_translation"] = markerInfo["data_translation"]
      marker["hasDefaultValue"] = false

    marker["id_marker"] = markerInfo["id"]
    marker["uniqueID"] =  _.uniqueId()
    marker["type"]  = markersType
    marker["cat"]  = markersCat
    marker["map"] = @map
    
    
    for idArea, area of @areas
      if marker._latlng.lat <= area.neLat and marker._latlng.lat >= area.swLat and marker._latlng.lng <= area.neLng and marker._latlng.lng >= area.swLng
        marker["area"] = area
    # marker["drag"] = new L.Handler.MarkerDrag(marker)
    # console.log marker
    # if !isMarkerDraggable
      # marker.drag.enable()
    # else
      # marker.drag.disable()
    # marker["popUp"]  = new L.popup()
    # marker["popUp"].setLatLng(latLng)
    # marker["popUp"].setContent(markerTitle)
    
    marker.on('click', (e)=>
      if marker.id_marker.toString() isnt "-1" and !e.src?
        lang = if window.LANG is "en" then "" else "fr/"
        console.log "redirection"
        window.location.hash = "/#{lang}show/#{marker.id_marker}/"
      else
        if e.target.popUp?
          e.target.popUp.open()
        else
          @createInfoWindow(e.target)
    )
    marker.on('dragend', (e)=>
      @saveToLocalStorage()
      if e.target.popUp
        e.target.popUp.setLatLng(new L.LatLng(marker._latlng.lat, marker._latlng.lng))
    )
    
    if markerVisibility
      marker.addTo(@map)
    
    marker
    # if markerInfo.lat.toString() is @startLat and markerInfo.lng.toString() is @startLng
      # if not marker["infoWindow"]?
        # @createInfoWindow(marker)
        # marker["infoWindow"].open()
      # else
        # marker["infoWindow"].open()
      
    # google.maps.event.addListener(marker, 'dragend', (e)=>
      # @saveToLocalStorage()
      # if marker["infoWindow"]?
        # marker["infoWindow"].updatePos()
    # )

    # google.maps.event.addListener(marker, 'click', (e)=>
      # if it's not a new marker, simply change the hash so that our router
      # handle the rest.
      # if marker.id_marker.toString() isnt "-1"
        # lang = if window.LANG is "en" then "" else "fr/"
        # window.location.hash = "/#{lang}show/#{marker.id_marker}/"
      # else
        # @createInfoWindow(marker)
        # if @currentOpenedInfoWindow then @currentOpenedInfoWindow.close()
        # marker["infoWindow"].open()
    # )
  
  createInfoWindow: (marker)=>
    # console.log marker
    lang = if window.LANG is "en" then "#/" else "#/fr/"
    templateInfo = 
      id : marker.uniqueID
      title: (()=>
        if marker["data_translation"][LANG]["title"] || marker["data_translation"][LANG]["name"]
          return marker["data_translation"][LANG]["title"] || marker["data_translation"][LANG]["name"]
        else if marker.type is "vistas" || marker.type is "skillpoints"
          return Traduction["infoWindow"][marker.type][LANG]
        else
          return ""
      )()
      desc: marker["data_translation"][LANG]["desc"]
      wikiLink  : marker["data_translation"][LANG]["link_wiki"] || ""
      hasDefaultValue : marker["hasDefaultValue"]
      type  : marker.type
      lat   : marker._latlng.lat
      lng   : marker._latlng.lng
      shareLink: "http://#{window.location.hostname}/#{lang}show/#{marker.id_marker}/"
    editInfoWindowContent = @editInfoWindowTemplate(templateInfo)
    marker["popUp"] = new CustomInfoWindow(marker, editInfoWindowContent,
      onSave  : (newInfo)=>
        @updateMarkerInfos(newInfo)
      deleteCalled : (marker)=>
        @removeMarker(marker.uniqueID, marker.type, marker.cat)
      moveCalled : (marker) =>
        if marker.dragging.enabled()
          marker.dragging.disable()
        else
          marker.dragging.enable()
      template : @editInfoWindowTemplate
    )
       
  setAllMarkers: () ->
    @currentMapVersion = Metadata.version;    
    for markersCat, markersObjects of @MarkersConfig
      if not @mapMarkersObject[markersCat]?
        @mapMarkersObject[markersCat] = {}
        @mapMarkersObject[markersCat]["data_translation"] = markersObjects.data_translation
        @mapMarkersObject[markersCat]["marker_types"] = {}
        
      for markerType, markerTypeObject of markersObjects.marker_types
        # Cloning markerTypeObject
        @mapMarkersObject[markersCat]["marker_types"][markerType] = $.extend(true, {}, markerTypeObject)
        @mapMarkersObject[markersCat]["marker_types"][markerType]["markers"] = []

        otherInfo = 
          markersCat : markersCat
          markersType : markerType
          icon       : markerTypeObject.icon
        
        defaultValue = null
        
        if markerTypeObject["data_translation"][LANG]["title"]? and markerTypeObject["data_translation"][LANG]["desc"]?
          defaultValue = markerTypeObject["data_translation"]
          
        # Pushing the returned marker of the method addMarker into the right spot of our gMarker object
        for marker in markerTypeObject.markers
          newMarker = @addMarker(marker, otherInfo, false, defaultValue)
          @mapMarkersObject[markersCat]["marker_types"][markerType]["markers"].push(newMarker)
        
  showMarkerFromArea: (areaId)->
    if @activeArea
      @activeArea.areaSummary.setInactive()
    @activeArea = @areas[areaId]
    for cat, markersObjects of @mapMarkersObject
      for markerType, markerTypeObject of markersObjects.marker_types when not $("[data-type='#{markerType}']").hasClass('off')
        for marker in markerTypeObject["markers"] when marker?
          lat = marker.getLatLng().lat
          lng = marker.getLatLng().lng
          if lat <= @activeArea.neLat and lat >= @activeArea.swLat and lng <= @activeArea.neLng and lng >= @activeArea.swLng
            marker.addTo(@map)
          else
            @map.removeLayer(marker)
            if marker["popUp"]
              @map.removeLayer(marker["popUp"])
             
  setAllMarkersVisibility:(isVisible)->
    for cat, markersObjects of @mapMarkersObject
      @setMarkersVisibilityByType(isVisible, markerType, cat) for markerType, markerTypeObject of markersObjects.marker_types when not $("[data-type='#{markerType}']").hasClass('off')

  setMarkersVisibilityByType:(isVisible, type, cat)->
    for marker in @mapMarkersObject[cat]["marker_types"][type]["markers"] when marker?
      if marker.popUp?
        @map.removeLayer(marker.popUp)
      lat = marker.getLatLng().lat
      lng = marker.getLatLng().lng
      if isVisible and marker? and lat <= @activeArea.neLat and lat >= @activeArea.swLat and lng <= @activeArea.neLng and lng >= @activeArea.swLng
        marker.addTo(@map) if !marker._map?
      else
        @map.removeLayer(marker) if marker._map?
  
  setMarkersVisibilityByCat:(isVisible, cat)->
    for markerType, markerTypeObject of @mapMarkersObject[cat]["marker_types"]
      for marker in markerTypeObject.markers
        if marker.popUp?
          @map.removeLayer(marker.popUp)
        lat = marker.getLatLng().lat
        lng = marker.getLatLng().lng
        if isVisible and lat <= @activeArea.neLat and lat >= @activeArea.swLat and lng <= @activeArea.neLng and lng >= @activeArea.swLng
            marker.addTo(@map) if !marker._map?
        else
            @map.removeLayer(marker) if marker._map?

  highlightsCat:(cats)->
    for markerCat, markerCatObject of @mapMarkersObject
      @setMarkersVisibilityByCat(off, markerCat)
      @turnOffMenuIconsFromCat(markerCat)
      for cat in cats when markerCat is cat
          @turnOnMenuIconsFromCat(cat)
          if @canToggleMarkers is on
            @setMarkersVisibilityByCat(on, cat)
        
  destroyLocalStorage: (e) =>
    confirmMessage = Traduction["notice"]["dataDestruction"][LANG]
    @confirmBox.initConfirmation(confirmMessage, (e)=>
      if e and @getConfigFromLocalStorage()
        localStorage.removeItem(@localStorageKey);
        window.location = "/"
    )
  sendMapForApproval: (e) =>
    this_ = $(e.currentTarget)
    ajaxUrl = this_.attr('data-ajaxUrl')
    modal = new Cartographer.Modalbox("waiting")
    confirmMessage = Traduction["notice"]["dataApproval"][LANG]
    @confirmBox.initConfirmation(confirmMessage, (e)=>
      if(e == true)
        modal.setContent('<h1 text-align: center;>Please wait while your request is being handled.</h1><img class="loading" src="/assets/images/loading-black.gif"><p style="text-align: center;">This could take a few seconds</p>')
        modal.open()
        request = $.ajax({
          url: ajaxUrl,
          type: "POST",
          dataType: 'json',
          crossDomain: true,
          data: { "json" : _this.handleExport() },
          beforeSend: (x) =>
              if x && x.overrideMimeType
                  x.overrideMimeType("application/json;charset=UTF-8")
           ,
           success: (result) =>
               if result.success is true
                   localStorage.removeItem(@localStorageKey);
               modal.setContent(result.message)
               modal.open()
          })
    )

  handleExport:(e)=>
    exportMarkerObject = {}
    for markersCat, markersObjects of @mapMarkersObject
      if not exportMarkerObject[markersCat]?
        exportMarkerObject[markersCat] = {}
        exportMarkerObject[markersCat]["data_translation"] = markersObjects["data_translation"]
        exportMarkerObject[markersCat]["marker_types"] = {}
        
      for markerType, markerTypeObject of markersObjects.marker_types
        exportMarkerObject[markersCat]["marker_types"][markerType] = $.extend(true, {}, markerTypeObject)
        exportMarkerObject[markersCat]["marker_types"][markerType]["markers"] = []

        for marker in markerTypeObject.markers
          if marker["data_translation"]?
            nm = 
              "lng" : marker._latlng.lng
              "lat" : marker._latlng.lat
              "data_translation" : $.extend(true, {}, marker["data_translation"])
          else
            nm = 
              "lng" : marker._latlng.lng
              "lat" : marker._latlng.lat
 
          exportMarkerObject[markersCat]["marker_types"][markerType]["markers"].push(nm)
          nm["id"] = marker["id_marker"];

    finalExport = {};
    finalExport["version"] = @currentMapVersion;
    finalExport["creation_date"] = "null";
    finalExport["markers"] = exportMarkerObject;

    jsonString = JSON.stringify(finalExport);
    return jsonString
    
  handleAddTool: (e)=>
    this_      = $(e.currentTarget)
    parent     = this_.closest('.type-menu-item')
    markerLink = parent.find('.marker-type-link')
    markerType = markerLink.attr('data-type')
    markerCat  = markerLink.attr('data-cat')
    icon       = markerLink.attr('data-icon')
    coord      = @map.getCenter()
    getValue = (cat, type)=>
      defaultValue = null
      defaultDesc = @MarkersConfig[cat]["marker_types"][type]["data_translation"][LANG]["desc"]
      defaultTitle = @MarkersConfig[cat]["marker_types"][type]["data_translation"][LANG]["title"] or @MarkersConfig[cat]["marker_types"][type]["data_translation"][LANG]["name"]
      if (defaultDesc? or defaultTitle is "") and defaultTitle?
        defaultValue = $.extend(true, {}, @MarkersConfig[cat]["marker_types"][type]["data_translation"])
      return defaultValue
    
    defaultValue = getValue(markerCat, markerType)
    otherInfo =
      markersCat : markerCat
      markersType : markerType
      icon : icon
    
    if defaultValue
      newMarkerInfo =
        id        : -1
        lat       : coord.lat()
        lng       : coord.lng()
        draggable : true
    else
      newMarkerInfo =
        id        : -1
        lat       : coord.lat()
        lng       : coord.lng()
        data_translation : 
          en :
            title: ""
            desc: ""
            wikiLink: ""
          fr :
            title: ""
            desc: ""
            wikiLink: ""
        draggable : true

    newMarker = @addMarker(newMarkerInfo, otherInfo, true, defaultValue)
    @mapMarkersObject[markerCat]["marker_types"][markerType]["markers"].push(newMarker)
    
  removeMarker:(id, mType, mCat)->
    confirmMessage = Traduction["notice"]["deleteMarker"][LANG]
    @confirmBox.initConfirmation(confirmMessage, (e)=>
      if e
        for marker, markerKey in @mapMarkersObject[mCat]["marker_types"][mType]["markers"] when marker.uniqueID is id
          if marker.popUp?
            @map.removeLayer(marker.popUp)
          @map.removeLayer(marker)

          @mapMarkersObject[mCat]["marker_types"][mType]['markers'] = _.reject(@mapMarkersObject[mCat]["marker_types"][mType]["markers"], (m) =>
            return m == marker
          )

          @saveToLocalStorage()
          return true
    )
  
  updateMarkerInfos: (newInfo)->
    for marker, markerKey in @mapMarkersObject[newInfo.cat]["marker_types"][newInfo.type]["markers"] when marker.uniqueId is newInfo.id
      if marker["data_translation"]?
        marker["data_translation"][LANG]["desc"] = newInfo.desc
        marker["data_translation"][LANG]["title"] = newInfo.title
        marker["data_translation"][LANG]["link_wiki"] = newInfo.wikiLink 
      else
        marker.desc = newInfo.desc
        marker.title = newInfo.title
        marker.wikiLink = newInfo.wikiLink
        
      @saveToLocalStorage()
      return
        
  
  saveToLocalStorage: ()->
    # Save new exported JSON to local storage if it is supported
    if window.LOCAL_STORAGE
      json = @handleExport()
      localStorage.setItem(@localStorageKey, json);

  getMarkerByCoordinates:(lat, lng)->
    for markersCat, markersObjects of @MarkersConfig
      for markerTypeObject, key in markersObjects.marker_types
        return marker for marker in markerTypeObject.markers when marker.lat is lat and marker.lng is lng
    return false  
      
  turnOffMenuIconsFromCat:(markerCat)->
    menu = $(".menu-item[data-markerCat='#{markerCat}']")
    menu.addClass('off')
    menu.find('.group-toggling').addClass('off')
    menu.find('.trigger').addClass('off')
  
  turnOnMenuIconsFromCat: (markerCat)->
    menu = $(".menu-item[data-markerCat='#{markerCat}']")
    menu.removeClass('off')
    menu.find('.group-toggling').removeClass('off')
    menu.find('.trigger').removeClass('off')
    
  addMenuIcons:()->
    template = _.template(Cartographer.templates.get("markersOptions"));
    html = $(template(@MarkersConfig))
    
    # Binding click on marker icon in markers option list
    html.find(".trigger").bind 'click', (e) =>
      item           = $(e.currentTarget)
      myGroupTrigger = item.closest(".menu-marker").find('.group-toggling')
      myMenuItem     = item.closest(".menu-item")
      markerType     = item.attr('data-type')
      markerCat      = item.attr('data-cat')

      if @canToggleMarkers
        if item.hasClass('off')
          @setMarkersVisibilityByType(true, markerType, markerCat)
          item.removeClass('off')
          myMenuItem.removeClass('off')
          myGroupTrigger.removeClass('off')
        else
          @setMarkersVisibilityByType(false, markerType, markerCat)
          item.addClass('off')
    
    html.find('.group-toggling').bind 'click', (e)=>
      this_ = $(e.currentTarget)
      menuItem = this_.closest('.menu-item')
      markerCat = menuItem.attr('data-markerCat')
      if this_.hasClass('off')
        this_.removeClass('off')
        menuItem.removeClass('off')
        @setMarkersVisibilityByCat(on, markerCat)
        menuItem.find('.trigger').removeClass('off')
      else
        this_.addClass('off')
        menuItem.addClass('off')
        @setMarkersVisibilityByCat(off, markerCat)
        menuItem.find('.trigger').addClass('off')
          
    @markersOptionsMenu.find('.padding').prepend(html)
    @turnOffMenuIconsFromCat(markerCat) for markerCat of @MarkersConfig when markerCat isnt @defaultCat
      
  initializeAreaSummaryBoxes:()->
    @areas = {}
    Cartographer.templates.get("areasSummary", (e)=>
      for key, area of Areas
        @areas[area.id] = area
        @areas[area.id]['areaSummary'] = new AreaSummary(@map, area, e, @)
    )
  
    
  setAreasInformationVisibility:(isVisible)->
    for box in @areaSummaryBoxes
      box.setVisible(isVisible)
  
  toggleMarkersOptionsMenu: () ->
    @markersOptionsMenu.toggleClass('active')
  hideMarkersOptionsMenu: () ->
    @markersOptionsMenu.addClass('off')
  showMarkersOptionsMenu: () ->
    @markersOptionsMenu.removeClass('off')

###
# }}}
###

###
# class AreaSummary {{{
#
###
class AreaSummary
  constructor:(map, area, template, carto)->
    southWest = new L.LatLng(area.swLat, area.swLng)
    northEast = new L.LatLng(area.neLat, area.neLng)
    @bounds = new L.LatLngBounds(southWest, northEast)
    @map = map
    @carto = carto
    @areaInfo = area
    @defaultStyle =
      color: "black"
      weight: 4,
      fill: true,
      fillOpacity: 0.5

    @activeStyle = 
      color: "black"
      weight: 4
      fill: false 
    # create an orange rectangle
    @rect = new L.rectangle(@bounds, @defaultStyle).addTo(map)
    @rect.on('click', (e)=>
      map.fitBounds(@bounds)
      t = setTimeout(()=>
        map.setZoom(6)
      , 500)
    )
    
    @template = _.template(template)
    stringPopupContent = @template(@areaInfo)
    popupContent = $(stringPopupContent)
    popupContent.appendTo('html').hide()
    myIcon = new L.divIcon(
      className: 'area-summary'
      html : stringPopupContent
      iconSize: new L.Point(popupContent.outerWidth() , popupContent.outerHeight())
    )
    @area = new L.marker(@bounds.getCenter(), {icon: myIcon})
    @area.on('click', (e)=>
      @setActive()
    )
    @area.addTo(map)

  setActive:(callback)->
    @map.removeLayer(@area)
    @map.panTo(@bounds.getCenter())
    t = setTimeout(()=>
      @map.setZoom(6)
      @rect.setStyle(@activeStyle)
      @carto.showMarkerFromArea(@areaInfo.id)
      callback() if callback?
    , 500)
    
   setInactive:()->
      @area.addTo(@map)
      @rect.setStyle(@defaultStyle)
###
# }}}
###                

###
# class CustomInfoWindow {{{
###

class CustomInfoWindow
  constructor: (marker, content, opts) ->
    console.log marker
    @content = content
    @marker  = marker
    @template = opts.template
    @map     = marker.map
    
    @latLng = new L.LatLng(marker._latlng.lat, marker._latlng.lng)

    wrap = """
    <div class="customInfoWindow">
       <div class="padding"></div>
    </div>
    """
    @wrap = $(wrap)
    @wrap.find('.padding').append(@content)
    @closeBtn = @wrap.find('.close')
    
    @isVisible = false
    @onSave    = opts.onSave
    @deleteCalled = opts.deleteCalled
    @moveCalled = opts.moveCalled
    
    @setLatLng(@latLng)
    @currentContent = @wrap.clone()
    @setContent(@currentContent[0])

    @map.openPopup(@)
    @bindButton()
    # @closeBtn.bind('click', @close)

  CustomInfoWindow:: = new L.popup({
    autoPanPadding : new L.Point(120, 120)
    offset: new L.Point(0, -6)
  })
  
  open: ()->
    @.openOn(@map)

  bindButton: () ->
    @currentContent.find('button').bind('click', @handleSave)
    @currentContent.find('.iw-options-list .button').bind('click', (e)=>
      @toggleSection(e)
    )
  
  toggleSection: (e) =>
    # console.log "toggleSection"
    this_ = $(e.currentTarget)
    mywrap = this_.closest('.customInfoWindow')
    action = this_.attr('data-action')
    defaultTab = mywrap.find('.marker-desc')
    activeTab = mywrap.find('.toggling-tab.active') 
    targetTab = mywrap.find("[data-target='#{action}']")
    
    switch action
      when "move", "share", "edit"
        mywrap.find('.iw-options-list .button').removeClass('active')
        if targetTab.attr("data-target") is activeTab.attr("data-target")
          targetTab.removeClass('active')
          defaultTab.addClass('active')
          @._update()
        else
          this_.addClass('active')
          activeTab.removeClass('active')
          targetTab.addClass('active')
          defaultTab.removeClass('active')
          @._update()
      when "delete"
        @deleteCalled(@marker)
 
    if action is "move"
      @moveCalled(@marker)
 
  handleSave: (e) =>
    this_ = $(e.currentTarget)
    form = @currentContent.find('.edit-form')
    newTitle = @currentContent.find('[name="marker-title"]').val()
    newDesc = @currentContent.find('[name="marker-description"]').val()
    newDesc = newDesc.replace(/\n/g, '<br />');
    newWikiLink = @currentContent.find('[name="marker-wiki"]').val()
    form.removeClass('active')

    lang = if window.LANG is "en" then '#/' else "#/fr/"
    newInfo = 
      id    : @marker.uniqueId
      title : newTitle
      desc  : newDesc
      wikiLink : newWikiLink
      type : @marker.type
      cat  : @marker.cat
      lat  : @marker.getLatLng().lat
      lng  : @marker.getLatLng().lng
      shareLink: "http://#{window.location.hostname}/#{lang}show/#{@marker.id_marker}/"
      hasDefaultValue : @marker["hasDefaultValue"]
    
    @wrap.find('.padding').html(@template(newInfo))
    @currentContent = @wrap.clone()
    @setContent(@currentContent[0])
    @bindButton()
    @currentContent.find('.edit').removeClass('active')
    @._update()
    @onSave(newInfo)
 # 
 # panMap: () -> 
 #   @map.panTo(new google.maps.LatLng(@marker.position.lat(), @marker.position.lng()));

###
# }}}
###

# }}}

#################
#----ROUTER------
##############{{{
Cartographer.router = Backbone.Router.extend(
  routes: {}
  initialize: ()->
    routes = [
      [ /^\/*(en|fr)\/*$/, 'lang', this.handleLang ]
      [ /^\/*(en|fr)*\/*show\/([0-9]+)\/*$/, 'show', this.handleShow ]
      [ /^\/*(en|fr)*\/*lat\/([\-0-9.]+)\/lng\/([\-0-9.]+)\/*$/, 'coord', this.handleCoord ]
      [ /^\/*(en|fr)*\/*cat\/([a-zA-Z&]+)\/*$/, 'categories', this.handleCat ]
      [ /^\/*(en|fr)*\/*info\/*$/, 'info', this.handleInfo ]
    ]
    _.each(routes, (route)=>
      this.route.apply(this,route)
    )
    
    Backbone.history.start()
    
  handleLang: (lang)->
    Cartographer.switchLang(lang)
    
  handleCat: (lang, a)->
    if lang?
      @handleLang(lang)
    Cartographer.toggleCat(a.split('&'))
  handleShow: (lang, id)->
    if lang?
      @handleLang(lang)
    Cartographer.highlighMarker(id)
  handleCoord: (lang, lat, lng)->
    if lang?
      @handleLang(lang)
    Cartographer.highlighMarker(
      lat : lat
      lng : lng
    )
  
  handleInfo: (lang)->
    if lang?
      @handleLang(lang)
    Cartographer.showInfo()
) 
# }}}

$ ()->
  Cartographer.initiate()