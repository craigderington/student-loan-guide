


		<cfcomponent displayname="companyadmingateway">
		
			<cffunction name="init" access="public" output="false" returntype="companyadmingateway" hint="I create an initialized company gateway object.">
				<cfreturn this >
			</cffunction>
		
			<cffunction name="getcompanies" access="public" output="false" hint="I get the list of companies from the database for administrative functions.">
				<cfset var complist = "" />
				<cfquery datasource="#application.dsn#" name="complist">
					select companyid, companyname, dba, address1, address2, city, state, zip, 
						   phone, fax, email, regcode, active
					  from company
					 where companyid <> <cfqueryparam value="445" cfsqltype="cf_sql_integer" />
				  order by companyname asc 
				</cfquery>
				<cfreturn complist >
			</cffunction>
			
			<cffunction name="getcompany" access="public" output="false" hint="I get the selected company detail.">
				<cfargument name="companyid" default="#url.compid#" type="numeric" required="yes">
				<cfset var compdetail = "" />
				<cfquery datasource="#application.dsn#" name="compdetail">
					select companyid, companyname, dba, address1, address2, city, state, zip, 
						   phone, fax, email, regcode, active, complogo, advisory, implement, comptype
					  from company
				     where companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" /> 
				</cfquery>
				<cfreturn compdetail >
			</cffunction>
			
			<cffunction name="getusercomp" access="public" output="false" hint="I get the selected company detail for the user and department admin section.">
				<cfargument name="companyid" default="#session.companyid#" type="numeric" required="yes">
				<cfset var compuserdetail = "" />
				<cfquery datasource="#application.dsn#" name="compuserdetail">
					select companyid, companyname
					  from company
				     where companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" /> 
				</cfquery>
				<cfreturn compuserdetail >
			</cffunction>
		
		</cfcomponent>