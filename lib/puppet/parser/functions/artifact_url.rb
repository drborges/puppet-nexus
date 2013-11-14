# -*- encoding : utf-8 -*-
module Puppet::Parser::Functions
  newfunction(:artifact_url, :type => :rvalue) do |args|
    nexus = args[0]
    api_path = '/service/local/artifact/maven/redirect'
    query = "?r=#{nexus['repository']}&g=#{nexus['group_id']}&a=#{nexus['artifact_id']}&v=#{nexus['version']}"
    "#{nexus['url']}#{api_path}#{query}"
  end
end
