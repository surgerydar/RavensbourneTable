//var WebSocket = require('ws');
//
// TODO: move sketch session storage to db
//
function SketchSessions() {
    this.sketches = [];
}
/*
SketchSessions.prototype.processMessage = function( wss, ws, message ) {
    try {
        var command = JSON.parse( message );
        if ( command && this[ command.command ] ) {
            console.log( 'processing command : ' + command.command );
            this[ command.command ]( wss, ws, command );
        } else {
            console.log( 'SketchSessions.processMessage : unable to process message ' + message  );
        }
    } catch( err ) {
        console.log( 'SketchSessions.processMessage : ' + err + ' : unable to process message ' + message  );
    }
}
*/
SketchSessions.prototype.connect = function( wsr ) {
    for ( var key in this ) {
        if ( key !== 'connect' ) {
            console.log( 'SketchSessions connecting : ' + key );
            wsr.json( key, this[ key ] );
        }
    }
}

SketchSessions.prototype.log = function( wss, ws, command ) {
    console.log( 'SketchSessions.log : ' + command.message );
}

SketchSessions.prototype.join = function( wss, ws, command ) {
    console.log( 'SketchSessions.join : sketchid:' + command.sketchid + ' userid:' + command.userid );
    this.relay(wss, ws, command);
    //
    // add user
    //
    this.addUser( command.sketchid, command.userid );
    //
    // return lock and user lists
    //
    var sketch = this.getSketch( command.sketchid );
    command.locks = sketch.locks;
    command.users = sketch.users;
    ws.send(JSON.stringify(command));
}

SketchSessions.prototype.leave = function( wss, ws, command ) {
    console.log( 'SketchSessions.leave : sketchid:' + command.sketchid + ' userid:' + command.userid );
    this.relay(wss, ws, command);
    this.releaseUserLocks( wss, ws, command.sketchid, command.userid );
    this.removeUser( command.sketchid, command.userid );
}

SketchSessions.prototype.additem = function( wss, ws, command ) {
    console.log( 'SketchSessions.add : sketchid:' + command.sketchid + ' userid:' + command.userid + ' itemid:' + command.itemid );
    this.relay(wss, ws, command);
}

SketchSessions.prototype.deleteitem = function( wss, ws, command ) {
    console.log( 'SketchSessions.delete : sketchid:' + command.sketchid + ' userid:' + command.userid + ' itemid:' + command.itemid );
    this.relay(wss, ws, command);
}

SketchSessions.prototype.updateitem = function( wss, ws, command ) {
    console.log( 'SketchSessions.updateitem : sketchid:' + command.sketchid + ' userid:' + command.userid + ' itemid:' + command.itemid );
    this.relay(wss, ws, command);
}


SketchSessions.prototype.lock = function( wss, ws, command ) {
    console.log( 'SketchSessions.lock : sketchid:' + command.sketchid + ' userid:' + command.userid + ' itemid:' + command.itemid );
    this.relay(wss, ws, command);
    this.addLock( command.sketchid, command.userid, command.itemid );
}

SketchSessions.prototype.unlock = function( wss, ws, command ) {
    console.log( 'SketchSessions.unlock : sketchid:' + command.sketchid + ' userid:' + command.userid + ' itemid:' + command.itemid );
    this.relay(wss, ws, command);
    this.releaseLock( command.sketchid, command.userid, command.itemid );
}

SketchSessions.prototype.addline = function( wss, ws, command ) {
    console.log( 'SketchSessions.addline : sketchid:' + command.sketchid + ' userid:' + command.userid + ' lineid:' + command.lineid );
    this.relay(wss, ws, command);
}

SketchSessions.prototype.deleteline = function( wss, ws, command ) {
    console.log( 'SketchSessions.deleteline : sketchid:' + command.sketchid + ' userid:' + command.userid + ' lineid:' + command.lineid );
    this.relay(wss, ws, command);
}

SketchSessions.prototype.updateline = function( wss, ws, command ) {
    console.log( 'SketchSessions.updateline : sketchid:' + command.sketchid + ' userid:' + command.userid + ' lineid:' + command.lineid );
    this.relay(wss, ws, command);
}

SketchSessions.prototype.userlist = function( wss, ws, command ) {
    console.log( 'SketchSessions.userlist : sketchid:' + command.sketchid );
    var sketch = this.getSketch( command.sketchid );
    if ( sketch ) {
        command.users = sketch.users;
        ws.send(JSON.stringify(command));
    }
}

SketchSessions.prototype.relay = function( wss, ws, command ) {
    //
    // relay to all other sockets
    //
    var message = JSON.stringify( command );
    console.log('SketchSessions.relay:' + command.command);
    wss.clients.forEach(function(client) {
        console.log( 'client.readyState=' + client.readyState );
        if (client !== ws && client.readyState === WebSocket.OPEN) {
          client.send(message);
        }
    });
}

SketchSessions.prototype.getSketch = function( sketchid ) {
    var count = this.sketches.length;
    for ( var i = 0; i < count; i++ ) {
        if ( this.sketches[i].id === sketchid ) {
            return this.sketches[i];
        }
    }
    var sketch = { 
        id: sketchid,
        locks: [],
        users: []
    };
    this.sketches.push(sketch);
    return sketch;
}

SketchSessions.prototype.addUser = function( sketchid, userid ) {
    //
    //
    //
    var sketch = this.getSketch( sketchid );
    if ( sketch.users.indexOf(userid) === -1 ) {
        sketch.users.push(userid);
    }
}
SketchSessions.prototype.removeUser = function( sketchid, userid ) {
    //
    //
    //
    var sketch = this.getSketch( sketchid );
    var i = sketch.users.indexOf(userid);
    if ( i !== -1 ) {
        sketch.users.splice(i,1);
    }
}

SketchSessions.prototype.addLock = function( sketchid, userid, itemid ) {
    //
    //
    //
    var sketch = this.getSketch( sketchid );
    sketch.locks.push({userid: userid, itemid: itemid});
}

SketchSessions.prototype.releaseLock = function( sketchid, userid, itemid ) {
    //
    //
    //
    var sketch = this.getSketch( sketchid );
    var count = sketch.locks.length;
    for ( var i = 0; i < count; i++ ) {
        if ( sketch.locks[ i ].userid === userid && sketch.locks[ i ].itemid === itemid ) {
            sketch.locks.splice( i, 1 );
            return;
        }
    }
}

SketchSessions.prototype.releaseUserLocks = function( wss, ws, sketchid, userid ) {
    console.log( 'SketchSessions.releaseUserLocks : sketchid:' + sketchid + ' userid:' + userid );
    //
    // 
    //
    var command = {
        command : 'unlock',
        sketchid : sketchid,
        userid : userid
    };
    var sketch = this.getSketch( sketchid );
    var count = sketch.locks.length;
    for ( var i = 0; i < count; ) {
        if ( sketch.locks[ i ].userid === userid ) {
            command.itemid = sketch.locks[ i ].itemid;
            this.relay( wss, ws, command );
            sketch.locks.splice( i, 1 );
            count--;
        } else {
            i++;
        }
    }
}

module.exports = new SketchSessions();

