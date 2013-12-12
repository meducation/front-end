express = require 'express'
path = require 'path'
http = require 'http'
votes = require './routes/votes'
syllabusItems = require './routes/syllabus_items'
uploadForm = require './routes/upload_form'
contentWidgets = require './routes/content_widgets'
server = express()

server.set 'port', process.env.PORT || 5000
# Log requests to the console
server.use express.logger 'dev'
# Allow the app to read JSON from the body in POSTs and PUTs
server.use express.bodyParser()
# Create paths that mimic the Rails asset pipeline in the form:
# Pipeline location -> static location
server.use '/src', express.static path.join __dirname, '..', '..', 'src'
server.use '/lib', express.static path.join __dirname, '..', '..', 'lib'
server.use '/assets', express.static path.join __dirname, '..', '..', 'lib',
  'assets', 'templates'

server.use '/vendor', express.static path.join __dirname, '..', '..', 'vendor'

# Set view engine to ejs but allow HTML files to be rendered as is.
server.set 'views', path.join(__dirname, 'views')
server.engine 'html', require('ejs').renderFile

server.get '/', (request, response) ->
  response.sendfile path.join 'src', 'server', 'index.html'

# Example pages hosting individual UI components.
server.get "/votes", votes.getVote
server.get "/syllabus_items", syllabusItems.getSyllabusItems
server.get "/upload_form", uploadForm.getUploadForm
server.get "/content_widgets", contentWidgets.getContentWidgets

# API calls returning stubbed responses.
uriPrefix = '/api'
server.post "#{uriPrefix}/votes", votes.postVote
server.put "#{uriPrefix}votes/:id", votes.putVote
server.delete "#{uriPrefix}/votes/:id", votes.deleteVote

server.get "#{uriPrefix}/syllabus_items", syllabusItems.query

server.post '/media_files', uploadForm.postForm
server.post '/s3_upload', uploadForm.uploadToS3

http.createServer(server).listen server.get('port'), () ->
  console.log 'Server listening on port: ' + server.get 'port'