require 'rspec-system/spec_helper'
require 'rspec-system-puppet/helpers'
require 'rspec-system-serverspec/helpers'
require 'fixtures/fixtures_helper'

include Serverspec::Helper::RSpecSystem
include Serverspec::Helper::DetectOS
include RSpecSystemPuppet::Helpers
include PuppetFixtures

# TODO automatically fetch the module's name (perhaps from init.pp?)
def module_name
  'nexus'
end

# TODO build a prefab (vagrant box) with the dependencies already installed
def install_dependencies
  puppet_install
  shell 'sudo yum install -y git'
  shell 'sudo gem install librarian-puppet'
end

# TODO can't use vagrant's shared folder for this purpose?
def sync_module
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  puppet_module_install(:source => proj_root, :module_name => module_name)
  shell "cd /etc/puppet/modules/#{module_name} && sudo librarian-puppet install --path /etc/puppet/modules"
end

RSpec.configure do |c|

  c.include PuppetFixtures
  c.include RSpecSystemPuppet::Helpers

  c.before :suite do
    install_dependencies
    sync_module
  end
end
