note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MODEL

inherit
	ANY
		redefine
			out
		end

create {ETF_MODEL_ACCESS}
	make

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		do
			create er.make_empty
			create setter.make_empty
			create set_class.make_empty
			create set_command.make_empty
			create assignment.make_empty
			create java.make_empty
			create dub.make
			create nils.make
			create loc.make
			create {UNKNOWN} e_pointer.make
			create {ADDITION} c_pointer.make (e_pointer, e_pointer)
			root := e_pointer
			create containers.make
			classes := 0
			create cn_setting.make ("")
			create {COMMAND_HOLDER} fn_setting.make ("", <<["",""]>>)
		end

feature -- model attributes
	er, assignment, java, setter: STRING
	classes : INTEGER
	specifing, setting, printJava, tc : BOOLEAN
	loc : LINKED_LIST[CLASS_HOLDER]
	nils: LINKED_LIST[EXPERSSION]
	containers: LINKED_LIST[CONTAIN]
	dub: LINKED_LIST[STRING]
	set_class: STRING
	set_command: STRING
	root: EXPERSSION
	e_pointer: EXPERSSION
	c_pointer: CONTAIN
	fn_setting: HOLDER
	cn_setting: CLASS_HOLDER


feature -- helpers
	check_class_name(n: STRING) : BOOLEAN

		do
			Result := across 1 |..| classes is i some loc[i].name ~ n  end
		end
	check_f_name(cn: STRING; n: STRING) : BOOLEAN

		do
			Result := False
			across 1 |..| classes is i loop
				if cn ~ loc[i].name then
					if not loc[i].attributes.is_empty then
						Result := Result or across 1 |..| loc[i].attributes.count is j some loc[i].attributes[j].fname ~ n end
					end
					if not loc[i].commands.is_empty then
						Result := Result or across 1 |..| loc[i].commands.count is j some loc[i].commands[j].fname ~ n end
					end
					if not loc[i].queries.is_empty then
						Result := Result or across 1 |..| loc[i].queries.count is j some loc[i].queries[j].fname ~ n end
					end
				end
			end
		end

	check_fn_att(cn: STRING; fn: STRING) : BOOLEAN

		do
			Result := False
			across 1 |..| classes is i loop
				if cn ~ loc[i].name then
					if not loc[i].attributes.is_empty then
						Result := Result or across 1 |..| loc[i].attributes.count is j some loc[i].attributes[j].fname ~ fn end
					end
				end
			end
		end
	check_n_name(cn: STRING; n: STRING) : BOOLEAN

		do
			Result := False
			across 1 |..| classes is i loop
				if cn ~ loc[i].name then
					if not loc[i].commands.is_empty then
						Result := Result or across 1 |..| loc[i].commands.count is j some loc[i].commands[j].fname ~ n end
					end
					if not loc[i].queries.is_empty then
						Result := Result or across 1 |..| loc[i].queries.count is j some loc[i].queries[j].fname ~ n end
					end
				end
			end
		end

	noDublic(ps:ARRAY[TUPLE[pn: STRING;ft: STRING]]) : BOOLEAN

		local
			a: LINKED_LIST[STRING]
		do
			-- Result := across 1 |..| ps.count is i all across 1 |..| ps.count is j all i /= j implies ps[i].pn /~ ps[j].pn end end
			Result := True
			create a.make
			across 1 |..| ps.count is i loop
				if across a as k all k.item /~ ps[i].pn end then
					a.extend (ps[i].pn)
				else
					dub.extend (ps[i].pn)
					Result := False
				end
			end
		end

	haveDublic(a: LINKED_LIST[STRING]): STRING

		do
			create Result.make_empty
			across a as v loop
				if v.is_last then
					Result.append (v.item)
				else
					Result.append (v.item+", ")
				end
			end
			a.wipe_out
		end

	clash(ps:ARRAY[TUPLE[pn: STRING;ft: STRING]]) : BOOLEAN

		do
			across
				loc as i
			loop
				Result := across 1 |..| ps.count is j some i.item.name ~ ps[j].pn end
			end
			across 1 |..| ps.count is i loop
				if ps[i].pn ~ "INTEGER" or ps[i].pn ~ "BOOLEAN" then
					Result := Result or True
				end
			end
		end

	hasclash(ps:ARRAY[TUPLE[pn: STRING;ft: STRING]]): STRING

		local
			a: LINKED_LIST[STRING]
		do
			create Result.make_empty
			create a.make
			across 1 |..| ps.count is i loop
				across 1 |..| loc.count is j loop
					if ps[i].pn ~ loc[j].name or ps[i].pn ~ "INTEGER" or ps[i].pn ~ "BOOLEAN" then
						if across a as k all k.item /~ ps[i].pn and (k.item /~ "INTEGER" or k.item /~ "BOOLEAN") end then
							a.extend (ps[i].pn)
						end
					end
				end
			end
			across a as v loop
				if v.is_last then
					Result.append (v.item)
				else
					Result.append (v.item+", ")
				end
			end
		end

	are_p_type(ps:ARRAY[TUPLE[pn: STRING;ft: STRING]]) : BOOLEAN

		do
			Result := across loc as i some across 1 |..| ps.count is j some i.item.name ~ ps[j].ft end end
			across 1 |..| ps.count is i loop
				if ps[i].ft ~ "INTEGER" or ps[i].ft ~ "BOOLEAN" then
					Result := Result or True
				end
			end
			if ps.is_empty then
				Result := True
			end
		end

	is_p_type(ft: STRING) : BOOLEAN

		do
			across
				loc as i
			loop
				Result := Result or (i.item.name ~ ft or ft ~ "INTEGER" or ft ~ "BOOLEAN")
			end
		end

	p_type(ps:ARRAY[TUPLE[pn: STRING;ft: STRING]]): STRING

		local
			a: LINKED_LIST[STRING]
		do
			create Result.make_empty
			create a.make
			across 1 |..| ps.count is i loop
				across 1 |..| loc.count is j loop
					if not (ps[i].pn ~ loc[j].name or ps[i].ft ~ "INTEGER" or ps[i].ft ~ "BOOLEAN") then
						if across a as k all k.item /~ ps[i].ft and (k.item /~ "INTEGER" or k.item /~ "BOOLEAN") end then
							a.extend (ps[i].ft)
						end
					end
				end
			end
			across a as v loop
				if v.is_last then
					Result.append (v.item)
				else
					Result.append (v.item+", ")
				end
			end
		end

	set_error(str: STRING)

		do
			er := str
		end

	add_container(add: CONTAIN; c1: EXPERSSION; c2: EXPERSSION)
		local
			v: VISITOR
		do
			create {PRETTY_PRINTER} v.make
			add.accept (v)

			c1.set_parent (add)
			c2.set_parent (add)

			if  e_pointer.str ~ "?" then
				if e_pointer.parent /= Void then
					check attached e_pointer.parent as o then
						add.set_parent (o)
						c_pointer := o
						if c_pointer.left.str ~ "?" then
							c_pointer.set_left (add)
						else
							c_pointer.set_right (add)
						end
						c_pointer := add
						e_pointer := c_pointer.left
					end
				else
					c_pointer := add
					e_pointer := c_pointer.left
					root := c_pointer
				end
			end
			if nils.is_empty then
				nils.extend (c_pointer.right)
			else
				nils.put_front (c_pointer.right)
			end
		end
	add_constant(e: EXPERSSION)

		local
			new: UNKNOWN
		do
			create new.make
			if  e_pointer.str ~ "?" then
				if e_pointer.parent /= Void then
					check attached e_pointer.parent as o then
						e.set_parent (o)
						if o.left.str ~ "?" then
							o.set_left (e)
						else
							o.set_right (e)
						end

					end
					if not(nils.is_empty) and nils.first.parent /= Void then
						check attached nils.first.parent as n then
							new.set_parent (n)
							n.set_right (new)
							e_pointer := new
							nils.start
							nils.remove
						end
					else
						e_pointer := e
						check_tree
					end
				else
					e_pointer := e
					root := e_pointer
					check_tree
				end
			end
		end

	check_tree

		local
			v: PRETTY_PRINTER
		do
			if setting and nils.is_empty and e_pointer.str /~ "?" then
				setting := False
				create v.make
				root.accept (v)
				fn_setting.addx (setter+" = "+v.s)
				create {UNKNOWN} e_pointer.make
				create {ADDITION} c_pointer.make (e_pointer, e_pointer)
				root := e_pointer

			end
		end

	set_fcn(cn: STRING; n: STRING)

		do
			across 1 |..| classes is i loop
				if cn ~ loc[i].name then
				cn_setting := loc[i]
					across 1 |..| loc[i].commands.count is j loop
						if loc[i].commands[j].fname ~ n then
							fn_setting := loc[i].commands[j]
						end
					end
					across 1 |..| loc[i].queries.count is j loop
						if loc[i].queries[j].fname ~ n then
							fn_setting := loc[i].queries[j]
						end
					end
				end
			end
		end


