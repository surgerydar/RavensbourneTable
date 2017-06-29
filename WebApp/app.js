var env = process.env;
var config = require('./config');
var fs = require('fs');
//var config = { ssl: { key: fs.readFileSync('./ssl/server.key'), cert: fs.readFileSync('./ssl/server.crt')}};

//
// connect to database
//
var db = require('./ravensbourne.db.js');
db.connect(
	env.MONGODB_DB_HOST,
	env.MONGODB_DB_PORT,
	env.APP_NAME,
    env.MONGODB_DB_USERNAME,
	env.MONGODB_DB_PASSWORD
).then( function( db_connection ) {
    //
    // configure express
    //
    console.log('initialising express');
    var express = require('express');
    var bodyParser = require('body-parser');
    var jsonParser = bodyParser.json();
    var mailer = require('./mailer.js');
    //
    //
    //		
    var app = express();
    //
    //
    //
    bodyParser.json( {limit:'5mb'} );
	//
	// configure express
	//
	app.set('view engine', 'pug');
    app.use(express.static(__dirname+'/static',{dotfiles:'allow'}));
    //
    // express routes
    //
	app.get('/', function (req, res) {
        res.json({ status: 'ok' });
	});
    //
    // user
    //
    app.post('/user', jsonParser, function (req, res) {
        // create new user
        console.log( 'user : ' + JSON.stringify(req.body) );
        db.putUser( req.body ).then( function( response ) {
            /*
            //
            // email confirmation
            //
            var message = 'Hi ' + req.body.username + ', welcome to collaborative sketch at Ravensbourne<br/>';
            message += 'You can access your sketches using the mobile app available at:<br/>';
            message += 'Android: http://ravensbournetable.co.uk/android/<br/>';
            message += 'iOS: http://store<br/>';
            message += 'enter the following code when you first launch the app:<br/>'
            message += req.body.id;
            mailer.send( req.body.email, 'Welcome to collaborative sketch at Ravensbourne', message ).then( function( response ) {
                res.json( {status: 'OK'} );
            }).catch( function( error ) {
                res.json( {status: 'ERROR', message: JSON.stringify( error ) } );
            });
            */
            res.json( {status: 'OK'} );
        } ).catch( function( error ) {
            res.json( {status: 'ERROR', message: JSON.stringify( error ) } );
        });
    });
    app.put('/user/:id', jsonParser, function (req, res) {
        // update user
        db.updateUser( req.params.id, req.body ).then( function( response ) {
            //
            //
            //
            res.json( {status: 'OK'} );
        } ).catch( function( error ) {
            res.json( {status: 'ERROR', message: JSON.stringify( error ) } );
        });
    });
    app.get('/user/byid/:id', function(req, res) {
        // get single user
        db.getUser(req.params.id).then( function( response ) {
            console.log( '/user/byid/' + req.params.id + ' : ' + JSON.stringify(response) );
            res.json( formatResponse( response, 'OK' ) );
        }).catch( function( error ) {
            res.json( formatResponse( null, 'ERROR', JSON.stringify( error ) ) );
        });
    });
    app.get('/user/byemail/:email', function(req, res) {
        // get single user
        db.getUserByEmail(req.params.email).then( function( response ) {
            console.log( '/user/byemail/' + req.params.email + ' : ' + JSON.stringify(response) );
            if ( response ) {
                res.json( formatResponse( response, 'OK' ) );
            } else {
                res.json( formatResponse( null, 'ERROR', "Unknown user" ) );
            }
        }).catch( function( error ) {
            res.json( formatResponse( null, 'ERROR', JSON.stringify( error ) ) );
        });
    });
    app.get('/user/byname/:name', function(req, res) {
        // get single user
        db.getUserByName(req.params.name).then( function( response ) {
            console.log( '/user/byname/' + req.params.name + ' : ' + JSON.stringify(response) );
            if ( response ) {
                res.json( formatResponse( response, 'OK' ) );
            } else {
                res.json( formatResponse( null, 'ERROR', "Unknown user" ) );
            }
        }).catch( function( error ) {
            res.json( formatResponse( null, 'ERROR', JSON.stringify( error ) ) );
        });
    });
    app.delete('/user/:id', function(req, res) {
        // get single route
        db.deleteUser(req.params.id).then( function( response ) {
            res.json( formatResponse( response, 'OK' ) );
        }).catch( function( error ) {
            res.json( formatResponse( null, 'ERROR', JSON.stringify( error ) ) );
        });
    });
    //
    // sketch
    //
    app.post('/sketch', jsonParser, function (req, res) {
        // create new user
        db.putSketch( req.body ).then( function( response ) {
            res.json( {status: 'OK'} );
        } ).catch( function( error ) {
            res.json( {status: 'ERROR', message: JSON.stringify( error ) } );
        });
    });
    app.put('/sketch/:id', jsonParser, function (req, res) {
        // create new user
        db.updateSketch( req.params.id, req.body ).then( function( response ) {
            res.json( {status: 'OK'} );
        } ).catch( function( error ) {
            res.json( {status: 'ERROR', message: JSON.stringify( error ) } );
        });
    });
    app.get('/sketch/:id', function(req, res) {
        // get single route
        db.getSketch(req.params.id).then( function( response ) {
            res.json( formatResponse( response, 'OK' ) );
        }).catch( function( error ) {
            res.json( formatResponse( null, 'ERROR', JSON.stringify( error ) ) );
        });
    });
    app.get('/usersketches/:user_id', function(req, res) {
        // get single route
        db.getUserSketches(req.params.user_id).then( function( response ) {
            res.json( formatResponse( response, 'OK' ) );
        }).catch( function( error ) {
            res.json( formatResponse( null, 'ERROR', JSON.stringify( error ) ) );
        });
    });
    app.delete('/sketch/:id', function(req, res) {
        // get single route
        db.deleteSketch(req.params.id).then( function( response ) {
            res.json( formatResponse( response, 'OK' ) );
        }).catch( function( error ) {
            res.json( formatResponse( null, 'ERROR', JSON.stringify( error ) ) );
        });
    });
    //
    //
    //
    function formatResponse( data, status, message ) {
        var response = {};
        if ( message ) response[ 'message' ] = message;
        if ( status ) response[ 'status' ] = status;
        if ( data ) response[ 'data' ] = data;
        return response;
    }
    //
    // remove these in production
    //
    app.get('/drop/:collection', function(req, res) {
        // get single route
        db.drop(req.params.collection).then( function( response ) {
            res.json( {status: 'OK', data: response} );
        }).catch( function( error ) {
            res.json( {status: 'ERROR', message: JSON.stringify( error ) } );
        });
    });
    app.get('/defaults', function(req, res) {
        // get single route
        db.setDefaults();
        res.json( {status: 'OK'} );
    });
    app.get('/testemail/:message', function(req,res) {
        mailer.send( 'jons@soda.co.uk', 'Testing collaborative sketch at Ravensbourne', req.params.message ).then( function( response ) {
            res.json( {status: 'OK'} );
        }).catch( function( error ) {
            res.json( {status: 'ERROR', message: JSON.stringify( error ) } );
        });
    });
    //
    // configure websockes
    //
    var wsr = require('./websocketrouter');
    //
    // connect sketch session
    //
    var sketchsession = require('./sketchsession.js');
    sketchsession.connect(wsr);
    //
    // create server
    //
    var httpx = require('./httpx');
    var server = httpx.createServer(config.ssl, { http:app, ws:wsr });
    //
    // start listening
    //
    try {
        server.listen(env.NODE_PORT || 3000, env.NODE_IP || 'localhost', () => console.log('Server started'));
    } catch( error ) {
        console.log( 'unable to start server : ' + error );
    }
}).catch( function( err ) {
	console.log( 'unable to connect to database : ' + err );
});
/*
'use strict';
//
//
//
let env = process.env;
let fs = require('fs');
//
//
//
let httpx = require('./httpx');
let fileupload = require('./fileuploader')
//
// ssl options
//
//let config = require('./config');
let config = { ssl: { key: fs.readFileSync('./ssl/server.key'), cert: fs.readFileSync('./ssl/server.crt')}};
//
// configure express
//
let express = require('express');
let app = express();
app.set('view engine', 'pug');
app.use(express.static(__dirname+'/public',{dotfiles:'allow'}));
//
// websocket routing
//
let wsr = require('./websocketrouter');
wsr.json('hello', (wss,ws,command) => {
    try {
        ws.send(command.greeting);
    } catch( error ) {
        console.log( 'unable to send : type : ' + typeof ws + ' : error : ' + error );
    }
});
wsr.json('log', (wss,ws,command) => {
    console.log( 'app log : ' + command.message );
});
wsr.json('login', (wss,ws,command) => {
    try {
        var response = {command: command.command, guid: command.guid};
        if ( command.username === 'jons101' && command.password === 'password' ) {
            response.staus = true;
            response.token = '2edafasfdqwedwasd2qwefwef'
            ws.send(JSON.stringify(response));
        } else {
            response.staus = true;
            response.message = 'invalid username or password';
            ws.send(JSON.stringify(response));
        }
    } catch( error ) {
        console.log( 'unable to process command : ' + JSON.stringify(command) + ' : error : ' + error );
    }
});

wsr.binary('upld', fileupload );
//
// create server(s)
//
let server = httpx.createServer(config.ssl, { http:app, ws:wsr });
//
// start listening
//
try {
    server.listen(env.NODE_PORT || 3000, env.NODE_IP || 'localhost', () => console.log('Server started'));
} catch( error ) {
    console.log( 'unable to start server : ' + error );
}
*/
