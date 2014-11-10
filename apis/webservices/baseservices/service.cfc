<cfcomponent
    output="false"
    hint="I am a web service with some remote access.">
 
    <!--- // initialize the component object --->
	<cffunction name="init">
        <cfreturn this />
    </cffunction>
 
 
    <cffunction
        name="getGirl"
        access="remote"
        returntype="struct"
        returnformat="json"
        output="false"
        hint="I return a girl object.">
 
        <!--- define arguments. --->
        <cfargument
            name="name"
            type="string"
            required="true"
            hint="I am the name of the girl being returned."
            />
 
        <!--- define the girl object. --->
        <cfset local.girl = {
            name = arguments.name
            } />
 
        <!--- return girl object. --->
        <cfreturn local.girl />
    </cffunction>
 
</cfcomponent>