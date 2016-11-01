require 'test_helper'
require 'channel'

class SlackChannelTest < ActionController::TestCase
  #Just to verify that Rake can pick up the test
  test 'the truth' do
    assert true
  end

  test "Must provide a name and id for a Slack_Channel" do
    assert_raises ArgumentError do
      Slack_Channel.new nil, nil
    end
    assert_raises ArgumentError do
      Slack_Channel.new "", ""
    end
    assert_raises ArgumentError do
      Slack_Channel.new "", "12345"
    end
    assert_raises ArgumentError do
      Slack_Channel.new "slack-channel-name", ""
    end
    assert_raises ArgumentError do
      Slack_Channel.new nil, "12345"
    end
    assert_raises ArgumentError do
      Slack_Channel.new "slack-channel-name", nil
    end
  end

  test "Name Attribute is set correctly" do
    test_me = Slack_Channel.new "myname", "myid"
    assert test_me.name == "myname"
  end

  test "ID Attribute is set correctly" do
    test_me = Slack_Channel.new "myname", "myid"
    assert test_me.id == "myid"
  end

end
