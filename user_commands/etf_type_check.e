note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_TYPE_CHECK
inherit
	ETF_TYPE_CHECK_INTERFACE
create
	make
feature -- command
	type_check
    	do
			-- perform some update on the model state
			if model.setting then
				model.set_error ("An assignment instruction is currently being specified for routine "+model.set_command+" in class "+model.set_class)
			else
				model.type_check
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
