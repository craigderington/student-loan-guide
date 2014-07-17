

	<cfcomponent displayname="taskmanager">
	
		<cffunction name="init" access="public" output="false" returntype="taskmanager" hint="Returns an initialized task manager function.">		
			<!--- // return This reference. --->
			<cfreturn this />
		</cffunction>
		
		<cffunction name="gettask" access="remote" returntype="query" output="false" hint="I get the task detail">
			<cfargument name="taskid" default="#url.taskid#" type="any">
			<cfquery datasource="#application.dsn#" name="taskdetail">
				select t.taskid, t.taskuuid, t.mtaskid, t.leadid, t.userid, t.taskname, t.taskstatus, t.taskduedate, t.tasklastupdated,
				       t.tasklastupdated, t.tasklastupdatedby, t.taskcompleteddate, t.taskcompletedby, t.tasknotes, 
	                   mt.mtaskname, mt.mtaskdescr, mt.mtasktype
				  from tasks t, mtask mt
				 where t.mtaskid = mt.mtaskid
				   and t.taskuuid = <cfqueryparam value="#arguments.taskid#" cfsqltype="cf_sql_varchar" maxlength="35" />
			</cfquery>
			<cfreturn taskdetail>
		</cffunction>				
	
	
	</cfcomponent>