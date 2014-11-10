


			<!--- // the included sidebar navigation --->
			<cfoutput>	
				
				<cfparam name="vancowebservices" default="0">					
				
					<cfif not isuserinrole( "bclient" )>
					
						
						<cfinvoke component="apis.com.system.companysettings" method="getcompanysettings" returnvariable="companysettings">
							<cfinvokeargument name="companyid" value="#session.companyid#">
						</cfinvoke>
						
						<cfset vancowebservices = companysettings.vancows />
						
							<ul class="nav nav-tabs nav-stacked">
								
								<li <cfif trim( url.event ) is "page.tasks">class="active"</cfif>>
									<a href="#application.root#?event=page.tasks">
										<i class="icon-tasks"></i>
											Program Tasks
										<i class="icon-chevron-right"></i>
									</a>              		
								</li>
								
								<li <cfif trim( url.event ) is "page.email" or trim( url.event ) is "page.txtmsg">class="active"</cfif>>
									<a href="#application.root#?event=page.tasks">
										<i class="icon-envelope"></i>
											Message
										<i class="icon-chevron-right"></i>
									</a>              		
								</li>
								
								<li <cfif trim( url.event ) is "page.summary">class="active"</cfif>>
									<a href="#application.root#?event=page.summary">
										<i class="icon-user"></i>
											Contact Information
										<i class="icon-chevron-right"></i>
									</a>              			              	
								</li>						
										
								<li <cfif trim( url.event ) is "page.enroll">class="active"</cfif>>
									<a href="#application.root#?event=page.enroll">
										<i class="icon-picture"></i>
											Inquiry Summary
										<i class="icon-chevron-right"></i>
									</a>              		
								</li>
								
								<li <cfif trim( url.event ) contains "page.fee">class="active"</cfif>>
									<a href="#application.root#?event=page.fees">
										<i class="icon-money"></i>
											Fee Schedule
										<i class="icon-chevron-right"></i>
									</a>              		
								</li>
								
								<li <cfif trim( url.event ) is "page.lead.login">class="active"</cfif>>
									<a href="#application.root#?event=page.lead.login">
										<i class="icon-lock"></i>
											Client Login
										<i class="icon-chevron-right"></i>
									</a>              			              	
								</li>
								
								<!--- // CLD 10-29-2014 // modify payment information nav
										 for Vanco Services intergration --->
								<cfif companysettings.vancows neq 1>
								
									<li <cfif trim( url.event ) is "page.banking">class="active"</cfif>>
										<a href="#application.root#?event=page.banking">
											<i class="icon-building"></i>
												Payment Information
											<i class="icon-chevron-right"></i>
										</a>              			              	
									</li>
								
								<cfelse>
								
									<li <cfif trim( url.event ) is "page.vanco">class="active"</cfif>>
										<a href="#application.root#?event=page.vanco">
											<i class="icon-building"></i>
												Vanco Payment Services
											<i class="icon-chevron-right"></i>
										</a>              			              	
									</li>

								
								</cfif>
														
								<li <cfif trim( url.event ) is "page.enroll.status">class="active"</cfif>>
									<a href="#application.root#?event=page.enroll.status">
										<i class="icon-bar-chart"></i>
											Enrollment Status
										<i class="icon-chevron-right"></i>
									</a>              		
								</li>
														
								<li <cfif trim( url.event ) is "page.docs">class="active"</cfif>>
									<a href="#application.root#?event=page.docs">
										<i class="icon-book"></i>
											Documents
										<i class="icon-chevron-right pull-right"></i>
									</a>              		
								</li>
														
								<li <cfif trim( url.event ) is "page.notes">class="active"</cfif>>
									<a href="#application.root#?event=page.notes">
										<i class="icon-comments"></i>
											Notes
										<i class="icon-chevron-right"></i>
									</a>              		
								</li>					
														
								<li <cfif trim( url.event ) is "page.activity">class="active"</cfif>>
									<a href="#application.root#?event=page.activity">
										<i class="icon-reorder"></i>
											Activity Log
										<i class="icon-chevron-right"></i>
									</a>              		
								</li>
														
														
								<cfif structkeyexists( session, "leadconv" )>			
									<cfif not isuserinrole( "counselor" ) and not isuserinrole( "agent" )>
										
										<li <cfif trim( url.event ) contains "page.worksheet">class="active"</cfif>>
											<a href="#application.root#?event=page.worksheet">
												<i class="icon-refresh"></i>
												Debt Worksheet
												<i class="icon-chevron-right"></i>
											</a>              		
										</li>
										
										<li <cfif trim( trim( url.event ) ) contains "page.budget">class="active"</cfif>>
											<a href="#application.root#?event=page.budget">
												<i class="icon-list-alt"></i>
												Budget
												<i class="icon-chevron-right"></i>
											</a>              		
										</li>
																
										<li <cfif trim( url.event ) is "page.survey">class="active"</cfif>>
											<a href="#application.root#?event=page.survey">
												<i class="icon-question-sign"></i>
												Questionnaire
												<i class="icon-chevron-right"></i>
											</a>              		
										</li>
														
										<li <cfif trim( url.event ) is "page.repayments">class="active"</cfif>>
											<a href="#application.root#?event=page.repayments">
												<i class="icon-retweet"></i>
												AGI/Family Size
												<i class="icon-chevron-right"></i>
											</a>              		
										</li>
										
										<li <cfif trim( url.event ) contains "page.intake">class="active"</cfif>>
											<a href="#application.root#?event=page.intake.review">
												<i class="icon-search"></i>
												Intake Review
												<i class="icon-chevron-right"></i>
											</a>              		
										</li>
																
										<li <cfif trim( url.event ) is "page.tree">class="active"</cfif>>
											<a href="#application.root#?event=page.tree">
												<i class="icon-sitemap"></i>
												Option Tree
												<i class="icon-chevron-right"></i>
											</a>              		
										</li>
																
										<li <cfif trim( url.event ) is "page.solution">class="active"</cfif>>
											<a href="#application.root#?event=page.solution">
												<i class="icon-check"></i>
												Student Loan Solution
												<i class="icon-chevron-right"></i>
											</a>              		
										</li>
										
										<li <cfif trim( url.event ) is "page.advisor.review">class="active"</cfif>>
											<a href="#application.root#?event=page.advisor.review">
												<i class="icon-flag"></i>
												Advisor Review
												<i class="icon-chevron-right"></i>
											</a>              		
										</li>
										
									</cfif>
								</cfif>											
														
							</ul>
						
					<cfelse>


						<ul class="nav nav-tabs nav-stacked">						
							
							
							<li <cfif trim( url.event ) is "page.summary" or trim( url.event ) is "page.lead.login">class="active"</cfif>>
								<a href="#application.root#?event=page.summary">
									<i class="icon-user"></i>
										Contact Information
									<i class="icon-chevron-right"></i>
								</a>              			              	
							</li>
							
							<li <cfif trim( url.event ) contains "page.budget">class="active"</cfif>>
								<a href="#application.root#?event=page.budget">
									<i class="icon-list-alt"></i>
										Budget
									<i class="icon-chevron-right"></i>
								</a>              		
							</li>
							
							<li <cfif trim( url.event ) is "page.repayments">class="active"</cfif>>
								<a href="#application.root#?event=page.repayments">
									<i class="icon-retweet"></i>
										AGI/Family Size
									<i class="icon-chevron-right"></i>
								</a>              		
							</li>
							
							<li <cfif trim( url.event ) is "page.survey">class="active"</cfif>>
								<a href="#application.root#?event=page.survey">
									<i class="icon-question-sign"></i>
										Questionnaire
									<i class="icon-chevron-right"></i>
								</a>              		
							</li>

							<li <cfif trim( url.event ) contains "page.worksheet">class="active"</cfif>>
								<a href="#application.root#?event=page.worksheet">
									<i class="icon-refresh"></i>
										Debt Worksheet
									<i class="icon-chevron-right"></i>
								</a>              		
							</li>

							<li <cfif trim( url.event ) is "page.docs">class="active"</cfif>>
								<a href="#application.root#?event=page.docs">
									<i class="icon-book"></i>
										Documents
									<i class="icon-chevron-right pull-right"></i>
								</a>              		
							</li>												
													
							<cfif companysettings.useportalactlog eq 1>
								<li <cfif trim( url.event ) is "page.activity">class="active"</cfif>>
									<a href="#application.root#?event=page.activity">
										<i class="icon-reorder"></i>
											Activity Log
										<i class="icon-chevron-right"></i>
									</a>              		
								</li>
							</cfif>
						
						</ul>

					
				</cfif>

			</cfoutput>
				