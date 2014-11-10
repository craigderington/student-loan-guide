
	
	
	
	
	
				<!--- // get our data access components --->
				
				<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
					<cfinvokeargument name="leadid" value="#session.leadid#">
				</cfinvoke>

				<cfinvoke component="apis.com.clients.clientgateway" method="getclientfees" returnvariable="clientfees">
					<cfinvokeargument name="leadid" value="#session.leadid#">
				</cfinvoke>
					
				
				
				<cfif structkeyexists( form, "saveVancoBillingDetails" ) >
				
				
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
						<cfset urltoredirect = "http://67.79.186.26/sladmin/index.cfm" />
						<cfset isdebitcardonly = "no" />				
					
						<!--- // end encrypted values --->
				
				
						<!--- // create our Vanco client variable "envpvar" string to be encrypted --->
						<cfset nvpvar = "requesttype=" & requesttype & "&requestid=" & requestid & "&clientid=" & clientid & "&urltoredirect=" & urltoredirect & "&customerid=" & customerid & "&isdebitcardonly=" & isdebitcardonly />
					
					
					
						<!--- // call the encryption component to encrypt our vanco nvpvar data packet --->				
						<cfinvoke component="apis.dotnet.vanco.vanco-functions" method="vancoencrypt" returnvariable="thisencryptedmessage">							
							<cfinvokeargument name="theKey" value="#vancosettings.webserviceapiencryptkey#" />
							<cfinvokeargument name="nvpvar" value="#nvpvar#">					
						</cfinvoke>
						
					
					
					
						
				
							<!-- // define additional variables --->
							
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
							<cfset billingstate = trim( form.billingstate ) />
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
									
							<!---// check the status code from the cfhttp --->
							<cfif result.statusCode neq "200 OK">
							
								<cfoutput>									
									<h3>HTTP Error</h3>
									<p>#result.statusCode#<p>
									<p>#htmleditformat( result.filecontent )#</p>
								</cfoutput>
							
							<cfelse>
								
								<!--- 
								      // since our post was successful, the 'nvpvar' will be in the
								      // file content property of our response object.  assign a
									  // new variable, set the value and prepare string for decryption 
							    --->
								<cfset vanco_r = result.filecontent />
								<cfset nvpvar = listlast( vanco_r, "=" ) />
								<cfset nvpvar = listfirst( nvpvar, '"' ) />							
							
							</cfif>					
							
							<!---
							<cfdump var="#result#" label="HTTP Result">
							<cfdump var="#variables#" label="Vanco Response">
							<cfdump var="#form#" label="Form Scope">
							--->
							
							
				</cfif>
		
							
							
							<!---
							<cfdump var="#result#" label="Response">
							--->
							
							
													<cfoutput>
															
															<form id="create-vanco-payment-method" class="form-horizontal" method="post" action="#application.root#?event=#url.event#">
																	
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
																				<input type="text" class="input-large" name="accountnumber" id="accountnumber" value="<cfif isdefined( "form.ccacctnum" )>#form.ccacctnum#</cfif>" />
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->

																		<div class="control-group">											
																			<label class="control-label" for="ccexpdate"><strong>Expiration Date</strong></label>
																			<div class="controls">
																				<input type="text" class="input-mini" name="expmonth" id="expmonth" value="<cfif isdefined( "form.expmonth" )>#form.expmonth#</cfif>" />  <input type="text" class="input-mini" name="expyear" id="expyear" value="<cfif isdefined( "form.expyear" )>#form.expyear#</cfif>" />
																				<span class="help-block">Enter as MM / YY</span>
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->																																		
																		
																		
																		<hr style="margin-top:5px;margin-bottom:5px;color:gray;">
																		
																		<h5><i class="icon-home"></i> Billing Address</h5>
																		
																		<br />							
																		
																		<div class="control-group">											
																			<label class="control-label" for="billingaddress"><strong>Billing Address</strong></label>
																			<div class="controls">
																				<input type="text" class="input-large" name="billingaddr1" id="billingaddr1" value="<cfif isdefined( "form.billingaddress" )>#form.billingaddress#</cfif>">
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<div class="control-group">											
																			<label class="control-label" for="billingcity"><strong>City</strong></label>
																			<div class="controls">
																				<input type="text" class="input-large" name="billingcity" id="billingcity" value="<cfif isdefined( "form.billingcity" )>#form.billingcity#</cfif>" />
																				<input type="text" class="input-mini" name="billingstate" id="billingstate" value="<cfif isdefined( "form.billingstate" )>#form.billingstate#</cfif>" maxlength="2" />
																				<input type="text" class="input-small" name="billingzip" id="billingzip" value="<cfif isdefined( "form.billingzip" )>#form.billingzip#</cfif>" />
																			
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<br /><br />															
																		
																		<div class="form-actions">																		
																			<button type="submit" class="btn btn-secondary" name="saveVancoBillingDetails"><i class="icon-save"></i> Save Payment Method </button>																		
																			<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.summary'"><i class="icon-remove-sign"></i> Cancel</a>																	
																			<input name="utf8" type="hidden" value="&##955;">													
																			<input type="hidden" name="gformid" value="4" />
																			<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
																			<input type="hidden" name="paymentmethod" value="CC" />
																			<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
																			<input type="hidden" name="leadname" value="#leaddetail.leadfirst# #leaddetail.leadlast#" />
																			<input type="hidden" name="__authToken" value="#randout#" />
																			<input name="validate_require" type="hidden" value="leadid|Lead ID is a required field.;ccacctnum|Please enter the credit card number.;expmonth|Please enter the credit card expiration date.;ccname|Please enter the credit card name.;billingaddress|Please enter the billing address.;billingcity|Please enter the billing city.;billingstate|Please enter the state initials.;billingzip|Please enter the billing zip code." />																									
																		</div> <!-- / .form-actions -->
																		
																	</fieldset>
																</form>																							
														
														</cfoutput>
							
							
							
							
							
							
							