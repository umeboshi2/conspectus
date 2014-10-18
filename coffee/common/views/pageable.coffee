# https://github.com/scottaj/marionette-form-view-demo
# 
define (require, exports, module) ->
  _ = require 'underscore'
  Backbone = require 'backbone'
  Marionette = require 'marionette'
  Masonry = require 'masonry'
  imagesLoaded = require 'imagesloaded'

  class PageableView extends Backbone.Marionette.CompositeView
    onDomRefresh: () ->
      window.pview = @
      @masonry = new Masonry @ui.container.selector,
        gutter: @layoutGutter || 2
        isInitLayout: false
        itemSelector: @itemSelector || '.item'
        columnWidth: @columnWidth || 100
      @set_layout()

    set_layout: ->
      @ui.container.show()
      @masonry.reloadItems()
      @masonry.layout()
      if @collection.state.currentPage == @collection.state.firstPage
        @ui.prev_page_button.hide()
      else
        @ui.prev_page_button.show()
      if @collection.state.currentPage == @collection.state.lastPage
        @ui.next_page_button.hide()
      else
        @ui.next_page_button.show()

    events:
      'click @ui.next_page_button': 'get_next_page'
      'click @ui.prev_page_button': 'get_prev_page'

    get_another_page: (direction) ->
      @ui.container.hide()
      switch direction
        when 'prev' then response = @collection.getPreviousPage()
        when 'next' then response = @collection.getNextPage()
        else response = null
      if response
        response.done =>
          @set_layout()

    get_next_page: () ->
      @get_another_page 'next'

    get_prev_page: () ->
      @get_another_page 'prev'
      
  module.exports = PageableView
  
  
