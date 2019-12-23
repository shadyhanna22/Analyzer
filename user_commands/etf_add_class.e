note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_ADD_CLASS
inherit
	ETF_ADD_CLASS_INTERFACE
create
	make
feature -- command
	add_class(cn: STRING)
		require else
			add_class_precond(cn)
    	do
			-- perform some update on the model state

			if model.setting then
				model.set_error ("An assignment instruction is currently being specified for routine "+model.set_command+" in class "+model.set_class)
			elseif model.check_class_name (cn) then
				model.set_error (cn+" is already an existing class name")
			else
				model.add_class(cn)
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
