
		
		
		<!--- include the header --->
		<cfinclude template="header.cfm">		
				
		<!--- scope the URL variable --->
		<cfparam name="event" default="page.index">

		<!--- components that we'll use on every page --->
		<cfinvoke component="apis.udfs.genAlpha" method="genRandomAlphaString" returnvariable="randout">
		
		<!--- include the system templating engine --->
		<cfinclude template="apis/nav/nav.cfm">		
		
		<!--- include the footer --->			
		<cfinclude template="footer.cfm">			
					
				