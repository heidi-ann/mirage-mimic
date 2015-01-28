open V1_LWT
open Lwt
open Ipaddr
open String
open Re

(* Based on mirage-skeleton/xen/static_website+ip code for reading boot parameters *)
type t = { cmd_line : string;
           parameters : (string * string) list }

(* read boot parameter line and store in assoc list - expected format is "key1=val1 key2=val2" *)
let create = 
  let cmd_line = "socks_ip=192.168.1.105 socks_port=8888 dest_ip=192.168.1.104 dest_ports=80,81 ip=192.168.1.2 netmask=255.255.255.0 gw=192.168.1.1" in
  let entries = Re_str.(split (regexp_string " ") cmd_line) in
  let vartuples =
    List.map (fun x ->
        match Re_str.(split (regexp_string "=") x) with 
        | [a;b] -> Printf.printf "%s=%s\n" a b ; (a,b)
        | _ -> raise (Failure "malformed boot parameters")) entries
  in
  { cmd_line = cmd_line; parameters = vartuples}

(* get boot parameter *)
let get t parameter = 
  try 
    List.assoc parameter t.parameters
  with
    Not_found -> Printf.printf "Boot parameter %s not found\n" parameter; raise Not_found


let to_string t = List.fold_left (fun str (x,y) -> str^" "^x^"="^y^" ") "" t.parameters