# ------------------------------------------------------------------------------
#
# Heroku Rails Template Generator
#
# John Beynon
# http://github.com/johnbeynon/heroku-rails-template
#
# -----------------------------------------------------------------------------

# Helper methods
def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

def copy_from_repo(filename, destination)
  repo = 'https://raw.github.com/codegram/heroku-rails-template/master/files/'
  get repo + filename, destination
end

def inject_into_environment(rails_env, config)
  inject_into_file( "config/environments/#{rails_env}.rb", "\n\n  #{config}", before: "\nend")
end

say 'Heroku Rails Application Generator'

copy_from_repo 'common/Gemfile', 'Gemfile'

# Add Puma config
copy_from_repo 'common/config/puma.rb', 'config/puma.rb'

# Add Rack::Timeout config
copy_from_repo 'common/config/timeout.rb', 'config/initializers/timeout.rb'

# Add newrelic.yml
copy_from_repo 'common/config/newrelic.yml.erb', 'config/newrelic.yml.erb'
template 'config/newrelic.yml.erb', 'config/newrelic.yml.erb'

# Add a Procfile
copy_from_repo 'common/Procfile', 'Procfile'

# Add a .env file for local environment variables
copy_from_repo 'common/env', '.env'

# Add .env_sample for sample local variables
copy_from_repo 'common/env_sample', '.env_sample'

# Ensure local .env file is added to .gitignore
run "echo '.env' >> .gitignore"

# Remove database.yml
# Replace with postgres friendly database.yml for local development
remove_file 'config/database.yml'
copy_from_repo 'common/config/database.yml.erb', 'config/database.yml.erb'
template 'config/database.yml.erb', 'config/database.yml'

lograge = <<-RUBY

  config.lograge.enabled = true
RUBY

inject_into_environment('production', lograge)
