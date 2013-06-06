require 'fluent/plugin'
require 'fluent/config'
require 'fluent/input'
require 'databasedotcom'

module Fluent


class TermtterInput < Input
  Plugin.register_input('chatter-api', self)

  def start
    # Not yet implemented
  end
end


end
