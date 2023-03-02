require "test_helper"

class PostmarkControllerTest < ActionDispatch::IntegrationTest
  SPAM_PAYLOAD = {
    "RecordType": "Bounce",
    "Type": "SpamNotification",
    "TypeCode": 512,
    "Name": "Spam notification",
    "Tag": "",
    "MessageStream": "outbound",
    "Description": "The message was delivered, but was either blocked by the user, or classified as spam, bulk mail, or had rejected content.",
    "Email": "zaphod@example.com",
    "From": "notifications@honeybadger.io",
    "BouncedAt": "2023-02-27T21:41:30Z"
  }

  BOUNCE_PAYLOAD = {
    "RecordType": "Bounce",
    "MessageStream": "outbound",
    "Type": "HardBounce",
    "TypeCode": 1,
    "Name": "Hard bounce",
    "Tag": "Test",
    "Description": "The server was unable to deliver your message (ex: unknown user, mailbox not found).",
    "Email": "arthur@example.com",
    "From": "notifications@honeybadger.io",
    "BouncedAt": "2019-11-05T16:33:54.9070259Z"
  }

  test "should detext spam" do
    post postmark_webhook_url, params: SPAM_PAYLOAD
    assert_response :success
    assert_equal "spam", JSON.parse(@response.body)["result"]
  end

  test "should detext not spam" do
    post postmark_webhook_url, params: BOUNCE_PAYLOAD
    assert_response :success
    assert_equal "ok", JSON.parse(@response.body)["result"]
  end

  test "should handle unknown format" do
    post postmark_webhook_url, params: {}
    assert_response :success
    assert_equal "ok", JSON.parse(@response.body)["result"]
  end
end
