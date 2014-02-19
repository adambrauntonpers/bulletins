# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def nice_date(date)
    day = Date::DAYNAMES[date.wday()]
    month = Date::MONTHNAMES[date.month()]
    
    d = date.mday()
    if d == 1 or d == 21 or d == 31
      addon = "st"
    elsif d == 2 or d == 22
      addon = "nd"
    elsif d == 3 or d == 23
      addon = "rd"
    else
      addon = "th"
    end
    return day + " " + d.to_s + addon + " " + month    
  end
  
  def start_of_next_week()
	today = todays_date()
	return today.next_week(:monday)
  end
  
  def end_of_next_week()
	today = todays_date()
	return today.next_week(:friday)
  end
    
  def end_of_the_week()
	puts "Determining end of the week"
    today = todays_date()
	puts "Calculated the end of the week as: " + today.end_of_week().-(2).to_s
	return today.end_of_week().-(2)
  end
  
  
   # Returns a Date object representing today.  If today is a weekend, it returns the following Monday

  
  def todays_date()
    today = Date.today
    puts "DATE IS NOW: " + today.to_s
    puts "today.wday: " + today.wday.to_s
    if (today.wday == 0) then 
      # SUNDAY
      puts "TODAY IS A SUNDAY"
      today = today.+(1)
      puts "DATE IS NOW: " + today.to_s
    elsif (today.wday == 6) then
      # SATURDAY
	  puts "TODAY IS A Saturday"
      today = today.+(2)
	  puts "DATE IS NOW: " + today.to_s
    end
	puts "Returning " + today.to_s
    return today
  end

 
  def tomorrow()
	tomorrow = Date.today.+(1)
	
    if (tomorrow.wday == 6) then 
      # SATURDAY
      tomorrow = today.+(2)
    elsif (tomorrow.wday == 0) then
      # SUNDAY
      tomorrow = today.+(1)
    end
    return tomorrow
  end


end
