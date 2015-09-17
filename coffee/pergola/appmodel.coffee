define (require, exports, module) ->
  $ = require 'jquery'
  jQuery = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  ft = require 'furniture'
  
  AppRegions = ft.misc.appregions
  
  appmodel = new Backbone.Model
    brand:
      name: 'Pergola'
      url: '#'
    applets:
      [
        {
          appname: 'wiki'
          name: 'Wiki'
          url: '#wiki'
        }
        {
          appname: 'bumblr'
          name: 'Bumblr'
          url: '#bumblr'
        }
        {
          appname: 'hubby'
          name: 'Hubby'
          url: '#hubby'
        }
        {
          appname: 'bookstore'
          name: 'Bookstore'
          url: '#bookstore'
        }
      ]
    regions: AppRegions.basic_appregions
    routes: [
      'frontdoor:route'
      'wiki:route'
      'bumblr:route'
      'hubby:route'
      'bookstore:route'
      ]
    
      
  module.exports = appmodel
  
  
    
