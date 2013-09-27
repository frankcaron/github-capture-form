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
                        @github_handle = handle_passes[0]
                        @github_num_repos = handle_passes[1]
                        @github_repo_name = handle_passes[2]
                        erb :main_validated
                    else
                        erb :main_failed
                    end
                end

            end
        end
    end
end