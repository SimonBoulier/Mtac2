open Constr
open Evd
open Environ

module Constr : sig
  exception Constr_not_found of string
  exception Constr_poly of string

  val mkConstr : string -> constr Lazy.t

  val mkUConstr : string -> Evd.evar_map -> Environ.env
    -> (Evd.evar_map * constr)

  val isConstr : Term.constr Lazy.t -> Term.constr -> bool

end

module ConstrBuilder : sig
  type t

  val from_string : string -> t

  val from_coq : t -> (Environ.env * Evd.evar_map)
    -> constr -> (constr array) option

  val build_app : t -> constr array -> constr

  val equal : t -> constr -> bool
end

module UConstrBuilder : sig
  type t

  val build_app : t -> Evd.evar_map -> Environ.env
    -> constr array -> (Evd.evar_map * constr)
end

module CoqN : sig

  val from_coq : (Environ.env * Evd.evar_map) -> constr -> int
  val to_coq : int -> constr
end

module CoqString : sig

  val from_coq : (Environ.env * Evd.evar_map) -> constr -> string
  val to_coq : string -> constr

end

module CoqList : sig

  val makeNil : types -> evar_map -> env -> evar_map * constr
  val makeCons : types -> constr -> constr -> evar_map -> env -> evar_map * constr
  val makeType : types -> evar_map -> env -> evar_map * types
  val from_coq : (Environ.env * Evd.evar_map) -> constr -> constr list

  (** Allows skipping an element in the conversion *)
  exception Skip

  exception NotAList of constr

  val from_coq_conv : (Environ.env * Evd.evar_map) -> (constr -> 'a)
    -> constr -> 'a list

  val to_coq : types -> ('a -> constr) -> 'a list -> evar_map -> env -> evar_map * constr
  val pto_coq : types -> ('a -> Evd.evar_map -> Evd.evar_map * constr) -> 'a list -> Evd.evar_map -> env -> Evd.evar_map * constr
end

module CoqOption : sig
  exception NotAnOptionType

  val mkNone : types -> constr

  val mkSome : types -> constr -> constr

  val from_coq : (Environ.env * Evd.evar_map) -> constr
    -> constr option

  (** to_coq ty ot constructs an option type with type ty *)
  val to_coq : types -> constr option -> constr
end

module CoqUnit : sig
  val mkTT : constr Lazy.t
end

module CoqBool : sig
  val mkTrue : constr
  val mkFalse : constr
end

module CoqEq : sig
  val mkAppEq : types -> constr -> constr -> constr
  val mkAppEqRefl : types -> constr -> constr
end

module CoqSig : sig
  val from_coq : (Environ.env * Evd.evar_map) -> constr -> constr
end

module MCTactics : sig
  val mkReduceGoal : constr Lazy.t
  val mkRunTac : Evd.evar_map -> Environ.env -> Evd.evar_map * Term.constr
  val mkTactic : Evd.evar_map -> Environ.env -> Evd.evar_map * Term.constr
end

module CoqPair : sig
  val mkPair : types -> types -> constr -> constr -> constr
end
