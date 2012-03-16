
require 'rest-core'

AsynchronousClient = RestCore::Builder.client do
  s = self.class # this is only for ruby 1.8!
  use s::DefaultSite , 'https://api.github.com/users/'
  use s::JsonDecode  , true
  use s::CommonLogger, method(:puts)
  use s::Cache       , nil, 3600
  run s::EmHttpRequest
end

client = AsynchronousClient.new(:cache => {})
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