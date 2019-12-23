note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_ADD_ASSIGNMENT_INSTRUCTION
inherit
	ETF_ADD_ASSIGNMENT_INSTRUCTION_INTERFACE
create
	make
feature -- command
	add_assignment_instruction(cn: STRING ; fn: STRING ; n: STRING)
		require else
			add_assignment_instruction_precond(cn, fn, n)
    	do
			-- perform some update on the model state
			if model.setting then
				model.set_error ("An assignment instruction is currently being specified for routine "+model.set_command+" in class "+model.set_class)
			elseif not model.check_class_name (cn)  then
				model.set_error (cn + " is not an existing class name")
			elseif model.check_n_name(cn,n) then
				model.set_error (n +" is already an existing feature name in class "+ cn)
			elseif not model.check_f_name(cn,fn) then
				model.set_error (fn +" is not an existing feature name in class "+ cn)
			elseif model.check_fn_att(cn,fn) then
				model.set_error ("Attribute "+fn+" in class "+cn+" cannot be specified with an implementation")
			else
				model.add_assignment_instruction(cn, fn, n)
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
