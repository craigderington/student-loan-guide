


		<!--- // company administration--->
		
		
		<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
							
							<div class="widget stacked">
								<cfoutput>
									<div class="widget-header">		
										<i class="icon-book"></i>							
										<h3>Company Administration for #session.companyname#</h3>						
									</div> <!-- //.widget-header -->
								</cfoutput>
								<div class="widget-content">						
									
									
									<cfoutput>
									<div class="shortcuts">
											<a href="#application.root#?event=page.manage.leads" class="shortcut">
												<i class="shortcut-icon icon-group"></i>
												<span class="shortcut-label">Manage<br /> Leads</span>
											</a>
											
											<a href="#application.root#?event=page.company.activity" class="shortcut">
												<i class="shortcut-icon icon-bookmark"></i>
												<span class="shortcut-label">User<br /> Activity</span>								
											</a>
											
											<a href="#application.root#?event=page.reports" class="shortcut">
												<i class="shortcut-icon icon-briefcase"></i>
												<span class="shortcut-label">Reports<br />&nbsp;</span>	
											</a>
											
											<a href="#application.root#?event=page.reminders" class="shortcut">
												<i class="shortcut-icon icon-calendar"></i>
												<span class="shortcut-label">View<br /> Reminders</span>								
											</a>										
											
											<a href="#application.root#?event=page.settings" class="shortcut">
												<i class="shortcut-icon icon-cogs"></i>
												<span class="shortcut-label">Company<br /> Settings</span>
											</a>
											
											<a href="#application.root#?event=page.depts" class="shortcut">
												<i class="shortcut-icon icon-building"></i>
												<span class="shortcut-label">Manage<br /> Departments</span>
											</a>

											<a href="#application.root#?event=page.users" class="shortcut">
												<i class="shortcut-icon icon-user"></i>
												<span class="shortcut-label">Users<br />&nbsp;</span>
											</a>
											
											<a href="#application.root#?reinit=true" onclick="javascript:return confirm('This will restart the application.  Do you wish to continue?');" class="shortcut">
												<i class="shortcut-icon icon-off"></i>
												<span class="shortcut-label">Restart<br /> Application</span>
											</a>
										</div> <!-- / .shortcuts -->
									
									
									</cfoutput>

									<div class="clear"></div>
								
								
								</div> <!-- //.widget-content -->	
									
							</div> <!-- //.widget -->
							
						</div> <!-- //.span12 -->
						
					</div> <!-- //.row -->			
				
				
					<div style="height:400px;"></div>			
				
				</div> <!-- //.container -->
			
			</div> <!-- //.main -->