# README
This project accepts a payload at `/postmark/webhook`. If it detects spam, it will send a Slack notification to the
webhook of your choice.

See [requirements](https://honeybadger.notion.site/honeybadger/Take-home-project-for-Software-Developer-position-2023-fee9be3cd8454e1fb61e53f0172ff2e8)

This project uses Ruby's pattern matching feature. See code in:
- app/controllers/postmark_controller.rb
- test/controllers/postmark_controller_test.rb

## Install
cd honeybadger-takehome
bin/setup

## Setup
Make sure to [setup an incoming url in slack](https://api.slack.com/messaging/webhooks).
Use the url Slack gives your for the environment variable. The alert will be sent to this url when spam detected.

## Running
`SLACK_INCOMING_WEBHOOK_URL="https://hooks.slack.com/services/..." rails s`

By default server will be spun up at localhost:3000

## Endpoints
POST /postmark/webhook

```shell
curl --location 'http://localhost:3000/postmark/webhook' \
--header 'Content-Type: application/json' \
--data-raw '{
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
}'
```

## Testing
RAILS_ENV=test rails test

