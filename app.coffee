redis = require 'redis'
static = require 'node-static'

watch_client = redis.createClient()

watch_client.psubscribe 'johnny:*'

#---------------
WebSocketServer = require('websocket').server
file = new(static.Server) './public'

server = require('http').createServer (request, response) ->
  request.addListener 'end', ->
    file.serve(request, response);

server.listen 8080

wsServer = new WebSocketServer {
  httpServer: server
  autoAcceptConnections: false
}

originIsAllowed = (origin) ->
  true # TODO: fixme

wsServer.on 'request', (request) ->
  if !originIsAllowed(request.origin)
    request.reject();
    console.log new Date() + ' Connection from origin ' + request.origin + ' rejected.'
  else
    connection = request.accept 'johnny-protocol', request.origin
    watch_client.on "pmessage", (pattern, channel, message) ->
      connection.sendUTF "#{message}"
