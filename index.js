
const queue_len = 1000;
const CircularBuffer = require("circular-buffer");
const BeaconScanner = require('node-beacon-scanner');
const NonBlockPolling = require('./NonBlockPolling');
const poller = new NonBlockPolling(1000);

const util =  require('./utils');
let queue = new CircularBuffer(queue_len);
console.log('the queue size : ' + queue.capacity());

const scanner = new BeaconScanner();
scanner.onadvertisement = (ad) => {
 //if ((ad.beaconType == "eddystoneUrl") || (ad.beaconType == "eddystoneUid") || (ad.beaconType == "eddystoneEid"))
  {
    console.log(JSON.stringify(ad, null, '  '));
    let ble_addr = ad.id;
    let id = util.gen_ble_tag_id(ble_addr);
    let adv_data = { ...ad };
    adv_data.id = id;
    queue.enq(adv_data);

  
  }
};

// Start scanning
scanner.startScan().then(() => {
  console.log('Started to scan.');
}).catch((error) => {
  console.error(error);
});

//=============Poll to processing buffer================

// poller.onPoll( async()=>{

//   //console.log('triggered');
//   let l =queue.size();
//   for(let i=0;i<l;i++){
//       if(queue.size()>0){
//           let beacon_adv = queue.deq();
//           console.log(JSON.stringify(beacon_adv, null, '  '));
//       }
//   }
//   console.log('Process ',l, '  beacon');

//   poller.poll(); // Go for the next poll

// })
// poller.poll(); // Go for the next poll
