<cfcomponent
	output="false"
	hint="I provide the base API functionality.">
 
 
	<cffunction
		name="getNewResponse"
		access="public"
		returntype="struct"
		output="false"
		hint="I return a new API response struct.">
 
		<!--- Define the local scope. --->
		<cfset var local = {} />
 
		<!--- Create new API response. --->
		<cfset local.response = {
			success = true,
			errors = [],
			data = ""
			} />
 
		<!--- Return the empty response object. --->
		<cfreturn local.response />
	</cffunction>
 
</cfcomponent>