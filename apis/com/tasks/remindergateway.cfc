


		<cfcomponent displayname="remindergateway">
			
			<cffunction name="init" access="public" output="false" returntype="remindergateway" hint="Returns an initialized task reminder function.">		
				<!--- // return This reference. --->
				<cfreturn this />
			</cffunction>
			
			
			<cffunction name="getreminders" access="public" output="false" returntype="query" hint="I get the list of task reminders.">
				<cfargument name="userid" default="#session.userid#" type="numeric" required="yes">				
				<cfset var reminderlist = "" />				
				<cfquery datasource="#application.dsn#" name="reminderlist">
					select tr.reminderid, tr.taskuuid, tr.reminderdate, tr.remindertime, tr.alerttype, tr.alertdeltatype,
					       tr.alertdeltanum, tr.alertsent, t.taskid, t.leadid, t.taskname, t.taskstatus, t.taskduedate,
						   t.tasknotes, l.leadfirst, l.leadlast, mt.mtaskname
					  from taskreminders tr, tasks t, mtask mt, leads l
					 where tr.taskuuid = t.taskuuid
					   and t.leadid = l.leadid
					   and t.mtaskid = mt.mtaskid
					   and t.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
					   and t.taskstatus <> <cfqueryparam value="Completed" cfsqltype="cf_sql_varchar" />
				  order by t.leadid
				</cfquery>
				<cfreturn reminderlist >
			</cffunction>
			
			
			<cffunction name="getreminder" access="public" output="false" returntype="query" hint="I get the list of task reminders.">
				<cfargument name="taskid" default="#url.taskid#" type="uuid" required="yes">				
				<cfset var rdetail = "" />				
				<cfquery datasource="#application.dsn#" name="rdetail">
					select tr.reminderid, tr.taskuuid, tr.reminderdate, tr.remindertime, tr.alerttype, tr.alertdeltatype,
					       tr.alertdeltanum, tr.alertsent, t.taskid, t.leadid, t.taskname, t.taskstatus, t.taskduedate,
						   t.tasknotes, l.leadfirst, l.leadlast
					  from taskreminders tr, tasks t, leads l
					 where tr.taskuuid = t.taskuuid
					   and t.leadid = l.leadid
					   and t.taskuuid = <cfqueryparam value="#arguments.taskid#" cfsqltype="cf_sql_varchar" maxlength="35" />				   
				</cfquery>
				<cfreturn rdetail>
			</cffunction>
			
			
			<cffunction name="getuserreminders" access="public" output="false" returntype="query" hint="I get the list of user reminders.">
				<cfargument name="userid" default="#session.userid#" type="numeric" required="yes">				
				<cfset var userreminderlist = "" />				
				<cfquery datasource="#application.dsn#" name="userreminderlist">
					select reminderuuid, userid, leadid, dateadded, reminderdate, remindertime, reminderampm,
					       remindertext, alerttype, alertdeltatype, alertdeltanum, alertsent
					  from userreminders
					 where userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
					order by reminderdate, remindertime asc
				</cfquery>
				<cfreturn userreminderlist>
			</cffunction>
			
			
			<cffunction name="getuserreminderdetail" access="public" output="false" returntype="query" hint="I get the user reminder detail.">
				<cfargument name="reminderid" default="#url.rmid#" type="uuid" required="yes">				
				<cfset var userreminderdetail = "" />				
				<cfquery datasource="#application.dsn#" name="userreminderdetail">
					select reminderuuid, userid, leadid, dateadded, reminderdate, remindertime, reminderampm,
					       remindertext, alerttype, alertdeltatype, alertdeltanum, alertsent
					  from userreminders
					 where reminderuuid = <cfqueryparam value="#arguments.reminderid#" cfsqltype="cf_sql_varchar" maxlength="35" />
					   and showreminder = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
				</cfquery>
				<cfreturn userreminderdetail>
			</cffunction>
					
		</cfcomponent>