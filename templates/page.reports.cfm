
			
			
			<!--- // get our data access components --->
			<cfinvoke component="apis.com.ui.dashboardgateway" method="getmydashboard" returnvariable="mydashboard">
				<cfinvokeargument name="companyid" value="#session.companyid#">
			</cfinvoke>
			
			<!--- // get our data access components --->
			<cfinvoke component="apis.com.admin.admindashboard" method="getreportdashboard" returnvariable="reportdashboard">
				<cfinvokeargument name="companyid" value="#session.companyid#">
				<cfinvokeargument name="userid" value="#session.userid#">
			</cfinvoke>
			
			
			
			
			<!--- reports page --->
			
			
			<link href="./css/pages/reports.css" rel="stylesheet">
			
			<script src="./js/charts/pie.js"></script>
			<script src="./js/charts/bar.js"></script>
			
			
					
			<div class="main">

				<div class="container">
					
				  <div class="row">
				  
					<div class="span12">
					
					<cfif structkeyexists( url, "noaccess" ) and url.noaccess eq 1>
						<div class="alert alert-block alert-error">
							<button type="button" class="close" data-dismiss="alert">&times;</button>
							<h4><strong>Sorry</strong>, you do not have access to this report in your current user role.</h4>
							<p><i class="icon-warning-sign"></i> Security Event Logged!  Please use the small X to the right to dismiss this message....</p>											
						</div>
					</cfif>
						
						<div class="widget stacked">
							
							<cfoutput>
								<div class="widget-header">
									<span class="icon-upload"></span>
									<h3 style="font-weight:bold;">#session.companyname# | Report Dashboard</h3>
								</div> <!-- .widget-header -->
								</cfoutput>
							
							<div class="widget-content">
								
								<div class="row" style="margin-left:5px;margin-right:5px;">
											<cfoutput>
											
												<div id="big_stats" class="cf">													
																					
													<div class="stat">								
														<h4>Total Lead Sources</h4>
														<span class="value"><small>#numberformat( reportdashboard.totalleadsources, "999,999" )#</small></span>								
													</div> <!-- .stat -->
																					
													<div class="stat">								
														<h4>Total E-Sign</h4>
														<span class="value"><small>#numberformat( reportdashboard.totalesign, "999,999" )#</small></span>								
													</div> <!-- .stat -->																
																					
													<div class="stat">								
														<h4>Total NSLDS</h4>
														<span class="value"><small>#numberformat( reportdashboard.totalnslds, "999,999" )#</small></span>								
													</div> <!-- .stat -->
													
													<div class="stat">								
														<h4>Total Tasks</h4>
														<span class="value"><small>#numberformat( reportdashboard.totaltasks, "999,999" )#</small></span>								
													</div> <!-- .stat -->
													
																									
												</div>
											
											</cfoutput>				
										</div><!-- / .row -->
										
										
										<div class="row" style="margin-left:5px;margin-right:5px;margin-top:10px;padding-top:10px;border-top:1px dotted #f2f2f2;">
											<cfoutput>
											
												<div id="big_stats" class="cf">													
																					
													<div class="stat">								
														<h4>Total Clients</h4>
														<span class="value"><small>#numberformat( reportdashboard.totalclients, "999,999" )#</small></span>								
													</div> <!-- .stat -->
																					
													<div class="stat">								
														<h4>Total Worksheets</h4>
														<span class="value"><small>#numberformat( reportdashboard.totalworksheets, "999,999" )#</small></span>								
													</div> <!-- .stat -->																
																					
													<div class="stat">								
														<h4>Total Solutions</h4>
														<span class="value"><small>#numberformat( reportdashboard.totalsolutions, "999,999" )#</small></span>								
													</div> <!-- .stat -->
													
													<div class="stat">								
														<h4>Total Implementations</h4>
														<span class="value"><small>#numberformat( reportdashboard.totalimpplans, "999,999" )#</small></span>								
													</div> <!-- .stat -->													
																									
												</div>
											
											</cfoutput>				
										</div><!-- / .row -->
							
							</div> <!-- /widget-content -->
							
						</div> <!-- /widget -->
						
					</div> <!-- /span12 -->	
					
				  </div> <!-- /row -->	  
				  
				  
					<div class="row">
					
						<div class="span6">
						
							<div class="widget stacked widget-table">
								
								<cfoutput>
								<div class="widget-header">
									<span class="icon-list-alt"></span>
									<h3 style="font-weight:bold;">#session.companyname# | Supervisor Enrollment Reports Menu</h3>
								</div> <!-- .widget-header -->
								</cfoutput>
								
								<div class="widget-content">
									<table class="table table-bordered table-striped">
										
										<thead>
											<tr>								
												<th>Report Name</th>
												<th align="center">Run Report</th>								
											</tr>
										</thead>
								
										<tbody>
											<cfoutput>
												
												<!--- // start with supervisory reports --->
												<cfif isuserinrole( "admin" ) or isuserinrole( "co-admin" )>
												
													<tr>
														<td class="description"><span style="margin-right:5px;" class="label label-important">NEW</span><a href="#application.root#?event=page.reports.enrollment">Outstanding Enrollment Report</a></td>
														<td align="center" class="value"><a href="#application.root#?event=page.reports.enrollment" class="btn btn-small btn-default"><i class="icon-laptop btn-icon-only"></i></a></td>
													</tr>
													
													<tr>
														<td class="description"><span style="margin-right:5px;" class="label label-important">NEW</span><a href="#application.root#?event=page.reports.enrolled">Clients Enrolled Report</a></td>
														<td align="center" class="value"><a href="#application.root#?event=page.reports.enrolled" class="btn btn-small btn-default"><i class="icon-laptop btn-icon-only"></i></a></td>
													</tr>
													
													<tr>
														<td class="description"><span style="margin-right:5px;" class="label label-important">NEW</span><a href="#application.root#?event=page.reports.leadsource">Inquiry Summary Report</a></td>
														<td align="center" class="value"><a href="#application.root#?event=page.reports.leadsource" class="btn btn-small btn-default"><i class="icon-laptop btn-icon-only"></i></a></td>
													</tr>

													
												
												</cfif>
												
											</cfoutput>
										</tbody>
									</table>
									
								</div> <!-- .widget-content -->
								
							</div> <!-- /widget -table -->

							<div class="widget stacked widget-table">
								
								<cfoutput>
								<div class="widget-header">
									<span class="icon-list-alt"></span>
									<h3>#session.companyname# | Supervisor Intake Reports Menu</h3>
								</div> <!-- .widget-header -->
								</cfoutput>
								
								<div class="widget-content">
									<table class="table table-bordered table-striped">
										
										<thead>
											<tr>								
												<th>Report Name</th>
												<th>Run Report</th>								
											</tr>
										</thead>
								
										<tbody>
											<cfoutput>
												<tr>
													<td class="description"><span style="margin-right:5px;" class="label label-important">NEW</span><a href="#application.root#?event=page.reports.intake.pipeline">Intake Pipeline Report</a></td>
													<td align="center" class="value"><a href="#application.root#?event=page.reports.intake.pipline" class="btn btn-small btn-default"><i class="icon-laptop btn-icon-only"></i></a></td>
												</tr>													
												<tr>
													<td class="description"><span style="margin-right:5px;" class="label label-important">NEW</span><a href="#application.root#?event=page.reports.intake">Intake Completed Report</a></td>
													<td align="center" class="value"><a href="#application.root#?event=page.reports.intake" class="btn btn-small btn-default"><i class="icon-laptop btn-icon-only"></i></a></td>
												</tr>
																								
											</cfoutput>										
										</tbody>
									</table>
									
								</div> <!-- .widget-content -->
								
							</div><!-- / .widget-table -->
							
							<div class="widget stacked widget-table">
								
								<cfoutput>
								<div class="widget-header">
									<span class="icon-list-alt"></span>
									<h3>#session.companyname# | Supervisor Advisory Reports Menu</h3>
								</div> <!-- .widget-header -->
								</cfoutput>
								
								<div class="widget-content">
									<table class="table table-bordered table-striped">
										
										<thead>
											<tr>								
												<th>Report Name</th>
												<th>Run Report</th>								
											</tr>
										</thead>
								
										<tbody>
											<cfoutput>
												<tr>
													<td class="description"><span style="margin-right:5px;" class="label label-important">NEW</span><a href="#application.root#?event=page.reports">Cases Waiting Solutions</a></td>
													<td align="center" class="value"><a href="#application.root#?event=page.reports" class="btn btn-small btn-default"><i class="icon-laptop btn-icon-only"></i></a></td>
												</tr>
												<tr>
													<td class="description"><span style="margin-right:5px;" class="label label-important">NEW</span><a href="#application.root#?event=page.reports">Solutions Not Completed</a></td>
													<td align="center" class="value"><a href="#application.root#?event=page.reports" class="btn btn-small btn-default"><i class="icon-laptop btn-icon-only"></i></a></td>
												</tr>
												<tr>
													<td class="description"><span style="margin-right:5px;" class="label label-important">NEW</span><a href="#application.root#?event=page.reports.advisor.accepted">Advisor Cases Waiting Acceptance </a></td>
													<td align="center" class="value"><a href="#application.root#?event=page.reports" class="btn btn-small btn-default"><i class="icon-laptop btn-icon-only"></i></a></td>
												</tr>
												<tr>
													<td class="description"><span style="margin-right:5px;" class="label label-important">NEW</span><a href="#application.root#?event=page.reports">Completed Advisory Cases </a></td>
													<td align="center" class="value"><a href="#application.root#?event=page.reports" class="btn btn-small btn-default"><i class="icon-laptop btn-icon-only"></i></a></td>
												</tr>
																								
											</cfoutput>										
										</tbody>
									</table>	

									
								</div> <!-- .widget-content -->
								
							</div><!-- / .widget-table -->
							
							
							
							
							
							
						</div> <!-- /span6 -->
						
						
						
						<div class="span6">
							
							
							
							
							<div class="widget stacked widget-table">
								
								<cfoutput>
								<div class="widget-header">
									<span class="icon-list-alt"></span>
									<h3>#session.companyname# | Supervisor Summary Reports Menu</h3>
								</div> <!-- .widget-header -->
								</cfoutput>
								
								<div class="widget-content">
									<table class="table table-bordered table-striped">
										
										<thead>
											<tr>								
												<th>Report Name</th>
												<th>Run Report</th>								
											</tr>
										</thead>
								
										<tbody>
											<cfoutput>
												<tr>
													<td class="description"><span style="margin-right:5px;" class="label label-important">NEW</span><a href="#application.root#?event=page.reports.summary.example">Example Report 1</a></td>
													<td align="center" class="value"><a href="#application.root#?event=page.reports.summary.example" class="btn btn-small btn-default"><i class="icon-laptop btn-icon-only"></i></a></td>
												</tr>													
												<tr>
													<td class="description"><span style="margin-right:5px;" class="label label-important">NEW</span><a href="#application.root#?event=page.reports">Not Defined</a></td>
													<td align="center" class="value"><a href="#application.root#?event=page.reports" class="btn btn-small btn-default"><i class="icon-laptop btn-icon-only"></i></a></td>
												</tr>
																								
											</cfoutput>										
										</tbody>
									</table>
									
								</div> <!-- .widget-content -->
								
							</div><!-- / .widget-table -->
							
						</div> <!-- / .span6 -->			
						
					
					</div> <!-- / .row -->
				    <div style="margin-top:100px;"></div>
				  
				</div> <!-- / .container -->
				
			</div> <!-- / .main -->