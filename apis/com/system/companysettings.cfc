


		<cfcomponent displayname="companysettings">
	
				<cffunction name="init" access="public" output="false" returntype="activitylog" hint="Returns an initialized company settings object function.">		
					<!--- // return this reference. --->
					<cfreturn this />
				</cffunction>
				
				
				<cffunction name="getcompanysettings" access="public" output="false" hint="I get the company settings.">
					<cfargument name="companyid" type="numeric" required="yes" default="#session.companyid#">
					<cfset var companysettings = "" />
					<cfquery datasource="#application.dsn#" name="companysettings">
						select c.* from company c
						 where c.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
					</cfquery>
					<cfreturn companysettings >
				</cffunction>
				
				<cffunction name="getclientsettings" access="public" output="false" hint="I get the client company settings.">
					<cfargument name="leadid" type="numeric" required="yes" default="#session.leadid#">
					<cfset var clientsettings = "" />
					<cfquery datasource="#application.dsn#" name="clientsettings">
						select c.*, l.leadid
						  from company c, leads l
						 where c.companyid = l.companyid
						   and l.leadid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
					</cfquery>
					<cfreturn clientsettings >
				</cffunction>
				
				<cffunction name="getcompanydocs" access="public" output="false" hint="I get the company document paths for enroll and impl agreements.">
					<cfargument name="companyid" type="numeric" required="yes" default="#session.companyid#">
					<cfset var companydocs = "" />
					<cfquery datasource="#application.dsn#" name="companydocs">
						select c.companyid, c.dba, c.companyname, 
						       c.enrollagreepath, c.implagreepath 
						  from company c
						 where c.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
					</cfquery>
					<cfreturn companydocs >
				</cffunction>
				
				
				
		</cfcomponent>