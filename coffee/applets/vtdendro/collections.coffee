define (require, exports, module) ->
  $ = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  PageableCollection = require 'backbone.paginator'
  MainBus = require 'msgbus'
  localStorage = require 'bblocalStorage'
  Models = require 'vtdendro/models'
  AppBus = require 'vtdendro/msgbus'
  

  ########################################
  # Collections
  ########################################
  baseURL = 'http://api.tumblr.com/v2'
  
  class PhotoPostCollection extends Backbone.Collection
    url: () ->
      "#{baseURL}/#{@id}/posts/photo?callback=?"
      
  class BlogPosts extends PageableCollection
    mode: 'server'
    full: true
    baseURL: baseURL
    url: () ->
      "#{@baseURL}/blog/#{@base_hostname}/posts/photo?api_key=#{@api_key}"
  
    fetch: (options) ->
      options || options = {}
      data = (options.data || {})
      current_page = @state.currentPage
      offset = current_page * @state.pageSize
      options.offset = offset
      options.dataType = 'jsonp'
      super options
      
    parse: (response) ->
      total_posts = response.response.total_posts
      @state.totalRecords = total_posts
      super response.response.posts

    state:
      firstPage: 0
      pageSize: 15
      
    queryParams:
      pageSize: 'limit'
      offset: () ->
        @state.currentPage * @state.pageSize
        
  class LocalBlogCollection extends Backbone.Collection
    localStorage: new localStorage('blogs')
    model: Models.BlogInfo

    # FIXME: This is ugly!
    add_blog: (name) ->
      sitename = "#{name}.tumblr.com"
      model = new Models.BlogInfo
      model.set 'id', sitename
      model.set 'name', name
      model.api_key = @api_key
      @add model
      model.fetch()
      return model

  class GenusCollection extends Backbone.Collection
    url: '/rest/v0/main/genus'

  genus_collection = new GenusCollection
  AppBus.reqres.setHandler 'get_genus_collection', ->
    genus_collection
    
  module.exports =
    PhotoPostCollection: PhotoPostCollection
    GenusCollection: GenusCollection
    
