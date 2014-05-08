
			
			
			
			
			<!--- get our necessary components --->
			<cfinvoke component="apis.com.clients.clientgateway" method="getclientsearch" returnvariable="clientsearch">
			
			
			
			<!--- search results page --->
			
					
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
							
							<div class="widget stacked">
								
								<div class="widget-header">		
									<i class="icon-search"></i>							
									<h3>Search Results</h3>						
								</div> <!-- //.widget-header -->
								
								<div class="widget-content">						
									
									<cfif clientsearch.recordcount gt 0>
										
										<cfparam name="url.startRow" default="1" >
										<cfparam name="url.rowsPerPage" default="20" >
										<cfparam name="currentPage" default="1" >
										<cfparam name="totalPages" default="0" >
										
										
										<cfoutput><h5 style="color:##f90;">The search query found #clientsearch.recordcount# records matching your input.  Please select the lead record below...</h5></cfoutput>
										
										<table id="myTable" class="table table-bordered table-striped table-highlight tablesorter">
											<thead>
												<tr>
													<th width="5%">Actions</th>												
													<th>Lead Source</th>
													<th>Client Name</th>
													<th>Phone</th>
													<th>Email</th>
													<th>Status</th>
													<th>Date Enrolled</th>
												</tr>
											</thead>
											<tbody>
												<cfoutput query="clientsearch" startrow="#url.startrow#" maxrows="#url.rowsperpage#">
												<tr>
													<td class="actions">													
														<a href="#application.root#?event=page.getlead&fuseaction=leadgen&leadid=#leaduuid#" class="btn btn-small btn-warning">
															<i class="btn-icon-only icon-ok"></i>										
														</a>		
													</td>											
													<td>#leadsource#</td>
													<td>#leadfirst# #leadlast# (#leadid#)</td>
													<td><cfif leadphonenumber is not "">#leadphonenumber# (#leadphonetype#)<cfelse>Not Defined</cfif></td>
													<td>#leademail#</td>
													<td><cfif leadactive eq 1><span class="label label-success">ACTIVE</span><cfelse><span class="label label-default">INACTIVE</span></cfif></td>
													<td><span class="label label-success">#dateformat(leaddate, "mm/dd/yyyy")#</span></td>												
												</tr>
												</cfoutput>
											</tbody>
										</table>
										
										<p style="float:left;">
											<!--- // 7-26-2013 // new pagination ++ page number links --->
													
											<cfset totalRecords = clientsearch.recordcount >
											<cfset totalPages = totalRecords / rowsPerPage >
											<cfset endRow = (startRow + rowsPerPage) - 1 >													

												<!--- If the endrow is greater than the total, set the end row to to total --->
												<cfif endRow GT totalRecords>
													<cfset endRow = totalRecords>
												</cfif>

												<!--- Add an extra page if you have leftovers --->
												<cfif (totalRecords MOD rowsPerPage) GT 0 >
													<cfset totalPages = totalPages + 1 >
												</cfif>

												<!--- Display all of the pages --->
												<cfif totalPages gte 2>
													<div class="pagination">
														<ul>
														<cfloop from="1" to="#totalPages#" index="i">
															<cfset startRow = ((i - 1) * rowsPerPage) + 1>
																<cfif currentPage neq i>
																	<cfoutput><li><a href="#cgi.script_name#?event=#url.event#&startRow=#startRow#&currentPage=#i#">#i#</a></li></cfoutput>
																<cfelse>
																	<cfoutput><li class="active"><a href="javascript:;">#i#</a></li></cfoutput>
																</cfif>													
														</cfloop>
														</ul>
													</div>
												</cfif>
												
												<div style="float:right;margin-right:7px;margin-bottom:15px;">
													<a href="index.cfm?event=page.clients" class="btn btn-primary"><i class="icon-search"></i> Search Again</a>  <a href="index.cfm?event=page.index" class="btn btn-secondary"><i class="icon-dashboard"></i> Go to Dashboard</a>
												</div>
										</p>

										
										
									<cfelse>
											<div class="alert alert-error">
												<button type="button" class="close" data-dismiss="alert">&times;</button>
												<strong>No records found!</strong> Sorry, your search query did not match any records in the database...
											</div>
											<p style="margin-top:20px;">
												<a href="index.cfm?event=page.clients" class="btn btn-tertiary" style="margin-right:7px;"><i class="icon-search"></i> Search Again</a>  <a href="index.cfm?event=page.index" class="btn btn-tertiary"><i class="icon-dashboard"></i> Go to Dashboard</a>
											</p>
									</cfif>
									<div class="clear"></div>
								</div> <!-- //.widget-content -->	
									
							</div> <!-- //.widget -->
							
						</div> <!-- //.span12 -->
						
					</div> <!-- //.row -->			
				
				
					<div style="height:300px;"></div>			
				
				</div> <!-- //.container -->
			
			</div> <!-- //.main -->