## -----------------
## 
## Stormpath Git Me
## 
## Written by Frank Caron
## frank@stormpath.com
##
##
## A little utility for conferences to follow up
## with cool devs we meet.
## 
## September 26, 2013
## -----------------

# Internal Reqs
require_relative 'routes/main_router'
require_relative 'helpers'

# Interal Vars
API_KEY = ENV['MAILGUN_API_KEY']
API_URL = "https://api:#{API_KEY}@api.mailgun.net/v2/<your-mailgun-domain>"

# External Reqs
require 'sinatra/base'

# Construct the main StormpathGitMe App as a Modular Sinatra App
class StormpathGitMe < Sinatra::Base

    # Set root
    set :root, File.dirname(__FILE__)

    # Set views
    set :views, File.expand_path('../views', __FILE__)

    # Configure logging
    configure :production, :development do
        enable :logging
    end

    # Enable Sessions
    enable :sessions

    # Set Method Override
    enable :method_override

    # Handle errors
    not_found do
        erb :not_found
    end

    # Register Helpers
    helpers Sinatra::StormpathGitMe::Helpers

    # Register Routers
    # Note that the order is critical as requests are handled top to bottom 
    register Sinatra::StormpathGitMe::MainRouter

end