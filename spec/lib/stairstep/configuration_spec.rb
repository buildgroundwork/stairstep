# frozen_string_literal: true

require "active_support/core_ext/hash/keys"
require_relative "../../../lib/stairstep/configuration"

RSpec.describe Configuration do
  let(:configuration) { described_class.new(git:, settings: settings.deep_stringify_keys) }
  let(:git) { double(:git, project_name: "a-project") }
  let(:pipeline) { "wibble" }
  let(:remote) { "staging" }

  describe "#pipeline" do
    subject { configuration.pipeline }

    context "with a pipeline setting" do
      let(:settings) { { pipeline: } }
      it { should == pipeline }
    end

    context "without a pipeline setting" do
      let(:settings) { {} }
      it { should == git.project_name }
    end
  end

  describe "#app_name" do
    subject { configuration.app_name(remote:) }
    let(:app_name) { "jeff" }

    context "with a setting for the given remote" do
      let(:settings) { { pipeline:, app: { remote => app_name } } }
      it { should == app_name }
    end

    context "with a setting for a different remote" do
      let(:settings) { { pipeline:, app: { other_remote => app_name } } }
      let(:other_remote) { "different" }
      it { should == "#{pipeline}-#{remote}" }
    end
  end

  describe "#callbacks" do
    subject { configuration.callbacks(phase:) }
    let(:phase) { :before_deploy }

    context "with callbacks for the given phase" do
      let(:settings) { { phase => command_settings } }
      let(:command_settings) { { "run" => %w[this that], "just_do" => %w[it] } }
      it { should == [%w[run this], %w[run that], %w[just_do it]] }

      context "with a command with no param" do
        let(:command_settings) { { "run" => [nil] } }
        it { should == [["run", ""]] }
      end
    end

    context "with no callbacks for the given phase" do
      let(:settings) { { different_phase: command_settings } }
      let(:command_settings) { { "do" => %w[something_else] } }
      it { should be_empty }
    end
  end

  describe "#fixed_options" do
    subject { configuration.fixed_options }

    context "with a boolean true option" do
      let(:settings) { { command_line: ["downtime"] } }
      it { should == { "downtime" => true } }
    end

    context "with a boolean false option" do
      let(:settings) { { command_line: ["no-downtime"] } }
      it { should == { "downtime" => false } }
    end

    context "with an option that includes the initial dashes" do
      let(:settings) { { command_line: ["--no-downtime"] } }
      it { should == { "downtime" => false } }
    end

    context "with multiple options" do
      let(:settings) { { command_line: %w[--no-downtime tag] } }
      it { should == { "downtime" => false, "tag" => true } }
    end

    context "with no command line options" do
      let(:settings) { {} }
      it { should == {} }
    end
  end
end

