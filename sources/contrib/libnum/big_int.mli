(* Operation on big integers *)

#open "nat";;

(* Big integers (type [big_int]) are signed integers of arbitrary size. *)
   
type big_int;;

value sign_big_int : big_int -> int
  and zero_big_int : big_int
  and unit_big_int : big_int
  and num_digits_big_int : big_int -> int
  and minus_big_int : big_int -> big_int
  and abs_big_int : big_int -> big_int
  and compare_big_int : big_int -> big_int -> int
  and eq_big_int : big_int -> big_int -> bool
  and le_big_int : big_int -> big_int -> bool
  and ge_big_int : big_int -> big_int -> bool
  and lt_big_int : big_int -> big_int -> bool
  and gt_big_int : big_int -> big_int -> bool
  and max_big_int : big_int -> big_int -> big_int
  and min_big_int : big_int -> big_int -> big_int
  and pred_big_int : big_int -> big_int
  and succ_big_int : big_int -> big_int
  and add_big_int : big_int -> big_int -> big_int
  and big_int_of_int : int -> big_int
  and add_int_big_int : int -> big_int -> big_int
  and sub_big_int : big_int -> big_int -> big_int
  and mult_int_big_int : int -> big_int -> big_int
  and mult_big_int : big_int -> big_int -> big_int
  and quomod_big_int : big_int -> big_int -> big_int * big_int
  and div_big_int : big_int -> big_int -> big_int
  and mod_big_int : big_int -> big_int -> big_int
  and gcd_big_int : big_int -> big_int -> big_int
  and int_of_big_int : big_int -> int
  and is_int_big_int : big_int -> bool
  and nat_of_big_int : big_int -> nat
  and big_int_of_nat : nat -> big_int
  and string_of_big_int : big_int -> string
  and big_int_of_string : string -> big_int
  and float_of_big_int : big_int -> float
  and square_big_int: big_int -> big_int
  and sqrt_big_int: big_int -> big_int
  and base_power_big_int: int -> int -> big_int -> big_int
  and sys_big_int_of_string: string -> int -> int -> big_int
  and power_int_positive_int: int -> int -> big_int
  and power_big_int_positive_int: big_int -> int -> big_int
  and power_int_positive_big_int: int -> big_int -> big_int
  and power_big_int_positive_big_int: big_int -> big_int -> big_int
  and round_futur_last_digit : string -> int -> int -> bool
  and approx_big_int: int -> big_int -> string
;;