feature -- model operations

	add_assignment_instruction(cn: STRING ; fn: STRING ; n: STRING)

		local
			v: VISITOR
		do
			create {PRETTY_PRINTER} v.make
			root.accept (v)
			setting := True
			set_class := cn
			set_command := fn
			setter := n
			set_fcn(cn, fn)
		end

	addition

		local
			add: CONTAIN
			c1, c2: EXPERSSION
		do
			create {UNKNOWN} c1.make
			create {S_UNKNOWN} c2.make
			create {ADDITION} add.make (c1, c2)
			add_container(add,c1,c2)
		end

	subtraction

		local
			add: CONTAIN
			c1, c2: EXPERSSION
		do
			create {UNKNOWN} c1.make
			create {S_UNKNOWN} c2.make
			create {SUBSTRACTION} add.make (c1, c2)
			add_container(add,c1,c2)
		end

	multiplication

		local
			add: CONTAIN
			c1, c2: EXPERSSION
		do
			create {UNKNOWN} c1.make
			create {S_UNKNOWN} c2.make
			create {MULTIPLICATION} add.make (c1, c2)
			add_container(add,c1,c2)
		end

	quotient

		local
			add: CONTAIN
			c1, c2: EXPERSSION
		do
			create {UNKNOWN} c1.make
			create {S_UNKNOWN} c2.make
			create {QUOTIENT} add.make (c1, c2)
			add_container(add,c1,c2)
		end
	modulo
		local
			add: CONTAIN
			c1, c2: EXPERSSION
		do
			create {UNKNOWN} c1.make
			create {S_UNKNOWN} c2.make
			create {MODULO} add.make (c1, c2)
			add_container(add,c1,c2)
		end

	conjunction

		local
			add: CONTAIN
			c1, c2: EXPERSSION
		do
			create {UNKNOWN} c1.make
			create {S_UNKNOWN} c2.make
			create {CONJUNCTION} add.make (c1, c2)
			add_container(add,c1,c2)
		end

	disjunction

		local
			add: CONTAIN
			c1, c2: EXPERSSION
		do
			create {UNKNOWN} c1.make
			create {S_UNKNOWN} c2.make
			create {DISJUNCTION} add.make (c1, c2)
			add_container(add,c1,c2)
		end

	equals

		local
			add: CONTAIN
			c1, c2: EXPERSSION
		do
			create {UNKNOWN} c1.make
			create {S_UNKNOWN} c2.make
			create {EQUALS} add.make (c1, c2)
			add_container(add,c1,c2)
		end

	greater_than

		local
			add: CONTAIN
			c1, c2: EXPERSSION
		do
			create {UNKNOWN} c1.make
			create {S_UNKNOWN} c2.make
			create {GREATER_THAN} add.make (c1, c2)
			add_container(add,c1,c2)
		end

	less_than

		local
			add: CONTAIN
			c1, c2: EXPERSSION
		do
			create {UNKNOWN} c1.make
			create {S_UNKNOWN} c2.make
			create {LESS_THAN} add.make (c1, c2)
			add_container(add,c1,c2)
		end

	int_value(c: INTEGER_32)

		local
			cc: EXPERSSION
		do
			create {CONSTANT} cc.make (c)
			add_constant (cc)
		end

	bool_value(c: BOOLEAN)

		local
			cc: EXPERSSION
		do
			create {BOOL_VALUE} cc.make (c)
			add_constant (cc)
		end

	add_call_chain(c: ARRAY[STRING])

		local
			cc: EXPERSSION
			cs: STRING
		do
			create cs.make_empty
			across c.lower |..| c.upper is l loop
				if l < c.upper then
					cs.append (c[l]+".")
				else
					cs.append (c[l])
				end
			end
			create {CALL_CHAIN} cc.make (cs)
			add_constant (cc)
		end

	add_attribute(cn: STRING ; fn: STRING ; ft: STRING)

		do
			across
				1 |..| loc.count is i
			loop
				if cn ~ loc[i].name then
					loc[i].add_attrib (cn, fn, ft)
				end
			end
		end



	add_class(cn: STRING)

		local
			oo : CLASS_HOLDER
		do
			specifing := True
			create oo.make (cn)
			loc.extend (oo)
			classes := classes + 1
		end

	add_command(cn: STRING ; fn: STRING ; ps: ARRAY[TUPLE[pn: STRING; ft: STRING]])

		do
			across
				1 |..| loc.count is i
			loop
				if cn ~ loc[i].name then
					loc[i].add_comm (cn, fn, ps)
				end
			end
		end

	add_query(cn: STRING ; fn: STRING ; ps: ARRAY[TUPLE[pn: STRING; pt: STRING]] ; rt: STRING)

		do
			across
				1 |..| loc.count is i
			loop
				if cn ~ loc[i].name then
					loc[i].add_query (cn, fn, ps, rt)
				end
			end
		end

	generate_java_code

		local
			v: PRETTY_PRINTER
			clean: BOOLEAN
		do
			if fn_setting.x.is_empty then
				create v.make
				root.accept (v)
				fn_setting.addx (setter+" = "+v.s)
				clean := True
			end
			java.wipe_out
			if classes > 0 and specifing then
				across 1|..| loc.count is i loop
					if i > 1 then
					java.append ("%N")
					end
				java.append ("  class " + loc[i].name + " {")
				java.append ("%N")
					if loc.at (i).attributes.count > 0 then
						across 1 |..| loc.at (i).attributes.count is att
						loop
							if (loc.at (i).attributes.at (att).ftype ~ "INTEGER") then java.append("    int " + loc.at (i).attributes.at (att).fname+";%N")
							elseif (loc.at (i).attributes.at (att).ftype ~ "BOOLEAN") then java.append("    bool " + loc.at (i).attributes.at (att).fname+";%N")
							else java.append("    "+loc.at (i).attributes.at (att).ftype +" "+ loc.at (i).attributes.at (att).fname+";%N")
							end
						end
					end
					if loc.at(i).commands.count > 0 then
						across 1 |..| loc.at(i).commands.count is com
						loop
							java.append ("    void " + loc.at(i).commands.at (com).fname)

							java.append ("(")
							if not loc.at (i).commands.at (com).array.is_empty then
								across 1 |..| loc.at (i).commands.at (com).array.count is ty
								loop
									if ty < loc.at (i).commands.at (com).array.count then
										if loc.at (i).commands.at(com).array[ty].ft ~ "INTEGER" then
											 java.append ("int" + " " + loc.at (i).commands.at(com).array[ty].pn+ ", ")
										elseif loc.at (i).commands.at(com).array[ty].ft ~ "BOOLEAN" then
										 	java.append ("bool" + " " + loc.at (i).commands.at(com).array[ty].pn+ ", ")
										else
											java.append (loc.at (i).commands.at(com).array[ty].ft+ " " + loc.at (i).commands.at(com).array[ty].pn + ", ")
										end
									else
									 	if loc.at (i).commands.at(com).array[ty].ft ~ "INTEGER" then
									 		java.append ("int" + " " + loc.at (i).commands.at(com).array[ty].pn)
									 	elseif loc.at (i).commands.at(com).array[ty].ft ~ "BOOLEAN" then
									 		java.append ("bool" + " " + loc.at (i).commands.at(com).array[ty].pn)
									 	else
											java.append (loc.at (i).commands.at(com).array[ty].ft+ " " + loc.at (i).commands.at(com).array[ty].pn)
									 	end
									end
								end
							end
							java.append (") {%N")
							across loc.at(i).commands.at (com).x as cx loop
								java.append ("      " + cx.item+";")
								java.append ("%N")
							end
							java.append ("    }")
							java.append ("%N")
						end
					end
					if  loc.at(i).queries.count > 0 then
						across 1 |..| loc.at(i).queries.count is que
						loop
							if loc.at (i).queries.at(que).rtype ~ "INTEGER" then
								java.append ("    int " + loc.at(i).queries.at (que).fname)
							elseif loc.at (i).queries.at(que).rtype ~ "BOOLEAN" then
								java.append ("    bool " + loc.at(i).queries.at (que).fname)
							else
								java.append ("    "+loc.at (i).queries.at(que).rtype+" " + loc.at(i).queries.at (que).fname)
							end
							java.append ("(")
							if not loc.at (i).queries.at (que).array.is_empty then
								across 1 |..| loc.at (i).queries.at (que).array.count is ty
								loop
									if ty < loc.at (i).queries.at (que).array.count then
										if loc.at (i).queries.at(que).array[ty].ft ~ "INTEGER" then
											 java.append ("int" + " " + loc.at (i).commands.at(que).array[ty].pn+ ", ")
										elseif loc.at (i).queries.at(que).array[ty].ft ~ "BOOLEAN" then
										 	java.append ("bool" + " " + loc.at (i).commands.at(que).array[ty].pn+ ", ")
										else
											java.append (loc.at (i).queries.at(que).array[ty].ft+ " " + loc.at (i).queries.at(que).array[ty].pn + ", ")
										end
									else
									 	if loc.at (i).queries.at(que).array[ty].ft ~ "INTEGER" then
									 		java.append ("int" + " " + loc.at (i).queries.at(que).array[ty].pn)
									 	elseif loc.at (i).queries.at(que).array[ty].ft ~ "BOOLEAN" then
									 		java.append ("bool" + " " + loc.at (i).queries.at(que).array[ty].pn)
									 	else
											java.append (loc.at (i).queries.at(que).array[ty].ft+ " " + loc.at (i).queries.at(que).array[ty].pn)
									 	end
									end
								end
							end
							java.append (") {%N")
							if loc.at (i).queries.at(que).rtype ~ "INTEGER" then
								java.append ("      int Result = 0;%N")
							elseif loc.at (i).queries.at(que).rtype ~ "BOOLEAN" then
								java.append ("      bool Result = false;%N")
							else
								java.append ("      "+loc.at (i).queries.at(que).rtype+" Result = null;%N")
							end
							across loc.at(i).queries.at (que).x as qx loop
								java.append ("      " + qx.item+";")
								java.append ("%N")
							end
							java.append ("      return Result;%N")
							java.append ("    }")
							java.append ("%N")
						end
					end
					java.append ("  }")
				end
			end
			printJava := True
			if clean then
				clean := False
				fn_setting.x.go_i_th (fn_setting.x.count)
				fn_setting.x.remove
			end
		end

	logical_negation

		do

		end

	numerical_negation

		do

		end

	type_check

		do
			tc:=True
		end

	reset
			-- Reset model state.
		do
			make
		end

