# modular template loading
define (require, exports, module) ->
  $ = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  teacup = require 'teacup'
  marked = require 'marked'
  
  renderable = teacup.renderable
  raw = teacup.raw
  
  div = teacup.div
  # I use "icon" for font-awesome
  icon = teacup.i
  strong = teacup.strong
  span = teacup.span
  label = teacup.label
  input = teacup.input

  text = teacup.text
  img = teacup.img
  # Main Templates must use teacup.
  # The template must be a teacup.renderable, 
  # and accept a layout model as an argument.

  # Tagnames to be used in the template.
  {div, span, link, text, strong, label, input, 
  button, a, nav, form, p,
  ul, li, b,
  h1, h2, h3,
  subtitle, section
  } = teacup
            
    
  ########################################
  # Templates
  ########################################
  layout = renderable () ->
    div '.something-very-special'
    
  frontdoor_main = renderable (page) ->
    raw marked page.content
    
              
  page_list_entry = renderable (page) ->
    div '.listview-list-entry', ->
      span '.btn-default.btn-xs', ->
        a href:'#wiki/editpage/' + page.id,
        style:'color:black', ->
          icon '.edit-page.fa.fa-pencil'
      text "    " 
      a href:'#wiki/showpage/' + page.id, page.id
        
  page_list = renderable () ->
    div '.listview-header', 'Wiki Pages'
    div '.listview-list'

  show_page_view = renderable (page) ->
    div '.listview-header', ->
      text page.name
    div '.listview-list', ->
      teacup.raw marked page.content
      
  edit_page = renderable (page) ->
    div '.listview-header', ->
      text "Editing " + page.id
      div '#save-button.pull-left.btn.btn-default.btn-xs', ->
        text 'save'
    div '#editor'
    

      
  module.exports =
    layout: layout
    frontdoor_main: frontdoor_main
    page_list_entry: page_list_entry
    page_list: page_list
    show_page_view: show_page_view
    edit_page: edit_page
    
