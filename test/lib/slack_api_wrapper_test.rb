require 'test_helper'
require 'slack_api_wrapper'
require 'channel'

class SlackApiTest < ActionController::TestCase
  test "the truth" do
    assert true
  end

  test "can retrieve an array of slack channels" do
    VCR.use_cassette("channels") do
      channels = SlackApiWrapper.listchannels

      assert channels.is_a? Array
      assert channels.length > 0  ## Or assert not empty

      channels.each do |ch|
        assert ch.is_a? Slack_Channel
      end
    end
  end

  test "retrieves nil when the token is broken" do
    VCR.use_cassette("bad-token") do
      channels = SlackApiWrapper.listchannels 'bad-token'
      assert channels == nil
    end
  end

  test "Can send a properly formatted message" do
    VCR.use_cassette("send-msg") do
      response = SlackApiWrapper.sendmsg('test-api-parens', "I hope this works")
      assert response["ok"] == true
      assert response["message"]["type"] == "message"
      assert response["message"]["subtype"] == "bot_message"
    end
  end

  test "Response fails when channel doesn't exist" do
    VCR.use_cassette("not-a-channel") do
      response = SlackApiWrapper.sendmsg('not-a-channel', "I hope this works")
      assert response["ok"] == false
      assert response["error"] == "channel_not_found"
    end
  end

  test "Response fails when message is nil" do
    VCR.use_cassette("bad-msg") do
      response = SlackApiWrapper.sendmsg('test-api-parens', nil)
      assert_not response["ok"]
      assert response["error"] == "no_text"

      response = SlackApiWrapper.sendmsg('test-api-parens', "")
      assert_not response["ok"]
      assert response["error"] == "no_text"
    end
  end

  test "Response fails when the token is broken" do
    VCR.use_cassette("bad-msg-token") do
      response = SlackApiWrapper.sendmsg('test-api-parens', "I hope this works", 'bad-msg-token')
      assert_not response["ok"]
      assert response["error"] == "invalid_auth"

      response = SlackApiWrapper.sendmsg('test-api-parens', "I hope this works", '')
      assert_not response["ok"]
      assert response["error"] == "not_authed"
    end
  end

end
