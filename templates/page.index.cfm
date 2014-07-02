
					
					
					<!--- // CF9 cflogin bug // temporary work-around --->
					<cfif not structkeyexists( session, "userid" )>
						<cflocation url="#application.root#?event=page.logout&rdurl=killopensess" addtoken="no">
					</cfif>
					
					
					
					
					
					
					
					
					
					
					
					
					
					<!--- // if the role is bClient, redirect to portal home --->
					<cfif isuserinrole( "bclient" )>										
						<cfquery datasource="#application.dsn#" name="getuser">
							select u.userid, u.leadid, u.leadwelcome, l.leadwelcomehome, l.leadesign
							  from users u, leads l
							 where u.leadid = l.leadid
							   and u.userid = <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />
						</cfquery>								
						<!--- // set some additional session vars we need for the client portal --->						
						<cfset session.leadid = getuser.leadid />
						<cfset session.leadesign = getuser.leadesign />
						<cfset session.welcomehomesess = 0 />
						<cfset session.leadwelcomehome = getuser.leadwelcomehome />									
						<!--- // redirect to portal home --->
						<cflocation url="#application.root#?event=page.portal.home" addtoken="yes">									
					</cfif>

					
					
					
					<!--- // include the data access components for the dashboard --->
					<cfinvoke component="apis.com.ui.dashboardgateway" method="getmydashboard" returnvariable="mydashboard">			
						<cfinvokeargument name="companyid" value="#session.companyid#">
						<cfinvokeargument name="userid" value="#session.userid#">
					</cfinvoke>

					<cfinvoke component="apis.com.ui.dashboardgateway" method="getmydashboarduser" returnvariable="mydashboarduser">			
						<cfinvokeargument name="userid" value="#session.userid#">
					</cfinvoke>
					
					<cfinvoke component="apis.com.leads.leadgateway" method="getrecentactivity" returnvariable="logrecent">			
						<cfinvokeargument name="userid" value="#session.userid#">
					</cfinvoke>					
					
					<cfinvoke component="apis.com.ui.dashboardgateway" method="getrandomclients" returnvariable="dashboardclients">
						<cfinvokeargument name="companyid" value="#session.companyid#">
					</cfinvoke>
					
					<cfinvoke component="apis.com.ui.dashboardgateway" method="getnewassignments" returnvariable="newassign">
						<cfinvokeargument name="companyid" value="#session.companyid#">
					</cfinvoke>
					
					<cfinvoke component="apis.com.tasks.remindergateway" method="getuserreminders" returnvariable="userreminderlist">
						<cfinvokeargument name="userid" value="#session.userid#">
					</cfinvoke>
					
					
					
					
					<div class="main">

						<div class="container">

						  <div class="row">
							
							<!--- // show system access denied message --->
							<cfif structkeyexists( url, "error" ) and url.error eq 1 >
								<div class="span12">
									<div class="alert alert-error">
										<button type="button" class="close" data-dismiss="alert">&times;</button>
										<i class="icon-warning-sign"></i> <strong>UNAUTHORIZED ACCESS!</strong>  You have attempted to access a private system resource.  This is not allowed and is a violation of your <i>terms of use</i>.  Your user activity and ID have been logged and reported to the system administrator.  You can dismiss this message by clicking the 'X' in the upper right hand corner of the dialog.
									</div>
								</div>
							</cfif>
							
							<!--- // show system access denied message --->
							<cfif structkeyexists( url, "restart" ) and url.restart eq 1 >
								<div class="span12">
									<div class="alert alert-info">
										<cfoutput>
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<i class="icon-check"></i> <strong>SYSTEM READY!</strong>  The system was successfully restarted on #dateformat( now(), "full" )# at #timeformat( now(), "hh:mm:ss tt" )#.  Please dismiss this message to continue..
										</cfoutput>
									</div>
								</div>
							</cfif>
							
							<!--- // show system restart alert message --->
							<cfif structkeyexists( url, "reinit" ) and url.reinit is true>
								<script src="../js/countdown.js" type="text/javascript"></script>
								<div class="span12">
									<div class="well" style="padding:30px;">										
										<cfoutput>
										<h5 style="font-size:16px;"><i style="margin-right:5px;color:red;" class="icon-warning-sign"></i> THIS APPLICATION WILL AUTOMATICALLY RESTART IN...<span style="margin-left:75px"><a href="" class="btn btn-mini btn-default"><i class="icon-off"></i> Cancel Restart</a><a href="" style="margin-left:7px;" class="btn btn-mini btn-secondary"><i class="icon-remove-sign"></i> Dismiss Message</a></span>								
											<span class="pull-right" style="margin-top:-20px;">
												<script type="application/javascript">
													var myCountdown2 = new Countdown({
														time: 90, 
														width:150, 
														height:75, 
														rangeHi:"minute"	// <- no comma on last item!
													});
												</script>												
											</span>
										</h5>
										<!--- // cf thread sleep does not work here // this is cheating // redirect to home page and update status --->
										<meta http-equiv="refresh" content="91;URL=index.cfm?event=page.index&restart=1&status=ready">
										</cfoutput>														
									</div>
								</div>
							</cfif>
							
							
							<div class="span6">	
								
								<div class="widget stacked">
										
									<div class="widget-header">
										<i class="icon-user"></i>
										<h3><cfoutput>Welcome, #mydashboarduser.firstname#!</cfoutput></h3>
									</div> <!-- /widget-header -->
									
									<div class="widget-content">
										
										<cfoutput>
										<div class="stats">
											
											<div class="stat">
												<span class="stat-value" style="font-size:14px;font-weight:bold;letter-spacing:0px;">#mydashboard.companyname#</span>									
												Company
											</div> <!-- /stat -->
											
											<div class="stat">
												<span class="stat-value" style="font-size:14px;font-weight:bold;letter-spacing:0px;">#mydashboarduser.deptname#</span>									
												Department
											</div> <!-- /stat -->
											
											<cfif mydashboarduser.lastlogindate neq "" and mydashboarduser.lastloginip neq "">
											<div class="stat">
												<span class="stat-value" style="font-size:12px;letter-spacing:0px;">#DateFormat( mydashboarduser.lastlogindate, "mm/dd/yyyy" )# from #mydashboarduser.lastloginip#</span>								
												<a href="#application.root#?event=page.loginhistory" title="View Login History">Last Login</a>											
											</div> <!-- /stat -->
											</cfif>
											
										</div> <!-- /stats -->										
										</cfoutput>
																				
									</div> <!-- /widget-content -->
										
								</div> <!-- /widget -->	
								
								<div class="widget stacked">
										
									<div class="widget-header">
										<i class="icon-dashboard"></i>
										<h3>Dashboard</h3>
									</div> <!-- /widget-header -->
									
									<div class="widget-content">
										
										<div class="stats">
											<cfoutput>
											<div class="stat">
												<span class="stat-value">#mydashboard.totalleads#</span>									
												Active Leads
											</div> <!-- /stat -->
											
											<div class="stat">
												<span class="stat-value">#mydashboard.totalclients#</span>									
												Total Clients
											</div> <!-- /stat -->
											
											<div class="stat">
												<span class="stat-value">#userreminderlist.recordcount#</span>										
												<a href="#application.root#?event=page.reminders">Your Reminders</a>												
											</div> <!-- /stat -->
											</cfoutput>	
										</div> <!-- /stats -->										
										
									</div> <!-- /widget-content -->
									
								</div> <!-- /widget -->	
								
								<div class="widget stacked">
										
									<div class="widget-header">
										<i class="icon-money"></i>
										<h3>Quick Stats</h3>
									</div> <!-- /widget-header -->
									
									<div class="widget-content">
										
										<div class="stats">
											<cfoutput>
											<div class="stat">
												<span class="stat-value">#mydashboard.totalloans#</span>									
												Total Student Loans Enrolled
											</div> <!-- /stat -->
											
											<div class="stat">
												<span class="stat-value">#dollarformat( mydashboard.totaldebt )#</span>									
												Total Student Loan Debt Enrolled
											</div> <!-- /stat -->
											
											<div class="stat">
												<span class="stat-value">0</span>									
												Total Solutions Implemented
											</div> <!-- /stat -->
											</cfoutput>
										</div> <!-- /stats -->										
										
									</div> <!-- /widget-content -->
										
								</div> <!-- /widget -->	
								
								<cfif isuserinrole( "admin" ) or isuserinrole( "co-admin" )>
									<div class="widget stacked">
												
										<div class="widget-header">
											<i class="icon-list-alt"></i>
											<h3>Dashboard Shortcuts</h3>
										</div> <!-- /widget-header -->
										
										<div class="widget-content">
											<cfoutput>
											<div class="shortcuts">
												<a href="#application.root#?event=page.leads" class="shortcut">
													<i class="shortcut-icon icon-bar-chart"></i>
													<span class="shortcut-label">Inquiries</span>
												</a>
												
												<a href="#application.root#?event=page.clients" class="shortcut">
													<i class="shortcut-icon icon-group"></i>
													<span class="shortcut-label">Clients</span>
												</a>
												
												<a href="#application.root#?event=page.library.forms" class="shortcut">
													<i class="shortcut-icon icon-book"></i>
													<span class="shortcut-label">Forms Library</span>								
												</a>
												
												<a href="#application.root#?event=page.reports" class="shortcut">
													<i class="shortcut-icon icon-briefcase"></i>
													<span class="shortcut-label">Reports</span>	
												</a>
												
												<a href="#application.root#?event=page.reminders" class="shortcut">
													<i class="shortcut-icon icon-calendar"></i>
													<span class="shortcut-label">Reminders</span>								
												</a>				
												
												<cfif isuserinrole( "admin" ) or isuserinrole( "co-admin" )>
												<a href="#application.root#?event=page.settings" class="shortcut">
													<i class="shortcut-icon icon-cogs"></i>
													<span class="shortcut-label">Settings</span>
												</a>

												<a href="#application.root#?event=page.users" class="shortcut">
													<i class="shortcut-icon icon-user"></i>
													<span class="shortcut-label">Users</span>
												</a>
												
												<a href="#application.root#?event=page.depts" class="shortcut">
													<i class="shortcut-icon icon-building"></i>
													<span class="shortcut-label">Departments</span>
												</a>
												
												</cfif>
											</div> <!-- / .shortcuts -->
											</cfoutput>
										</div> <!-- / .widget-content -->
									
									</div> <!-- / .widget -->											
								</cfif>
							</div> <!-- / .span6 -->
							
							
							<div class="span6">	
								
								<cfif isuserinrole( "intake" ) or isuserinrole( "sls" )>
									<!--- // show new assignments --->
									<div class="widget stacked">
											
										<div class="widget-header">
											<i class="icon-user"></i>
											<h3>New Client Assignments</h3>
										</div> <!-- / .widget-header -->
										
										<div class="widget-content">
											
											<cfif newassign.recordcount gt 0>
												<table class="table table-striped table-bordered">
													<thead>
														<tr>
															<th>Name</th>
															<th>Date Assigned</th>
															<th>Role</th>
															<th class="td-actions">Actions</th>
														</tr>
													</thead>
													<tbody>
														<cfoutput query="newassign">
															<tr>
																<td>#leadfirst# #leadlast#</td>
																<td>#dateformat( leadassigndate, "mm/dd/yyyy" )# <cfif datediff( "d", leadassigndate, now() ) lt 1><span class="label label-info" style="margin-left:25px;"><small>Days Assigned: &nbsp;Less than 1 day</small><cfelse><span class="label label-important" style="margin-left:25px;"><small>Days Assigned: </small>&nbsp; #datediff( "d", leadassigndate, now() )#</span></cfif></td>
																<td><span class="label label-default">#leadassignrole#</span>
																<td><a href="#application.root#?event=page.getlead&fuseaction=leadgen&leadid=#leaduuid#&acceptassignment=1" class="btn btn-mini btn-secondary">Accept</a></td>
															</tr>
														</cfoutput>
													</tbody>											
												</table>								
											
											<cfelse>
												<div class="alert alert-error" style="padding:5px;">												
													<i class="icon-warning-sign"></i> <strong>Sorry</strong>, you have no new client assignments.  You may click the link below to view all of your client assignments.
												</div>	
											</cfif>
											
											<cfoutput>
												<a href="#application.root#?event=page.client.assignments">View All Assignments</a>
											</cfoutput>
											
											
										</div>
									</div>
								</cfif>
								
								
								
								
								
								
								
								
								
								
								
								<cfif isuserinrole( "admin" ) or isuserinrole( "co-admin" )>
									<div class="widget stacked">
											
										<div class="widget-header">
											<i class="icon-bookmark"></i>
											<h3>Recent Activity</h3>
										</div> <!-- / .widget-header -->
										
										<div class="widget-content">
											
											<cfif logrecent.recordcount gt 0>
												<ul class="news-items">
													
													<cfoutput query="logrecent" maxrows="5">		
														<li>
															<div class="news-item-detail">										
																<a href="#application.root#?event=page.getlead&fuseaction=leadgen&leadid=#leaduuid#" class="news-item-title">#leadfirst# #leadlast#</a>
																<p class="news-item-preview" style="font-weight:bold;">#activitytype# by #firstname# #lastname#</p>													
																<p class="news-item-preview">#activity#</p>
															</div>
																	
															<div class="news-item-date">
																<span class="news-item-day">#datepart("d", recentdate)#</span>
																<span class="news-item-month">#monthasstring(month(recentdate))#</span>
															</div>
														</li>
													</cfoutput>
													
												</ul>
											<cfelse>
											
												<div class="alert alert-notice" style="padding:5px;">												
													<i class="icon-warning-sign"></i> <strong>NO RECORDS FOUND!</strong> Sorry, no recent activity is available.  Client records will auto-populate the recent activity once created.  Please click New Inquiry to get started.
												</div>										
											
											</cfif>
										
										</div> <!-- / .widget-content -->
										
									</div> <!-- / .widget -->									
								</cfif>		
								

								<!--- // show client list --->
								
								<cfif not isuserinrole( "co-admin" )>
									<div class="widget stacked widget-table action-table">
											
										<div class="widget-header">
											<i class="icon-group"></i>
											<h3>Recent Clients</h3>
										</div> <!-- /. widget-header -->
										
										<div class="widget-content">
											
											<cfif dashboardclients.recordcount gt 0>
												<table class="table table-striped table-bordered">
													<thead>
														<tr>
															<th>Name</th>
															<th>Enroll Date</th>
															<th class="td-actions">Actions</th>
														</tr>
													</thead>
													<tbody>
														<cfoutput query="dashboardclients" maxrows="6">
															<tr>
																<td>#leadfirst# #leadlast#</td>
																<td><span class="label label-inverse">#dateformat( slenrollreturndate, "mm/dd/yyyy" )#</span> <span style="margin-left:7px;" class="label label-info"><small>Days Enrolled: </small>&nbsp; #datediff( "d", leaddate, now() )#</span>
																<td class="td-actions">
																	
																	<a href="#application.root#?event=page.getlead&fuseaction=leadgen&leadid=#leaduuid#" class="btn btn-small btn-warning">
																		<i class="btn-icon-only icon-ok"></i>										
																	</a>

																	<a href="#application.root#?event=page.getlead&fuseaction=leadgen&leadid=#leaduuid#" class="btn btn-small btn-secondary">
																		<i class="btn-icon-only icon-tasks"></i>										
																	</a>
																	
																</td>
															</tr>
														</cfoutput>
													</tbody>
												</table>
											<cfelse>
												
												<cfoutput>
													<div style="padding:15px;margin-bottom:35px;">
														<a href="#application.root#?event=page.lead.new" class="btn btn-default btn-medium"><i class="icon-user"></i> Create New Inquiry</a>
													</div>
												</cfoutput>
												
											</cfif>
											
										</div> <!-- / .widget-content -->
									
									</div> <!-- / .widget -->
								</cfif>				
							  </div> <!-- / .span6 -->
							
						  </div> <!-- / .row -->

						</div> <!-- / .container -->
						
					</div> <!-- / .main -->
