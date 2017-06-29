//
// database
//
var MongoClient = require('mongodb').MongoClient;
var ObjectId = require('mongodb').ObjectID;
var bcrypt = require('bcryptjs');

function Db() {
}

Db.prototype.connect = function( host, port, database, username, password ) {
	host 		= host || '127.0.0.1';
	port 		= port || '27017';
	database 	= database || 'ravensbourne';
	var authentication = username && password ? username + ':' + password + '@' : '';
	var url = host + ':' + port + '/' + database;
	console.log( 'connecting to mongodb://' + authentication + url );
	var self = this;
	return new Promise( function( resolve, reject ) {
		try {
			MongoClient.connect('mongodb://'+ authentication + url, function(err, db) {
				if ( !err ) {
					console.log("Connected to database server");
					self.db = db;
                    //
                    //
                    //
					resolve( db );
				} else {
					console.log("Unable to connect to database : " + err);
					reject( err );
				}
			});
		} catch( err ) {
			reject( err );
		}
	});
}


Db.prototype.putUser = function( data ) {
    var db = this.db;
    return new Promise( function( resolve, reject ) {
        try {
            db.collection( 'users' ).findOne({$or: [ { fingerprint:data.id }, { username:data.username }, { email:data.email } ]},function(err,user) {
                if ( user ) {
                    if ( user.id === data.id ) {
                        reject( 'a user with this fingerprint is already registered' ); // this shouldn't happen
                    } else {
                        reject( 'user already registered with this email or password' );
                    }
                } else {
                    var user = {
                        fingerprint: data.id, // id translates into fingerprint on server
                        username: data.username,
                        email: data.email
                    };
                    db.collection( 'users' ).insertOne(user,function(err,result) {
                       if ( err ) {
                           reject( err );
                       } else {
                           resolve( 'signed up' );
                       }
                    });
                }
            });
        } catch( err ) {
            console.log( err );
            reject( err );
        }
    });

}

Db.prototype.updateUser = function( id, user ) {
    var db = this.db;
    return new Promise( function( resolve, reject ) {
         try {
             db.collection('users').findOneAndUpdate( { fingerprint: id }, user, function( err, result ) {
                if ( err ) {
                    console.log( err );
                    reject( err );
                } else {
                    resolve( result );
                }
             });
        } catch( err ) {
            console.log( err );
            reject( err );
        }
    });
}

Db.prototype.deleteUser = function( id ) {
    var db = this.db;
    return new Promise( function( resolve, reject ) {
         try {
             db.collection('users').deleteOne( { fingerprint: id }, function( err, result ) {
                if ( err ) {
                    console.log( err );
                    reject( err );
                } else {
                    resolve( result );
                }
             });
        } catch( err ) {
            console.log( err );
            reject( err );
        }
    });
}

Db.prototype.getUser = function( id ) {
    var db = this.db;
    return new Promise( function( resolve, reject ) {
         try {
             db.collection('users').findOne( { fingerprint: id }, function( err, result ) {
                if ( err ) {
                    console.log( err );
                    reject( err );
                } else if( result ) {
                    resolve( result );
                } else {
                    reject( 'unable to find user : ' + id );
                }
             });
        } catch( err ) {
            console.log( err );
            reject( err );
        }
    });
}

Db.prototype.getUserByEmail = function( email ) {
    var db = this.db;
    return new Promise( function( resolve, reject ) {
         try {
             db.collection('users').findOne( { email: email }, function( err, result ) {
                if ( err ) {
                    console.log( err );
                    reject( err );
                } else {
                    resolve( result );
                }
             });
        } catch( err ) {
            console.log( err );
            reject( err );
        }
    });
}

Db.prototype.getUserByName = function( username ) {
    var db = this.db;
    return new Promise( function( resolve, reject ) {
         try {
             db.collection('users').findOne( { username: username }, function( err, result ) {
                if ( err ) {
                    console.log( err );
                    reject( err );
                } else {
                    resolve( result );
                }
             });
        } catch( err ) {
            console.log( err );
            reject( err );
        }
    });
}
//
//
//
Db.prototype.putSketch = function( sketch ) {
    var db = this.db;
    return new Promise( function( resolve, reject ) {
        try {
            db.collection( 'sketches' ).insertOne(sketch,function(err,result) {
               if ( err ) {
                   reject( err );
               } else {
                   resolve( 'saved' );
               }
            });
        } catch( err ) {
            console.log( err );
            reject( err );
        }
    });
}

Db.prototype.deleteSketch = function( id ) {
    var db = this.db;
    return new Promise( function( resolve, reject ) {
        try {
            db.collection( 'sketches' ).deleteOne({id:id},function(err,result) {
               if ( err ) {
                   reject( err );
               } else {
                   resolve( 'saved' );
               }
            });
        } catch( err ) {
            console.log( err );
            reject( err );
        }
    });
}

Db.prototype.updateSketch = function( id, sketch ) {
    var db = this.db;
    return new Promise( function( resolve, reject ) {
         try {
             db.collection('sketches').findOneAndUpdate( { id: id }, sketch, function( err, result ) {
                if ( err ) {
                    console.log( err );
                    reject( err );
                } else {
                    resolve( result );
                }
             });
        } catch( err ) {
            console.log( err );
            reject( err );
        }
    });
}

Db.prototype.getSketch = function( id ) {
    var db = this.db;
    return new Promise( function( resolve, reject ) {
         try {
             db.collection('sketches').findOne( { id: id }, function( err, result ) {
                if ( err ) {
                    console.log( err );
                    reject( err );
                } else {
                    resolve( result );
                }
             });
        } catch( err ) {
            console.log( err );
            reject( err );
        }
    });
}

Db.prototype.getUserSketches = function( user_id ) {
    var db = this.db;
    return new Promise( function( resolve, reject ) {
        try {
            var query = {$or:[{user_id:user_id},{'group.id':user_id}]};
            db.collection('sketches').find(query).toArray( function( err, result ) {
                if ( err ) {
                    console.log( err );
                    reject( err );
                } else {
                     resolve( result );
                }
            });  
        } catch( err ) {
            console.log( err );
            reject( err );
        }
    });
}
//
//
//
Db.prototype.drop = function( collection ) {
	var db = this.db;
	return new Promise( function( resolve, reject ) {
		try {
			db.collection( collection ).drop(function(err,result) {
				if ( err ) {
					reject( err );
				} else {
					resolve( result );
				}
			});
		} catch( err ) {
			reject( err );
		}
	});
}


module.exports = new Db();

