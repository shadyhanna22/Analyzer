note
	description: "Summary description for {LESS_THAN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LESS_THAN

inherit CONTAIN

create
	make

feature {NONE} -- Initialization

	make(l:EXPERSSION; r:EXPERSSION)
			-- Initialization for `Current'.
		do
			left:=l
			right:=r
			is_comp := True
		end

feature

	accept(v:VISITOR)

		do
			v.visit_less_than(Current)
		end

	set_left(e: EXPERSSION)

		do
			left := e
		end

	set_right(e: EXPERSSION)

		do
			right := e
		end
	set_parent (p:CONTAIN)

		do
			parent := p
		end

	str: STRING

		do
			create Result.make_empty
			Result.append ("<")
		end

end
