define (require, exports, module) ->
  $ = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  MainBus = require 'msgbus'
  BaseLocalStorageModel = require 'common/localstoragemodel'
  AppBus = require 'vtdendro/msgbus'
  
  ########################################
  # Models
  ########################################
  baseURL = 'http://api.tumblr.com/v2'
  
  class VtdendroSettings extends BaseLocalStorageModel
    id: 'vtdendro_settings'

  class BaseTumblrModel extends Backbone.Model
    baseURL: baseURL
    
  class BlogInfo extends BaseTumblrModel
    url: () ->
      "#{@baseURL}/blog/#{@id}/info?api_key=#{@api_key}&callback=?"
      
  module.exports =
    BlogInfo: BlogInfo
    
