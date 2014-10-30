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
  PageableView = require 'common/views/pageable'
  
  require 'jquery-ui'

  { navigate_to_url } = require 'common/util'

  class SideBarView extends BaseSideBarView

  class BlogModal extends Backbone.Marionette.ItemView
    template: Templates.blog_dialog_view
    
  class SimpleGenusInfoView extends Backbone.Marionette.ItemView
    template: Templates.simple_genus_info

  class SimpleGenusListView extends PageableView
    childView: SimpleGenusInfoView
    template: Templates.simple_genus_list
    childViewContainer: '#genuslist-container'
    itemSelector: '.genus'
    ui:
      container: '#genuslist-container'
      next_page_button: '#next-page-button'
      prev_page_button: '#prev-page-button'

  class SimpleVTSpeciesInfoView extends Backbone.Marionette.ItemView
    template: Templates.simple_vtspecies_info
    
  class SimpleVTSpeciesListView extends PageableView
    childView: SimpleVTSpeciesInfoView
    template: Templates.simple_vtspecies_list
    childViewContainer: '#speclist-container'
    itemSelector: '.species'
    ui:
      container: '#speclist-container'
      next_page_button: '#next-page-button'
      prev_page_button: '#prev-page-button'

  class VTSpecView extends Backbone.Marionette.ItemView
    template: Templates.vtspecies_full_view

  class MainVtdendroView extends Backbone.Marionette.ItemView
    template: Templates.main_vtdendro_view

  class ShowPageView extends Backbone.Marionette.ItemView
    template: Templates.page_view


  class SimpleBlogPostView extends Backbone.Marionette.ItemView
    template: Templates.simple_post_view
    #className: 'col-sm-10'
    className: 'post'

  class SearchVTSpeciesView extends FormView
    template: Templates.search_vtspecies_form
    ui:
      cname: '[name="cname"]'
      form: '[name="form"]'

    createModel: ->
      new Backbone.Model url: null

    updateModel: ->
      for field in ['cname', 'form']
        value = @ui[field].val()
        if value
          @model.set field, value
          console.log 'set', field, value
      console.log "model", @model

    saveModel: ->
      console.log "calling save model, do something here"
      console.log "model is", @model
      
      
    
  module.exports =
    SideBarView: SideBarView
    BlogModal: BlogModal
    MainVtdendroView: MainVtdendroView
    SimpleGenusListView: SimpleGenusListView
    SimpleVTSpeciesListView: SimpleVTSpeciesListView
    VTSpecView: VTSpecView
    SearchVTSpeciesView: SearchVTSpeciesView
    
    
