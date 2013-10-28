# Module dependencies.
express = require 'express'
http = require 'http'
path = require 'path'
io = require 'socket.io'
routes = require './../routes'
user = require './../routes/user'
path = require 'path'
app = express()

# all environments
app.set 'port', process.env.PORT || 3000
app.set 'views', __dirname + '/../views'
app.set 'view engine', 'jade'
app.use express.favicon()
app.use express.logger('dev')
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.cookieParser('your secret here')
app.use express.session()
app.use app.router
app.use require('stylus').middleware(__dirname + '/../public')
app.use express.static(path.join(__dirname, '/../public'))

# development only
if 'development' == app.get('env') 
  app.use express.errorHandler()

app.get '/', (req, res) ->
	res.render 'index'

server = http.createServer(app)

io = io.listen(server);

users = {}

# If the client just connected
io.sockets.on 'connection', (socket) ->
	users[socket.id] = socket.id
	io.sockets.emit 'connected', {id : socket.id, users : users}

	socket.on 'chatMessage', (message) ->
		io.sockets.emit 'messageDisplay', {id : socket.id, message : message}
		return

	socket.on 'disconnect', () ->
		delete users[socket.id]
		io.sockets.emit 'userDisconnect', {id : socket.id, users : users}
		
		return

	return





server.listen 3000, () ->
  console.log 'Express server listening on port ' + app.get 'port' 





