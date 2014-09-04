define (require, exports, module) ->
  Backbone = require 'backbone'
  Marionette = require 'marionette'

  Templates = require 'common/templates'

  MainBus = require 'msgbus'
  
  MainBus.reqres.setHandler 'get-navbar-color', ->
    navbar = $ '#main-navbar'
    navbar.css 'color'
    
  MainBus.reqres.setHandler 'get-navbar-bg-color', ->
    navbar = $ '#main-navbar'
    navbar.css 'background-color'
    
  class MainPageLayout extends Backbone.Marionette.LayoutView
    template: Templates.BootstrapLayoutTemplate
    
  class BootstrapNavBarView extends Backbone.Marionette.ItemView
    template: Templates.BootstrapNavBarTemplate
        
  class LoginView extends Backbone.Marionette.ItemView
    template: Templates.login_form

  class UserMenuView extends Backbone.Marionette.ItemView
    template: Templates.user_menu
    
  module.exports =
    MainPageLayout: MainPageLayout
    BootstrapNavBarView: BootstrapNavBarView
    LoginView: LoginView
    UserMenuView: UserMenuView
      