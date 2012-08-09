window.Cartographer = {}

Cartographer.router = Backbone.Router.extend(
  routes:
    ":lang" : "handleLang"
    ":lang/lat/:lat/lgn/:lgn" : "handleCoord"

  initialize: ()->
    console.log "test"
    # router = this
    # routes = [
      # [ /^(en|fr)*\/*$/, 'handleLang', this.handleLang ]
      # [ /^(en|fr)*\/lat\/[0-9.]+\/lgn\/[0-9.]+\/*$/, 'handleLangWithParams', this.handleLangWithParams ]
    # ]
    # _.each(routes, (route)->
      # router.route.apply(router,route)
    # )
    Backbone.history.start()
    
  handleLang: (lang)->
    if lang? and (lang is "fr" or lang is "en")
      Cartographer.switchLang(lang)
    else
      this.navigate("fr", {trigger : true})
      
  handleCoord: (lang, lat, lgn)->
    console.log "handling #{lang}"
    console.log "move to #{lat}, #{lgn}"
) 

Cartographer.initiate = ()->
  @cartographerRouter = new Cartographer.router()

Cartographer.switchLang = (lang)->
  console.log "switching lang to #{lang}"

$ ()->
  Cartographer.initiate()