class GithubLead
  include DataMapper::Resource

  property :id,         Serial      # An auto-increment integer key
  property :email,        Text      # User's email address
  property :handle,       Text      # User's Github handle
  property :num_repos, Integer      # Number of Github repositories
end

DataMapper.finalize