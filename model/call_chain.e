note
	description: "Summary description for {CALL_CHAIN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CALL_CHAIN

inherit
	EXPERSSION

create
	make

feature

value: STRING

feature {NONE} -- Initialization

	make(n:STRING)
			-- Initialization for `Current'.
		do
			value:=n
			is_comp := False
		end
feature

	accept(v:VISITOR)

		do
			v.visit_call_chain(Current)
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
