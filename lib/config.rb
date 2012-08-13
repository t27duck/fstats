module Fstats
  @config = {}

  def self.config
    @config
  end

  def self.load_config(path="./config/config.yml")
    @config = YAML.load(File.read(path))["config"]
  end
end
