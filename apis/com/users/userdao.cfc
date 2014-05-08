



		<cfcomponent displayname="userdao">
			
			<cffunction name="init" access="public" output="false" returntype="userDAO" hint="Returns an initialized user data access object function.">		
				<!--- // return This reference. --->
				<cfreturn this />
			</cffunction>
			
			<cffunction name="saveuserprofile" access="remote" output="false" hint="I save the user profile data.">
				<cfargument name="userid" required="yes" type="numeric">
				<cfargument name="firstname" required="yes" type="string">
				<cfargument name="lastname" required="yes" type="string">
				<cfargument name="email" required="no" type="string">
				<cfargument name="password" required="yes" type="string">
				
				<cfset arguments.userid = #session.userid# />
				<cfset arguments.email = "#form.email#" />
				<cfset arguments.firstname = "#form.firstname#" />
				<cfset arguments.lastname = "#form.lastname#" />
				<cfset arguments.password = "#form.password1#" />
				
				<cfif structkeyexists(form, "saveuserprofile") and structkeyexists( form, "__authtoken" ) and len( form.__authtoken ) eq 20 >
					<cfquery datasource="#application.dsn#">
						update users
						   set firstname = <cfqueryparam value="#arguments.firstname#" cfsqltype="cf_sql_varchar" />,
							   lastname = <cfqueryparam value="#arguments.lastname#" cfsqltype="cf_sql_varchar" />,
							   email = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar" />
							   passcode = <cfqueryparam value="#arguments.password#" cfsqltype="cf_sql_varchar" />
						 where userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
					</cfquery>
					
					<cfset broadcastmessage = "Your user profile was successfully updated...">
					
					<cflocation url="../../index.cfm?event=page.profile" addtoken="no">
				
				<cfelse>
				
					<cfset broadcastmessage = "The form data can not be posted due to malformed data structure.  Please go back and try again..." />				
				
				</cfif>
			
			</cffunction>
		
		
		</cfcomponent>