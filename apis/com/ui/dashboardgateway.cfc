

	<cfcomponent displayname="sldashboard">
	
		<cffunction name="init" access="public" output="false" returntype="sldashboard" hint="Returns an initialized student loan dashboard function.">		
			<!--- // return This reference. --->
			<cfreturn this />
		</cffunction>
	
		<cffunction name="getmydashboard" access="remote" output="false" hint="I get the user's dashboard data...">		
			<cfargument name="companyid" default="#session.companyid#" required="yes" type="numeric">
			<cfargument name="userid" default="#session.userid#" required="yes" type="numeric">
				<cfset mydashboard = "" />
				<cfquery datasource="#application.dsn#" name="mydashboard">					
					select companyid, companyname, dba,
							(select count(l.leadid) from leads l where l.leadconv = 0 and l.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" /> <cfif not isuserinrole( "admin" ) and not isuserinrole( "co-admin" )> and l.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" /></cfif>) as totalleads,
							(select count(l.leadid) from leads l where l.leadconv = 1 and l.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" /> <cfif not isuserinrole( "admin" ) and not isuserinrole( "co-admin" )> and l.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" /></cfif>) as totalclients,
							(select sum(slw.loanbalance) from slworksheet slw, leads l where slw.leadid = l.leadid and l.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" /> <cfif not isuserinrole( "admin" ) and not isuserinrole( "co-admin" )> and l.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" /></cfif>) as totaldebt,
							(select count(slw.worksheetid) from slworksheet slw, leads l where slw.leadid = l.leadid and l.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" /> <cfif not isuserinrole( "admin" ) and not isuserinrole( "co-admin" )> and l.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" /></cfif>) as totalloans,
							(select count(i.implementid) from implement i, leads l where i.leadid = l.leadid and l.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" /> and i.impcompleted = <cfqueryparam value="1" cfsqltype="cf_sql_bit" /><cfif not isuserinrole( "admin" ) and not isuserinrole( "co-admin" )> and l.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" /></cfif>) as totalplanscomp
					  from company co
					 where co.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />					 
				</cfquery>				
				<cfreturn mydashboard>		
		</cffunction>
		
		<cffunction name="getmydashboarduser" access="remote" output="false" hint="I get the user's dashboard data...">			
			<cfargument name="userid" type="numeric" required="yes" default="#session.userid#">
				<cfset mydashboarduser = "" />
				<cfquery datasource="#application.dsn#" name="mydashboarduser">					
					select u.firstname, u.lastname, u.lastlogindate, u.lastloginip, d.deptname
                      from users u, dept d
                     where u.deptid = d.deptid
                       and u.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />			 
				</cfquery>				
				<cfreturn mydashboarduser>		
		</cffunction>
		
		
		<cffunction name="gettaskmanager" access="remote" output="false" hint="I get the list of recent activity">			
			<cfargument name="companyid" default="#session.companyid#" required="yes" type="numeric">
			<cfargument name="userid" default="#session.userid#" required="no" type="numeric">
				<cfset taskmgr = "" />
				<cfquery datasource="#application.dsn#" name="taskmgr">
					select l.leadid, l.leaduuid, l.leadlast, l.leadfirst, count(t.taskid) as totaltaskspending
					  from leads l, tasks t
					 where l.leadid = t.leadid
					   and t.taskstatus <> <cfqueryparam value="Completed" cfsqltype="cf_sql_varchar" />
					   and t.taskcompleteddate is null
					   and l.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
						   <cfif isuserinrole( "counselor" ) or isuserinrole( "intake" )>
						   and l.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
						   </cfif>
				  group by l.leadid, l.leaduuid, l.leadlast, l.leadfirst
				  order by l.leadlast asc 
				</cfquery>			
				<cfreturn taskmgr>		
		</cffunction>
		
		
		<cffunction name="getrandomclients" access="remote" output="false" hint="I get a random list of 10 clients.">
			<cfargument name="companyid" default="#session.companyid#" required="yes" type="numeric">
			<cfargument name="userid" type="numeric" required="no" default="#session.userid#">
			<cfset dashboardclients = "" />
			<cfquery datasource="#application.dsn#" name="dashboardclients">
				select top 10 l.leadid, l.leaduuid, l.leadsourceid, l.leaddate, l.leadfirst, l.leadlast, ls.leadsource,
                       l.leadphonetype, l.leadphonenumber, l.leademail, sl.slenrollreturndate,
                       sls.firstname, sls.lastname, l.leadactive
                  from leads l, leadsource ls, slsummary sl, users sls
                 where l.leadsourceid = ls.leadsourceid
                   and l.leadid = sl.leadid
                   and sl.slsid = sls.userid
                   and l.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
                   and l.leadconv = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
                   and l.leadactive = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
				   <cfif not isuserinrole( "admin" ) and not isuserinrole( "co-admin" )>
				   and l.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
				   </cfif>
              order by rand((1000*l.leadID)*datepart(millisecond, getDate()))
			</cfquery>		
			<cfreturn dashboardclients >		
		</cffunction>


		<cffunction name="getnewassignments" access="public" output="false" hint="I get the list of new client assignments.">
			<cfargument name="userid" type="numeric" default="#session.userid#">
			<cfset var newassign = "" />
			<cfquery datasource="#application.dsn#" name="newassign">
				select la.leadassignid, la.leadassigndate, la.leadassignleadid, la.leadassignuserid, la.leadassignrole, la.leadassignaccept,
					   la.leadassignacceptdate, la.leadassigntransfer, la.leadassigntransfertoid,
					   l.leaduuid, l.leadfirst, l.leadlast
				  from leadassignments la, leads l
				 where la.leadassignleadid = l.leadid
				   and la.leadassignuserid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
				   and la.leadassignaccept = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />
				   and la.leadassignacceptdate is null
				   and l.leadactive = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
			</cfquery>
			<cfreturn newassign>
		</cffunction>



		
			
	</cfcomponent>