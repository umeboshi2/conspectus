define (require, exports, module) ->
  $ = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  tc = require 'teacup'


  # Main Templates must use teacup.
  # The template must be a teacup.renderable, 
  # and accept a layout model as an argument.
  
  ########################################
  # Templates
  ########################################
  form_group_input_div = tc.renderable (data) ->
    tc.div '.form-group', ->
      tc.label '.control-label',
        for:data.input_id
        data.label
      input_type = if data?.input_type then data.input_type else tc.input
      input_type "##{data.input_id}.form-control", data.input_attributes
          
  login_form = tc.renderable (user) ->
    tc.form
      role:'form'
      method: 'POST'
      action: '/login', ->
        form_group_input_div
          input_id: 'input_username'
          label: 'User Name'
          input_attributes:
            name: 'username'
            placeholder: 'User Name'
        form_group_input_div
          input_id: 'input_password'
          label: 'Password'
          input_attributes:
            name: 'password'
            type: 'password'
            placeholder: 'Type your password here....'
        tc.button '.btn.btn-default', type:'submit', 'login'

  name_content_form = tc.renderable (model) ->
    form_group_input_div
      input_id: 'input_name'
      label: 'Name'
      input_attributes:
        name: 'name'
        placeholder: 'Name'
    form_group_input_div
      input_id: 'input_content'
      input_type: tc.textarea
      label: 'Content'
      input_attributes:
        name: 'content'
        placeholder: '...'
    tc.input '.btn.btn-default.btn-xs', type:'submit', value:'Add'
    
  ########################################
  user_menu = tc.renderable (user) ->
    name = user.username
    tc.ul '#user-menu.ctx-menu.nav.navbar-nav', ->
      tc.li '.dropdown', ->
        tc.a '.dropdown-toggle', dataToggle:'dropdown', ->
          if name == undefined
            tc.text "Guest"
          else
            tc.text name
          tc.b '.caret'
        tc.ul '.dropdown-menu', ->
          if name == undefined
            tc.li ->
              tc.a href:'/login', 'login'
          else
            tc.li ->
              tc.a href:'/app/user', 'User Page'
            # we need a "get user info" from server
            # to populate this menu with 'admin' link
            # FIXME use "?." to help here
            admin = false
            unless name == undefined
              groups = user.groups
              if groups != undefined
                for g in groups
                  if g.name == 'admin'
                    admin = true
            if admin
              tc.li ->
                href = '/admin'
                pathname = window.location.pathname
                if pathname.split(href)[0] == ''
                  href = '#'
                tc.a href:href, 'Administer Site'
            tc.li ->
              tc.a href:'/logout', 'Logout'

  ########################################
  BootstrapNavBarTemplate = tc.renderable (appmodel) ->
    tc.div '.container', ->
      tc.div '#navbar-brand.navbar-header', ->
        tc.button '.navbar-toggle', type:'button', dataToggle:'collapse',
        dataTarget:'.navbar-collapse', ->
          tc.span '.sr-only', 'Toggle Navigation'
          tc.span '.icon-bar'
          tc.span '.icon-bar'
          tc.span '.icon-bar'
        tc.a '.navbar-brand', href:appmodel.brand.url, appmodel.brand.name
      tc.div '.navbar-collapse.collapse', ->
        tc.ul '#app-navbar.nav.navbar-nav', ->
          for app in appmodel.apps
            tc.li appname:app.appname, ->
              tc.a href:app.url, app.name
        tc.ul '#main-menu.nav.navbar-nav.navbar-left'
        tc.ul '#user-menu.nav.navbar-nav.navbar-right'
              

  ########################################
  BootstrapLayoutTemplate = tc.renderable () ->
    tc.div '#modal'
    tc.div '#main-navbar.navbar.navbar-default.navbar-fixed-top',
    role:'navigation'
    #div '#header.listview-header'
    tc.div '.container-fluid', ->
      tc.div '.row', ->
        tc.div '#sidebar.col-sm-2'
        tc.div '#main-content.col-sm-9'
        
    tc.div '#footer'
    
  BootstrapNoGridLayoutTemplate = tc.renderable () ->
    tc.div '#main-navbar.navbar.navbar-default.navbar-fixed-top',
    role:'navigation'
    #div '#header.listview-header'
    tc.div '.main-layout', ->
      tc.div '#sidebar'
      tc.div '#main-content'
        
    tc.div '#footer'
    
  ########################################
  main_sidebar = tc.renderable (model) ->
    tc.div '.sidebar-menu', ->
      for entry in model.entries
        tc.div '.sidebar-entry-button', buttonUrl:entry.url, ->
          tc.text entry.name          
  

  ########################################
  module.exports =
    form_group_input_div: form_group_input_div
    login_form: login_form
    name_content_form: name_content_form
    user_menu: user_menu
    BootstrapNavBarTemplate: BootstrapNavBarTemplate
    BootstrapLayoutTemplate: BootstrapLayoutTemplate
    BootstrapNoGridLayoutTemplate: BootstrapNoGridLayoutTemplate
    main_sidebar: main_sidebar
