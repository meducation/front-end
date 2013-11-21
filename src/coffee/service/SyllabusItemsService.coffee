mainModule = angular.module 'meducationFrontEnd'

syllabusItemsServiceFunction = ($resource, apiURI) ->
  $resource "#{apiURI}/syllabus_items/:itemId"

syllabusItemsServiceFunction.$inject = ['$resource', 'apiURI']
mainModule.factory 'syllabusItemsService', syllabusItemsServiceFunction