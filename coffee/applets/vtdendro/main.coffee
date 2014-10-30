#
define (require, exports, module) ->
  Backbone = require 'backbone'
  Util = require 'common/util'
  MainBus = require 'msgbus'

  Controller = require 'vtdendro/controller'
  AppBus = require 'vtdendro/msgbus'

  { BootStrapAppRouter } = require 'common/approuters'
  

  # FIXME: this is to make sure that AppBus handlers
  # are running
  Models = require 'vtdendro/models'  
  require 'vtdendro/collections'
  
  class Router extends BootStrapAppRouter
    appRoutes:
      'vtdendro': 'start'
      'vtdendro/genuslist': 'genus_list'
      'vtdendro/viewgenus/:name?genus_id=:id': 'view_genus'
      'vtdendro/vtspecieslist': 'vtspecies_list'
      'vtdendro/viewvtspecies/:id': 'view_vtspecies'
      'vtdendro/vtsearch': 'search_vtspecies'
      
    
  MainBus.commands.setHandler 'vtdendro:route', () ->
    console.log "vtdendro:route being handled..."
    controller = new Controller MainBus
    router = new Router
      controller: controller
    #console.log 'vtdendro router created'
