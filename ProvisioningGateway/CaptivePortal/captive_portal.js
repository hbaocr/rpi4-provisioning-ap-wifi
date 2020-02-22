const port = 80;
const host = "0.0.0.0";
const express = require('express');

let app = express();


app.use(express.static(__dirname + '/web'));// the root path to web  folder
//app.use('/',express.static(__dirname + '/web'));

let server = app.listen(port, host, function (err) {
    if (err) {
        console.log(err);
    } else {
        console.log(`listen: ${host}:${port}`);
    }
});
app.get('/', function(req, res){
    res.status(200).send('hello world');
  });
  
  //The 404 Route (ALWAYS Keep this as the last route)
  app.get('*', function(req, res){
    //console.log(req.query);
    let full_url = req.protocol + '://' + req.get('host') + req.originalUrl;
    console.log(full_url)
    res.redirect(301,'/');
    //res.send('what???', 404);
  });
//
