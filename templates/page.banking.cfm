

			
			
			<!--- // get our data access components --->			
			
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>

			<cfinvoke component="apis.com.esign.esigngateway" method="getesigninfo" returnvariable="esigninfo">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>		
			
			<!--- // declare form variables --->			
			<cfparam name="bankname" default="">
			<cfparam name="routing" default="">
			<cfparam name="accountnumber" default="">			
			<cfparam name="today" default="">
			<cfparam name="abano" default="false">
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			<!--- lead summary page --->	
			
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
										<h3>Banking and ACH Details for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>					
									</div> <!-- //.widget-header -->
								</cfoutput>	
							
								<div class="widget-content">			
									

										<!--- // validate CFC Form Processing --->							
										<cfif structkeyexists( form, "mform" )>
										
											<cfif form.mform eq 1>
												<cfif structkeyexists( form, "paymenttype" )>													
													<!--- // update the clients payment type --->
													<cfquery datasource="#application.dsn#" name="savepaymenttype">
														update esign
														   set esignpaytype = <cfqueryparam value="#trim( form.paymenttype )#" cfsqltype="cf_sql_varchar" />
														 where esid = <cfqueryparam value="#esigninfo.esid#" cfsqltype="cf_sql_integer" />
													</cfquery>
													<cflocation url="#application.root#?event=#url.event#" addtoken="no">
												</cfif>
											</cfif>
											
										<cfelse>
										
											<cfif isDefined("form.fieldnames")>
												
												<cfscript>
													objValidation = createObject("component","apis.com.ui.validation").init();
													objValidation.setFields(form);
													objValidation.validate();
												</cfscript>

												
												<!--- // if there ar eno errors, allow the data access operation --->
												<cfif objValidation.getErrorCount() is 0>

													
													<cfif structkeyexists( form, "gformid" )>
													
															
															<cfif form.gformid eq 3>								
														
																<!--- // declare form vars --->	
																<cfset lead = structnew() />
																<cfset lead.leadid = #form.leadid# />
																<cfset lead.leadname = #trim( form.leadname )# />
																<cfset lead.account = #trim( form.accountnumber )# />
																<cfset lead.routing = #trim( rereplacenocase( form.routingnumber, "[^0-9]", "", "all" ))# />
																<cfset lead.accttype = #trim( form.accttype )# />
																<cfset lead.bankname = #trim( form.bankname )# />

																<!--- // admin banking settings --->
																<cfif isdefined( "form.achhold" )>
																	<cfset lead.achhold = trim( form.achhold ) />
																</cfif>
																
																<cfif isdefined( "form.achholddate" )>
																	<cfset lead.achholddate = form.achholddate />
																</cfif>
																
																<cfif isdefined( "form.achholdreason" )>
																	<cfset lead.achholdreason = form.achholdreason />
																</cfif>
																
																<!--- // some other variables --->
																<cfset today = #createodbcdatetime(now())# />					
																
																<cfif len( lead.routing ) eq 9>
																
																	<!--- // include the necessary udfs --->
																	<cfinclude template="../apis/udfs/validateABA.cfm">
																
																	<!--- // check to make sure the routing number is valid, call the udf --->
																	<cfset abano = isAba( form.routingnumber )>
																
																
																	<cfif abano is true>
																
																		<!--- // update the clients bank account info --->
																		<cfquery datasource="#application.dsn#" name="savebankinginfo">
																				update esign
																				   set esignbankname = <cfqueryparam value="#lead.bankname#" cfsqltype="cf_sql_varchar" />,
																					   esignaccttype = <cfqueryparam value="#lead.accttype#" cfsqltype="cf_sql_varchar" />,
																					   esignrouting = <cfqueryparam value="#lead.routing#" cfsqltype="cf_sql_varchar" />,															   
																					   esignaccount = <cfqueryparam value="#lead.account#" cfsqltype="cf_sql_varchar" />
																				 where leadid = <cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />							
																		</cfquery>
																		
																		
																		<!--- // check for admin banking settings vars --->
																		<cfif structkeyexists( lead, "achhold" )>												
																			<cfquery datasource="#application.dsn#" name="saveadminsettings">
																					update leads
																					   set leadachhold = <cfqueryparam value="#lead.achhold#" cfsqltype="cf_sql_char" />
																						   
																						   <cfif structkeyexists( lead, "achholddate" )>
																						   , leadachholddate = <cfqueryparam value="#lead.achholddate#" cfsqltype="cf_sql_date" />
																						   </cfif>
																						   
																						   <cfif structkeyexists( lead, "achholdreason" )>
																						   , leadachholdreason = <cfqueryparam value="#lead.achholdreason#" cfsqltype="cf_sql_varchar" />
																						   </cfif>
																						   
																					 where leadid = <cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />							
																			</cfquery>
																		</cfif>
																		<!--- // log the activity ---> 
																		<cfquery datasource="#application.dsn#" name="logact">
																			insert into activity(leadid, userid, activitydate, activitytype, activity)
																				values (
																						<cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />,
																						<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																						<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																						<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
																						<cfqueryparam value="#session.username# saved the banking details for #lead.leadname#" cfsqltype="cf_sql_varchar" />
																						); select @@identity as newactid
																		</cfquery>											

																		<!--- // log the activity as recent --->
																		<cfquery datasource="#application.dsn#">
																			insert into recent(userid, leadid, activityid, recentdate)
																				values (
																						<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																						<cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />,
																						<cfqueryparam value="#logact.newactid#" cfsqltype="cf_sql_integer" />,
																						<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />
																						);
																		</cfquery>
																	
																		<!--- // task automation 
																		<cfinvoke component="apis.com.tasks.taskautomation" method="marktaskcompleted" returnvariable="taskmsg">
																			<cfinvokeargument name="leadid" value="#session.leadid#">
																			<cfinvokeargument name="taskref" value="banking">
																		</cfinvoke>
																		--->											
																	
																		<!--- // redirect --->
																		<cflocation url="#application.root#?event=#url.event#&msg=bksaved" addtoken="no">											
																
																
																	<cfelse>
																
																		<cfoutput>
																			<div class="alert alert-error">
																				<a class="close" data-dismiss="alert">&times;</a>
																					<h5><error>Sorry, there were errors in your submission:</error></h2>
																					<ul>
																						<li class="formerror"><cfoutput>#form.routingnumber#</cfoutput> is an invalid routing number.  Please check your input.</li>																
																					</ul>
																			</div>
																		</cfoutput>
																
																	</cfif>											
																
																<cfelse>
																
																	<div class="alert alert-error">
																		<a class="close" data-dismiss="alert">&times;</a>
																			<h5><error>Sorry, there were errors in your submission:</error></h2>
																			<ul>
																				<li class="formerror"><cfoutput>#lead.routing#</cfoutput> is an invalid routing number.  Must be 9 digits in length.  Please check your input.</li>																
																			</ul>
																	</div>
																
																</cfif>
																
															<cfelse>
															
															
																	<!--- // declare form vars --->	
																	<cfset lead = structnew() />
																	<cfset lead.leadname = form.leadname />
																	<cfset lead.leadid = form.leadid />
																	<cfset lead.ccname = trim( form.ccname ) />
																	<cfset lead.ccnum = rereplace( form.ccacctnum, "[^0-9,]", "", "all" ) />
																	<cfset lead.ccexpdate = trim( form.ccexpdate ) />
																	<cfset lead.ccv2 = trim( form.ccv2 ) />																	
																	<cfset today = #createodbcdatetime(now())# />	
																		
																		
																		<!--- // update the clients bank account info --->
																		<cfquery datasource="#application.dsn#" name="saveccinfo">
																				update esign
																				   set esignccnumber = <cfqueryparam value="#lead.ccnum#" cfsqltype="cf_sql_varchar" />,
																					   esignccexpdate = <cfqueryparam value="#lead.ccexpdate#" cfsqltype="cf_sql_varchar" />,
																					   esignccv2 = <cfqueryparam value="#lead.ccv2#" cfsqltype="cf_sql_varchar" />,															   
																					   esignccname = <cfqueryparam value="#lead.ccname#" cfsqltype="cf_sql_varchar" />
																				 where leadid = <cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />							
																		</cfquery>
																		
																		<!--- // log the activity ---> 
																		<cfquery datasource="#application.dsn#" name="logact">
																			insert into activity(leadid, userid, activitydate, activitytype, activity)
																				values (
																						<cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />,
																						<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																						<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																						<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
																						<cfqueryparam value="#session.username# saved the client credit card payment information for #lead.leadname#" cfsqltype="cf_sql_varchar" />
																						); select @@identity as newactid
																		</cfquery>											

																		<!--- // log the activity as recent --->
																		<cfquery datasource="#application.dsn#">
																			insert into recent(userid, leadid, activityid, recentdate)
																				values (
																						<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																						<cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />,
																						<cfqueryparam value="#logact.newactid#" cfsqltype="cf_sql_integer" />,
																						<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />
																						);
																		</cfquery>
																
																
																		<!--- // redirect --->
																		<cflocation url="#application.root#?event=#url.event#&msg=ccsaved" addtoken="no">
																
																
															
															
															
															</cfif>
														
													</cfif>
										
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
											</cfif>
										</cfif><!--- // end check on form type --->
										<!--- // end form processing --->

									
									
										<!--- // sidebar navigation --->									
										<div class="span3">					
											<cfinclude template="page.sidebar.nav.cfm">			
										</div> <!-- /.span3 -->
			
			
										<div class="span8">
											
											<div class="tabbable">
												<!---
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
														
															<h3><i class="icon-money"></i> Payment Information</h3>										
															<p>Please select the payment type and enter the appropriate Automated Cleating House (ACH) or Credit Card information to use the integrated client payment automation. 
															
															<br /><br />															
															
															<!--- // set the value of the payment type first in order to determine which form to show the user --->
															<form name="getpaymenttype" class="form-horizontal" method="post" action="#cgi.script_name#?event=#url.event#">																
																<div class="control-group">											
																	<label class="control-label" for="paymenttype"><strong>Payment Type</strong></label>
																		<div class="controls">																	
																			<select name="paymenttype" class="input-medium" onchange="javascript:this.form.submit();">
																				<option value="ACH"<cfif trim( esigninfo.esignpaytype ) is "ach">selected</cfif>>ACH</option>
																				<option value="CC"<cfif trim( esigninfo.esignpaytype ) is "cc">selected</cfif>>Credit Card</option>
																			</select>
																		</div>								
																		<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
																		<input type="hidden" name="mform" value="1" />
																</div>															
															</form>
															
															
															
															
															
															
															
															
															
															
															
															
															<cfif trim( esigninfo.esignpaytype ) is "ach">
																<form id="editpaymentsettings" class="form-horizontal" method="post" action="#application.root#?event=#url.event#">
																	
																	<fieldset>																
																															
																		
																		<div class="control-group">											
																			<label class="control-label" for="bankname">Name of Bank</label>
																			<div class="controls">
																				<input type="text" class="input-large" name="bankname" id="bankname" value="<cfif isdefined( "form.bankname" )>#form.bankname#<cfelse><cfif esigninfo.esignbankname is not "">#esigninfo.esignbankname#<cfelse>Bank Name Not Saved</cfif></cfif>" />
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->

																		<div class="control-group">
																			<label class="control-label" for="accttype">Account Type</label>
																				<div class="controls">
																					<label class="radio">
																						<input type="radio" name="accttype" value="Checking" <cfif trim( esigninfo.esignaccttype ) is "checking">checked</cfif>>
																							Checking
																					</label>
																					<label class="radio">
																						<input type="radio" name="accttype" value="Savings" <cfif trim( esigninfo.esignaccttype ) is "savings">checked</cfif>>
																							Savings
																						</label>
																				</div>	
																		</div>
																		
																		<div class="control-group">											
																			<label class="control-label" for="routingnumber">Routing Number</label>
																			<div class="controls">
																				<input type="text" class="input-medium" name="routingnumber" id="routingnumber" value="<cfif isdefined( "form.routingnumber" )>#form.routingnumber#<cfelse><cfif esigninfo.esignrouting is not "">#trim( esigninfo.esignrouting )#</cfif></cfif>" />
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->

																		<div class="control-group">											
																			<label class="control-label" for="accountnumber">Account Number</label>
																			<div class="controls">
																				<input type="text" class="input-medium" name="accountnumber" id="accountnumber" value="<cfif isdefined( "form.accountnumber" )>#form.accountnumber#<cfelse><cfif esigninfo.esignaccount is not "">#trim( esigninfo.esignaccount )#</cfif></cfif>">
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->

																		<!---
																		<div class="control-group">											
																			<label class="control-label" for="accountnumber2">Confirm Account Number</label>
																			<div class="controls">
																				<input type="text" class="input-medium" name="accountnumber2" id="accountnumber2">
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		--->
																		<br /><br />

																		
																		<cfif not isuserinrole( "counselor" ) and not isuserinrole( "bclient" )>
																		<!--- // for admin only --->
																		
																		<h6><i class="icon-exclamation-sign"></i> Administrative Settings </h6>
																		<hr style="margin-top:5px;margin-bottom:10px;">
																		
																		
																		
																			<div class="control-group">											
																				<label class="control-label" for="accountnumber">ACH Hold</label>
																				<div class="controls">
																					<select class="input-small" name="achhold" id="achhold">
																						<option value="Y"<cfif trim( leaddetail.leadachhold ) is "Y">selected</cfif>>YES</option>
																						<option value="N"<cfif trim( leaddetail.leadachhold ) is "N">selected</cfif>>NO</option>
																					</select>
																				</div> <!-- /controls -->				
																			</div> <!-- /control-group -->
																			
																			<cfif trim( leaddetail.leadachhold ) is "Y">
																			
																				<div class="control-group">											
																					<label class="control-label" for="achholddate">ACH Hold Date</label>
																					<div class="controls">
																						<input type="text" class="input-medium" name="achholddate" id="datepicker-inline3" value="<cfif isdefined( "form.achholddate" )>#form.achholddate#<cfelse>#dateformat( leaddetail.leadachholddate, "mm/dd/yyyy" )#</cfif>" />
																					</div> <!-- /controls -->				
																				</div> <!-- /control-group -->

																				<div class="control-group">											
																					<label class="control-label" for="achholdreason">ACH Hold Reason</label>
																					<div class="controls">
																						<input type="text" class="input-xlarge" name="achholdreason" id="achholdreason" value="<cfif isdefined( "form.achholdreason" )>#form.achholdreason#<cfelse>#leaddetail.leadachholdreason#</cfif>" />
																					</div> <!-- /controls -->				
																				</div> <!-- /control-group -->
																				
																			
																			</cfif>
																		
																		
																		
																		
																		</cfif>																
																		
																		<div class="form-actions">																		
																			<button type="submit" class="btn btn-secondary" name="saveachdetails"><i class="icon-save"></i> Save Banking</button>																		
																			<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.summary'"><i class="icon-remove-sign"></i> Cancel</a>																	
																			<input name="utf8" type="hidden" value="&##955;">													
																			<input type="hidden" name="gformid" value="3" />
																			<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
																			<input type="hidden" name="leadname" value="#leaddetail.leadfirst# #leaddetail.leadlast#" />
																			<input type="hidden" name="__authToken" value="#randout#" />
																			<input name="validate_require" type="hidden" value="leadid|Lead ID is a required field.;routingnumber|Please enter the last routing number.;accountnumber|Please enter the account number." />																									
																		</div> <!-- / .form-actions -->
																		
																	</fieldset>
																</form>
															</cfif>
															
															
															
															<cfif trim( esigninfo.esignpaytype ) is "CC">
															
																<form id="editccpaymentsettings" class="form-horizontal" method="post" action="#application.root#?event=#url.event#">
																	
																	<fieldset>			
																		
																		<div class="control-group">											
																			<label class="control-label" for="ccexpdate"><strong>Card Holder Name</strong></label>
																			<div class="controls">
																				<input type="text" class="input-large" name="ccname" id="ccname" value="<cfif isdefined( "form.ccname" )>#form.ccname#<cfelse><cfif esigninfo.esignccname is not "">#trim( esigninfo.esignccname )#</cfif></cfif>">
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<div class="control-group">											
																			<label class="control-label" for="ccacctnum"><strong>Account Number</strong></label>
																			<div class="controls">
																				<input type="text" class="input-large" name="ccacctnum" id="ccacctnum" value="<cfif isdefined( "form.ccacctnum" )>#form.ccacctnum#<cfelse><cfif esigninfo.esignccnumber is not "">#trim( esigninfo.esignccnumber )#</cfif></cfif>" />
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->

																		<div class="control-group">											
																			<label class="control-label" for="ccexpdate"><strong>Expiration Date</strong></label>
																			<div class="controls">
																				<input type="text" class="input-mini" name="ccexpdate" id="ccexpdate" value="<cfif isdefined( "form.ccexpdate" )>#form.ccexpdate#<cfelse><cfif esigninfo.esignccexpdate is not "">#trim( esigninfo.esignccexpdate )#</cfif></cfif>">
																				<span class="help-block">Enter in the format MM/YY</span>
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->

																		<div class="control-group">											
																			<label class="control-label" for="ccexpdate"><strong>Security Code</strong></label>
																			<div class="controls">
																				<input type="text" class="input-mini" name="ccv2" id="ccv2" value="<cfif isdefined( "form.ccv2" )>#form.ccv2#<cfelse><cfif esigninfo.esignccv2 is not "">#trim( esigninfo.esignccv2 )#</cfif></cfif>">
																				<span class="help-block">Please enter the 3 digit code on the back of the card.  AMEX is 4 digits on front of card.</span>																		
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		
																		
																		<br /><br />							
																		
																		
																		
																																	
																		
																		<div class="form-actions">																		
																			<button type="submit" class="btn btn-secondary" name="saveachdetails"><i class="icon-save"></i> Save Credit Card </button>																		
																			<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.summary'"><i class="icon-remove-sign"></i> Cancel</a>																	
																			<input name="utf8" type="hidden" value="&##955;">													
																			<input type="hidden" name="gformid" value="4" />
																			<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
																			<input type="hidden" name="leadname" value="#leaddetail.leadfirst# #leaddetail.leadlast#" />
																			<input type="hidden" name="__authToken" value="#randout#" />
																			<input name="validate_require" type="hidden" value="leadid|Lead ID is a required field.;ccacctnum|Please enter the credit card number.;ccexpdate|Please enter the credit card expiration date.;ccname|Please enter the credit card name.;ccv2|Please enter the credit card security code." />																									
																		</div> <!-- / .form-actions -->
																		
																	</fieldset>
																</form>
															
															</cfif>
															
															
															
															
															
															
														</cfoutput>				
													</div> <!-- / . tab1 -->										 
												
												</div> <!-- / .tab-content -->
											
											</div> <!-- / .tabbable -->

										</div> <!-- / .span8 -->
									
					
								</div> <!-- / .widget-content -->
							
							</div> <!-- / .widget-stacked -->
						
						</div> <!-- / .span12 -->
					
					</div> <!-- / .row -->
				
				</div> <!-- / .container -->
			
			</div> <!-- / .main -->
		
		
		