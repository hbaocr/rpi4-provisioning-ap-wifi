var mqtt = require('mqtt');
const mqtt_link = 'mqtt://104.198.141.65';
var options = {
    port: 1883,
    host: mqtt_link,
    clientId: 'mqttjs_' + Math.random().toString(16).substr(2, 8),
    username: 'beacon',
    password: 'password',
    keepalive: 60,
    reconnectPeriod: 1000,
    protocolId: 'MQIsdp',
    protocolVersion: 3,
    clean: true,
    encoding: 'utf8'
};
var client = mqtt.connect(mqtt_link, options);
client.on('connect', function() { // When connected
    console.log('connected');
    // subscribe to a topic
    client.subscribe('topic1/#', function() {
        // when a message arrives, do something with it
        client.on('message', function(topic, message, packet) {
            console.log("Received '" + message + "' on '" + topic + "'");
        });
    });

    // publish a message to a topic
    client.publish('hh', 'my message', function() {
        console.log("Message is published");
        client.end(); // Close the connection when published
    });
});
client.on('error', function(err) {
    console.log(err);
});