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
    let(:app) { "jeff" }

    context "with a setting for the given remote" do
      let(:settings) { { pipeline:, remote => { app: } } }
      it { should == app }
    end

    context "with a setting for a different remote" do
      let(:settings) { { pipeline:, other_remote => { app: } } }
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
end

