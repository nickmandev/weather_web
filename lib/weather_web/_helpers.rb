require 'sinatra/base'
module Sinatra
  module SessionHelper
    def current_user
      session['current_user']
    end
  end
  register SessionHelper
end
