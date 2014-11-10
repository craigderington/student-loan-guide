<cfcomponent
	extends="BaseAPI"
	output="false"
	hint="I am the public API for contacts.">
 
 
	<cffunction
		name="AddContact"
		access="remote"
		returntype="struct"
		returnformat="json"
		output="false"
		hint="I add the given contact.">
 
		<!--- Define arguments. --->
		<cfargument
			name="Name"
			type="string"
			required="true"
			hint="I am the name of the contact."
			/>
 
		<cfargument
			name="Hair"
			type="string"
			required="true"
			hint="I am the hair color of the contact."
			/>
 
		<!--- define the local scope. --->
		<cfset var LOCAL = {} />
 
		<!--- get a new API resposne. --->
		<cfset LOCAL.Response = THIS.GetNewResponse() />
 
 
		<!--- Check to see if all the data is defined. --->
		<cfif NOT Len( ARGUMENTS.Name )>
 
			<cfset ArrayAppend(
				LOCAL.Response.Errors,
				"Please enter a contact name."
				) />
 
		</cfif>
 
		<cfif NOT Len( ARGUMENTS.Hair )>
 
			<cfset ArrayAppend(
				LOCAL.Response.Errors,
				"Please enter a contact hair color."
				) />
 
		</cfif>
 
 
		<!---
			Check to see if their are any errors. If there are
			none, then we can process the API request.
		--->
		<cfif NOT ArrayLen( LOCAL.Response.Errors )>
 
			<!--- create a new contact. --->
			<cfset LOCAL.Contact = {
				ID = CreateUUID(),
				Name = ARGUMENTS.Name,
				Hair = ARGUMENTS.Hair
				} />
 
			<!--- add the contact to the cache. --->
			<cfset ArrayAppend(
				APPLICATION.Contacts,
				LOCAL.Contact
				) />
 
			<!--- set the contact as the return data. --->
			<cfset LOCAL.Response.Data = LOCAL.Contact />
 
		</cfif>
 
 
		<!--- Check to see if we have any errors. --->
		<cfif ArrayLen( LOCAL.Response.Errors )>
 
			<!---
				At this point, if we have errors, we have to flag
				the request as not successful.
			--->
			<cfset LOCAL.Response.Success = false />
 
		</cfif>
 
		<!--- Return the response. --->
		<cfreturn "This is the response" <!---LOCAL.Response---> />
	</cffunction>
 
 
	<cffunction
		name="DeleteContact"
		access="remote"
		returntype="struct"
		returnformat="json"
		output="false"
		hint="I delete the contact with the given ID.">
 
		<!--- Define arguments. --->
		<cfargument
			name="ID"
			type="string"
			required="true"
			hint="I am the ID of the contact to delete."
			/>
 
		<!--- Define the local scope. --->
		<cfset var LOCAL = {} />
 
		<!--- Get a new API resposne. --->
		<cfset LOCAL.Response = THIS.GetNewResponse() />
 
		<!--- Set a default contact index. --->
		<cfset LOCAL.ContactIndex = 0 />
 
		<!---
			Loop over the contacts looking for the one with
			the given ID.
		--->
		<cfloop
			index="LOCAL.Index"
			from="1"
			to="#ArrayLen( APPLICATION.Contacts )#"
			step="1">
 
			<!--- Check the contact ID. --->
			<cfif (APPLICATION.Contacts[ LOCAL.Index ].ID EQ ARGUMENTS.ID)>
 
				<!--- Store this index as the target index. --->
				<cfset LOCAL.ContactIndex = LOCAL.Index />
 
			</cfif>
 
		</cfloop>
 
 
		<!--- Check to see if we found a contact. --->
		<cfif NOT LOCAL.ContactIndex>
 
			<cfset ArrayAppend(
				LOCAL.Response.Errors,
				"The given contact could not be found."
				) />
 
		</cfif>
 
 
		<!---
			Check to see if their are any errors. If there are
			none, then we can process the API request.
		--->
		<cfif NOT ArrayLen( LOCAL.Response.Errors )>
 
			<!--- Get the contact. --->
			<cfset LOCAL.Contact = APPLICATION.Contacts[ LOCAL.ContactIndex ] />
 
			<!--- Delete the contact. --->
			<cfset ArrayDeleteAt(
				APPLICATION.Contacts,
				LOCAL.ContactIndex
				) />
 
			<!--- Set the contact as the return data. --->
			<cfset LOCAL.Response.Data = LOCAL.Contact />
 
		</cfif>
 
 
		<!--- Check to see if we have any errors. --->
		<cfif ArrayLen( LOCAL.Response.Errors )>
 
			<!---
				At this point, if we have errors, we have to flag
				the request as not successful.
			--->
			<cfset LOCAL.Response.Success = false />
 
		</cfif>
 
		<!--- Return the response. --->
		<cfreturn LOCAL.Response />
	</cffunction>
 
 
	<cffunction
		name="GetContacts"
		access="remote"
		returntype="struct"
		returnformat="json"
		output="false"
		hint="I return the collection of contacts.">
 
		<!--- Define the local scope. --->
		<cfset var LOCAL = {} />
 
		<!--- Get a new API response. --->
		<cfset LOCAL.Response = THIS.GetNewResponse() />
 
		<!--- Store the contacts in the response. --->
		<cfset LOCAL.Response.Data = APPLICATION.Contacts />
 
		<!--- Return the response. --->
		<cfreturn LOCAL.Response />
	</cffunction>
 
</cfcomponent>