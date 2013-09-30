## MainRouter
## 
## Serves the form and processes it

require "sinatra/base"

module Sinatra
    module StormpathGitMe
        module MainRouter
            def self.registered(app)

                app.get '/' do
                    $form_submitted = false
                    erb :main
                end

                app.post '/process' do

                    github = params[:github_handle]

                    unless ($form_submitted)
                        $form_submitted = true
                        handle_passes = check_handle(github)
                    end

                    unless (handle_passes.nil? or handle_passes == "")
                        @github_handle = handle_passes[0]
                        @github_num_repos = handle_passes[1]
                        @github_repo_name = handle_passes[2]
                        erb :main_validated
                    else
                        erb :main_failed
                    end
                end

                app.get '/*' do
                    $form_submitted = false
                    erb :main
                end

                app.post '/' do
                    $form_submitted = false
                    erb :main_superfailed
                end

            end
        end
    end
end