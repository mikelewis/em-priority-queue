$:.unshift File.dirname(__FILE__) + '/../lib'
require 'em-priority-queue'
require 'delorean'

RSpec.configure do |config|
  config.include Delorean
  config.after(:each) { back_to_the_present }

end
