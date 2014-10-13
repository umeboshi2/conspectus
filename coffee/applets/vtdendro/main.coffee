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
      'vtdendro/settings': 'settings_page'
      'vtdendro/dashboard': 'show_dashboard'
      'vtdendro/listblogs': 'list_blogs'
      'vtdendro/viewblog/:id': 'view_blog'
      'vtdendro/addblog' : 'add_new_blog'
      
    
  MainBus.commands.setHandler 'vtdendro:route', () ->
    console.log "vtdendro:route being handled..."
    controller = new Controller MainBus
    router = new Router
      controller: controller
    #console.log 'vtdendro router created'
