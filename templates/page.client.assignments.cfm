	
	
			
			<!--- // get our data access components --->
			<cfinvoke component="apis.com.clients.assigngateway" method="getallassignments" returnvariable="clientassignments">
				<cfinvokeargument name="userid" value="#session.userid#">
			</cfinvoke>
			
			
			
			<!--- page to enroll and e-sign the enrollment documents --->
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">						
							
							<div class="widget stacked">
								<div class="widget-header">		
									<i class="icon-group"></i>							
									<h3>View All Client Assignments</h3>						
								</div> <!-- //.widget-header -->								
							
								<div class="widget-content">

									<div class="tab-content">
												
										<div class="tab-pane active" id="tab1">																			
												
												<cfif clientassignments.recordcount gt 0>
													
													<cfoutput>
													<h4><i class="icon-inbox"></i> <small>You currently have #clientassignments.recordcount# client<cfif clientassignments.recordcount gt 1>s</cfif>  assigned to your user ID.  Access your individual client files by clicking the orange checkmark next to the client name.</small></h4><br />
													</cfoutput>
													<table class="table table-striped table-bordered">
														<thead>
															<tr>
																<th>Client Name</th>
																<th>Date Assigned</th>
																<th class="td-actions">Actions</th>
															</tr>
														</thead>
														<tbody>
															<cfoutput query="clientassignments">
																<tr>
																	<td>#leadfirst# #leadlast#</td>
																	<td>#dateformat( leadassigndate, "mm/dd/yyyy" )# <cfif datediff( "d", leadassigndate, now() ) lt 1><span class="label label-info" style="margin-left:25px;"><small>Days Assigned: &nbsp;Less than 1 day</small><cfelse><span class="label label-important" style="margin-left:25px;"><small>Days Assigned: </small>&nbsp; #datediff( "d", leadassigndate, now() )#</span></cfif><cfif leadassignaccept eq 1><span style="margin-left:5px;" class="label label-success">Accepted on #dateformat( leadassignacceptdate, "mm/dd/yyyy" )#</span></cfif></td>
																	<td>
																	
																		<a href="#application.root#?event=page.getlead&fuseaction=leadgen&leadid=#leaduuid#" class="btn btn-small btn-warning">
																			<i class="btn-icon-only icon-ok"></i>										
																		</a>

																		<a href="#application.root#?event=page.getlead&fuseaction=leadgen&leadid=#leaduuid#" class="btn btn-small btn-secondary">
																			<i class="btn-icon-only icon-tasks"></i>										
																		</a>
																	
																	</td>
																</tr>
															</cfoutput>
														</tbody>											
													</table>										
												<cfelse>
													<div class="alert alert-error" style="padding:5px;">												
														<i class="icon-warning-sign"></i> <strong>Sorry</strong>, you have no active client assignments.  Please conatct your company administrator for more information.
													</div>	
												</cfif>
											
											<!--- // dump vars 
											<cfdump var="#clientassignments#" label="Client Assignments">
											--->
												
													
										</div> <!-- / .tab1 -->										 
											
									</div> <!-- / .tab-content -->
									
					
								</div> <!-- / .widget-content -->
							
							</div> <!-- / .widget-stacked -->
						
						</div><!-- / .span12 -->
					
					</div> <!-- / .row -->
					<cfif clientassignments.recordcount lt 10>
						<div style="margin-top:375px;"></div>
					<cfelse>
						<div style="margin-top:100px;"></div>
					</cfif>
				</div> <!-- / .container -->
			
			</div> <!-- / .main -->
		