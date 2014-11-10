		
		
		
		
		<cfset session.companyid = 446 />
		 
		<cfparam name="vancoresponse" default="">	
		<cfset vancoresponse =  url.nvpvar />
			
			
			
			<cfinvoke component="apis.dotnet.vanco.vanco-functions" method="getvancosettings" returnvariable="vancosettings">
				<cfinvokeargument name="companyid" value="#session.companyid#">
				<cfinvokeargument name="requesttype" value="efttransparentredirect">
			</cfinvoke>
			

			<!--- // call the decryption component to decrypt the vanco login response --->				
			<cfinvoke component="apis.dotnet.vanco.vanco-functions" method="vancodecrypt" returnvariable="thisdecryptedmessage">
				<cfinvokeargument name="companyid" value="#session.companyid#">
				<cfinvokeargument name="theKey" value="#vancosettings.webserviceapiencryptkey#" />
				<cfinvokeargument name="nvpvar" value="#nvpvar#">					
			</cfinvoke>
									
							
			<cfset vancoresponse = thisdecryptedmessage />
			
			<cfset thisarr = listtoarray( vancoresponse, "&", false, true ) />
							
							
			<cfoutput>
											
									
				<p>#thisdecryptedmessage#</p>
				
				
				<cfloop array="#thisarr#" index="j">
					<cfset item = listfirst( j, "=" ) />
					<cfset thisitemvalue = listlast( j, "=" ) />
					
					#item# ::: #thisitemvalue#<br />
				</cfloop>
				
					
									
								
			</cfoutput>
								
									
									
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		

		
		
		