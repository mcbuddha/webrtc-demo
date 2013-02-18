[API, _, IO] =
  [exports._app = {},
  (require 'lodash'),
  (require 'socket.io')]
___ = (x)->console.log x

API.SIO = (parseInt process.argv[2]) or 4567
IO = IO.listen API.SIO, 'log level': 1
IO.sockets.on 'connection', (s) ->
  ___ "connected #{s.id}"
  s.on 'message', (d) -> ___ "got #{d}"

___ "socket.io listening on #{API.SIO}"