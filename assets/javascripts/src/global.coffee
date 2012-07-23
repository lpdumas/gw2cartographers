window.App = {}
App.opacity = false
App.pointerEvents = false
App.localStorageAvailable = (()->
  if window['localStorage']?
    return true
  else
    return false
)()
App.extractUrlParams = ()->
  parameters = location.search.substring(1).split('&')
  urlArray = {}
  for element in parameters
    x = element.split('=')      
    urlArray[x[0]] = x[1]
  urlArray

html = document.documentElement
attToCheck = ["pointerEvents", "opacity"]
for att in attToCheck 
  if html.style[att]?
    $(html).addClass(att)
    App[att] = true
  else
    $(html).addClass("no-#{att}") 
###
# class ModalBox {{{
###
class Modalbox
  constructor: () ->
    @modal   = $('<div class="modal"><div class="padding"></div></div>')
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
# class Confirmbox {{{
###
class Confirmbox extends Modalbox
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
# classCustomMap {{{
###
class CustomMap
  constructor: (id)->
    @localStorageKey  = "gw2c_markers_config_01"
    
    @blankTilePath = 'tiles/00empty.jpg'
    @iconsPath     = 'assets/images/icons/32x32'
    @maxZoom       = 7
    @appState      = "read"
    # HTML element
    @html             = $('html')
    @lngContainer     = $('#long')
    @latContainer     = $('#lat')
    @devModInput      = $('#dev-mod')
    @addMarkerLink    = $('#add-marker')

    @exportBtn        = $('#export')
    @exportWindow     = $('#export-windows')
    @markersOptionsMenu = $('#markers-options')
    @mapOptions    = $('#edition-tools a')
    # @defaultLat = 15.919073517982465    # @defaultLng = 18.28125
    @urlParams = App.extractUrlParams()
    @startLat = if @urlParams['lat']? then @urlParams['lat'] else 26.765230565697536
    @startLng = if @urlParams['lgn']? then @urlParams['lng'] else -36.32080078125
    @defaultCat = (()=>
      dcat = "explore"
      if @urlParams['cat']?
        for cat, catObject of Markers
          if cat is @urlParams['cat']
            dcat = @urlParams['cat']
      dcat
    )()
    window.LANG = (()=>
      if @urlParams['lang']? and (@urlParams['lang'] is 'fr' or @urlParams['lang'] is 'en')
        return @urlParams['lang']
      else
        return "en"
    )()
    @areaSummaryBoxes = []
    @markersImages = {}
    
    @draggableMarker  = false
    @visibleMarkers   = true
    @canToggleMarkers = true
    @currentOpenedInfoWindow = false
    @gMapOptions   = 
      center: new google.maps.LatLng(@startLat, @startLng)
      zoom: 6
      minZoom: 3
      maxZoom: @maxZoom
      streetViewControl: false
      mapTypeControl: false
      mapTypeControlOptions:
        mapTypeIds: ["custom", google.maps.MapTypeId.ROADMAP]

      panControl: false
      zoomControl: true
      zoomControlOptions:
        position: google.maps.ControlPosition.LEFT_CENTER
        zoomControlStyle: google.maps.ZoomControlStyle.SMALL
        
    @customMapType = new google.maps.ImageMapType(
      getTileUrl : (coord, zoom)=>
        normalizedCoord = coord
        if normalizedCoord && (normalizedCoord.x < Math.pow(2, zoom)) && (normalizedCoord.x > -1) && (normalizedCoord.y < Math.pow(2, zoom)) && (normalizedCoord.y > -1)
          path = 'tiles/' + zoom + '_' + normalizedCoord.x + '_' + normalizedCoord.y + '.jpg'
        else 
          return @blankTilePath
      tileSize: new google.maps.Size(256, 256)
      maxZoom: @maxZoom
      name: 'GW2 Map'
    )
    
    @map = new google.maps.Map($(id)[0], @gMapOptions)
    @map.mapTypes.set('custom', @customMapType)
    @map.setMapTypeId('custom')

    $.get('assets/javascripts/templates/confirmBox._', (e)=>
      template = _.template(e);
      @confirmBox = new Confirmbox(template)
    
      @handleLocalStorageLoad(()=>
        @addMenuIcons(()=>
          @addTools = $('.menu-marker a.add')
          @addTools.each((index, target)=>
            $(target).bind('click', @handleAddTool)
          )
        )
        
        google.maps.event.addListener(@map, 'zoom_changed', (e)=>
            zoomLevel = @map.getZoom()
            if zoomLevel == 4
              @canToggleMarkers = false
              @hideMarkersOptionsMenu()
              @setAllMarkersVisibility(false)
              @setAreasInformationVisibility(true)
              if @currentOpenedInfoWindow then @currentOpenedInfoWindow.close()
            else if zoomLevel > 4
              @canToggleMarkers = true
              @showMarkersOptionsMenu()
              @setAllMarkersVisibility(true)
              @setAreasInformationVisibility(false)
            else if zoomLevel < 4
              @canToggleMarkers = false
              @hideMarkersOptionsMenu()
              @setAllMarkersVisibility(false)
              @setAreasInformationVisibility(false)
              if @currentOpenedInfoWindow then @currentOpenedInfoWindow.close()
        )
    
        #marker
        @gMarker = {}
        @currentMapVersion = 1;

        @editInfoWindowTemplate = ""
        $.get('assets/javascripts/templates/customInfoWindow._', (e)=>
          @editInfoWindowTemplate = _.template(e)
          
          @setAllMarkers()
          @initializeAreaSummaryBoxes()
          google.maps.event.addListener(@map, 'click', (e)=>
            console.log "Lat : #{e.latLng.lat()}, Lng : #{e.latLng.lng()}"
          )
          # UI
          $('#destroy').bind('click', @destroyLocalStorage)
          $('#send').bind('click', @sendMapForApproval)
          
        )
      )
    )
    
  handleLocalStorageLoad: (callback)->
    if App.localStorageAvailable and @getConfigFromLocalStorage()
      confirmMessage = Traduction["notice"]["localDetected"][window.LANG]
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

    createInfoWindow = (marker) =>
      templateInfo = 
        id : marker.__gm_id
        title: marker["data_translation"][window.LANG]["title"] || marker["data_translation"][window.LANG]["name"]
        desc: marker["data_translation"][window.LANG]["desc"]
        wikiLink  : marker["data_translation"][window.LANG]["link_wiki"]
        hasDefaultValue : marker["hasDefaultValue"]
        type  : marker.type
        lat   : marker.position.lat()
        lng   : marker.position.lng()
      editInfoWindowContent = @editInfoWindowTemplate(templateInfo)
      marker["infoWindow"] = new CustomInfoWindow(marker, editInfoWindowContent,
        onClose : () =>
          @currentOpenedInfoWindow = null
        onOpen  : (infoWindow) =>
          @currentOpenedInfoWindow = infoWindow
        onSave  : (newInfo)=>
          @updateMarkerInfos(newInfo)
        deleteCalled : (marker)=>
          @removeMarker(marker.__gm_id, markersType, markersCat)
        moveCalled : (marker) =>
          if marker.getDraggable()
            marker.setDraggable(false)
            marker.setCursor("pointer")
          else
            marker.setDraggable(true)
            marker.setCursor("move")
        template : @editInfoWindowTemplate
      )
      
    iconsize = 32;
    iconmid = iconsize / 2;
    iconPath = Metadata.icons_path + otherInfo.icon
    markersType = otherInfo["markersType"]
    markersCat = otherInfo["markersCat"]
    markerVisibility = if markersCat is @defaultCat || isNew then yes else no
    
    if not @markersImages[markersType]?
      image = new google.maps.MarkerImage(iconPath, null, null, new google.maps.Point(iconmid,iconmid), new google.maps.Size(iconsize, iconsize));
      @markersImages[markersType] = image
    
    isMarkerDraggable = if markerInfo.draggable? then markerInfo.draggable else false
    
    if defaultValue?
      markerTitle = defaultValue[window.LANG]["title"] || defaultValue[window.LANG]["name"]
    else
      markerTitle = markerInfo["data_translation"][window.LANG]["title"]
    marker = new google.maps.Marker(
      position: new google.maps.LatLng(markerInfo.lat, markerInfo.lng)
      map: @map
      icon: @markersImages[markersType]
      visible: markerVisibility
      draggable: isMarkerDraggable
      cursor : if isMarkerDraggable then "move" else "pointer"
      title: markerTitle
      animation: if isNew then google.maps.Animation.DROP else no
    )

    if defaultValue?
      marker["data_translation"] = defaultValue
      marker["hasDefaultValue"] = true
    else
      marker["data_translation"] = markerInfo["data_translation"]
      marker["hasDefaultValue"] = false

    marker["id_marker"] = markerInfo["id"]
    marker["type"]  = markersType
    marker["cat"]  = markersCat

    if markerInfo.lat.toString() is @startLat and markerInfo.lng.toString() is @startLng
      if not marker["infoWindow"]?
        createInfoWindow(marker)
        marker["infoWindow"].open()
      else
        marker["infoWindow"].open()
        
    google.maps.event.addListener(marker, 'dragend', (e)=>
      @saveToLocalStorage()
      if marker["infoWindow"]?
        marker["infoWindow"].updatePos()
    )

    google.maps.event.addListener(marker, 'click', (e)=>
      if marker["infoWindow"]?
        if @currentOpenedInfoWindow is marker["infoWindow"]
          @currentOpenedInfoWindow.close()
          
        else
          if @currentOpenedInfoWindow then @currentOpenedInfoWindow.close()
          marker["infoWindow"].open()
      else  
        createInfoWindow(marker)
        if @currentOpenedInfoWindow then @currentOpenedInfoWindow.close()
        marker["infoWindow"].open()
    )
    
    # markerType["markers"].push(marker) for markerType in @gMarker[markersCat]["marker_types"] when markerType.slug is markersType
    marker
          
  setAllMarkers: () ->

    @currentMapVersion = Metadata.version;
    
    for markersCat, markersObjects of @MarkersConfig
      if not @gMarker[markersCat]?
        @gMarker[markersCat] = {}
        @gMarker[markersCat]["data_translation"] = markersObjects.data_translation
        @gMarker[markersCat]["marker_types"] = {}
        
      for markerType, markerTypeObject of markersObjects.marker_types
        # Cloning markerTypeObject
        @gMarker[markersCat]["marker_types"][markerType] = $.extend(true, {}, markerTypeObject)
        @gMarker[markersCat]["marker_types"][markerType]["markers"] = []

        otherInfo = 
          markersCat : markersCat
          markersType : markerType
          icon       : markerTypeObject.icon
        
        defaultValue = null
        
        if markerTypeObject["data_translation"][window.LANG]["title"]? and markerTypeObject["data_translation"][window.LANG]["desc"]?
          defaultValue = markerTypeObject["data_translation"]
          
        # Pushing the returned marker of the method addMarker into the right spot of our gMarker object
        for marker in markerTypeObject.markers
          newMarker = @addMarker(marker, otherInfo, false, defaultValue)
          @gMarker[markersCat]["marker_types"][markerType]["markers"].push(newMarker)
        
  setAllMarkersVisibility:(isVisible)->
    for cat, markersObjects of @gMarker
      @setMarkersVisibilityByType(isVisible, markerType, cat) for markerType, markerTypeObject of markersObjects.marker_types when not $("[data-type='#{markerType}']").hasClass('off')

  setMarkersVisibilityByType:(isVisible, type, cat)->
    marker.setVisible(isVisible) for marker in @gMarker[cat]["marker_types"][type]["markers"]

  
  setMarkersVisibilityByCat:(isVisible, cat)->
    for markerType, markerTypeObject of @gMarker[cat]["marker_types"]
      marker.setVisible(isVisible) for marker in markerTypeObject.markers

  destroyLocalStorage: (e) =>
    confirmMessage = Traduction["notice"]["dataDestruction"][window.LANG]
    @confirmBox.initConfirmation(confirmMessage, (e)=>
      if e and @getConfigFromLocalStorage()
        localStorage.removeItem(@localStorageKey);
        window.location = "/"
    )
  sendMapForApproval: (e) =>
    this_ = $(e.currentTarget)
    ajaxUrl = this_.attr('data-ajaxUrl')
    modal = new Modalbox()
    confirmMessage = Traduction["notice"]["dataApproval"][window.LANG]
    @confirmBox.initConfirmation(confirmMessage, (e)=>
      if(e == true)
        modal.setContent('<h1>Please wait while your request is being handled.</h1><img class="loading" src="/assets/images/loading-black.gif">')
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
    for markersCat, markersObjects of @gMarker
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
              "lng" : marker.getPosition().lng()
              "lat" : marker.getPosition().lat()
              "data_translation" : $.extend(true, {}, marker["data_translation"])
          else
            nm = 
              "lng" : marker.getPosition().lng()
              "lat" : marker.getPosition().lat()
 
          exportMarkerObject[markersCat]["marker_types"][markerType]["markers"].push(nm)
          nm["id"] = marker["id_marker"];

    finalExport = {};
    finalExport["version"] = @currentMapVersion;
    finalExport["creation_date"] = "null";
    finalExport["markers"] = exportMarkerObject;

    jsonString = JSON.stringify(finalExport);
    # console.log jsonString
    return jsonString
    # @exportWindow.find('.content').html(jsonString)
    # @exportWindow.show();
    
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
      defaultDesc = @MarkersConfig[cat]["marker_types"][type]["data_translation"][window.LANG]["desc"]
      defaultTitle = @MarkersConfig[cat]["marker_types"][type]["data_translation"][window.LANG]["title"] or @MarkersConfig[cat]["marker_types"][type]["data_translation"][window.LANG]["name"]
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
    @gMarker[markerCat]["marker_types"][markerType]["markers"].push(newMarker)
    
  removeMarker:(id, mType, mCat)->
    confirmMessage = Traduction["notice"]["deleteMarker"][window.LANG]
    @confirmBox.initConfirmation(confirmMessage, (e)=>
      if e
        for marker, markerKey in @gMarker[mCat]["marker_types"][mType]["markers"] when marker.__gm_id is id
          if marker.infoWindow?
            marker.infoWindow.setMap(null)
          marker.setMap(null)
          @gMarker[mCat]["marker_types"][mType]['markers'] = _.reject(@gMarker[mCat]["marker_types"][mType]["markers"], (m) =>
            return m == marker
            # return m.__gm_id == id
          )
          @saveToLocalStorage()
          return true
    )
  
  updateMarkerInfos: (newInfo)->
    for marker, markerKey in @gMarker[newInfo.cat]["marker_types"][newInfo.type]["markers"] when marker.__gm_id is newInfo.id
      if marker["data_translation"]?
        marker["data_translation"][window.LANG]["desc"] = newInfo.desc
        marker["data_translation"][window.LANG]["title"] = newInfo.title
        marker["data_translation"][window.LANG]["link_wiki"] = newInfo.wikiLink 
      else
        marker.desc = newInfo.desc
        marker.title = newInfo.title
        marker.wikiLink = newInfo.wikiLink
        
      @saveToLocalStorage()
      return
        
  
  saveToLocalStorage: ()->
    # Save new exported JSON to local storage if it is supported
    if App.localStorageAvailable
      json = @handleExport()
      localStorage.setItem(@localStorageKey, json);

  getMarkerByCoordinates:(lat, lng)->
    for markersCat, markersObjects of @MarkersConfig
      for markerTypeObject, key in markersObjects.marker_types
        return marker for marker in markerTypeObject.markers when marker.lat is lat and marker.lng is lng
    return false  
      
  turnOfMenuIconsFromCat:(markerCat)->
    menu = $(".menu-item[data-markerCat='#{markerCat}']")
    menu.addClass('off')
    menu.find('.group-toggling').addClass('off')
    menu.find('.trigger').addClass('off')
  
  addMenuIcons:(callback)->
    markersOptions = $.get('assets/javascripts/templates/markersOptions._', (e)=>
      template = _.template(e);
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
      callback()
      @turnOfMenuIconsFromCat(markerCat) for markerCat of @MarkersConfig when markerCat isnt @defaultCat
    )
      
  initializeAreaSummaryBoxes:()->
    for area of Areas
        @areaSummaryBoxes[area] = new AreaSummary(@map, Areas[area])
        
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
###
class AreaSummary
    constructor:(map, area)->
        swBound = new google.maps.LatLng(area.swLat, area.swLng)
        neBound = new google.maps.LatLng(area.neLat, area.neLng)
        @bounds_ = new google.maps.LatLngBounds(swBound, neBound)
        @area_ = area
        @div_ = null
        @height_ = 80
        @width_ = 150
        @template = ""
        $.get('assets/javascripts/templates/areasSummary._', (e)=>
          @template = _.template(e)
          @setMap(map)
        )
    
    AreaSummary:: = new google.maps.OverlayView();
    
    onAdd:()->
        content = @template(@area_)
        @div_ = $(content)[0]
        panes = @getPanes()
        panes.overlayImage.appendChild(@div_)
        @setVisible(false)
        
    draw:()->
      overlayProjection = @getProjection()
      sw = overlayProjection.fromLatLngToDivPixel(this.bounds_.getSouthWest());
      ne = overlayProjection.fromLatLngToDivPixel(this.bounds_.getNorthEast());

      div = this.div_;
      div.style.left = sw.x + ((ne.x - sw.x) - @width_) / 2 + 'px';
      div.style.top = ne.y + ((sw.y - ne.y) - @height_) / 2 + 'px';
    
    setVisible:(isVisible)->
      if @div_
          if isVisible is true
              @div_.style.visibility = "visible"
          else
              @div_.style.visibility = "hidden"
###
# }}}
###                

###
# class CustomInfoWindow {{{
###
class CustomInfoWindow
  constructor: (marker, content, opts) ->
    @content = content
    @marker  = marker
    @template = opts.template
    @map     = marker.map
    wrap = """
    <div class="customInfoWindow">
      <a href="javascript:" title="Close" class="close button"></a>
        <div class="padding"></div>
    </div>
    """
    @wrap = $(wrap)
    @closeBtn = @wrap.find('.close')
    @setMap(@map)
    @isVisible = false
    @onClose   = opts.onClose
    @onOpen    = opts.onOpen
    @onSave    = opts.onSave
    @deleteCalled = opts.deleteCalled
    @moveCalled = opts.moveCalled
    @closeBtn.bind('click', @close)

  CustomInfoWindow:: = new google.maps.OverlayView()
  
  
  onAdd:()->
      @wrap.find('.padding').append(@content)
      @wrap.css(
        display: "block"
        position: "absolute"
      )
      panes = @getPanes()
      panes.overlayMouseTarget.appendChild(@wrap[0])
      @iWidth = @wrap.outerWidth()
      @iHeight = @wrap.outerHeight()
      
      @bindButton()
      # @open()
  bindButton: () ->
    @wrap.find('button').bind('click', @handleSave)
    @wrap.find('.iw-options-list .button').bind('click', @toggleSection)
    
  onRemove :() ->
    @wrap[0].parentNode.removeChild(@wrap[0])
    @wrap = null
    
  draw: () ->
    cancelHandler = (e)=>
        e.cancelBubble = true
        if e.stopPropagation
          e.stopPropagation()
    
    overlayProjection = @getProjection()
    pos = overlayProjection.fromLatLngToDivPixel(@marker.position)
    @wrap.css(
      left: pos.x + 30
      top: pos.y - 80
    )
    
    events = ['mousedown', 'touchstart', 'touchend', 'touchmove', 'contextmenu', 'click', 'dblclick', 'mousewheel', 'DOMMouseScroll']
    @listeners = []
    for event in events
      @listeners.push(google.maps.event.addDomListener(@wrap[0], event, cancelHandler);)
    
  close:()=>
    if @wrap
      @onClose(this)
      @isVisible = false
      @wrap.css(
        display : "none"
      )
  open:()=>
    if @wrap
      @panMap()
      @onOpen(this)
      @isVisible = true
      @wrap.css(
        display : "block"
      )
  
  updatePos: ()->
    overlayProjection = @getProjection()
    pos = overlayProjection.fromLatLngToDivPixel(@marker.position)

    shareInput = @wrap.find('[name="share-link"]') 
    val = shareInput.val()
    newVal = val.split("?")[0] + "?lat=" + @marker.position.lat() + "&lng=" + @marker.position.lng()
    shareInput.val(newVal)

    @wrap.css(
      left: pos.x + 30
      top: pos.y - 80
    )
    
  toggleSection: (e) =>
    this_ = $(e.currentTarget)
    action = this_.attr('data-action')
    defaultTab = @wrap.find('.marker-desc')
    activeTab = @wrap.find('.toggling-tab.active') 
    targetTab = $("[data-target='#{action}']")

    switch action
      when "move", "share", "edit"
        @wrap.find('.iw-options-list .button').removeClass('active')
        if targetTab.attr("data-target") is activeTab.attr("data-target")
          targetTab.removeClass('active')
          defaultTab.addClass('active')
        else
          this_.addClass('active')
          activeTab.removeClass('active')
          targetTab.addClass('active')
          defaultTab.removeClass('active')
      when "delete"
        @deleteCalled(@marker)
      
    if action is "move"
      @moveCalled(@marker)

  handleSave: (e) =>
    this_ = $(e.currentTarget)
    form = @wrap.find('.edit-form')
    newTitle = @wrap.find('[name="marker-title"]').val()
    newDesc = @wrap.find('[name="marker-description"]').val()
    newWikiLink = @wrap.find('[name="marker-wiki"]').val()
    form.removeClass('active')
    console.log newWikiLink
    newInfo = 
      id    : @marker.__gm_id
      title : newTitle
      desc  : newDesc
      wikiLink : newWikiLink
      type : @marker.type
      cat  : @marker.cat
      lat  : @marker.position.lat()
      lng  : @marker.position.lng()
      hasDefaultValue : @marker["hasDefaultValue"]
    @wrap.find('.padding').html(@template(newInfo))
    @bindButton()
    @wrap.find('.edit').removeClass('active')
    @onSave(newInfo)
  
  panMap: () -> 
    @map.panTo(new google.maps.LatLng(@marker.position.lat(), @marker.position.lng()));

###
# }}}
###

    
$ ()->
  myCustomMap = new CustomMap('#map')
  markersOptionsMenuToggle = $('#options-toggle strong')
  markersOptionsMenuToggle.click( () ->
    myCustomMap.toggleMarkersOptionsMenu()
  )
