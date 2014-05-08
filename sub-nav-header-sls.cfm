			
			
			
			
			
			
			<cfoutput>
			<div class="subnavbar">

				<div class="subnavbar-inner">
				
					<div class="container">
						
						<a class="btn-subnavbar collapsed" data-toggle="collapse" data-target=".subnav-collapse">
							<i class="icon-reorder"></i>
						</a>

						<div class="subnav-collapse collapse">
							<ul class="mainnav">
							
								
								<cfif not structkeyexists( session, "leadid" )>							
								
									<li <cfif structkeyexists( url, "event" ) and url.event is "page.index">class="active"</cfif>>
										<a href="#application.root#?event=page.index">
											<i class="icon-home"></i>
											<span>Home</span>
										</a>	    				
									</li>
									
									<li <cfif structkeyexists( url, "event" ) and ( url.event is "page.lead.new" )>class="active"</cfif>>					
										<a href="#application.root#?event=page.lead.new">
											<i class="icon-external-link"></i>
											<span>New Inquiry</span>
										</a>								
														
									</li>
									
									<li <cfif structkeyexists( url, "event" ) and ( url.event is "page.leads" )>class="active"</cfif>>					
										<a href="#application.root#?event=page.leads">
											<i class="icon-user"></i>
											<span>Inquiries</span>
										</a>								
														
									</li>
									
									<li <cfif structkeyexists( url, "event" ) and ( url.event is "page.clients" )>class="active"</cfif>>					
										<a href="#application.root#?event=page.clients">
											<i class="icon-group"></i>
											<span>Clients</span>
										</a>								
														
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
								
									
											
									<li <cfif structkeyexists( url, "event" ) and url.event contains "page.library.forms">class="active"</cfif>>
										<a href="#application.root#?event=page.library.forms">
											<i class="icon-book"></i>
											<span>Library</span>
										</a>	    				
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
									
									
									<!--- // if the lead has been converted, show the worksheet and option tree --->
									<cfif structkeyexists( session, "leadconv" )>				
										
											
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
											
											<cfif isuserinrole( "sls" ) or isuserinrole( "admin" ) or isuserinrole( "co-admin" )>	
												<li class="dropdown <cfif structkeyexists( url, "event" ) and ( url.event contains "page.tree" or url.event contains "page.calc" or url.event is "page.solution" )> active</cfif>">					
													<a href="javascript:;" class="dropdown-toggle" data-toggle="dropdown">
														<i class="icon-briefcase"></i>
														<span>Advisory</span>
														<b class="caret"></b>
													</a>	    
													
													<ul class="dropdown-menu">
														<li><a href="#application.root#?event=page.tree">Option Tree</a></li>
														<li><a href="#application.root#?event=page.calc">Loan Calculator</a></li>
														<li><a href="#application.root#?event=page.solution">Debt Solution</a></li>																							
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
									
									<!--- // close the lead and destroy the sessions --->
									<li>
										<a href="#application.root#?event=page.close">
											<i class="icon-remove-circle"></i>
											<span>Close</span>
										</a>	    				
									</li>
								
								</cfif>

								
								
								
								<!--- // show the client or lead name in the header 								
								
								<cfif structkeyexists(session, "clientid")>
									<li>
										<span style="color:##FFF;padding:25px;font-size:20px;">
											Client First Name
										</span>										
									</li>
								</cfif>
								
								<cfif structkeyexists(session, "leadid")>
									<li>		
										<span style="color:##FFF;padding:25px;font-size:20px;">
											Lead First Name
										</span>										
									</li>
								</cfif>										
								
								--->
							
							</ul>
						</div> <!-- /.subnav-collapse -->

					</div> <!-- /container -->
				
				</div> <!-- /subnavbar-inner -->

			</div> <!-- /subnavbar -->
			</cfoutput>