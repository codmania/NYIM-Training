class FullCalendar::Widget < Application::Widget

  needs :options
  def widget_content
    options = @options
    event_class = options[:event_class].to_s.classify.constantize || controller.resource_class
    options = options.reverse_merge(:id => dom_id(resource,:calendar),
    :view => 'month', :year => Time.now.year, :month => Time.now.month - 1,
    :details_dom_id => dom_id(resource,:calendar_details),
    :start_param => 'search[calendar_from_dt]',
    :end_param => 'search[calendar_to_dt]',
    :url => polymorphic_path(event_class.new(:id => '%(id)')),
    :json_feed_url => polymorphic_path(event_class,{ :format => :json }.reverse_merge(options[:extra_params])))
    javascript_tag(full_calendar_js(options))
    full_calendar_html_scaffold(options)
  end

  def full_calendar_html_scaffold(options)
    div :id => options[:id]
    div(:id => options[:details_dom_id] + '_desc_dialog', :style => "display:none;")
    
  end

  def full_calendar_js(options={})
    #loading: function(bool){},
    #http://arshaw.com/fullcalendar/docs/event_data/events_json_feed/
    #The GET parameter names will be determined by the startParam and endParam options. ("start" and "end" by default).
    #http://arshaw.com/fullcalendar/docs/text/
    #timeFormat: 'h:mm t{ - h:mm t} ',
    #dragOpacity: "0.5",
    # event responders
    # http://arshaw.com/fullcalendar/docs/mouse/

    #dayClick (callback)    Triggered when the user clicks on a day.
    #eventMouseover (callback)    Triggered when the user mouses over an event.
    #eventMouseout (callback)    Triggered when the user mouses out of an event.
    <<EOF
    $(document).ready(function(){
      // page is now ready, initialize the calendar...
      $('\##{options[:id]}').fullCalendar({
          loading: function(bool){
            if (bool) { $('\#spinner').show(); } else { $('\#spinner').hide(); } 
          },
          allDaySlot: false,
          firstDay: 1,
          firstHour: 11,
          year: #{options[:year]},
          month: #{options[:month]},
          minTime: 10,
          maxTime: 22,
          editable: false,
          header: {
              //left: 'prev,next today',
              left: 'prev',
              center: 'title',
              //right: 'month,agendaWeek,agendaDay'
              right: 'next'
          },
          defaultView: '#{options[:view]}',
          //height: 300,
          //slotMinutes: 30,
          events: '#{options[:json_feed_url]}',
          startParam: '#{options[:start_param]}',
          endParam: '#{options[:end_param]}',
          eventClick: function(event, jsEvent, view) {
            var url = '/signups/new.js?signup[course_id]=' + event.course_id + '&signup[scheduled_course_id]=' + event.id;
            $.get(url);
            return false;
          },
          eventMouseover: function(event, jsEvent, view) {
            var course = $('\#li_scheduled_course_' + event.id);
            if (course.length) { 
              course.attr('background-color',course.css('background-color'));
              course.css('background-color', 'orange');
            } else {
              $('\#calendar_popup .info').html(event.info);
              $('\#calendar_popup .thumb').html('<img class="rounded-corners-shadow" width="30" height="30" src="%(src)" alt="%(alt)">'.replace('%(src)',event.trainer_photo).replace('%(alt)',event.trainer_name));
              $('\#calendar_popup').show();
            };
           return false;
          },
          eventMouseout: function(event, jsEvent, view) {
            var course = $('\#li_scheduled_course_' + event.id);
            
            if (course.length) { 
              course.css('background-color', course.attr('background-color'));
            } else {
              $('\#calendar_popup').hide();
            };
            return false;
          }
    })
  });
EOF
  end

end