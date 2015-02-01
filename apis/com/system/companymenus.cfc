



	<cfcomponent displayname="companymenus">
	
		<cffunction name="init" access="public" output="false" returntype="companymenus" hint="Returns an initialized company settings system menu object function.">		
				<!--- // return this reference. --->
				<cfreturn this />
			</cffunction>
				
				
			<cffunction name="getcompanycontactmethods" access="public" output="false" hint="I get the company contact methods.">
				<cfargument name="companyid" type="numeric" required="yes" default="#session.companyid#">
				<cfset var contactmethods = "" />
				<cfquery datasource="#application.dsn#" name="contactmethods">
						 select cm.contactmethodid, cm.companyid, cm.contactmethod								
						   from contactmethod cm
						  where cm.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
					   order by cm.contactmethod asc
					</cfquery>
				<cfreturn contactmethods >
			</cffunction>
			
			<cffunction name="getcompanyoutcomes" access="public" output="false" hint="I get the company outcomes list.">
				<cfargument name="companyid" type="numeric" required="yes" default="#session.companyid#">
				<cfset var outcomeslist = "" />
				<cfquery datasource="#application.dsn#" name="outcomeslist">
						 select o.outcomeid, o.companyid, o.outcomedescr								
						   from outcomes o
						  where o.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
					   order by o.outcomedescr asc
					</cfquery>
				<cfreturn outcomeslist >
			</cffunction>
			
			
	</cfcomponent>