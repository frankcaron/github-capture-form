## MainRouter
## 
## Serves the form and processes it

require "sinatra/base"

module Sinatra
    module StormpathGitMe
        module MainRouter
            def self.registered(app)

                app.get '/' do
                    erb :main
                end

                app.post '/' do

                    github = params[:github_handle]
                    handle_passes = check_handle(github)

                    unless (handle_passes.nil? or handle_passes == "")
                        @github_handle = handle_passes
                        erb :main_validated
                    else
                        erb :main_failed
                    end
                end

            end
        end
    end
end