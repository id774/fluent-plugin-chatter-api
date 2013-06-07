require 'fluent/plugin'
require 'fluent/config'
require 'fluent/input'
require 'databasedotcom'

# TODO:
#   The configuration should be defined in fluent.conf


# databasedotcom.yml
#
# ---
# client_id: xxxxxxxx
# client_secret: xxxxxxxx


module Fluent


class TermtterInput < Input
  Plugin.register_input('chatter-api', self)

  def start
    client = Databasedotcom::Client.new("databasedotcom.yml")

    client.client_id
    client.client_secret
    security_token = "xxxxxxxx"

    client.authenticate :token => security_token,
      :instance_url => "http://localhost"

    # p client.list_sobjects

    my_feed_items = Databasedotcom::Chatter::UserProfileFeed.find(client)  #=> a Databasedotcom::Collection of FeedItems
    my_feed_items = Databasedotcom::Chatter::FeedItem  #=> a Databasedotcom::Collection of FeedItems

    my_feed_items.each do |feed_item|
      # feed_item.likes                   #=> a Databasedotcom::Collection of Like instances
      # feed_item.comments                #=> a Databasedotcom::Collection of Comment instances
      # feed_item.raw_hash                #=> the hash returned from the Chatter API describing this FeedItem
      # feed_item.comment("This is cool") #=> create a new comment on the FeedItem
      # feed_item.like                    #=> the authenticating user likes the FeedItem
      Engine.emit("chatter.api",
        Engine.now, {
            "likes" => feed_item.likes,
            "comments" => feed_item.comments,
        }
      )
    end
    # me = Databasedotcom::Chatter::User.find(client, "me")   #=> a User for the authenticating user
    # me.followers                                              #=> a Databasedotcom::Collection of Users
    # me.post_status("what I'm doing now")                      #=> post a new status

    # you = Databasedotcom::Chatter::User.find(client, "your-user-id")
    # me.follow(you)                                            #=> start following a user@
  end

end


end
