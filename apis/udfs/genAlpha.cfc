<cfcomponent>

	<cffunction
		name="genRandomAlphaString"
		access="remote"
		output="false"
		hint="I generate a random alpha-numeric string">
		
		<cfset chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ" / >
		<cfset strLength = 20 / >
		<cfset randout = "" / >
		
		<cfloop from="1" to="#strLength#" index="i">
		<cfset rnum = ceiling(rand() * len(chars)) / >
		<cfif rnum EQ 0 ><cfset rnum = 1 / ></cfif>
		<cfset randout = randout & mid(chars, rnum, 1) / >
		</cfloop>

		<cfreturn randout >
	
	</cffunction>

</cfcomponent>