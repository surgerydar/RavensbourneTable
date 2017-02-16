.pragma library

function get(uri,callback) {
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhttp.readyState === XMLHttpRequest.DONE) {
            callback(xhr.status,xhttp.responseText)
        }
    }
    xhr.open('GET', uri);
}
