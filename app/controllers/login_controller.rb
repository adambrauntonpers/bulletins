class LoginController < ApplicationController
  
  if RAILS_ENV == 'production' 
    require 'net/ldap'
  end

  def login
    if request.get?
      session[:teacher] = nil
      redirect_to(:action => "index")
    else
		if params[:username] == '' or params[:password] == ''
			flash[:notice] = "Please enter both username and password"
			redirect_to(:action => "index")
		else
			if RAILS_ENV == 'development' or valid_teacher(params[:username], params[:password])  
				logger.info "Valid teacher"
				session[:teacher] = params[:username]
				
				if Adminuser.find(:first, :conditions => ["username = ?", params[:username]])
				  session[:superuser] = 'true'
				end
				
				redirect_to(:controller => "bulletins")
			else 
				logger.info "Invalid teacher"
				flash[:error] = "Invalid login - this tool is for teaching staff only"
				redirect_to(:controller => "bulletins")
			end
	    end
	end
  end

  def logout 
    session[:teacher] = nil
	session[:superuser] = nil
    redirect_to(:controller => "bulletins")
  end
  
  def valid_teacher(username,password)
    ldap_con = initialize_ldap_con('PCC\\' + username, password)
    treebase = "dc=pcc,dc=local"
    user_filter = Net::LDAP::Filter.eq( "sAMAccountName", username ) 
    op_filter = Net::LDAP::Filter.eq( "objectClass", "organizationalPerson" ) 
    dn = String.new
    ldap_con.search( :base => treebase, :filter => op_filter & user_filter, :attributes=> 'dn') do |entry|
      dn = entry.dn
      logger.info dn
    end
    login_succeeded = false
    if dn.to_s.index('OU=Staff') != nil or dn.to_s.index('OU=Network Managers') != nil
		logger.info "Record DN is: " + dn.to_s
      ldap_con = initialize_ldap_con(dn,password)
      login_succeeded = true if ldap_con.bind
	end

    login_succeeded
  end
  
  def initialize_ldap_con(user_name, password)
    Net::LDAP.new( {:host => '10.3.36.2', :port => 389, :auth => { :method => :simple, :username => user_name, :password => password }} ) 
  end

end
