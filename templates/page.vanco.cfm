

			
			
			<!--- // get our data access components --->				
			
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>		

			<cfinvoke component="apis.com.esign.esigngateway" method="getesigninfo" returnvariable="esigninfo">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
	
			<!--- // add components for vanco web services --->
			<cfinvoke component="apis.com.webservices.webservices" method="getwebservices" returnvariable="webservices">
				<cfinvokeargument name="companyid" value="#session.companyid#">
			</cfinvoke>
			
			<!--- get the specific webservice detail for the vanco login service to make sure it is active --->
			<cfinvoke component="apis.com.webservices.webservices" method="getwebservice" returnvariable="webservicedetail">
				<cfinvokeargument name="wsid" value="#webservices.webserviceuuid[1]#">				
			</cfinvoke>
			
			<!--- // get list of client vanco transactions --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getvancotransactions" returnvariable="vancotransactions">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<!--- // get list of client vanco credit card charge transactions --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getvancocharges" returnvariable="vancochargelist">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<!--- // get the list of client fees to charge the client credit card --->
			<cfinvoke component="apis.com.clients.clientgateway" method="getclientfees" returnvariable="clientfees">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfparam name="webserviceslist" default="">
			<cfset webserviceslist = valuelist( webservices.webservicerequesttype, "," ) />
			
			
			
			
			<!--- // declare form variables --->			
			<cfparam name="bankname" default="">
			<cfparam name="routing" default="">
			<cfparam name="accountnumber" default="">			
			<cfparam name="today" default="">
			<cfparam name="abano" default="false">
			
			
			<cfset today = #createodbcdatetime(now())# />
			
			
			
			<!--- vanco payment processing page --->	
			
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
						
							<!--- // system messages --->
							
							<cfif structkeyexists(url, "msg") and url.msg is "bksaved">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-info">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong><i class="icon-check"></i>SUCCESS!</strong>  The banking details were successfully updated.  Please use the navigation in the sidebar to continue...
										</div>										
									</div>								
								</div>
							<cfelseif structkeyexists(url, "msg") and url.msg is "ccsaved">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-info">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong><i class="icon-check"></i>SUCCESS!</strong>  The client credit card information was successfully updated.  Please use the navigation in the sidebar to continue...
										</div>										
									</div>								
								</div>
							</cfif>	
							
							
							<!--- start page content + details and draw form --->
							
							<div class="widget stacked">
								
								<cfoutput>	
									<div class="widget-header">		
										<i class="icon-ok"></i>							
										<h3>Vanco Services | Banking Details for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>					
									</div> <!-- //.widget-header -->
								</cfoutput>	
							
								<div class="widget-content">							

										<!--- // validate CFC Form Processing --->								
										
										<cfif isdefined( "form.fieldnames" )>
												
											<cfscript>
												objValidation = createobject( "component","apis.com.ui.validation" ).init();
												objValidation.setFields( form );
												objValidation.validate();
											</cfscript>
											
											<!--- // if there are no errors, begin vanco data operations --->
											<cfif objValidation.getErrorCount() is 0>
												
												<cfif structkeyexists( form, "vwsid" ) and isvalid( "uuid", form.vwsid ) >
													
													<cfinvoke component="apis.dotnet.vanco.vanco-functions" method="getvancosettings" returnvariable="vancosettings">
														<cfinvokeargument name="companyid" value="#session.companyid#">
														<cfinvokeargument name="requesttype" value="efttransparentredirect">
													</cfinvoke>									
										
													<!--- // define vanco url and post variables --->
													<cfparam name="sessionid" default="">
													<cfparam name="posturl" default="">					
													<cfparam name="nvpvar" default="">
													<cfparam name="thisencryptedmessage" default="">													
												
													<!--- // set our vanco api session variables
														  // and request type post url          --->
													<cfset sessionid = vancosettings.webservicesessionid />			
													<cfset posturl = vancosettings.webserviceposturl />								
											
											
													<!--- // begin encrypted variables //
														 //  these variables must be encrypted --->
										
													<!--- // define params for encryption --->					
													<cfparam name="requesttype" default="">
													<cfparam name="requestid" default="">
													<cfparam name="clientid" default="">
													<cfparam name="urltoredirect" default="">
													<cfparam name="customerid" default=""> 
													<cfparam name="customerref" default=""> 
													<cfparam name="isdebitcardonly" default="">
												
													<!--- // set variables --->
													<cfset requesttype = vancosettings.webservicerequesttype />
													<cfset requestid = dateformat( now(), "mmddyy" ) & timeformat( now(), "mmss" ) & numberformat( randrange( 1,9999 ), "00000000" ) />
													<cfset clientid = vancosettings.webserviceclientid />
													<cfset customerid = leaddetail.leadid />
													<cfset urltoredirect = "https://www.studentloanadvisoronline.com/index.cfm" />
													<cfset isdebitcardonly = "no" />										
													<!--- // end encrypted values --->										
										
													<!--- // create our Vanco client variable "envpvar" string to be encrypted --->
													<cfset nvpvar = "requesttype=" & requesttype & "&requestid=" & requestid & "&clientid=" & clientid & "&urltoredirect=" & urltoredirect & "&customerid=" & customerid & "&isdebitcardonly=" & isdebitcardonly />
																														
													<!--- // call the encryption component to encrypt our vanco nvpvar data packet --->				
													<cfinvoke component="apis.dotnet.vanco.vanco-functions" method="vancoencrypt" returnvariable="thisencryptedmessage">							
														<cfinvokeargument name="theKey" value="#vancosettings.webserviceapiencryptkey#" />
														<cfinvokeargument name="nvpvar" value="#nvpvar#">					
													</cfinvoke>
										
													<!-- // define any additional variables --->
													
													<cfparam name="accounttype" default="">
													<cfparam name="accountnumber" default="">
													<cfparam name="expmonth" default="">
													<cfparam name="expyear" default="">
													<cfparam name="name" default="">
													<cfparam name="email" default="">
													<cfparam name="billingaddr1" default="">
													<cfparam name="billingcity" default="">
													<cfparam name="billingstate" default="">
													<cfparam name="billingzip" default="">
													<cfparam name="name_on_card" default="">
													
													<!--- // set our variables --->							
													<cfset nvpvar = thisencryptedmessage />					
													<cfset accounttype = form.paymentmethod />
													<cfset accountnumber = form.accountnumber />
													<cfset expmonth = form.expmonth />
													<cfset expyear = form.expyear />
													<cfset name = trim( listlast( form.ccname, " " ) & "," & listfirst( form.ccname, " " ) )  />
													<cfset email = trim( leaddetail.leademail ) />
													<cfset billingaddr1 = urlencodedformat( form.billingaddr1 ) />
													<cfset billingcity = trim( form.billingcity ) />
													<cfset billingstate = trim( ucase( form.billingstate )  ) />
													<cfset billingzip = trim( form.billingzip ) />
													<cfset name_on_card = urlencodedformat( form.ccname ) />											
													
													<!--- // now post the client transactions to the vanco api via cfhttp ---> 
													<cfhttp url="#posturl#sessionid=#sessionid#&accounttype=#accounttype#&accountnumber=#accountnumber#&expmonth=#expmonth#&expyear=#expyear#&name=#name#&email=#email#&billingaddr1=#billingaddr1#&billingcity=#billingcity#&billingstate=#billingstate#&billingzip=#billingzip#&name_on_card=#name_on_card#&nvpvar=#nvpvar#" 
														method="GET" 					
														throwonerror="yes"
														charset="utf-8"
														result="result"
														redirect="yes">	
														
													</cfhttp>											
													
													<!--- // check the status code from the cfhttp 
													         if the status code is not 200 'OK' --->
													<cfif result.statusCode neq "200 OK">
														
														<div class="alert alert-block alert-error">
															<a class="close" data-dismiss="alert">&times;</a>																
																<cfoutput>									
																	<h5><i class="icon-cogs"></i> HTTP Error</h5>
																	<p>#result.statusCode#<p>
																	<p>#htmleditformat( result.filecontent )#</p>
																</cfoutput>																
														</div>			
													
													
													<!--- // http result status code 200 'OK' --->
													<cfelse>

														<!--- 
															  // since our http post was successful, the 'nvpvar' will be in the
															  // file content property of our response object.  assign a
															  // new variable, set the value and prepare string for decryption 
														--->
														
														<cfset vanco_r = result.filecontent />	
													
														<!--- // next, save our client data to the credit card section --->														
														<cfquery datasource="#application.dsn#" name="saveccinfo">
															update esign
															   set esignccnumber = <cfqueryparam value="#accountnumber#" cfsqltype="cf_sql_varchar" />,
																   esignccexpdate = <cfqueryparam value="#expmonth##expyear#" cfsqltype="cf_sql_varchar" />,																   															   
																   esignccname = <cfqueryparam value="#name_on_card#" cfsqltype="cf_sql_varchar" />,
																   esignacctadd1 = <cfqueryparam value="#billingaddr1#" cfsqltype="cf_sql_varchar" />,
																   esignacctcity = <cfqueryparam value="#billingcity#" cfsqltype="cf_sql_varchar" />,
																   esignacctstate = <cfqueryparam value="#ucase( billingstate )#" cfsqltype="cf_sql_varchar" />,
																   esignacctzipcode = <cfqueryparam value="#billingzip#" cfsqltype="cf_sql_varchar" />
															 where leadid = <cfqueryparam value="#leaddetail.leadid#" cfsqltype="cf_sql_integer" />							
														</cfquery>																											
														
														<!--- // 
																now output the response object.														        
																the redirect variable is stored in the 
																page meta refresh url tag, with a val .2 
																the nvpvar is appended to the query string 
																this is the best method for extracting
																the response encrypted nvpvar string var
														--->				
														
														<cfoutput>
															#vanco_r#
														</cfoutput>
														
													</cfif><!-- / .statuscode -->							
													
												</cfif><!-- /.vws in form -->											
													
										
											<!--- If the required data is missing - throw the validation error --->
											<cfelse>
													
												<div class="alert alert-error">
													<a class="close" data-dismiss="alert">&times;</a>
														<h5><error>There were <cfoutput>#objValidation.getErrorCount()#</cfoutput> errors in your submission:</error></h2>
															<ul>
																<cfloop collection="#variables.objValidation.getMessages()#" item="rr">
																	<li class="formerror"><cfoutput>#variables.objValidation.getMessage(rr)#"</cfoutput></li>
																</cfloop>
															</ul>
												</div>										
												
											</cfif>
										
										</cfif><!--- // end form processing --->

									
									
										<!--- // sidebar navigation --->									
										<div class="span3">					
											<cfinclude template="page.sidebar.nav.cfm">			
										</div> <!-- /.span3 -->
			
			
										<div class="span8">
											
											<div class="tabbable">
												<!--- // CLD 2-20-2014 // move to sidebar separate workflow
												<cfoutput>
													<ul class="nav nav-tabs">
														<li>
															<a href="#application.root#?event=page.summary">Profile</a>
														</li>
														<li>
															<a href="#application.root#?event=page.lead.login">User Login</a>
														</li>
														<li class="active">
															<a href="#application.root#?event=page.banking">ACH Details</a>
														</li>
													</ul>
												</cfoutput>												
												--->

												<div class="tab-content">					
													
													<div class="tab-pane active" id="tab1">
														<cfoutput>
														
															<h3><i class="icon-building"></i> Vanco Client Services | Integrated Payment Processing</h3>										
															<p>Please use the integrated Vanco Web Services to add client payment method information and bill client credit cards. To learn more about PCI Level 1 Compliant Integrated Solutions, please visit <a href="https://www.vancoservices.com/secure/clients_financial-instituitions.html" target="_blank">Vanco Services</a>.	&nbsp;&nbsp;<i class="icon-info-sign"></i> For standard, non-integrated banking and payment options, <a href="#application.root#?event=page.banking">please click here</a>.</p>	
															
															<!--- // is the login web service active --->
															<cfif webservicedetail.webserviceisactive eq 1>																
																
																<!--- // if the login service is active, do we have a valid web service session id --->
																<cfif ( webservicedetail.webservicesessionid is not "" ) and ( len( webservicedetail.webservicesessionid ) eq 40 )>																	
																	
																	<cfif not structkeyexists( url, "fuseaction" ) and not structkeyexists( url, "reqtype" ) and not structkeyexists( url, "vws_error" )>
																		
																		<cfif listfind( webserviceslist, "efttransparentredirect", "," )>
																			
																			<cfif vancotransactions.recordcount eq 0>
																				<a href="#application.root#?event=#url.event#&fuseaction=addpaymentmethod" class="btn btn-small btn-secondary"><i class="icon-credit-card"></i> Add New Payment Method </a>
																			</cfif>
																			
																			<!--- // if valid payment method reference number
																					 exists allow agency to charge the card   --->
																			<cfif vancotransactions.recordcount gt 0>
																				
																				<cfif vancotransactions.paymentmethodref[1] neq "" and vancotransactions.customerref[1] neq "">
																					
																					<div style="padding:15px;margin-top:10px;">
																						
																						<h6 style="color:red;"><i class="icon-check"></i> #vancotransactions.recordcount# Vanco Payment Method<cfif vancotransactions.recordcount gt 1>s</cfif> Found </h6>
																						
																						
																						<div class="span4">
																							<small>
																								<ul>																	
																									<li>Vanco Customer Reference: #vancotransactions.customerref#</li>
																									<li>Vanco Payment Method Reference: #vancotransactions.paymentmethodref#</li>
																									<li>Name: #vancotransactions.name_on_card#</li>
																									<li>Billing Address: #vancotransactions.billingaddr1# #vancotransactions.billingcity#, #vancotransactions.billingstate# #vancotransactions.billingzip#
																									<li>Session Date: #dateformat( vancotransactions.transdatetime, "mm/dd/yyyy" )# #timeformat( vancotransactions.transdatetime, "hh:mm:ss tt" )#
																									<li>Session ID: #vancotransactions.sessionid#
																									<li>Request ID: #vancotransactions.requestid#
																								<ul>
																							</small>
																						</div>
																						
																						<div class="span3">
																							<h5><i class="icon-check"></i> &nbsp;Fees Due</h5>
																							<cfif clientfees.recordcount eq 0>
																								<p><a href="#application.root#?event=page.fees">Fees Not Set</a></p>
																							<cfelse>
																								<p>Fee Due Date: #dateformat( clientfees.feeduedate[1], "mm/dd/yyyy" )#</p>
																								<p>Fee Amount: #dollarformat( clientfees.feeamount[1] )#</p>
																							</cfif>
																							
																							<cfif clientfees.recordcount gt 0>
																								<cfif ( clientfees.feepaiddate[1] eq "" ) and ( trim( clientfees.feestatus[1] ) neq "paid" ) >
																									<cfif trim( clientfees.feepaytype[1] ) eq "cc">
																										<a href="#application.root#?event=#url.event#.eftaddcompletetransaction&feeid=#clientfees.feeuuid[1]#" style="margin-top:10px;" class="btn btn-medium btn-danger" onclick="javascript:confirm('Are you sure you want to charge the clients credit card?');"><i class="icon-credit-card"></i> Charge Payment Method #dollarformat( clientfees.feeamount[1] )# </a>
																									<cfelse>
																										<span class="label label-important">Fee payment type not set to credit card...</span>
																									</cfif>
																								<cfelse>
																									<ul>
																										<li>Fee Amount: #dollarformat( clientfees.feepaid[1] )#</li>
																										<li>Fee Paid Date: #dateformat( clientfees.feepaiddate[1], "mm/dd/yyyy" )#</li>
																										<li>Fee Status: <span class="label label-success">#clientfees.feestatus[1]#</span> 
																									</ul>
																								</cfif>
																							<cfelse>
																								<h5 style="color:red;"><i class="icon-warning-sign"></i> Sorry, fees not set...  <a href="#application.root#?event=page.fees"> Please click here to create fees.</a></h5>
																							</cfif>
																						</div>
																						
																					</div>																					
																					
																					
																				</cfif>
																			
																			</cfif>
																		
																		
																			<cfelse>
																					<h6 style="color:red;"><i class="icon-warning-sign"></i> Sorry, Vanco Web Services not properly configured.  Please contact your Company Administrator.</h6>
																			
																			</cfif>
																	
																		</cfif>
																
																<cfelse>
																	
																	<h5 style="color:red;"><i class="icon-warning-sign"></i> The Vanco Login Web Service has an invalid session ID.  Please notify your company administrator to refresh the login service.</h5>
															
																	
																</cfif><!-- / .invalid session id -->
																
															<cfelse>
															
															
																<h5 style="color:red;"><i class="icon-warning-sign"></i> The Vanco Login Web Service is inactive.  Please notify your company administrator.</h5>
															
															
															</cfif><!-- / .check to make sure the web service is active and we have a valid session id --->
															
															<cfif structkeyexists( url, "fuseaction" ) and ( trim( url.fuseaction ) eq "addpaymentmethod" )>
																
																<hr >
																<br />
																<form id="efttransparentredirect" class="form-horizontal" method="post" action="#application.root#?event=#url.event#&fuseaction=efttransparentredirect">
																	
																	<fieldset>			
																		
																		<div class="control-group">											
																			<label class="control-label" for="ccexpdate"><strong>Card Holder Name</strong></label>
																			<div class="controls">
																				<input type="text" class="input-large" name="ccname" id="ccname" value="<cfif isdefined( "form.ccname" )>#form.ccname#</cfif>">
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<div class="control-group">											
																			<label class="control-label" for="ccacctnum"><strong>Account Number</strong></label>
																			<div class="controls">
																				<input type="text" class="input-large" name="accountnumber" id="accountnumber" value="<cfif isdefined( "form.accountnumber" )>#form.accountnumber#</cfif>" />
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->

																		<div class="control-group">											
																			<label class="control-label" for="ccexpdate"><strong>Expiration Date</strong></label>
																			<div class="controls">
																				<input type="text" class="input-mini" name="expmonth" id="expmonth" value="<cfif isdefined( "form.expmonth" )>#form.expmonth#</cfif>" />  <input type="text" class="input-mini" name="expyear" id="expyear" value="<cfif isdefined( "form.expyear" )>#form.expyear#</cfif>" />
																				<span class="help-block">Enter as MM / YY</span>
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->																																		
																		
																		
																		<hr style="margin-top:10px;margin-bottom:5px;color:gray;">
																		
																		<h5 style="margin-top:10px;"><i class="icon-home"></i> Billing Address</h5>
																		
																		<br />							
																		
																		<div class="control-group">											
																			<label class="control-label" for="billingaddress"><strong>Billing Address</strong></label>
																			<div class="controls">
																				<input type="text" class="input-large" name="billingaddr1" id="billingaddr1" value="<cfif isdefined( "form.billingaddr1" )>#form.billingaddr1#</cfif>">
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<div class="control-group">											
																			<label class="control-label" for="billingcity"><strong>City, State, Zip</strong></label>
																			<div class="controls">
																				<input type="text" class="input-large" name="billingcity" id="billingcity" value="<cfif isdefined( "form.billingcity" )>#form.billingcity#</cfif>" />
																				<input type="text" class="input-mini" name="billingstate" id="billingstate" value="<cfif isdefined( "form.billingstate" )>#ucase( form.billingstate )#</cfif>" maxlength="2" />
																				<input type="text" class="input-small" name="billingzip" id="billingzip" value="<cfif isdefined( "form.billingzip" )>#form.billingzip#</cfif>" />
																			
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<br /><br />															
																		
																		<div class="form-actions">																		
																			<button type="submit" class="btn btn-secondary" name="save-vanco-payment-method"><i class="icon-save"></i> Save Payment Method </button>																		
																			<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=#url.event#'"><i class="icon-remove-sign"></i> Cancel</a>																	
																			<input name="utf8" type="hidden" value="&##955;">													
																			<input type="hidden" name="mformid" value="4" />
																			<input type="hidden" name="paymentmethod" value="CC" />
																			<input type="hidden" name="vwsid" value="#createuuid()#">
																			<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
																			<input type="hidden" name="leadname" value="#leaddetail.leadfirst# #leaddetail.leadlast#" />
																			<input type="hidden" name="__authToken" value="#randout#" />
																			<input name="validate_require" type="hidden" value="leadid|Lead ID is a required field.;accountnumber|Please enter the credit card number.;expmonth|Please enter the credit card expiration month.;expyear|Please enter the credit card expiration year;ccname|Please enter the credit card name.;billingaddr1|Please enter the billing address.;billingcity|Please enter the billing city.;billingstate|Please enter the state initials.;billingzip|Please enter the billing zip code." />																									
																		</div> <!-- / .form-actions -->
																		
																	</fieldset>
																</form>
															
															<cfelseif structkeyexists( url, "fuseaction" ) and ( trim( url.fuseaction ) eq "efttransparentredirect" )>
																<div style="padding:25px;">
																	<p><i style="color:orange;" class="icon-spinner icon-spin icon-2x"></i></p>
																	<p><small> Please wait....  Processing...</p>
																</div>
															</cfif>
															
															
															
															<cfif structkeyexists( url, "vws_error" )>
																<cfparam name="errorcode" default="#url.vws_error#">
																<cfset errorcode = #url.vws_error# />
																<cfinvoke component="apis.dotnet.vanco.vanco-functions" method="getvancoerrorcodes" returnvariable="vancoerrorcodes">
																	<cfinvokeargument name="errorcodes" value="#errorcode#">
																</cfinvoke>
																
																
																<div class="alert alert-error">
																	<a class="close" data-dismiss="alert">&times;</a>
																		<h5><error>Sorry, your transaction was not successful:</error></h2>
																			<ul>
																				<cfloop query="vancoerrorcodes">
																					<li class="formerror">Error Code: #vancoerrorcode# - #vancoerrorcodedescr#</li>
																				</cfloop>
																			</ul>
																</div>			
																
																<a href="#application.root#?event=#url.event#" class="btn btn-small btn-primary"><i class="icon-building"></i> Vanco Home</a><cfif vancotransactions.recordcount eq 0><a style="margin-left:7px;" href="#application.root#?event=#url.event#&fuseaction=addpaymentmethod" class="btn btn-small btn-secondary"><i class="icon-circle-arrow-right"></i> Try Again!</a><cfelse><a style="margin-left:7px;" href="#application.root#?event=#url.event#.eftaddcompletetransaction" class="btn btn-small btn-secondary"><i class="icon-circle-arrow-right"></i> Try Again!</a></cfif>
																
																
															</cfif>
															
															<cfif structkeyexists( url, "reqtype" ) and structkeyexists( url, "status" )>
																<cfif ( trim( url.reqtype ) eq "efttransparentredirect" ) and ( trim( url.status ) eq "ok" )>
																	<h5 style="color:green;"><i class="icon-check icon-2x"></i> Success!  Your payment method was successfully added.  Your transaction details are below:</h5>
																	<p>You will now be able to charge the client credit card in the next step.</p>
																	<a href="#application.root#?event=#url.event#" class="btn btn-large btn-primary"><i class="icon-check"></i> OK</a>
																<cfelseif ( trim( url.reqtype ) is "eftaddcompletetransaction" ) and ( trim( url.status ) eq "ok" )>															
																	<h5 style="text-size:14px;color:green;"><i class="icon-check icon-2x"></i> Success!  Your credit card transaction completed successfully...</h5>
																	<p style="margin-top:-15px;">Please see the specific transaction details below under the section Vanco Transaction Log</p>
																	<a href="#application.root#?event=#url.event#" class="btn btn-small btn-secondary"><i class="icon-check"></i> OK</a>
																<cfelse>
																	<h3><i class="icon-exclamation-sign icon-2x"></i> System Error</h3>
																</cfif>
															</cfif>								
															
														</cfoutput>				
													</div> <!-- / . tab1 -->										 
												
												</div> <!-- / .tab-content -->
											
											</div> <!-- / .tabbable -->
											
											
											
											<!--- // if the credit card charge list recordset is empty 
											         don't show this section --->
												
											<cfif vancochargelist.recordcount gt 0>									
											
												<div class="row">
													<div style="padding:25px;">
														<hr>
														<h5 style="margin-top:25px;"><i class="icon-list-alt"></i> &nbsp; Vanco Credit Card Transaction Log</h5>
																				
															<small>
																<table class="table table-striped">															
																	<thead>
																		<tr>
																			<th>Trans Date</th>
																			<th>Pay Ref</th>
																			<th>Amount</th>
																			<th>Cust Ref</th>
																			<th>Req ID</th>
																			<th>Auth Code</th>
																			<th>Card Type</th>
																			<th>Status</th>
																		</tr>
																	</thead>
																	<tbody>
																		<cfoutput query="vancochargelist">
																		<tr>
																			<td>#dateformat( requestdate, "yyyy-mm-dd" )# #timeformat( requestdate, "hh:mm:ss tt" )#</td>
																			<td>#paymentmethodref#</td>
																			<td>#dollarformat( paymentamount )#</td>
																			<td>#customerref#</td>
																			<td>#requestid#</td>
																			<td>#ccauthcode#</td>
																			<td>#cardtype#</td>
																			<td><i style="color:green;" class="icon-check"></i></td>
																		</tr>
																		</cfoutput>
																	</tbody>
																</table>
															</small>														
													</div>										
												</div>
											</cfif>		
													
													
													
													
													
													
										</div> <!-- / .span8 -->
									
					
								</div> <!-- / .widget-content -->
							
							</div> <!-- / .widget-stacked -->
						
						</div> <!-- / .span12 -->
					
					</div> <!-- / .row -->
				
				</div> <!-- / .container -->
			
			</div> <!-- / .main -->
		
		
		