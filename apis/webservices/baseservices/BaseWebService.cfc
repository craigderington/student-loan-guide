		
		
		
		
		
		
		<cfcomponent
			displayname="BaseWebService"
			output="false"
			hint="This handles core web service features.">
		 
			<cffunction
				name="Init"
				access="public"
				returntype="any"
				output="false"
				hint="Returns an initialized web service instance.">
		 
				<!--- Return This reference. --->
				<cfreturn THIS />
			</cffunction>
		 
		 
			<cffunction
				name="RebuildStubFile"
				access="remote"
				returntype="void"
				output="false"
				hint="Rebuilds the WSDL file at the given url.">
		 
				<!--- Define arguments. --->
				<cfargument name="Password" type="string" required="true" />
		 
				<!---
					Check to make sure this user has access to this
					feature. This probably shouldn't be a remote access
					function, but for the moment, I had no idea where
					else to put it.
				--->
				<cfif NOT Compare( ARGUMENTS.Password, "sweetlegs!" )>
		 
					<!---
						Rebuild this stub file for the web service using
						the ColdFusion service factory. I picked this
						tip up from:
						http://www.bpurcell.org/blog/index.cfm?mode=entry&ENTRY=965.
		 
						Notice here that we are getting the requested
						URL, which will be the web service coldfusion
						component that was requested. Then we append
						the "?wsdl" web service directive to the end
						of the url.
					--->
					<cfset CreateObject( "java", "coldfusion.server.ServiceFactory" ).XmlRpcService.RefreshWebService(
						GetPageContext().GetRequest().GetRequestUrl().Append( "?wsdl" ).ToString()
						) />
		 
				</cfif>
		 
				<!--- Return out. --->
				<cfreturn />
			</cffunction>
		 
		</cfcomponent>