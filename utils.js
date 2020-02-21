const sha256 = require('sha256');
module.exports.gen_ble_tag_id = (str)=> {
    let id = str;
    if (str.length < 12) {
      id = sha256(str);
    }
    return id;
}