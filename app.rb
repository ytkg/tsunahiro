# frozen_string_literal: true

require 'twitter'
require 'dotenv/load'

def client
  @client ||= Twitter::REST::Client.new do |config|
    config.consumer_key = ENV['TWITTER_API_CONSUMER_KEY']
    config.consumer_secret = ENV['TWITTER_API_CONSUMER_SECRET']
    config.access_token = ENV['TWITTER_API_ACCESS_TOKEN']
    config.access_token_secret = ENV['TWITTER_API_ACCESS_TOKEN_SECRET']
  end
end

def write_json(filename, object)
  File.write("data/#{filename}", JSON.pretty_generate(object))
end

def load_json(filename)
  JSON.parse(File.read("data/#{filename}"))
end

follower_ids = client.follower_ids.to_a
write_json('follower_ids.json', follower_ids)

friend_ids = client.friend_ids.to_a
write_json('friend_ids.json', friend_ids)

already_followed_ids = load_json('followed_ids.json')
followed_ids = already_followed_ids | friend_ids
write_json('followed_ids.json', followed_ids)
