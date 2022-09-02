# frozen_string_literal: true

# $LOAD_PATH << File.expand_path(__dir__, "..", "lib")

require "bundler/setup"
require "stairstep"

Dir[Pathname.new(__dir__).join("support", "**", "*.rb")].each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = %i[should expect]
  end
end

