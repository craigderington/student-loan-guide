
		
		
			<!--- // admin section // check user roles --->
			<cfif not isuserinrole( "admin" ) and not isuserinrole( "co-admin" )>
				<cflocation url="#application.root#?event=page.index&error=1" addtoken="yes">
			</cfif>
			
			<!--- // get our data acess components --->			
			<cfinvoke component="apis.com.admin.companyadmingateway" method="getusercomp" returnvariable="compuserdetail">
				<cfinvokeargument name="companyid" value="#session.companyid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.admin.useradmingateway" method="getuser" returnvariable="userdetail">
				<cfinvokeargument name="userid" value="#url.uid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.admin.useradmingateway" method="getusers" returnvariable="userlist">
				<cfinvokeargument name="companyid" value="#session.companyid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.admin.deptadmingateway" method="getdepts" returnvariable="deptlist">
				<cfinvokeargument name="companyid" value="#session.companyid#">
			</cfinvoke>
		
		
			<!--- // additional stylesheet for large support buttons --->
			<link href="./js/plugins/faq/faq.css" rel="stylesheet">	
		
		

			<!--- company user management --->
			<div class="main">	
					
				<div class="container">
						
						<div class="row">
				
							<div class="span9">
								
								<div class="widget stacked">
									
									
									
									<cfoutput>
										<div class="widget-header">		
											<i class="icon-group"></i>							
											<cfif userdetail.recordcount gt 0>
											<h3>Edit User Detail for #userdetail.firstname# #userdetail.lastname#</h3>
											<cfelse>
											<h3>Add New User for #compuserdetail.companyname#</h3>
											</cfif>
										</div> <!-- //.widget-header -->
									</cfoutput>
										
										
										
										
										
										
										
										<!--- // widget content user form --->
										<div class="widget-content">							
											
											
											<!--- // begin form processing --->
											<cfif isDefined("form.fieldnames")>
												<cfscript>
													objValidation = createObject( "component","apis.com.ui.validation" ).init();
													objValidation.setFields( form );
													objValidation.validate();
												</cfscript>

												<cfif objValidation.getErrorCount() is 0>							
													
													<!--- define our structure and set form values --->
													<cfset user = structnew() />
													<cfset user.userid = #form.thisuserid# />
													
													<cfif structkeyexists( form, "thisuserid" ) and form.thisuserid eq 0>
														<cfset user.useruuid = #createuuid()# />
														<cfset user.username = #trim( form.username )# />
													<cfelse>
														<cfset user.useruuid = #form.thisuserid# />
													</cfif>
													
													<cfset user.companyid = #session.companyid# />
													<cfset user.deptid = #form.deptid# />													
													<cfset user.firstname = #trim( form.firstname )# />
													<cfset user.lastname = #form.lastname# />
													<cfset user.email = #trim( form.email )# />
													<cfset user.role = #form.userrole# />
													<cfset user.acl = #form.acl# />
													
													<cfif form.password1 is not "">
														<cfset user.password = #trim( form.password1 )# />
														<cfset user.confirmpass = #trim( form.password2 )# />
													<cfelse>
														<cfset user.password = "" />
														<cfset user.confirmpass = "" />
													</cfif>
													
													<cfif isdefined( "form.chkstatus" )>
														<cfset user.status = #form.chkstatus# />
													<cfelse>
														<cfset user.status = 0 />
													</cfif>
																								
													<!--- // some other variables --->
													<cfset today = #CreateODBCDateTime(now())# />																							
														
															
														<cfif user.userid eq 0>															
															
															<!--- // check for duplicate user entry --->
															<cfquery datasource="#application.dsn#" name="checkdupeuser">
																select userid, companyid, username
																  from users
																 where ( companyid = <cfqueryparam value="#session.companyid#" cfsqltype="cf_sql_integer" />
																   and firstname = <cfqueryparam value="#user.firstname#" cfsqltype="cf_sql_varchar" />
																   and lastname = <cfqueryparam value="#user.lastname#" cfsqltype="cf_sql_varchar" /> )
																    or ( email = <cfqueryparam value="#user.email#" cfsqltype="cf_sql_varchar" /> )
															</cfquery>														
														
																<!--- // check to make sure we are not allowing a duplicate department name for the same company --->
																<cfif checkdupeuser.recordcount eq 1 >
																	
																	
																	<div class="alert alert-error">
																		<a class="close" data-dismiss="alert">&times;</a>
																		<h5><error>There was 1 error in your form submission:</error></h2>
																			<ul>																		
																				<li class="formerror"><cfoutput>The user #checkdupeuser.username# was already found in the database.  This is not allowed.  Each user profile must be unique.  Please check your data and try again.</cfoutput></li>																		
																			</ul>
																	</div>	
															
															
																<cfelseif trim( user.password ) is "">
																
																	<div class="alert alert-error">
																		<a class="close" data-dismiss="alert">&times;</a>
																		<h5><error>There was 1 error in your form submission:</error></h2>
																			<ul>																		
																				<li class="formerror">The user's password is required to add a new record.  Please check your input and try again...</li>																		
																			</ul>
																	</div>
																
																
																<cfelseif comparenocase( user.password, user.confirmpass ) neq 0>
																
																	<div class="alert alert-error">
																		<a class="close" data-dismiss="alert">&times;</a>
																		<h5><error>There was 1 error in your form submission:</error></h2>
																			<ul>																		
																				<li class="formerror">The entered user password and confirm password fields do not match.  Please check your input and try again...</li>																		
																			</ul>
																	</div>
																
																
																
																<cfelse>
																
																	<!--- // create the database record --->
																	<cfquery datasource="#application.dsn#" name="addnewuser">
																		insert into users(useruuid, companyid, deptid, username, passcode, firstname, lastname, acl, role, active, email)
																			values (
																					<cfqueryparam value="#user.useruuid#" cfsqltype="cf_sql_varchar" maxlength="35" />,
																					<cfqueryparam value="#user.companyid#" cfsqltype="cf_sql_integer" />,
																					<cfqueryparam value="#user.deptid#" cfsqltype="cf_sql_integer" />,											
																					<cfqueryparam value="#user.username#" cfsqltype="cf_sql_varchar" />,
																					<cfqueryparam value="#hash( user.password, "SHA-384", "UTF-8" )#" cfsqltype="cf_sql_clob" />,
																					<cfqueryparam value="#user.firstname#" cfsqltype="cf_sql_varchar" />,
																					<cfqueryparam value="#user.lastname#" cfsqltype="cf_sql_varchar" />,
																					<cfqueryparam value="#user.acl#" cfsqltype="cf_sql_numeric" />,
																					<cfqueryparam value="#user.role#" cfsqltype="cf_sql_varchar" />,
																					<cfqueryparam value="1" cfsqltype="cf_sql_bit" />,
																					<cfqueryparam value="#user.email#" cfsqltype="cf_sql_varchar" />																				
																				   );
																	</cfquery>											
																	
																	<!--- // log the activity --->
																	<cfquery datasource="#application.dsn#" name="logact">
																		insert into activity(leadid, userid, activitydate, activitytype, activity)
																			values (
																					<cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
																					<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																					<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																					<cfqueryparam value="Record Added" cfsqltype="cf_sql_varchar" />,
																					<cfqueryparam value="#session.username# added a #user.firstname# #user.lastname# to the system." cfsqltype="cf_sql_varchar" />
																					);
																	</cfquery>																					
																	
																	<cflocation url="#application.root#?event=page.users&msg=added" addtoken="no">
														
																</cfif>
																
															
														<cfelse>
															
																
																<!--- // update the database record --->
																<cfquery datasource="#application.dsn#" name="saveuserdetail">
																	update users
																	   set deptid = <cfqueryparam value="#user.deptid#" cfsqltype="cf_sql_integer" />,											   
																		   firstname = <cfqueryparam value="#user.firstname#" cfsqltype="cf_sql_varchar" />,
																		   lastname = <cfqueryparam value="#user.lastname#" cfsqltype="cf_sql_varchar" />,
																		   acl = <cfqueryparam value="#user.acl#" cfsqltype="cf_sql_numeric" />,
																		   role = <cfqueryparam value="#user.role#" cfsqltype="cf_sql_varchar" />,
																		   email = <cfqueryparam value="#user.email#" cfsqltype="cf_sql_varchar" />,
																		   active = <cfqueryparam value="#user.status#" cfsqltype="cf_sql_bit" />
																		   <cfif trim( user.password ) is not "">
																		   , passcode = <cfqueryparam value="#hash( user.password, "SHA-384", "UTF-8" )#" cfsqltype="cf_sql_clob" />
																		   </cfif>
																	 where useruuid = <cfqueryparam value="#user.useruuid#" cfsqltype="cf_sql_varchar" maxlength="35" />
																</cfquery>											
																
																<!--- // log the user activity --->
																<cfquery datasource="#application.dsn#" name="logact2">
																	insert into activity(leadid, userid, activitydate, activitytype, activity)
																		values (
																				<cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
																				<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																				<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																				<cfqueryparam value="Record Updated" cfsqltype="cf_sql_varchar" />,
																				<cfqueryparam value="The user update the user profile for #user.firstname# #user.lastname#." cfsqltype="cf_sql_varchar" />
																				);
																</cfquery>																					
																
																<cflocation url="#application.root#?event=page.users&msg=saved" addtoken="no">													
															
														
														</cfif>
												
												
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
											<!--- // end form processing --->
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											<br />
											<cfoutput>
											
												<form id="edit-user-detail" class="form-horizontal" method="post" action="#cgi.script_name#?event=#url.event#&fuseaction=edit.user&uid=#userdetail.useruuid#">
													
													<fieldset>
														
														<div class="control-group">											
															<label class="control-label" for="username">Username</label>
															<div class="controls">
																<cfif userdetail.useruuid is not "">
																<input type="text" class="input-large disabled" name="username" id="username" value="#userdetail.username#" disabled>
																<p class="help-block">Your username is for logging in and cannot be changed.</p>
																<cfelse>
																<input type="text" class="input-large" id="username" name="username" placeholder="Enter user's email address" />
																</cfif>
															</div> <!-- /controls -->				
														</div> <!-- /control-group -->
														
														<div class="control-group">											
															<label class="control-label" for="deptid">Department</label>
															<div class="controls">
																<select name="deptid" class="input-large">
																	<cfloop query="deptlist">
																		<option value="#deptid#"<cfif deptlist.deptid eq userdetail.deptid>selected</cfif>>#deptname#</option>
																	</cfloop>
																</select>
															</div> <!-- /controls -->				
														</div> <!-- /control-group -->
														
														<div class="control-group">											
															<label class="control-label" for="firstname">First Name</label>
															<div class="controls">
																<input type="text" class="input-medium" id="firstname" name="firstname" value="#userdetail.firstname#">
															</div> <!-- /controls -->				
														</div> <!-- /control-group -->									
														
														<div class="control-group">											
															<label class="control-label" for="lastname">Last Name</label>
															<div class="controls">
																<input type="text" class="input-medium" id="lastname" name="lastname" value="#userdetail.lastname#">
															</div> <!-- /controls -->				
														</div> <!-- /control-group -->														
														
														<div class="control-group">											
															<label class="control-label" for="email">Email Address</label>
															<div class="controls">
																<input type="text" class="input-large" id="email" name="email" value="#userdetail.email#">
															</div> <!-- /controls -->				
														</div> <!-- /control-group -->														
														
														<div class="control-group">											
															<label class="control-label" for="userrole">Role</label>
															<div class="controls">
																<select name="userrole" class="input-large" multiple size="5">															
																	<cfif isuserinrole( "admin" )>
																	<option value="admin"<cfif listcontains( userdetail.role, "admin" ) and not listcontains( userdetail.role, "co-admin" )>selected</cfif>>System Administrator</option>
																	</cfif>
																	<option value="co-admin"<cfif listcontains( userdetail.role, "co-admin" )>selected</cfif>>Company Administrator</option>
																	<option value="sls"<cfif listcontains( userdetail.role, "sls" )>selected</cfif>>Student Loan Advisor</option>
																	<option value="intake"<cfif listcontains( userdetail.role, "intake" )>selected</cfif>>Intake Advisor</option>
																	<option value="counselor"<cfif listcontains( userdetail.role, "counselor" )>selected</cfif>>Enrollment Counselor</option>
																</select>
															</div> <!-- /controls -->				
														</div> <!-- /control-group -->												
														
														<div class="control-group">											
															<label class="control-label" for="acl">Access Level</label>
															<div class="controls">
																<input type="text" class="input-mini" id="acl" name="acl" value="#userdetail.acl#" />
															</div> <!-- /controls -->				
														</div> <!-- /control-group -->
														
														<div class="control-group">											
															<label class="control-label" for="acl">Active</label>
															<div class="controls">
																<input type="checkbox" class="input-mini" value="1" id="chkstatus" name="chkstatus" <cfif userdetail.active eq 1>checked</cfif> />
															</div> <!-- /controls -->				
														</div> <!-- /control-group -->
														
														<br /><br />
														
														<div class="control-group">											
															<label class="control-label" for="password1">Password</label>
															<div class="controls">
																<input type="password" class="input-medium" id="password1" name="password1" />
															</div> <!-- /controls -->				
														</div> <!-- /control-group -->
														
														
														<div class="control-group">											
															<label class="control-label" for="password2">Confirm</label>
															<div class="controls">
																<input type="password" class="input-medium" id="password2" name="password2" />
															</div> <!-- /controls -->				
														</div> <!-- /control-group -->						
															
														<br />												
														<cfif ( structkeyexists( url, "uid" ) and url.uid eq 0 )>	
															<cfif compuserdetail.numlicenses neq userlist.recordcount>
																<div class="form-actions">															
																	<button type="submit" class="btn btn-secondary" name="saveuserprofile"><i class="icon-save"></i> Save User Profile</button>
																	<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.users'"><i class="icon-remove-sign"></i> Cancel</a>
																	<input name="utf8" type="hidden" value="&##955;">
																	<input type="hidden" name="__authToken" value="#randout#" />
																	<input type="hidden" name="thisuserid" value="<cfif userdetail.useruuid is "">0<cfelse>#userdetail.useruuid#</cfif>" />														
																	<input name="validate_require" type="hidden" value="firstname|Please enter your first name.  This field can not be blank.;lastname|Please enter your last name.  This field can not be blank.;email|Please enter your email address.  You can not receive email notifications without a valid email address." />
																	<input type="hidden" name="validate_email" value="email|The email address enter is invalid.  Please re-try..." />															
																</div> <!-- /form-actions -->
															<cfelse>
																<span style="color:red;margin-left:10px;"><i style="color:red;" class="icon-warning-sign"></i> Sorry, all of your company software licenses are currently in use.  No new users may be added at this time.</span>
															</cfif>
														<cfelse>
															<div class="form-actions">															
																<button type="submit" class="btn btn-secondary" name="saveuserprofile"><i class="icon-save"></i> Save User Profile</button>
																<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.users'"><i class="icon-remove-sign"></i> Cancel</a>
																<input name="utf8" type="hidden" value="&##955;">
																<input type="hidden" name="__authToken" value="#randout#" />
																<input type="hidden" name="thisuserid" value="<cfif userdetail.useruuid is "">0<cfelse>#userdetail.useruuid#</cfif>" />														
																<input name="validate_require" type="hidden" value="firstname|Please enter your first name.  This field can not be blank.;lastname|Please enter your last name.  This field can not be blank.;email|Please enter your email address.  You can not receive email notifications without a valid email address." />
																<input type="hidden" name="validate_email" value="email|The email address enter is invalid.  Please re-try..." />															
															</div> <!-- /form-actions -->
														</cfif>
													</fieldset>
												</form>
											
											</cfoutput>
											

											<div class="clear"></div>										
										
										</div> <!-- //.widget-content -->	
											
									</div> <!-- //.widget -->
								
							</div> <!-- //.span9 -->
							
							
							<!--- // sidebar --->
							
							<div class="span3">
								
								<div class="widget widget-box">
									
									<div class="widget-header">
										<i class="icon-globe"></i>
										<h3>Admin Options</h3>
									</div>
									
									<div class="widget-content">
										<cfoutput>
											<cfif structkeyexists( url, "uid" ) and url.uid neq 0><a href="#application.root#?event=page.users&fuseaction=edit.user&uid=0" class="btn btn-xlarge btn-primary">Add New User <i style="margin-left:58px;" class="icon-plus"></i></a></cfif>					
											<a href="#application.root#?event=page.depts" <cfif structkeyexists( url, "uid" ) and url.uid neq 0>style="margin-top:10px;"</cfif> class="btn btn-xlarge btn-secondary">Manage Departments<i style="margin-left:12px;" class="icon-building"></i></a>
											<a href="#application.root#?event=page.company.activity" style="margin-top:10px;" class="btn btn-xlarge btn-secondary">View Activity Log<i style="margin-left:48px;" class="icon-spinner"></i></a>								
											<a href="#application.root#?event=page.company.activity" style="margin-top:10px;" class="btn btn-xlarge btn-default">Company Settings<i style="margin-left:35px;" class="icon-cogs"></i></a>
											<br /><br />
										</cfoutput>
									</div> <!-- /widget-content -->
							
								</div> <!-- /widget -->								
							
							</div><!-- // .span3 -->
							
						</div> <!-- //.row -->			
					
					
						<div style="height:100px;"></div>			
					
				</div> <!-- //.container -->
				
			</div> <!-- //.main -->