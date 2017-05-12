import QtQuick 2.7

Item {
    id: container
    //
    // layout
    //
    Rectangle {
        anchors.fill: parent
        color: colourYellow
    }
    //
    // blobs
    //
    Blobs {
        id: blobs
        anchors.fill: parent
        count: 12
    }
    //
    // frame
    //
    Image {
        anchors.fill: parent
        source: "icons/rectangular-frame.svg"
        fillMode: Image.PreserveAspectFit
    }
    //
    // prompts
    //
    /*
    RotatingPrompt {
        id: info
        radius: parent.height / 2
        anchors.centerIn: parent
        prompt: "The Microsoft Manual of Style for Technical Publications does not capitalize four-letter prepositions. The Chicago Manual of Style (Chicago) and The MLA Handbook don't capitalize any prepositions--unless, for all three manuals, the word fits in category 2 or 3 above. So if you want to follow the rules of those guides, you need to recognize prepositions such as with, from, between, around, and through to know whether to capitalize them. I prefer the simplicity of my way--that is, Gregg's way. I grabbed a few books off my shelf so you can test yourself. Decide what to capitalize in these titles:made to stick: why some ideas survive and others die the story factor: inspiration, influence, and persuasion through the art of storytelling fierce conversations: achieving success at work and in life, one conversation at a time a funny thing happened on the way to the boardroom: using humor in business speaking Remember, first you can capitalize any word of four or more letters, if you follow my style. Then capitalize the first word of the title and the subtitle, and the last word of the title. Then you have to think about whether the remaining short words are conjunctions, articles, or prepositions. If they are, they are lower case. Okay, here goes: Made to Stick: Why Some Ideas Survive and Others Die (to is a short preposition; and is a conjunction) The Story Factor: Inspiration, Influence, and Persuasion Through the Art of Storytelling (Chicago would leave through lowercase as a preposition) Fierce Conversations: Achieving Success at Work and in Life, One Conversation at a Time (one is capitalized because it is an adjective) A Funny Thing Happened on the Way to the Boardroom: Using Humor in Business Speaking The most common errors I see are with short words that are not conjunctions, articles, or prepositions. Words such as one, it, its, it's, him, and own should all be capitalized no matter where they appear in a title. Well, I have done My Good Deed for today. I hope you found the review helpful. - See more at: http://www.businesswritingblog.com/business_writing/2010/02/words-to-capitalize-in-titles-and-headings.html#sthash.holvURUy.dpuf"
    }
    */
    FingerprintScannerPrompt {
        anchors.top: parent.top
        rotation: 180
        prompt: "Scan your index finger to start"
    }
    FingerprintScannerPrompt {
        anchors.bottom: parent.bottom
        prompt: "Scan your index finger to start"
    }
    //
    //
    //
    function start() {
        blobs.start();
        //info.start();
    }
    function stop() {
        blobs.stop();
        //info.stop();
    }
    //
    //
    //
    function setup( param ) {
        blobs.setup(param);
        start();
        //
        //
        //
        for ( var i = 0; i < materialScanners.length; i++ ) {
            materialScanners[ i ].barcode = "";
        }
    }
    function close() {
        stop();
    }
    MouseArea { // TODO: disable for production
        //
        //
        //
        property string userId: "{fb8592f5-7e49-49ba-b190-77e39381cfbd}"

        anchors.fill: parent
        onClicked: {
            WebDatabase.getUser(userId);
        }
    }
    //
    // fingerprint handling
    //
    function fingerPrintEnrollmentStage(device,stage) {
        if ( enrollFingerprint.visible ) enrollFingerprint.fingerPrintEnrollmentStage( device, stage );
    }
    function fingerPrintEnrolled(device,id) {
        if ( enrollFingerprint.visible ) enrollFingerprint.fingerPrintEnrolled( device, id );
    }
    function fingerPrintEnrollmentFailed(device) {
        if ( enrollFingerprint.visible ) enrollFingerprint.fingerPrintEnrollmentFailed( device );
    }
    function fingerPrintValidated(device,id) {
        console.log( 'Valid finger : ' + id );
        //
        // go to user home
        //
        if ( !enrollFingerprint.visible ) { // no enrollment in progress
            WebDatabase.getUser(id);
        }
    }
    function fingerPrintValidationFailed(device,error) {
        //
        // show enrollment dialog
        //
        console.log( 'validation failed : ' + error );
        if ( !enrollFingerprint.visible ) { // no enrollment in progress
            var param = {
                device: device
            }
            enrollFingerprint.setup(param);
            enrollFingerprint.visible = true;
        }
    }
    //
    // WebDatabase
    //
    function webDatabaseSuccess( command, result ) {
        if ( enrollFingerprint.visible ) {
            enrollFingerprint.webDatabaseSuccess( command, result );
        }
        if ( command.indexOf('/user/') === 0 ) {
            var user = {
                id: result.fingerprint,
                username: result.username,
                email: result.email
            };
            console.log( 'Validated user : ' + JSON.stringify(user) );
            var param = {
                user: user
            };
            appWindow.go("Home", param);
        }
    }
    function webDatabaseError( command, error ) {
        /*
        if ( enrollFingerprint.visible ) {
            enrollFingerprint.webDatabaseError( command, error );
        }
        */
    }
}
