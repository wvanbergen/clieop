require 'rubygems'
require 'spec/autorun'
require 'clieop'

Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f }

Spec::Runner.configure do |config|
  
end

