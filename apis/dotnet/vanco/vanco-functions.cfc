




			<cfcomponent displayname="vanco-functions" >
			
				<cffunction name="init" access="public" output="false" returntype="vanco-functions" hint="Returns an initialized vanco encryption and decryption function.">		
					<!--- // return This reference. --->
					<cfreturn this />
				</cffunction>				
			
					<cffunction name="getvancosettings" access="remote" returntype="query" output="false" hint="I get the vanco encrypted output.">
						<cfargument name="companyid" default="#session.companyid#" type="numeric">
						<cfargument name="requesttype" default="none" type="string" required="yes">
							<!--- // get the company vanco web services api login information --->
							<cfquery datasource="#application.dsn#" name="vancosettings">
								select webserviceid, webserviceuuid, webservicedatecreated, companyid, webserviceprovidername, 
								       webservicerequesttype, webserviceposturl, webserviceloginuserid, webserviceloginpassword, 
									   webserviceclientid, webserviceframeid, webserviceapiencryptkey, webservicesessionid, 
									   webservicerequestid, webservicelastlogindatetime, webserviceisactive
								  from webservice
								 where companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
								       <cfif structkeyexists( arguments, "requesttype" )>
										and webservicerequesttype = <cfqueryparam value="#arguments.requesttype#" cfsqltype="cf_sql_varchar" />
									   </cfif>
							</cfquery>									
							<cfreturn vancosettings >							
					</cffunction>


					<cffunction name="getvancoerrorcodes" access="remote" returntype="query" output="false" hint="I get the list of vanco error codes.">
						<cfargument name="errorcodes" type="any" required="yes" default="11">
						<!--- // get the vanco web services error list  --->
							<cfset var vancoerrorcodes = "" />
							<cfquery datasource="#application.dsn#" name="vancoerrorcodes">
								select vancoerrorcodeid, vancoerrorcode, vancoerrorcodedescr
								  from vancoerrorcodes
								 where vancoerrorcode in( <cfqueryparam value="#arguments.errorcodes#" cfsqltype="cf_sql_numeric" list="yes" /> )
							  order by vancoerrorcodeid asc
							</cfquery>									
							<cfreturn vancoerrorcodes >							
					</cffunction>
					
					<cffunction name="vancoDecrypt" access="remote" returntype="string" output="false" hint="I decrypt the vanco response for output.">
						<cfargument name="dotnetpath" default="#expandpath('apis/dotnet/vanco/cryption.dll')#" required="no" />
						<cfargument name="nvpvar" type="string" required="yes">							
						<cfargument name="theKey" required="yes" type="string" default="none" />				
							
							<!--- // create a new instance of our .net object and reference our new DLL path --->
							<cfobject
								type=".NET"				
								class="Cryption.CryptionUtils"
								assembly="#arguments.dotnetpath#"
								name="decryptVancoResponse">				
							
									<!--- // intialize our custom vanco .net component --->
									<cfset decryptVancoResponse.init() />				
									<cfset message = arguments.nvpvar />
									<cfset setDecryptedMessage = decryptVancoResponse.DecryptAndDecodeMessage( message, arguments.theKey ) />
									<cfset thisDecryptedMessage = setDecryptedMessage />											
							
							<cfreturn thisDecryptedMessage>
					</cffunction>
					
					<!--- // encrypt for vanco transaction --->
					<cffunction name="vancoEncrypt" access="remote" returntype="string" output="false" hint="I encrypt the vanco client data for processing.">
						<cfargument name="dotnetpath" default="#expandpath('apis/dotnet/vanco/cryption.dll')#" required="no" />
						<cfargument name="nvpvar" type="string" required="yes">							
						<cfargument name="theKey" required="yes" type="string" default="none" />
							
							<!--- // create a new instance of our .net object and reference our component path --->
							<cfobject
								type=".NET"				
								class="Cryption.CryptionUtils"
								assembly="#arguments.dotnetpath#"
								name="encryptVancoPacket">				
							
								<!--- // intialize our custom vanco .net component --->
								<cfset encryptVancoPacket.init() />				
								<cfset message = arguments.nvpvar />
								<cfset getEncryptedMessage = encryptVancoPacket.EncryptAndEncodeMessage( message, arguments.theKey ) />
								<cfset thisEncryptedMessage = replace( replace(  getEncryptedMessage, "+", "-", "all"), "/", "_", "all" )>			
							
							<cfreturn thisEncryptedMessage>		
					</cffunction>
					
			</cfcomponent>