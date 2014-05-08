


	<cfcomponent displayname="portalgateway">

		<cffunction name="init" access="public" output="false" returntype="portalgateway" hint="I create an initialized instance of the client portal gateway object.">				
			<cfreturn this >			
		</cffunction>


		<cffunction name="getportaldashboard" access="public" output="false" returntype="query" hint="I get the client portal dashboard.">
			<cfargument name="leadid" type="numeric" default="#session.leadid#">
			<cfset var cdashboard = "" />
			<cfquery datasource="#application.dsn#" name="cdashboard">
				select leadid,
				       (select sum(slw.loanbalance) from slworksheet slw, leads l where slw.leadid = l.leadid and l.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />) as totaldebt,
					   (select count(slw.worksheetid) from slworksheet slw, leads l where slw.leadid = l.leadid and l.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />) as totalloans				  
				  from leads
				 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
			</cfquery>
			<cfreturn cdashboard >
		</cffunction>
		
		<cffunction name="getclienttasks" output="false" access="remote" hint="I get the list of tasks for the client task checklist.">			
			<cfargument name="leadid" required="yes" default="#session.leadid#" type="numeric">			
			<cfset var tasklist = "" />				
				<cfquery datasource="#application.dsn#" name="tasklist">
					select t.taskid, t.taskuuid, mt.mtaskid, mt.mtasktype, mt.mtaskname, mt.mtaskdescr, t.userid, t.taskname, t.taskstatus,
					       t.tasklastupdated, t.tasklastupdatedby, t.taskduedate, t.taskcompleteddate, t.taskcompletedby, t.tasknotes
					  from tasks t, mtask mt
					 where t.mtaskid = mt.mtaskid
					   and t.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_varchar" />
					   and mt.mtasktype = <cfqueryparam value="N" cfsqltype="cf_sql_char" />
					   and mt.mtaskid <> <cfqueryparam value="9905" cfsqltype="cf_sql_integer">
				  order by mt.mtasktype, mt.mtaskorder asc
				</cfquery>				
			<cfreturn tasklist>			
		</cffunction>
		
		<cffunction name="getportalcategories" output="false" access="public" hint="I get the list of client portal instruction categories.">					
			<cfset var instructcategories = "" />				
				<cfquery datasource="#application.dsn#" name="instructcategories">
					select distinct( instructcategory ), instructorder
					  from portalinstructions
				  order by instructorder asc
				</cfquery>				
			<cfreturn instructcategories>			
		</cffunction>
		
		
		<cffunction name="getportalinstructions" output="false" access="public" hint="I get the client portal instructions content by category if necessary.">			
			<cfargument name="icat" required="no" type="any">			
			<cfset var portalinstructcontent = "" />				
				<cfquery datasource="#application.dsn#" name="portalinstructcontent">
					select instructtext, instructcategory
					  from portalinstructions
					  <cfif structkeyexists( arguments, "icat" ) and arguments.icat neq 1>
						where instructcategory = <cfqueryparam value="#arguments.icat#" cfsqltype="cf_sql_varchar" />
					  <cfelse>
					    where instructorder = <cfqueryparam value="1" cfsqltype="cf_sql_numeric" />
					  </cfif>
				</cfquery>				
			<cfreturn portalinstructcontent>			
		</cffunction>
		
		<cffunction name="getadvisorteam" access="public" output="false" hint="I get the advisor team for the portal homepage.">
			<cfargument name="leadid" type="numeric" required="yes" default="#session.leadid#">
			<cfset var advisorteam = "" />
			<cfquery datasource="#application.dsn#" name="advisorteam">
				select l.leadid, u.firstname + ' ' + u.lastname as enrollmentcounselor,
						
						(select u.firstname + ' ' + u.lastname as intakeadvisor
						   from leadassignments la, leads l, users u
						   where la.leadassignleadid = l.leadid
						   and la.leadassignuserid = u.userid
						   and la.leadassignrole = 'intake'
						   and la.leadassignleadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />) as intakeadvisor,
						
						(select u.firstname + ' ' + u.lastname as intakeadvisor
						   from leadassignments la, leads l, users u
						   where la.leadassignleadid = l.leadid
						   and la.leadassignuserid = u.userid
						   and la.leadassignrole = 'sls'
						   and la.leadassignleadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />) as slsadvisor
						   
						from leads l, users u
						where l.userid = u.userid
						and l.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
			</cfquery>
			<cfreturn advisorteam>
		</cffunction>
		
		
	</cfcomponent>