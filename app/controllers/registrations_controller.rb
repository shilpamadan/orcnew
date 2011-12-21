class RegistrationsController < ApplicationController
  before_filter :login_required

  def index
    @registrations = Registration.where(:is_delete => false)
  end

  def show
    @registration = Registration.where(:id => params[:id], :is_delete => false)
  end

  def new
    visitor_id = params[:visitor_id]
    @event_list = Event.where(:is_delete => false)
    if (visitor_id.nil?)
      visitor = Visitor.find(1)
      @registration = Registration.new
      @registration.visitor = visitor

    else
      visitor = Visitor.find(visitor_id)
      @registration = Registration.new
      @registration.visitor = visitor
    end
  end

  def create
    @registration = Registration.new(params[:registration])
    visitor_id = params[:registration][:visitor_id]
    visitor = Visitor.find(visitor_id)
    @registration.visitor = visitor 
    @registration.is_delete = false
    if @registration.save
      redirect_to registrations_path
    else
      render new_registration_path
    end
  end

  def edit
    @registration = Registration.where(:id => params[:id], :is_delete => false)
  end

  def update
    @registration = Registration.find(params[:id])
    if @registration.update_attributes(params[:registration])
      flash[:notice] = "Registration successfully updated"
      redirect_to registrations_path
    else
      render edit_registration_path(params[:id])
    end  
  end

  def destroy
    @registration = Registration.find(params[:id])
    @registration.update_attribute(:is_delete, true)
  end

end
