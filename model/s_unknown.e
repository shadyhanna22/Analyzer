note
	description: "Summary description for {S_UNKNOWN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	S_UNKNOWN

inherit
	EXPERSSION

create
	make

feature

	value: STRING

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create value.make_empty
			value := "nil"
			is_comp := False
		end

feature

	accept(v:VISITOR)

		do
			v.visit_s_unknown (Current)
		end

	set_parent (p:CONTAIN)

		do
			parent := p
		end

	str: STRING

		do
			Result := value
		end

end
