


		<!--- // show the hash --->
		
		
		<cfparam name="thishash" default="">
		
		<cfset thishash = "momo1023" />
		
		<cfset thishash = hash( thishash, "SHA-384", "UTF-8" ) />
		
		<cfoutput>
			#thishash#
		</cfoutput>