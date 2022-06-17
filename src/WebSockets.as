// Currently this implementation only sends data to the client
// Not sure if we'll need read data from the client outside of initial connection calls 

// https://www.honeybadger.io/blog/building-a-simple-websockets-server-from-scratch-in-ruby/
// https://developer.mozilla.org/en-US/docs/Web/API/WebSockets_API/Writing_WebSocket_servers

class WebSocketClient {
    Net::Socket@ Client;
    array<string> Features;

    WebSocketClient(Net::Socket@ client, array<string> features) {
        @Client = @client;
        Features = features;
    }

    // method for sending Text data 
    void SendData(const string &in data) {
        if (data.Length < 3) {
            // not sure what issue is here, but
            // for some reason connection fails with very short length
            return;
        }
        
        int padBytes;
        uint payloadLen;
        if (data.Length <= 125) {
            padBytes = 1;
            payloadLen = data.Length;
        } else if (data.Length < Math::Pow(2,16)) {
            padBytes = 3;
            payloadLen = 126;
        } else if (data.Length < Math::Pow(2,64)) {
            padBytes = 9;
            payloadLen = 127;
        }

        // Construct the Data Frame
        // Preallocate 1 byte then payload size then payload
        auto msg = MemoryBuffer(1 + padBytes + data.Length);
        // Opcode and Text Data flags
        msg.Seek(0);
        msg.Write(0x81);
        // Message Length
        msg.Seek(1);
        msg.Write(payloadLen);
        
        if (payloadLen == 126) {
            for (int i = 0; i < padBytes - 1 ; i++) {
                msg.Seek(2 + i);
                msg.Write((data.Length >> (8*(padBytes-2-i))) & 0xff);
            }
        } else if (payloadLen == 127) {
            for (int i = 0; i < padBytes - 1; i++) {
                msg.Seek(2 + i);
                msg.Write((data.Length >> (8*(padBytes-2-i))) & 0xff);
            }
        }

        // Write data to frame
        msg.Seek(1 + padBytes);
        msg.Write(data);
        msg.Seek(0);
        // Send msg over websockets
        if (!Client.Write(msg)) {
            Client.Close();
            @Client = null;
        }
    }
}

class WebSockets {
    // "private"
    Net::Socket@ tcpsocket;
    // "public"
    array<WebSocketClient@> Clients;

    WebSockets(const string &in host, int port) {
        @tcpsocket = Net::Socket();

        if (!tcpsocket.Listen(host, port)) {
            trace("Could not establish a TCP socket!");
            return;
        }

        trace("Connecting to host...");

        while (!tcpsocket.CanRead()) {
            yield();
        }

    }

    void Listen() {
        while (true) {
            // we accept any incoming connections
            // acceptclient will only accept max specified
            AcceptClient();


            // this is a bit janky
            // I think this can be improved
            array<int> cleanup;
            // // cleanup the failed connections
            for (uint i = 0; i < Clients.Length; i++) {
                // trace(Clients[i].Client is null);
                if (Clients[i].Client is null) {
                    cleanup.InsertLast(i);
                }
            }
            // print("Cleanup " + cleanup.Length);
            for (uint i = 0; i < cleanup.Length; i++) {
                if (i < Clients.Length) {
                    Clients.RemoveAt(i);
                }
            }
                    
            // do other activity
            yield();
        }
    }

    void AcceptClient() {
        if (Clients.Length == 5) {
            // if full just return
            return;
        }
        auto client = tcpsocket.Accept();
        // trace("accepted websocket client");
        
        string key;
        string protocol;

        if (client is null) {
            return;
        }

        // While loop code snippet taken from Network test example script and slightly modified
        // https://github.com/openplanet-nl/example-scripts/blob/master/Plugin_NetworkTest.as
        while (true) {
            // If there is no data available yet, yield and wait.
            while (client.Available() == 0) {
                yield();
            }

            // There's buffered data! Try to get a line from the buffer.
            string line;
            if (!client.ReadLine(line)) {
                // We couldn't get a line at this point in time, so we'll wait a
                // bit longer.
                yield();
                continue;
            }

            // We got a line! Trim it, since ReadLine() returns the line including
            // the newline characters.
            line = line.Trim();

            // Parse the header line.
            auto parse = line.Split(":");
            if (parse.Length == 2 && parse[0].ToLower() == "sec-websocket-key") {
                key = parse[1].Trim();
            } else if (parse.Length == 2 && parse[0].ToLower() == "sec-websocket-protocol") {
                protocol = parse[1].Trim();
            }

            // If the line is empty, we are done reading all headers.
            if (line == "") {
                break;
            }

            // Print the header line.
            // print("\"" + line + "\"");
        }

        // We did not get a websocket header request
        // Close connection
        if (key == "") {
            client.Close();
            return;
        }

        // Complete handshake
        string hashkey = Hash::Sha1(key + "258EAFA5-E914-47DA-95CA-C5AB0DC85B11");
        auto bytearray = MemoryBuffer(20);
        int counter = 0;
        for (int i = 0; i < hashkey.Length; i+=2) {
            uint8 dec = getHexToDec(hashkey.SubStr(i,1)) * 16 + getHexToDec(hashkey.SubStr(i+1,1));
            bytearray.Write(dec);
            counter += 1;
            bytearray.Seek(counter);
        }
        bytearray.Seek(0);
        string b64key = bytearray.ReadToBase64(bytearray.GetSize());

        // Complete the handshake
        if (!client.WriteRaw(
            "HTTP/1.1 101 Switching Protocols\r\n" +
            "Upgrade: websocket\r\n" +
            "Connection: Upgrade\r\n" +
            "Sec-WebSocket-Version: 13\r\n" +
            "Sec-WebSocket-Accept: " + b64key + "\r\n" +
            // we're overriding protocol in order to allow
            // client to request specific data points
            // this is more efficient as we don't need to 
            // send the entire VehicleState or whatever back to client
            ((protocol != "") ? "Sec-WebSocket-Protocol: " + protocol + "\r\n" : "") +
            "\r\n"
        )) {
            print("Could not complete handshake");
            return;
        }
        trace("successfully upgraded connection to sockets");
        // add to connections
        Clients.InsertLast(WebSocketClient(@client, protocol.Split("|")));
    }

    void Close() {
        trace("tcpsocket closed");
        tcpsocket.Close();
    }

    // helper function to convert hex to dec values
    // only used in retrieving the bytes of the SHA1 key
    int getHexToDec(const string &in val) {
        if (val == "a") {
            return 10;
        } else if (val == "b") {
            return 11;
        } else if (val == "c") {
            return 12;
        } else if (val == "d") {
            return 13;
        } else if (val == "e") {
            return 14;
        } else if (val == "f") {
            return 15;
        } else {
            return Text::ParseInt(val);
        }
    }
}