describe "Votes Service", () ->

  service = null
  mockHttpBackend = null

  beforeEach () ->
    module "meducationFrontEnd"
    inject (votesService, _$httpBackend_) ->
      service = votesService
      mockHttpBackend = _$httpBackend_

  it "Should be instantiated", () ->
    expect(service).not.toBeNull()

  it "should POST with the correct URI for up-voting", ->
    mockHttpBackend.expectPOST("/votes",
      encodeURI "vote[item_id]=123&vote[item_type]=MediaFile&liked=1")
        .respond 200

    service.post { id: 123, type: "MediaFile", liked: true }

    mockHttpBackend.flush()

  it "should POST with the correct URI for down-voting", ->
    mockHttpBackend.expectPOST("/votes",
      encodeURI "vote[item_id]=456&vote[item_type]=MediaFile&liked=0")
        .respond 200

    service.post { id: 456, type: "MediaFile", liked: false }

    mockHttpBackend.flush()
