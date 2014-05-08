


		<cfcomponent displayname="taskautomation">
		
			<cffunction name="init" access="public" output="false" returntype="taskautomation" hint="Returns an initialized task automation function.">		
				<!--- // return This reference. --->
				<cfreturn this />
			</cffunction>
		
			
			<cffunction name="marktaskcompleted" access="remote" output="false" hint="I update the tasks status and task dates.">
				<cfargument name="taskref" default="none" type="any" required="yes">
				<cfargument name="leadid" default="#session.leadid#" type="numeric" required="yes">
				<cfset var taskmsg = "" />
				<cfset today = #CreateODBCDateTime(now())# />
					
					<!--- // get the correct task from the master task table by task reference name --->
					<cfquery datasource="#application.dsn#" name="gettaskfromref">
						select mtaskid
						  from mtask
						 where mtaskref = <cfqueryparam value="#arguments.taskref#" cfsqltype="cf_sql_varchar" />					
					</cfquery>
					
					<!--- // get the correct task from lead task table and check to see if the lead task has not been completed --->
					<cfquery datasource="#application.dsn#" name="checkleadtask">
						select taskstatus, taskcompleteddate
						  from tasks
						 where mtaskid = <cfqueryparam value="#gettaskfromref.mtaskid#" cfsqltype="cf_sql_varchar" />
						   and leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					</cfquery>					
					
					<!--- // check the task record, then check the task status --->
					<cfif gettaskfromref.recordcount eq 1> 
						
						<cfif trim( checkleadtask.taskstatus ) is not "completed" and checkleadtask.taskcompleteddate is "">
						
							<cfquery datasource="#application.dsn#" name="savetaskstat">
								update tasks
								   set taskstatus = <cfqueryparam value="Completed" cfsqltype="cf_sql_varchar" />,
									   taskcompleteddate = <cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
									   tasklastupdated = <cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
									   taskcompletedby = <cfqueryparam value="#session.username#" cfsqltype="cf_sql_varchar" />
								 where mtaskid = <cfqueryparam value="#gettaskfromref.mtaskid#" cfsqltype="cf_sql_integer" />
								   and leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
							</cfquery>
						
							<!--- // set the task broadcast message --->
							<cfset taskmsg = "The task status was updated successfully..." />
							<cfreturn taskmsg />
						
						<cfelse>
						
							<!--- // set the task broadcast message --->
							<cfset taskmsg = "Task has already been marked completed..." />
							<cfreturn taskmsg />
							
						</cfif>
					
					<cfelse>
					
						<!--- // set the task broadcast message --->
						<cfset taskmsg = "Could not update task..." />
						<cfreturn taskmsg />
					
					</cfif>
			
			
			</cffunction>
		
		
		</cfcomponent>