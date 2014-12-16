<cfcomponent
	displayname="helloworld"
	hint="I say hello to the user request."
	>
	
	<cffunction
		name="sayHello"
		access="remote"
		output="false"
		returntype="string"
		hint="I say hello to the user."
		>
		
		
		<cfargument
			name="callersname"
			required="true"
			type="string"
			default="Joe"
			>
			
		
		<cfreturn "Hello" & arguments.callersname >
	
	
	
	</cffunction>
	
	
</cfcomponent>