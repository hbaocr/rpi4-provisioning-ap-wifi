const fs = require('fs');
const os_cmd = require('child_process');

const  fpath_wpa_supplicant = "/etc/wpa_supplicant/wpa_supplicant.conf";
//const fpath_wpa_supplicant = "/Users/duonghuynhbao/Documents/idlogiqCompany/wpa_supplicant.conf";
function update_wpa_supplicant(ssid, pass) {
  let network = `

  network={
    ssid="${ssid}"
    psk="${pass}"
  }
  `
  fs.appendFileSync(fpath_wpa_supplicant, network, 'utf8');
}

function factory_wpa_supplicant(ssid = 'SSID_wifi', pass = 'qwertyuiop') {
  let network = `
  ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
  update_config=1
  country=US

  network={
    ssid="${ssid}"
    psk="${pass}"
  }
  `
  fs.writeFileSync(fpath_wpa_supplicant, network, 'utf8');
}

function software_reboot() {
  return new Promise((resolved, reject) => {
  
    let cmd = `sudo /sbin/reboot`;
    console.log(cmd);
    os_cmd.exec(cmd, function (error, stdout, stderr) {
      if (error) {
        reject(stderr);
      } else {
        resolved(stdout);
      }
    });
  })
}

function scan_wifi() {
  return new Promise((resolved, reject) => {
    let cmd = `sudo iw wlan0 scan | egrep 'SSID|signal'`;
    os_cmd.exec(cmd, function (error, stdout, stderr) {
      if (error) {
        reject(stderr);
      } else {
        console.log(stdout);
        resolved(stdout);
      }
    });
  })

}


module.exports.update_wpa_supplicant = update_wpa_supplicant;
module.exports.factory_wpa_supplicant = factory_wpa_supplicant;
module.exports.software_reboot = software_reboot;
module.exports.scan_wifi = scan_wifi;