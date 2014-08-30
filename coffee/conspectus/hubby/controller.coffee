define (require, exports, module) ->
  $ = require 'jquery'
  Backbone = require 'backbone'
  Marionette = require 'marionette'
  MainBus = require 'msgbus'

  Views = require 'hubby/views'
  Models = require 'hubby/models'
  AppBus = require 'hubby/msgbus'
  
  Collections = require 'hubby/collections'

  fullCalendar = require 'fullcalendar'
  { navbar_set_active
    scroll_top_fast } = require 'common/util'
  
  
  sidebar_model = new Backbone.Model
    entries: [
      {
        url: '#hubby'
        name: 'Main Calendar'
      }
      {
        url: '#hubby/listmeetings'
        name: 'List Meetings'
      }
    ]

  meetings = AppBus.reqres.request 'meetinglist'
  
  class Controller extends Backbone.Marionette.Controller
    make_sidebar: ->
      MainBus.vent.trigger 'sidebar:close'
      view = new Views.SideBarView
        model: sidebar_model
      MainBus.vent.trigger 'sidebar:show', view
      
    set_header: (title) ->
      header = $ '#header'
      header.text title
      
    start: ->
      #console.log 'hubby start'
      MainBus.vent.trigger 'rcontent:close'
      MainBus.vent.trigger 'sidebar:close'
      @set_header 'Hubby'
      @show_calendar()
      
    show_calendar: () ->
      #console.log 'hubby show calendar'
      @make_sidebar()
      view = new Views.MeetingCalendarView
      MainBus.vent.trigger 'rcontent:show', view
      scroll_top_fast()
      
    show_meeting: (meeting_id) ->
      #console.log 'show_meeting called'
      @make_sidebar()
      meeting = new Models.MainMeetingModel
        id: meeting_id
      response = meeting.fetch()
      response.done =>
        view = new Views.ShowMeetingView
          model: meeting
        MainBus.vent.trigger 'rcontent:show', view
      scroll_top_fast()

    list_meetings: () ->
      #console.log 'list_meetings called'
      @make_sidebar()
      view = new Views.MeetingListView
        collection: meetings
      if meetings.length == 0
        meetings.fetch()
      MainBus.vent.trigger 'rcontent:show', view
      scroll_top_fast()
      
  module.exports = Controller
  
