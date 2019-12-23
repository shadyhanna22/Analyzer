note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_ADD_COMMAND
inherit
	ETF_ADD_COMMAND_INTERFACE
create
	make
feature -- command
	add_command(cn: STRING ; fn: STRING ; ps: ARRAY[TUPLE[pn: STRING; ft: STRING]])
		require else
			add_command_precond(cn, fn, ps)
    	do
			-- perform some update on the model state
			if model.setting then
				model.set_error ("An assignment instruction is currently being specified for routine "+model.set_command+" in class "+model.set_class)
			elseif not model.check_class_name (cn)  then
				model.set_error (cn + " is not an existing class name")
			elseif model.check_f_name(cn,fn) then
				model.set_error (fn +" is already an existing feature name in class "+ cn)
			elseif model.clash(ps) then
				model.set_error ("Parameter names clash with existing classes: "+ model.hasclash (ps))
			elseif not model.nodublic (ps) then
				model.set_error ("Duplicated parameter names: " + model.havedublic (model.dub))
			elseif not model.are_p_type (ps) then
				model.set_error ("Parameter types do not refer to primitive types or existing classes: "+ model.p_type (ps))
			else
				model.add_command(cn, fn, ps)
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
