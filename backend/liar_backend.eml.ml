let home =
  <html>
  <body>
    <script>

    var socket = new WebSocket("ws://" + window.location.host + "/ws");

    socket.onopen = function () {
      socket.send(JSON.stringify({"message_type":"Hell", "message": "Low"}));
    };

    socket.onmessage = function (e) {
      alert(e.data);
    };
    test = function () {
      socket.send(JSON.stringify({"message_type":"Hell", "message": "Low"}));
    }

    </script>

    <button onClick="test();">
    Test Button
    </button>
  </body>
  </html>

type message_object = {
    message_type: string;
    message: string;
} [@@deriving yojson]



let handle_client client =  
  let rec loop () = 
    match%lwt Dream.receive client with 
    | Some(message') ->
      let json = message' |> Yojson.Safe.from_string |> message_object_of_yojson in            
      let _ = Dream.send client json.message in 
      loop ()
    | _ -> 
      client|>Dream.close_websocket
  in
  loop ()

let () =
  Dream.run 
    @@ Dream.logger
    @@ Dream.router [
      Dream.get "/" (fun _ -> Dream.html home);
      Dream.get "ws"
      (fun req -> 
        (* Sec-WebSocket-Key 가 없으면 뱉기 *)
        let websocket_key = Dream.header req "Sec-WebSocket-Key" in 
        match websocket_key with
        | Some(_) -> Dream.websocket handle_client
        | None -> Dream.websocket Dream.close_websocket
        );
    ]
    

    
    
