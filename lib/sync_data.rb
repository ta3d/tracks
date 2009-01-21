require 'vpim/icalendar'
module SyncData
  
  def build_syncdata (synctodo , todo)
      synctodo.user_id = todo.user_id
      synctodo.todo_id = todo.id 
      build_vtodo_data synctodo , todo
      build_vcalendar_data synctodo , todo
      synctodo.save
      puts synctodo.sync_vtodo_content
      puts synctodo.sync_vcalendar_content
  end
    
    
  def build_vtodo_data (synctodo , todo)
      vtodo_content = Vpim::Icalendar.create
      todostr = "["+todo.context.name+"]"+todo.description
      desc=""
      if todo.notes?
        desc = todo.notes
      end
      x=Vpim::Icalendar::Vtodo.create('SUMMARY' => todostr, 'DUE'=>todo.remindtime.utc, "DESCRIPTION"=>desc)
      vtodo_content.push x
      vtodo_content.add_event do |e|
          e.summary       todo.description
          e.dtstart       todo.due.to_time
          e.dtend         todo.due.to_time
        if todo.notes?
          e.description  todo.notes
        end 
        e.categories    [ todo.context.name ]
        if todo.project_id?
          e.categories do |c| c.push todo.project.name end
        end
#        e.url           'http://www.example.com'
#        e.sequence      0
#        e.access_class  "PRIVATE"
#        e.transparency  'OPAQUE'
        now = Time.now
        e.created       now
        e.lastmod       now
      end
      synctodo.sync_vtodo_content = vtodo_content.encode

  end
  
  def build_vcalendar_data (synctodo , todo)
      vcalendar_content = Vpim::Icalendar.create2
      todostr = todo.description
      desc=''
      if todo.notes?
        desc = todo.notes
      end
      categories = todo.context.name
      if todo.project_id?
        categories << ',' + todo.project.name
      end
      now = Time.now
      y=Vpim::Icalendar::Vevent.create(todo.due.to_time, 'SUMMARY' => todostr,'DTSTART'=>todo.remindtime.utc, 'DTEND'=>todo.remindtime.utc, 
                                                            "DESCRIPTION"=>desc, "CATEGORIES"=>categories
                                                             )

      y = Vpim::Icalendar::Vevent::Maker.make(y){|e| 
          e.summary       todo.description
          e.dtstart       todo.remindtime.utc
          e.dtend         todo.remindtime.utc
        if todo.notes?
          e.description  todo.notes
        end 
        e.categories   [ categories ]
#        e.url           'http://www.example.com'
#        e.sequence      0
#        e.access_class  "PRIVATE"
#        e.transparency  'OPAQUE'
        now = Time.now
        e.created       now
        e.lastmod       now
      }
      vcalendar_content.push y
      synctodo.sync_vcalendar_content = vcalendar_content.encode
  end

end
