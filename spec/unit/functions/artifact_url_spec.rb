require 'spec_helper'

describe 'artifact_url', :type => :puppet_function do
  it 'mounts nexus artifact url based on the provided parameters' do
    should run.with_params({
      'url'         => 'http://nexus',
      'repository'  => 'repo',
      'group_id'    => 'group',
      'artifact_id' => 'artifact',
      'version'     => 'v1.0',
    })
    .and_return('http://nexus/service/local/artifact/maven/redirect?r=repo&g=group&a=artifact&v=v1.0')

    should run.with_params({
      'url'         => 'http://nexus.com',
      'repository'  => 'release',
      'group_id'    => 'org.junit',
      'artifact_id' => 'junit',
      'version'     => '1.1.0',
    })
    .and_return('http://nexus.com/service/local/artifact/maven/redirect?r=release&g=org.junit&a=junit&v=1.1.0')
  end
end
