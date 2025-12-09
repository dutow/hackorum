#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../config/environment"
require_relative "../lib/dev/email_simulator"

min_interval = ENV.fetch("MIN_INTERVAL_SECONDS", "30").to_i
max_interval = ENV.fetch("MAX_INTERVAL_SECONDS", "90").to_i
existing_alias_prob = ENV.fetch("EXISTING_ALIAS_PROB", "0.9").to_f
existing_topic_prob = ENV.fetch("EXISTING_TOPIC_PROB", "0.9").to_f

raise ArgumentError, "MIN_INTERVAL_SECONDS must be > 0" if min_interval <= 0
raise ArgumentError, "MAX_INTERVAL_SECONDS must be >= MIN_INTERVAL_SECONDS" if max_interval < min_interval

simulator = Dev::EmailSimulator.new(
  existing_alias_prob: existing_alias_prob,
  existing_topic_prob: existing_topic_prob
)

puts "Starting email stream simulator (interval #{min_interval}-#{max_interval}s, existing alias prob #{existing_alias_prob}, existing topic prob #{existing_topic_prob})"

loop do
  sent_at = Time.current - rand(1..10)
  mail = simulator.generate_mail(sent_at: sent_at)
  simulator.ingest!(mail)
  puts "[#{Time.current}] Injected simulated email with subject: #{mail.subject}"

  sleep rand(min_interval..max_interval)
end
