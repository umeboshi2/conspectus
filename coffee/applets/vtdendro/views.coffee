define (require, exports, module) ->
  Backbone = require 'backbone'
  MainBus = require 'msgbus'
  Marionette = require 'marionette'
  Masonry = require 'masonry'
  imagesLoaded = require 'imagesloaded'
  require 'qs'
  
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
    ui: () ->
      super
        container: '#genuslist-container'

  class SimpleVTSpeciesInfoView extends Backbone.Marionette.ItemView
    template: Templates.simple_vtspecies_info

  class BaseVTSpeciesListView extends PageableView
    childView: SimpleVTSpeciesInfoView
    childViewContainer: '#speclist-container'
    itemSelector: '.species'
    ui: () ->
      super
        container: '#speclist-container'
        
  class SimpleVTSpeciesListView extends BaseVTSpeciesListView
    template: Templates.simple_vtspecies_list

  class VTSpeciesGenusListView extends BaseVTSpeciesListView
    template: Templates.vtspecies_genus_list
      
  class VTSpecView extends Backbone.Marionette.ItemView
    template: Templates.vtspecies_full_view

  class MainVtdendroView extends Backbone.Marionette.ItemView
    template: Templates.main_vtdendro_view

  class WikiPageView extends Backbone.Marionette.ItemView
    template: Templates.wikipage_view
    
  class SearchVTSpeciesView extends FormView
    fields: ['cname', 'form', 'leaf', 'bark', 'fruit', 'flower', 'twig']
    template: Templates.search_vtspecies_form
    ui: () ->
      data = {}
      for field in @fields
        #data[field] = '[name="' + field + '"]'
        data[field] = "[name=\"#{field}\"]"
      return data
      
    createModel: ->
      new Backbone.Model url: null

    updateModel: ->
      for field in @fields
        value = @ui[field].val()
        if value
          @model.set field, value
          console.log 'set', field, value
      console.log "model", @model

    saveModel: ->
      console.log "calling save model, do something here"
      console.log "model is", @model, @ui
      urlbase = '#vtdendro/vtshowsearch?'
      queryString = qs.stringify @model.attributes
      url = urlbase + queryString
      navigate_to_url url
        
        
        
      
      
      
      
    
  module.exports =
    SideBarView: SideBarView
    BlogModal: BlogModal
    MainVtdendroView: MainVtdendroView
    SimpleGenusListView: SimpleGenusListView
    SimpleVTSpeciesListView: SimpleVTSpeciesListView
    VTSpecView: VTSpecView
    SearchVTSpeciesView: SearchVTSpeciesView
    VTSpeciesGenusListView: VTSpeciesGenusListView
    WikiPageView: WikiPageView
    
