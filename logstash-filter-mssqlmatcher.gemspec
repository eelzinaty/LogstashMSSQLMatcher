Gem::Specification.new do |s|
  s.name = 'logstash-filter-mssqlmatcher'
  s.version         = '2.0.1'
  s.licenses = ['Apache License (2.0)']
  s.summary = "This filter add new field from sql server to the output by matching input field from sql data."
  s.description     = "This gem is a Logstash plugin required to be installed on top of the Logstash core pipeline using $LS_HOME/bin/logstash-plugin install gemname. This gem is not a stand-alone program"
  s.authors = ["eelzinaty"]
  s.email = 'engessam1985@gmail.com'
  s.homepage = "https://github.com/eelzinaty"
  s.require_paths = ["lib"]

  # Files
  s.files = Dir['lib/**/*','spec/**/*','vendor/**/*','*.gemspec','*.md','CONTRIBUTORS','Gemfile','LICENSE','NOTICE.TXT']
   # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "filter" }

  # Gem dependencies
  #s.add_runtime_dependency "logstash-core-plugin-api", ">= 1.60", "<= 2.99"
  s.add_runtime_dependency "logstash-core", ">= 2.0.0", "< 3.0.0"
  s.add_runtime_dependency 'logstash-codec-plain'
  s.add_runtime_dependency 'sequel'
  
  s.add_development_dependency 'logstash-devutils', '~> 0'
end
