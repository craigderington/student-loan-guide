
			
			
			<!--- // get our data access components --->
			<cfinvoke component="apis.com.ui.dashboardgateway" method="getmydashboard" returnvariable="mydashboard">
				<cfinvokeargument name="companyid" value="#session.companyid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.reports.reportgateway" method="getleadagereport" returnvariable="leadagereport">
				<cfinvokeargument name="companyid" value="#session.companyid#">
				<cfinvokeargument name="thisdate" value="#createodbcdatetime( now() )#" />
			</cfinvoke>
			
			
			
			
			<!--- reports css --->
			
			
			<link href="./css/pages/reports.css" rel="stylesheet">
			
					
			




			<!--- // begin reports page --->
			
			<div class="main">

				<div class="container">
					
					<div class="row">
				  
						<div class="span12">
							
							<div class="widget big-stats-container stacked">
								
								<div class="widget-content">
									
									<cfoutput>
										<div id="big_stats" class="cf">
											<div class="stat">								
												<h4>Active Leads</h4>
												<span class="value">#mydashboard.totalleads#</span>								
											</div> <!-- .stat -->
											
											<div class="stat">								
												<h4>Enrolled Clients</h4>
												<span class="value">#mydashboard.totalclients#</span>								
											</div> <!-- .stat -->

											<div class="stat">								
												<h4>Enrolled Student Loans</h4>
												<span class="value">#mydashboard.totalloans#</span>								
											</div> <!-- .stat -->
											
											<div class="stat">								
												<h4>Total Enrolled Debt</h4>
												<span class="value">#dollarformat( mydashboard.totaldebt )#</span>								
											</div> <!-- .stat -->
										</div>
									</cfoutput>
								</div> <!-- /widget-content -->
								
							</div> <!-- /widget -->
							
						</div> <!-- /span12 -->	
					
					</div> <!-- /row -->

					<div class="row">
					
						<div class="span12">
							
							<div class="widget stacked">
									
								<div class="widget-header">
									<i class="icon-calendar"></i>
									<h3>Lead Aging Report</h3>
								</div> <!-- /widget-header -->
								
								<div class="widget-content">
									
									<table class="table table-bordered table-striped table-highlight">
										<thead>
											<tr>
												<th width="5%">Actions</th>
												<th>First Name</th>												
												<th>Inquiry Date</th>
												<th>Age</th>
											</tr>
										</thead>
										<tbody>
											<cfoutput query="leadagereport">
												<tr>
													<td class="actions">
														<a href="#application.root#?event=page.getlead&fuseaction=leadgen&leadid=#leaduuid#" class="btn btn-mini btn-warning">
															<i class="btn-icon-only icon-ok"></i>										
														</a>						
													</td>													
													<td>#leadfirst# #leadlast#</td>
													<td>#dateformat( leaddate, "mm/dd/yyyy" )#</td>
													<td><span class="label label-success">#leadage#</span></td>
												</tr>
											</cfoutput>												
										</tbody>
									</table>
									
								</div> <!-- /widget-content -->
									
							</div> <!-- /widget -->
							
						</div> <!-- /span12 -->
					
					</div> <!-- /row -->
				  
				  
				</div> <!-- /container -->
				
			</div> <!-- /main -->