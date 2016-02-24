<cfcomponent
	extends="rootapplication"
	hint="I define the webservices sub directory application settings and event handlers."
	>		
	<!--- ****************************************************  
		  11-2-2014 // CLD // 
		  We need to allow direct web service API calls to our
		  CFC's.  Since the root site utilizes the OnRequestStart
		  method, all page requests are routed through CF login.
		  This app.cfc extends rootapp.cfc (located in this
		  same directory; so no namespace mapping is required).
		  The rootapp.cfc is a simple include statement that 
		  includes the site root app.cfc as an included template.  
		  Works like a charm.
		  Thanks to Ben Nadel bennadel.com
	--->
		  
		 
			<cffunction
				name="onSessionStart"
				access="public"
				returntype="void"
				output="false"
				hint="I initialize the session.">
		 
				<!--- set some session variables for testing --->
				<cfset session.dateInitialized = now() />
		 
				<!--- return out --->
				<cfreturn />
			</cffunction>
		 
		 
			<cffunction
				name="onRequestStart"
				access="public"
				returntype="boolean"
				output="false"
				hint="I initialize the page pre-processing for the sub-directory requests.  This is to allow direct CFC calls to exposed web services.">				
		 
				<!--- return true so the page can process --->
				<cfreturn true />
			</cffunction>
		 
</cfcomponent>
