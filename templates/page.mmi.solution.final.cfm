






			<!--- // Money Management International Workflow --->
			
			
			<!--- // include our data components and api --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>

			<cfinvoke component="apis.com.solutions.mmisolutiongateway" method="getmmisolution" returnvariable="mmisolution">
				<cfinvokeargument name="leadid" value="#session.leadid#">
				<cfinvokeargument name="planid" value="#session.planid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.solutions.mmisolutiongateway" method="getmmisolutiondetail" returnvariable="mmisolutiondetail">
				<cfinvokeargument name="mmisolutionid" value="#mmisolution.mmisolutionid#">				
			</cfinvoke>
				
			
					<cfoutput>
						<div class="main">	
							
							<div class="container">
								
								<div class="row">
						
									<div class="span7">
										
										<div class="widget stacked">
											
											<div class="widget-header">		
												<i class="icon-paste"></i>							
												<h3>#session.companyname# &raquo; Print Action Plan for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
											</div> <!-- //.widget-header -->
											
											<div class="widget-content">									
											
												<div style="padding:20px;" class="well">
													
													<ul style="list-style:none;">
														
														<li><i class="icon-paste"></i> Solution ID: #mmisolution.mmisolutionuuid#</li>
														<li><i class="icon-calendar"></i> Solution Date: #dateformat( mmisolution.mmisolutiondate, "mm/dd/yyyy" )#</li>
														<li><i class="icon-user"></i> Advisor: #mmisolution.firstname# #mmisolution.lastname#</li>
														
													</ul>
													
													<br />												
													<br /><br />
													
														<div class="form-actions">													
															<a name="create-action-plan" class="btn btn-secondary" onclick="location.href='#application.root#?event=page.mmi.create.action.plan&clientid=#leaddetail.leadid#&planid=#mmisolution.mmisolutionuuid#'"><i class="icon-paste"></i> Create Action Plan</button>																									
															<a style="margin-left:5px;" name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.tree'"><i class="icon-remove-sign"></i> Cancel</a>													
															<input name="utf8" type="hidden" value="&##955;">													
															<input type="hidden" name="leadid" value="#session.leadid#" />														
															<input type="hidden" name="__authToken" value="#randout#" />
															<input name="validate_require" type="hidden" value="leadid|Opps, sorry... the form can not be posted due to an internal error.  Please re-load the page and try again.;solutiontext|You did not enter a personal solution narrative." />															
														</div> <!-- /form-actions -->
													
												</div>										
											</div>
										</div>
									</div>

									<div class="span5">
										<div class="widget stacked">
											<div class="widget-header">
												<i class="icon-list-alt"></i>
												<h3>Options Presented</h3>
											</div>
											
											<div class="widget-content">
												<table class="table table-striped table-highlight">
													<thead>
														<tr>
															<th width="25%">Loan Type</th>
															<th width="25%">Category</th>
															<th>Option</th>
													</thead>
													<tbody>
														<cfloop query="mmisolutiondetail">
														<tr>
															<td>#mmisolutiontree#</td>
															<td>#mmisolutionoption#</td>
															<td>#mmisolutionsubcat#</td>
														</tr>
														</cfloop>
													</tbody>
												</table>
											</div>
											
											
											
										</div>
									
									</div>
									
									
									
																
								</div>
								<div style="margin-top:250px;"></div>
							</div>
						</div>
					</cfoutput>