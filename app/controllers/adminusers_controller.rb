class AdminusersController < ApplicationController

  before_filter :authorise

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [:create, :update ],
         :redirect_to => { :action => :list }

  def list
    @adminusers = Adminuser.find :all
  end

  def show
    @adminuser = Adminuser.find(params[:id])
  end

  def new
    @adminuser = Adminuser.new
  end

  def create
    @adminuser = Adminuser.new(params[:adminuser])
    if @adminuser.save
      flash[:notice] = 'Adminuser was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @adminuser = Adminuser.find(params[:id])
  end

  def update
    @adminuser = Adminuser.find(params[:id])
    if @adminuser.update_attributes(params[:adminuser])
      flash[:notice] = 'Adminuser was successfully updated.'
      redirect_to :action => 'show', :id => @adminuser
    else
      render :action => 'edit'
    end
  end

  def destroy
    Adminuser.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
