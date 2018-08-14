# mangacore-wallet-client

[![NPM Package](https://img.shields.io/npm/v/mangacore-wallet-client.svg?style=flat-square)](https://www.npmjs.org/package/mangacore-wallet-client)
[![Build Status](https://img.shields.io/travis/bitpay/mangacore-wallet-client.svg?branch=master&style=flat-square)](https://travis-ci.org/bitpay/mangacore-wallet-client) 
[![Coverage Status](https://coveralls.io/repos/bitpay/mangacore-wallet-client/badge.svg)](https://coveralls.io/r/bitpay/mangacore-wallet-client)

The *official* client library for [mangacore-wallet-service] (https://github.com/bitpay/mangacore-wallet-service). 

## Description

This package communicates with BWS [Mangacore wallet service](https://github.com/bitpay/mangacore-wallet-service) using the REST API. All REST endpoints are wrapped as simple async methods. All relevant responses from BWS are checked independently by the peers, thus the importance of using this library when talking to a third party BWS instance.

See [Mangacore-wallet] (https://github.com/bitpay/mangacore-wallet) for a simple CLI wallet implementation that relays on BWS and uses mangacore-wallet-client.

## Get Started

You can start using mangacore-wallet-client in any of these two ways:

* via [Bower](http://bower.io/): by running `bower install mangacore-wallet-client` from your console
* or via [NPM](https://www.npmjs.com/package/mangacore-wallet-client): by running `npm install mangacore-wallet-client` from your console.

## Example

Start your own local [Mangacore wallet service](https://github.com/bitpay/mangacore-wallet-service) instance. In this example we assume you have `mangacore-wallet-service` running on your `localhost:3232`.

Then create two files `irene.js` and `tomas.js` with the content below:

**irene.js**

``` javascript
var Client = require('mangacore-wallet-client');


var fs = require('fs');
var BWS_INSTANCE_URL = 'https://bws.bitpay.com/bws/api'

var client = new Client({
  baseUrl: BWS_INSTANCE_URL,
  verbose: false,
});

client.createWallet("My Wallet", "Irene", 2, 2, {network: 'testnet'}, function(err, secret) {
  if (err) {
    console.log('error: ',err); 
    return
  };
  // Handle err
  console.log('Wallet Created. Share this secret with your copayers: ' + secret);
  fs.writeFileSync('irene.dat', client.export());
});
```

**tomas.js**

``` javascript

var Client = require('mangacore-wallet-client');


var fs = require('fs');
var BWS_INSTANCE_URL = 'https://bws.bitpay.com/bws/api'

var secret = process.argv[2];
if (!secret) {
  console.log('./tomas.js <Secret>')

  process.exit(0);
}

var client = new Client({
  baseUrl: BWS_INSTANCE_URL,
  verbose: false,
});

client.joinWallet(secret, "Tomas", {}, function(err, wallet) {
  if (err) {
    console.log('error: ', err);
    return
  };

  console.log('Joined ' + wallet.name + '!');
  fs.writeFileSync('tomas.dat', client.export());


  client.openWallet(function(err, ret) {
    if (err) {
      console.log('error: ', err);
      return
    };
    console.log('\n\n** Wallet Info', ret); //TODO

    console.log('\n\nCreating first address:', ret); //TODO
    if (ret.wallet.status == 'complete') {
      client.createAddress({}, function(err,addr){
        if (err) {
          console.log('error: ', err);
          return;
        };

        console.log('\nReturn:', addr)
      });
    }
  });
});
```

Install `mangacore-wallet-client` before start:

```
npm i mangacore-wallet-client
```

Create a new wallet with the first script:

```
$ node irene.js
info Generating new keys 
 Wallet Created. Share this secret with your copayers: JbTDjtUkvWS4c3mgAtJf4zKyRGzdQzZacfx2S7gRqPLcbeAWaSDEnazFJF6mKbzBvY1ZRwZCbvT
```

Join to this wallet with generated secret:

```
$ node tomas.js JbTDjtUkvWS4c3mgAtJf4zKyRGzdQzZacfx2S7gRqPLcbeAWaSDEnazFJF6mKbzBvY1ZRwZCbvT
Joined My Wallet!

Wallet Info: [...]

Creating first address:

Return: [...]

```

Note that the scripts created two files named `irene.dat` and `tomas.dat`. With these files you can get status, generate addresses, create proposals, sign transactions, etc.


