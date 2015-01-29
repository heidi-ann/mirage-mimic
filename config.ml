open Mirage

let main = foreign "Unikernel.Main" (console @-> network @-> job)

let platform =
    match get_mode () with
    | `Unix -> "unix"
    | `Xen -> "xen"

let () =
  add_to_ocamlfind_libraries ["cstruct"; "cstruct.syntax"; "re"; "re.str"; "tcpip.ethif"; "tcpip.tcp"; "tcpip.udp"; "tcpip.stack-direct";  "mirage-clock-" ^ platform; "tls" ];
  add_to_opam_packages ["cstruct"; "tcpip"; "re"; "mirage-clock-" ^ platform; "tls"; "tls.mirage"];
  register "unikernel" [
    main $ default_console $ tap0
  ]
