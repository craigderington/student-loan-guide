

			
			
					
					
					
					
					<!--- // do we need to login to vanco and refresh the session id's ?  --->		
					<cfinvoke component="apis.dotnet.vanco.vanco-functions" method="getvancosettings" returnvariable="vancosettings">
						<cfinvokeargument name="companyid" value="#session.companyid#">
						<cfinvokeargument name="requesttype" value="login">
					</cfinvoke>		
			
					<!-- url params --->			
					<cfparam name="nvpvar" default="" >
					<cfparam name="requesttype" default="" >
					<cfparam name="userid" default="" >
					<cfparam name="password" default="" />
				
					<!--- // set post url values --->
					<cfset posturl = vancosettings.webserviceposturl />	
					<cfset requesttype = vancosettings.requesttype />
					<cfset userid = vancosettings.webserviceloginuserid />
					<cfset password = vancosettings.webserviceloginpassword />			
					<cfset thisrequestid = dateformat( now(), "mmddyy" ) & timeformat( now(), "mmss" ) & numberformat( randrange( 1,9999 ), "00000000" ) />
									
					<!--- // call vanco server for login and session id response --->
					<cfhttp url="#posturl#requesttype=#requesttype#&userid=#userid#&password=#password#&requestid=#thisrequestid#" 
							method="GET" 					
							throwonerror="yes"
							charset="utf-8"
							result="result">						
					</cfhttp>			

					
					<!--- // if the connection to the server responds 200 OK - process the login --->
					<cfif result.statuscode neq "200 OK">
					
						<cfoutput>
							<p>HTTP Error: #result.statusCode#</p>
							<p>Content: #htmldecode( result.filecontent )#
						</cfoutput>
						
					<cfelse>					
						
						<!--- // the server responsed 200 OK, let's continue
						     // set vanvco server response to a variable    --->
						<cfset nvpvar = result.filecontent />
						
							<!--- // strip the "nvpvar=" from the decrypted response and setup the 
						             string to create the required variables --->
						
							<cfset nvpvarlen = len( nvpvar ) />				
							<cfset nvpvar2 = mid( nvpvar, 8, nvpvarlen ) />		
					
					
							<!--- // call the decryption component to decrypt the vanco login response --->				
							<cfinvoke component="apis.dotnet.vanco.vanco-functions" method="vancodecrypt" returnvariable="thisdecryptedmessage">
								<cfinvokeargument name="companyid" value="#session.companyid#">
								<cfinvokeargument name="theKey" value="#vancosettings.webserviceapiencryptkey#" />
								<cfinvokeargument name="nvpvar" value="#nvpvar2#">					
							</cfinvoke>
					
							<!--- // we need to create the required variables for the Vanco API 
							     //  dump our decrypted response variable into session and requestid 
								 //  separate the variables by the & symbol --->
								<cfset newsessionid = listfirst( thisdecryptedmessage, "&" ) />
								<cfset newrequestid = listlast( thisdecryptedmessage, "&" ) />				
								
								<!--- // separate from the value label --->
								<cfset newsessionid = listlast( newsessionid, "=" ) />
								<cfset newrequestid = listlast( newrequestid, "=" ) />
					
								<!--- // save the new values to the database for the company webservice account --->
								<cfquery datasource="#application.dsn#" name="saveloginsession">
									update webservice
									   set webservicelastlogindate = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp" />,
										   webservicesessionid = <cfqueryparam value="#newsessionid#" cfsqltype="cf_sql_varchar" />,
										   webservicerequestid = <cfqueryparam value="#newrequestid#" cfsqltype="cf_sql_varchar" />
									 where webserviceid = <cfqueryparam value="#vancosettings.webserviceid#" cfsqltype="cf_sql_integer" />				
								</cfquery>
					
					
								<cfoutput>
					
								<div style="padding:50px;">
							
									<br /><br />
									<h4>Vanco Login &amp; Successful Login </h4>								
									
									<p><cfdump var="#vancosettings#" label="Vanco Login"></p>
									
									<p>Output: #thisdecryptedmessage#</p>			
							
									<p>New Session ID: #newsessionid#</p>
									<p>New Request ID: #newrequestid#</p>
									
								</div>
					
					</cfoutput>
					
					</cfif>
					
					
					
							
						