#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See 
#   the COPYRIGHT file.

class ServicesController < ApplicationController
  before_filter :authenticate_user!, :except => [:facebook_canvas_redirect]
  protect_from_forgery :except => [:facebook_canvas_redirect]
  
  def index
    @services = current_user.services
  end

  def destroy
    @service = current_user.services.find(params[:id])
    @service.destroy
    flash[:notice] = I18n.t 'services.destroy.success'
    redirect_to services_url
  end

  def redirect_from_service
    render :text => ("<script>window.close()</script>")
  end

  def facebook_canvas_redirect 
    url = user_omniauth_authorize_url(:provider => 'facebook', :state => 'redirect')
    render :text => ("<script>top.location='#{url}'</script>")
  end
end