const { update_wpa_supplicant, factory_wpa_supplicant, software_reboot, scan_wifi } = require('./utils');
const http_port = 80;
const dev_usrname = "admin";
const dev_password = "admin@123";
const host = "0.0.0.0";
const express = require('express');
const bodyParser = require("body-parser");
let app = express();

app.use(express.static(__dirname + '/web'));// the root path to web  folder
//app.use('/',express.static(__dirname + '/web'));
//Here we are configuring express to use body-parser as middle-ware.
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());



app.listen(http_port, host, function (err) {
  if (err) {
    console.log(err);
  } else {
    console.log(`listen: ${host}:${http_port}`);
  }
});

app.post('/mqtt_credential', function (req, res) {
  res.status(200).send('credential');
});

app.post('/wifi_credential', function (req, res) {
  let ssid = req.body.ssid;
  let password = req.body.password;
  console.log("ssid_wifi = " + ssid + ", password is " + password);

  if ((ssid !== undefined) && (password !== undefined)) {
    if (password.length > 6) {
      update_wpa_supplicant(ssid, password);

      res.status(200).send({ "status": "OK and Reboot" });
      software_reboot();
    } else {
      // not acceptable status code
      res.status(406).send({ "status": "Pass must be > 6" });
    }
  } else {
    res.status(406).send({ "status": "invalid ssid or password" });
  }

});

app.post('/wifi_factory_reset', function (req, res) {

    factory_wpa_supplicant();
    res.status(200).send({ "status": "OK" });

});
app.post('/scan_wifi', function (req, res) {
  scan_wifi().then((ssid_list) => {
    res.status(200).send(ssid_list);
  }).catch((e) => {
    res.status(500).send('Internal Server Error');
  })
})

//  redirect unhandled  request to home
app.get('*', function (req, res) {
  let full_url = req.protocol + '://' + req.get('host') + req.originalUrl;
  console.log(full_url)
  //res.redirect(301, '/');//permanent redirect
  res.redirect(302, '/');//  temporary redirect
});

