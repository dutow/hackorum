#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../config/environment"
require_relative "../lib/dev/email_simulator"

offset_seconds = ENV.fetch("SENT_OFFSET_SECONDS", "5").to_i
existing_alias_prob = ENV.fetch("EXISTING_ALIAS_PROB", "0.9").to_f
existing_topic_prob = ENV.fetch("EXISTING_TOPIC_PROB", "0.9").to_f

simulator = Dev::EmailSimulator.new(
  existing_alias_prob: existing_alias_prob,
  existing_topic_prob: existing_topic_prob
)

sent_at = Time.current - offset_seconds
msg = simulator.generate_mail(sent_at: sent_at)
simulator.ingest!(msg)

puts "Injected simulated email at #{sent_at} with subject: #{msg.subject}"
