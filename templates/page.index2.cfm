
					

					<!--- // include the data access components for the dashboard --->
					<cfinvoke component="apis.com.ui.dashboardgateway" method="getmydashboard" returnvariable="mydashboard">			
						<cfinvokeargument name="companyid" value="#session.companyid#">
					</cfinvoke>					
					
					<cfinvoke component="apis.com.leads.leadgateway" method="getrecentactivity" returnvariable="logrecent">			
						<cfinvokeargument name="userid" value="#session.userid#">
					</cfinvoke>					
					
					<cfinvoke component="apis.com.ui.dashboardgateway" method="getrandomclients" returnvariable="dashboardclients">
						<cfinvokeargument name="companyid" value="#session.companyid#">
					</cfinvoke>
					
					
					<div class="main">

						<div class="container">

						  <div class="row">
						  
							<cfif structkeyexists( url, "error" ) and url.error eq 1 >
								<div class="span12">
									<div class="alert alert-error">
										<button type="button" class="close" data-dismiss="alert">&times;</button>
										<i class="icon-warning-sign"></i> <strong>UNAUTHORIZED ACCESS!</strong>  You have attempted to access a private system resource.  This is not allowed and is a violation of your <i>terms of use</i>.  Your user activity and ID have been logged and reported to the system administrator.  You can dismiss this message by clicking the 'X' in the upper right hand corner of the dialog.
									</div>
								</div>
							</cfif>
							
							<div class="span6">	
								
								<div class="widget stacked">
										
									<div class="widget-header">
										<i class="icon-user"></i>
										<h3><cfoutput>Welcome #session.username#</cfoutput></h3>
									</div> <!-- /widget-header -->
									
									<div class="widget-content">
										
										<cfoutput>
										<div class="stats">
											
											<div class="stat">
												<span class="stat-value" style="font-size:14px;font-weight:bold;letter-spacing:0px;">#session.companyname#</span>									
												Company
											</div> <!-- /stat -->
											
											<div class="stat">
												<span class="stat-value" style="font-size:14px;font-weight:bold;letter-spacing:0px;">#session.deptname#</span>									
												Department
											</div> <!-- /stat -->
											
											<div class="stat">
												<span class="stat-value" style="font-size:12px;letter-spacing:0px;">#DateFormat(session.lastdate, "mm/dd/yyyy")# from #session.lastip#</span>									
												<a href="#application.root#?event=page.loginhistory" title="View Login History">Last Login</a> 
												
											</div> <!-- /stat -->
										
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
												<span class="stat-value">18</span>									
												<a href="#application.root#?event=page.reminders">Active Reminders</a>
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
												Total Student Loan Debt
											</div> <!-- /stat -->
											
											<div class="stat">
												<span class="stat-value">0</span>									
												Total Solutions Implemented
											</div> <!-- /stat -->
											</cfoutput>
										</div> <!-- /stats -->										
										
									</div> <!-- /widget-content -->
										
								</div> <!-- /widget -->	
								
								
								<div class="widget stacked">
											
									<div class="widget-header">
										<i class="icon-list-alt"></i>
										<h3>Dashboard Shortcuts</h3>
									</div> <!-- /widget-header -->
									
									<div class="widget-content">
										
										<div class="shortcuts">
											<a href="javascript:;" class="shortcut">
												<i class="shortcut-icon icon-group"></i>
												<span class="shortcut-label">Leads</span>
											</a>
											
											<a href="javascript:;" class="shortcut">
												<i class="shortcut-icon icon-bookmark"></i>
												<span class="shortcut-label">Activity</span>								
											</a>
											
											<a href="javascript:;" class="shortcut">
												<i class="shortcut-icon icon-briefcase"></i>
												<span class="shortcut-label">Reports</span>	
											</a>
											
											<a href="javascript:;" class="shortcut">
												<i class="shortcut-icon icon-calendar"></i>
												<span class="shortcut-label">Reminders</span>								
											</a>										
											
											<a href="javascript:;" class="shortcut">
												<i class="shortcut-icon icon-file"></i>
												<span class="shortcut-label">Notes</span>	
											</a>
											
											<a href="javascript:;" class="shortcut">
												<i class="shortcut-icon icon-check"></i>
												<span class="shortcut-label">Questionnaire</span>	
											</a>
											
											<a href="javascript:;" class="shortcut">
												<i class="shortcut-icon icon-cogs"></i>
												<span class="shortcut-label">Settings</span>
											</a>

											<a href="javascript:;" class="shortcut">
												<i class="shortcut-icon icon-user"></i>
												<span class="shortcut-label">Users</span>
											</a>
										</div> <!-- / .shortcuts -->
										
									</div> <!-- / .widget-content -->
								
								</div> <!-- / .widget -->											
								
							</div> <!-- / .span6 -->
							
							
							<div class="span6">	
								
								
								<div class="widget stacked">
										
									<div class="widget-header">
										<i class="icon-bookmark"></i>
										<h3>Recent Activity</h3>
									</div> <!-- / .widget-header -->
									
									<div class="widget-content">
										
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
									
									</div> <!-- / .widget-content -->
									
								</div> <!-- / .widget -->									
										
								

								<!--- // show client list --->
								
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
											<div class="alert alert-info">
												<button type="button" class="close" data-dismiss="alert">&times;</button>
												<i class="icon-warning-sign"></i> <strong>NO RECORDS FOUND!</strong> Sorry, no recent clients records were found.  Please get started by creating a new inquiry...
											</div>
										</cfif>
										
									</div> <!-- / .widget-content -->
								
								</div> <!-- / .widget -->
												
							  </div> <!-- / .span6 -->
							
						  </div> <!-- / .row -->

						</div> <!-- / .container -->
						
					</div> <!-- / .main -->
