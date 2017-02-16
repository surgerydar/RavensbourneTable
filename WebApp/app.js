var env = process.env;
//
//
//
var express = require('express');
var bodyParser = require('body-parser');
var jsonParser = bodyParser.json();
//
//
//		
var app = express();
var io = null;
//
// start app
//
var server = app.listen(env.NODE_PORT || 3000, env.NODE_IP || 'localhost', function () {
  console.log('Application worker ' + process.pid + ' started...');
});
/*
//
// start socket io
//
try {
    io = require('socket.io').listen(server);
    console.log( 'SocketIO started')
    io.sockets.on('connection', function (socket) {
        console.log('client connected!');
        //
        // relay messages to all clients
        //
        socket.on('message', function (message) {
            socket.broadcast.emit('message',message)
        });
    });
} catch( err ) {
    console.log( 'Unable to start SocketIO : ' + err );
}
*/
//
// start ws
//
var sketchsession = require('./sketchsession.js');
var WebSocket = require('ws');
var wss = new WebSocket.Server({ server });
wss.on('connection', function(ws) {
    ws.on('message', function(message) {
        sketchsession.processMessage(wss,ws,message);
    });
    ws.send(JSON.stringify({command:'welcome'}));
});
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
	app.set('view engine', 'pug');
	app.use(express.static(__dirname+'/static'));
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
            //
            //
            //
            res.json( {status: 'OK'} );
        } ).catch( function( error ) {
            res.json( {status: 'ERROR', message: JSON.stringify( error ) } );
        });
    });
    app.put('/user/:id', jsonParser, function (req, res) {
        // create new user
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
}).catch( function( err ) {
	console.log( 'unable to connect to database : ' + err );
});

