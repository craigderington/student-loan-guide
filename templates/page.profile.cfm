

			<!--- call the component to get the user profile --->
			<cfinvoke component="apis.com.users.usergateway" method="getuserprofile" returnvariable="quserprofile">
				<cfinvokeargument name="userid" value="#session.userid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.users.usergateway" method="getloginhistory" returnvariable="qloginhistory">
				<cfinvokeargument name="userid" value="#session.userid#">
			</cfinvoke>
			
			
			
			<!--- // the user profile page --->
			<div class="main">

				<div class="container">

					<div class="row">
					
					<cfif structkeyexists( url, "msg") and url.msg is "saved">
						<cfparam name="broadcastmessage" default="">
						<cfset broadcastmessage = "Your user profile was successfully updated..." />
						<div class="span12">	
							<div class="alert alert-success">
								<button type="button" class="close" data-dismiss="alert">&times;</button>
								<i class="icon-ok"></i> <cfoutput> #broadcastmessage#</cfoutput>
							</div>
						</div>						
					</cfif>
					
						<div class="span8">      		
							
							<div class="widget stacked ">
								
								<div class="widget-header">
									<i class="icon-user"></i>
									<h3>Edit Your User Profile</h3>
								</div> <!-- /widget-header -->
								
								<div class="widget-content">

									<!--- // begin form processing --->
									<cfif isDefined("form.fieldnames")>
										<cfscript>
											objValidation = createObject("component","apis.com.ui.validation").init();
											objValidation.setFields(form);
											objValidation.validate();
										</cfscript>

										<cfif objValidation.getErrorCount() is 0>							
											
											<!--- define our structure and set form values --->
											<cfset me = structnew() />
											<cfset me.myuserid = #session.userid# />
											<cfset me.fname = #form.firstname# />
											<cfset me.lname = #form.lastname# />
											<cfset me.email = #form.email# />
											<cfset me.pass = #form.password1# />
											<cfset me.txtmsgprovider = #form.provider# />
											<cfset me.txtmsgnumber = #form.phone# />
																						
											<!--- // some other variables --->
											<cfset today = #CreateODBCDateTime(now())# />											
																						
											<!--- // create the database record --->
											<cfquery datasource="#application.dsn#" name="saveuserprofile">
												update users
												   set firstname = <cfqueryparam value="#me.fname#" cfsqltype="cf_sql_varchar" />,
												       lastname = <cfqueryparam value="#me.lname#" cfsqltype="cf_sql_varchar" />,
													   email = <cfqueryparam value="#me.email#" cfsqltype="cf_sql_varchar" />,
													   passcode = <cfqueryparam value="#hash( me.pass, "SHA-384", "UTF-8" )#" cfsqltype="cf_sql_clob" maxlength="255" />,
													   txtmsgaddress = <cfqueryparam value="#me.txtmsgnumber#" cfsqltype="cf_sql_varchar" />,
													   txtmsgprovider = <cfqueryparam value="#me.txtmsgprovider#" cfsqltype="cf_sql_varchar" />
												 where userid = <cfqueryparam value="#me.myuserid#" cfsqltype="cf_sql_integer" /> 
											</cfquery>											
											
											<!--- // log the activity --->
											<cfquery datasource="#application.dsn#" name="logact">
												insert into activity(leadid, userid, activitydate, activitytype, activity)
													values (
															<cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
															<cfqueryparam value="Record Added" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#session.username# updated the information in their profile." cfsqltype="cf_sql_varchar" />
															);
											</cfquery>																					
											
											<cflocation url="#application.root#?event=#url.event#&msg=saved" addtoken="no">
								
										<!--- If the required data is missing - throw the validation error --->
										<cfelse>
										
											<div class="alert alert-error">
												<a class="close" data-dismiss="alert">&times;</a>
													<h5><error>There were <cfoutput>#objValidation.getErrorCount()#</cfoutput> errors in your submission:</error></h2>
													<ul>
														<cfloop collection="#variables.objValidation.getMessages()#" item="rr">
															<li class="formerror"><cfoutput>#variables.objValidation.getMessage(rr)#</cfoutput></li>
														</cfloop>
													</ul>
											</div>				
										
										</cfif>										
										
									</cfif>
									<!-- // end form processing --->
									
									
									
									<!--- // tabs --->
									<div class="tabbable">
										<ul class="nav nav-tabs">
											<li class="active">
												<a href="#profile" data-toggle="tab">Profile</a>
											</li>
											<li><a href="#settings" data-toggle="tab">Settings</a></li>
										</ul>
									
									<br>
									
										<div class="tab-content">
											<cfoutput>
											<div class="tab-pane active" id="profile">
											<form id="edit-profile" class="form-horizontal" method="post" action="#cgi.script_name#?event=#url.event#">
												<fieldset>
													
													<div class="control-group">											
														<label class="control-label" for="username">Username</label>
														<div class="controls">
															<input type="text" class="input-large disabled" id="username" value="#getauthuser()#" disabled>
															<p class="help-block">Your username is for logging in and cannot be changed.</p>
														</div> <!-- /controls -->				
													</div> <!-- /control-group -->
													
													
													<div class="control-group">											
														<label class="control-label" for="firstname">First Name</label>
														<div class="controls">
															<input type="text" class="input-medium" id="firstname" name="firstname" value="#quserprofile.firstname#">
														</div> <!-- /controls -->				
													</div> <!-- /control-group -->
													
													
													<div class="control-group">											
														<label class="control-label" for="lastname">Last Name</label>
														<div class="controls">
															<input type="text" class="input-medium" id="lastname" name="lastname" value="#quserprofile.lastname#">
														</div> <!-- /controls -->				
													</div> <!-- /control-group -->
													
													
													<div class="control-group">											
														<label class="control-label" for="email">Email Address</label>
														<div class="controls">
															<input type="text" class="input-large" id="email" name="email" value="#quserprofile.email#">
														</div> <!-- /controls -->				
													</div> <!-- /control-group -->
													
													<div class="control-group">											
														<label class="control-label" for="email">Text Address</label>
														<div class="controls">
															<input type="text" class="input-medium" name="phone" id="phone" value="<cfif isdefined( "form.phone" )>#trim( form.phone )#<cfelse>#quserprofile.txtmsgaddress#</cfif>">
																		
																		
																<!--- // add mobile provider for text messaging --->
																<select name="provider" id="provider" class="input-medium">
																	<option value="">Select Provider</option>															  
																	<option value="@txt.att.net"<cfif trim( quserprofile.txtmsgprovider ) is "@txt.att.net">selected</cfif>>AT&amp;T</option>
																	<option value="@message.alltel.com"<cfif trim( quserprofile.txtmsgprovider ) is "@message.alltel.com">selected</cfif>>Alltel</option>
																	<option value="@myboostmobile.com"<cfif trim( quserprofile.txtmsgprovider ) is "@myboostmobile.com">selected</cfif>>Boost Mobile</option>
																	<option value="@mycellone.com"<cfif trim( quserprofile.txtmsgprovider ) is "@mycellone.com">selected</cfif>>Cellular South</option>
																	<option value="@cingularme.com"<cfif trim( quserprofile.txtmsgprovider ) is "@cingularme.com">selected</cfif>>Consumer Cellular</option>
																	<option value="@mymetropcs.com"<cfif trim( quserprofile.txtmsgprovider ) is "@mymetropcs.com">selected</cfif>>Metro PCS</option>
																	<option value="@messaging.nextel.com"<cfif trim( quserprofile.txtmsgprovider ) is "@messaging.nextel.com">selected</cfif>>Nextel</option>
																	<option value="@messaging.sprintpcs.com"<cfif trim( quserprofile.txtmsgprovider ) is "@messaging.sprintpcs.com">selected</cfif>>Sprint</option>
																	<option value="@gmomail.net"<cfif trim( quserprofile.txtmsgprovider ) is "@gmomail.net">selected</cfif>>T-Mobile</option>
																	<option value="@vtext.com"<cfif trim( quserprofile.txtmsgprovider ) is "@vtext.com">selected</cfif>>Verizon</option>
																	<option value="@vmobl.com"<cfif trim( quserprofile.txtmsgprovider ) is "@vmobl.com">selected</cfif>>Virgin Mobile</option>
																</select>
																		
														</div>
													</div>
													<br /><br />
													
													<div class="control-group">											
														<label class="control-label" for="password1">Password</label>
														<div class="controls">
															<input type="password" class="input-medium" id="password1" name="password1" value="#quserprofile.passcode#" />
														</div> <!-- /controls -->				
													</div> <!-- /control-group -->
													
													
													<div class="control-group">											
														<label class="control-label" for="password2">Confirm</label>
														<div class="controls">
															<input type="password" class="input-medium" id="password2" name="password2" />
														</div> <!-- /controls -->				
													</div> <!-- /control-group -->						
														
													<br />												
														
													<div class="form-actions">
														<button type="submit" class="btn btn-secondary" name="saveuserprofile"><i class="icon-save"></i> Save Profile</button>
														<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.index'"><i class="icon-remove-sign"></i> Cancel</a>
														<input name="utf8" type="hidden" value="&##955;">
														<input type="hidden" name="__authToken" value="#randout#" />
														<input type="hidden" name="thisuserid" value="#session.userid#" />														
														<input name="validate_require" type="hidden" value="firstname|Please enter your first name.  This field can not be blank.;lastname|Please enter your last name.  This field can not be blank.;password1|Please enter your password to validate.  This field can not be blank.;email|Please enter your email address.  You can not receive email notifications without a valid email address." />
														<input type="hidden" name="validate_email" value="email|The email address enter is invalid.  Please re-try..." />
														<input type="hidden" name="validate_password" value="password1|password2|Sorry, the passwords entered do not match.  Please re-try..." />
													</div> <!-- /form-actions -->
												</fieldset>
											</form>
											</div>
											</cfoutput>
											<div class="tab-pane" id="settings">
												<form id="edit-profile-settings" class="form-horizontal">
													<fieldset>
														
														
														<div class="control-group">
															<label class="control-label" for="accounttype">Account Type</label>
															<div class="controls">
																<label class="radio">
																	<input type="radio" name="accounttype" value="option1" checked="checked" id="accounttype">
																	POP3
																</label>
																<label class="radio">
																	<input type="radio" name="accounttype" value="option2">
																	IMAP
																</label>
															</div>
														</div>
														<div class="control-group">
															<label class="control-label" for="accountusername">Account Username</label>
															<div class="controls">
																<input type="text" class="input-large" id="accountusername" value="">
																<p class="help-block">Leave blank to use your profile email address.</p>
															</div>
														</div>
														<div class="control-group">
															<label class="control-label" for="emailserver">Email Server</label>
															<div class="controls">
																<input type="text" class="input-large" id="emailserver" value="mail.example.com">
															</div>
														</div>
														<div class="control-group">
															<label class="control-label" for="accountpassword">Password</label>
															<div class="controls">
																<input type="text" class="input-large" id="accountpassword" value="password">
															</div>
														</div>
														
																									
														
														
														<div class="control-group">
															<label class="control-label" for="accountadvanced">Advanced Settings</label>
															<div class="controls">
																<label class="checkbox">
																	<input type="checkbox" name="accountadvanced" value="option1" checked="checked" id="accountadvanced">
																	User encrypted connection when accessing this server
																</label>
																<label class="checkbox">
																	<input type="checkbox" name="accounttype" value="option2">
																	Download all message on connection
																</label>
															</div>
														</div>

														
														<br />
														
														<div class="form-actions">
															<button type="submit" class="btn btn-secondary">Save Settings</button> <button class="btn btn-primary">Cancel</button>
														</div>
													</fieldset>
												</form>
											</div>
											
										</div> <!-- /.tab-content -->							  
									  
									</div> <!-- /.tabble -->							
									
								</div> <!-- /widget-content -->
									
							</div> <!-- /widget -->
							
						</div> <!-- /span8 -->
					
					
						<div class="span4">
							
							
							<div class="widget stacked widget-box">
								
								<div class="widget-header">
									<i class="icon-calendar"></i>
									<h3>Login History</h3>
								</div> <!-- /widget-header -->
								
								<div class="widget-content">
									
									<table class="table table-striped table-highlight">
										<thead>
											<tr>												
												<th>Login Date</th>
												<th>IP Address</th>												
											</tr>
										</thead>
										<tbody>
											<cfoutput query="qloginhistory" maxrows="14">
												<tr>													
													<td>#dateformat(logindate, "mm/dd/yyyy")# #timeformat(logindate, "hh:mm tt")#</td>
													<td>#loginip#</td>													
												</tr>
											</cfoutput>
										</tbody>									
									</table>								
									<h6 style="margin-top:3px;"><a href="index.cfm?event=page.loginhistory">View More</a></h6>
								</div> <!-- /widget-content -->
								
							</div> <!-- /widget-box -->
												
						</div> <!-- /span4 -->
					
					</div> <!-- /row -->

				</div> <!-- /container -->
				
			</div> <!-- /main -->