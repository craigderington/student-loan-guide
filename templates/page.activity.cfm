

			
			<!--- // redirect if the lead sessionis undefined --->
			<cfif not structkeyexists( session, "leadid" )>
				<cflocation url="#application.root#?event=page.leads" addtoken="yes">				
			</cfif>
			
			
			<!--- get our data components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>			
			
			<cfinvoke component="apis.com.leads.leadgateway" method="getleadactivity" returnvariable="leadact">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			


			<!--- lead summary page --->
			
			
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
						
							<div class="widget stacked">
								<cfoutput>	
								<div class="widget-header">		
									<i class="icon-calendar"></i>							
									<h3>Activity Log for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
								</div> <!-- //.widget-header -->
								</cfoutput>	
							
								<div class="widget-content">
								
												
								
										<!--- // include the side bar nav --->
										<div class="span3">					
											<cfinclude template="page.sidebar.nav.cfm">		
										</div> <!-- /.span3 -->
			
			
										<div class="span8">
											
											<div class="tab-content">
												
												<div class="tab-pane active" id="tab1">
													
													<h3><i class="icon-calendar"></i> Activity Log</h3>
													
													<p>The following table displays all enrollment activity for the selected client.  Please use the data below for historical analysis of the client's progress through the enrollment process.  Additional activity will be tracked as the client begings the advisory services and student loan repayment options and solutions.</p>
													
													<br>
													
													<cfif leadact.recordcount gt 0>
														<cfparam name="url.startRow" default="1" >
														<cfparam name="url.rowsPerPage" default="20" >
														<cfparam name="currentPage" default="1" >
														<cfparam name="totalPages" default="0" >
															<table class="table table-bordered table-striped table-highlight">
																<thead>
																	<tr>
																		<th width="10%">Date</th>
																		<th>Type</th>																		
																		<th>Activity</th>																	
																	</tr>
																</thead>
																<tbody>																		
																	<cfoutput query="leadact" startrow="#url.startrow#" maxrows="#url.rowsperpage#">
																	<tr>
																		<td>#dateformat(activitydate, "mm/dd/yyyy")#</td>																	
																		<td>#activitytype#</td>																		
																		<td>#activity#</td>																	
																	</tr>		
																	</cfoutput>											
																</tbody>
															</table>
															
															
															
															<!--- // 7-26-2013 // new pagination ++ page number links --->
													
															<cfset totalRecords = leadact.recordcount >
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
															
													<cfelse>
														<div class="row">
															<div class="span8">										
																<div class="alert alert-error">
																	<button type="button" class="close" data-dismiss="alert">&times;</button>
																	<strong>NO RECORDS FOUND!</strong>  Sorry, there is no recorded activity for the selected client record.  Please use the navigation sidebar to continue...
																</div>										
															</div>								
														</div>
													</cfif>
																	
												</div> <!-- /#tab1 -->										 
											
											</div> <!-- /.tab-content -->
											
										</div> <!-- /.span8 -->
			
									
					
								</div> <!-- /. widget-content -->
							
							</div> <!-- /. widget-stacked -->
						
						</div><!-- / .span12 -->
					
					</div> <!-- / .row -->
				
				</div> <!-- / .container -->
			
			</div> <!-- / .main -->
		
		
		