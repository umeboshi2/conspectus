define (require, exports, module) ->
  $ = require 'jquery'
  Backbone = require 'backbone'
  Marionette = require 'marionette'
  MainBus = require 'msgbus'

  Views = require 'vtdendro/views'
  Models = require 'vtdendro/models'
  AppBus = require 'vtdendro/msgbus'
    
  Collections = require 'vtdendro/collections'
  Util = require 'common/util'
  
  fullCalendar = require 'fullcalendar'

  { SideBarController } = require 'common/controllers'

  side_bar_data = new Backbone.Model
    entries: [
      {
        name: 'Genus List'
        url: '#vtdendro/genuslist'
      }
      {
        name: 'VTSpecies List'
        url: '#vtdendro/vtspecieslist'
      }
      ]

  class Controller extends SideBarController
    sidebarclass: Views.SideBarView
    sidebar_model: side_bar_data
    
    init_page: ->
      #console.log 'init_page', @App
      view = new Views.BlogModal()
      @App.modal.show view
      
    set_header: (title) ->
      header = $ '#header'
      header.text title
      
    start: ->
      if @App.content.hasView()
        console.log 'empty content....'
        @App.content.empty()
      if @App.sidebar.hasView()
        console.log 'empty sidebar....'
        @App.sidebar.empty()
      @set_header 'VT Dendro'
      @vtspecies_list()
      
    show_mainview: () ->
      @make_sidebar()
      view = new Views.SimpleGenusListView
      @App.content.show view
      Util.scroll_top_fast()
      

    genus_list: () ->
      #console.log 'genus_list called'
      @make_sidebar()
      glist = AppBus.reqres.request 'get_genus_collection'
      response = glist.fetch()
      #console.log 'my glist response', response
      response.done =>
        #console.log "response.done for glist"
        view = new Views.SimpleGenusListView
          collection: glist
        @App.content.show view
        Util.scroll_top_fast()

    
    vtspecies_list: () ->
      @make_sidebar()
      vlist = AppBus.reqres.request 'get_vtspecies_collection'
      response = vlist.fetch()
      response.done =>
        view = new Views.SimpleVTSpeciesListView
          collection: vlist
        @App.content.show view
        Util.scroll_top_fast()

    view_vtspecies: (id) ->
      @make_sidebar()
      vlist = AppBus.reqres.request 'get_vtspecies_collection'
      response = vlist.fetch()
      response.done =>
        window.vlist = vlist
        spec = vlist.get id
        view = new Views.VTSpecView
          model: spec
        @App.content.show view
        Util.scroll_top_fast()
      
  module.exports = Controller
  
