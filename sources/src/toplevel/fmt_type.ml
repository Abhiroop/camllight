(* Printing a type expression *)

#open "misc";;
#open "const";;
#open "globals";;
#open "builtins";;
#open "types";;
#open "modules";;
#open "pr_type";;
#open "format";;

let print_global sel_fct gl =
  if not (can_omit_qualifier sel_fct gl) then begin
    print_string gl.qualid.qual;
    print_string "__"
  end;
  print_string gl.qualid.id
;;

let output_type_constr = 
  (print_global types_of_module: type_desc global -> unit)
and output_value =
  (print_global values_of_module: value_desc global -> unit)
and output_constr =
  (print_global constrs_of_module: constr_desc global -> unit)
and output_label =
  (print_global labels_of_module: label_desc global -> unit)
;;

let rec print_typ priority ty =
  let ty = type_repr ty in
  match ty.typ_desc with
    Tvar _ ->
      print_string "'";
      print_string (name_of_type_var ty)
  | Tarrow(ty1, ty2) ->
      if priority >= 1 then print_string "(";
      open_hovbox 0;
      print_typ 1 ty1;
      print_string " ->"; print_space();
      print_typ 0 ty2;
      close_box();
      if priority >= 1 then print_string ")"
  | Tproduct(ty_list) ->
      if priority >= 2 then print_string "(";
      open_hovbox 0;
      print_typ_list 2 " *" ty_list;
      close_box();
      if priority >= 2 then print_string ")"
  | Tconstr(cstr, args) ->
      open_hovbox 0;
      begin match args with
        []    -> ()
      | [ty1] ->
          print_typ 2 ty1; print_space ()
      | tyl ->
          print_string "(";
          open_hovbox 0;
          print_typ_list 0 "," tyl;
          close_box();
          print_string ")"; print_space()
      end;
      print_global types_of_module cstr;
      close_box()

and print_typ_list priority sep = function
    [] ->
      fatal_error "print_typ_list"
  | [ty] ->
      print_typ priority ty
  | ty::rest ->
      print_typ priority ty;
      print_string sep; print_space();
      print_typ_list priority sep rest
;;

let print_type ty = print_typ 0 ty;;

let print_one_type ty = reset_type_var_name(); print_typ 0 ty;;
