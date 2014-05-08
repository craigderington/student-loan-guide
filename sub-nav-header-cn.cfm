			
			
			
			
			
			
			<cfoutput>
			<div class="subnavbar">

				<div class="subnavbar-inner">
				
					<div class="container">
						
						<a class="btn-subnavbar collapsed" data-toggle="collapse" data-target=".subnav-collapse">
							<i class="icon-reorder"></i>
						</a>

						<div class="subnav-collapse collapse">
							<ul class="mainnav">
							
								
								<cfif not structkeyexists( session, "clientid" ) and not structkeyexists( session, "leadid" )>							
								
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
								
									<li <cfif structkeyexists( url, "event" ) and url.event is "page.library.forms">class="active"</cfif>>
										<a href="#application.root#?event=page.library.forms">
											<i class="icon-book"></i>
											<span>Library</span>
										</a>	    				
									</li>
									
								</cfif>
								
								<cfif structkeyexists(session, "leadid")>
								
									<!--- // remove the link to the dashboard 
									<li <cfif structkeyexists(url, "event") and url.event is "page.index">class="active"</cfif>>
										<a href="#application.root#?event=page.index">
											<i class="icon-dashboard"></i>
											<span>Dashboard</span>
										</a>	    				
									</li>
									--->
									
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
									
									
									<li <cfif ( structkeyexists( url, "event" ) and url.event is "page.summary" ) or ( url.event is "page.enroll" or url.event is "page.enroll.status" )>class="active"</cfif>>
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
									
									<!--- // remove from header --->
									<li <cfif structkeyexists( url, "event" ) and url.event is "page.activity">class="active"</cfif>>
										<a href="#application.root#?event=page.activity">
											<i class="icon-briefcase"></i>
											<span>Activity</span>
										</a>	    				
									</li>						
									
									
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