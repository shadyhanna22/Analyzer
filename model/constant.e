note
	description: "Summary description for {CONSTANT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONSTANT

inherit
	EXPERSSION

create
	make

feature

value: INTEGER

feature {NONE} -- Initialization

	make(n:INTEGER)
			-- Initialization for `Current'.
		do
			value:=n
			is_comp := False
		end
feature

	accept(v:VISITOR)

		do
			v.visit_constant(Current)
		end

	set_parent (p:CONTAIN)

		do
			parent := p
		end
		
	str: STRING

		do
			Result := value.out
		end

end
