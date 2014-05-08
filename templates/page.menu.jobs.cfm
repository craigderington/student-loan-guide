


			<!-- get our data component and populate table --->
			<cfinvoke component="apis.com.system.settingsgateway" method="getjobs" returnvariable="jobs1">
		
			

			
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
						
							<cfif structkeyexists(url, "msg")>						
								<div class="row">
									<div class="span12">
										<cfif url.msg is "saved">
											<div class="alert alert-info">
												<button type="button" class="close" data-dismiss="alert">&times;</button>
												<strong>Success!</strong>  The job condition was successfully updated...
											</div>
										<cfelseif url.msg is "added">
											<div class="alert">
												<button type="button" class="close" data-dismiss="alert">&times;</button>
												<strong>Success!</strong>  The new job condition was successfully added to the database...
											</div>
										<cfelseif url.msg is "deleted">
											<div class="alert alert-error">
												<button type="button" class="close" data-dismiss="alert">&times;</button>
												<strong>Success!</strong>  The job condition was successfully deleted from the system...
											</div>
										</cfif>
									</div>								
								</div>							
							</cfif>
							
							<div class="widget stacked">
								
								<div class="widget-header">		
									<i class="icon-briefcase"></i>							
									<h3>Manage Job Conditions for Student Loan Concessions</h3>					
								</div> <!-- //.widget-header -->
								
								<div class="widget-content">						
									
									<h5 style="font-weight:bold;"><cfoutput>Showing #jobs1.recordcount# Records</cfoutput></h5>
									
									<table id="myTable" class="table table-bordered table-striped table-highlight tablesorter">
										<thead>
											<tr>
												<th width="10%">Actions</th>
												<th>Job Condition</th>
												<th><div align="center">Perkins 80-87</div></th>												
												<th><div align="center">Perkins Prior 87</div></th>
												<th><div align="center">Perkins 87-93</div></th>
												<th><div align="center">Perkins After 93</div></th>
												<th><div align="center">Status</div></th>
											</tr>
										</thead>
										<tbody>
											
											<cfoutput query="jobs1">
											<tr>
												<td class="actions">														
													<!---
													<a href="javascript;" class="btn btn-small btn-warning">
														<i class="btn-icon-only icon-ok"></i>										
													</a>
													--->
													<cfif isuserinrole("admin")>
														<a href="#application.root#?event=page.menu.job.edit&jobid=#conditionuuid#" class="btn btn-small btn-primary">
															<i class="btn-icon-only icon-pencil"></i>										
														</a>
														
														<a href="#application.root#?event=page.menu.job.delete&jobid=#conditionuuid#" class="btn btn-small btn-inverse">
															<i class="btn-icon-only icon-trash"></i>										
														</a>
													</cfif>
												</td>												
												<td>#condition#</td>
												<td><cfif perkins8087 eq 1><div align="center"><span class="label label-important">X</span></div></cfif></td>
												<td><cfif perkinspre80 eq 1><div align="center"><span class="label label-inverse">X</span></div></cfif></td>
												<td><cfif perkins8793 eq 1><div align="center"><span class="label label-info">X</span></div></cfif></td>
												<td><cfif perkinsafter93 eq 1><div align="center"><span class="label label-default">X</span></div></cfif></td>
												<td><cfif active eq 1><div align="center"><span class="label label-success">ACTIVE</span><cfelse><span class="label">INACTIVE</span></div></cfif></td>
											</tr>
											</cfoutput>						
											
										</tbody>
									</table>									
									
									
									<!--- // 7-26-2013 // new pagination ++ page number links 
									<cfparam name="url.startRow" default="1" >
									<cfparam name="url.rowsPerPage" default="10" >
									<cfset totalRecords = 0 >
									<cfset totalPages = totalRecords / rowsPerPage >
									<cfset endRow = (startRow + rowsPerPage) - 1 >
									<cfparam name="currentPage" default="1" >

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
									--->

									<div class="clear"></div>
								</div> <!-- //.widget-content -->	
									
							</div> <!-- //.widget -->
							
						</div> <!-- //.span12 -->
						
					</div> <!-- //.row -->				
				
					<div style="height:200px;"></div>			
				
				</div> <!-- //.container -->
			
			</div> <!-- //.main -->