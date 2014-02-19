class Bulletin < ActiveRecord::Base
  validates_presence_of :message
  validates_presence_of :valid, :message => 'range must be chosen'
  attr_accessor :valid
  

  def validate
    if validfrom > validto
      errors.add_to_base("Invalid timespan")
    end
	if year7 == 0 and year8 == 0 and year9 == 0 and year10 == 0 and year11 == 0
		errors.add_to_base("Please choose a year")
	end
  end

  def for_everyone
    return (year7 > 0 and year8 > 0 and year9 > 0 and year10 > 0 and year11 > 0)
  end

  def for_year7
    return year7 > 0 
  end

  def for_year8
    return year8 > 0 
  end

  def for_year9
    return year9 > 0 
  end

  def for_year10
    return year10 > 0 
  end

  def for_year11
    return year11 > 0 
  end

  
  def from_list
    @list = ""
    
    if year7 > 0 and year8 > 0 and year9 > 0 and year10 > 0 and year11 > 0
      @list = "Everyone"
    else
	  @list = @list + "Year "
      if year7 > 0
        @list = @list + "7"
      end
      if year8 > 0
        if @list.length > 5
          @list = @list + ", "
        end
        @list = @list + "8"
      end
      if year9 > 0
        if @list.length > 5
          @list = @list + ", "
        end
        @list = @list + "9"
      end
      if year10 > 0
        if @list.length > 5
          @list = @list + ", "
        end
        @list = @list + "10"
      end
      if year11 > 0
        if @list.length > 5
          @list = @list + ", "
        end
        @list = @list + "11"
      end
    
    end
    return @list  
  end

  
end
