const sendMessageId = document.getElementById("btn_domain");
if (sendMessageId) {
  sendMessageId.onclick = function(e) {

    chrome.tabs.query({active: true, lastFocusedWindow: true}, function(tabs) 
    {
            var tab = tabs[0];
            alert(tab.url);
            //alert("copy domain substring from address url '" + tab.url + "'!");
            
    });
    //var url = window.location;
    //alert("copy domain substring from address url '" + url + "'!");
  };
}