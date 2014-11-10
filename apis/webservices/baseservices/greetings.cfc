<cfcomponent
    output="false"
    hint="I provide a simple greeting method.">
 
 
    <cffunction
        name="sayHello"
        access="remote"
        returntype="string"
        returnformat="json"
        output="false"
        hint="I say something to the given person.">
 
        <!--- Define arguments. --->
        <cfargument
            name="name"
            type="string"
            required="true"
            hint="I am the person we are talking to."
            />
 
        <cfargument
            name="compliment"
            type="string"
            required="false"
            hint="I am the optional compliment."
            />
 
        <!--- Check to see if the compliment exists. --->
        <cfif structKeyExists( arguments, "compliment" )>
 
            <!--- Return just the hello with a compliment. --->
            <cfreturn "Hello, #arguments.name#, you are #arguments.compliment#." />
 
        <cfelse>
 
            <!--- Return just the hello. --->
            <cfreturn "Hello, #arguments.name#." />
 
        </cfif>
    </cffunction>
 
</cfcomponent>