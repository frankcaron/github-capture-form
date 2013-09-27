# Helpers
require 'sinatra/base'
require 'faraday'
require 'webrick/https'
require 'openssl'
require 'json'
require 'rest_client'


module Sinatra
  module StormpathGitMe
    module Helpers

        # Validate handle
        def check_handle(name)
            # Prep return var; 0=handle, 1=numrepos, 2=reponame
            github_deets = Array.new
            github_deets[0] = name

            # If name from form is not nil or blank..
            if name.nil? or name == ""
                return nil
            else 
                # Check to see if the github handle exists
                begin
                    url = ['https://api.github.com/users', name, 'repos'] * '/'
                    response = Faraday.get url
                    code = response.headers["status"].split(' ')[0]

                    # Repo was found
                    if code == "200"
                        
                        # Turn body into json
                        repos = JSON.parse response.body

                        # Grab details
                        github_deets[1] = repos.length
                        github_deets[2] = repos[[*0..repos.length].sample]["name"]

                        # Send email
                        send_email name

                        return github_deets
                    end

                    #No repo found
                    return nil
                rescue
                    #Connection to Github API died.
                    return nil
                end
                
            end
        end

        # Send an email to inform us about the specified github name
        def send_email(name) 

            RestClient.post API_URL+"/messages", 
                :from => "stormpathgitme@stormpath.com",
                :to => "frank@stormpath.com",
                :subject => "Conference Git Submission",
                :html => "<a href='http://github.com/" + name +"''>" + name + "</a>"
        end

    end
  end
end