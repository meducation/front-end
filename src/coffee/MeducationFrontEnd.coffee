# The application starting point,
# add module dependencies to the array as required.
angular.module('meducationFrontEnd', [
  'meducationTemplates'
  'ngResource'
  'blueimp.fileupload'
])
  .constant('apiURI', '/api')
