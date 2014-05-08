


			<!--- get oru data access components --->
			<cfinvoke component="apis.com.convo.convogateway" method="getmessagecenter" returnvariable="msgcenter">
				<cfinvokeargument name="myid" value="#session.userid#">
			</cfinvoke>
			
			
			<!--- page to enroll and e-sign the enrollment documents --->
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
						
							<!--- system messages --->
							<cfif structkeyexists( url, "msg" ) and url.msg is "posted">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-info">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong><i class="icon-check"></i> SUCCESS!</strong>  Your conversation reply was posted and the Advisor notified by email.  Please check back shortly for a response...
										</div>										
									</div>								
								</div>
							<cfelseif structkeyexists( url, "msg" ) and url.msg is "replyposted">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-success">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong><i class="icon-comments-alt"></i> REPLY SUCCESS!</strong>  Your reply posted successfully...
										</div>										
									</div>								
								</div>
							<cfelseif structkeyexists( url, "msg" ) and url.msg is "thread.closed">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-info">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong>THREAD CLOSED!</strong>  The conversation thread was closed...
										</div>										
									</div>								
								</div>
							</cfif>	
							
							
							<div class="widget stacked">
								
								<cfoutput>	
									<div class="widget-header">		
										<i class="icon-comments"></i>							
										<h3>Your Message Center</h3>						
									</div> <!-- //.widget-header -->
								</cfoutput>	
							
								<div class="widget-content">
									
									<cfif msgcenter.recordcount eq 0>
									
										<div class="alert alert-info">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong><i class="icon-warning-sign"></i> NO MESSAGES!</strong>  You have no open conversations or new messages.
										</div>
									
									<cfelse>
										
										<h4><i class="icon-comments-alt"></i> Your Open Conversations</h4>
										
											<table class="table table-bordered table-striped table-highlight">
												<thead>
													<tr>
														<th width="15%">Actions</th>
														<th>Client Name</th>
														<th>Status</th>
														<th>Last Message Date</th>
														<th>New Messages</th>														
													</tr>
												</thead>
												<tbody>
													<cfoutput query="msgcenter">
														<tr>
															<td class="actions">																
																	<a href="#application.root#?event=page.getlead&fuseaction=leadgen&leadid=#leaduuid#&thread=#convouuid#" class="btn btn-mini btn-warning" title="Open Thread">
																		<i class="btn-icon-only icon-ok"></i>										
																	</a>
																	
																	<cfif convostatus is "open" and convoclosed eq 0>
																	<a href="#application.root#?event=#url.event#" class="btn btn-mini" title="Close Thread">
																		<i class="btn-icon-only icon-remove"></i>										
																	</a>					
																	</cfif>
															</td>														
															<td>#leadfirst# #leadlast#</td>
															<td><cfif convostatus is "open"><span style="padding:3px;" class="label label-success">Open</span><cfelse><span style="padding:3px;" class="label label-default">Closed</span></cfif></td>
															<td><span class="label label-default">#dateformat( lastmsgdate, "mm/dd/yyyy" )# at #timeformat( lastmsgdate, "hh:mm:ss tt" )#</span></td>
															<td><cfif totalnewmessages gt 0><span style="padding:3px;" class="label label-success">#totalnewmessages#</span><cfelse><span style="padding:3px;" class="label label-default">#totalnewmessages#</span></cfif></td>															
														</tr>
													</cfoutput>
												</tbody>
											</table>		
										
									</cfif>
								</div>
								
							</div>
							
							
						
						</div><!-- / .span12 -->
					</div><!-- / .row -->
					<cfif msgcenter.recordcount lt 10>
						<div style="margin-top:450px;"></div>
					<cfelse>
						<div style="margin-top:205px;"></div>
					</cfif>
				</div><!-- / .container -->
			</div><!-- / .main -->