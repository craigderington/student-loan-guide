


			<!--- call the user gateway component to get the login history --->
			
			<cfinvoke component="apis.com.users.usergateway" method="getloginhistory" returnvariable="qloginhistory">
				<cfinvokeargument name="userid" value="#session.userid#">
			</cfinvoke>
			
			
			<!--- // show the login history --- // going to use partials --->					
					
					<div class="main">

						<div class="container">

							<div class="row">
							
								<div class="span8">
													
									<div class="widget stacked">
															
										<div class="widget-header">
											<i class="icon-calendar"></i>
											<h3><cfoutput>Login History by Date for #session.username#</cfoutput></h3>
										</div> <!-- /widget-header -->						
														
										<div class="widget-content">				
											
											<cfparam name="url.startRow" default="1" >
											<cfparam name="url.rowsPerPage" default="20" >
											<cfparam name="currentPage" default="1" >
											<cfparam name="totalPages" default="0" >
											
											<table class="table table-bordered table-striped table-highlight">
												<thead>
													<tr>
													<th>Login ID</th>
													<th>Login Date</th>
													<th>Remote Address</th>
													<th>Logged Username</th>
													</tr>
												</thead>
												<tbody>
													<cfoutput query="qloginhistory" startrow="#url.startrow#" maxrows="#url.rowsperpage#">
													<tr>
														<td>#loginid#</td>
														<td>#dateformat(logindate, "mm/dd/yyyy")# #timeformat(logindate, "hh:mm tt")#</td>
														<td>#loginip#</td>
														<td>#username#</td>
													</tr>
													</cfoutput>
												</tbody>
											</table>
											
											<!--- // 7-26-2013 // new pagination ++ page number links --->
													
											<cfset totalRecords = qloginhistory.recordcount >
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
															
										</div> <!-- /widget-content -->							
									</div><!-- /widget-->			
								</div> <!-- /span8 -->
									
									
								<div class="span4">							
									<!--- include a partial template // will be important for forms --->
									<cfinclude template="page.testcol.cfm">
								</div> <!-- /span4 -->			
							
							
							</div> <!-- /row -->
							
							<cfif qloginhistory.recordcount LTE 30>
								<div style="height:350px;"></div>
							<cfelse>
								<div style="height:150px;"></div>
							</cfif>

						</div> <!-- /container -->
						
					</div> <!-- /main -->
