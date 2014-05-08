


			<!--- // the included sidebar navigation --->
			<cfoutput>	
				
				
					
						<ul class="nav nav-tabs nav-stacked">
							
							<li <cfif url.event is "page.tasks">class="active"</cfif>>
								<a href="#application.root#?event=page.tasks">
									<i class="icon-tasks"></i>
										Program Tasks
									<i class="icon-chevron-right"></i>
								</a>              		
							</li>
							
							<li <cfif url.event is "page.email" or url.event is "page.txtmsg">class="active"</cfif>>
								<a href="#application.root#?event=page.tasks">
									<i class="icon-envelope"></i>
										Message
									<i class="icon-chevron-right"></i>
								</a>              		
							</li>
							
							<li <cfif url.event is "page.summary" or url.event is "page.lead.login">class="active"</cfif>>
								<a href="#application.root#?event=page.summary">
									<i class="icon-user"></i>
										Contact Information
									<i class="icon-chevron-right"></i>
								</a>              			              	
							</li>						
							
							<li <cfif url.event is "page.fees">class="active"</cfif>>
								<a href="#application.root#?event=page.fees">
									<i class="icon-money"></i>
										Fee Schedule
									<i class="icon-chevron-right"></i>
								</a>              		
							</li>	
													
							<li <cfif url.event is "page.docs">class="active"</cfif>>
								<a href="#application.root#?event=page.docs">
									<i class="icon-book"></i>
										Documents
									<i class="icon-chevron-right pull-right"></i>
								</a>              		
							</li>
													
							<li <cfif url.event is "page.notes">class="active"</cfif>>
								<a href="#application.root#?event=page.notes">
									<i class="icon-comments"></i>
										Notes
									<i class="icon-chevron-right"></i>
								</a>              		
							</li>					
													
							<li <cfif url.event is "page.activity">class="active"</cfif>>
								<a href="#application.root#?event=page.activity">
									<i class="icon-reorder"></i>
										Activity Log
									<i class="icon-chevron-right"></i>
								</a>              		
							</li>
													
													
							<cfif structkeyexists( session, "leadconv" )>			
								<cfif not isuserinrole( "counselor" ) and not isuserinrole( "agent" )>								
									
									<li <cfif url.event is "page.budget">class="active"</cfif>>
										<a href="#application.root#?event=page.budget">
											<i class="icon-list-alt"></i>
											Budget
											<i class="icon-chevron-right"></i>
										</a>              		
									</li>							
															
									<li <cfif url.event is "page.solution">class="active"</cfif>>
										<a href="#application.root#?event=page.solution">
											<i class="icon-check"></i>
											Student Loan Solution
											<i class="icon-chevron-right"></i>
										</a>              		
									</li>
								</cfif>
								
								<cfif structkeyexists( session, "leadimp" )>
								
									<li <cfif url.event is "page.implement.enroll">class="active"</cfif>>
										<a href="#application.root#?event=page.implement.enroll">
											<i class="icon-cogs"></i>
											Implementation Status
											<i class="icon-chevron-right"></i>
										</a>              		
									</li>
									
									<li <cfif url.event contains "page.implement.personal">class="active"</cfif>>
										<a href="#application.root#?event=page.implement.personal">
											<i class="icon-bar-chart"></i>
											Implementation Personal Data
											<i class="icon-chevron-right"></i>
										</a>              		
									</li>
									
									<li <cfif url.event is "page.solution.implement">class="active"</cfif>>
										<a href="#application.root#?event=page.solution.implement">
											<i class="icon-fast-forward"></i>
											Implementation Plan
											<i class="icon-chevron-right"></i>
										</a>              		
									</li>
								
								</cfif>
								
								
								
							</cfif>											
													
						</ul>
			</cfoutput>
				