feature -- queries
	out : STRING

		local
			p: PRETTY_PRINTER
		do
		create Result.make_from_string ("")
			if tc then
				across 1 |..| loc.count is jj loop
					Result.append("  class "+loc.at (jj).name+" is type-correct.")
					if jj < loc.count then
						Result.append("%N")
					end
				end
			else

			if not printJava then
				Result.append ("  Status: ")
				if not er.is_empty then
					Result.append("Error (")
					Result.append(er)
					Result.append(").")
					er.wipe_out
				else
					Result.append ("OK.")
				end
				Result.append ("%N")
				Result.append ("  Number of classes being specified: " + classes.out)

				if classes > 0 and specifing then
					across
						1 |..| loc.count is i
					loop
						--                    get the name of class from loc array
						Result.append ("%N")
						Result.append ("    "+loc.at (i).name+"%N")
						Result.append ("      Number of attributes: "+loc.at (i).attributes.count.out+"%N")
						-- check if current class has attributes
						if loc.at (i).attributes.count > 0 then
							across
								1 |..| loc.at (i).attributes.count is i_a
							loop
								--                            gets the name of that attribute
								Result.append ("        + " + loc.at (i).attributes.at (i_a).fname +": " + loc.at (i).attributes.at (i_a).ftype + "%N")
							end
						end

						Result.append ("      Number of queries: "+loc.at (i).queries.count.out+"%N")
						-- check queries
						if loc.at (i).queries.count > 0 then
							across
								1 |..| loc.at (i).queries.count is i_q
							loop
								Result.append ("        + " + loc.at (i).queries.at (i_q).fname)
								if not loc.at (i).queries.at (i_q).array.is_empty then
									Result.append ("(")
									across 1 |..| loc.at (i).queries.at (i_q).array.count is ty
									loop
										if ty < loc.at (i).queries.at (i_q).array.count then
											Result.append (loc.at (i).queries.at (i_q).array[ty].ft+ ", ")
										else
											Result.append (loc.at (i).queries.at (i_q).array[ty].ft+ ")")
										end
									end
								end
								Result.append (": "+loc.at (i).queries.at (i_q).rtype + "%N")
							end
						end
						Result.append ("      Number of commands: "+loc.at (i).commands.count.out)
						if loc.at (i).commands.count > 0 then
							across
								1 |..| loc.at (i).commands.count is i_c
							loop
								Result.append ("%N")
								Result.append ("        + " + loc.at (i).commands.at (i_c).fname)
								if not loc.at (i).commands.at (i_c).array.is_empty then
									Result.append ("(")
									across 1 |..| loc.at (i).commands.at(i_c).array.count is ty
									loop
										if ty < loc.at (i).commands.at (i_c).array.count then
											Result.append (loc.at (i).commands.at (i_c).array[ty].ft+ ", ")
										else
											Result.append (loc.at (i).commands.at (i_c).array[ty].ft+ ")")
										end
									end
								end
							end
						end
					end
				end
				if setting then
					Result.append("%N")
					create p.make
					root.accept (p)
					Result.append ("  Routine currently being implemented: {"+set_class+"}."+set_command+"%N")
					Result.append ("  Assignment being specified: "+setter+" := "+p.s)
				end
			else
				Result.append (java)
				printJava := False
			end
			end
			tc := False
		end

end




