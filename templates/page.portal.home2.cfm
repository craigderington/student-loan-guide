


			<!--- // show portal home or welcome message --->
			<cfif session.leadwelcomehome eq 0>
				<cfif session.welcomehomesess eq 0>	
					<cflocation url="#application.root#?event=page.portal.welcome" addtoken="no" />
				</cfif>
			</cfif>	
			
			
			
			
			<!--- // get our data access objects --->

			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>

			<cfinvoke component="apis.com.portal.portalgateway" method="getportaldashboard" returnvariable="cdashboard">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>

			<cfinvoke component="apis.com.portal.portalgateway" method="getclienttasks" returnvariable="tasklist">
				<cfinvokeargument name="leadid" value="#session.leadid#">			
			</cfinvoke>

			<cfinvoke component="apis.com.leads.leadgateway" method="getleadactivity" returnvariable="leadact">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>		
			
			<cfinvoke component="apis.com.solutions.solutiongateway" method="getcompletedsolutions" returnvariable="completedsolutions">
				<cfinvokeargument name="leadid" value="#session.leadid#">
				<cfinvokeargument name="solcomp" value="1">
			</cfinvoke>
			
			<cfinvoke component="apis.com.convo.convogateway" method="getconvo" returnvariable="convolist">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.portal.portalgateway" method="getadvisorteam" returnvariable="advisorteam">
				<cfinvokeargument name="leadid" value="#session.leadid#">			
			</cfinvoke>

			
	









			<!--- client portal home page --->
			
			
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">					
							
							
							
							<!--- // old homepage
							<div class="widget stacked">								
								
								<cfoutput>
									<div class="widget-header">		
										<i class="icon-money"></i>							
										<h3>Student Loan Advisory Services provided by #leaddetail.companyname#</h3>						
									</div> <!-- //.widget-header -->
								</cfoutput>				
								
								<div class="widget-content">		
										
										<div class="span4">
										
											<!--- // default welcome message --->
											<cfif leaddetail.leadesign eq 0 and leaddetail.leadconv eq 0>
												<cfoutput>
													<div class="alert alert-block alert-notice">
														<button type="button" class="close" data-dismiss="alert">&times;</button>												
															<h4><i class="icon-home"></i> Welcome to Your Client Portal.  </h4>
															<p>Please take the time to <strong><a href="#application.root#?event=page.enroll.esign">E-SIGN</a></strong> your <strong>Student Loan Advisory Agreement</strong> before you get started.
															<p><a href="#application.root#?event=page.enroll.esign" class="btn btn-secondary btn-medium"><i class="icon-pencil"></i> I'm Ready to E-Sign</a></p>
															
													</div>
												</cfoutput>
											<cfelse>
												<cfoutput>
													<div class="alert alert-block alert-success">
														<button type="button" class="close" data-dismiss="alert">&times;</button>											
															<h4><i class="icon-home"></i> OK, LET'S GET STARTED!</H4>
															<p>Now that you have provided your electronic signature and have officially enrolled in Student Loan Advisory Program, please <strong><a href="#application.root#?event=page.portal.instructions">View Instructions</a></strong> to help you navigate your client portal.</p>
															
													</div>
												</cfoutput>
											</cfif>				
											
										</div>
										
											<cfoutput>
												
													<div class="span7">
														<div class="well">	
																														
															<h4 style="font-size:32px;"><i class="icon-user"></i>  Welcome #leaddetail.leadfirst# #leaddetail.leadlast#!</h4>																	
																<p><i class="icon-home"></i> #leaddetail.leadadd1#   <cfif leaddetail.leadadd2 is not "">#leaddetail.leadadd2#</cfif> <span class="pull-right"><i class="icon-calendar"></i> Enroll Date | #dateformat( leaddetail.leaddate, "mm/dd/yyyy" )#</span></p>
																<p style="margin-top:-10px;">#leaddetail.leadcity#, #ucase( leaddetail.leadstate )#  #leaddetail.leadzip#		      <span class="pull-right"><i class="icon-cog"></i> <a href="#application.root#?event=page.profile">Edit My Profile </a> | <a href="#application.root#?event=page.logout">Logout</a></span></p>								
																<p style="margin-top:-10px;"><i class="icon-phone"></i>  #leaddetail.leadphonetype# : #leaddetail.leadphonenumber#	  <span class="pull-right"><i class="icon-comments"></i> <cfif convolist.totalnewmsgs gt 0><span class="label label-success">#convolist.totalnewmsgs# New Message<cfif convolist.totalnewmsgs gt 1>s</cfif></span><cfelse><span class="label label-important">0 New Messages</span></cfif>  <a href="#application.root#?event=page.conversation&fuseaction=new"> Ask Us</a></span></p>
																<p style="margin-top:-10px;"><i class="icon-envelope"></i>  #leaddetail.leademail#									  <span class="pull-right"><i class="icon-folder-open"></i> <a href="#application.root#?event=page.docs&fuseaction=upload"> Upload New Document</a></span></p>
																
														</div>						
													</div>
												
												
											</cfoutput>
											
											
										<div class="span12">
										
											<div class="span4" style="margin-top:-40px;">
												
												<cfif leaddetail.leadesign eq 1 and leaddetail.leadconv eq 1>
													<h5><i class="icon-check"></i> Getting Started</h5>									
													
													<cfoutput>
														<ul style="list-style:none;">
															<cfloop query="tasklist">
																<li><cfif #trim( taskstatus )# is "completed"><i class="icon-check"></i><cfelse><i class="icon-check-empty"></i></cfif>  <strong>#mtaskname#</strong></li>													
															</cfloop>
														</ul>
													</cfoutput>
												</cfif>
												
											
											</div>
											
											
											<div class="span7" style="margin-top:30px;">
												<cfif advisorteam.recordcount eq 1>
													
												<cfelse>
													Team Not Yet Assigned
												</cfif>
											</div>
										
										
										</div>
										
										
										
										<div class="span12">
										
											<div class="span4" style="margin-top:30px;">												
												
												<h5><i class="icon-edit"></i> Section V</h5>											
												<br />
												<br />
												<br />
												<br />
												<br />
												<br />
												
											</div>											
											
											<div class="span7" style="margin-top:30px;">
												{{{ SECTION VI - Activity, Conversations and Forms }}}
												<br />
												<br />
												<br />
												<br />
												<br />
												<br />
												<br />
											</div>
										
										
										</div>
										
										
										<div class="span12">
										
																				
										
										</div>
									
															
							
							
										<div style="margin-top:50px;">
										
											<cfif cdashboard.totalloans neq 0>
														
												<div class="widget big-stats-container stacked" style="margin-top:-15px;">
												
													<cfoutput>
																		
														<div class="widget-content">
																			
															<div id="big_stats" class="cf">
																<div class="stat">								
																	<h4>Total Student Loans Enrolled</h4>
																	<span class="value">#cdashboard.totalloans#</span>								
																</div> <!-- .stat -->
																				
																<div class="stat">								
																	<h4>Total Student Loan Debt</h4>
																	<span class="value">#dollarformat( cdashboard.totaldebt )#</span>								
																</div> <!-- .stat -->
																				
																<div class="stat">								
																	<h4>Total Completed Solutions</h4>
																	<span class="value">#completedsolutions.recordcount#</span>								
																</div> <!-- .stat -->																
																				
																<div class="stat">								
																	<h4>Program Enrollment</h4>
																	<span class="value"><span style="padding:10px;font-size:24px;" class="label label-success">ACTIVE</span></span>								
																</div> <!-- .stat -->
															</div>
																		
														</div> <!-- /widget-content -->
																	
													</cfoutput>
																
												</div> <!-- /widget -->
											</cfif>	
										
										
										
										
											<!--- // last login and history --->
											<cfif session.lastdate neq "" and session.lastip neq "">
												<cfoutput>
													<div>
														<div style="text-align:center;">																					
															<a href="#application.root#?event=page.loginhistory" title="View Login History"><strong>Last Login</strong></a>
															<span class="stat-value" style="font-size:10px;letter-spacing:0px;">#DateFormat( session.lastdate, "mm/dd/yyyy" )# from #session.lastip#</span>													
														
															
															<!---<a class="btn btn-mini btn-tertiary" data-toggle="modal" href="##myModal" >Show Welcome Message</a>--->
														
														
														</div> <!-- /stat -->
													</div>
												</cfoutput>
											</cfif>
										
										</div>
							
							
							
							
							
							
							
							
								</div><!-- / .widget-content -->
							
							
							</div> <!-- /. widget-stacked -->
							
							--->
							
							<div style="backgroundcolor:#fff;">
							
							
								<!--- // new portal homepage --->
								<div class="accordion" id="basic-accordion">
									
									
									
									<div class="accordion-group">
										<div class="accordion-heading">
											<a class="accordion-toggle" data-toggle="collapse" data-parent="#basic-accordion" href="#collapseOne">								  
												<i class="icon-check"></i> Your Online Student Loan Advisor.  Welcome...				
											</a>
										</div>
										<div id="collapseOne" class="accordion-body in collapse">
											<div class="accordion-inner">
												<cfinclude template="page.portal.home.cfm">
											</div>
										</div>
									</div>
									
									
									
									
									<div class="accordion-group">
										<div class="accordion-heading">
											<a class="accordion-toggle" data-toggle="collapse" data-parent="#basic-accordion" href="#collapseTwo">
												<i class="icon-tasks"></i> Your Task List
											</a>
										</div>
										<div id="collapseTwo" class="accordion-body collapse">
											<div class="accordion-inner">
											
												<cfinclude template="page.tasks.cfm">
											
											</div>
										</div>
									</div>
									
									
									
									<div class="accordion-group">
										
										<div class="accordion-heading">
											<a class="accordion-toggle" data-toggle="collapse" data-parent="#basic-accordion" href="#collapseThree">
												<i class="icon-money"></i> Your Student Loans
											</a>
										</div>
										
											<div id="collapseThree" class="accordion-body collapse">
												<div class="accordion-inner">
													<div class="widget-content">
													
														<cfinclude template="page.worksheet.cfm">
													
													</div>
												</div>
											</div>
									</div>
									
									<div class="accordion-group">
										
										<div class="accordion-heading">
											<a class="accordion-toggle" data-toggle="collapse" data-parent="#basic-accordion" href="#collapseFour">
												<i class="icon-money"></i> Your Budget
											</a>
										</div>
										
											<div id="collapseFour" class="accordion-body collapse">
												<div class="accordion-inner">
													<div class="widget-content">
														<cfinclude template="page.budget.cfm">
													</div>
												</div>
											</div>
									</div>
								
								
								</div>
							</div>
							
							
							
							
							
							
							
							
						
						</div><!-- / .span12 -->
						
						
					
					</div> <!-- / .row -->					
					
					<div style="margin-top:125px;"></div>
				</div> <!-- / .container -->
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				<cfoutput>
					<div class="modal fade hide" id="myModal">
						<div class="modal-header">
							<h3>Welcome, #leaddetail.leadfirst#</h3>
						</div>
							
						<div class="modal-body">
							<p>Welcome to your Student Loan Advisor Client Portal. The portal allows you to E-sign your enrollment docs, update your contact information, upload student loan and personal information, view student loan solution packet, download forms needed to implement solutions and track progress on your file.  Before you can proceed, please see the instructions on how to e-sign your enrollment documents and payment form.  Once you have completed these steps, you will be able to have full access to the portal and be on your way to discovering the solutions for your student loan debt!</p>
						</div>
							  
						<div class="modal-footer">							
							<form class="form-inline" method="post" action="#cgi.script_name#?event=page.portal.welcome">																				
								<label class="checkbox" style="margin-right:200px;">
									<input name="chkhome" type="checkbox" value="1" checked> Show Welcome Page
								</label>											
								<button type="submit" name="savewelcomehome" class="btn btn-primary btn-large"><i class="icon-circle-arrow-right"></i> Continue</button>										
							</form>						
						</div>
					</div>
				</cfoutput>
				
				
				
			
			</div> <!-- / .main -->