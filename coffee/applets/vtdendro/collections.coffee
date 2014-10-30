define (require, exports, module) ->
  $ = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  PageableCollection = require 'backbone.paginator'
  require 'qs'
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

  class BaseCollection extends OffsetLimitCollection
    state:
      firstPage: 0
      pageSize: 30
    
      
  class GenusCollection extends BaseCollection
    url: '/rest/v0/main/genus'
        
  genus_collection = new GenusCollection
  AppBus.reqres.setHandler 'get_genus_collection', ->
    genus_collection

  class MainVTSpeciesCollection extends BaseCollection
    url: '/rest/v0/main/vtspecies'

  vtspecies_collection = new MainVTSpeciesCollection
  AppBus.reqres.setHandler 'get_vtspecies_collection', ->
    vtspecies_collection

  class VTGenusCollection extends BaseCollection
    url: () ->
      "/rest/v0/main/vtspecies?genus=#{@genus}"
      
    
  AppBus.reqres.setHandler 'make_vtgenus_collection', (genus) ->
    c = new VTGenusCollection
    c.genus = genus
    return c

  class VTSearchCollection extends BaseCollection
    url: () ->
      "/rest/v0/main/vtspecies?#{qs.stringify @searchParams}"

  AppBus.reqres.setHandler 'make_vtsearch_collection', (params) ->
    c = new VTSearchCollection
    c.searchParams = params
    return c
          
    
  module.exports =
    GenusCollection: GenusCollection
    VTGenusCollection: VTGenusCollection
    
