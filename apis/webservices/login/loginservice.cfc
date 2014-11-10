<cfcomponent
    extends="basewebservice"
	output="false"
    hint="I am a web service with some remote access.">
 
    <cffunction name="init">
        <cfreturn this />
    </cffunction>
 
	
	<cfset theKey = "5b!R-j0E12LF9m6s8qzgNtMvBk74KX3T" />	
	<cfset dotnetpath = expandpath( '../../dotnet/vanco/cryption.dll' ) />	
	
 
    <cffunction
        name="doLogin"
        access="remote"
        returntype="string"
        returnformat="json"
        output="false"
        hint="I return a login response object.">
 
        <!--- Define arguments. --->
        <cfargument
            name="username"
            type="string"
            required="true"
            hint="I am the username of the clientid for the login service."
            />
		
		<cfargument
            name="passcode"
            type="string"
            required="true"
            hint="I am the password of the clientid for the login service."
            />
		
		<cfargument
            name="apiKey"
            type="string"
            required="true"
            hint="I am the web service api key."
            />
		
		<cfargument
            name="nvpvar"
            type="string"
            required="true"
            hint="I am the web service encrypted value."
            />
			
			<!--- // create a new instance of our .net object and reference our new DLL path --->
			<cfobject
				type=".NET"		
				class="Cryption.CryptionUtils"
				assembly="#dotnetpath#"
				name="decryptApiKey"
				>		
							
				<!--- // intialize our custom vanco .net component --->
				<cfset decryptApiKey.init() />			
				<cfset message = arguments.apiKey />
				<cfset setDecryptedMessage = decryptApiKey.DecryptAndDecodeMessage( message, theKey ) />
				<cfset thisDecryptedMessage = setDecryptedMessage />
				
			
			<cfif ( structkeyexists( arguments, "username" ))  and ( structkeyexists( arguments, "passcode" )) and ( structkeyexists( arguments, "apiKey" )) and ( structkeyexists( arguments, "nvpvar" )) >
				<cfset wsnewuuid = #createuuid()# />
				<cfset wsnewreqid = dateformat( now(), "mmddyy" ) & timeformat( now(), "mmss" ) & numberformat( randrange( 1, 999 ), "00000000" ) />
				<cfset today = now() />
				
				<!--- // perform login --->
				<cfquery datasource="#application.dsn#" name="checklogin">
					select ws.webserviceid, ws.webserviceprovidername, ws.webserviceclientid
					  from webservice ws, company c
					 where ws.companyid = c.companyid
					   and ws.webserviceloginuserid = <cfqueryparam value="#arguments.username#" cfsqltype="cf_sql_varchar" />					   
					   and ws.webserviceloginpassword = <cfqueryparam value="#arguments.passcode#" cfsqltype="cf_sql_varchar" />
					   <!---
					   and c.regcode = <cfqueryparam value="#thisDecryptedMessage#" cfsqltype="cf_sql_varchar" maxlength="35" />
					   --->
				</cfquery>
				
				<cfif checklogin.recordcount eq 1>
					<!---// save the new login response variables --->
					<cfquery datasource="#application.dsn#" name="saveloginsessionid">
						update webservice
						   set webservicesessionid = <cfqueryparam value="#wsnewuuid#" cfsqltype="cf_sql_varchar" maxlength="35" />,
							   webservicerequestid = <cfqueryparam value="#wsnewreqid#" cfsqltype="cf_sql_varchar" />,
							   webservicelastlogindatetime = <cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />
						 where webserviceid = <cfqueryparam value="#checklogin.webserviceid#" cfsqltype="cf_sql_integer" />
					</cfquery>
					
					<!--- // defne and set our JSON object --->
					<cfset loginresponse = {
						clientid = checklogin.webserviceclientid,						
						ipaddr = cgi.remote_addr,
						requestdate = dateFormat( now(), "mm-dd-yyyy" ),
						sessionid = wsnewuuid,
						requestid = wsnewreqid
						} />
				 
					<!--- now, serialize the user data as JSON. --->
					<cfset serializedresponsedata = serializeJSON( loginresponse ) />
				 
					<!---
						And, encrypt it. Because the entire set of JSON characters
						work towards one object, it makes the ability to mess with
						the encrypted data much more difficult.
					--->
					
					<!--- // create a new instance of our .net object and reference our component path --->
					<cfobject
						type=".NET"				
						class="Cryption.CryptionUtils"
						assembly="#dotnetpath#"
						name="encryptLoginResponsePacket">				
							
						<!--- // intialize our custom vanco .net component --->
						<cfset encryptLoginResponsePacket.init() />				
						<cfset message = serializedresponsedata />
						<cfset getEncryptedMessage = encryptLoginResponsePacket.EncryptAndEncodeMessage( message, theKey ) />						
						<cfset thisEncryptedMessage = replace( replace(  getEncryptedMessage, "+", "-", "all"), "/", "_", "all" )>
					
					<cfset local.loginresponse = thisencryptedmessage />
				    
				<cfelse>					
				
					<cfset local.loginresponse = "Login Failed!  Please try again..." />
				
				</cfif>
			
			<cfelse>				
				
				<cfset local.loginresponse = "The required variable structure for the login service is invalid." />
			
			</cfif>
			
			
        <!--- return our response object. --->
        <cfreturn local.loginresponse />
    </cffunction>
 
</cfcomponent>