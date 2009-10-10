Gem::Specification.new do |s|
  s.name    = 'clieop'

  # Do not set version and date yourself, this will be done automatically
  # by the gem release script.
  s.version = "0.1.1"
  s.date    = "2009-10-10"

  s.summary     = "A pure Ruby implementation to write CLIEOP files"
  s.description = "This library is a pure Ruby, MIT licensed implementation of the CLIEOP03 transaction format. CLIEOP03 can be used to communicate direct debt transactions with your (Dutch) bank."

  s.authors  = ['Willem van Bergen']
  s.email    = ['willem@vanbergen.org']
  s.homepage = 'http://github.com/wvanbergen/clieop/wikis'

  # Do not set files and test_files yourself, this will be done automatically
  # by the gem release script.
  s.files      = %w(.gitignore lib/clieop/record.rb lib/clieop/file.rb lib/clieop/batch.rb lib/clieop.rb Rakefile MIT-LICENSE test/clieop_writer_test.rb tasks/github-gem.rake clieop.gemspec README.rdoc)
  s.test_files = %w(test/clieop_writer_test.rb)
end
