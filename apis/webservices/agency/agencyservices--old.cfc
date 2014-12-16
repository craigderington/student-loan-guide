<cfcomponent
	displayname="agencyservices"
	output="false"
    hint="I am a web service with some remote access.">
 
    <cffunction name="init">
        <cfreturn this />
    </cffunction>
	
	
	<cffunction name="getCompanyUsers" access="remote" returnformat="json" output="false" hint="I get the list of company users.">	
		<cfargument name="sessionid" required="yes" type="any">
		<cfargument name="nvpvar" required="yes" type="any">
		<cfset var userlist = "" />
		
		<!--- // check our session ID against the web services database --->
		<cfquery datasource="#application.dsn#" name="checksession">
			select companyid, webservicesessionid, webservicerequestid, 
			       webserviceclientid, webserviceapiencryptkey,
			       webserviceisactive, webservicelastlogindatetime
			  from webservice
			 where webservicesessionid = <cfqueryparam value="#arguments.sessionid#" cfsqltype="cf_sql_varchar" maxlength="35" />
			   and webserviceisactive = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
	    </cfquery>
		
		<cfif checksession.recordcount eq 1>
		
			<cfset thiscompanyid = checksession.companyid />
			<cfset thisenckey = checksession.webserviceapiencryptkey />
			<cfset thisclientid = checksession.webserviceclientid />
			<cfset dotnetpath = expandpath( '../../dotnet/vanco/cryption.dll' ) />
			
			<!--- // create a new instance of our .net object and reference our new DLL path --->
			<cfobject
				type=".NET"		
				class="Cryption.CryptionUtils"
				assembly="#dotnetpath#"
				name="decryptArgs"
				>		
							
				<!--- // intialize our custom vanco .net component --->
				<cfset decryptArgs.init() />			
				<cfset message = arguments.nvpvar />
				<cfset setDecryptedMessage = decryptArgs.DecryptAndDecodeMessage( message, thisEncKey ) />
				<cfset thisDecryptedMessage = setDecryptedMessage />
			
					<cfset thisargs = deserializeJSON( thisdecryptedmessage ) />
					
					<cfset thisarg1 = thisargs.clientid />
					<cfset thisarg2 = thisargs.requestid />
					<cfset thisarg3 = thisargs.requestdate />
					
					<!--- check to make sure our client ID key exists in the encytpted struct
					      and matyches the login client ID from the web services session ID check --->
					<cfif trim( thisargs1 ) eq trim( checksession.webserviceclientid )>
					
						<cfquery datasource="#application.dsn#" name="getUserList">
							select useruuid, username, passcode, firstname, lastname, 
								   role, email, txtmsgaddress, txtmsgprovider
							  from users
							 where companyid = <cfqueryparam value="#thiscompanyid#" cfsqltype="cf_sql_integer" />
							   and leadid = <cfqueryparam value="0" cfsqltype="cf_sql_integer" />
							   and active = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
							  order by userid asc
						</cfquery>
			
						<cfset thisresultset = serializeJSON( getUserList, true ) />
				
						<!--- // create a new instance of our .net object and reference our component path --->
						<cfobject
							type=".NET"				
							class="Cryption.CryptionUtils"
							assembly="#dotnetpath#"
							name="encryptDataPacket">				
								
							<!--- // intialize our custom vanco .net component --->
							<cfset encryptDataPacket.init() />				
							<cfset message = thisresultset />
							<cfset getEncryptedMessage = encryptDataPacket.EncryptAndEncodeMessage( message, thisEncKey ) />						
							<cfset thisEncryptedMessage = replace( replace(  getEncryptedMessage, "+", "-", "all"), "/", "_", "all" )>
				
				
						<cfreturn thisencryptedmessage>
				
					<cfelse>
			
						<cfreturn "Sorry, System Error:  Your client ID was not found in this system.  Operation aborted.">
				
					</cfif>
		
		<cfelse>
		
			<cfreturn "Sorry, invalid session ID.  Please try logging into web services again and refreshing your ID.">
		
		</cfif>
	
	
	
	
	</cffunction>
	
	
</cfcomponent>