	
	
	
	<!--- api web services documentation gateway and data access objects --->
	<cfcomponent displayname="usermanualgateway">
	
		<cffunction name="init" access="public" output="false" returntype="usermanualgateway" hint="Returns an initialized user manual gateway function.">		
			<!--- // return this reference. --->
			<cfreturn this />
		</cffunction>
		
		
		<cffunction name="getusermanual" access="public" output="false" returntype="query" hint="I get the list of user manual section names.">
			<cfargument name="section" type="any" required="no">
			<cfset var usermanual = "" />
			<cfquery datasource="#application.dsn#" name="usermanual">
				select um.usermanualid, um.usermanualuuid, um.usermanualsection, um.usermanualsectionname, 
				       um.usermanualsectiontext, um.usermanualcreatedate, um.usermanuallastupdated, 
					   um.usermanuallastupdatedby, u1.firstname, u1.lastname
				  from usermanual um, users u1
				 where um.usermanuallastupdatedby = u1.userid 
				       <cfif structkeyexists( arguments, "section" )>
							<cfif arguments.section neq "">
								and usermanualsection = <cfqueryparam value="#trim( arguments.section )#" cfsqltype="cf_sql_varchar" />
							</cfif>
					   </cfif>
			</cfquery>
			<cfreturn usermanual>
		</cffunction>
		
		<cffunction name="getusermanualsidebar" access="public" output="false" returntype="query" hint="I get the list of user manual section names for the sidebar.">
			<cfset var usermanualsidebar = "" />
			<cfquery datasource="#application.dsn#" name="usermanualsidebar">
				select u.usermanualid, u.usermanualsection, u.usermanualsectionname
				  from usermanual u
			  order by u.usermanualid asc					 
			</cfquery>
			<cfreturn usermanualsidebar>
		</cffunction>
		
		<cffunction name="getsearch" access="public" output="false" returntype="query" hint="I get the API docs search results list">
			<cfargument name="search" type="any" required="yes" default="service">
			<cfset var searchresults = "" />
			<cfquery datasource="#application.dsn#" name="searchresults">
				select u.usermanualid, u.usermanualsection, u.usermanualsectionname, u.usermanualsectiontext
				  from usermanual u
				 where u.usermanualsectiontext LIKE <cfqueryparam value="%#arguments.search#%" cfsqltype="cf_sql_varchar" />
			  order by u.usermanualid asc					 
			</cfquery>
			<cfreturn searchresults>
		</cffunction>
		
		
	</cfcomponent>