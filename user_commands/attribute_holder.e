note
	description: "Summary description for {ATTRIBUTE_HOLDER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ATTRIBUTE_HOLDER

create
	make

feature -- attrabutes

	fname, ftype: STRING

feature {NONE} -- Initialization

	make(fn: STRING ; ft: STRING)
			-- Initialization for `Current'.
		do
			create fname.make_from_string (fn)
			create ftype.make_from_string (ft)
		end

end
