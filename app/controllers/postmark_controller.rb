require 'uri'
require 'net/http'

class PostmarkController < ApplicationController
  SLACK_INCOMING_WEBHOOK_URL = ENV["SLACK_INCOMING_WEBHOOK_URL"]
  # POST /postmark/webhook
  def webhook
    render json: {result: process_webhook}, status: :ok
  end

  private

  def process_webhook
    # add any pattern matching logic here
    # do different things based on the type of webhook
    case params.to_unsafe_h.symbolize_keys
    in {Type: "SpamNotification"}
      send_slack_notification
      :spam
    else
      :ok
    end
  rescue NoMatchingPatternError
    # do nothing, we don't care about this webhook
    :ok
  end

  # Sending a slack notification is dependent on the incoming webhook integration
  # https://api.slack.com/messaging/webhooks
  def send_slack_notification
    # don't send a notification if the webhook url is not configured
    return unless SLACK_INCOMING_WEBHOOK_URL.present?

    uri = URI.parse(SLACK_INCOMING_WEBHOOK_URL)
    data = { text: "Spam detected: #{params[:Email]}"}
    puts "Sending slack notification: #{data}"
    response = Net::HTTP.post(uri, data.to_json, {"Content-Type" => "application/json", "Accept" => "application/json"})
    puts "Slack response: #{response}"
  rescue => e
    puts "Error sending slack notification: #{e}"
  end
end
