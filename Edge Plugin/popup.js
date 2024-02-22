const sendMessageId = document.getElementById("btn_domain");
if (sendMessageId) {
  sendMessageId.onclick = function(e) {

    chrome.tabs.query({active: true, lastFocusedWindow: true}, function(tabs) 
    {
            var tab = tabs[0];

            var a = document.createElement('a');
            a.href = tab.url;
            alert(a.hostname);
            
    });
  };
}