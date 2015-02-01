
		
		
		<!--- // include the header --->
		<cfinclude template="header.cfm">	
				
		<!--- // scope the URL variable --->
		<cfparam name="event" default="page.index">	
		
		<!--- // if the event variable does not exist, scope any additional url variables --->
		<cfif structkeyexists( url, "nvpvar" ) and not structkeyexists( url, "event" )>
			<cfparam name="nvpvar" default="">
			<cfset nvpvar = url.nvpvar />
			<cflocation url="#application.root#?event=page.vanco.response&nvpvar=#nvpvar#" addtoken="no">
		</cfif>
		
		<!--- // components that we'll use on every page --->
		<cfinvoke component="apis.udfs.genAlpha" method="genRandomAlphaString" returnvariable="randout">
		
		<!--- // include the system templating engine --->
		<cfinclude template="apis/nav/nav.cfm">	
		
		<!--- // include the footer --->			
		<cfinclude template="footer.cfm">			
					
				