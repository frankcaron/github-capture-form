# Helpers
require 'sinatra/base'
require 'faraday'
require 'webrick/https'
require 'openssl'
require 'json'

require_relative 'db/githublead'


module Sinatra
  module StormpathGitMe
    module Helpers

        # Validate handle
        def check_handle(name)
            # Prep return var; 0=handle, 1=numrepos, 2=reponame, 3=email
            github_deets = Array.new
            github_deets[0] = name

            # If name from form is not nil or blank..
            if name.nil? or name == ""
                return nil
                puts "Name is nil"
            else 
                # Check to see if the github handle exists
                begin
                    url = ['https://frankcaron@api.github.com/users', name, 'repos'] * '/'
                    response = Faraday.get url

                # Couldn't connect to API
                rescue Exception => ex
                    puts ex.message
                    puts ex.backtrace.join("\n") 
                    return nil
                end

                # Get the status code of the response
                code = response.headers["status"].split(' ')[0]

                # Repo was found
                if code == "200"
                    
                    # Turn body into json
                    repos = JSON.parse response.body

                    unless (repos.length == 0 || repos.length == "0")
                        # Grab details
                        github_deets[1] = repos.length
                        github_deets[2] = repos[[*0..repos.length].sample]["name"]
                    else 
                        # Grab details
                        github_deets[1] = 0
                        github_deets[2] = "Insert Repo Name Here"
                    end

                    # Fetch user's email
                    url = ['https://frankcaron@api.github.com/users', name] * '/'
                    second_response = Faraday.get url
                    second_response = JSON.parse second_response.body

                    # Return email
                    email = second_response["email"]

                    unless (email.nil?)
                        github_deets[3] = email
                    else 
                        github_deets[3] = "no email on file"
                    end

                    # Create database entry for lead
                    begin
                        create_record(github_deets)

                    # Couldn't send mail
                    rescue Exception => ex
                        puts ex.message
                        puts ex.backtrace.join("\n") 
                        return nil
                    end

                    #Return the finalized variable
                    return github_deets
                end

                #API error
                puts "Error communicating with Github API"
                return nil
                
            end
        end

        # Writes to the database
        def create_record(details)
            @post = GithubLead.create(
                :email     => details[3],
                :handle    => details[0],
                :num_repos => details[1]
            )
        end

    end
  end
end