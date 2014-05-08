

			<!--- // protect the admin page --->
			<cfif not isuserinrole( "admin" )>
				<cflocation url="#application.root#?event=page.index&error=1" addtoken="no">
			</cfif>
			
			
			<cfif structkeyexists( session, "primarycompanyid" )>
				<cfparam name="tempQC" default="">
				<cfparam name="tempQR" default="">
				<cfset tempQC = structdelete( session, "companyid" ) />
				<cfset session.companyid = #session.primarycompanyid# />
				<cfset tempQR = structdelete( session, "primarycompanyid" ) />
				<cflocation url="#application.root#?event=page.admin" addtoken="no">
			</cfif>
			
			
			
			<!--- get our data access components --->
			<cfinvoke component="apis.com.admin.admindashboard" method="getadmindashboard" returnvariable="admindashboard">


			
			
			
			<!--- // Administration --->
			
			
			<div class="main">	
					
					<div class="container">
						
						<div class="row">
				
							<div class="span12">
								
								<div class="widget stacked">
									
									<div class="widget-header">		
										<i class="icon-book"></i>							
										<h3>Administration | Admin Dashboard</h3>						
									</div> <!-- //.widget-header -->
									
									<div class="widget-content">						
										
										<!--- // admin stats ---> 
										<div class="row" style="margin-left:5px;margin-right:5px;">
											<cfoutput>
											
												<div id="big_stats" class="cf">													
																					
													<div class="stat">								
														<h4>Total Companies</h4>
														<span class="value"><small>#numberformat( admindashboard.totalcompanies, "999,999" )#</small></span>								
													</div> <!-- .stat -->
																					
													<div class="stat">								
														<h4>Total Lead Sources</h4>
														<span class="value"><small>#numberformat( admindashboard.totalleadsources, "999,999" )#</small></span>								
													</div> <!-- .stat -->																
																					
													<div class="stat">								
														<h4>Total NSLDS</h4>
														<span class="value"><small>#numberformat( admindashboard.totalnslds, "999,999" )#</small></span>								
													</div> <!-- .stat -->
													
													<div class="stat">								
														<h4>Total Tasks</h4>
														<span class="value"><small>#numberformat( admindashboard.totaltasks, "999,999" )#</small></span>								
													</div> <!-- .stat -->
													
																									
												</div>
											
											</cfoutput>				
										</div><!-- / .row -->
										
										
										<div class="row" style="margin-left:5px;margin-right:5px;margin-top:10px;padding-top:10px;border-top:1px dotted #f2f2f2;">
											<cfoutput>
											
												<div id="big_stats" class="cf">													
																					
													<div class="stat">								
														<h4>Total Clients</h4>
														<span class="value"><small>#numberformat( admindashboard.totalclients, "999,999" )#</small></span>								
													</div> <!-- .stat -->
																					
													<div class="stat">								
														<h4>Total Worksheets</h4>
														<span class="value"><small>#numberformat( admindashboard.totalworksheets, "999,999" )#</small></span>								
													</div> <!-- .stat -->																
																					
													<div class="stat">								
														<h4>Total Solutions</h4>
														<span class="value"><small>#numberformat( admindashboard.totalsolutions, "999,999" )#</small></span>								
													</div> <!-- .stat -->
													
													<div class="stat">								
														<h4>Total Implementations</h4>
														<span class="value"><small>#numberformat( admindashboard.totalimpplans, "999,999" )#</small></span>								
													</div> <!-- .stat -->													
																									
												</div>
											
											</cfoutput>				
										</div><!-- / .row -->
										
										
										
										
										
										
										<div class="row" style="margin-top:50px;">
											
											<!--- // shortcuts menu --->
											<h3 style="text-align:center;"><i class="icon-cogs"></i> System Shortcuts</h3>
											
											
											<cfoutput>
												<div class="shortcuts">
													
													<div class="row">
													
														<a href="#application.root#?event=page.admin.company" class="shortcut">
															<i class="shortcut-icon icon-briefcase"></i>
															<span class="shortcut-label">Companies<br />&nbsp;</span>
														</a>
														
														<a href="#application.root#?event=page.manage.leads" class="shortcut">
															<i class="shortcut-icon icon-group"></i>
															<span class="shortcut-label">Manage<br /> Company Data</span>
														</a>
														
														<a href="#application.root#?event=page.system.activity" class="shortcut">
															<i class="shortcut-icon icon-globe"></i>
															<span class="shortcut-label">System<br /> Activity</span>								
														</a>
														
														<a href="#application.root#?event=page.company.activity" class="shortcut">
															<i class="shortcut-icon icon-coffee"></i>
															<span class="shortcut-label">User<br /> Activity</span>	
														</a>
														
														<a href="#application.root#?event=page.reminders" class="shortcut">
															<i class="shortcut-icon icon-calendar"></i>
															<span class="shortcut-label">Reminders<br />&nbsp;</span>								
														</a>											
													</div>
													
													
													<div class="row">	
														
														<a href="#application.root#?event=page.menu.survey" class="shortcut">
															<i class="shortcut-icon icon-check"></i>
															<span class="shortcut-label">Questionnaire<br />&nbsp;</span>	
														</a>
														
														<a href="#application.root#?event=page.settings" class="shortcut">
															<i class="shortcut-icon icon-cogs"></i>
															<span class="shortcut-label">Settings<br />&nbsp;</span>
														</a>

														<a href="#application.root#?event=page.users" class="shortcut">
															<i class="shortcut-icon icon-user"></i>
															<span class="shortcut-label">Users<br />&nbsp;</span>
														</a>
														
														<a href="#application.root#?event=page.depts" class="shortcut">
															<i class="shortcut-icon icon-building"></i>
															<span class="shortcut-label">Departments<br />&nbsp;</span>
														</a>
														
														<a href="#application.root#?reinit=true" onclick="javascript:return confirm('This will restart the application.  Do you wish to continue?');" class="shortcut">
															<i class="shortcut-icon icon-off"></i>
															<span class="shortcut-label">Restart<br /> Application</span>
														</a>
													
													</div>
													
													
													<div class="row">
														<p>&nbsp;</p>
													</div>
												</div> <!-- / .shortcuts -->								
											</cfoutput>
										</div>								
									
									</div> <!-- //.widget-content -->	
										
								</div> <!-- //.widget -->
								
							</div> <!-- //.span12 -->
							
						</div> <!-- //.row -->			
					
					
						<div style="height:200px;"></div>			
					
					</div> <!-- //.container -->
				
				</div> <!-- //.main -->