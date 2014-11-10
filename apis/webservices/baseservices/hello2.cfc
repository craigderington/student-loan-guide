<cfcomponent>
   <cffunction name="helloWorld" returnType="string" access="remote">     
	  <cfargument name="fname" type="string" required="true">
	  <cfreturn "Hello World!">
   </cffunction>   
</cfcomponent>