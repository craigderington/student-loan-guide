<cfcomponent>

	<cffunction
		name="getHexColor"
		access="remote"
		output="false"
		hint="I generate a random alpha-numeric string">
		
		<cfset chars = "0123456789ABCDEF" / >
		<cfset strLength = 6 / >
		<cfset hexcolor = "" / >
		
		<cfloop from="1" to="#strLength#" index="i">
		<cfset rnum = ceiling(rand() * len(chars)) / >
		<cfif rnum EQ 0 ><cfset rnum = 1 / ></cfif>
		<cfset hexcolor = hexcolor & mid(chars, rnum, 1) / >
		</cfloop>

		<cfreturn hexcolor >
	
	</cffunction>

</cfcomponent>