Gem::Specification.new do |s|
  s.name    = 'clieop'

  # Do not set version and date yourself, this will be done automatically
  # by the gem release script.
  s.version = "0.2.0"
  s.date    = "2010-12-09"

  s.summary     = "A pure Ruby implementation to write CLIEOP files"
  s.description = "This library is a pure Ruby, MIT licensed implementation of the CLIEOP03 transaction format. CLIEOP03 can be used to communicate direct debt transactions with your (Dutch) bank."

  s.authors  = ['Willem van Bergen', 'Leon Berenschot']
  s.email    = ['willem@vanbergen.org', 'LeipeLeon@gmail.com']
  s.homepage = 'http://github.com/wvanbergen/clieop/wikis'

  s.add_development_dependency('rake')
  s.add_development_dependency('rspec', '~> 2.2')
  s.add_development_dependency('ZenTest', '~> 4.4')
  
  # Do not set files and test_files yourself, this will be done automatically
  # by the gem release script.
  s.files      = %w(.gitignore .rspec Gemfile Gemfile.lock MIT-LICENSE README.rdoc Rakefile autotest/discover.rb clieop.gemspec doc/clieop03.pdf init.rb lib/clieop.rb lib/clieop/batch.rb lib/clieop/file.rb lib/clieop/record.rb spec/clieop/batch_spec.rb spec/clieop/file_spec.rb spec/clieop/record_spec.rb spec/clieop_spec.rb spec/spec_helper.rb tasks/github-gem.rake)
  s.test_files = %w(spec/clieop/batch_spec.rb spec/clieop/file_spec.rb spec/clieop/record_spec.rb spec/clieop_spec.rb)
end
