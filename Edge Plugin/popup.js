const svrNameButton = document.getElementById("btn_servername");
const domainButton = document.getElementById("btn_domain");

if (domainButton) {
    domainButton.onclick = function(e) {
        chrome.tabs.query({active: true, lastFocusedWindow: true}, function(tabs) {
            var tab = tabs[0];
            var a = document.createElement('a');
            a.href = tab.url;
            if(a.hostname.indexOf('.') > 0){
                var frags = a.hostname.split('.').reverse();
                var hostnameFrags = [];
                for(var i = 0; i < 2; i++){
                    hostnameFrags.unshift(frags[i]);
                }
                var hostname = hostnameFrags.join('.');
                var blob = new Blob([hostname], {type: 'text/plain'});
                var item = new ClipboardItem({'text/plain': blob});
                
                navigator.clipboard.write([item]).then(function() {
                    console.log("Copied to clipboard successfully!");
                }, function(error) {
                    console.error("unable to write to clipboard. Error:");
                    console.log(error);
                });
            }
        });
        window.close();
    };
}

if (svrNameButton) {
    svrNameButton.onclick = function(e) {
        chrome.tabs.query({active: true, lastFocusedWindow: true}, function(tabs) {
            var tab = tabs[0];
            var a = document.createElement('a');
            a.href = tab.url;
            var hostname = a.hostname;
            var blob = new Blob([hostname], {type: 'text/plain'});
            var item = new ClipboardItem({'text/plain': blob});

            navigator.clipboard.write([item]).then(function() {
                console.log("Copied to clipboard successfully!");
            }, function(error) {
                console.error("unable to write to clipboard. Error:");
                console.log(error);
            });
        });
        window.close();
    };
}