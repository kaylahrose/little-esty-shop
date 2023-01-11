require './lib/api_helper'

class ApplicationController < ActionController::Base
  helper_method :api_helper

  def api_helper
    ApiHelper.new
  end
end
