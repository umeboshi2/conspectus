define (require, exports, module) ->
  $ = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  
  Models = require 'models'
  
  MSGBUS = require 'msgbus'
  localStorage = require 'bblocalStorage'
  
      

  ########################################
  # Collections
  ########################################
  module.exports = null
  
