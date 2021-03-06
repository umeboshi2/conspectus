define (require, exports, module) ->
  $ = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  Wreqr = require 'backbone.wreqr'
  
  localStorage = require 'bblocalStorage'
  
  Models = require 'wiki/models'
  MainChannel = Backbone.Wreqr.radio.channel 'global'
  AppChannel = Backbone.Wreqr.radio.channel 'wiki'
  
      

  ########################################
  # Collections
  ########################################
  class PageCollection extends Backbone.Collection
    localStorage: new localStorage('pages')
    model: Models.Page

    
  # set handlers on message bus
  #
  main_page_collection = new PageCollection
  AppChannel.reqres.setHandler 'pages:collection', ->
    main_page_collection

  AppChannel.reqres.setHandler 'pages:getpage', (page_id) ->
    #console.log 'handle pages:getpage ' + page_id
    model = main_page_collection.get page_id
    #window.mmodel = model
    #return model
    if model is undefined
      #console.log 'make new page model ' + page_id
      model = new Models.Page
        id: page_id
        content: ''
      main_page_collection.add model
      if page_id == 'intro'
        model.set 'content', 'This is the intro.'
        model.save()
    model
      
  module.exports =
    PageCollection: PageCollection
