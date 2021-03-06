# heroku-addon-auth [![NPM version](https://badge.fury.io/js/heroku-addon-auth.svg)](http://badge.fury.io/js/heroku-addon-auth)
  [![Build Status](https://travis-ci.org/AndreasPizsa/heroku-addon-auth.svg)](https://travis-ci.org/AndreasPizsa/heroku-addon-auth) 


> Middleware for [restify](https://github.com/mcavage/node-restify) to check authentication as per the Heroku Addon specs: basic authentication with username and password stored in `addon-manifest.json`

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


### Compatibility with Express
restify uses the same Middleware function pattern as expresss, `function middleware(req,res,next)`, which should make it very easily portable to Express and similar servers.

One `restify`-specific requirement is that the _Authorization Parser_ must be used before calling this module.


## Contributing
Find a bug? Have a feature request? Please [create an Issue](https://github.com/AndreasPizsa/heroku-addon-auth/issues).

In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality,
and run `docs` in the command line to build the docs with [Verb](https://github.com/assemble/verb).

Pull requests are also encouraged, and if you find this project useful please consider "starring" it to show your support! Thanks!

## Author
**Andreas Pizsa**
+ [github/AndreasPizsa](https://github.com/AndreasPizsa)
+ [twitter/AndreasPizsa](http://twitter.com/AndreasPizsa)

## License
Copyright (c) 2014 Andreas Pizsa, contributors.  
MIT License.

***

_This file was generated by [verb-cli](https://github.com/assemble/verb-cli) on September 02, 2014._
