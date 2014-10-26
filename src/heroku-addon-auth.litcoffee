# Heroku Addon-Provider Authentication
Middleware for [restify](https://github.com/mcavage/node-restify) to check authentication as per the Heroku Addon specs: basic authentication with username and password stored in `addon-manifest.json`

## Motivation

> All calls should be protected by HTTP basic auth with the add-on id and password specified in your add-on manifest.
– [Heroku Add-on Provider API](https://devcenter.heroku.com/articles/add-on-provider-api)

## Usage

### Install with npm
```bash
$ npm install --save heroku-addon-auth
```

### Use with restify

```javascript
options = {
  log : console
};

restify = require('restify');
server = restify.createServer(options);
server.use(restify.authorizationParser());
server.use(require('heroku-addon-auth')(options));
```

Note that the **Authorization Parser** needs to be installed **before** `heroku-addon-auth`.


### Compatibility with Express and Connect
restify uses the same Middleware function pattern as Expresss/Connect:

>```coffee-script
function middleware(req,res,next)`
```

 which should make it very easily portable to Express and similar servers.

One `restify`-specific requirement is that the _Authorization Parser_ must be used before calling this module.


# Implementation
### Using addon-manifest.json

`addon-manifest` is located in the root directory of the main module.


## Initializing the module

    module.exports = (options)->
      {log,manifest}=options

#### log
`log` is supposed to be a `bunyan` instance or any other log that can print hashes.

      log ?= console

#### manifest
Specify a custom manifest; defaults to the  `addon-manifest.json` from the packages main module.

      if not manifest
        path = require 'path'
        manifestName = path.dirname(require.main.filename) +
          path.sep + 'addon-manifest.json'
        log.info {filename:manifestName}, "Loading manifest file"
        manifest = require manifestName
        log.info {filename:manifestName,mainfest:manifest}, "Loading manifest file successful."

      restify = require 'restify'

## Authenticating

      return (req,res,next)->
        reqLog = req.log ? log
        if not req.authorization
          path = require 'path'
          errorMessage =
            "Authorization middleware must be use()d before
            #{path.basename(module.filename,'.litcoffee')},
            e.g. server.use(restify.authorizationParser())."
          reqLog.error errorMessage
          return next new restify.errors.InternalError errorMessage

        auth = req.authorization?.basic

        if not auth or
        auth.username != manifest.id or
        auth.password != manifest.api.password
          reqLog.error {auth:auth, manifest:{id:manifest.id,apiPassword:manifest.api.password}}, "Authentication failed"
          return next new restify.errors.UnauthorizedError

        return next()
