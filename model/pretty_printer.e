note
	description: "Summary description for {PRETTY_PRINTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PRETTY_PRINTER

inherit
	VISITOR

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create s.make_empty
		end

feature

	single(si:CONTAIN)

		local
			ll, rr: PRETTY_PRINTER
		do
			create ll.make
			create rr.make
			si.left.accept (ll)
			si.right.accept (rr)
			s.append ("("+ll.s+" "+si.str+" "+rr.s+")")
		end

	visit_unknown(u: UNKNOWN)

		do
			s.append (u.str)
		end

	visit_s_unknown(su: S_UNKNOWN)

		do
			s.append (su.str)
		end

	visit_constant(c: CONSTANT)

		do
			s.append (c.str)
		end

	visit_bool_value(bl: BOOL_VALUE)

		do
			s.append (bl.str)
		end
	visit_call_chain(cc: CALL_CHAIN)

		do
			s.append (cc.str)
		end

	visit_addition(a: ADDITION)

		do
			single(a)
		end

	visit_multiplication(m: MULTIPLICATION)

		do
			single(m)
		end

	visit_modulo(mo:MODULO)

		do
			single(mo)
		end

	visit_less_than(lt:LESS_THAN)

		do
			single(lt)
		end

	visit_greater_than(gt:GREATER_THAN)

		do
			single(gt)
		end

	visit_equals(eq:EQUALS)

		do
			single(eq)
		end

	visit_disjunction(di:DISJUNCTION)

		do
			single(di)
		end

	visit_conjunction(cj:CONJUNCTION)

		do
			single(cj)
		end

	visit_quotient(qu:QUOTIENT)

		do
			single(qu)
		end

	visit_substraction(su:SUBSTRACTION)

		do
			single(su)
		end

end

