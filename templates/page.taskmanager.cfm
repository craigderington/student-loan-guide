
		
			
			<!--- // get our data access components --->
			
			<cfinvoke component="apis.com.ui.dashboardgateway" method="gettaskmanager" returnvariable="taskmgr">
				<cfinvokeargument name="companyid" value="#session.companyid#">
			</cfinvoke>
			
			
			

			<!--- task manager page --->
			


			
					
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
							
							<div class="widget stacked">
								<cfoutput>
								<div class="widget-header">		
									<i class="icon-tasks"></i>							
									<h3>#session.username#'s Task Manager</h3>						
								</div> <!-- //.widget-header -->
								</cfoutput>
								
								<div class="widget-content">						
																	
									<table class="table table-bordered table-striped table-highlight">
										<thead>
											<tr>
												<th width="8%">Get Tasks</th>												
												<th width="82%">Name</th>												
												<th width="10%">Pending Tasks</th>
											</tr>
										</thead>
										<tbody>
											<cfoutput query="taskmgr">
											<tr>
												<td class="actions">
													
													<a href="#application.root#?event=page.getlead&fuseaction=leadgen&leadid=#leaduuid#" class="btn btn-small btn-warning">
														<i class="btn-icon-only icon-ok"></i>										
													</a>														
														
												</td>												
												<td>#leadfirst# #leadlast#</td>												
												<td><span class="<cfif totaltaskspending gte 20>badge badge-important<cfelseif totaltaskspending gt 10 and totaltaskspending lt 20>badge badge-success<cfelse>badge badge-info</cfif>">#totaltaskspending#</span></td>
											</tr>
											</cfoutput>
										</tbody>
									</table>
									
									
									<div class="clear"></div>
								</div> <!-- //.widget-content -->	
									
							</div> <!-- //.widget -->
							
						</div> <!-- //.span12 -->
						
					</div> <!-- //.row -->			
				
					<cfif taskmgr.recordcount lt 7>
						<div style="height:250px;"></div>			
					<cfelse>
						<div style="height:200px;"></div>
					</cfif>
				</div> <!-- //.container -->
			
			</div> <!-- //.main -->