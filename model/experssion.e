note
	description: "Summary description for {EXPERSSION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EXPERSSION

feature

	is_comp: BOOLEAN
	parent: detachable CONTAIN

feature

	accept(v:VISITOR) deferred end

feature

	str: STRING deferred end
	set_parent(p:CONTAIN) deferred end


end
