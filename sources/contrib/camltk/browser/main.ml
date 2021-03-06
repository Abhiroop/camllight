#open "unix";;
#open "protocol";;
#open "tk";;
#open "config";;
#open "misc";;
#open "modules";;
#open "hyper_printers";;
#open "visual";;
#open "source";;


let bye () = 
  CloseTk();
  exit 0
;;

(* Open generic requester *)
let new_open_top = 
  let cnter = ref 0 in
  function () ->
   incr cnter; "open" ^ string_of_int !cnter
;;


let open title action =
  let t = toplevelw__create (support__new_toplevel_widget "open") [] in
  focus__set t;
  grab__set_local t;
  let tit = label__create t [Text title] in
  let e = entry__create t [Relief Sunken] in
    tk__bind e [[], XKey "Return"]
      	(BindSet ([], fun _ -> action (entry__get e); destroy t));

  let f = frame__create t [] in
  let bok = button__create f
      	    [Text "Ok"; 
      	     Command (fun () -> action (entry__get e); destroy t)] in
  let bcancel = button__create f
      	    [Text "Cancel"; 
      	     Command (fun () -> destroy t)] in

    tk__bind t [[], XKey "Return"]
      	 (BindSet ([], (fun _ -> button__invoke bok)));
    tk__bind t [[], XKey "Escape"]
      	 (BindSet ([], (fun _ -> button__invoke bcancel)));
    tk__bind e [[], XKey "Escape"]
      	 (BindSet ([], (fun _ -> button__invoke bcancel)));

    pack [bok; bcancel] [Side Side_Left; Fill Fill_X; Expand true];
    pack [tit;e] [Fill Fill_X];
    pack [f] [Side Side_Bottom; Fill Fill_X];
    util__resizeable t;
    focus__set e
;;

(******* Modules *********)
(* returns: panel widget, add *)
let module_panel parent =
  let f = frame__create parent [] in (* vgroup *)
  let title = label__create f [Text "Opened Modules"] in

  let fls = frame__create f [Relief Sunken; Borderwidth (Pixels 2)] in 
  let lb = listbox__create fls [] in
  let sb = scrollbar__create fls [] in
    util__scroll_listbox_link sb lb;
    tk__bind lb [[Double], WhatButton 1] 
           (BindSet ([], fun _ ->
                          do_list (fun s ->
			             visual_module false (listbox__get lb s))
                                     (listbox__curselection lb)));
  let add_module n =
    try 
      used_modules := find_module n :: !used_modules; 
      listbox__insert lb End [n]
    with
      Toplevel -> begin
	 dialog (support__new_toplevel_widget "error")
	     "Caml Browser Error"
	     ( "Cannot open module :" ^ n)
	     ""
	     0
	     ["Ok"];
	 ()
	end

  and close_module () =
    do_list (fun s -> 
	       let name = (listbox__get lb s) in
		 used_modules := exceptq (find_module name) !used_modules;
		 listbox__delete lb s s)
	    (listbox__curselection lb) in

  let c = button__create f
      [Text "Close Module"; Relief Raised;
       Command close_module] in
  let o = button__create f
      [Text "Open Module"; Relief Raised; 
       Command (fun () -> open "Open a module" add_module)] in

   pack [title] [Fill Fill_X];
    pack [lb] [Side Side_Left; Fill Fill_Both; Expand true];
    pack [sb] [Side Side_Right; Fill Fill_Y];
   pack [fls] [Fill Fill_Both; Expand true];
   pack [c;o] [Side Side_Bottom; Anchor Center; Fill Fill_X];

   f, add_module
;;


