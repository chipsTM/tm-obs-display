void Update(float dt) {
#if TMNEXT
    auto visState = VehicleState::ViewingPlayerState();
    if (visState is null || websocket is null) {
        return;
    }

    // print("total clients " + websocket.Clients.Length);
    for (uint i = 0; i < websocket.Clients.Length; i++) {
        auto wsc = websocket.Clients[i];
        if (wsc.Client !is null) {
            // Form the json string
            // while not most efficient method of sending data, 
            // it is easier for extensibility at the client side
            // what was asked for is retrived and sent over websockets
            array<string> featuresForJSON;
            for (uint j = 0; j < wsc.Features.Length; j++) {
                featuresForJSON.InsertLast(VisStateFormatter(visState, wsc.Features[j]));
            }
            wsc.SendData("{" + string::Join(featuresForJSON, ",") + "}");
        } 
    }
#endif
}

void CopyPresets(const string &in dirLocation) {
    if (!IO::FolderExists(dirLocation)) {
        trace("OBSDisplay folder doesn't exist. Creating...");
        IO::CreateFolder(dirLocation);
    }
    if (!IO::FolderExists(dirLocation + "/presets")) {
        trace("OBSDisplay/presets folder doesn't exist. Creating...");
        IO::CreateFolder(dirLocation + "/presets");
    }
    array<string> filesToCopy = {
        "keyboard.html",
        "pad.html",
        "speed.html",
        "404.html",
        "gearbox.html",
        "p5.min.js"
    };
    for (uint i = 0; i < filesToCopy.Length; i++) {
        IO::FileSource presetFile("src/presets/" + filesToCopy[i]);
        auto content = presetFile.Read(presetFile.Size());
        IO::File copiedFile(dirLocation + "/presets/" + filesToCopy[i]);
        copiedFile.Open(IO::FileMode::Write);
        copiedFile.Write(content);
        copiedFile.Close();
    }
}


WebSockets@ websocket;
HTTPServer@ display;
string dirLocation = IO::FromDataFolder("OBSDisplay");

void Main() {
#if TMNEXT
    // Only copy if folder doesn't exist
    if (!IO::FolderExists(dirLocation)) {
        CopyPresets(dirLocation);
    }

    // Leaving out for first release, seems like there are some hang ups
    // issues to resolve in future if people actually need a http server
    // otherwise serving a local page works just fine

    // we need a display server first to serve webpages
    // @display = HTTPServer("localhost", 7774);
    // display.Serve(dirLocation);


    // create new websocket and start connection
    @websocket = WebSockets("localhost", 7775);
    websocket.Listen();

#endif
}