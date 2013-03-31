class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end
  
  def after_sign_in_path_for(resource)
    session[:user_return_to].nil? ? user_root_path : session[:user_return_to].to_s
  end

  #
  # select total hours of records grouped by proper time period
  #
  def groups_total_hours(records, from, to, rows)
    groups_total_hours = []
    # days difference between rows
    days = ((to - from) / rows).to_i + 1
    (0..rows-1).each do |i|
      i_from = to - (i+1) * days
      i_to = to - i * days
      # break if time period of current row is out of time area delimited by from and to  
      break if from > i_to
      date = i_to - days / 2
      total_hours = records.where("date(records.created_at) > ? and date(records.created_at) <= ?", i_from, i_to).sum("hours")
      groups_total_hours << {date: date, total_hours: total_hours}
    end
    groups_total_hours    
  end
end
