



			<cfcomponent displayname="portaltasks">		
				<cffunction name="init" access="public" output="false" returntype="portaltasks" hint="Returns an initialized portal task management function.">		
					<!--- // return This reference. --->
					<cfreturn this />
				</cffunction>				
				<cffunction name="getportaltasklist" access="public" output="false" hint="I get the list of client portal tasks.">
					<cfset var portaltasklist = "" />
					<cfquery datasource="#application.dsn#" name="portaltasklist">
							select portaltaskid, portaltask
							  from portaltasks						  
						  order by portaltaskid asc
					</cfquery>
					<cfreturn portaltasklist>
				</cffunction>
				<cffunction name="getportaltaskdetail" access="public" output="false" hint="I get the portal tasks detail.">
					<cfargument name="taskid" type="numeric" required="yes" default="#url.taskid#">
					<cfset var portaltaskdetail = "" />
					<cfquery datasource="#application.dsn#" name="portaltaskdetail">
							select portaltaskid, portaltask
							  from portaltasks
							 where portaltaskid = <cfqueryparam value="#arguments.taskid#" cfsqltype="cf_sql_integer" />
					</cfquery>
					<cfreturn portaltaskdetail>
				</cffunction>
			</cfcomponent>