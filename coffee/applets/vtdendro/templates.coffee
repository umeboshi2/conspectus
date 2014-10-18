# modular template loading
define (require, exports, module) ->
  $ = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  teacup = require 'teacup'
  marked = require 'marked'
  
  renderable = teacup.renderable
  raw = teacup.raw
  
  # I use "icon" for font-awesome
  icon = teacup.i
  text = teacup.text
  # Main Templates must use teacup.
  # The template must be a teacup.renderable, 
  # and accept a layout model as an argument.

  # Tagnames to be used in the template.
  {div, span, link, strong, label, input, img, textarea
  button, a, nav, form, p,
  ul, li, b,
  h1, h2, h3,
  subtitle, section, hr,
  table, tr, td, th, thead
  } = teacup
            
  { form_group_input_div } = require 'common/templates'
    
  ########################################
  # Templates
  ########################################
  sidebar = renderable (model) ->
    div '.listview-list.btn-group-vertical', ->
      for entry in model.entries
        div '.btn.btn-default.' + entry.name, entry.label
        
  main_vtdendro_view = renderable (model) ->
    p 'main vtdendro view'

  vtdendro_dashboard_view = renderable (model) ->
    p 'vtdendro_dashboard_view'


  blog_dialog_view = renderable (blog) ->
    div '.modal-header', ->
      h2 'This is a modal!'
    div '.modal-body', ->
      p 'here is some content'
    div '.modal-footer', ->
      button '#modal-cancel-button.btn', 'cancel'
      button '#modal-ok-button.btn.btn-default', 'Ok'

  simple_toolbar = renderable () ->
    div '.mytoolbar.row', ->
      ul '.pager', ->
        li '.previous', ->
          icon '#prev-page-button.fa.fa-arrow-left.btn.btn-default'
        li '.next', ->
          icon '#next-page-button.fa.fa-arrow-right.btn.btn-default'
    
  simple_genus_list = renderable () ->
    simple_toolbar()
    div ->
      div '#genuslist-container.listview-list'

  simple_genus_info = renderable (genus) ->
    div '.genus.listview-list-entry', ->
      a href:"#vtdendro/viewgenus/#{genus.name}", genus.name

  simple_vtspecies_info = renderable (species) ->
    div '.species.listview-list-entry', ->
      a href:"#vtdendro/viewvtspecies/#{species.id}", species.cname

  simple_vtspecies_list = renderable () ->
    simple_toolbar()
    div ->
      div '#speclist-container.listview-list'

  vtspecies_full_view = renderable (spec) ->
    window.spec = spec
    div '.listview-header', spec.cname
    div '.listview-list-entry', "#{spec.genus} #{spec.species}"
    table ->
      for field in ['form', 'leaf', 'bark', 'fruit', 'flower', 'twig']
        tr '.listview-list-entry',  ->
          td ->
            strong "#{field}"
            text spec[field]
          td ->
            img src:"#{spec.pictures[field].localurl}"
      
  simple_post_view = renderable (post) ->
    div '.listview-list-entry', ->
      #p ->
      # a href:post.post_url, target:'_blank', post.blog_name
      span ->
        #for photo in post.photos
        photo = post.photos[0]
        current_width = 0
        current_size = null
        for size in photo.alt_sizes
          if size.width > current_width and size.width < 250
            current_size = size
            current_width = size.width
        size = current_size 
        a href:post.post_url, target:'_blank', ->
          img src:size.url

  module.exports =
    sidebar: sidebar
    main_vtdendro_view: main_vtdendro_view
    vtdendro_dashboard_view: vtdendro_dashboard_view
    blog_dialog_view: blog_dialog_view
    simple_genus_list: simple_genus_list
    simple_genus_info: simple_genus_info
    simple_vtspecies_list: simple_vtspecies_list
    simple_vtspecies_info: simple_vtspecies_info
    vtspecies_full_view: vtspecies_full_view
    