(******* Load path panel ******)
(* returns: path widget, add *)
let path_panel parent =
  let f = frame__create parent [] in (* vgroup *)
  let title = label__create f [Text "Load Path"] in

  let fls = frame__create f [Relief Sunken; Borderwidth (Pixels 2)] in 
  let lb = listbox__create fls [] in
  let sb = scrollbar__create fls [] in
    util__scroll_listbox_link sb lb;

  let add_path n =
      load_path := n :: !load_path;
      listbox__insert lb (Number 0) [n] in

  let o = button__create f
      [Text "Add Directory"; Relief Raised; 
       Command (fun () ->
      	       	 open "Add a directory to the load path" add_path)] in

   pack [title] [Fill Fill_X];
    pack [lb] [Side Side_Left; Fill Fill_Both; Expand true];
    pack [sb] [Side Side_Right; Fill Fill_Y];
   pack [fls] [Fill Fill_Both; Expand true];
   pack [o] [Side Side_Bottom; Anchor Center; Fill Fill_X];
   f, add_path
;;

(********** Browsing panel *********)
let browsing_panel parent =
  let f = frame__create parent [] in (* vgroup *)
   (* Entering something *)
   let enterf = frame__create f [] in
   let m = label__create enterf [Text "Enter a global symbol:"] in
   let e = entry__create enterf [Relief Sunken] in
      tk__bind e [[], XKey "Return"]
                 (BindSet ([], (fun _ -> visual_search_any 
      	       	       	       	       	  (entry__get e))));
      (* Make e "autofocus" *)
      tk__bind e [[Any], Enter]
	    (BindSet ([], (fun _ -> focus__set e)));
      tk__bind e [[Any], Leave]
	    (BindSet ([], (fun _ -> focus__none ())));

      pack [m] [Side Side_Left];
      pack [e] [Side Side_Left; Fill Fill_X];

   (* Loading a source file *)
   let o2 = button__create f
      [Text "Open source file"; Relief Raised;
       Command (fun () -> open "Open a source file" display_file)] in

   pack [o2; enterf] [Side Side_Bottom; Fill Fill_X];
   f
;;

let main () = 
  let top = OpenTkClass "CamlBrowser" in
     signal SIGINT (Signal_handle bye);
     signal SIGTERM (Signal_handle bye);
  (* Resources *)
  resource__add "*library_path" "/usr/local/lib/caml-light"
      WidgetDefault;
  resource__add "*module_set" "cautious"
      WidgetDefault;

  (* highlighting of anchors *)
  begin match colormodel__get top with
      Monochrome -> anchor_attrib := [Underline true]
    | _ -> ()
  end;

  let t = label__create top [Text "Caml Browser"; Relief Raised] in

  let g = frame__create top [] in (* hgroup *)
    let mods, add_module = module_panel g 
    and dirs, add_path = path_panel g in
      pack [mods;dirs] [Side Side_Left; Fill Fill_Both; Expand true];

  let browse = browsing_panel top
  and quitb = button__create top [Text "Quit"; Relief Raised; Command bye] in

    pack [t] [Side Side_Top; Fill Fill_X];
    pack [g] [Side Side_Top; Fill Fill_Both; Expand true];
    pack [browse] [Side Side_Top; Fill Fill_Both];
    pack [quitb] [Side Side_Bottom; Fill Fill_X];
    util__resizeable top;
   (* focus__set e; *)

  (* The interface is now ready *)
  let libpath = ref (resource__get top "library_path" "library_path") 
  and module_set = ref (resource__get top "module_set" "module_set") 
  and initial_modules = ref ([] : string list) in
  (* Initialisation of the module machinery *)
  default_used_modules := assoc !module_set default_used_interfaces;
  load_path := [];
  path_library := !libpath;
  add_path !path_library;
  do_list add_module !default_used_modules;

  arg__parse [
       "-stdlib", arg__String 
      	   (fun s -> path_library := s; add_path s);
       "-I", arg__String add_path
       ]
       (fun s -> initial_modules := s :: !initial_modules);

   try
     do_list (function m -> 
       	       add_module m;
      	       visual_module false m) 
      	     !initial_modules;
     tk__MainLoop()
   with
     TkError s as ex -> begin 
      	 prerr_string s;
      	 prerr_string "\n";
      	 flush std_err;
      	 CloseTk(); 
      	 raise ex 
	 end
   | ex -> begin CloseTk(); raise ex end
;;

(* protocol__debug := true;; *)


printexc__f (handle_unix_error main) ()
;;

