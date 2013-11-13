require 'rspec/core/rake_task'
require 'rspec-system/rake_task'

namespace :spec do
  desc 'prepares fixtures for spec examples'
  task :fixtures do
    verbose(false) do
      sh 'bundle exec rspec-puppet-init'
      FileUtils.rm_rf([
        'spec/classes',
        'spec/defines',
        'spec/functions',
        'spec/hosts'
      ])
      sh 'bundle exec librarian-puppet install --path=spec/fixtures/modules'
    end
  end

  desc 'run rspec using the local .rspec config file'
  RSpec::Core::RakeTask.new(:unit => :fixtures) do |t|
    t.pattern = 'spec/unit/*/*_spec.rb'
  end

  desc 'run rspec with a progress formatter'
  RSpec::Core::RakeTask.new(:progress => :fixtures) do |t|
    t.pattern = 'spec/unit/*/*_spec.rb'
    t.rspec_opts = '--format progress'
  end

  desc 'run rspec with an HTML formatter'
  RSpec::Core::RakeTask.new(:ci => :fixtures) do |t|
    t.pattern = 'spec/unit/*/*_spec.rb'
    t.rspec_opts = '--format html'
  end

  desc 'run integration tests with the proper fixtures in place'
  task :integration => [:fixtures, :system]
end
