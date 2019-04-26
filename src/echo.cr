require "router"

module Echo
  VERSION = "0.1.0"

  class WebServer
    include Router

    def draw_routes
      get "/" do |context, params|
        headers = context.request.headers
        context.response.print headers.fetch("X-Forwarded-For", headers.fetch("X-Real-IP", "unknown"))
        context
      end

      post "/" do |context, params|
        context.response.print context.request.body.not_nil!.gets_to_end
        context
      end
    end

    def run
      server = HTTP::Server.new(route_handler)
      port = 10000
      server.bind_tcp port
      puts "Listen on http://127.0.0.1:#{port}"
      server.listen
    end
  end
end

web_server = Echo::WebServer.new
web_server.draw_routes
web_server.run
