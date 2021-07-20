
function log(message) {
	window.webkit.messageHandlers.log.postMessage("[Javascript Context] " + message);
}

// global socket object
var socket;

function createSocket(url,parameters) {
	log("Creating socket '"+ url +"'");
  var queryParams = {
    transports : ['websocket'],
    forceNew : false,
    query : parameters,
    path: '/ws/socket.io'
  };
  log("Query parameters = '" + parameters + "'");
  socket = io.connect(url,queryParams);
	
	//https://github.com/socketio/socket.io-client#events

	// convention for obj-c callback is window.webkit.messageHandlers.{event_name}.postMessage(obj ?? "");
	socket.on('connect',function() {
		log('Connected');
		window.webkit.messageHandlers.connect.postMessage("");
	});
	socket.on('error',function(error) {
		log('error ' + error);
		window.webkit.messageHandlers.error.postMessage(error);
	});
	socket.on('disconnect',function() {
		log('disconnect');
		window.webkit.messageHandlers.disconnect.postMessage("");
	});
	socket.on('reconnect',function(obj) {
		log('reconnect ' + obj);
		window.webkit.messageHandlers.reconnect.postMessage(obj);
	});
	socket.on('reconnect_attempt',function() {
		log('reconnect_attempt');
		window.webkit.messageHandlers.reconnect_attempt.postMessage("");
	});
	socket.on('reconnecting',function(obj) {
		log('reconnecting ' + obj);
		window.webkit.messageHandlers.reconnecting.postMessage(obj);
	});
	socket.on('reconnect_error',function(err) {
		log('reconnect_error ' + err);
		window.webkit.messageHandlers.reconnect_error.postMessage(err);
	});
	socket.on('reconnect_failed',function() {
		log('reconnect_failed');
		window.webkit.messageHandlers.reconnect_failed.postMessage();
	});
}


function disconnect() {
	socket.disconnect();
}

// Bridge functions
function createOnEvent(event) {
	var text = "creating event" + " " + event;
	log(text);
	socket.on(event, function(data) {
		window.webkit.messageHandlers.notification.postMessage({"event" : event,"response" : data});
	});
}

function emitEvent(event,data) {
	var text = "Emiting event " + "'" + event + "'";
	log(text);
	socket.emit(event,data);
}
