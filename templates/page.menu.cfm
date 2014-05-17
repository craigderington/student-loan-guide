


		<!--- // security checks // right now, only admin users are allowed to access this page --->
		<cfif not isuserinrole( "admin" )>
			<cflocation url="#application.root#?event=page.index&error=1" addtoken="yes">
		</cfif>	
		
		<!--- // Menu System Data --->
		
		<div class="main">	
				
			<div class="container">
					
				<div class="row">
			
					<div class="span12">
							
						<div class="widget stacked">
								
							<div class="widget-header">		
								<i class="icon-book"></i>							
								<h3>System Administration | Manage System Menu Data</h3>						
							</div> <!-- //.widget-header -->
								
							<div class="widget-content">						
									
								<cfoutput>
										<div class="shortcuts">
												
											<!--- // 1st row of menu items --->	
											<div class="row">
												
													<a href="#application.root#?event=page.menu.servicers" class="shortcut">
														<i class="shortcut-icon icon-group"></i>
														<span class="shortcut-label">Loan Servicers</span>
													</a>
														
													<a href="#application.root#?event=page.menu.email" class="shortcut">
														<i class="shortcut-icon icon-envelope-alt"></i>
														<span class="shortcut-label">Message Library</span>								
													</a>
														
													<a href="#application.root#?event=page.reports" class="shortcut">
														<i class="shortcut-icon icon-desktop"></i>
														<span class="shortcut-label">Reports</span>	
													</a>
														
													<a href="#application.root#?event=page.reminders" class="shortcut">
														<i class="shortcut-icon icon-calendar"></i>
														<span class="shortcut-label">Reminders</span>								
													</a>										
													
													
											</div>
												
											<!--- / 2nd row of menu items --->
											<div class="row">										
													
													<a href="#application.root#?event=page.menu.tasks" class="shortcut">
														<i class="shortcut-icon icon-tasks"></i>
														<span class="shortcut-label">Master Task List</span>	
													</a>
														
													<a href="#application.root#?event=page.menu.survey" class="shortcut">
														<i class="shortcut-icon icon-check"></i>
														<span class="shortcut-label">Questionnaire</span>	
													</a>
														
													<a href="#application.root#?event=page.settings" class="shortcut">
														<i class="shortcut-icon icon-cogs"></i>
														<span class="shortcut-label">Settings</span>
													</a>

													<a href="#application.root#?event=page.users" class="shortcut">
														<i class="shortcut-icon icon-user"></i>
														<span class="shortcut-label">Users</span>
													</a>
												
											</div>
											
											<!--- // 3rd row of menu items --->
											<div class="row">										
													
													<a href="#application.root#?event=page.menu.jobs" class="shortcut">
														<i class="shortcut-icon icon-briefcase"></i>
														<span class="shortcut-label">Job Conditions</span>	
													</a>
														
													<a href="#application.root#?event=page.menu.points" class="shortcut">
														<i class="shortcut-icon icon-umbrella"></i>
														<span class="shortcut-label">Clarifying Points</span>	
													</a>
														
													<a href="#application.root#?event=page.menu.plans" class="shortcut">
														<i class="shortcut-icon icon-suitcase"></i>
														<span class="shortcut-label">Action Plans</span>
													</a>

													<a href="#application.root#?event=page.menu.steps" class="shortcut">
														<i class="shortcut-icon icon-cogs"></i>
														<span class="shortcut-label">Implement Steps</span>
													</a>
												
											</div>
											
											
											<!--- // 4th row of menu items --->
											<div class="row">										
													
													<a href="#application.root#?event=page.menu.portal.instructions" class="shortcut">
														<i class="shortcut-icon icon-tags"></i>
														<span class="shortcut-label">Portal Instructions</span>	
													</a>					
													
													<a href="#application.root#?event=page.menu.portal.tasks" class="shortcut">
														<i class="shortcut-icon icon-reorder"></i>
														<span class="shortcut-label">Portal <br/> Tasks</span>	
													</a>											
														
													<a href="#application.root#?event=page.menu.document.categories" class="shortcut">
														<i class="shortcut-icon icon-paste"></i>
														<span class="shortcut-label">Document Categories</span>
													</a>											
													
													<a href="javascript:;" class="shortcut">
														<i class="shortcut-icon icon-folder-open-alt"></i>
														<span class="shortcut-label">Future<br /> Use</span>
													</a>
													
											</div>
											
											
											
											<div class="row" style="height:100px;">										
													
												<a href="#application.root#?event=page.menu.leadsources" class="shortcut">
													<i class="shortcut-icon icon-map-marker"></i>
													<span class="shortcut-label">Manage <br /> Lead Sources </span>	
												</a>	
												
											</div>
											
											
												
										</div> <!-- / .shortcuts -->
								</cfoutput>

								<div class="clear"></div>
								
								
							</div> <!-- //.widget-content -->	
									
						</div> <!-- //.widget-stacked -->
							
					</div> <!-- //.span12 -->
						
				</div> <!-- //.row -->			
				
				
				<div style="height:200px;"></div>			
				
			</div> <!-- //.container -->
			
		</div> <!-- //.main -->