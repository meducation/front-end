express = require 'express'
path = require 'path'
http = require 'http'
votes = require './routes/votes'
app = express()

app.set 'port', process.env.PORT || 3000
# Log requests to the console
app.use express.logger 'dev'
# Allow the app to read JSON from the body in POSTs and PUTs
app.use express.bodyParser()
# OS-agnostic way of going up two directories
# to be able to access the lib and vendor folders
app.use express.static path.join __dirname, '..', '..'

# Set view engine to ejs but allow HTML files to be rendered as is.
app.set 'views', path.join(__dirname, 'views')
app.engine 'html', require('ejs').renderFile

app.get '/', (request, response) ->
  response.sendfile path.join 'src', 'app', 'index.html'

app.get '/votes', votes.getVote
app.post '/votes', votes.postVote
app.put '/votes/:id', votes.putVote
app.delete '/votes/:id', votes.deleteVote

http.createServer(app).listen app.get('port'), () ->
  console.log 'Server listening on port: ' + app.get 'port'