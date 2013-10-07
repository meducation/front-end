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

    service.post { item_id: 123, item_type: "MediaFile", liked: true }

    mockHttpBackend.flush()

  it "should POST with the correct URI for down-voting", ->
    mockHttpBackend.expectPOST("/votes",
      encodeURI "vote[item_id]=456&vote[item_type]=MediaFile&liked=0")
        .respond 200

    service.post { item_id: 456, item_type: "MediaFile", liked: false }

    mockHttpBackend.flush()

  it "should PUT with the correct URI when changing to an up vote", ->
    mockHttpBackend.expectPUT("/votes/789",
      encodeURI "vote[liked]=1").respond 200

    service.put { vote_id: 789, liked: true }

    mockHttpBackend.flush()

  it "should PUT with the correct URI when changing to a down vote", ->
    mockHttpBackend.expectPUT("/votes/101",
      encodeURI "vote[liked]=0").respond 200

    service.put { vote_id: 101, liked: false }

    mockHttpBackend.flush()

  it "should DELETE with the correct URI when removing a vote", ->
    mockHttpBackend.expectDELETE("/votes/112").respond 200

    service.delete { vote_id: 112 }

    mockHttpBackend.flush()