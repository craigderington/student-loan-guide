
		
		
			<!--- // CF9 cflogin bug // temporary work-around --->
			<cfif not structkeyexists( session, "userid" )>
				<cflocation url="#application.root#?event=page.logout&rdurl=killopensess" addtoken="no">
			</cfif>
			
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
			
			<cfinvoke component="apis.com.portal.portaltaskgateway" method="getportaltasklist" returnvariable="portaltasklist">
				<cfinvokeargument name="leadid" value="#session.leadid#">			
			</cfinvoke>


			<!--- client portal home page --->
			
			
			<div class="main">	
				
				<div class="container">				
					
					<cfif leaddetail.leadesign eq 0>
						<div class="row">
							<div class="span12">												
								<cfoutput>
									<div class="alert alert-block alert-notice">																						
										<h4><i class="icon-home"></i> Welcome to Your Client Portal.  </h4>
										<p>To get started with the Student Loan Advisor Online Client Portal, please take the time to <strong><a href="#application.root#?event=page.enroll.esign">E-SIGN</a></strong> your <strong>Student Loan Advisory Agreement.</strong>  If you have any questions before electronically signing your document, please contact your enrollment advisor.</strong> 
										<p><a style="margin-top:10px;" href="#application.root#?event=page.enroll.esign" class="btn btn-secondary btn-medium"><i class="icon-pencil"></i> I'm Ready to E-Sign</a>  <cfif advisorteam.enrollmentcounselor is not ""><a style="margin-left:10px;margin-top:10px;" href="javascript:;" class="btn btn-medium btn-default"><i class="icon-envelope-alt"></i>  Contact #advisorteam.enrollmentcounselor#</a><br /><br /></cfif>
									</div>
								</cfoutput>							
							</div>
						</div>
								
					<cfelse>
						<div class="row">
							<div class="span12">						
								<cfoutput>
								<div class="alert alert-block alert-info">
									<button type="button" class="close" data-dismiss="alert">&times;</button>											
									<h4><i class="icon-home"></i> OK, LET'S GET STARTED!</h4>
									<p style="margin-top:7px;">Now that you have provided your electronic signature and have officially enrolled in Student Loan Advisory Program, please <strong><a href="#application.root#?event=page.portal.instructions">View Instructions</a></strong> to help you navigate your client portal.</p>
								</div>
								</cfoutput>
							</div>
						</div>						
					</cfif>
											
				
					
					
					
							
					<cfif leaddetail.leadesign eq 1 and leaddetail.leadconv eq 1>		
					<div class="row">


						<div class="span7">			
						
							
							<!--- // welcome the user --->
							<div class="widget stacked">							
								<cfoutput>
									<div class="widget-header">		
										<i class="icon-bookmark"></i>							
										<h3>Student Loan Advisory Services provided by #leaddetail.companyname#</h3>						
									</div> <!-- //.widget-header -->
														
								<div class="widget-content">	
									<div class="well">	
										<cfoutput>																				
											<h4 style="font-size:14px;"><i style="margin-right:5px;" class="icon-user"></i>  Welcome #leaddetail.leadfirst# #leaddetail.leadlast#!</h4>																	
											<p><i class="icon-home"></i> #leaddetail.leadadd1#   <cfif leaddetail.leadadd2 is not "">#leaddetail.leadadd2#</cfif> 				  	<span class="pull-right"><i style="margin-right:5px;" class="icon-calendar"></i> Enroll Date | #dateformat( leaddetail.leaddate, "mm/dd/yyyy" )#</span></p>
											<p style="margin-top:-10px;margin-left:16px;">#leaddetail.leadcity#, #ucase( leaddetail.leadstate )#  #leaddetail.leadzip#		      	<span class="pull-right"><i style="margin-right:8px;" class="icon-cog"></i> <a href="#application.root#?event=page.profile">Edit My Profile </a> | <a href="#application.root#?event=page.logout">Logout</a></span></p>								
											<p style="margin-top:-10px;"><i style="margin-right:5px;" class="icon-phone"></i> #leaddetail.leadphonetype# : #leaddetail.leadphonenumber#	  					<span class="pull-right"><i style="margin-right:2px;" class="icon-comments"></i> <cfif convolist.totalnewmsgs gt 0><span class="label label-success">#convolist.totalnewmsgs# New Message<cfif convolist.totalnewmsgs gt 1>s</cfif></span><cfelse><span class="label label-important">0 New Messages</span></cfif>  <a href="#application.root#?event=page.conversation&fuseaction=new">Ask Us</a></span></p>
											<p style="margin-top:-10px;"><i style="margin-right:5px;" class="icon-envelope"></i> #leaddetail.leademail#									 	 				<span class="pull-right"><i style="margin-right:8px;" class="icon-folder-open"></i> <a href="#application.root#?event=page.docs&fuseaction=upload">Upload New Document</a></span></p>
										</cfoutput>							
									</div>
									<!--- // last login and history --->
									<cfif session.lastdate neq "" and session.lastip neq ""><i class="icon-angle-right"></i> Last Login: #DateFormat( session.lastdate, "mm/dd/yyyy" )# from #session.lastip#</a></cfif>   <a style="margin-left:15px;" href="#application.root#?event=page.loginhistory" title="View Login History"><i class="icon-lock"></i> View Login History</strong></a>	<a style="margin-left:15px;" data-toggle="modal" href="##myModal" ><i class="icon-paste"></i> Show Welcome Message</a>
														
														
														
											
								</div><!-- / .widget-content -->
								</cfoutput>							
							</div> <!-- /. widget-stacked -->
							
							
							
							<!--- // getting started checklist --->
							<div class="widget stacked">							
								
									<div class="widget-header">		
										<i class="icon-tasks"></i>							
										<h3>Your Task List</h3>						
									</div> <!-- //.widget-header -->
														
								<div class="widget-content">
								
									<cfif leaddetail.leadesign eq 1 and leaddetail.leadconv eq 1>
										<h5><small>Please complete the following list of tasks required for student loan analysis...</small></h5>									
													
											
												<ul style="list-style:none;">
													<cfoutput query="portaltasklist">
														<li style="font-size:16px;margin-bottom:5px;"><i <cfif portaltaskcomp eq 1 and isvalid( "date", portaltaskcompdate )>style="color:green;" class="icon-check"<cfelse>style="color:red;" class="icon-check-empty"</cfif>></i> #portaltask#</li>														
													</cfoutput>
												</ul>
										
											<p style="margin-left:30px;"><small>Your task list will be updated automatically...</small></p>
									</cfif>
								
								</div><!-- / .widget-content -->						
							</div> <!-- /. widget-stacked -->
							
							
							<!--- // meet your advisors --->
							<div class="widget stacked">							
								
									<div class="widget-header">		
										<i class="icon-group"></i>							
										<h3>Meet Your Advisor Team</h3>						
									</div> <!-- //.widget-header -->
														
									<div class="widget-content">								
										<cfoutput>
											<cfif advisorteam.enrollmentcounselor is not "">															
												<i style="color:lightgray;" class="icon-user"></i>  #advisorteam.enrollmentcounselor#   Enrollment Counselor<a href="#application.root#?event=page.conversation&fuseaction=new"> <i style="margin-left:5px;" class="icon-comment"></i> Ask Me a Question</a></span><br /><br />														
											</cfif>
											<cfif advisorteam.intakeadvisor is not "">															
												<i style="color:lightgray;" class="icon-user"></i>  #advisorteam.intakeadvisor#   Intake Advisor<a href="#application.root#?event=page.conversation&fuseaction=new">  <i style="margin-left:5px;" class="icon-comment"></i> Ask Me a Question</a></span><br /><br />												
											</cfif>
											<cfif advisorteam.slsadvisor is not "">															
												<i style="color:lightgray;" class="icon-user"></i>  #advisorteam.slsadvisor#   Student Loan Advisor<a href="#application.root#?event=page.conversation&fuseaction=new">  <i style="margin-left:5px;" class="icon-comment"></i> Ask Me a Question</a></span><br /><br />												
											</cfif>
										</cfoutput>										
									</div><!-- / .widget-content -->						
							</div> <!-- /. widget-stacked -->
							
							
							
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						</div><!-- / .span6 -->
						
					
						<div class="span5">				
													
							
							
							<!--- // faq and instructions --->
							<div class="widget stacked">							
								
									
									<!--- // quick stats --->
									<div class="widget stacked">							
										
											<div class="widget-header">		
												<i class="icon-star"></i>							
												<h3>Quick Stats</h3>						
											</div> <!-- //.widget-header -->
																
											<div class="widget-content">
											
												<cfoutput>
													<div id="big_stats">
															<div class="stat">								
																	<h4>Total Student Loans Enrolled</h4>
																	<span class="value">#cdashboard.totalloans#</span>								
																</div> <!-- .stat -->
																							
																<div class="stat">								
																	<h4>Total Student Loan Debt</h4>
																	<span class="value">#dollarformat( cdashboard.totaldebt )#</span>								
																</div> <!-- .stat -->															
																<!---
																<div class="stat">								
																	<h4>Total Completed Solutions</h4>
																	<span class="value">#completedsolutions.recordcount#</span>								
																</div> <!-- .stat -->																
																						
																
																<div class="stat">								
																	<h4>Program Enrollment</h4>
																	<span class="value"><span style="padding:10px;font-size:24px;" class="label label-success">ACTIVE</span></span>								
																</div> <!-- .stat -->
																--->
														</div>
												</cfoutput>
											
											</div><!-- / .widget-content -->						
									</div> <!-- /. widget-stacked -->
									
									
									
									<div class="widget-header">		
										<i class="icon-download"></i>							
										<h3>Student Loan Advisor Online FAQ's</h3>						
									</div> <!-- //.widget-header -->
														
									
									<cfoutput>
										<div class="widget-content">
										
											<a style="margin-bottom: 10px;" href="#application.root#?event=page.portal.faqs##faq-1"><i class="icon-question-sign"></i> What is NSLDS?</a><br />
											<a style="margin-bottom: 10px;"href="#application.root#?event=page.portal.faqs##faq-2"><i class="icon-question-sign"></i> What is my Federal Student Loan PIN?</a><br />
											<a href="#application.root#?event=page.portal.faqs##faq-9"><i class="icon-question-sign"></i> What is Adjusted Gross Income?</a><br />
											
											<br />
											
											<a href="#application.root#?event=page.portal.instructions" class="btn btn-default btn-small"><i class="icon-coffee"></i> View Instructions</a>
											<a href="javascript:;" style="margin-left:5px;" class="btn btn-secondary btn-small" onclick="window.open('https://www.nslds.ed.gov/nslds_SA/','','scrollbars=yes,width=918,height=695');"><i class="icon-key"></i> Access NSLDS</a>									
											<a href="javascript:;" style="margin-left:5px;" class="btn btn-primary btn-small" onclick="window.open('https://pin.ed.gov/PINWebApp/pinindex.jsp','','scrollbars=yes,width=918,height=695');"> <i class="icon-lock"></i> Retrieve NSLDS PIN</a></p>
										</div><!-- / .widget-content -->
									</cfoutput>
							</div> <!-- /. widget-stacked -->
						
							
							
						
						
							<!--- // recent activity  --->
							<div class="widget stacked">							
								
									<div class="widget-header">		
										<i class="icon-money"></i>							
										<h3>Recent Account Activity</h3>						
									</div> <!-- //.widget-header -->
														
								<div class="widget-content">
								
									<cfif leadact.recordcount gt 0>
										<table class="table table-bordered table-striped">
											<thead>
												<tr>												
													<th>Date</th>
													<th>Activity</th>
												</tr>
											</thead>
											<tbody>					
												<cfoutput query="leadact" maxrows="3">
												<tr>
													<td>#dateformat( activitydate, "mm/dd/yyyy" )#</td>
													<td>#activity#</td>
												</tr>
												</cfoutput>
											</tbody>
										</table>
										
										<cfoutput>
											<a style="margin-top:5px;" href="#application.root#?event=page.activity"><i class="icon-pushpin"></i> View All Activity</a>
										</cfoutput>
										
									<cfelse>
									
										<small>No activity recorded...  This will automatically update as your user activity is recorded throughout the system.</small>
									
									</cfif>
									
									
									
								</div><!-- / .widget-content -->						
							</div> <!-- /. widget-stacked -->
							
							
							<!--- // getting started checklist --->
							<div class="widget stacked">							
								
									<div class="widget-header">		
										<i class="icon-money"></i>							
										<h3>Program Shortcuts</h3>						
									</div> <!-- //.widget-header -->
														
								<div class="widget-content">
								
									<cfoutput>
											<div class="shortcuts">
												<a href="#application.root#?event=page.budget" class="shortcut">
													<i class="shortcut-icon icon-money"></i>
													<span class="shortcut-label">Budget</span>
												</a>
												
												<a href="#application.root#?event=page.survey" class="shortcut">
													<i class="shortcut-icon icon-question-sign"></i>
													<span class="shortcut-label">Questionnaire</span>
												</a>
												
												<a href="#application.root#?event=page.library.forms" class="shortcut">
													<i class="shortcut-icon icon-book"></i>
													<span class="shortcut-label">Forms Library</span>								
												</a>
												
												<a href="#application.root#?event=page.docs" class="shortcut">
													<i class="shortcut-icon icon-file-alt"></i>
													<span class="shortcut-label">Your Documents</span>	
												</a>
												
												<a href="#application.root#?event=page.worksheet" class="shortcut">
													<i class="shortcut-icon icon-table"></i>
													<span class="shortcut-label">Loan Worksheets</span>								
												</a>
												
												<a href="#application.root#?event=page.profile" class="shortcut">
													<i class="shortcut-icon icon-user"></i>
													<span class="shortcut-label">Profile</span>								
												</a>						
												
											</div> <!-- / .shortcuts -->
											</cfoutput>
								
								</div><!-- / .widget-content -->						
							</div> <!-- /. widget-stacked -->
							
							
							
							
						
						</div>
					
					
					
					
					
					</div><!-- / .row -->
					</cfif>
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					<cfif leaddetail.leadesign eq 0 >
						<div style="margin-top:425px;"></div>
					<cfelse>
						<div style="margin-top:125px;"></div>
					</cfif>
				</div> <!-- / .container -->


												<!--- // show welcome message --->
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