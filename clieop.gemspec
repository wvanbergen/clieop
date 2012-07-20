Gem::Specification.new do |s|
  s.name    = 'clieop'

  # Do not set version and date yourself, this will be done automatically
  # by the gem release script.
  s.version = "1.0.0"
  s.date    = "2012-07-20"

  s.summary     = "A pure Ruby implementation to write CLIEOP files"
  s.description = "This library is a pure Ruby, MIT licensed implementation of the CLIEOP03 transaction format. CLIEOP03 can be used to communicate direct debt transactions with your (Dutch) bank."

  s.authors  = ['Willem van Bergen', 'Leon Berenschot', 'Reinier de Lange']
  s.email    = ['willem@vanbergen.org', 'LeipeLeon@gmail.com', 'r.j.delange@nedforce.nl']
  s.homepage = 'http://github.com/wvanbergen/clieop/wiki'

  s.add_development_dependency('rake')
  s.add_development_dependency('rspec', '~> 2.2')
  s.add_development_dependency('ZenTest', '~> 4.4')
  
  # Do not set files and test_files yourself, this will be done automatically
  # by the gem release script.
  s.files      = %w(.gitignore .infinity_test .rspec Gemfile MIT-LICENSE README.rdoc Rakefile autotest/discover.rb clieop.gemspec doc/VERWINFO_NL_4.1_11-2009.pdf doc/clieop03.pdf lib/clieop.rb lib/clieop/payment/batch.rb lib/clieop/payment/file.rb lib/clieop/payment/record.rb lib/clieop/process_info/batch.rb lib/clieop/process_info/file.rb lib/clieop/process_info/record.rb lib/clieop/process_info/transaction.rb lib/core_ext/hash.rb lib/core_ext/string.rb spec/clieop/payment/batch_spec.rb spec/clieop/payment/file_spec.rb spec/clieop/payment/record_spec.rb spec/clieop/process_info/batch_spec.rb spec/clieop/process_info/file_spec.rb spec/clieop/process_info/record_spec.rb spec/clieop/process_info/transaction_spec.rb spec/clieop_spec.rb spec/files/VERWINFO.txt spec/spec_helper.rb tasks/github-gem.rake)
  s.test_files = %w(spec/clieop/payment/batch_spec.rb spec/clieop/payment/file_spec.rb spec/clieop/payment/record_spec.rb spec/clieop/process_info/batch_spec.rb spec/clieop/process_info/file_spec.rb spec/clieop/process_info/record_spec.rb spec/clieop/process_info/transaction_spec.rb spec/clieop_spec.rb)
end
