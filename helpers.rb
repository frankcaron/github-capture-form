# Helpers
require 'sinatra/base'
require 'Faraday'
require 'webrick/https'
require 'openssl'

module Sinatra
  module StormpathGitMe
    module Helpers

        # Check to see if the Github handle exists
        def check_handle(name)
            
            if name.nil? or name == ""
                return nil
            else 
                check_github_for_handle(name)
                return name
            end
        end

        # Connect to github and check for handle
        def check_github_for_handle(handle)
            response = Faraday.get ['https://api.github.com', handle, '/repos'] * '/'

        end

    end
  end
end