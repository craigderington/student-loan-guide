


			<cfcomponent displayname="leadsourcegateway">
			
				<cffunction name="init" access="public" output="false" returntype="leadsourcegateway" hint="I create an initialized instance of the leadsource gateway object.">				
					<cfreturn this >			
				</cffunction>
				
				<cffunction name="getleadsources" access="public" output="false" hint="I get the list of company lead sources for admin management">
					<cfargument name="companyid" type="numeric" required="yes" default="#session.companyid#">
					<cfset var leadsources = "" />
					<cfquery datasource="#application.dsn#" name="leadsources">
						select leadsourceid, companyid, leadsource, active
						  from leadsource
						 where companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
				      order by leadsource asc 
					</cfquery>
					<cfreturn leadsources >
				</cffunction>
			
			</cfcomponent>