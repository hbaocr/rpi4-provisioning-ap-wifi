const http_port = 80;
const https_port = 443;
const host = "0.0.0.0";
const express = require('express');
const fs = require('fs')
const https = require('https');


let app = express();


app.use(express.static(__dirname + '/web'));// the root path to web  folder
//app.use('/',express.static(__dirname + '/web'));




app.listen(http_port, host, function (err) {
  if (err) {
    console.log(err);
  } else {
    console.log(`listen: ${host}:${http_port}`);
  }
});
app.get('/', function (req, res) {
  res.status(200).send('hello world');
});

//  redirect unhandled  request to home
app.get('*', function (req, res) {
  let full_url = req.protocol + '://' + req.get('host') + req.originalUrl;
  console.log(full_url)
  res.redirect(301, '/');
});

