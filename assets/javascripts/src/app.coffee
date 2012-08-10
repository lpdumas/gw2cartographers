# CONSTANT
window.LANG = "en"
Cartographer.LOCAL_STORAGE = (()->
  if window['localStorage']?
    return yes
  else
    return no
)()

##################
#--CARTOGRAPHER--
###############{{{
Cartographer.initiate = ()->
  @router = new Cartographer.router()
  @templatesLoader = new Cartographer.TemplatesLoader()
  

Cartographer.switchLang = (lang)->
  if window.LANG isnt lang
    console.log "switching lang to #{lang}"
    window.LANG = lang

Cartographer.highlighMarker = (coord)->
  console.log "highlighting marker at #{coord.lat}, #{coord.lgn}"
# }}}

##################
#---CLASSES------
###############{{{
class Cartographer.TemplatesLoader
  constructor: ()->
    @templates =
      "confirmBox" : 
        path : "assets/javascripts/templates/confirmBox._"
        version : 1
      "customInfoWindow" : 
        path : "assets/javascripts/templates/customInfoWindow._"
        version : 2
      "markersOptions" : 
        path: "assets/javascripts/templates/markersOptions._"
        version : 1
      "areasSummary" : 
        path: "assets/javascripts/templates/areasSummary._"
        version: 1

  getTemplate: (templateName, callback)->
    if Cartographer.LOCAL_STORAGE
      localTemplate = localStorage.getItem(templateName)
      localTemplateVersion = localStorage.getItem("#{templateName}Version")
      if localTemplate && (localTemplateVersion? and parseInt(localTemplateVersion) is @templates[templateName].version)
        callback(localTemplate)
      else if @templates[templateName]?
        $.get(@templates[templateName].path, (e)=>
          localStorage.setItem(templateName, e);
          localStorage.setItem("#{templateName}Version", @templates[templateName].version);
          callback(e)
        )
    else
      $.get(@templates[templateName], (e)=>
        callback(e)
      )
# }}}

##################
#---COLLECTIONS---
###############{{{

# }}}

##################
#-----MODELS-----
###############{{{
# }}}

#################
#----ROUTER------
##############{{{
Cartographer.router = Backbone.Router.extend(
  routes: {}
  initialize: ()->
    routes = [
      [ /^(en|fr)\/*$/, 'lang', this.handleLang ]
      [ /^(en|fr)*\/lat\/([0-9.]+)\/lgn\/([0-9.]+)\/*$/, 'coord', this.handleLangWithParams ]
    ]
    _.each(routes, (route)=>
      this.route.apply(this,route)
    )
    
    Backbone.history.start()
    
  handleLang: (lang)->
    Cartographer.switchLang(lang)
      
  handleCoord: (lang, lat, lgn)->
    @handleLang(lang)
    Cartographer.highlighMarker(
      lat : lat
      lgn : lgn
    )
) 
# }}}

$ ()->
  Cartographer.initiate()