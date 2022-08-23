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

    </script>
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
      let%lwt () = Dream.send client json.message in 
      loop ()
    | _ -> Dream.close_websocket client
  in
  loop ()

let () =
  Dream.run 
    @@ Dream.logger
    @@ Dream.router [
      Dream.get "/" (fun _ -> Dream.html home);
      Dream.get "ws"
      (fun _ -> 
        Dream.websocket handle_client);
    ]
    

    
    
