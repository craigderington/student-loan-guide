


						



							<!--- // 
					
							****************************************************************
							 
							 this is the complete eft add complete transaction vanco
							 service. now that we have a valid vanco customer ref
							 number and payment method reference number, we can actually
							 charge the client's credit card.
							 
							 we'll post this page, get the redirect and
							 handle our errors
							 
							 
							 ***************************************************************
				
							// --->
					
					
							<!--- // get list of the customer client vanco payment method reference transaction --->
							<cfinvoke component="apis.com.leads.leadgateway" method="getvancotransactions" returnvariable="vancotransactions">
								<cfinvokeargument name="leadid" value="#session.leadid#">
							</cfinvoke>
							
							<!--- // get the vanco webservice agency client data for this service --->
							<cfinvoke component="apis.dotnet.vanco.vanco-functions" method="getvancosettings" returnvariable="vancosettings">
								<cfinvokeargument name="companyid" value="#session.companyid#">
								<cfinvokeargument name="requesttype" value="eftaddcompletetransaction">
							</cfinvoke>

							<!--- // mark the fee as paid --->
							<cfset feeid = url.feeiD />
											
							<!--- // get the fee record by uuid --->
							<cfquery datasource="#application.dsn#" name="getfeedetail">
								select feeid, leadid, feeamount, feepaid, feeduedate, feepaiddate
							      from fees
								 where feeuuid = <cfqueryparam value="#feeid#" cfsqltype="cf_sql_varchar" maxlength="35" />
							</cfquery>	
							
							<!--- // url post vars --->
							<cfparam name="sessionid" default="">
							<cfparam name="posturl" default="">					
							<cfparam name="nvpvar" default="">
							<cfparam name="thisencryptedmessage" default="">				
							
							<!--- // begin encryption variables --->
							<cfparam name="requesttype" default="">
							<cfparam name="requestid" default="">
							<cfparam name="clientid" default="">					
							
							<!--- // client variables --->
							<cfparam name="customerref" default="">
							<cfparam name="customerid" default="">
							
							<!--- // not required fields --->
							<cfparam name="customername" default="">
							<cfparam name="customeraddress" default="">
							<cfparam name="customeraddress2" default="">
							<cfparam name="customercity" default="">
							<cfparam name="customerstate" default="">
							<cfparam name="customerzip" default="">
							
							<!---  // payment method reference number from the previous workflow step 
								   // efttransparentredirect service --->
								  
							<cfparam name="paymentmethodref" default="">
							<cfparam name="isdebitcardonly" default="yes">
							
							<!--- // payment amount variables --->
							<cfparam name="amount" default="">
							<cfparam name="startdate" default="">
							<cfparam name="frequencycode" default="O">
							<cfparam name="transactiontypecode" default="PPD">
							
							<!--- // assign our variables with real values --->					
							<cfset requesttype = vancosettings.webservicerequesttype />
							<cfset requestid = dateformat( now(), "mmddyy" ) & timeformat( now(), "mmss" ) & numberformat( randrange( 1,9999 ), "00000000" ) />
							<cfset clientid = vancosettings.webserviceclientid />					
							<cfset customerref = vancotransactions.customerref />					
							<cfset paymentmethodref = vancotransactions.paymentmethodref />
							<cfset amount = numberformat( getfeedetail.feeamount, "9.99" ) />
							<cfset startdate = dateformat( now(), "yyyy-mm-dd" ) />
							<cfset frequencycode = "O" />
							<cfset transactiontypecode = "PPD" />
							<cfset isdebitcardonly = "yes" />
							
							<!--- // set our vanco api session variables
								  // and request type post url          --->
							<cfset sessionid = vancosettings.webservicesessionid />			
							<cfset posturl = vancosettings.webserviceposturl />
										
							<!--- // create our Vanco client variable "envpvar" string to be encrypted --->
							<cfset nvpvar = "requesttype=" & requesttype & "&requestid=" & requestid & "&clientid=" & clientid & "&customerref=" & customerref & "&paymentmethodref=" & paymentmethodref & "&isdebitcardonly=" & isdebitcardonly & "&amount=" & amount & "&startdate=" & startdate & "&frequencycode=" & frequencycode & "&transactiontypecode=" & transactiontypecode />
											
							
							<!--- // call the encryption component to encrypt our vanco nvpvar data packet --->				
							<cfinvoke component="apis.dotnet.vanco.vanco-functions" method="vancoencrypt" returnvariable="thisencryptedmessage">							
								<cfinvokeargument name="theKey" value="#vancosettings.webserviceapiencryptkey#" />
								<cfinvokeargument name="nvpvar" value="#nvpvar#">					
							</cfinvoke>
							
							<cfset nvpvar = thisencryptedmessage />
							
							<!--- // now build our url for post --->
							<!--- // now post the client transactions to the vanco api via cfhttp ---> 
							<cfhttp url="#posturl#sessionid=#sessionid#&nvpvar=#nvpvar#" 
								method="GET" 					
								throwonerror="yes"
								charset="utf-8"
								result="result"
								redirect="yes">	
																
							</cfhttp>		
							
							<!--- // check the status code from the cfhttp --->
							<cfif result.statusCode neq "200 OK">
																
								<div class="alert alert-block alert-error">
									<a class="close" data-dismiss="alert">&times;</a>																
										<cfoutput>									
											<h5><i class="icon-cogs"></i> HTTP Error</h5>
											<p>#result.statusCode#<p>
											<p>#htmleditformat( result.filecontent )#</p>
										</cfoutput>																
								</div>			
															
							<cfelse>
																
									<!--- // the server responsed 200 OK, let's continue
										 // set vanvco server response to a variable    --->
							
							
									<cfset nvpvar = result.filecontent />
												
										<!--- // strip the "nvpvar=" from the decrypted response 
												 and setup the string to create the required variables  --->
												
										<cfset nvpvarlen = len( nvpvar ) />				
										<cfset nvpvar2 = mid( nvpvar, 8, nvpvarlen ) />		
											
											
										<!--- // call the decryption component to decrypt the vanco response --->				
										<cfinvoke component="apis.dotnet.vanco.vanco-functions" method="vancodecrypt" returnvariable="thisdecryptedmessage">
											<cfinvokeargument name="companyid" value="#session.companyid#">
											<cfinvokeargument name="theKey" value="#vancosettings.webserviceapiencryptkey#" />
											<cfinvokeargument name="nvpvar" value="#nvpvar2#">					
										</cfinvoke>
										
										
										<!--- // some variables we'll need for the next step --->			
										<cfset vancoresponse = thisdecryptedmessage />			
										<cfset thisarr = listtoarray( vancoresponse, "&", false, true ) />			
										<cfset thistransuuid = #createuuid()# />
										<cfset thisleadid = session.leadid />
										<cfset today = now() />
										
										<!--- 
										     // since the decrypted variable is a simple string, we need to break apart the string 
											 // and place our key pair values into a simple array,  we can then loop over the array 
											 // inserting the key pair values and labels into the database for later usage, showing
											 // the payment method, client number assigned by vanco and the payment method reference
											 // number that must now accompany the next step in the transaction.
										--->	 
										
										<cfloop array="#thisarr#" index="j">
											<cfset item = listfirst( j, "=" ) />
											<cfset thisitemvalue = listlast( j, "=" ) /> 					
											<!--- // save the decrypted vanco data so we can use it in our application ---> 
											<cfquery datasource="#application.dsn#" name="savevancodecryptdata">
												insert into vancodecryptdata(vancouuid, leadid, vancolabel, vancovalue)
													values(
															<cfqueryparam value="#thistransuuid#" cfsqltype="cf_sql_varchar" maxlength="35" />,
															<cfqueryparam value="#thisleadid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#item#" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#trim( thisitemvalue )#" cfsqltype="cf_sql_varchar" maxlength="250" />							
														   );
											</cfquery>		
											
										</cfloop>
										
										<!--- // check for errors // errorlist only included when there is an error
										         the successful transaction struct looks different ---->
										<cfquery datasource="#application.dsn#" name="checkvancodata">
											select vancolabel, vancovalue
											  from vancodecryptdata											 
											 where leadid = <cfqueryparam value="#thisleadid#" cfsqltype="cf_sql_integer" />
											   and vancouuid = <cfqueryparam value="#thistransuuid#" cfsqltype="cf_sql_varchar" maxlength="35" />
											   and vancolabel = <cfqueryparam value="errorlist" cfsqltype="cf_sql_varchar" />
										</cfquery>
										
										<!--- errorlist variable found in the response struct --->
										<cfif checkvancodata.recordcount gt 0>			

											<!--- // redirect to vanco page with error list --->
											<cflocation url="#application.root#?event=page.vanco&vws_error=#checkvancodata.vancovalue#" addtoken="no">
																
										
										<!--- // no errors found in the response struct --->
										<cfelse>								
										
											<!--- // get the individual values and create a structure --->			
											<cfquery datasource="#application.dsn#" name="getvancodata">					
												select leadid as thisvancolead,							
														(select vancovalue from vancodecryptdata where vancolabel = <cfqueryparam value="paymentmethodref" cfsqltype="cf_sql_varchar" /> and leadid = <cfqueryparam value="#thisleadid#" cfsqltype="cf_sql_integer" /> and vancouuid = <cfqueryparam value="#thistransuuid#" cfsqltype="cf_sql_varchar" maxlength="35" /> ) as thispaymethref,
														(select vancovalue from vancodecryptdata where vancolabel = <cfqueryparam value="transactionref" cfsqltype="cf_sql_varchar" /> and leadid = <cfqueryparam value="#thisleadid#" cfsqltype="cf_sql_integer" /> and vancouuid = <cfqueryparam value="#thistransuuid#" cfsqltype="cf_sql_varchar" maxlength="35" /> ) as thistransref,
														(select vancovalue from vancodecryptdata where vancolabel = <cfqueryparam value="customerref" cfsqltype="cf_sql_varchar" /> and leadid = <cfqueryparam value="#thisleadid#" cfsqltype="cf_sql_integer" /> and vancouuid = <cfqueryparam value="#thistransuuid#" cfsqltype="cf_sql_varchar" maxlength="35" /> ) as thiscustref,
														(select vancovalue from vancodecryptdata where vancolabel = <cfqueryparam value="requestid" cfsqltype="cf_sql_varchar" /> and leadid = <cfqueryparam value="#thisleadid#" cfsqltype="cf_sql_integer" /> and vancouuid = <cfqueryparam value="#thistransuuid#" cfsqltype="cf_sql_varchar" maxlength="35" /> ) as thisreqid,
														(select vancovalue from vancodecryptdata where vancolabel = <cfqueryparam value="ccauthcode" cfsqltype="cf_sql_varchar" /> and leadid = <cfqueryparam value="#thisleadid#" cfsqltype="cf_sql_integer" /> and vancouuid = <cfqueryparam value="#thistransuuid#" cfsqltype="cf_sql_varchar" maxlength="35" /> ) as thisccauthcode,
														(select vancovalue from vancodecryptdata where vancolabel = <cfqueryparam value="cardtype" cfsqltype="cf_sql_varchar" /> and leadid = <cfqueryparam value="#thisleadid#" cfsqltype="cf_sql_integer" /> and vancouuid = <cfqueryparam value="#thistransuuid#" cfsqltype="cf_sql_varchar" maxlength="35" /> ) as thiscardtype
												  from vancodecryptdata
												 where leadid = <cfqueryparam value="#thisleadid#" cfsqltype="cf_sql_integer" />
												   and vancouuid = <cfqueryparam value="#thistransuuid#" cfsqltype="cf_sql_varchar" maxlength="35" />
											  group by leadid				 
											</cfquery>
											
											
										
											<!--- // great, we have no errors, so let's go ahead and insert our response object data values 
											         the response object is a bit different, so our structure is a little bit different --->
											<cfquery datasource="#application.dsn#" name="savevancotransaction">
												insert into vancotransactions(vancotranslogid, vancouuid, leadid, customerref, paymentmethodref, transactionref, requestid, requestdate, paymentamount, ccauthcode, cardtype)
													values(
														   <cfqueryparam value="#vancotransactions.vancotranslogid#" cfsqltype="cf_sql_integer" />,
														   <cfqueryparam value="#thistransuuid#" cfsqltype="cf_sql_varchar" maxlength="35" />,
														   <cfqueryparam value="#getvancodata.thisvancolead#" cfsqltype="cf_sql_integer" />,												  
														   <cfqueryparam value="#getvancodata.thiscustref#" cfsqltype="cf_sql_varchar" />,
														   <cfqueryparam value="#getvancodata.thispaymethref#" cfsqltype="cf_sql_varchar" />,
														   <cfqueryparam value="#getvancodata.thistransref#" cfsqltype="cf_sql_varchar" />,
														   <cfqueryparam value="#getvancodata.thisreqid#" cfsqltype="cf_sql_varchar" />,												  
														   <cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
														   <cfqueryparam value="#amount#" cfsqltype="cf_sql_float" />,
														   <cfqueryparam value="#getvancodata.thisccauthcode#" cfsqltype="cf_sql_varchar" />,
														   <cfqueryparam value="#getvancodata.thiscardtype#" cfsqltype="cf_sql_varchar" />
																										   
														  );
											</cfquery>

											<!--- // mark the fee paid --->											
											<cfquery datasource="#application.dsn#" name="markfeepaid">
												update fees
												   set feepaid = <cfqueryparam value="#getfeedetail.feeamount#" cfsqltype="cf_sql_float" />,
												       feepaiddate = <cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
													   feestatus = <cfqueryparam value="PAID" cfsqltype="cf_sql_varchar" />,
													   feetrans = <cfqueryparam value="Y" cfsqltype="cf_sql_char" />,
													   feetransdate = <cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />
												 where feeid = <cfqueryparam value="#getfeedetail.feeid#" cfsqltype="cf_sql_integer" />
											</cfquery>
											
											<!--- // log the activity --->
											<cfquery datasource="#application.dsn#" name="logact">
												insert into activity(leadid, userid, activitydate, activitytype, activity)
													values (
															<cfqueryparam value="#getvancodata.thisvancolead#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
															<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#session.username# charged the clients credit card using Vanco Services." cfsqltype="cf_sql_varchar" />
															); select @@identity as newactid
											</cfquery>											

											<!--- // log the activity as recent --->
											<cfquery datasource="#application.dsn#">
												insert into recent(userid, leadid, activityid, recentdate)
													values (
															<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#getvancodata.thisvancolead#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#logact.newactid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />
															);
											</cfquery>				
											
											
											<!--- // redirect to the vanco payment page --->				
											<cflocation url="#application.root#?event=page.vanco&reqtype=#vancosettings.webservicerequesttype#&status=ok" addtoken="no">
										
										
										</cfif><!-- / .check for errors -->
											
																						
											
										
									

									
							</cfif><!-- / .statuscode -->
					
						