define (require, exports, module) ->
  $ = require 'jquery'
  jQuery = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  bootstrap = require 'bootstrap'
  Marionette = require 'marionette'
  Wreqr = require 'backbone.wreqr'
  ft = require 'furniture'
  
  #MainPage = ft.misc.mainpage

  
  AppModel = require 'appmodel'

  
  AppChannel = Backbone.Wreqr.radio.channel 'global'

  #MainPage.set_mainpage_init_handler MainBus
  
  
  # require applets
  require 'frontdoor/main'
  require 'wiki/main'
  #require 'bumblr/main'
  require 'hubby/main'
  #require 'bookstore/main'

  app = new Marionette.Application()
  # attach app to window
  window.App = app

  app.ready = false
  ft.misc.mainhandles.set_mainpage_init_handler()
  
  ft.misc.mainhandles.prepare_app app, AppModel

  
    
  #ft.misc.appregions.prepare_app app, appmodel, MainBus
  app.ready = true
  #ft.util.navigate_to_url('#')
  console.log "hello"
  
  module.exports = app
  
    
