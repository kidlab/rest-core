
require 'rest-core'
require 'eventmachine'
require 'cool.io'

YourClient = RestCore::Builder.client do
  s = RestCore
  use s::DefaultSite , 'https://api.github.com/users/'
  use s::JsonDecode  , true
  use s::CommonLogger, method(:puts)
  use s::Cache       , nil, 3600
  run s::Auto
end

client = YourClient.new(:cache => {})
p client.get('cardinalblue') # cache miss
puts
p client.get('cardinalblue') # cache hit

puts

client = YourClient.new(:cache => {})
EM.run{
  client.get('cardinalblue'){ |response|
    p response
    EM.stop
  }
}

puts

EM.run{
  Fiber.new{
    p client.get('cardinalblue')
    EM.stop
  }.resume
}
