
				
			
			
			
			<!--- // get our data access components --->

			<!--- // get the system activity --->
			<cfinvoke component="apis.com.system.activitylog" method="getsystemactivity" returnvariable="systemactivity">
			
			<!--- // get activity types --->
			<cfinvoke component="apis.com.system.activitylog" method="getactivitytypes" returnvariable="a1">
			
			<!--- user filter --->
			<cfinvoke component="apis.com.system.activitylog" method="getsystemusers" returnvariable="userlist">

			<!--- // side bar stats data --->
			<cfinvoke component="apis.com.admin.admindashboard" method="getreportdashboard" returnvariable="reportdashboard">
				<cfinvokeargument name="companyid" value="#session.companyid#">
				<cfinvokeargument name="userid" value="#session.userid#">
			</cfinvoke>
			
			






					<!--- // system activity log --->
					<div class="main">
					
						<div class="container">
						
							<div class="row">
								
								<div class="span9">
								
									<div class="widget stacked">
									
										<div class="widget-header">
											<i class="icon-globe"></i>
											<h3>System Activity Log
										</div>
										
										<div class="widget-content">
											
											<!--- // report filter --->								
											<cfoutput>
												<div class="well">
													<p><i class="icon-check"></i> Filter Your Results</p>
													<form class="form-inline" name="filterresults" method="post">																				
														
														<select name="userid" style="margin-left:5px;" class="input-large" onchange="javascript:this.form.submit();">
															<option value="0">Filter By User</option>
																<cfloop query="userlist">
																	<option value="#userid#"<cfif isdefined( "form.userid" ) and form.userid eq userlist.userid>selected</cfif>>#firstname# #lastname# - #dba#</option>
																</cfloop>												
														</select>
														
														<select name="acttype" style="margin-left:5px;" class="input-large" onchange="javascript:this.form.submit();">
															<option value="">Filter By Activity Type</option>
																<cfloop query="a1">
																	<option value="#acttype#"<cfif isdefined( "form.acttype" ) and form.acttype eq a1.acttype>selected</cfif>>#acttype#</option>
																</cfloop>												
														</select>														
														<input type="text" name="username" style="margin-left:5px;" class="input-large" placeholder="Filter By Name" value="<cfif isdefined( "form.username" )>#trim( form.username )#</cfif>">
														<br /><br />
														<input type="text" name="startdate" style="margin-left:5px;" class="input-medium" placeholder="Start Date" id="datepicker-inline4" value="<cfif isdefined( "form.startdate" )>#dateformat( form.startdate, 'mm/dd/yyyy' )#</cfif>">
														<input type="text" name="enddate" style="margin-left:5px;" class="input-medium" placeholder="End Date" id="datepicker-inline5" value="<cfif isdefined( "form.enddate" )>#dateformat( form.enddate, 'mm/dd/yyyy' )#</cfif>">
														<input type="hidden" name="filtermyresults">
														<button type="submit" style="margin-left:5px;" name="filterresults" class="btn btn-small btn-secondary"><i class="icon-search"></i> Filter Results</button>
														<cfif structkeyexists( form, "filtermyresults" )><button type="reset" onclick="location.href='#application.root#?event=#url.event#'" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-check"></i> Reset List</button></cfif>
													</form>
												</div>
											</cfoutput>
											<!--- // end filter --->
												
											
											
											
											
											
											
											
											
											
											<cfif systemactivity.recordcount gt 0>
											
												<!--- activity log pagination --->
												<cfparam name="startrow" default="1">
												<cfparam name="displayrows" default="50">
												<cfparam name="torow" default="0">												
												
												<cfset torow = startrow + ( displayrows - 1 ) />
												<cfif torow gt systemactivity.recordcount>
													<cfset torow = systemactivity.recordcount />
												</cfif>												
												
												<cfset next = startrow + displayrows>
												<cfset prev = startrow - displayrows>
												
												
												
												
												
												
												
												
												
												<cfoutput>
													<h5><i style="margin-right:5px;" class="icon-th-large"></i> Found #systemactivity.recordcount# records found | Displaying #startrow# to #torow#      <span class="pull-right"><a style="margin-bottom:5px;" href="#application.root#?event=page.admin" class="btn btn-small btn-tertiary"><i class="icon-home"></i> Admin Home</a> <cfif prev gte 1><a style="margin-left:5px;margin-bottom:5px;" href="#application.root#?event=#url.event#&startrow=#prev#" class="btn btn-small btn-secondary"><i class="icon-circle-arrow-left"></i> Previous #displayrows# Records</a></cfif><cfif next lte systemactivity.recordcount><a style="margin-bottom:5px;margin-left:5px;" class="btn btn-small btn-default" href="#application.root#?event=#url.event#&startrow=#next#">Next <cfif ( systemactivity.recordcount - next ) lt displayrows>#evaluate(( systemactivity.recordcount - next ) + 1 )#<cfelse>#displayrows#</cfif> Records <i class="icon-circle-arrow-right"></i></a></cfif></h5>
												</cfoutput>
												
												
													<table class="table table-bordered table-striped">
														<thead>
															<tr>														
																<th width="15%">Date</th>
																<th>Type</th>
																<th>User</th>
																<th>Activity</th>												
															</tr>
														</thead>
														<tbody>
															<cfoutput query="systemactivity" startrow="#startrow#" maxrows="#displayrows#">
															<tr>															
																<td>#dateformat( activitydate, "mm/dd/yyyy" )#</td>
																<td>#activitytype#</td>
																<td>#firstname# #lastname#</td>
																<td>#activity#
															</tr>
															</cfoutput>											
														</tbody>
													</table>
											
											
											
											
											<cfelse>
											
											
												<div class="alert alert-block alert-info">
													<button type="button" class="close" data-dismiss="alert">&times;</button>
													<h3><i style="font-weight:bold;" class="icon-warning-sign"></i>WARNING!</h3>
													<p>Sorry, the system can not find any activity records...</p>
												</div>							
											
											
											
											</cfif>
											
											
											
											
											
										</div>
									
									</div>
								
								</div><!-- / .span9 -->
								
								
								
								<div class="span3">
									
									<div class="widget stacked">
									
										<div class="widget-header">
											<i class="icon-star"></i>
											<h3>System Stats</h3>
										</div>
										
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
																					
														
														<!---
														<div class="stat">								
															<h4>Total NSLDS</h4>
															<span class="value"><small>#numberformat( reportdashboard.totalnslds, "999,999" )#</small></span>								
														</div> <!-- .stat -->
														<br />
														<div class="stat">								
															<h4>Total Tasks</h4>
															<span class="value"><small>#numberformat( reportdashboard.totaltasks, "999,999" )#</small></span>								
														</div> <!-- .stat -->
														--->
																										
													</div>
												
												</cfoutput>				
											</div><!-- / .row -->
											
											<div class="row" style="margin-left:5px;margin-right:5px;">
												<cfoutput>
												
													<div id="big_stats" class="cf">													
														<!---								
														<div class="stat">								
															<h4>Total Lead Sources</h4>
															<span class="value"><small>#numberformat( reportdashboard.totalleadsources, "999,999" )#</small></span>								
														</div> <!-- .stat -->
																			
														<div class="stat">								
															<h4>Total E-Sign</h4>
															<span class="value"><small>#numberformat( reportdashboard.totalesign, "999,999" )#</small></span>								
														</div> <!-- .stat -->																
														--->				
														
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
														
														<!---														
														<div class="stat">								
															<h4>Total Solutions</h4>
															<span class="value"><small>#numberformat( reportdashboard.totalsolutions, "999,999" )#</small></span>								
														</div> <!-- .stat -->
														
														<div class="stat">								
															<h4>Total Implementations</h4>
															<span class="value"><small>#numberformat( reportdashboard.totalimpplans, "999,999" )#</small></span>								
														</div> <!-- .stat -->													
														--->												
													</div>
												
												</cfoutput>				
											</div><!-- / .row -->
											
											
											<div class="row" style="margin-left:5px;margin-right:5px;margin-top:10px;padding-top:10px;border-top:1px dotted #f2f2f2;">
												<cfoutput>
												
													<div id="big_stats" class="cf">													
														
														<!---														
														<div class="stat">								
															<h4>Total Clients</h4>
															<span class="value"><small>#numberformat( reportdashboard.totalclients, "999,999" )#</small></span>								
														</div> <!-- .stat -->
																						
														<div class="stat">								
															<h4>Total Worksheets</h4>
															<span class="value"><small>#numberformat( reportdashboard.totalworksheets, "999,999" )#</small></span>								
														</div> <!-- .stat -->																
														--->
																											
														<div class="stat">								
															<h4>Total Solutions</h4>
															<span class="value"><small>#numberformat( reportdashboard.totalsolutions, "999,999" )#</small></span>								
														</div> <!-- .stat -->
														
														<div class="stat">								
															<h4>Total Plans</h4>
															<span class="value"><small>#numberformat( reportdashboard.totalimpplans, "999,999" )#</small></span>								
														</div> <!-- .stat -->													
																										
													</div>
												
												</cfoutput>				
											</div><!-- / .row -->			
										
										</div><!-- / .widget-content -->
									
									</div><!-- / .widget -->									
									
									<!-- // shortcuts --->		
									<div class="widget stacked">
											
										<div class="widget-header">
											<i class="icon-star"></i>
											<h3>Shortcuts</h3>
										</div>
												
										<cfoutput>
											<div class="widget-content">
												<div class="shortcuts">
													
													<a href="#application.root#?event=page.company.activity" class="shortcut">
														<i class="shortcut-icon icon-coffee"></i>
														<span class="shortcut-label">User<br /> Activity</span>	
													</a>		
													<a href="#application.root#?event=page.manage.leads" class="shortcut">
														<i class="shortcut-icon icon-group"></i>
														<span class="shortcut-label">Manage<br /> Company Data</span>
													</a>													
													<a href="#application.root#?event=page.settings" class="shortcut">
														<i class="shortcut-icon icon-cogs"></i>
														<span class="shortcut-label">Settings<br />&nbsp;</span>
													</a>							
													<a href="#application.root#?reinit=true" onclick="javascript:return confirm('This will restart the application.  Do you wish to continue?');" class="shortcut">
														<i class="shortcut-icon icon-off"></i>
														<span class="shortcut-label">Restart<br /> Application</span>
													</a>													
												</div><!-- / .shortcuts -->
											</div><!-- / .widget-content -->
										</cfoutput>
									</div><!-- / .widget -->								
								</div><!-- / .span3 -->
								
							</div><!-- / .row -->
						
						</div><!-- / .container -->
					
					</div><!-- / .main -->
			
			