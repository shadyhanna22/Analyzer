note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_ADD_ATTRIBUTE
inherit
	ETF_ADD_ATTRIBUTE_INTERFACE
create
	make
feature -- command
	add_attribute(cn: STRING ; fn: STRING ; ft: STRING)
		require else
			add_attribute_precond(cn, fn, ft)
    	do
			-- perform some update on the model state
			if model.setting then
				model.set_error ("An assignment instruction is currently being specified for routine "+model.set_command+" in class "+model.set_class)
			elseif not model.check_class_name (cn)  then
				model.set_error (cn + " is not an existing class name")
			elseif model.check_f_name(cn,fn) then
				model.set_error (fn +" is already an existing feature name in class "+ cn)
			elseif not model.is_p_type (ft) then
				model.set_error ("Return type does not refer to a primitive type or an existing class: "+ ft)
			else
				model.add_attribute(cn, fn, ft)
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
