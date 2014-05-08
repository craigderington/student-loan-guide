


	<cfcomponent displayname="myRandomList">
		<cffunction name="randomizeList" output="no" access="remote" hint="I randomize the client list for the dashboard.">
			<cfargument name="object" type="any" required="yes" />
			<cfset var list = '' />
			<cfset var randomPos = 1 />
			<cfset var result = arraynew(1) />
			
				<!--- Create a sorted list depending on the type of object passed in --->
				<cfif IsStruct( arguments.object )>
					<cfset list = structkeylist( arguments.object )>
				<cfelseif IsQuery( arguments.object )>
					<cfloop index="index" from="1" to="#arguments.object.recordCount#">
						<cfset list = listappend( list, index ) />
					</cfloop>
				<cfelseif IsArray( arguments.object )>
					<cfloop index="index" from="1" to="#arraylen( arguments.object )#">
						<cfset list = listappend( list, index ) />
					</cfloop>
				<cfelse>
					<cfset list = arguments.object />
				</cfif>
			
				<!--- Convert the list to an array for speed --->
				<cfset list = listtoarray(list) />
				
					<!--- As many times as there are items in the current list --->
					<cfloop index="i" from="1" to="#arraylen( list )#">
						<!--- Add one list item at random to the results --->
						<cfset randomPos = randrange( 1, arraylen( list )) />
						<cfset arrayappend(result, list[randomPos]) />
						<!--- Remove that list item --->
						<cfset arraydeleteat( list, randomPos ) />
					</cfloop>

			<cfreturn arraytolist( result ) />
		</cffunction>	
	</cfcomponent>