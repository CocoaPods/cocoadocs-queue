Bundler.require(*[:default, :web, ENV['RACK_ENV'].to_sym].compact)

require 'json'
require 'sinatra/base'

require_relative '../../database/db'
require_relative '../../database/domain'

class QueueApp < Sinatra::Base
  #
  get "/api/v1/pods/:name/enqueue" do
    
  end
end
