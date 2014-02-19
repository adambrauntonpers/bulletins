class BulletinsController < ApplicationController

  before_filter :authorise, :except => [:printout, :list, :index]
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

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
    
  def end_of_the_week()
	puts "Determining end of the week"
    today = todays_date()
	puts "today is: " + today.to_s
	if (today.wday == 1) then 
		end_of_week = today.+(4)
	elsif (today.wday == 2) then 
		end_of_week = today.+(3)
	elsif (today.wday == 3) then 
		end_of_week = today.+(2)
	elsif (today.wday == 4) then 
		end_of_week = today.+(1)
	elsif (today.wday == 5) then 
		end_of_week = today
	end
	return end_of_week
  end
  
  def yesterdays_date(todays_date)
    if todays_date.wday == 1
      return todays_date.-2
    else
      return todays_date.-1
    end
  end



  def list

    @today = todays_date()
	
    @bulletins_to_everyone = Bulletin.find(:all, :conditions => ["validfrom <= ? and validto >= ? and bulletins.year7 = ? and bulletins.year8 = ? and bulletins.year9 = ? and bulletins.year10 = ? and bulletins.year11 = ?", @today, @today, 1, 1, 1, 1, 1])
    
    if params[:year] == "7"
    	@bulletins_to_others = Bulletin.find(:all, :conditions => ["validfrom <= ? and validto >= ? and bulletins.year7 = ? and not (bulletins.year8 = ? and bulletins.year9 = ? and bulletins.year10 = ? and bulletins.year11 = ?)", @today, @today, 1, 1, 1, 1, 1], :order => "bulletins.freetext")
    elsif params[:year] == "8"
    	@bulletins_to_others = Bulletin.find(:all, :conditions => ["validfrom <= ? and validto >= ? and bulletins.year8 = ? and not (bulletins.year7 = ? and bulletins.year9 = ? and bulletins.year10 = ? and bulletins.year11 = ?)", @today, @today, 1, 1, 1, 1, 1], :order => "bulletins.freetext")
    elsif params[:year] == "9"
    	@bulletins_to_others = Bulletin.find(:all, :conditions => ["validfrom <= ? and validto >= ? and bulletins.year9 = ? and not (bulletins.year7 = ? and bulletins.year8 = ? and bulletins.year10 = ? and bulletins.year11 = ?)", @today, @today, 1, 1, 1, 1, 1], :order => "bulletins.freetext")
    elsif params[:year] == "10"
    	@bulletins_to_others = Bulletin.find(:all, :conditions => ["validfrom <= ? and validto >= ? and bulletins.year10 = ? and not (bulletins.year7 = ? and bulletins.year8 = ? and bulletins.year9 = ? and bulletins.year11 = ?)", @today, @today, 1, 1, 1, 1, 1], :order => "bulletins.freetext")
    elsif params[:year] == "11"
    	@bulletins_to_others = Bulletin.find(:all, :conditions => ["validfrom <= ? and validto >= ? and bulletins.year11 = ? and not (bulletins.year7 = ? and bulletins.year8 = ? and bulletins.year9 = ? and bulletins.year10 = ?)", @today, @today, 1, 1, 1, 1, 1], :order => "bulletins.freetext")
    else
    	@bulletins_to_others = Bulletin.find(:all, :conditions => ["validfrom <= ? and validto >= ? and (bulletins.year7 = ? or bulletins.year8 = ? or bulletins.year9 = ? or bulletins.year10 = ? or bulletins.year11 = ?)", @today, @today, 0, 0, 0, 0, 0], :order => "year7, year8, year9, year10, year11")
    end
	
    @upcoming_to_everyone = Bulletin.find(:all, :conditions => ["validfrom > ? and bulletins.year7 = ? and bulletins.year8 = ? and bulletins.year9 = ? and bulletins.year10 = ? and bulletins.year11 = ?", @today, 1, 1, 1, 1, 1])
    @upcoming_to_others = Bulletin.find(:all, :conditions => ["validfrom > ? and (bulletins.year7 = ? or bulletins.year8 = ? or bulletins.year9 = ? or bulletins.year10 = ? or bulletins.year11 = ?)", @today, 0, 0, 0, 0, 0], :order => "year7, year8, year9, year10, year11")
  end



  def show
    @bulletin = Bulletin.find(params[:id])
  end

  def new
	puts 'In NEW action for Bulletin'
    @bulletin = Bulletin.new
    @bulletin.valid = 'tomorrow'
    @bulletin.validfrom = Date.today
    @bulletin.validto = Date.today
  end

  def create
  
  	unless session[:teacher] != nil
  		redirect_to :action => 'login', :controller => 'login'
  	end
	
    @bulletin = Bulletin.new(params[:bulletin])

    Bulletin.destroy_all(["validto < ?", Date.today])

    if params[:bulletin][:valid] == "tomorrow"
		day_tomorrow = Time.now.tomorrow
		if day_tomorrow.strftime("%A") == 'Saturday'
			day_tomorrow = Time.now.next_week.at_beginning_of_week
		end
      @bulletin.validfrom = day_tomorrow
      @bulletin.validto = day_tomorrow
    end
    
    if params[:bulletin][:valid] == "thisweek"
      @bulletin.validfrom = todays_date()
      @bulletin.validto = end_of_the_week()
    end
    
    if params[:bulletin][:valid] == "nextweek"
      @bulletin.validfrom = Time.now.next_week.at_beginning_of_week
      @bulletin.validto = Time.now.next_week.at_beginning_of_week + 4.days
    end
	
    @bulletin.createdBy = session[:teacher]
    
    if @bulletin.save
      flash[:notice] = 'Bulletin was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @bulletin = Bulletin.find(params[:id])
  end

  def update
    @bulletin = Bulletin.find(params[:id])
	
	@bulletin.update_attributes(params[:bulletin])
	
	if params[:bulletin][:valid] == "tomorrow"
		day_tomorrow = Time.now.tomorrow
		if day_tomorrow.strftime("%A") == 'Saturday'
			day_tomorrow = Time.now.next_week.at_beginning_of_week
		end
      @bulletin.validfrom = day_tomorrow
      @bulletin.validto = day_tomorrow
    end
    
    if params[:bulletin][:valid] == "thisweek"
      @bulletin.validfrom = Time.now.monday
      @bulletin.validto = Time.now.monday + 4.days
    end
    
    if params[:bulletin][:valid] == "nextweek"
      @bulletin.validfrom = Time.now.next_week.at_beginning_of_week
      @bulletin.validto = Time.now.next_week.at_beginning_of_week + 4.days
    end
	
	if @bulletin.save
      flash[:notice] = 'Bulletin was successfully updated.'
      redirect_to :action => 'list'
	else 
		redirect_to :action => 'edit'
	end
  end

  def destroy
    Bulletin.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def printregisters
    @today = todays_date()
    @yesterday = yesterdays_date(@today)
    @oldBulletins = Array.new()
    @newBulletins = Array.new()
    @bulletins_to_everyoneToday = Array.new()
    @bulletins_to_everyoneRepeated = Array.new()
    @year7bulletinsToday = Array.new()
    @year7bulletinsRepeated = Array.new()
    @year8bulletinsToday = Array.new()
    @year8bulletinsRepeated = Array.new()
    @year9bulletinsToday = Array.new()
    @year9bulletinsRepeated = Array.new()
    @year10bulletinsToday = Array.new()
    @year10bulletinsRepeated = Array.new()
    @year11bulletinsToday = Array.new()
    @year11bulletinsRepeated = Array.new()



    # Get all valid Bulletins
    @validBulletins = Bulletin.find(:all, :conditions => ["validfrom <= ? and validto >= ?", @today, @today], :order => "bulletins.freetext")
        
    # For each valid bulletin, check whether it's a new or old
    @validBulletins.each do |bulletin|
        logger.info bulletin.freetext + ": " + bulletin.validfrom.to_s() + ": " + bulletin.validto.to_s() + ": " + bulletin.year7.to_s()
        if bulletin.validfrom == @today or bulletin.validfrom == @yesterday
            @newBulletins << bulletin
        else
            @oldBulletins << bulletin
        end
    end

    logger.info "Found " + @newBulletins.length().to_s() + " new bulletins and " + @oldBulletins.length().to_s() + " old bulletins"

    @newBulletins.each do |newBulletin|
        if newBulletin.for_everyone
            @bulletins_to_everyoneToday << newBulletin
		else
			if newBulletin.for_year7
				@year7bulletinsToday << newBulletin   
			end
			if newBulletin.for_year8
				@year8bulletinsToday << newBulletin    
			end
			if newBulletin.for_year9
				@year9bulletinsToday << newBulletin    
			end
			if newBulletin.for_year10
				@year10bulletinsToday << newBulletin    
			end
			if newBulletin.for_year11
				@year11bulletinsToday << newBulletin    
			end
        end
    end

    @oldBulletins.each do |oldBulletin|
        if oldBulletin.for_everyone
            @bulletins_to_everyoneRepeated << oldBulletin
		else
			if oldBulletin.for_year7
				@year7bulletinsRepeated << oldBulletin
			end
			if oldBulletin.for_year8
				@year8bulletinsRepeated << oldBulletin
			end
			if oldBulletin.for_year9
				@year9bulletinsRepeated << oldBulletin
			end
			if oldBulletin.for_year10
				@year10bulletinsRepeated << oldBulletin
			end
			if oldBulletin.for_year11
				@year11bulletinsRepeated << oldBulletin
			end
		end
    end

    render(:layout => false)
  end
  
  def printout
    @today = todays_date()
    @bulletins_to_everyone = Bulletin.find(:all, :conditions => ["validfrom <= ? and validto >= ? and bulletins.year7 = ? and bulletins.year8 = ? and bulletins.year9 = ? and bulletins.year10 = ? and bulletins.year11 = ?", @today, @today, 1, 1, 1, 1, 1])
    if params[:year] == "7"
    	@bulletins_to_others = Bulletin.find(:all, :conditions => ["validfrom <= ? and validto >= ? and bulletins.year7 = ? and not (bulletins.year8 = ? and bulletins.year9 = ? and bulletins.year10 = ? and bulletins.year11 = ?)", @today, @today, 1, 1, 1, 1, 1], :order => "bulletins.freetext")
    	@year = "<br />Bulletins for Year " + params[:year]
    elsif params[:year] == "8"
       @bulletins_to_others = Bulletin.find(:all, :conditions => ["validfrom <= ? and validto >= ? and bulletins.year8 = ? and not (bulletins.year7 = ? and bulletins.year9 = ? and bulletins.year10 = ? and bulletins.year11 = ?)", @today, @today, 1, 1, 1, 1, 1], :order => "bulletins.freetext")
    	@year = "<br />Bulletins for Year " + params[:year]
    elsif params[:year] == "9"
       @bulletins_to_others = Bulletin.find(:all, :conditions => ["validfrom <= ? and validto >= ? and bulletins.year9 = ? and not (bulletins.year7 = ? and bulletins.year8 = ? and bulletins.year10 = ? and bulletins.year11 = ?)", @today, @today, 1, 1, 1, 1, 1], :order => "bulletins.freetext")
    	@year = "<br />Bulletins for Year " + params[:year]
    elsif params[:year] == "10"
       @bulletins_to_others = Bulletin.find(:all, :conditions => ["validfrom <= ? and validto >= ? and bulletins.year10 = ? and not (bulletins.year7 = ? and bulletins.year8 = ? and bulletins.year9 = ? and bulletins.year11 = ?)", @today, @today, 1, 1, 1, 1, 1], :order => "bulletins.freetext")
    	@year = "<br />Bulletins for Year " + params[:year]
    elsif params[:year] == "11"
       @bulletins_to_others = Bulletin.find(:all, :conditions => ["validfrom <= ? and validto >= ? and bulletins.year11 = ? and not (bulletins.year7 = ? and bulletins.year8 = ? and bulletins.year9 = ? and bulletins.year10 = ?)", @today, @today, 1, 1, 1, 1, 1], :order => "bulletins.freetext")
    	@year = "<br />Bulletins for Year " + params[:year]
    else 
    	@bulletins_to_others = Bulletin.find(:all, :conditions => ["validfrom <= ? and validto >= ? and (bulletins.year7 = ? or bulletins.year8 = ? or bulletins.year9 = ? or bulletins.year10 = ? or bulletins.year11 = ?)", @today, @today, 0, 0, 0, 0, 0], :order => "year7, year8, year9, year10, year11")
    end
    render(:layout => false)
  end
end
