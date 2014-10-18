define (require, exports, module) ->
  Backbone = require 'backbone'
  MainBus = require 'msgbus'
  Marionette = require 'marionette'
  Masonry = require 'masonry'
  imagesLoaded = require 'imagesloaded'

  FormView = require 'common/views/formview'
  Templates = require 'vtdendro/templates'
  Models = require 'vtdendro/models'
  AppBus = require 'vtdendro/msgbus'
  
  BaseModels = require 'models'
  BaseSideBarView = require 'common/views/sidebar'
  require 'jquery-ui'

  { navigate_to_url } = require 'common/util'

  class SideBarView extends BaseSideBarView

  class BlogModal extends Backbone.Marionette.ItemView
    template: Templates.blog_dialog_view
    
  class SimpleGenusInfoView extends Backbone.Marionette.ItemView
    template: Templates.simple_genus_info

  class SimpleGenusListView extends Backbone.Marionette.CompositeView
    childView: SimpleGenusInfoView
    template: Templates.simple_genus_list
    childViewContainer: '#genuslist-container'
    ui:
      genuslist: '#genuslist-container'

    onDomRefresh: () ->
      #console.log 'onDomRefresh called on SimpleGenusListView'
      @masonry = new Masonry "#genuslist-container",
        gutter: 2
        isInitLayout: false
        itemSelector: '.genus'
        columnWidth: 100
      @set_layout()
      
    set_layout: ->
      @ui.genuslist.show()
      @masonry.reloadItems()
      @masonry.layout()
      if @collection.state.currentPage == @collection.state.firstPage
        $('#prev-page-button').hide()
      else
        $('#prev-page-button').show()
      if @collection.state.currentPage == @collection.state.lastPage
        $('#next-page-button').hide()
      else
        $('#next-page-button').show()
        

    events:
      'click #next-page-button': 'get_next_page'
      'click #prev-page-button': 'get_prev_page'
      
    keycommands:
      prev: 65
      next: 90

    get_another_page: (direction) ->
      @ui.genuslist.hide()
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

  class MainVtdendroView extends Backbone.Marionette.ItemView
    template: Templates.main_vtdendro_view

  class ShowPageView extends Backbone.Marionette.ItemView
    template: Templates.page_view


  class SimpleBlogPostView extends Backbone.Marionette.ItemView
    template: Templates.simple_post_view
    #className: 'col-sm-10'
    className: 'post'
    
    
  class BlogPostListView extends Backbone.Marionette.CompositeView
    template: Templates.simple_post_page_view
    childView: SimpleBlogPostView
    childViewContainer: '#posts-container'
    ui:
      posts: '#posts-container'
      slideshow_button: '#slideshow-button'
      
    #className: 'row'
    events:
      'click #next-page-button': 'get_next_page'
      'click #prev-page-button': 'get_prev_page'
      'click #slideshow-button': 'manage_slideshow'
      #'click #slideshow-button': 'blog_dialog'

    keycommands:
      prev: 65
      next: 90
      

    blog_dialog: (event) ->
      console.log event
      
      app = MainBus.reqres.request 'main:app:object'
      app.modal.showModal app.modal.currentView
      

    manage_slideshow: () ->
      button = @ui.slideshow_button
      if button.hasClass 'fa-play'
        @start_slideshow()
      else
        @stop_slideshow()
        
    
    start_slideshow: () ->
      console.log "start slideshow"
      @slideshow_handler = setInterval =>
        console.log "getting next page"
        @get_next_page()
      , 6000
      @ui.slideshow_button.removeClass 'fa-play'
      @ui.slideshow_button.addClass 'fa-stop'
      
    
    stop_slideshow: () ->
      clearInterval @slideshow_handler
      @ui.slideshow_button.removeClass 'fa-stop'
      @ui.slideshow_button.addClass 'fa-play'
      
    get_next_page: () ->
      @ui.posts.hide()
      response = @collection.getNextPage()
      response.done =>
        @set_image_layout()
        #@ui.posts.show()
        
    get_prev_page: () ->
      response = @collection.getPreviousPage()
      response.done =>
        @set_image_layout()

    get_another_page: (direction) ->
      @ui.posts.hide()
      switch direction
        when 'prev' then response = @collection.getPreviousPage()
        when 'next' then response = @collection.getNextPage()
        else response = null
      if response
        response.done =>
          @set_image_layout()
          

    handle_key_command: (command) ->
      #console.log "handle_key_command #{command}"
      if command in ['prev', 'next']
        @get_another_page command
      
    keydownHandler: (event_object) =>
      #console.log 'keydownHandler ' + event_object
      for key, value of @keycommands
        if event_object.keyCode == value
          @handle_key_command key
      
    set_image_layout: ->
      items = $ '.post'
      imagesLoaded items, =>
        @ui.posts.show()
        #console.log "Images Loaded>.."
        @masonry.reloadItems()
        @masonry.layout()      
  
    onRenderTemplate: ->
      #console.log 'onRenderTemplate'
      
    onRenderCollection: ->
      #console.log 'onRenderCollection'

    onRender: ->
      #console.log 'onRender'
      
    onDomRefresh: () ->
      console.log 'onDomRefresh called on BlogPostListView'
      $('html').keydown @keydownHandler
      @masonry = new Masonry "#posts-container",
        gutter: 2
        isInitLayout: false
        itemSelector: '.post'
      @set_image_layout()

    onBeforeDestroy: () ->
      #console.log "Remove @keydownHandler" + @keydownHandler
      $('html').unbind 'keydown', @keydownHandler
      @stop_slideshow()
      
      
  class ConsumerKeyFormView extends FormView
    template: Templates.consumer_key_form
    ui:
      consumer_key: '[name="consumer_key"]'
      consumer_secret: '[name="consumer_secret"]'
      token: '[name="token"]'
      token_secret: '[name="token_secret"]'

    updateModel: ->
      @model.set
        consumer_key: @ui.consumer_key.val()
        consumer_secret: @ui.consumer_secret.val()
        token: @ui.token.val()
        token_secret: @ui.token_secret.val()
        
    createModel: ->
      AppBus.reqres.request 'get_app_settings'
        
    onSuccess: (model) ->
      #console.log 'onSuccess called'
      navigate_to_url '#vtdendro'
      
  module.exports =
    SideBarView: SideBarView
    BlogModal: BlogModal
    MainVtdendroView: MainVtdendroView
    SimpleGenusListView: SimpleGenusListView
    BlogPostListView: BlogPostListView
    ConsumerKeyFormView: ConsumerKeyFormView
    
    
