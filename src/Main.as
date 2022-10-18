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
            array<string> features = wsc.Protocol.Split("|");
            for (uint j = 0; j < features.Length; j++) {
                featuresForJSON.InsertLast(VisStateFormatter(visState, features[j]));
            }
            wsc.SendMessage("{" + string::Join(featuresForJSON, ",") + "}");
        }
    }
#endif
}

void CopyPresets() {
    if (!IO::FolderExists(IO::FromStorageFolder("/presets"))) {
        trace("OBSDisplay/presets folder doesn't exist. Creating...");
        IO::CreateFolder(IO::FromStorageFolder("/presets"));
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
        IO::File copiedFile(IO::FromStorageFolder("/presets/") + filesToCopy[i]);
        copiedFile.Open(IO::FileMode::Write);
        copiedFile.Write(content);
        copiedFile.Close();
    }
}


Net::WebSocket@ websocket;

void Main() {
#if TMNEXT
    // Only copy presets if folder doesn't exist
    if (!IO::FolderExists(IO::FromStorageFolder("/presets"))) {
        CopyPresets();
    }

    // create new websocket and start connection
    @websocket = Net::WebSocket();
    if (!websocket.Listen(OBS_Display_Address, OBS_Display_Port)) {
        trace("unable to start websockets server");
        return;
    }

#endif
}