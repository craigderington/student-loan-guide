


	<cfcomponent displayname="librarygateway">
	
		<cffunction name="init" access="public" output="false" returntype="librarygateway" hint="Returns an initialized library gateway object function.">		
			<!--- // return this reference. --->
			<cfreturn this />
		</cffunction>
		
		
		<cffunction name="getformslist" access="public" output="false" returntype="query" hint="I get the company specific list of forms for the library.">
			<cfargument name="companyid" default="0" required="yes" type="numeric">
			<cfset var formslist = "" />
			<cfquery datasource="#application.dsn#" name="formslist">
				select libraryid, libuuid, docdate, doccat, docdescr, docname, docpath, docactive
				  from library
				 where companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
				   and docactive = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
			  order by doccat, docname asc
			</cfquery>
			<cfreturn formslist >
		</cffunction>
			
		
		
		
	
	</cfcomponent>