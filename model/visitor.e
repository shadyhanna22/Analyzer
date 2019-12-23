note
	description: "Summary description for {VISITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	VISITOR

feature

	visit_constant(c: CONSTANT) deferred end
	visit_addition(a: ADDITION) deferred end
	visit_multiplication(m: MULTIPLICATION) deferred end
	visit_modulo(mo: MODULO) deferred end
	visit_less_than(lt: LESS_THAN) deferred end
	visit_greater_than(gt: GREATER_THAN) deferred end
	visit_equals(eq:EQUALS) deferred end
	visit_conjunction(cj: CONJUNCTION) deferred end
	visit_disjunction(di: DISJUNCTION) deferred end
	visit_substraction(su: SUBSTRACTION) deferred end
	visit_unknown(u: UNKNOWN) deferred end
	visit_s_unknown(su: S_UNKNOWN) deferred end
	visit_quotient(qu: QUOTIENT) deferred end
	visit_bool_value(bl: BOOL_VALUE) deferred end
	visit_call_chain(cc: CALL_CHAIN) deferred end

feature
	s: STRING


end
