express = require 'express'
path = require 'path'
http = require 'http'
votes = require './routes/votes'
syllabusItems = require './routes/syllabus_items'
app = express()

app.set 'port', process.env.PORT || 5000
# Log requests to the console
app.use express.logger 'dev'
# Allow the app to read JSON from the body in POSTs and PUTs
app.use express.bodyParser()
# Create paths that mimic the Rails asset pipeline in the form:
# Pipeline location -> static location
app.use '/src', express.static path.join __dirname, '..', '..', 'src'
app.use '/lib', express.static path.join __dirname, '..', '..', 'lib'
app.use '/assets', express.static path.join __dirname, '..', '..', 'lib',
  'assets', 'templates'

# Set view engine to ejs but allow HTML files to be rendered as is.
app.set 'views', path.join(__dirname, 'views')
app.engine 'html', require('ejs').renderFile

app.get '/', (request, response) ->
  response.sendfile path.join 'src', 'app', 'index.html'

# Example pages hosting individual UI components.
app.get "/votes", votes.getVote
app.get "/syllabus_items", syllabusItems.getSyllabusItems

# API calls returning stubbed responses.
uriPrefix = '/api'
app.post "#{uriPrefix}/votes", votes.postVote
app.put "#{uriPrefix}votes/:id", votes.putVote
app.delete "#{uriPrefix}/votes/:id", votes.deleteVote

app.get "#{uriPrefix}/syllabus_items", syllabusItems.query

http.createServer(app).listen app.get('port'), () ->
  console.log 'Server listening on port: ' + app.get 'port'