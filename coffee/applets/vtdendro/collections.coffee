define (require, exports, module) ->
  $ = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  PageableCollection = require 'backbone.paginator'
  MainBus = require 'msgbus'
  localStorage = require 'bblocalStorage'
  Models = require 'vtdendro/models'
  AppBus = require 'vtdendro/msgbus'

  CommonCollections = require 'common/collections'

  ########################################
  # Collections
  ########################################
  class OffsetLimitCollection extends CommonCollections.OffsetLimitCollection
    mode: 'server'
    full: true
    
    parse: (response) ->
      #console.log "parsing response", response
      #window.gcresponse = response
      total_count = response.total_count
      @state.totalRecords = total_count
      super response.data
      
  class GenusCollection extends OffsetLimitCollection
    url: '/rest/v0/main/genus'

    state:
      firstPage: 0
      pageSize: 30
        
  genus_collection = new GenusCollection
  AppBus.reqres.setHandler 'get_genus_collection', ->
    #window.genuscollection = genus_collection
    genus_collection

  class VTSpeciesCollection extends OffsetLimitCollection
    url: '/rest/v0/main/vtspecies'
    state:
      firstPage: 0
      pageSize: 30
    
  genus_collection = new GenusCollection
  vtspecies_collection = new VTSpeciesCollection
  AppBus.reqres.setHandler 'get_vtspecies_collection', ->
    #window.genuscollection = genus_collection
    vtspecies_collection

    
  module.exports =
    GenusCollection: GenusCollection
    
