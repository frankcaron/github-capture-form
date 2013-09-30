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

                # Couldn't connect to API
                rescue Exception => ex
                    # puts ex.message
                    # puts ex.backtrace.join("\n") 
                    return nil
                end

                # Get the status code of the response
                code = response.headers["status"].split(' ')[0]

                # Repo was found
                if code == "200"
                    
                    # Turn body into json
                    repos = JSON.parse response.body

                    unless (repos.length == 0)
                        # Grab details
                        github_deets[1] = repos.length
                        github_deets[2] = repos[[*0..repos.length].sample]["name"]
                    else 
                        # Grab details
                        github_deets[1] = 0
                        github_deets[2] = "Insert Repo Name Here"
                    end

                    # Send email
                    begin
                        send_email(name)

                    # Couldn't send mail
                    rescue Exception => ex
                        # puts ex.message
                        # puts ex.backtrace.join("\n") 
                        return nil
                    end

                    #Return the finalized variable
                    return github_deets
                end

                #No repo found
                return nil
                
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