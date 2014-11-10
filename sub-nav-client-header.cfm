			
			
			
			
			<cfif not structkeyexists( session, "leadesign" )>
				<cfset session.leadesign = 0 />
			</cfif>
			
			<cfif structkeyexists( url, "event" ) and url.event is not "page.portal.welcome">
			
				
				<cfinvoke component="apis.com.system.companysettings" method="getcompanysettings" returnvariable="companysettings">
					<cfinvokeargument name="companyid" value="#session.companyid#">
				</cfinvoke>
				
				<cfoutput>
				
				<div class="subnavbar">

					<div class="subnavbar-inner">
					
						<div class="container">
							
							<a class="btn-subnavbar collapsed" data-toggle="collapse" data-target=".subnav-collapse">
								<i class="icon-reorder"></i>
							</a>

							<div class="subnav-collapse collapse">
								<ul class="mainnav">

									<li <cfif structkeyexists( url, "event" ) and trim( url.event ) is "page.portal.home" >class="active"</cfif>>
										<a href="#application.root#?event=page.portal.home">
											<i class="icon-home"></i>
											<span>Portal Home</span>
										</a>	    				
									</li>							
									
									<!--- // 9-9-2014 // modify header to add conditional operator for ESIGN --->
									<cfif companysettings.useportal eq 1>
									
										<li <cfif structkeyexists( url, "event" ) and trim( url.event ) is "page.enroll.esign">class="active"</cfif>>
											<a href="#application.root#?event=page.enroll.esign">
												<i class="icon-pencil"></i>
												<span>E-Sign</span>
											</a>	    				
										</li>
									
									</cfif>
									
									<cfif session.leadesign eq 1>
										<li <cfif structkeyexists( url, "event" ) and trim( url.event ) is "page.portal.instructions" >class="active"</cfif>>
											<a href="#application.root#?event=page.portal.instructions">
												<i class="icon-cog"></i>
												<span>Instructions</span>
											</a>	    				
										</li>
										
										<li class="dropdown <cfif structkeyexists( url, "event" ) and ( url.event is "page.summary" or url.event contains "page.budget" or url.event is "page.survey" or url.event is "page.worksheet" or url.event is "page.repayments" )> active</cfif>">					
											<a href="javascript:;" class="dropdown-toggle" data-toggle="dropdown">
												<i class="icon-tasks"></i>
												<span>To Do List</span>
												<b class="caret"></b>
											</a>	    
										
											<ul class="dropdown-menu">
												<li><a href="#application.root#?event=page.summary">Contact Information</a></li>
												<li><a href="#application.root#?event=page.budget">Monthly Budget</a></li>
												<li><a href="#application.root#?event=page.repayments">AGI/Family Size</a></li>
												<li><a href="#application.root#?event=page.survey">Questionnaire</a></li>
												<li><a href="#application.root#?event=page.worksheet">Debt Worksheet</a></li>										
											</ul> 				
										</li>															

										<li <cfif structkeyexists( url, "event" ) and trim( url.event ) is "page.docs">class="active"</cfif>>
											<a href="#application.root#?event=page.docs">
												<i class="icon-folder-open"></i>
												<span>Your Documents</span>
											</a>	    				
										</li>

										<li <cfif structkeyexists( url, "event" ) and trim( url.event ) is "page.client.forms">class="active"</cfif>>
											<a href="#application.root#?event=page.client.forms">
												<i class="icon-file-alt"></i>
												<span>Important Forms</span>
											</a>	    				
										</li>
										<!--- // 11-10-2014 // modify based on company settings --->
										<cfif companysettings.useportalactlog eq 1>
											<li <cfif structkeyexists( url, "event" ) and trim( url.event ) is "page.activity">class="active"</cfif>>
												<a href="#application.root#?event=page.activity">
													<i class="icon-bar-chart"></i>
													<span>Activity</span>
												</a>	    				
											</li>
										</cfif>
										
										<li <cfif structkeyexists( url, "event" ) and trim( url.event ) contains "page.portal.faqs">class="active"</cfif>>
											<a href="#application.root#?event=page.portal.faqs">
												<i class="icon-pushpin"></i>
												<span>FAQs</span>
											</a>	    				
										</li>
										<!--- // 11-10-2014 // modify based on company settings --->
										<cfif companysettings.useportalconvo eq 1>
											<li <cfif structkeyexists( url, "event" ) and trim( url.event ) contains "page.conversation">class="active"</cfif>>
												<a href="#application.root#?event=page.conversation">
													<i class="icon-comments-alt"></i>
													<span>Ask Us</span>
												</a>	    				
											</li>
										<cfelse>
											<li>
												<a href="mailto:#companysettings.email#" target="_blank">
													<i class="icon-comments-alt"></i>
													<span>Ask Us</span>
												</a>	    				
											</li>
										</cfif>
										
									</cfif>
									<!---
									<cfif session.leadconv eq 1>
										
										<li <cfif structkeyexists( url, "event" ) and url.event is "page.solution">class="active"</cfif>>
											<a href="#application.root#?event=page.solution">
												<i class="icon-retweet"></i>
												<span>Solution</span>
											</a>	    				
										</li>					
										
										<li <cfif structkeyexists( url, "event" ) and url.event is "page.forms">class="active"</cfif>>					
											<a href="#application.root#?event=page.forms">
												<i class="icon-book"></i>
												<span>Library</span>													
											</a>	
										</li>

									</cfif>			
									--->
								</ul>
							</div> <!-- / .subnav-collapse -->

						</div> <!-- / .container -->
					
					</div> <!-- / .subnavbar-inner -->

				</div> <!-- / .subnavbar -->
				</cfoutput>
			</cfif><!--- / .not welcome page --->