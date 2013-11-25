exports.getUploadForm = (request, response) ->
  response.render 'upload_form.html'

exports.postForm = (request, response) ->
  response.send 201, 'Created'

exports.uploadToS3  = (request, response) ->
  location = "https://my-bucket.s3.amazonaws.com/uploads%2F#{request.files.file.name}"
  key = "uploads/#{request.files.file.name}"
  xml = """
    <PostResponse>
      <Location>""" + location + """</Location>
      <Bucket>my-bucket</Bucket>
      <Key>""" + key + """</Key>
      <ETag>1709b592c7e504e467a5fc2c918ed477</ETag>
    </PostResponse>
  """

  response.set 'Encoding', 'utf8'
  response.set 'Content-Type', 'text/xml'
  response.send xml