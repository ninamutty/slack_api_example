require 'httparty'

class Slack_Api_Wrapper
  TOKEN = ENV["SlACK_TOKEN"]
  BASE_URL = "https://slack.com/api/"

  def self.list_channels
    url = BASE_URL + "channels.list?token=#{TOKEN}"

    response = HTTParty.get(url)
    ap response

    my_channels = []
    response["channels"].each do |channel|
      id = channel["id"]
      name = channel["name"]
      my_channels << Slack_Channel.new(name, id)

    end

    return my_channels
  end

  def self.send_message(channel, msg)
    url = BASE_URL + "chat.postMessage?token=#{TOKEN}"

    # response = HTTParty.get(url)
    data = HTTParty.post(url,
      body:  {
        "text" => "#{msg}",
        "channel" => "#{channel}",
        "username" => "Charles in Charge",
        "icon_emoji" => ":charles:",
        "as_user" => "false"
      },
      :headers => { 'Content-Type' => 'application/x-www-form-urlencoded' })
  end

end
