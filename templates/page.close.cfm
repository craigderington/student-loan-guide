




				<!--- // close the client record and destroy session vars --->
				<cfif structkeyexists( session, "leadid" )>				
					<cfparam name="tempX" default="">				
					<cfset tempX = structdelete( session, "leadid" )>					
					<cfif structkeyexists( session, "leadconv" )>
						<cfparam name="tempY" default="">
						<cfparam name="tempZ" default="">					
						<cfset tempZ = structdelete( session, "leadconv" )>						
							<cfif structkeyexists( session, "leadimp" )>
								<cfset tempY = structdelete( session, "leadimp" ) />
							</cfif>						
						<cflocation url="#application.root#?event=page.clients" addtoken="no">				
					<cfelse>						
						<cflocation url="#application.root#?event=page.leads" addtoken="no">					
					</cfif>
					<cfif structkeyexists( session, "nslds" )>
						<cfparam name="tempQ" default="">	
						<cfset tempQ = structdelete( session, "nslds" )>
					</cfif>					
				<cfelse>
					<cflocation url="#application.root#?event=page.index" addtoken="no">
				</cfif>