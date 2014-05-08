
		
		
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
							alert('Sorry, this user can no tbe deleted from the system because there are active leads assigned.  Reassign these leads and then delete the user..."');
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
							
							
							
							
							
							
							<div class="span8">
								
								<div class="widget stacked">
									<cfoutput>
										<div class="widget-header">		
											<i class="icon-group"></i>							
											<h3>Manage Company Users for #compuserdetail.companyname#</h3>						
										</div> <!-- //.widget-header -->
									</cfoutput>
										
										
										<!--- // widget content data grid --->
										<div class="widget-content">						
											
											<cfif userlist.recordcount gt 0>
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
								
							</div> <!-- //.span8 -->
							
							
							<!--- // sidebar --->
							
							<div class="span4">
								
								<div class="widget widget-plain">
				
									<div class="widget-content">
										<cfoutput>
											<a href="#application.root#?event=page.users.edit&fuseaction=edit.user&uid=0" class="btn btn-large btn-primary btn-support-ask"><i class="icon-plus-sign-alt"></i> Add New User</a>					
											<a href="#application.root#?event=page.depts" class="btn btn-large btn-secondary btn-support-ask"><i class="icon-building"></i> Manage Departments</a>
											<a href="#application.root#?event=page.activity" class="btn btn-large btn-tertiary btn-support-ask"><i class="icon-spinner"></i> View Activity Log</a>								
										</cfoutput>
									</div> <!--- /widget-content --->
							
								</div> <!--- /widget --->
								<!---
								<div class="widget stacked">
									
									<div class="widget-header">		
										<i class="icon-user"></i>							
										<h3>Other User Functions</h3>						
									</div> <!--- //.widget-header --->
									
									<div class="widget-content">						
										
										

										<div class="clear"></div>
									
									
									</div> <!--- //.widget-content --->	
										
								</div>  //.widget --->
							
							</div><!-- // .span4 -->
							
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
