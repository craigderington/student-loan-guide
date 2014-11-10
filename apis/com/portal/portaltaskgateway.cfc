


				<cfcomponent displayname="portaltaskgateway">

					<cffunction name="init" access="public" output="false" returntype="portaltaskgateway" hint="I create an initialized instance of the client portal task gateway object.">				
						<cfreturn this >			
					</cffunction>


						<cffunction name="getportaltasklist" access="public" output="false" returntype="query" hint="I get the client portal task list and task status.">
							<cfargument name="leadid" type="numeric" default="#session.leadid#">
							<cfset var portaltasklist = "" />
							<cfquery datasource="#application.dsn#" name="portaltasklist">
								select pt.portaltask, lpt.portaltaskcomp, lpt.portaltaskcompdate
								  from portaltasks pt, leadportaltasks lpt
								 where pt.portaltaskid = lpt.portaltaskid
								   and lpt.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
									<cfif session.companyid eq 454>
										and pt.portaltaskid <> <cfqueryparam value="1412" cfsqltype="cf_sql_integer" />										
									</cfif>
							  order by lpt.leadportaltaskid asc
							</cfquery>
							<cfreturn portaltasklist >
						</cffunction>	
					
					
						<cffunction name="markportaltaskcompleted" access="remote" output="false" hint="I update the portal tasks completed status and task dates.">
							<cfargument name="portaltaskid" default="1408" type="numeric" required="yes">
							<cfargument name="leadid" default="#session.leadid#" type="numeric" required="yes">
							<cfset var taskstatusmsg = "" />
							<cfset today = #CreateODBCDateTime(now())# />					
							
							<!--- // get the correct task from portal task table and check to see if the portal task has not been completed --->
							<cfquery datasource="#application.dsn#" name="checkportaltask">
								select leadportaltaskid, leadid, portaltaskid, portaltaskcomp, portaltaskcompdate
								  from leadportaltasks
								 where portaltaskid = <cfqueryparam value="#arguments.portaltaskid#" cfsqltype="cf_sql_integer" />
								   and leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
							</cfquery>					
							
							<!--- // check the task record, then check the task status --->
							<cfif checkportaltask.recordcount eq 1>
								
								<cfif checkportaltask.portaltaskcomp eq 0 and checkportaltask.portaltaskcompdate is "">
								
									<cfquery datasource="#application.dsn#" name="saveportaltaskstatus">
										update leadportaltasks
										   set portaltaskcomp = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />,
											   portaltaskcompdate = <cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />									   
										 where leadportaltaskid = <cfqueryparam value="#checkportaltask.leadportaltaskid#" cfsqltype="cf_sql_integer" />
									</cfquery>
								
									<!--- // set the task broadcast message --->
									<cfset taskstatusmsg = "The task status was updated successfully..." />
									<cfreturn taskstatusmsg />
								
								<cfelse>
								
									<!--- // set the task broadcast message --->
									<cfset taskstatusmsg = "Task has already been marked completed..." />
									<cfreturn taskstatusmsg />
									
								</cfif>
							
							<cfelse>
							
								<!--- // set the task broadcast message --->
								<cfset taskstatusmsg = "Could not update task..." />
								<cfreturn taskstatusmsg />
							
							</cfif>
					
					
						</cffunction>				
						
				
				</cfcomponent>