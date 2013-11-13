module PuppetFixtures
  def self.fixtures_path
    "#{File.expand_path File.dirname(__FILE__)}"
  end

  def self.manifests_path
    "#{fixtures_path}/manifests"
  end

  def self.load_manifest(manifest)
    File.read("#{Paths.manifests_path}/#{manifest}")
  end
end
