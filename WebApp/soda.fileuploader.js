var net = require('net');
var fs = require('fs');
var buffer = require('buffer');

var server = net.createServer(function(conn) {
    console.log('server connected');

});

var HOST = '127.0.0.1';
var PORT = '9001'
var FILEPATH = '/home/steve/Downloads/';

server.listen(PORT, HOST, function() {
    //listening
    console.log('server bound to ' + PORT + '\n');

    server.on('connection', function(conn) {
        console.log('connection made...\n')
        conn.on('data', function(data) {
            console.log('data received');
            console.log('data is: \n' + data);
        });
    })
});
function Upload( server, connection ) {
    var self = this;
    this.server = server;
    this.connection = connection;
    this.prefix = 0;
    this.filenameLength = -1;
    this.filename = '';
    this.fileSize = 0
    this.bytesWritten = 0;
    this.file = null;
    this.data = null;
    this.connection.on('data', function( data ) {
        if ( this.file ) {
            this.file
        }
        //
        // store data
        //
        if ( this.data === null ) {
            this.data = data;
        } else {
            this.data = Buffer.concat( [this.data,data],this.data.length + data.length);
        }
        //
        // parse header
        //
        try {
            this.prefix = this.data.readUInt16BE(0);
            this.filenameLength = this.data.readUInt32(2);
            this.filename = this.data.toString('utf16', 6, 6 + this.filenameLength - 1);
            this.fileSize = this.data.readUInt32(6 + this.filenameLength);
            
        } catch( error ) {
            
        }
    }).on('close' function() {
        //
        // remove me from server list
        //
    }).on('error', function() {
    });
}

function FileUploader() {
    this.server = net.createServer(function(connection) {
        console.log('soda.fileuploader : server connected'); 
    });
}

FileUploader.prototype.setup = function( host, port, directory ) {
    var self = this;
    this.directory = directory;
    self.server.listen( port, host function() {
        console.log( 'soda.fileuploader : server bound to port ' + port );
        this.connections = [];
        self.server.on('connection' function(connection) {
            console.log( 'soda.fileuploader : connection from ' + connection.address() );
            //
            // store connection
            //
            self.connections.push( new Upload(self,connection) );
        }).on( 'error' function(error) {
        });
    });
}