var arc = require('./constants');
const uuidv4 = require('uuid/v4');
const enet = require("enet");
const md5 = require("md5");
const addr = new enet.Address("0.0.0.0", 3000);

var p1 = uuidv4();
var players = {
  p1: {
    position: { x: 0, y: 0, vx: 0, xy: 0 }
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
      type: arc.GAME_INITIALIZE,
      team: arc.TEAM_GREEN,
      position: { x: 1, y: 1 },
      map: {
        name: 'aplgo.map',
        hash: md5('file contents.map'),
        energyRechargeRate: arc.ENERGY_RECHARGE_RATE,
        specialRechargeRate: arc.SPECIAL_RECHARGE_RATE,
        objective: arc.OBJECTIVE_CTF
      },
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
      const msg = JSON.parse(packet.data());
      switch (msg.type) {
        case arc.FIRE_LASER:
          break;
        case arc.FIRE_MISSILE:
          break;
        case arc.FIRE_MORTAR:
          break;
        case arc.FIRE_BOUNCY:
          break;
        case arc.TEAM_CHANGED:
          break;
        case arc.VELOCITY_CHANGED:
          break;
        case arc.FLAG_CAPTURED:
          break;
        case arc.SWITCH_FLIPPED:
          break;
      }
    });
  });

  //start polling the host for events at 50ms intervals
  host.start(50);
});