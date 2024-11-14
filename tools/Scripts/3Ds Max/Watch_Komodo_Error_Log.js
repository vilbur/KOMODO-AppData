var os = Components.classes['@activestate.com/koOs;1'].getService(Components.interfaces.koIOs);
try {
    appdir = komodo.interpolate('%(path:userDataDir)');
    var logFile = os.path.join(appdir,'pystderr.log');
    var winOpts = "centerscreen,chrome,resizable,scrollbars,dialog=no,close";
    window.openDialog('chrome://komodo/content/tail/tail.xul',"_blank",winOpts,logFile);
} catch(e) { alert(e); }

