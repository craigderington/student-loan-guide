


		<!--- pass any url vars we will need to direct back to the login page to provide status updates --->
		<cfparam name="rdurl" default="">
		
		<cfif structkeyexists( url, "rdurl" )>
			<cfset rdurl = #url.rdurl# />
		</cfif>
		
		<!--- // kill the user ID --->
		<cfif structkeyexists( session, "userid" )>
			<cfparam name="tempU" default="">
			<cfset tempU = structdelete( session, "userid" ) />
		</cfif>
		
		<cfif structkeyexists( session, "companyid" )>
			<cfparam name="tempQ" default="">
			<cfset tempQ = structdelete( session, "companyid" ) />
		</cfif>
		
		<!--- // kill any open lead session if it exists --->
		<cfif structkeyexists( session, "leadid" )>
			<cfparam name="tempZ" default="">
			<cfset tempZ = structdelete( session, "leadid" ) />
		</cfif>
		
		<!--- // kill the jsessionid --->
		<cfif structkeyexists( session, "jsessionid" )>
			<cfparam name="tempJ" default="">
			<cfset tempJ = structdelete( session, "jsessionid" ) />
		</cfif>		
			
		<!--- // log out the user --->
		<cflogout>
		
		<!--- // redirect to index page --->
		
		<cfif structkeyexists( url, "rdurl" ) and url.rdurl is not "">
			<cflocation url="#application.root#?event=page.index&#url.rdurl#=1" addtoken="no">
		<cfelse>
			<cflocation url="#application.root#?event=page.index&logout=1" addtoken="no">
		</cfif>