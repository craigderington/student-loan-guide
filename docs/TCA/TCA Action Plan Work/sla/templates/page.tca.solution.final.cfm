






			<!--- // Take Charge America Workflow --->
			
			
			<!--- // include our data components and api --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>			
			
			<cfinvoke component="apis.com.clients.clientgateway" method="getclientsurvey" returnvariable="clientsurvey">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>			
			
			<cfinvoke component="apis.com.worksheets.worksheetgateway" method="getworksheets" returnvariable="worksheetlist">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.solutions.tcasolutiongateway" method="gettcasolution" returnvariable="tcasolution">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.solutions.tcasolutiongateway" method="gettcasolutions" returnvariable="tcasolutions">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.solutions.tcasolutiongateway" method="gettcasolutioncount" returnvariable="tcasolutioncount">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			
			
			
				
				
				
			
					<cfoutput>
						<div class="main">	
							
							<div class="container">
								
								<div class="row">
						
									<div class="span8">
										
										<div class="widget stacked">
											
											<div class="widget-header">		
												<i class="icon-paste"></i>							
												<h3>Take Charge America &raquo; Print Action Plan for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
											</div> <!-- //.widget-header -->
											
											<div class="widget-content">									
											
												<div style="padding:20px;" class="well">
													
													<ul style="list-style:none;">
														
														<li><i class="icon-paste"></i> Solution ID: #tcasolution.tcasolutionuuid#</li>
														<li><i class="icon-calendar"></i> Solution Date: #dateformat( tcasolution.tcasolutiondate, "mm/dd/yyyy" )#</li>
														<li><i class="icon-user"></i> Advisor: #tcasolution.firstname# #tcasolution.lastname#</li>
														<li>&nbsp;</li>
														<cfif trim( tcasolution.consol ) eq 'Y'>
															<li><i class="icon-ok"></i> Consolidation</li>
														</cfif>
														
														<cfif trim( tcasolution.idrconsol ) eq 'Y'>
															<li><i class="icon-ok"></i> Consolidation - Income Driven Repayment</li>
														</cfif>
														
														<cfif trim( tcasolution.pslfconsol ) eq 'Y'>
															<li><i class="icon-ok"></i> Public Service Loan Forgiveness + Consolidation</li>
														</cfif>												
														
														<cfif trim( tcasolution.ibr ) eq 'Y'>
															<li><i class="icon-ok"></i> Income Based Repayment / Non-Consolidated</li>
														</cfif>
														
														<cfif trim( tcasolution.icr ) eq 'Y'>
															<li><i class="icon-ok"></i> Income Contingent Repayment / Non-Consolidated</li>
														</cfif>
														
														<cfif trim( tcasolution.paye ) eq 'Y'>
															<li><i class="icon-ok"></i> Pay As You Earn / Non-Consolidated</li>
														</cfif>
														
														<cfif trim( tcasolution.rehab ) eq 'Y'>
															<li><i class="icon-ok"></i> Rehabilitation</li>
														</cfif>
														
														<cfif trim( tcasolution.pslf ) eq 'Y'>
															<li><i class="icon-ok"></i> Public Service Loan Forgiveness</li>
														</cfif>									
														
														<cfif trim( tcasolution.tlf ) eq 'Y'>
															<li><i class="icon-ok"></i> Teacher Loan Forgiveness</li>
														</cfif>
														
														
														<cfif trim( tcasolution.forbear ) eq 'Y'>
															<li><i class="icon-ok"></i> Forbearance</li>
														</cfif>
														
														<cfif trim( tcasolution.unempdefer ) eq 'Y'>
															<li><i class="icon-ok"></i> Unemployment Deferment</li>
														</cfif>
														
														<cfif trim( tcasolution.econdefer ) eq 'Y'>
															<li><i class="icon-ok"></i> Economic Hardship Deferment</li>
														</cfif>
													</ul>
													
													<br /><br /><br />
													
													<div class="form-actions">													
														<button type="submit" class="btn btn-secondary" name="create-action-plan"><i class="icon-paste"></i> Create Action Plan</button>																									
														<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.tree'"><i class="icon-remove-sign"></i> Cancel</a>													
														<input name="utf8" type="hidden" value="&##955;">													
														<input type="hidden" name="leadid" value="#session.leadid#" />														
														<input type="hidden" name="__authToken" value="#randout#" />
														<input name="validate_require" type="hidden" value="leadid|Opps, sorry... the form can not be posted due to an internal error.  Please re-load the page and try again.;solutiontext|You did not enter a personal solution narrative." />															
													</div> <!-- /form-actions -->
												
												</div>
																	
																							
											
											
											</div>
										</div>
									</div>
									
									
									
									
									
									
									
									
									
									
									
									
									<!--- // 11-18-2014 // add sidebar --->
									
									<div class="span4">
										
										<div class="widget stacked">
											
											<div class="widget-header">		
												<i class="icon-th-large"></i>							
												<h3>The Solutions You've Selected</h3>						
											</div> <!-- //.widget-header -->
											
											<div class="widget-content">
											
												
													<ul style="list-style:none;">									
														
														<cfif trim( tcasolution.consol ) eq 'Y'>
															<li><i class="icon-ok"></i> Consolidation</li>
														</cfif>
														
														<cfif trim( tcasolution.idrconsol ) eq 'Y'>
															<li><i class="icon-ok"></i> Consolidation - Income Driven Repayment</li>
														</cfif>
														
														<cfif trim( tcasolution.pslfconsol ) eq 'Y'>
															<li><i class="icon-ok"></i> Public Service Loan Forgiveness + Consolidation</li>
														</cfif>												
														
														<cfif trim( tcasolution.ibr ) eq 'Y'>
															<li><i class="icon-ok"></i> Income Based Repayment / Non-Consolidated</li>
														</cfif>
														
														<cfif trim( tcasolution.icr ) eq 'Y'>
															<li><i class="icon-ok"></i> Income Contingent Repayment / Non-Consolidated</li>
														</cfif>
														
														<cfif trim( tcasolution.paye ) eq 'Y'>
															<li><i class="icon-ok"></i> Pay As You Earn / Non-Consolidated</li>
														</cfif>
														
														<cfif trim( tcasolution.rehab ) eq 'Y'>
															<li><i class="icon-ok"></i> Rehabilitation</li>
														</cfif>
														
														<cfif trim( tcasolution.pslf ) eq 'Y'>
															<li><i class="icon-ok"></i> Public Service Loan Forgiveness</li>
														</cfif>									
														
														<cfif trim( tcasolution.tlf ) eq 'Y'>
															<li><i class="icon-ok"></i> Teacher Loan Forgiveness</li>
														</cfif>
														
														
														<cfif trim( tcasolution.forbear ) eq 'Y'>
															<li><i class="icon-ok"></i> Forbearance</li>
														</cfif>
														
														<cfif trim( tcasolution.unempdefer ) eq 'Y'>
															<li><i class="icon-ok"></i> Unemployment Deferment</li>
														</cfif>
														
														<cfif trim( tcasolution.econdefer ) eq 'Y'>
															<li><i class="icon-ok"></i> Economic Hardship Deferment</li>
														</cfif>
													</ul>
												
											
											</div>
										</div>
										
										
										
										
										
										<div class="widget stacked">
											
											<div class="widget-header">		
												<i class="icon-list-alt"></i>							
												<h3>All Completed Solutions</h3>						
											</div> <!-- //.widget-header -->
											
											<div class="widget-content">
											
												<ul style="list-style:none;">
													<cfloop query="tcasolutions">
														<li><a href="javascript:void(0);">( #tcasolutionid# )</a> - #dateformat( tcasolutiondate, "mm/dd/yyyy" )#</li> 
													</cfloop>
												</ul>
											
											</div>
										</div>
										
										
										<div class="widget stacked">
											
											<div class="widget-header">		
												<i class="icon-tasks"></i>							
												<h3>Solutions by Solution Type</h3>						
											</div> <!-- //.widget-header -->
											
											<div class="widget-content">
											<small>
												<table class="table table-striped">
													<thead>
														<tr>
															<th width="65%">Type</th>
															<th>Count</th>												
														</tr>
													</thead>
													<tbody>
														<tr>								
															<td>Consolidation + IDR</td>
															<td>#tcasolutioncount.totalidrconsol#</td>												
														</tr>
														<tr>								
															<td>Consolidation</td>
															<td>#tcasolutioncount.totalconsol#</td>												
														</tr>
														<tr>								
															<td>Economic Hardship</td>
															<td>#tcasolutioncount.totalecondefer#</td>												
														</tr>
														<tr>								
															<td>Forbearance</td>
															<td>#tcasolutioncount.totalforbear#</td>												
														</tr>
														<tr>								
															<td>IBR/Non-Consolidated</td>
															<td>#tcasolutioncount.totalibr#</td>												
														</tr>
														<tr>								
															<td>ICR/Non-Consolidated</td>
															<td>#tcasolutioncount.totalicr#</td>												
														</tr>
														<tr>								
															<td>PAYE</td>
															<td>#tcasolutioncount.totalpaye#</td>												
														</tr>
														<tr>								
															<td>PSLF + Consolidation</td>
															<td>#tcasolutioncount.totalpslfconsol#</td>												
														</tr>
														<tr>								
															<td>PSLF</td>
															<td>#tcasolutioncount.totalpslf#</td>												
														</tr>
														<tr>								
															<td>Rehabilitation</td>
															<td>#tcasolutioncount.totalrehab#</td>												
														</tr>
														<tr>								
															<td>Teacher Loan Forgiveness</td>
															<td>#tcasolutioncount.totaltlf#</td>												
														</tr>
														<tr>								
															<td>Unemployment Deferment</td>
															<td>#tcasolutioncount.totalunempdefer#</td>												
														</tr>
													</tbody>
												</table>										
											</small>
											</div>
										</div>
										
																	
										
									</div>									
								</div>
								<div style="margin-top:150px;"></div>
							</div>
						</div>
					</cfoutput>