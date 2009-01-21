class Preference < ActiveRecord::Base
  belongs_to :user
  belongs_to :sms_context, :class_name => 'Context'

  def self.due_styles
    { :due_in_n_days => 0, :due_on => 1}
  end

  def self.day_number_to_name_map
    { 0 => "Sunday",
      1 => "Monday",
      2 => "Tuesday",
      3 => "Wednesday",
      4 => "Thursday",
      5 => "Friday",
      6 => "Saturday"}
  end

  def hide_completed_actions?
    return show_number_completed == 0
  end

  def parse_date(s)
    return nil if s.blank?
    date = nil

    if s.is_a?(Time)
      date = s.to_date
    elsif s.is_a?(String)
      date = Date.strptime(s, date_format)
    else
      raise ArgumentError.new("Bad argument type:#{s.class}")
    end

    user.at_midnight(date)
  end

  def parse_datetime(s)
    return nil if s.blank?
    r=DateTime.strptime(s, fmt='%d/%m/%Y% %H:%M', sg=Date::ITALY)
    t=Time.zone.local(r.year, r.month, r.day, r.hour, r.min, 0)
    t.utc
  end
end