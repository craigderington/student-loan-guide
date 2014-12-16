

			
			
					<!--- *********************     VANCO LOGIN    ********************************  --->
					<!--- ****************  Post to URL and Decrypt Response  ********************   --->
					<!--- *************** Save Session and Request ID Variables ******************   --->
					
					<!--- // 
					
					        this page is automatically triggered daily, by the CFAdmin's Scheduled Task function, 
							provides each company with vanco login session id management for vanco web services

						 //
					--->
					
					
					<div class="main">
					
						<div class="container">
						
							<div class="row">
							
								<div class="span12">
								
										<div class="widget stacked">
											
											<cfoutput>
												<div class="widget-header">
													<i class="icon-cogs"></i> 
													<h3>#session.companyname# | System Information | Vanco Web Services | Service Login</h3>				
												</div>
											</cfoutput>
											
											
											<div class="widget-content">		
											
											
												<cfquery datasource="#application.dsn#" name="getcompanylogin">						
													select webserviceid, companyid, webserviceisactive
													  from webservice
													 where webserviceprovidername = <cfqueryparam value="Vanco" cfsqltype="cf_sql_varchar" />
													   and webservicerequesttype = <cfqueryparam value="login" cfsqltype="cf_sql_varchar" />
													   and webserviceisactive = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />
													   and companyid = <cfqueryparam value="#session.companyid#" cfsqltype="cf_sql_integer" />
												</cfquery>

												<cfif getcompanylogin.recordcount eq 1>						
													
													<!--- // get our vanco settings   --->		
													<cfinvoke component="apis.dotnet.vanco.vanco-functions" method="getvancosettings" returnvariable="vancosettings">
														<cfinvokeargument name="companyid" value="#getcompanylogin.companyid#">
														<cfinvokeargument name="requesttype" value="login">
													</cfinvoke>							
											
													<!-- define url params --->			
													<cfparam name="nvpvar" default="" >
													<cfparam name="requesttype" default="" >
													<cfparam name="userid" default="" >
													<cfparam name="password" default="" />
												
													<!--- // set post url values --->
													<cfset posturl = vancosettings.webserviceposturl />	
													<cfset requesttype = vancosettings.webservicerequesttype />
													<cfset userid = vancosettings.webserviceloginuserid />
													<cfset password = vancosettings.webserviceloginpassword />			
													<cfset thisrequestid = dateformat( now(), "mmddyy" ) & timeformat( now(), "mmss" ) & numberformat( randrange( 1,9999 ), "00000000" ) />
																	
													<!--- // HTTP post to vanco server for login and session id response 
														  // the Vanco Response will be encrypted, we'll get to that later --->
														  
															<cfhttp url="#posturl#requesttype=#requesttype#&userid=#userid#&password=#password#&requestid=#thisrequestid#" 
																	method="GET" 					
																	throwonerror="yes"
																	charset="utf-8"
																	result="result">						
															</cfhttp>													
														
															<!--- // for testing 
															<cfdump var="#result#" label="Vanco Response">															
															<cfdump var="#getcompanylogin#" label="This Dump">
															<cfdump var="#vancosettings#" label="Vanco Dump">
															--->
															<!--- // if the connection to the server responds 200 OK - process the login --->
															<cfif result.statuscode neq "200 OK">
															
																<cfoutput>
																	<p>HTTP Error: #result.statusCode#</p>
																	<p>Content: #htmldecode( result.filecontent )#</p>
																	<p>Response Header: #result.responseHeader#</p>
																	<p>Text: #result.text#</p>
																</cfoutput>
																
															<cfelse>					
																
																<!--- // the server responsed 200 OK, let's continue
																	 // set vanvco server response to a variable    --->
																<cfset nvpvar = result.filecontent />
																
																	<!--- // strip the "nvpvar=" from the decrypted response and setup the 
																			 string to create the required variables                  --->
																
																	<cfset nvpvarlen = len( nvpvar ) />				
																	<cfset nvpvar2 = mid( nvpvar, 8, nvpvarlen ) />		
															
															
																	<!--- // call the decryption component to decrypt the vanco login response --->				
																	<cfinvoke component="apis.dotnet.vanco.vanco-functions" method="vancodecrypt" returnvariable="thisdecryptedmessage">
																		<cfinvokeargument name="companyid" value="#session.companyid#">
																		<cfinvokeargument name="theKey" value="#vancosettings.webserviceapiencryptkey#" />
																		<cfinvokeargument name="nvpvar" value="#nvpvar2#">					
																	</cfinvoke>
															
																	<!--- // we need to create the required variables for the rest of the Vanco API.
																		  // specifically, each company transaction must have a valid session ID.									
																		 //  dump our decrypted response variable into session and requestid variables 
																		 //  separate the variables by the & symbol --->
																		
																		<cfset newsessionid = listfirst( thisdecryptedmessage, "&" ) />
																		<cfset newrequestid = listlast( thisdecryptedmessage, "&" ) />				
																		
																		<!--- // now separate the item values from the item label --->
																		<cfset newsessionid = listlast( newsessionid, "=" ) />
																		<cfset newrequestid = listlast( newrequestid, "=" ) />
															
																		<!--- // save the new values to the database for the company webservice account --->
																		<cfquery datasource="#application.dsn#" name="saveloginsession">
																			update webservice
																			   set webservicelastlogindatetime = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp" />,
																				   webservicesessionid = <cfqueryparam value="#newsessionid#" cfsqltype="cf_sql_varchar" />,
																				   webservicerequestid = <cfqueryparam value="#newrequestid#" cfsqltype="cf_sql_varchar" />,
																				   webserviceisactive = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
																			 where webserviceid = <cfqueryparam value="#vancosettings.webserviceid#" cfsqltype="cf_sql_integer" />				
																		</cfquery>
																		
																		<!--- // update any additional vanco services --->
																		<cfquery datasource="#application.dsn#" name="getvancoservices">
																			 select webserviceid
																			   from webservice
																			  where companyid = <cfqueryparam value="#getcompanylogin.companyid#" cfsqltype="cf_sql_integer" />
																				and webserviceprovidername = <cfqueryparam value="Vanco" cfsqltype="cf_sql_varchar" />
																				and ( 
																					   webservicerequesttype = <cfqueryparam value="efttransparentredirect" cfsqltype="cf_sql_varchar" />
																				 or    webservicerequesttype = <cfqueryparam value="eftaddcompletetransaction" cfsqltype="cf_sql_varchar" /> 
																					)
																		</cfquery>
																		
																		<cfloop query="getvancoservices">
																			<cfquery datasource="#application.dsn#" name="savealtservicessessionid">
																				update webservice
																				   set webservicelastlogindatetime = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp" />,
																					   webservicesessionid = <cfqueryparam value="#newsessionid#" cfsqltype="cf_sql_varchar" />,
																					   webservicerequestid = <cfqueryparam value="#newrequestid#" cfsqltype="cf_sql_varchar" />,
																					   webserviceisactive = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
																				 where webserviceid = <cfqueryparam value="#getvancoservices.webserviceid#" cfsqltype="cf_sql_integer" />				
																			</cfquery>
																		</cfloop>
																		
															
																		<cfoutput>															
																				
																			<h4><i class="icon-check"></i> Vanco Client Services | Successful Login Message</h4>					
																			<p>New Session ID: #newsessionid#</p>
																			<p>New Request ID: #newrequestid#</p>
																			<p style="margin-top:10px;"><i>Your Vanco Web Services are now ready for use...</i></p>
															
																		</cfoutput>
																		
															</cfif><!-- / .status code -->
														
												<cfelse>
												
													<h5 style="color:red;"><i class="icon-warning-sign"></i> Sorry, there was a problem with the Vanco login service record.  The record could not be found.</h5>
												
												</cfif>
												
												
												<cfif isuserinrole( "admin" ) or isuserinrole( "co-admin" )>
													<cfoutput>														
														<a href="#application.root#?event=page.settings.webservices" class="btn btn-small btn-secondary" style="margin-top:25px;margin-left:10px;"><i class="icon-circle-arrow-left"></i> Back to Web Services</a>
														<a href="#application.root#?event=page.settings" class="btn btn-small btn-primary" style="margin-top:25px;margin-left:5px;"><i class="icon-cogs"></i> Company Settings</a>
														<a href="#application.root#?event=page.admin" class="btn btn-small btn-default" style="margin-top:25px;margin-left:5px;"><i class="icon-list-alt"></i> Administration</a>
													</cfoutput>
												</cfif>									
												
												
											</div><!--/ .widget-content -->
												
										</div><!-- / .widget -->
											
								</div><!-- / .span12 -->
										
							</div><!-- / .row -->
									
							<div style="margin-top:200px;"></div>
									
									
						</div><!-- / .container -->
								
					</div><!-- / .main -->