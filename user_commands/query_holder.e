note
	description: "Summary description for {COMMAND_HOLDER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	QUERY_HOLDER

inherit
	HOLDER

create
	make

feature -- attrabutes

	fname, rtype: STRING
	array: ARRAY[TUPLE[pn: STRING; ft: STRING]]

feature {NONE} -- Initialization

	make(fn: STRING ; ps: ARRAY[TUPLE[pn: STRING; ft: STRING]]rt: STRING)
			-- Initialization for `Current'.
		do
			create fname.make_from_string (fn)
			create array.make_from_array (ps)
			create rtype.make_empty
			rtype := rt
			create x.make
		end

	addx(s: STRING)
		do
			x.extend(s)
		end
end
