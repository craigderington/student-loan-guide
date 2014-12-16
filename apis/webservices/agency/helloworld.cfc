<cfcomponent
	displayname="helloworld"
	hint="I say hello to the user request."
	>
	
	<cffunction
		name="init"
		>
		<cfreturn this>
	</cffunction>
	
	<cffunction
		name="sayHello"
		access="remote"
		output="false"
		returntype="string"
		returnformat="plain"
		hint="I say hello to the user."
		>
		
		
		<cfargument
			name="callersname"
			required="true"
			type="string"
			default="Joe"
			>
			
		
		<cfreturn "Hello " & arguments.callersname & " Today is: " & dateformat( now(), 'mm/dd/yyyy' )>
	
	
	
	</cffunction>
	
	
</cfcomponent>