


	
	
		<!--- // test remote functionality for SLA API --->
		<cfcomponent displayname="hello">
			
			<!---// initialize the object 
			<cffunction name="init" access="remote" output="false" returntype="hello" hint="Returns an initialized webservices remote hello object.">		
				<!--- // return This reference. --->
				<cfreturn this />
			</cffunction>
			--->
			<cffunction name="sayhello" access="remote" returntype="string">
				<cfset thisHello = "Hello World!">
				<cfreturn thisHello >
			</cffunction>
		
			<!---
			<cffunction name="getcompanyname" access="remote" returntype="string" hint="I get the company name.">
				<cfargument name="cid" type="numeric" required="yes">
				<cfargument name="apiKey" type="uuid" required="yes">
				<cfset var companyname = "" />
				<cfquery datasource="#application.dsn#" name="companysettings">
					select companyid, regcode, dba
					  from company
					 where companyid = <cfqueryparam value="#arguments.cid#" cfsqltype="cf_sql_integer" />
					   and regcode = <cfqueryparam value="#arguments.apiKey#" cfsqltype="cf_sql_varchar" maxlength="35" />
				</cfquery>
				<cfset companyname = companysettings.dba />
				<cfreturn companyname>
			</cffunction>
			--->
		
		</cfcomponent>