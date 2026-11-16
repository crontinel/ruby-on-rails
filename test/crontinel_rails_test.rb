# frozen_string_literal: true

require "test_helper"

class FakeClient
  attr_reader :calls

  def initialize(fail_with: nil)
    @calls = []
    @fail_with = fail_with
  end

  def task_finished(**args)
    record(:finished, args)
  end

  def task_failed(**args)
    record(:failed, args)
  end

  private

  def record(kind, args)
    raise @fail_with if @fail_with

    @calls << [kind, args[:name]]
  end
end

describe Crontinel::Rails do
  after do
    Crontinel::Rails.settings = {}
    Crontinel::Rails.reset_client!
  end

  def with_client(client)
    Crontinel::Rails.instance_variable_set(:@client, client)
  end

  it "reports a finished run named by the job class and returns the job's value" do
    fake = FakeClient.new
    with_client(fake)
    assert_equal 42, Crontinel::Rails.track("InvoiceJob") { 42 }
    assert_equal [[:finished, "InvoiceJob"]], fake.calls
  end

  it "reports a failed run and re-raises the job's error" do
    fake = FakeClient.new
    with_client(fake)
    assert_raises(ArgumentError) { Crontinel::Rails.track("InvoiceJob") { raise ArgumentError, "boom" } }
    assert_equal [[:failed, "InvoiceJob"]], fake.calls
  end

  it "never fails the job when Crontinel is unreachable" do
    with_client(FakeClient.new(fail_with: Crontinel::NetworkError.new("down")))
    _out, err = capture_io { assert_equal :ok, Crontinel::Rails.track("InvoiceJob") { :ok } }
    assert_match "could not report run", err
  end

  it "has no client without an API key, so jobs run untouched" do
    Crontinel.config.api_key = nil
    Crontinel::Rails.reset_client!
    assert_nil Crontinel::Rails.client
    assert_equal :ok, Crontinel::Rails.track("InvoiceJob") { :ok }
  end

  it "accepts the old /api/v1 endpoint and the default host" do
    Crontinel::Rails.settings = { api_key: "k", endpoint: "https://app.crontinel.com/api/v1" }
    Crontinel::Rails.reset_client!
    assert_equal "https://app.crontinel.com", Crontinel::Rails.client.instance_variable_get(:@config).endpoint
  end
end

describe Crontinel::Rails::Sidekiq::ServerMiddleware do
  after { Crontinel::Rails.reset_client! }

  it "reports plain Sidekiq jobs and skips Active Job wrappers" do
    fake = FakeClient.new
    Crontinel::Rails.instance_variable_set(:@client, fake)
    mw = Crontinel::Rails::Sidekiq::ServerMiddleware.new
    worker = Class.new do
      def self.name
        "ReportWorker"
      end
    end.new
    mw.call(worker, {}, "default") { :done }
    mw.call(worker, { "wrapped" => "SomeJob" }, "default") { :done }
    assert_equal [[:finished, "ReportWorker"]], fake.calls
  end
end
