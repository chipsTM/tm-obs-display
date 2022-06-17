class HTTPServer {
    Net::Socket@ server;
    Net::Socket@ Client;
    string dir;

    HTTPServer(const string &in host, int port) {
        @server = Net::Socket();

        if (!server.Listen(host, port)) {
            trace("Could not establish a TCP socket!");
            return;
        }

        trace("Listening to " + host + " on port " + port + " ...");
    }

    void Close() {
        Client.Close();
        server.Close();
    }

    void HandleRequest() {
        if (!server.CanRead()) {
            return;
        }

        @Client = server.Accept();
        if (Client is null) {
            return;
        }


        // While loop code snippet taken from Network test example script and slightly modified
        // https://github.com/openplanet-nl/example-scripts/blob/master/Plugin_NetworkTest.as
        string page;
        while (true) {
            // If there is no data available yet, yield and wait.
            while (Client.Available() == 0) {
                yield();
            }

            // There's buffered data! Try to get a line from the buffer.
            string line;
            if (!Client.ReadLine(line)) {
                // We couldn't get a line at this point in time, so we'll wait a
                // bit longer.
                yield();
                continue;
            }

            // We got a line! Trim it, since ReadLine() returns the line including
            // the newline characters.
            line = line.Trim();

            if (line.StartsWith("GET")) {
                auto parts = line.Split(" ");
                page = parts[1];
            }

            // Parse the header line.
            auto parse = line.Split(":");

            // If the line is empty, we are done reading all headers.
            if (line == "") {
                break;
            }

            // Print the header line.
            // print("\"" + path + "\"");
        }

        string floc = dir + page;
        auto ext = page.Split(".");
        string extName = ext[ext.Length-1];

        if (IO::FileExists(floc) && mimetypes.Exists(extName)){
            IO::File file(floc);
            file.Open(IO::FileMode::Read);
            MemoryBuffer fileBuffer = file.Read(file.Size());
            file.Close();
            fileBuffer.Seek(0);

            if (!Client.WriteRaw(
                "HTTP/1.1 200 Ok\r\n" +
                "Content-Type: " + string(mimetypes[extName]) + "\r\n" +
                "Content-Length: " + fileBuffer.GetSize() + "\r\n\r\n"
            )) {
                print("could not send to client");
                return;
            }

            if (!Client.Write(fileBuffer)) {
                print("could not send to client");
                return;
            }
            if (!Client.WriteRaw("\r\n")) {
                print("could not send to client");
                return;
            }

        } else {
            if (IO::FileExists(dir + "/presets/404.html")) {
                IO::File file(dir + "/presets/404.html");
                file.Open(IO::FileMode::Read);
                MemoryBuffer fileBuffer = file.Read(file.Size());
                file.Close();
                fileBuffer.Seek(0);
                auto content = fileBuffer.ReadString(fileBuffer.GetSize());
                if (!Client.WriteRaw(
                    "HTTP/1.1 404 Not Found\r\n" +
                    "Content-Type: text/html; charset=utf-8\r\n" +
                    "Content-Length: " + fileBuffer.GetSize() + "\r\n" +
                    "\r\n" + content + "\r\n"
                )) {
                    print("could not send to client");
                    return;
                }
            } else {
                string msg = "Not Found";
                if (!Client.WriteRaw(
                    "HTTP/1.1 404 Not Found\r\n" +
                    "Content-Type: text/html; charset=utf-8\r\n" +
                    "Content-Length: " + msg.Length + "\r\n" +
                    "\r\n" + msg + "\r\n"
                )) {
                    print("could not send to client");
                    return;
                }
            }
        }


        Client.Close();
        @Client = null;
    }

    void ServeFunc() {
        while (true) {
            HandleRequest();
            yield();
        }
    }

    void Serve(const string &in directory = "") {
        dir = directory;
        startnew(CoroutineFunc(ServeFunc));
    }
}