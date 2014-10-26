
assert=require 'assert'
restify = require 'restify'

randomstring = ()->
  crypto = require 'crypto'
  crypto.randomBytes(64).toString('hex')

describe 'heroku-addon-auth',->
  describe 'setup',->
    auth = require '../'

    it 'will fail in testing when trying to load root addon-manifest.json',->
      assert.throws ()->
        auth()
      , Error

    it 'will use a custom manifest',->
      auth
        manifest:
          id: 'test-' + randomstring()
          api:
            password: randomstring()

  describe 'authentication',->
    manifest =
      id: randomstring()
      api:
        password: randomstring()

    auth = (require '../')
      manifest:manifest

    it 'will fail when started without Authorization Parser being installed',(done)->
      auth {},{},(args)->
        assert args instanceof restify.errors.HttpError
        done()

    it 'will fail with invalid credentials',(done)->
      auth
        authorization:
          basic:
            username: manifest.id + randomstring()
            password: manifest.api.password + randomstring()
      , {}, (err)->
        assert err instanceof restify.errors.HttpError
        done()

    it 'will pass with valid credentials',(done)->
      auth
        authorization:
          basic:
            username: manifest.id
            password: manifest.api.password
      , {}, (err)->
        assert not err
        done()
