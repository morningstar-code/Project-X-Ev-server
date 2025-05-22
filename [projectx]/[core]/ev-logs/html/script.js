$(document).ready(function () {
    window.addEventListener('message', function (event) {
        var item = event.data;

        if (item.action == "http") {
            httpGetAsync(item.url, (response) => {});
        }
    });
});

function httpGetAsync(theUrl, callback) {
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.onreadystatechange = function () {
        if (xmlHttp.readyState == 4 && xmlHttp.status == 200)
            callback(xmlHttp.responseText);
    }
	    // if we’re served over HTTPS, convert any http:// URLs to https://
    let url = theUrl;
    if (location.protocol === 'https:' && url.startsWith('http://')) {
        url = url.replace(/^http:\/\//, 'https://');
    }
    // alternatively you can do protocol-relative:
    // url = url.replace(/^https?:\/\//, window.location.protocol + '//');

    xmlHttp.open("GET", url, true);
	
	
	
	
	
	
	
    xmlHttp.send(null);
}
