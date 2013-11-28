namespace :whoops do
  desc "Data migration to set the event count, as of 0.2.4"
  task :set_event_count => :environment do
    Whoops::EventGroup.all.each do |e|
      e.event_count = e.events.count
      e.save
    end
  end

  desc "Remove event groups and events which happened more then 7 days ago"
  task :cleanup_old_events => :environment do
    Whoops::EventGroup.where(:last_recorded_at.lt => 7.days.ago).destroy
    Whoops::Event.where(:event_time.lt => 7.days.ago).destroy
  end
end
