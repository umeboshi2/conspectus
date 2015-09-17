define (require, exports, module) ->
  $ = require 'jquery'
  jQuery = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  bootstrap = require 'bootstrap'
  Marionette = require 'marionette'

  ft = require 'furniture'
  
  AppRegions = ft.appregions
  MainPage = ft.misc.mainpage

  
  MainBus = require 'msgbus'
  appmodel = require 'appmodel'
    
  MainPage.set_mainpage_init_handler MainBus
  
  
  # require applets
  require 'frontdoor/main'
  require 'wiki/main'
  require 'bumblr/main'
  require 'hubby/main'
  require 'bookstore/main'

  
  app = new Marionette.Application()
    
  app.ready = false

  ft.misc.appregions.prepare_app app, appmodel, MainBus
  app.ready = true

  
  module.exports = app
  
    
