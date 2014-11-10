	
	
	
	<!--- api web services documentation gateway and data access objects --->
	<cfcomponent displayname="apidocsgateway">
	
		<cffunction name="init" access="public" output="false" returntype="apidocsgateway" hint="Returns an initialized web services api docs gateway function.">		
			<!--- // return this reference. --->
			<cfreturn this />
		</cffunction>
		
		
		<cffunction name="getapidocs" access="public" output="false" returntype="query" hint="I get the list of API Section Names.">
			<cfargument name="section" type="any" required="no">
			<cfset var apidocs = "" />
			<cfquery datasource="#application.dsn#" name="apidocs">
				select a.apidocsid, a.apidocsuuid, a.apidocssection, a.apidocssectionname, 
				       a.apidocssectiontext, a.apidocscreatedate, a.apidocslastupdated, 
					   a.apidocslastupdatedby, u.firstname, u.lastname
				  from apidocs a, users u
				 where a.apidocslastupdatedby = u.userid 
				       <cfif structkeyexists( arguments, "section" )>
						<cfif arguments.section neq "">
							and apidocssection = <cfqueryparam value="#trim( arguments.section )#" cfsqltype="cf_sql_varchar" />
						</cfif>
					   </cfif>
			</cfquery>
			<cfreturn apidocs>
		</cffunction>
		
		<cffunction name="getapidocssidebar" access="public" output="false" returntype="query" hint="I get the list of API Section Names for the sidebar.">
			<cfset var apidocssidebar = "" />
			<cfquery datasource="#application.dsn#" name="apidocssidebar">
				select a.apidocsid, a.apidocssection, a.apidocssectionname
				  from apidocs a 
			  order by apidocsid asc					 
			</cfquery>
			<cfreturn apidocssidebar>
		</cffunction>
		
		<cffunction name="getsearch" access="public" output="false" returntype="query" hint="I get the API docs search results list">
			<cfargument name="search" type="any" required="yes" default="service">
			<cfset var searchresults = "" />
			<cfquery datasource="#application.dsn#" name="searchresults">
				select a.apidocsid, a.apidocssection, a.apidocssectionname, a.apidocssectiontext
				  from apidocs a
				 where apidocssectiontext LIKE <cfqueryparam value="%#arguments.search#%" cfsqltype="cf_sql_varchar" />
			  order by apidocsid asc					 
			</cfquery>
			<cfreturn searchresults>
		</cffunction>
		
		
	</cfcomponent>