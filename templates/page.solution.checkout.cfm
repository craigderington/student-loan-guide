	
	
			
		<!--- // get our data access objects --->
		<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
			<cfinvokeargument name="leadid" value="#session.leadid#">
		</cfinvoke>
			
		<cfinvoke component="apis.com.leads.leadgateway" method="getleadsummary" returnvariable="leadsummary">
			<cfinvokeargument name="leadid" value="#session.leadid#">
		</cfinvoke>
			
		<cfinvoke component="apis.com.solutions.solutiongateway" method="getsolutions" returnvariable="solutionlist">
			<cfinvokeargument name="leadid" value="#session.leadid#">
		</cfinvoke>
		
		
		
		<div class="main">
			
			<div class="container">
			
				<div class="row">
				
					<div class="span12">
			
			
						<div class="widget stacked">
									
									<cfoutput>
									<div class="widget-header">		
										<i class="icon-shopping-cart"></i>							
										<h3>Solution Cart Checkout | Confirm Student Loan Solutions for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
									</div> <!-- //.widget-header -->
									</cfoutput>
									
									
									<div class="widget-content">
									
										
										<cfif solutionlist.recordcount gt 0>												
													
											<table class="table table-bordered table-striped table-highlight">
												<thead>
													<tr>															
														<th>Servicer</th>
														<th>School Attended</th>
														<th>Chosen Solution</th>
														<th>Loan Type</th>												
													</tr>
												</thead>
												<tbody>
												<cfoutput query="solutionlist">
													<tr>																												
														<td><cfif servid neq -1>#servname#<cfelse>#nslservicer#</cfif></td>
														<td>#attendingschool#</td>
														<td>#solutionsubcat# #solutionoption#</td>
														<td><cfif solutionoptiontree eq 1>Direct Loan<cfelseif solutionoptiontree eq 2>FFEL Loan<cfelseif solutionoptiontree eq 2><cfelseif solutionoptiontree eq 3>Perkins Loan<cfelseif solutionoptiontree eq 4>Direct Consolidation<cfelseif solutionoptiontree eq 5>Health Professional<cfelseif solutionoptiontree eq 6>Parent PLUS<cfelseif solutionoptiontree eq 7>Private Loan</cfif></td>																									
													</tr>
												</cfoutput>
												</tbody>
											</table>
														
											<cfoutput>	
												<a href="#application.root#?event=page.solution" class="btn btn-medium btn-secondary"><i class="icon-shopping-cart"></i> Return to Solution Cart</a>  <a href="#application.root#?event=page.solution.final" style="margin-left: 5px;" class="btn btn-medium btn-primary" onclick="window.open('#application.root#?event=page.solution.present','_blank');"><i class="icon-book"></i> Generate Solution Presentation</a>  <a href="#application.root#?event=page.tree" class="btn btn-medium btn-default" style="margin-left: 5px;"><i class="icon-sitemap"></i> Return to Option Tree</a>
											</cfoutput>
											
										<cfelse>
										
										
											<div class="alert alert-error">
												<button type="button" class="close" data-dismiss="alert">&times;</button>
												<strong><i class="icon-warning-sign"></i> ERROR</strong>  No incomplete student loan debt solutions were found for the selected client.  Please return to the solution cart or option tree...
											</div>								
										
										
										</cfif>	
									
									</div>
						
						</div>
					
						
					</div>
				
				</div>
					<cfif solutionlist.recordcount LTE 5>
						<div style="height:400px;"></div>	
					<cfelse>
						<div style="height:200px;"></div>
					</cfif>
			</div>
			
		</div>