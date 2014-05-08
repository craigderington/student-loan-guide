

		<cfcomponent displayname="deptadmingateway">
		
			<cffunction name="init" access="public" output="false" returntype="deptadmingateway" hint="I create an initialized instance of the department gateway object.">				
				<cfreturn this >			
			</cffunction>
			
			<cffunction name="getdepts" access="public" output="false" hint="I get the list of company departments.">
				<cfargument name="companyid" default="#session.companyid#" type="numeric" required="yes">				
				<cfset var deptlist = "" />
				<cfquery datasource="#application.dsn#" name="deptlist">
					select d.deptid, d.deptuuid, d.companyid, d.deptname, d.active, c.companyname
					  from dept d, company c
					 where d.companyid = c.companyid
					   and d.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
				  order by d.deptname asc 
				</cfquery>
				<cfreturn deptlist >
			</cffunction>
			
			<cffunction name="getdept" access="public" output="false" hint="I get the company department detail.">
				<cfargument name="deptid" default="#url.deptid#" type="uuid" required="yes">				
				<cfset var deptdetail = "" />
				<cfquery datasource="#application.dsn#" name="deptdetail">
					select d.deptid, d.deptuuid, d.companyid, d.deptname, d.active, c.companyname
					  from dept d, company c
					 where d.companyid = c.companyid
					   and d.deptuuid = <cfqueryparam value="#arguments.deptid#" cfsqltype="cf_sql_varchar" maxlength="35" />				  
				</cfquery>
				<cfreturn deptdetail >
			</cffunction>
		
		</cfcomponent>