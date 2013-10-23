# The application starting point,
# add module dependencies to the array as required.
angular.module('meducationFrontEnd', ['meducationTemplates'])
  .constant('apiScheme', 'http')
  .constant('apiHostname', 'localhost')
  .constant('apiPort', 8000)

