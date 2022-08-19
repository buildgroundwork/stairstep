# frozen_string_literal: true

require_relative "../../stairstep"

module Stairstep::Common
  class Yarn
    def initialize(executor, logger)
      @executor = executor
      @logger = logger
    end

    def install_local_modules
      File.open("log/yarn-install.log", "w+") do |file|
        executor.execute("yarn", "install", "--check-files", message: "Checking local JS packages", output: file)
      end
    end

    private

    attr_reader :executor, :logger
  end
end

