

		<cfcomponent displayname="presentationgateway">
			
			<cffunction name="init" access="public" output="false" returntype="clarifyingpoints" hint="Returns an initialized action plan object function.">		
				<!--- // return this reference. --->
				<cfreturn this />
			</cffunction>
			
			<cffunction name="getplanlist" access="public" output="false" returntype="query" hint="I get the list of action plan items for the presentation.">
				<cfargument name="companyid" default="#session.companyid#" required="yes" type="numeric">
					<cfset var planlist = "" />				
						<cfquery datasource="#application.dsn#" name="planlist">
								select actionplanid, actionplanuuid, companyid, actionplanheader, actionplanbodya, actionplanbodyb, 
									   actionplanbodyc, actionplanfooter, optiontree, optiondescr, optionsubcat
								  from actionplan
								 where companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
							  order by actionplanid asc
						</cfquery>
				<cfreturn planlist >
			</cffunction>
			
			<cffunction name="getplandetail" access="public" output="false" returntype="query" hint="I get the action plan detail for the solution presentation.">
				<cfargument name="planid" default="#url.planid#" required="yes" type="uuid">
					<cfset var plandetail = "" />				
						<cfquery datasource="#application.dsn#" name="plandetail">
							select actionplanid, actionplanuuid, companyid, actionplanheader, actionplanbodya, actionplanbodyb, 
								   actionplanbodyc, actionplanfooter, optiontree, optiondescr, optionsubcat
							  from actionplan
							 where actionplanuuid = <cfqueryparam value="#arguments.planid#" cfsqltype="cf_sql_varchar" maxlength="35" />				  
						</cfquery>
				<cfreturn plandetail >
			</cffunction>
			
			<cffunction name="getapmanual" access="public" output="false" returntype="query" hint="I get the advisory manual for the solution presentation and action plan.">
				<cfargument name="companyid" default="#session.companyid#" required="yes" type="numeric">
					<cfset var apmanual = "" />
						<cfquery datasource="#application.dsn#" name="apmanual">
								select actionplanid, actionplanuuid, companyid, actionplanheader, actionplanbodya, actionplanbodyb, 
									   actionplanbodyc, actionplanfooter, optiontree, optiondescr, optionsubcat
								  from actionplan
								 where companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
								   and optiontree = <cfqueryparam value="Advisory" cfsqltype="cf_sql_varchar" />
								   and optiondescr = <cfqueryparam value="Manual" cfsqltype="cf_sql_integer" />
							  order by actionplanid asc 
						</cfquery>
				<cfreturn apmanual >
			</cffunction>
			
			<cffunction name="getactionplan" access="public" output="false" returntype="query" hint="I get the action plan items for the client solution presentation.">
				<cfargument name="treename" default="FFEL" type="any" required="yes">
				<cfargument name="option" default="Cancellation" type="any" required="yes">
				<cfargument name="subcat" default="Death" type="any" required="yes">				
					<cfset var actionplan = "" />				
						<cfquery datasource="#application.dsn#" name="actionplan">
								select actionplanid, actionplanheader, actionplanbodya, optiontree, optiondescr, optionsubcat
								  from actionplan
								 where optiontree = <cfqueryparam value="#arguments.treename#" cfsqltype="cf_sql_varchar" />
								   and optiondescr = <cfqueryparam value="#arguments.option#" cfsqltype="cf_sql_varchar" />
								   and optionsubcat = <cfqueryparam value="#arguments.subcat#" cfsqltype="cf_sql_varchar" />
							  order by actionplanid asc
						</cfquery>
				<cfreturn actionplan >				
			</cffunction>
		
		
		</cfcomponent>