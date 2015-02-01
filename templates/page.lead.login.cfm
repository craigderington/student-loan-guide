

			
			
			<!--- // get our data access components --->			
			
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>

			<cfinvoke component="apis.com.leads.leadgateway" method="getleadloginprofile" returnvariable="qleadlogin">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.system.companysettings" method="getcompanysettings" returnvariable="companysettings">
				<cfinvokeargument name="companyid" value="#session.companyid#">
			</cfinvoke>
			
			<!--- // 12-23-2014 // get the company email template for this feature --->
			<cfinvoke component="apis.com.admin.emailtemplategateway" method="getemailtemplatebycat" returnvariable="emailtemplate">
				<cfinvokeargument name="companyid" value="#session.companyid#">
				<cfinvokeargument name="cat" value="client-login">
			</cfinvoke>
			
			
			
			
			<!--- // declare form variables --->			
			<cfparam name="leadusername" default="">
			<cfparam name="leadpassword" default="">
			<cfparam name="leadpassword2" default="">
			<cfparam name="leadactive" default="">
			<cfparam name="today" default="">
			
			
			
			<!--- lead summary page --->	
			
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
						
							<!--- // system messages --->
							
							<cfif structkeyexists(url, "msg") and url.msg is "saved">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-info">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong><i class="icon-check"></i>SUCCESS!</strong>  The lead's login details were successfully updated.  Please use the navigation in the sidebar to continue...
										</div>										
									</div>								
								</div>							
							</cfif>	
							
							
							<!--- start page content + details and draw form --->
							
							<div class="widget stacked">
								
								<cfoutput>	
									<div class="widget-header">		
										<i class="icon-ok"></i>							
										<h3>User Login Details for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>					
									</div> <!-- //.widget-header -->
								</cfoutput>	
							
								<div class="widget-content">			
									

									<!--- // validate CFC Form Processing --->							
									
									<cfif isDefined("form.fieldnames")>
										<cfscript>
											objValidation = createObject("component","apis.com.ui.validation").init();
											objValidation.setFields(form);
											objValidation.validate();
										</cfscript>

										
										<!--- // if there ar eno errors, allow the data access operation --->
										<cfif objValidation.getErrorCount() is 0>

											<!--- // declare form vars --->
											<cfset lead = structnew() />
											<cfset lead.leadid = #form.leadid# />
											<cfset lead.companyid = 445 />
											<cfset lead.deptid = 0 />
											<cfset lead.username = #trim( form.leadusername )# />
											<cfset lead.password = #trim( form.leadpassword )# />
											<cfset lead.firstname = #leaddetail.leadfirst# />
											<cfset lead.lastname = #leaddetail.leadlast# />
											<cfset lead.email = #leaddetail.leademail# />
											<cfset lead.acl = 1 />
											<cfset lead.role = "bclient" />
											
											<!--- // set the lead login status --->
											<cfif isdefined( "form.leadactive" )>
												<cfset lead.active = 1 />
											<cfelse>
												<cfset lead.active = 0 />
											</cfif>
											
											<!--- // some other variables --->
											<cfset today = #createodbcdatetime(now())# />									
											
											<!--- // determine of we need to create the login or update an existing record --->
											<cfif structkeyexists( form, "createleadlogin" )>
											
												<cfquery datasource="#application.dsn#" name="checkusername">
													select userid, username
													  from users
													 where username = <cfqueryparam value="#lead.username#" cfsqltype="cf_sql_varchar" />													 
												</cfquery>												
													
													<cfif checkusername.recordcount gt 0>
														
														<cfoutput>
															<div class="alert alert-block alert-error">
																<a class="close" data-dismiss="alert">&times;</a>
																	<h5><error><i class="icon-warning-sign"></i> There were errors in your submission:</error></h5>
																	<p>The username entered #lead.username# is already in use on this system.  Please enter a different username.</p>
																	<p><a class="btn btn-default btn-small" href="#application.root#?event=#url.event#"><i style="margin-right:4px;" class="icon-plus-sign-alt"></i> Re-Enter Username</a></p>
															</div>
														</cfoutput>
														<cfabort>
													
													<cfelse>

															<!--- // create the lead user login insert record --->
															<cfquery datasource="#application.dsn#" name="createleadlogin">
																insert into users(useruuid,companyid,deptid,username,passcode,firstname,lastname,acl,role,active,email,leadid,leadwelcome)
																	values (
																			<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar" maxlength="35" />,
																			<cfqueryparam value="#lead.companyid#" cfsqltype="cf_sql_integer" />,
																			<cfqueryparam value="#lead.deptid#" cfsqltype="cf_sql_integer" />,
																			<cfqueryparam value="#lead.username#" cfsqltype="cf_sql_varchar" />,
																			<cfqueryparam value="#hash( lead.password, "SHA-384", "UTF-8" )#" cfsqltype="cf_sql_clob" />,
																			<cfqueryparam value="#lead.firstname#" cfsqltype="cf_sql_varchar" />,
																			<cfqueryparam value="#lead.lastname#" cfsqltype="cf_sql_varchar" />,
																			<cfqueryparam value="#lead.acl#" cfsqltype="cf_sql_integer" />,
																			<cfqueryparam value="#lead.role#" cfsqltype="cf_sql_varchar" />,
																			<cfqueryparam value="1" cfsqltype="cf_sql_bit" />,
																			<cfqueryparam value="#lead.email#" cfsqltype="cf_sql_varchar" />,
																			<cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />,
																			<cfqueryparam value="1" cfsqltype="cf_sql_bit" />
																			); 
															</cfquery>
														
															
															<cfquery datasource="#application.dsn#" name="checkportaltasks">
																select count(*) as totaltasks
																  from leadportaltasks
																 where leadid = <cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />												 
															</cfquery>
															
															<cfif checkportaltasks.totaltasks eq 0>													
															
																<!--- // create the client portal task list --->
																<cfquery datasource="#application.dsn#" name="getportaltasks">
																	select portaltaskid, portaltask
																	  from portaltasks						  
																</cfquery>
																
																<cfloop query="getportaltasks">													
																	<cfquery datasource="#application.dsn#" name="createportaltasks">
																		insert into leadportaltasks(portaltaskid, leadid, portaltaskcomp)
																			values(
																					<cfqueryparam value="#portaltaskid#" cfsqltype="cf_sql_integer" />,
																					<cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />,
																					<cfqueryparam value="0" cfsqltype="cf_sql_bit" />								
																				   );
																	</cfquery>												
																</cfloop>

															</cfif>											
															
															<!--- send the client a message with their login information --->
															<cfinvoke component="apis.com.comms.commsgateway" method="sendclientlogin" returnvariable="msgstatus">
																<cfinvokeargument name="leadid" value="#session.leadid#">
																<cfinvokeargument name="companyid" value="#session.companyid#">
																<cfinvokeargument name="cat" value="client-login">
																<cfinvokeargument name="companyemail" value="#companysettings.email#">
																<cfinvokeargument name="companyname" value="#companysettings.dba#">
																<cfinvokeargument name="sendto" value="#lead.username#">
																<cfinvokeargument name="templatepath" value="#emailtemplate.templatepath#">
															</cfinvoke>								
															
														
													</cfif>
													
											<!--- // update the existing lead user login details --->
											<cfelseif structkeyexists( form, "saveleadlogin" )>

												<!--- // get the existing user id from the database for the update --->
												<cfquery datasource="#application.dsn#" name="getleaduser">
													select userid, leadid
													  from users														   
													 where leadid = <cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />
												</cfquery>

												<!--- // save the lead's login information --->
												<cfquery datasource="#application.dsn#" name="saveleadlogin">
													update users
													   set username = <cfqueryparam value="#lead.username#" cfsqltype="cf_sql_varchar" />,
														   passcode = <cfqueryparam value="#hash( lead.password, "SHA-384", "UTF-8" )#" cfsqltype="cf_sql_clob" />,
														   active = <cfqueryparam value="#lead.active#" cfsqltype="cf_sql_bit" />
													 where userid = <cfqueryparam value="#getleaduser.userid#" cfsqltype="cf_sql_integer" />
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
															<cfqueryparam value="#session.username# saved the login details for #lead.firstname# #lead.lastname#." cfsqltype="cf_sql_varchar" />
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
											
											<!--- // task automation --->
											<cfinvoke component="apis.com.tasks.taskautomation" method="marktaskcompleted" returnvariable="taskmsg">
												<cfinvokeargument name="leadid" value="#session.leadid#">
												<cfinvokeargument name="taskref" value="userlogin">
											</cfinvoke>
											
											
											<!--- // redirect to the next step in the workflow --->
											<cfif structkeyexists( form, "createleadlogin" )>
												<cflocation url="#application.root#?event=#url.event#&msg=saved" addtoken="no">
											<cfelseif structkeyexists( form, "saveleadlogin" )>
												<cflocation url="#application.root#?event=#url.event#&msg=saved" addtoken="no">
											<cfelse>
												<cflocation url="#application.root#?event=#url.event#&msg=saved" addtoken="no">
											</cfif>											
											
								
										<!--- If the required data is missing - throw the validation error --->
										<cfelse>
										
											<div class="alert alert-error">
												<a class="close" data-dismiss="alert">&times;</a>
													<h5><error>There were <cfoutput>#objValidation.getErrorCount()#</cfoutput> errors in your submission:</error></h5>
													<ul>
														<cfloop collection="#variables.objValidation.getMessages()#" item="rr">
															<li class="formerror"><cfoutput>#variables.objValidation.getMessage(rr)#"</cfoutput></li>
														</cfloop>
													</ul>
											</div>
										
										</cfif>
									</cfif>
									
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
														<li class="active">
															<a href="#application.root#?event=page.lead.login">User Login</a>
														</li>
														<li>
															<a href="#application.root#?event=page.banking">ACH Details</a>
														</li>
													</ul>
												</cfoutput>												
												--->

												<div class="tab-content">					
													
													<div class="tab-pane active" id="tab1">
														<cfoutput>
														
															<h3><i class="icon-user"></i> User Login Information</h3>										
															<p>Your client will use the information below to login to the Student Loan Advisor system to complete enrollment, e-sign their enrollment agreement, answer the questionnaire and enter their budget and financial summary.  Clients will be able to communicate directly with their Student Loan Advisor.  Please ensure the username is in the correct email address format.  For password security, the notification email sent to the client will inform them the <strong>default password is set to the last 6 of their SSN</strong>.
															<br /><br />
															
															<form id="edit-lead-login-settings" class="form-horizontal" method="post" action="#application.root#?event=#url.event#">
																
																<fieldset>																
																														
																	
																	<div class="control-group">											
																		<label class="control-label" for="leadusername">User Name</label>
																		<div class="controls">
																			<input type="text" class="input-large" name="leadusername" id="leadusername" value="<cfif isdefined( "form.leadusername" )>#form.leadusername#<cfelse>#qleadlogin.username#</cfif>" />
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->						
																	
																	<div class="control-group">											
																		<label class="control-label" for="leadpassword">Password</label>
																		<div class="controls">
																			<input type="password" class="input-medium" name="leadpassword" id="leadpassword">
																			<span class="help-block">Set to last 6 of client SSN.</span>
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->

																	<div class="control-group">											
																		<label class="control-label" for="leadpassword2">Confirm Password</label>
																		<div class="controls">
																			<input type="password" class="input-medium" name="leadpassword2" id="leadpassword2">
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->

																	<div class="control-group">											
																		<label class="control-label" for="userrole">User Role</label>
																		<div class="controls">
																			<input type="text" class="input-medium readonly" name="userrole" id="userrole" value="Client" readonly="true">
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->

																	<cfif qleadlogin.recordcount neq 0>
																		<div class="control-group">											
																			<label class="control-label" for="useractive">User Active</label>
																			<div class="controls">
																				<input type="checkbox" class="input-medium" name="leadactive" id="leadactive" <cfif qleadlogin.active eq 1>checked</cfif>>
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																	<cfelse>
																		<input type="hidden" name="leadactive" value="1" />
																	</cfif>																
																	
																	<br /><br />						
																	
																	<div class="form-actions">													
																		<cfif qleadlogin.recordcount eq 0>
																			<button type="submit" class="btn btn-secondary" name="createleadlogin"><i class="icon-save"></i> Create User Login</button>
																		<cfelse>
																			<button type="submit" class="btn btn-secondary" name="saveleadlogin"><i class="icon-save"></i> Save User Login </button>
																		</cfif>
																		<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.summary'"><i class="icon-remove-sign"></i> Cancel</a>																	
																		<input name="utf8" type="hidden" value="&##955;">													
																		<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
																		<input type="hidden" name="__authToken" value="#randout#" />
																		<input name="validate_require" type="hidden" value="leadid|Lead ID is a required field.;leadpassword|Please enter the last 4 of the client's SSN for the password.;leadpassword2|Please confirm the login password." />
																		<input name="validate_email" type="hidden" value="leadusername|The client login username must be a valid e-mail address.  Please check your input and re-enter..." /> 
																		<input name="validate_password" type="hidden" value="leadpassword|leadpassword2|The passwords enetred do not match.  Please try again..." /> 						
																		
																	</div> <!-- / .form-actions -->
																	
																</fieldset>
															</form>
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
		
		
		