val home : 'a
type message_object = { message_type : string; message : string; }
val message_object_of_yojson : Yojson.Safe.t -> message_object
val yojson_of_message_object : message_object -> Yojson.Safe.t
val handle_client : Dream.websocket -> unit Lwt.t
