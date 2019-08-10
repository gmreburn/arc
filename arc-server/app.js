const uuidv4 = require('uuid/v4');
const enet = require("enet");
const md5 = require("md5");
const addr = new enet.Address("0.0.0.0", 3000);

const GAME_INITIALIZE = 1;

var p1 = uuidv4();
var players = {
  p1: {
    position: {x:0,y:0}
  }
}

enet.createServer({
  address: addr, /* the address the server host will bind to */
  peers: 32, /* allow up to 32 clients and/or outgoing connections */
  channels: 2, /* allow up to 2 channels to be used, 0 and 1 */
  down: 0, /* assume any amount of incoming bandwidth */
  up: 0 /* assume any amount of outgoing bandwidth */

}, function (err, host) {
  if (err) {
    return; /* host creation failed */
  }

  //setup event handlers..
  host.on("connect", function (peer, data) {
    var payload = {
      type: GAME_INITIALIZE,
      secret: uuidv4(),
      players: {}
    };
    Object.keys(players).forEach(function (key) {
      console.log(key); // key
      console.log(players[key]); // value
      payload.players[md5(key)] = players[key]
    });
    peer.send(0, JSON.stringify(payload));
    console.log("sent connect packet:", JSON.stringify(payload));
    

    //incoming peer connection
    peer.on("message", function (packet, channel) {
      console.log("received packet contents:", packet.data().toString());
    });
  });

  //start polling the host for events at 50ms intervals
  host.start(50);
});