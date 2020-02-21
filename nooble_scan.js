const noble = require('@abandonware/noble');
noble.startScanning();

noble.on("discover", function(peripheral) { 

  let macAdress = peripheral.uuid;
  let rss = peripheral.rssi;
  //let localName = advertisement.localName; 
  console.log('found device: ', macAdress, ' ', ' ', rss);   
})