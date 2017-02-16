
var current_tool = 0;
var drawing = false;

function pressed( x, y ) {
    drawing = true;
}

function released( x, y ) {
    drawing = false;
}

function moved( x, y ) {
    if ( drawing ) {
        //
        // add points to line
        //
    }
}
