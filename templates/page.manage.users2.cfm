
		
		
			<!--- // admin section // check user roles --->
			<cfif not isuserinrole( "admin" ) and not isuserinrole( "co-admin" )>
				<cflocation url="#application.root#?event=page.index&error=1" addtoken="yes">
			</cfif>	
			
			<!--- // get our data acess components --->
			<cfinvoke component="apis.com.admin.companyadmingateway" method="getusercomp" returnvariable="compuserdetail">
				<cfinvokeargument name="companyid" value="#session.companyid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.admin.useradmingateway" method="getusers" returnvariable="userlist">
				<cfinvokeargument name="companyid" value="#session.companyid#">
			</cfinvoke>			
		
			
			
			<!--- // kill user profile // check query string action --->
			<cfif structkeyexists( url, "fuseaction" ) and structkeyexists( url, "uid" )>
				<cfparam name="userid" default="#url.uid#">
				<cfset userid = #url.uid# />
				
				<cfif trim( url.fuseaction ) is "kill.user" and isvalid( "uuid", userid )>
				
					<!--- get the actual user id integer from the url param uuid --->
					<cfquery datasource="#application.dsn#" name="getuser">
						select userid, useruuid, username
						  from users
						 where useruuid = <cfqueryparam value="#userid#" cfsqltype="cf_sql_varchar" />
					</cfquery>
					
					<!--- // check to make sure the user does not have any leads bound to their user profile --->
					<cfquery datasource="#application.dsn#" name="checkuser">
						select count(*) as totalleads
						  from leads
						 where userid = <cfqueryparam value="#getuser.userid#" cfsqltype="cf_sql_integer" />
					</cfquery>
					
					
					<cfif checkuser.totalleads eq 0>
					
						<cfquery datasource="#application.dsn#" name="killuser">
							delete
							  from users
							 where userid = <cfqueryparam value="#getuser.userid#" cfsqltype="cf_sql_integer" />
						</cfquery>
						
						<!--- // log the activity --->
						<cfquery datasource="#application.dsn#" name="logact">
							insert into activity(leadid, userid, activitydate, activitytype, activity)
								values (
										<cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
										<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
										<cfqueryparam value="#createodbcdatetime( now() )#" cfsqltype="cf_sql_timestamp" />,
										<cfqueryparam value="Record Deleted" cfsqltype="cf_sql_varchar" />,
										<cfqueryparam value="#session.username# deleted #getuser.username# from the system." cfsqltype="cf_sql_varchar" />
										);
						</cfquery>
						
						<cflocation url="#application.root#?event=#url.event#&msg=deleted" addtoken="no" >
					
					<cfelse>
					
						<script>
							alert('Sorry, this user can no tbe deleted from the system because there are active clients assigned.  Reassign these clients and then delete the user..."');
							self.location="javascript:history.back(-1);"
						</script>
					
					</cfif>
			
				<cfelse>
				
					<script>
						alert('The user ID of the selected record is invalid.  Please try re-selecting the user again...');
						self.location="javascript:history.back(-1);"
					</script>
				
				</cfif>
			
			</cfif>
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			<!--- // additonal stylesheet for large support buttons --->
			<link href="./js/plugins/faq/faq.css" rel="stylesheet">	
		
		

			<!--- company user management --->
			<div class="main">	
					
				<div class="container">
						
						<div class="row">
				
							
							<!--- // show system messages --->
							
							<cfif structkeyexists( url, "msg" ) and url.msg is "saved">						
								<div class="span12">									
									<div class="alert alert-info">
										<button type="button" class="close" data-dismiss="alert">&times;</button>
										<strong><i class="icon-check"></i> SUCCESS!</strong>  The user's profile was successfully updated.  Please make another selection to continue...																	
									</div>
								</div>
								
							<cfelseif structkeyexists( url, "msg" ) and url.msg is "added">						
								<div class="span12">										
									<div class="alert alert-info">
										<button type="button" class="close" data-dismiss="alert">&times;</button>
										<strong>SUCCESS!</strong>  The user was successfully added to the selected company profile.  Please make another selection to continue...																	
									</div>
								</div>
								
							<cfelseif structkeyexists( url, "msg" ) and url.msg is "deleted">						
								<div class="span12">										
									<div class="alert alert-error">
										<button type="button" class="close" data-dismiss="alert">&times;</button>
										<strong>SUCCESS!</strong>  The user was successfully deleted from the selected company profile.  Please make another selection to continue...																	
									</div>
								</div>
								
							<cfelseif structkeyexists( url, "msg" ) and url.msg is "error">						
								<div class="span12">										
									<div class="alert alert-error">
										<button type="button" class="close" data-dismiss="alert">&times;</button>
										<strong>SYSTEM ERROR!</strong>  Sorry, the user could not be deleted due to a system error.  Please make another selection to continue...
									</div>
								</div>
									
							</cfif>
							
							
							
							<div class="span12">
								
								<div class="widget stacked">
									<cfoutput>
										<div class="widget-header">		
											<i class="icon-group"></i>							
											<h3>Manage Company Users for #compuserdetail.companyname#</h3>						
										</div> <!-- //.widget-header -->
									</cfoutput>
										
										
										<!--- // widget content data grid --->
										<div class="widget-content">

											<!--- // report filter --->									
											<cfoutput>
												<div class="well">
													<p><i class="icon-check"></i> Filter Your Results</p>
													
													<form class="form-inline" name="filterresults" method="post">																				
														
														<!--- // start with selecting user list --->
														<select name="userlist" style="margin-left:5px;" class="input-large" onchange="javascript:this.form.submit();">
															<option value="">Select User</option>
															<cfloop query="userlist">
																<option value="#userid#"<cfif isdefined( "form.userlist" ) and form.userlist eq userlist.userid>selected</cfif>>#firstname# #lastname#</option>
															</cfloop>												
														</select>						
														
														<select name="userroles" style="margin-left:5px;" class="input-large" onchange="javascript:this.form.submit();">
															<option value="">Filter By Role</option>																
																<cfif isuserinrole( "admin") >
																<option value="Admin"<cfif isdefined( "form.userroles" ) and trim( form.userroles ) is "admin">selected</cfif>>Administration</option>																												
																</cfif>
																<option value="co-admin"<cfif isdefined( "form.userroles" ) and trim( form.userroles ) is "admin">selected</cfif>>Company Administrator</option>
																<option value="sls"<cfif isdefined( "form.userroles" ) and trim( form.userroles ) is "sls">selected</cfif>>Student Loan Advisor</option>
																<option value="intake"<cfif isdefined( "form.userroles" ) and trim( form.userroles ) is "intake">selected</cfif>>Intake Advisor</option>
																<option value="counselor"<cfif isdefined( "form.userroles" ) and trim( form.userroles ) is "counselor">selected</cfif>>Enrollment Counselor</option>						
														</select>
														<input type="text" name="username" style="margin-left:5px;" class="input-large" placeholder="Filter By Name"  value="<cfif isdefined( "form.username" )>#trim( form.username )#</cfif>">
														<input type="hidden" name="filtermyresults">
														<button type="submit" style="margin-left:3px;" name="filterresults" class="btn btn-small btn-secondary"><i class="icon-search"></i> Filter Results</button>
														<cfif structkeyexists( form, "filtermyresults" )><button type="reset" onclick="location.href='#application.root#?event=#url.event#'" style="margin-left:3px;" class="btn btn-small btn-primary"><i class="icon-check"></i> Reset List</button></cfif>
														
														
													</form>
												</div>
											</cfoutput>
											<!--- // end filter --->
											
											
											<cfif userlist.recordcount gt 0>
												
												<cfoutput>
													<h5><i style="margin-right:5px;" class="icon-th-large"></i> Currently assigned user accounts:  #userlist.recordcount#.  Licenses remaining: #( compuserdetail.numlicenses - userlist.recordcount )# <span class="pull-right"><a href="#application.root#?event=page.company.activity" style="margin-bottom:5px;" class="btn btn-medium btn-secondary"><i class="icon-bookmark"></i> View User Activity </a><a href="#application.root#?event=page.depts" style="margin-left:5px;margin-bottom:5px;" class="btn btn-medium btn-default"><i class="icon-building"></i> Manage Departments </a><cfif compuserdetail.numlicenses neq userlist.recordcount><a href="#application.root#?event=#url.event#.edit&fuseaction=edit.user&uid=0" style="margin-bottom:5px;margin-left:5px;" class="btn btn-medium btn-primary"><i class="icon-plus"></i> Add New User </a></cfif>     </span></h5>
												</cfoutput>
												
												
												
												
												
												
												
												<table class="table table-bordered table-striped table-highlight">
													<thead>
														<tr>
															<th width="12%">Actions</th>
															<th>Dept</th>
															<th>First Name</th>
															<th>Last Name</th>													
															<th>Role</th>
														</tr>
													</thead>
													<tbody>
														<cfoutput query="userlist">
														<tr>
															<td class="actions">														
																<a href="#application.root#?event=page.users.edit&fuseaction=edit.user&uid=#useruuid#" class="btn btn-mini btn-warning">
																	<i class="btn-icon-only icon-ok"></i>										
																</a>
																
																<a href="#application.root#?event=#url.event#&fuseaction=kill.user&uid=#useruuid#" onclick="return confirmSubmitDelete();" class="btn btn-mini btn-inverse">
																	<i class="btn-icon-only icon-trash"></i>										
																</a>														
															</td>													
															<td>#deptname#</td>
															<td>#firstname#</td>
															<td>#lastname#</td>													
															<td><span class="label label-inverse">#role#</span></td>
														</tr>
														</cfoutput>
													</tbody>
												</table>
											
											
											
											<cfelse>
											
												<cfoutput>
													<div class="alert alert-error">
														<button type="button" class="close" data-dismiss="alert">&times;</button>
														<strong>NO RECORDS FOUND!</strong>  There are no saved users for the selected company.  Please <a href="#application.root#?event=page.users.edit&fuseaction=edit.user&uid=0">click here</a> to create a new company user.																	
													</div>
												</cfoutput>
											
											</cfif>								
											
											
											<div class="clear"></div>										
										
										</div> <!-- //.widget-content -->	
											
									</div> <!-- //.widget -->
								
							</div> <!-- //.span12 -->		
							
						</div> <!-- //.row -->			
					
					
						<div style="height:300px;"></div>			
					
				</div> <!-- //.container -->
				
			</div> <!-- //.main -->
			
			<script LANGUAGE="JavaScript">
				<!--
				// *** CLD - 2007-08-06 - Alert Confirm Delete
				function confirmSubmitDelete()
				{
				var agree=confirm("Are you sure you want to delete this user from the system?  This action can not be un-done...");
				if (agree)
					return true ;
				else
					return false ;
				}
				// -->
			</script>
