


		<cfcomponent displayname="statuscodes">
	
			<cffunction name="getcodelist" access="remote" output="false" hint="I generate the status code list.">
			
				<cfargument name="scode" type="any" default="C" required="yes">				
					
					<!--- // our 9 basic statuscodes to simplyfy the programming --->
									
					<cfif trim( arguments.scode ) is "BA">
					
						<!--- // bankruptcy codes --->
						<cfquery datasource="#application.dsn#" name="bank">
							select sc.statuscodeid, sc.statuscode
							  from statuscodes sc
							 where sc.statuscoderefer = <cfqueryparam value="BA" cfsqltype="cf_sql_varchar" />
						</cfquery>
						
						<cfset codelist = ValueList( bank.statuscode, "," ) />
					
					<cfelseif trim( arguments.scode ) is "C">
					
						<!--- // status current  --->
						<cfquery datasource="#application.dsn#" name="current">
							select sc.statuscodeid, sc.statuscode
							  from statuscodes sc
							 where sc.statuscoderefer = <cfqueryparam value="C" cfsqltype="cf_sql_varchar" />
						</cfquery>
						
						<cfset codelist = ValueList( current.statuscode, "," ) />
							
					<cfelseif trim( arguments.scode ) is "DF">
						
						<!--- // defaulted current  --->
						<cfquery datasource="#application.dsn#" name="df">
							select sc.statuscodeid, sc.statuscode
							  from statuscodes sc
							 where sc.statuscoderefer = <cfqueryparam value="DF" cfsqltype="cf_sql_varchar" />
						</cfquery>
						
						<cfset codelist = ValueList( df.statuscode, "," ) />
						
					<cfelseif trim( arguments.scode ) is "DJ">
						
						<!--- // jusdgement status  --->
						<cfquery datasource="#application.dsn#" name="judge">
							select sc.statuscodeid, sc.statuscode
							  from statuscodes sc
							 where sc.statuscoderefer = <cfqueryparam value="DJ" cfsqltype="cf_sql_varchar" />
						</cfquery>
						
						<cfset codelist = ValueList( judge.statuscode, "," ) />
						
					<cfelseif trim( arguments.scode ) is "DN">
						
						<!--- // status current  --->
						<cfquery datasource="#application.dsn#" name="dn">
							select sc.statuscodeid, sc.statuscode
							  from statuscodes sc
							 where sc.statuscoderefer = <cfqueryparam value="DN" cfsqltype="cf_sql_varchar" />
						</cfquery>
						
						<cfset codelist = valuelist( dn.statuscode, "," ) />
						
						
					<cfelseif trim( arguments.scode ) is "F">
						
						<!--- // status forbearance --->
						<cfquery datasource="#application.dsn#" name="forbear">
							select sc.statuscodeid, sc.statuscode
							  from statuscodes sc
							 where sc.statuscoderefer = <cfqueryparam value="F" cfsqltype="cf_sql_varchar" />
						</cfquery>
						
						<cfset codelist = ValueList( forbear.statuscode, "," ) />
						
					<cfelseif trim( arguments.scode ) is "G">
						
						<!--- // status in grace period  --->
						<cfquery datasource="#application.dsn#" name="grace">
							select sc.statuscodeid, sc.statuscode
							  from statuscodes sc
							 where sc.statuscoderefer = <cfqueryparam value="G" cfsqltype="cf_sql_varchar" />
						</cfquery>
						
						<cfset codelist = ValueList( current.statuscode, "," ) />
						
					<cfelseif trim( arguments.scode ) is "TO">
						
						<!--- // status current  --->
						<cfquery datasource="#application.dsn#" name="to">
							select sc.statuscodeid, sc.statuscode
							  from statuscodes sc
							 where sc.statuscoderefer = <cfqueryparam value="to" cfsqltype="cf_sql_varchar" />
						</cfquery>
						
						<cfset codelist = ValueList( to.statuscode, "," ) />
						
					<cfelseif trim( arguments.scode ) is "WG">
						
						<!--- // status wage garnishment --->
						<cfquery datasource="#application.dsn#" name="wg">
							select sc.statuscodeid, sc.statuscode
							  from statuscodes sc
							 where sc.statuscoderefer = <cfqueryparam value="WG" cfsqltype="cf_sql_varchar" />
						</cfquery>
						
						<cfset codelist = ValueList( wg.statuscode, "," ) />
					
					</cfif>			
					
					<cfset codelist = rereplace( codelist, "[[:space:]]", "", "ALL") />
				
				<cfreturn codelist >
				
			</cffunction>
			
		</cfcomponent>
					
					
					
					
					
					
					