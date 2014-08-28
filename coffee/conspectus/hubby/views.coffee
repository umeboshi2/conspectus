define (require, exports, module) ->
  Backbone = require 'backbone'
  MSGBUS = require 'msgbus'
  Marionette = require 'marionette'

  Templates = require 'hubby/templates'
  Models = require 'hubby/models'
  BaseSideBarView = require 'common/views/sidebar'
  
  require 'jquery-ui'

  class SideBarView extends BaseSideBarView
      
  render_calendar_event = (calEvent, element) ->
    calEvent.url = '#hubby/viewmeeting/' + calEvent.id
    element.css
      'font-size' : '0.9em'

  calendar_view_render = (view, element) ->
    MSGBUS.commands.execute 'hubby:maincalendar:set_date'

  loading_calendar_events = (bool) ->
    loading = $ '#loading'
    header = $ '.fc-header'
    if bool
      loading.show()
      header.hide()
    else
      loading.hide()
      header.show()
      
      
    
  class SimpleMeetingView extends Backbone.Marionette.ItemView
    template: Templates.meeting_list_entry
    
  class MeetingListView extends Backbone.Marionette.CollectionView
    childView: SimpleMeetingView

  class MeetingCalendarView extends Backbone.Marionette.ItemView
    template: Templates.meeting_calendar

    onDomRefresh: () ->
      # get the current calendar date that has been stored
      # before creating the calendar
      date  = MSGBUS.reqres.request 'hubby:maincalendar:get_date'
      navbar_color = MSGBUS.reqres.request 'hubby:navbar-color'
      navbar_bg_color = MSGBUS.reqres.request 'hubby:navbar-bg-color'
      cal = $ '#maincalendar'
      cal.fullCalendar
        header:
          left: 'today'
          center: 'title'
          right: 'prev, next'
        theme: true
        defaultView: 'month'
        eventSources:
          [
            url: 'http://hubby.littledebian.org/hubcal'
          ]
        eventRender: render_calendar_event
        viewRender: calendar_view_render
        loading: loading_calendar_events
        eventColor: navbar_bg_color
        eventTextColor: navbar_color
        eventClick: (event) ->
          url = event.url
          Backbone.history.navigate url, trigger: true
      # if the current calendar date that has been set,
      # go to that date
      if date != undefined
        cal.fullCalendar('gotoDate', date)
        
  class ShowMeetingView extends Backbone.Marionette.ItemView
    template: Templates.show_meeting_view

    onDomRefresh: () ->
      attachments = $ '.hubby-meeting-item-attachments'
      attachments.hide()
      attachments.draggable()
      $('.hubby-meeting-item-info').click ->
        $(this).next().toggle()
      $('.hubby-meeting-item-attachment-marker').click ->
        $(this).next().toggle()
      $('.hubby-meeting-item-action-marker').click ->
        el = $(this)
        action_area = el.next()
        if el.hasClass('itemaction-loaded')
          action_area.toggle()
        else
          itemid = el.attr('id')
          req = 'hubby:item_action_collection'
          collection = MSGBUS.reqres.request req, itemid
          response = collection.fetch()
          response.done =>
            html = ''
            for model in collection.models
              html += Templates.short_action model.attributes
            action_area.html html
            $(this).addClass('itemaction-loaded')
        
        
  module.exports =
    SimpleMeetingView: SimpleMeetingView
    MeetingListView: MeetingListView
    MeetingCalendarView: MeetingCalendarView
    ShowMeetingView: ShowMeetingView
    SideBarView: SideBarView
    
    
