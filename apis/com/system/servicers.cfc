

	<!--- our servicers component --->
	<cfcomponent displayname="servicersgateway">
	
		<cffunction name="init" access="public" output="false" returntype="servicersgateway" hint="Returns an initialized servicers gateway function.">		
			<!--- // return this reference. --->
			<cfreturn this />
		</cffunction>
	
		<cffunction name="getservicers" access="remote" output="false" hint="I get the list of servicers from the database.">			
			<cfset var servicerlist = "" />
			<cfquery datasource="#application.dsn#" name="servicerlist">
			   select servid, servtype, servname, servcity, servstate, servphone, servfax, servemail
				 from dbo.servicers
				where servactive = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
			 order by servname asc
			</cfquery>		
			<cfreturn servicerlist>
		</cffunction>
		
		<cffunction name="searchservicers" access="remote" output="false" hint="I get the search list of servicers from the database.">			
			<cfargument name="searchphrase" default="#form.search#">			
			<cfset var servlist = "" />			
			<cfquery datasource="#application.dsn#" name="servlist">
			   select servid, servtype, servname, servcity, servstate, servphone, servfax, servemail
				 from dbo.servicers
				where servname like <cfqueryparam value="%#arguments.searchphrase#%" cfsqltype="cf_sql_varchar" />
				  and servactive = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
			 order by servname asc
			</cfquery>		
			<cfreturn servlist>
		</cffunction>
		
		
		<cffunction name="getservicer" access="remote" output="false" hint="I get the loan servicer detail from the database.">			
			<cfargument name="srvid" required="yes" default="#url.srvid#">			
			<cfset var srvdetail = "" />			
			<cfquery datasource="#application.dsn#" name="srvdetail">
			   select servid, servtype, servname, servadd1, servadd2, servcity, servstate, 
			          servzip, servphone, servfax, servemail, servactive, servfax2, servphone2
				 from dbo.servicers
				where servid = <cfqueryparam value="#arguments.srvid#" cfsqltype="cf_sql_integer" />				  
			</cfquery>		
			<cfreturn srvdetail>
		</cffunction>	
	
	</cfcomponent>