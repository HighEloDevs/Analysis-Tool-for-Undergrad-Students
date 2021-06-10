function aaa(){
    const fs = require(['fs']);
    let posts = fs.readdirSync("../pages");
    console.log(posts)
};