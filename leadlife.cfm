



				<!--- Create an instance of the LeadLife API --->
				<cfinvoke component="apis.com.leadlife" method="leadlifeLogin" returnvariable="objLeadResponse">
					<cfinvokeargument name="authToken" value="">
					<cfinvokeargument name="manageURL" value="">
				<cfinvoke>
				
				<cfparam name="postLeadData" default="">				
				<cfset postLeadData = StructNew() />
				
				<cfhttp
					name="createOrUpdate"
					url=""
					method="POST"
					throwonerror="yes"
					result="leadResponse"
					path="#objLeadResponse.Headers[ 'X-Manage-Url' ]#" & "/Lead/CreateOrUpdate">
					
					
					<cfhttpparam
						name="X-Auth-Token"
						type="header"
						value="#objLeadResponse.Headers[ "X-Auth-Token" ]#">
				
				
					
				</cfhttp>	
					
				
				
					