define (require, exports, module) ->
  $ = require 'jquery'
  Backbone = require 'backbone'
  Marionette = require 'marionette'
  Wreqr = Backbone.Wreqr

  class ModalRegion extends Backbone.Marionette.Region
    el: '#modal'
    #events:
    #  show: (view) ->
    #    @showModal view
    events:
      'view:show': ->
        @showModal @
        
    getEl: (selector) ->
      $el = $ selector
      $el.attr 'class', 'modal bs-example-modal'
      #$el.on 'hidden', @close
      $el

    showModal: (view) ->
      @listenTo view, 'close', @hideModal, @
      @$el.modal 'show'

    hideModal: ->
      @$el.modal 'hide'
      
      
  basic_appregions = 
    mainview: 'body'
    navbar: '#main-navbar'
    sidebar: '#sidebar'
    content: '#main-content'
    footer: '#footer'
    modal: ModalRegion
    
  user_appregions = 
    mainview: 'body'
    navbar: '#main-navbar'
    usermenu: '#user-menu'
    sidebar: '#sidebar'
    content: '#main-content'
    footer: '#footer'
    modal: ModalRegion
    apptriggers:
      navbar:
        show: 'appregion:navbar:displayed'

  # just show and empty being handled
  # no triggers for empty yet
  add_view_handlers = (mainbus, app, regions, region) ->
    prefix = "appregion:#{region}"
    #console.log "prefix is #{prefix}"
    signal = "#{prefix}:show"
    show_trigger = false
    apptriggers = regions.apptriggers
    #console.log "apptriggers #{[key for key of apptriggers]}"
    if apptriggers and region of apptriggers and 'show' of apptriggers[region]
      show_trigger = apptriggers[region].show
      console.log "show_trigger #{show_trigger}"
    mainbus.vent.on signal, (view) =>
      #[ignore, sigregion, method] = signal.split ':'
      #console.log "#{signal} #{method} called on #{sigregion}=#{region}"
      app[region]?.show view
      if show_trigger
        mainbus.vent.trigger show_trigger, view
    signal = "#{prefix}:empty"
    mainbus.vent.on signal, (view) =>
      #[ignore, sigregion, method] = signal.split ':'
      #console.log "#{signal} #{method} called on #{sigregion}=#{region}"
      if region of app
        app[region]?.empty()
      
    signal = "#{prefix}:hasview"
    mainbus.reqres.setHandler signal, () =>
      if region of app
        app[region]?.hasView()

  add_region_view_handlers = (mainbus, app, regions) ->
    for region of regions
      add_view_handlers mainbus, app, regions, region
      
  prepare_app = (app, appmodel, mainbus) ->
    regions = appmodel.get 'appregions'
    routes = appmodel.get 'approutes'
    app.radio = Backbone.Wreqr.radio
    app.addRegions(regions)
    app.on 'start', ->
      Backbone.history.start() unless Backbone.history.started
    app.msgbus = mainbus
    app.addInitializer ->
      # set event handlers
      add_region_view_handlers mainbus, app, regions
      # init page
      mainbus.commands.execute 'mainpage:init', appmodel
      # init routes
      for route in routes
        mainbus.commands.execute route
    mainbus.reqres.setHandler 'main:app:object', ->
      app  

  module.exports =
    prepare_app: prepare_app
    basic_appregions: basic_appregions
    user_appregions: user_appregions
    
