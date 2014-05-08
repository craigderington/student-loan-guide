

	<cfcomponent displayname="assetgateway">
	
		<cfset init() />
		
		<cffunction name="init" access="public" output="false" returntype="assetgateway" hint="Returns an initialized asset gateway function.">		
			<!--- // return This reference. --->
			<cfreturn this />
		</cffunction>
		
		<cffunction name="getassettypes" output="false" access="remote" returntype="query" hint="I get the list of asset types.">
			<cfquery datasource="#application.dsn#" name="assettypes">
				select assetcatid, assetcatname
				  from assettypes
			  order by assetcatname asc
			</cfquery>
			<cfreturn assettypes>
		</cffunction>
		
		<cffunction name="getassets" output="false" access="remote" returntype="query" hint="I get the list of client assets and liabilities.">
			<cfargument name="budgetid" type="numeric" default="#budget.budgetid#">
			<cfargument name="leadid" type="numeric" default="#session.leadid#">
				<cfquery datasource="#application.dsn#" name="myassets">
					select a.assetid, a.budgetid, a.leadid, at.assetcatname, a.assetdescr, a.assetother, a.assetamount, a.liabilityamount
					  from assets a, assettypes at
					 where a.assetcatid = at.assetcatid
					   and a.budgetid = <cfqueryparam value="#arguments.budgetid#" cfsqltype="cf_sql_integer" />
					   and a.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					 order by at.assetcatname asc
				</cfquery>
				<cfreturn myassets>
		</cffunction>
		
		<cffunction name="getassetsbycat" output="false" access="remote" returntype="query" hint="I get the list of client assets and liabilities by asset type.">
			<cfargument name="budgetid" type="numeric" default="#budget.budgetid#">			
				<cfquery datasource="#application.dsn#" name="assetsbycat">
					select assetcatname, count(at.assetcatid) as totalcat,
						   sum(assetamount) as totalassets,
						   sum(liabilityamount) as totalliabilities
					 from assets a, assettypes at
					where a.assetcatid = at.assetcatid
					  and a.budgetid = <cfqueryparam value="#arguments.budgetid#" cfsqltype="cf_sql_integer" />
				 group by assetcatname
				 order by assetcatname asc
				</cfquery>
				<cfreturn assetsbycat>
		</cffunction>
		
		<cffunction name="getassettotals" output="false" access="remote" returntype="query" hint="I get the assets and liabilities totals.">
			<cfargument name="budgetid" type="numeric" default="#budget.budgetid#">			
				<cfquery datasource="#application.dsn#" name="assettotals">
					select sum(assetamount) as totalassets, sum(liabilityamount) as totalliabilities
					  from assets a
					 where a.budgetid = <cfqueryparam value="#arguments.budgetid#" cfsqltype="cf_sql_integer" />		 
				</cfquery>
				<cfreturn assettotals>
		</cffunction>
	
	
	
	
	</cfcomponent>