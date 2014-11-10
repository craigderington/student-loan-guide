


		<cfcomponent
			output="false"
			hint="I am a remote-access testing component.">
		 
			<!---
				Set up required credentials for API calls.
		 
				NOTE: This is not really the place to do this, but I am
				doing this for the demo. Normally, you would want this
				in some sort of application-centric area or management
				system integration.
			--->
			
			<cfset THIS.Credentials = {
				Username = "Tasiah",
				Password = "brielle19"
				} />
		 
		 
			<!--- ------------------------------------ --->
		 
		 
			<!--- Check request authorization for every request. --->
			<cfset THIS.CheckAuthentication() />
		 
		 
			<!--- ------------------------------------ --->
		 
		 
			<cffunction
				name="Test"
				access="remote"
				returntype="string"
				returnformat="json"
				output="false"
				hint="I am a remote-access test method.">
		 
				<cfreturn "Method access successful!" />
			</cffunction>
		 
		 
			<!--- ------------------------------------ --->
		 
		 
			<cffunction
				name="CheckAuthentication"
				access="public"
				returntype="void"
				output="false"
				hint="I check to see if the request is authenticated. If not, then I return a 401 Unauthorized header and abort the page request.">
		 
				<!---
					Check to see if user is authorized. If NOT, then
					return a 401 header and abort the page request.
				--->
				<cfif NOT THIS.CheckAuthorization()>
		 
					<!--- Set status code. --->
					<cfheader
						statuscode="401"
						statustext="Unauthorized"
						/>
		 
					<!--- Set authorization header. --->
					<cfheader
						name="WWW-Authenticate"
						value="basic realm=""API"""
						/>
		 
					<!--- Stop the page from loading. --->
					<cfabort />
		 
				</cfif>
		 
				<!--- Return out. --->
				<cfreturn />
			</cffunction>
		 
		 
			<cffunction
				name="CheckAuthorization"
				access="public"
				returntype="boolean"
				output="false"
				hint="I check to see if the given request credentials match the required credentials.">
		 
				<!--- Define the local scope. --->
				<cfset var LOCAL = {} />
		 
				<!---
					Wrap this whole thing in a try/catch. If any of it
					goes wrong, then the credentials were either non-
					existent or were not in the proper format.
				--->
				<cftry>
		 
					<!---
						Get the authorization key out of the header. It
						will be in the form of:
		 
						Basic XXXXXXXX
		 
						... where XXXX is a base64 encoded value of the
						users credentials in the form of:
		 
						username:password
					--->
					<cfset LOCAL.EncodedCredentials = ListLast(
						GetHTTPRequestData().Headers.Authorization,
						" "
						) />
		 
					<!---
						Convert the encoded credentials from base64 to
						binary and back to string.
					--->
					<cfset LOCAL.Credentials = ToString(
						ToBinary( LOCAL.EncodedCredentials )
						) />
		 
					<!--- Break up the credentials. --->
					<cfset LOCAL.Username = ListFirst( LOCAL.Credentials, ":" ) />
					<cfset LOCAL.Password = ListLast( LOCAL.Credentials, ":" ) />
		 
					<!---
						Check the users request credentials against the
						known ones on file.
					--->
					<cfif (
						(LOCAL.Username EQ THIS.Credentials.Username) AND
						(LOCAL.Password EQ THIS.Credentials.Password)
						)>
		 
						<!--- The user credentials are correct. --->
						<cfreturn true />
		 
					<cfelse>
		 
						<!--- The user credentials are not correct. --->
						<cfreturn false />
		 
					</cfif>
		 
		 
					<!--- Catch any errors. --->
					<cfcatch>
		 
						<!---
							Something went wrong somewhere with the
							credentials, so we have to assume user is
							not authorized.
						--->
						<cfreturn false />
		 
					</cfcatch>
		 
				</cftry>
			</cffunction>
		 
		</cfcomponent>