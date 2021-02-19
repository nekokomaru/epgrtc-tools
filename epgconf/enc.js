const child2 = require('child_process');
child.on('close', (code) => {
    child2.exec("shutdown_srv ${START_AT}");
});
