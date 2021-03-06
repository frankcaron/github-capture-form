## MainRouter
## 
## Serves the form and processes it

require "sinatra/base"

module Sinatra
    module StormpathGitMe
        module MainRouter
            def self.registered(app)

                app.before do
                    cache_control :no_cache, :no_store, :must_revalidate, :max_age => 0
                end

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

                # Handle Github API Down
                app.get '/github_down' do
                    erb :github_down
                end

                # Catch all
                app.get '/*' do
                    redirect '/'
                end

                # Catch form abuse
                app.post '/' do
                    $form_submitted = false
                    erb :main_superfailed
                end

            end
        end
    end
end