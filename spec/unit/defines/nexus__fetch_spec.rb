require 'spec_helper'

describe 'nexus::fetch', :type => :define do
  let(:title) { 'myartifact' }
  let(:defaults) {{
    artifact_id: 'junit',
    group_id: 'org.junit',
    version: '1.1.0',
    repository: 'release',
    nexus_url: 'http://nexus.com',
    deploy_at: '/tmp/apps',
    timeout: 120,
  }}

  def expected_artifact_url(nexus_url, repository, group_id, artifact_id, version)
    "#{nexus_url}/service/local/artifact/maven/redirect?r=#{repository}&g=#{group_id}&a=#{artifact_id}&v=#{version}"
  end

  context 'errors out with invalid parameters' do
    context 'when :artifact_id => empty' do
      let(:params) { defaults.merge({ artifact_id: '' }) }
      it {
        expect {
          should have_resource_count(0)
        }.to raise_error(Puppet::Error, /missing :artifact_id parameter/)
      }
    end

    context 'when :group_id => empty' do
      let(:params) { defaults.merge({ group_id: '' }) }
      it {
        expect {
          should have_resource_count(0)
        }.to raise_error(Puppet::Error, /missing :group_id parameter/)
      }
    end
  end

  context 'parameters default to' do
    context ":version => 'LATEST'" do
      let(:params) { defaults.select { |k, v| k != :version } }
      it {
        artifact_url = expected_artifact_url(
          params[:nexus_url],
          params[:repository],
          params[:group_id],
          params[:artifact_id],
          'LATEST'
        )
        should contain_wget__fetch("fetch #{title}")
        .with_source(artifact_url)
      }
    end

    context ":nexus_url => 'http://repository.sonatype.org'" do
      let(:params) { defaults.select { |k, v| k != :nexus_url } }
      it {
        artifact_url = expected_artifact_url(
         'http://repository.sonatype.org',
          params[:repository],
          params[:group_id],
          params[:artifact_id],
          params[:version]
        )
        should contain_wget__fetch("fetch #{title}")
        .with_source(artifact_url)
      }
    end

    context ":repository => 'release'" do
      let(:params) { defaults.select { |k, v| k != :repository } }
      it {
        artifact_url = expected_artifact_url(
          params[:nexus_url],
          'release',
          params[:group_id],
          params[:artifact_id],
          params[:version]
        )
        should contain_wget__fetch("fetch #{title}")
        .with_source(artifact_url)
      }
    end

    context ":deploy_at => '/tmp'" do
      let(:params) { defaults.select { |k, v| k != :deploy_at } }
      it {
        should contain_wget__fetch("fetch #{title}")
        .with_destination('/tmp')
      }
    end

    context ":timeout => 0" do
      let(:params) { defaults.select { |k, v| k != :timeout } }
      it {
        should contain_wget__fetch("fetch #{title}")
        .with_timeout(0)
      }
    end
  end

  context 'without authentication' do
    context 'when :username => empty' do
      let(:params) { defaults.merge({ username: '', password: 'secret' }) }
      it {
        artifact_url = expected_artifact_url(
          params[:nexus_url],
          params[:repository],
          params[:group_id],
          params[:artifact_id],
          params[:version]
        )

        should_not contain_wget__authfetch("fetch #{title}")
        should contain_wget__fetch("fetch #{title}")
        .with_source(artifact_url)
        .with_destination(params[:deploy_at])
        .with_timeout(params[:timeout])
      }
    end

    context 'when :password => empty' do
      let(:params) { defaults.merge({ username: 'diego', password: '' }) }
      it {
        artifact_url = expected_artifact_url(
          params[:nexus_url],
          params[:repository],
          params[:group_id],
          params[:artifact_id],
          params[:version]
        )

        should_not contain_wget__authfetch("fetch #{title}")
        should contain_wget__fetch("fetch #{title}")
        .with_source(artifact_url)
        .with_destination(params[:deploy_at])
        .with_timeout(params[:timeout])
      }
    end
  end

  context 'with authentication' do
    context 'when :username != empty and :password != empty' do
      let(:params) { defaults.merge({ username: 'diego', password: 'secret' }) }
      it {
        artifact_url = expected_artifact_url(
          params[:nexus_url],
          params[:repository],
          params[:group_id],
          params[:artifact_id],
          params[:version]
        )

        should_not contain_wget__fetch("fetch #{title}")
        should contain_wget__authfetch("fetch #{title}")
        .with_source(artifact_url)
        .with_destination(params[:deploy_at])
        .with_timeout(params[:timeout])
        .with_user(params[:username])
        .with_password(params[:password])

      }
    end
  end
end
