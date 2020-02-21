// config.js
const dotenv = require('dotenv');
dotenv.config();
module.exports = {
    mongodb_host: process.env.MONGO_URL,
    dtb_name:process.env.DTB_NAME,
    collection_name:process.env.COLLECTION_NAME,
    proxy_repo: process.env.FREE_PROXY_REPO,
    polling_period:parseInt(process.env.POLLING_PERIOD)||1000,
    server_port:process.env.SERVER_PORT,
    local_dtb_name:process.env.LOCAL_DTB_NAME||"beacon",
    enable_log:(process.env.ENABLE_LOG=="true")
};
