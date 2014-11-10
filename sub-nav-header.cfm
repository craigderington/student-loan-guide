			
			
			
			
			
			
			<cfoutput>
			<div class="subnavbar">

				<div class="subnavbar-inner">
				
					<div class="container">
						
						<a class="btn-subnavbar collapsed" data-toggle="collapse" data-target=".subnav-collapse">
							<i class="icon-reorder"></i>
						</a>
						
						
						<cfif isuserloggedin()>
							
							<div class="subnav-collapse collapse">
								<ul class="mainnav">
								
									
									<cfif not structkeyexists( session, "clientid" ) and not structkeyexists( session, "leadid" )>							
									
										<li <cfif structkeyexists( url, "event" ) and url.event is "page.index">class="active"</cfif>>
											<a href="#application.root#?event=page.index">
												<i class="icon-home"></i>
												<span>Home</span>
											</a>	    				
										</li>
										
										<li class="dropdown <cfif structkeyexists( url, "event" ) and ( url.event is "page.clients" or url.event is "page.leads" )>active</cfif>">					
											<a href="javascript:;" class="dropdown-toggle" data-toggle="dropdown">
												<i class="icon-group"></i>
												<span>Clients</span>
												<b class="caret"></b>
											</a>	    
										
											<ul class="dropdown-menu">											
												<li><a href="#application.root#?event=page.lead.new">New Inquiry</a></li>
												<li><a href="#application.root#?event=page.leads">Inquiries</a></li>											
												<cfif isuserinrole( "admin" ) or isuserinrole( "co-admin" ) or isuserinrole( "sls" )>
												<li><a href="#application.root#?event=page.clients">Client List</a></li>
												</cfif>									
											</ul> 				
										</li>

										<li <cfif structkeyexists( url, "event" ) and url.event contains "page.reports">class="active"</cfif>>
											<a href="#application.root#?event=page.reports">
												<i class="icon-copy"></i>
												<span>Reports</span>
											</a>	    				
										</li>
										
										<li <cfif structkeyexists( url, "event" ) and trim( url.event ) contains "page.message.center">class="active"</cfif>>
											<a href="#application.root#?event=page.message.center">
												<i class="icon-comments-alt"></i>
												<span>Messages</span>
											</a>	    				
										</li>
									
										
											
										<li class="dropdown <cfif structkeyexists( url, "event" ) and ( trim( url.event ) contains "page.library" or trim( url.event ) is "page.api.docs" )>active</cfif>">					
											<a href="javascript:;" class="dropdown-toggle" data-toggle="dropdown">
												<i class="icon-book"></i>
													<span>Library</span>
													<b class="caret"></b>
											</a>	
												
											<ul class="dropdown-menu">
												<li><a href="#application.root#?event=page.library.forms">Forms Library</a></li>																						
												<li><a href="#application.root#?event=page.library.forms.upload">Upload Forms</a></li>
												<cfif ( isuserinrole( "admin" ) or isuserinrole( "co-admin" ))>
													<li><a href="#application.root#?event=page.api.docs">API Documentation</a></li>
												</cfif>
											</ul>    				
										</li>
											
										
									</cfif>
									
									<cfif structkeyexists( session, "leadid" )>							
										
										
										<li <cfif structkeyexists( url, "event" ) and ( url.event is "page.tasks" or url.event contains "tasks" )>class="active"</cfif>>
											<a href="#application.root#?event=page.tasks">
												<i class="icon-tasks"></i>
												<span>Tasks</span>
											</a>	    				
										</li>									
										
										<li <cfif structkeyexists( url, "event" ) and ( url.event is "page.email" or url.event is "page.txtmsg" )>class="active"</cfif>>
											<a href="#application.root#?event=page.email">
												<i class="icon-envelope"></i>
												<span>Message</span>
											</a>	    				
										</li>
										
										<li <cfif structkeyexists( url, "event" ) and ( url.event is "page.summary" or url.event is "page.enroll" or url.event is "page.enroll.status" )>class="active"</cfif>>
											<a href="#application.root#?event=page.summary">
												<i class="icon-user"></i>
												<span>Enrollment</span>
											</a>	    				
										</li>
										
										<li <cfif structkeyexists( url, "event" ) and url.event is "page.fees">class="active"</cfif>>
											<a href="#application.root#?event=page.fees">
												<i class="icon-money"></i>
												<span>Fees</span>
											</a>	    				
										</li>
										
										<li <cfif structkeyexists( url, "event" ) and url.event is "page.docs">class="active"</cfif>>
											<a href="#application.root#?event=page.docs">
												<i class="icon-folder-open"></i>
												<span>Documents</span>
											</a>	    				
										</li>								
										
										<li <cfif structkeyexists( url, "event" ) and url.event is "page.notes">class="active"</cfif>>
											<a href="#application.root#?event=page.notes">
												<i class="icon-comments"></i>
												<span>Notes</span>
											</a>	    				
										</li>								
										
										<!--- // if the lead has been converted, show the debt worksheet and option tree --->
										<cfif structkeyexists( session, "leadconv" )>									
											
											<cfif not isuserinrole( "counselor" ) and not isuserinrole( "agent" ) and not isuserinrole( "client" )>
											
												<li class="dropdown <cfif structkeyexists( url, "event" ) and ( url.event contains "page.worksheet" or url.event contains "page.budget" or url.event is "page.survey" or url.event is "page.repayments" )> active</cfif>">					
													<a href="javascript:;" class="dropdown-toggle" data-toggle="dropdown">
														<i class="icon-tasks"></i>
														<span>Intake</span>
														<b class="caret"></b>
													</a>	    
												
													<ul class="dropdown-menu">
														<li><a href="#application.root#?event=page.worksheet">Debt Worksheet</a></li>
														<li><a href="#application.root#?event=page.budget">Monthly Budget</a></li>
														<li><a href="#application.root#?event=page.survey">Questionnaire</a></li>										
														<li><a href="#application.root#?event=page.repayments">Adjusted Gross Income</a></li>
														<li><a href="#application.root#?event=page.intake.review">Intake Advisor Review</a></li>
													</ul> 				
												</li>	
												
												
												
												<!--- // only show links to solution presentation and option tree for proper user roles --->
												<cfif isuserinrole( "admin") or isuserinrole( "co-admin" ) or isuserinrole( "sls" )>
													
													<li class="dropdown <cfif structkeyexists( url, "event" ) and ( url.event contains "page.tree" or url.event contains "page.calc" or url.event is "page.solution" )> active</cfif>">					
														<a href="javascript:;" class="dropdown-toggle" data-toggle="dropdown">
															<i class="icon-briefcase"></i>
																<span>Advisory</span>
																<b class="caret"></b>
														</a>	    
													
														<ul class="dropdown-menu">
															<li><a href="#application.root#?event=page.tree">Option Tree</a></li>
															<li><a href="#application.root#?event=page.calc">Loan Calculator</a></li>
															<li><a href="#application.root#?event=page.solution">Debt Solutions</a></li>																							
														</ul> 				
													</li>

													<cfif structkeyexists( session, "leadimp" )>
													
														<li class="dropdown <cfif structkeyexists( url, "event" ) and ( url.event contains "page.solution.implement" or url.event contains "page.implmenent.enroll" )> active</cfif>">					
															<a href="javascript:;" class="dropdown-toggle" data-toggle="dropdown">
																<i class="icon-cogs"></i>
																	<span>Implement</span>
																	<b class="caret"></b>
															</a>	    
													
															<ul class="dropdown-menu">
																<li><a href="#application.root#?event=page.implement.enroll">Implementation Enrollment Status</a></li>
																<li><a href="#application.root#?event=page.implement.personal">Implementation Personal Data</a></li>
																<li><a href="#application.root#?event=page.solution.implement">Implementation Plan</a></li>																																						
															</ul> 				
														</li>	
													
													</cfif>
													
												</cfif>
											</cfif>
										</cfif>
										
										<!--- // close the lead and destroy the sessions --->
										<li>
											<a href="#application.root#?event=page.close">
												<i class="icon-remove-circle"></i>
												<span>Close</span>
											</a>	    				
										</li>
									
									</cfif>				
									
								
								</ul>
							</div> <!-- /.subnav-collapse -->
						
						</cfif><!-- / .check on isuserloggedin() --->

					</div> <!-- /container -->
				
				</div> <!-- /subnavbar-inner -->

			</div> <!-- /subnavbar -->
			</cfoutput>