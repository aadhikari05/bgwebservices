class PermitMeController < ApplicationController

  layout "index"
  
  def show
    @queryResults = PermitmeResource.find(:all)  
  end
end