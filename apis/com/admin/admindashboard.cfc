


		<!--- -// admin dashboard --->
		<cfcomponent displayname="admindashboard">
		
			<cffunction name="init" access="public" output="false" returntype="admindashboard" hint="I create an initialized admin dashboard object.">
				<cfreturn this >
			</cffunction>
		
			<cffunction name="getadmindashboard" access="public" output="false" hint="I get the admin dashboard.">			
				<cfset var admindashboard = "" />		
				<cfquery datasource="#application.dsn#" name="admindashboard">
					select (select count( c.companyid )
							  from company c ) as totalcompanies,

						   (select count( ls.leadsourceid )
							  from leadsource ls ) as totalleadsources,

						   (select count( n.nslid )
							  from nslds n ) as totalnslds,

						   (select count( t.taskid )
							  from tasks t ) as totaltasks,

						   (select count( l.leadid )
							  from leads l
							  where l.leadactive = 1 ) as totalclients,

						   (select count( sl.worksheetid )
							  from slworksheet sl ) as totalworksheets,

						   (select count( s.solutionid )
							  from solution s ) as totalsolutions,

						   (select count( i.implementid )
							  from implement i ) as totalimpplans
				</cfquery>			
				<cfreturn admindashboard>
			</cffunction>
		
		
		
			<cffunction name="getreportdashboard" access="public" output="false" hint="I get the report count dashboard.">			
				<cfargument name="companyid" type="numeric" required="yes" default="#session.companyid#">
				<cfargument name="userid" type="numeric" required="no" default="#session.userid#">
				<cfset var admindashboard = "" />		
				<cfquery datasource="#application.dsn#" name="reportdashboard">
					 select

						   (select count( ls.leadsourceid )
							  from leadsource ls
							  where companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" /> 
							  ) as totalleadsources,

						   (select count( n.nslid )
							  from nslds n, leads l
							  where n.leadid = l.leadid 
							  and l.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
							  <cfif not isuserinrole( "admin" ) and not isuserinrole( "co-admin" )>
							  and l.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
							  </cfif>
							  ) as totalnslds,

						   (select count( t.taskid )
							  from tasks t, leads l
							  where t.leadid = l.leadid 
							  and l.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
							  <cfif not isuserinrole( "admin" ) and not isuserinrole( "co-admin" )>
							  and l.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
							  </cfif>
							  ) as totaltasks,
							
							(select count( e.esid )
							  from esign e, leads l
							  where e.leadid = l.leadid 
							  and l.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
							  <cfif not isuserinrole( "admin" ) and not isuserinrole( "co-admin" )>
							  and l.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
							  </cfif>
							  ) as totalesign,

						   (select count( l.leadid )
							  from leads l
							  where l.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" /> 
							  and l.leadactive = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
							  <cfif not isuserinrole( "admin" ) and not isuserinrole( "co-admin" )>
							  and l.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
							  </cfif>
							  ) as totalclients,

						   (select count( sl.worksheetid )
							  from slworksheet sl, leads l
							  where sl.leadid = l.leadid 
							  and l.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
							  <cfif not isuserinrole( "admin" ) and not isuserinrole( "co-admin" )>
							  and l.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
							  </cfif>
							  ) as totalworksheets,

						   (select count( s.solutionid )
							  from solution s, leads l
							  where s.leadid = l.leadid 
							  and l.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
							  <cfif not isuserinrole( "admin" ) and not isuserinrole( "co-admin" )>
							  and l.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
							  </cfif>
							  ) as totalsolutions,

						   (select count( i.implementid )
							  from implement i, leads l
							  where i.leadid = l.leadid 
							  and l.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />							  
							  <cfif not isuserinrole( "admin" ) and not isuserinrole( "co-admin" )>
							  and l.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
							  </cfif>						  
							  ) as totalimpplans
				</cfquery>			
				<cfreturn reportdashboard>
			</cffunction>
		
		
		
		</cfcomponent>