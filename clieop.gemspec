Gem::Specification.new do |s|
  s.name    = 'clieop'

  # Do not set version and date yourself, this will be done automatically
  # by the gem release script.
  s.version = '0.1.0'
  s.date    = '2008-09-17'

  s.summary     = "A pure Ruby implementation to write CLIEOP files"
  s.description = "This library is a pure Ruby, MIT licensed implementation of the CLIEOP03 transaction format. CLIEOP03 can be used to communicate direct debt transactions with your (Dutch) bank."

  s.authors  = ['Willem van Bergen']
  s.email    = ['willem@vanbergen.org']
  s.homepage = 'http://github.com/wvanbergen/clieop/wikis'

  # Do not set files and test_files yourself, this will be done automatically
  # by the gem release script.
  s.files      = %w(MIT-LICENSE README.rdoc Rakefile TODO lib lib/clieop lib/clieop.rb lib/clieop/batch.rb lib/clieop/file.rb lib/clieop/record.rb test test/clieop_writer_test.rb test/tasks.rake)
  s.test_files = %w(test/clieop_writer_test.rb)
end
