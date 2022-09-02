# frozen_string_literal: true

require "json"
require "yaml"

class Configuration
  def initialize(git: , settings: nil)
    @git = git
    @settings = settings || load_from_file
  end

  def pipeline
    settings["pipeline"] || git.project_name
  end

  def app_name(remote: )
    settings[remote.to_s]&.fetch("app", nil) || default_app_name(remote)
  end

  def callbacks(phase: )
    phase_settings = settings.fetch(phase.to_s, [])
    phase_settings.inject([]) do |commands, (command, params)|
      params.each { |param| commands.push([command, param || ""]) }
      commands
    end
  end

  private

  attr_reader :git, :settings

  def load_from_file
    if File.exist?(".stairstep.json")
      JSON.parse(File.open(".stairstep.yml", "r"))
    elsif File.exist?("config/stairstep.yml")
      YAML.safe_load(File.open("config/stairstep.yml", "r"))
    else
      {}
    end
  end

  def default_app_name(remote)
    "#{pipeline}-#{remote}"
  end
end

