note
	description: "Summary description for {CLASS_HOLDER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CLASS_HOLDER

create
	make
feature
	name: STRING
	attributes: LINKED_LIST[ATTRIBUTE_HOLDER]
    queries: LINKED_LIST[QUERY_HOLDER]
   	commands: LINKED_LIST[COMMAND_HOLDER]

feature  -- constractor

	make(n: STRING)

		do
			create name.make_from_string (n)
			create attributes.make
			create queries.make
			create commands.make
		end



feature

	add_comm(cn: STRING ; fn: STRING ; ps: ARRAY[TUPLE[pn: STRING; ft: STRING]])

		local
			cc: COMMAND_HOLDER
		do
			if name ~ cn then
				create cc.make(fn, ps)
				commands.extend (cc)
			end
		end

	add_attrib(cn: STRING ; fn: STRING ; ft: STRING)

		local
			cc: ATTRIBUTE_HOLDER
		do
			if name ~ cn then
				create cc.make(fn, ft)
				attributes.extend (cc)
			end
		end

	add_query(cn: STRING ; fn: STRING ; ps: ARRAY[TUPLE[pn: STRING; ft: STRING]]; rt: STRING)

		local
			cc: QUERY_HOLDER
		do
			if name ~ cn then
				create cc.make(fn, ps, rt)
				queries.extend (cc)
			end
		end

end
