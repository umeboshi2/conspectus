# modular template loading
define (require, exports, module) ->
  $ = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  tc = require 'teacup'
  marked = require 'marked'
  
  # I use "icon" for font-awesome
  icon = tc.i

  # Main Templates must use teacup.
  # The template must be a teacup.renderable, 
  # and accept a layout model as an argument.

    
  ########################################
  # Templates
  ########################################
  frontdoor_main = tc.renderable (page) ->
    tc.raw marked page.content
    
              
  page_list_entry = tc.renderable (page) ->
    tc.div '.listview-list-entry', ->
      tc.span '.btn-default.btn-xs', ->
        tc.a href:'#wiki/editpage/' + page.id,
        style:'color:black', ->
          icon '.edit-page.fa.fa-pencil'
      tc.text "    " 
      tc.a href:'#wiki/showpage/' + page.id, page.id
        
  page_list = tc.renderable () ->
    tc.div '.listview-header', ->
      tc.text 'Wiki Pages'
      tc.span '#add-new-page-button.btn.btn-default.btn-xs.pull-right',
      'New Page'
    tc.div '.listview-list'

  show_page_view = tc.renderable (page) ->
    tc.div '.listview-header', ->
      tc.text page.name
    tc.div '.listview-list', ->
      tc.raw marked page.content
      
  edit_page = tc.renderable (page) ->
    tc.div '.listview-header', ->
      tc.text "Editing " + page.id
      tc.div '#save-button.pull-left.btn.btn-default.btn-xs', ->
        tc.text 'save'
    tc.div '#editor'

  new_page_form = tc.renderable () ->
    tc.div '.form-group', ->
      tc.label '.control-label', for:'input_name', 'Page Name'
      tc.input '#input_name.form-control',
      name:'name', dataValidation:'name',
      placeholder:'New Page', value:''
    tc.div '.form-group', ->
      tc.label '.control-label', for:'input_content', 'Content'
      tc.textarea '#input_content.form-control',
      name:'content', dataValidation:'content',
      placeholder:'...add text....', value:''
    tc.input '.btn.btn-default.btn-xs', type:'submit', value:'Add Page'
    

      
  module.exports =
    frontdoor_main: frontdoor_main
    page_list_entry: page_list_entry
    page_list: page_list
    show_page_view: show_page_view
    edit_page: edit_page
    new_page_form: new_page_form
    
    
