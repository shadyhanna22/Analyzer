note
	description: "Summary description for {BOOL_VALUE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BOOL_VALUE
inherit
	EXPERSSION

create
	make

feature

value: BOOLEAN

feature {NONE} -- Initialization

	make(n:BOOLEAN)
			-- Initialization for `Current'.
		do
			value:=n
			is_comp := False
		end
feature

	accept(v:VISITOR)

		do
			v.visit_bool_value(Current)
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
