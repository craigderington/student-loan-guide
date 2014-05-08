

		<!--- // Loan Servicers Administration --->
		<cfinvoke component="apis.com.system.servicers" method="getservicers" returnvariable="servicerlist">
		
		
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
												<strong>Success!</strong>  The loan servicer details were successfully updated...
											</div>
										<cfelseif url.msg is "added">
											<div class="alert">
												<button type="button" class="close" data-dismiss="alert">&times;</button>
												<strong>Success!</strong>  The new servicer was successfully added to the loan servicer database...
											</div>
										<cfelseif url.msg is "deleted">
											<div class="alert alert-error">
												<button type="button" class="close" data-dismiss="alert">&times;</button>
												<strong>Success!</strong>  The loan servicer was successfully deleted from the system...
											</div>
										</cfif>
									</div>								
								</div>							
							</cfif>						
							
							<div class="widget stacked">
								
								<div class="widget-header">		
									<i class="icon-book"></i>							
									<h3>Manage Loan Servicers</h3>						
								</div> <!-- //.widget-header -->
								
								<div class="widget-content">
						
									<!--- // begin form processing --->
									<cfif isDefined("form.fieldnames")>
										<cfscript>
											objValidation = createObject("component","apis.com.ui.validation").init();
											objValidation.setFields(form);
											objValidation.validate();
										</cfscript>

										<cfif objValidation.getErrorCount() is 0>							
											
																					
																						
											<!--- // some other variables --->
											<cfset today = #CreateODBCDateTime(now())# />											
																						
											<!--- // create the database record --->
											<cfquery datasource="#application.dsn#" name="savemasterstep">
												
											</cfquery>											
											
											<!--- // log the activity --->
											<cfquery datasource="#application.dsn#" name="logact">
												insert into activity(leadid, userid, activitydate, activitytype, activity)
													values (
															<cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
															<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#session.username# updated master implementation step #step.stepcat#" cfsqltype="cf_sql_varchar" />
															);
											</cfquery>																					
											
											<cflocation url="#application.root#?event=#url.event#&msg=saved" addtoken="no">
								
										<!--- If the required data is missing - throw the validation error --->
										<cfelse>
										
											<div class="alert alert-error">
												<a class="close" data-dismiss="alert">&times;</a>
													<h5><error>There were <cfoutput>#objValidation.getErrorCount()#</cfoutput> errors in your submission:</error></h2>
													<ul>
														<cfloop collection="#variables.objValidation.getMessages()#" item="rr">
															<li class="formerror"><cfoutput>#variables.objValidation.getMessage(rr)#</cfoutput></li>
														</cfloop>
													</ul>
											</div>				
										
										</cfif>										
										
									</cfif>
									<!-- // end form processing --->























								
									
									<cfif not structkeyexists(form, "search")>
									<h5>Search Loan Servicers</h5>
									<div class="faq-container">
										<cfoutput>
											<form class="faq-search" name="searchservicers" method="post" action="#application.root#?event=page.menu.servicers">
												<input type="text" name="search" placeholder="Search by Loan Servicer Name " class="input-xlarge span6" style="padding:15px;"> <input type="submit" class="btn btn-large btn-primary span3" name="searchserv" value="Search Loan Servicers" style="padding:15px;margin-top:-10px;margin-left:10px;font-weight:bold"> <a href="#application.root#?event=page.menu.servicer.add" class="btn btn-large btn-secondary" style="padding:15px;margin-top:-10px;margin-left:5px;font-weight:bold"><i class="icon-plus-sign"></i> Add New Loan Servicer</a>
											</form>
										</cfoutput>
									</div>	
									
									
									<br />
									</cfif>
									
									
									<cfif not structkeyexists(form, "search")>
										<cfparam name="url.startRow" default="1" >
										<cfparam name="url.rowsPerPage" default="10" >
										<cfparam name="currentPage" default="1" >
										<cfparam name="totalPages" default="0" >
									
										
										<cfoutput>
										<p>
											<strong>Loan Servicer List &raquo; Found #servicerlist.recordcount# Loan Servicer Records </strong>
										</p>
										</cfoutput>
										
										
										<table class="table table-bordered table-striped table-highlight">
											<thead>
												<tr>
													<th width="15%">Actions</th>
													<th>Servicer Type</th>
													<th>Servicer Name</th>
													<th>City</th>
													<th>State</th>
													<th>Phone</th>
													<th>Email</th>
												</tr>
											</thead>
											
											<tbody>
												<cfoutput query="servicerlist" startrow="#url.startrow#" maxrows="#url.rowsperpage#">
													<cfinvoke component="apis.udfs.cleanphonenumber" method="formatphonenumber" returnvariable="phonenumber">
														<cfinvokeargument name="phonenumber" value="#servicerlist.servphone#">
													</cfinvoke>
													<tr>														
														<td class="actions">
															
																<a href="#application.root#?event=page.menu.servicer.detail&srvid=#servid#" class="btn btn-small btn-warning">
																	<i class="btn-icon-only icon-ok"></i>										
																</a>
																<cfif isuserinrole("admin")>
																<a href="#application.root#?event=page.menu.servicer.edit&srvid=#servid#" class="btn btn-small">
																	<i class="btn-icon-only icon-pencil"></i>										
																</a>
																
																<a href="#application.root#?event=page.menu.servicer.delete&srvid=#servid#" class="btn btn-small btn-inverse">
																	<i class="btn-icon-only icon-trash"></i>										
																</a>
																</cfif>
														</td>														
														<td>#servtype#</td>
														<td>#servname#</td>
														<td>#servcity#</td>
														<td>#servstate#</td>
														<td><span class="label label-inverse">#phonenumber#</span></td>
														<td>#servemail#</td>
													</tr>
													</cfoutput>
											</tbody>
										</table>
													
										<!--- // 7-26-2013 // new pagination ++ page number links --->
													
											<cfset totalRecords = servicerlist.recordcount >
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
											
									</cfif>
									
									
									<cfif structkeyexists(form, "search")>
										<cfinvoke component="apis.com.system.servicers" method="searchservicers" returnvariable="servlist">
											<cfinvokeargument name="searchphrase" value="#form.search#">
										</cfinvoke>
										
										<cfif servlist.recordcount gt 0>
										
											<p>
												<h5><strong>Search Results.  Your query found <cfoutput>#servlist.recordcount#</cfoutput> records matching your input...</strong></h5>
											</p>
											
											<table class="table table-bordered table-striped table-highlight">
												<thead>
													<tr>
														<cfif isuserinrole("admin")><th width="15%">Actions</th></cfif>
														<th>Servicer Type</th>
														<th>Servicer Name</th>
														<th>City</th>
														<th>State</th>
														<th>Phone</th>
														<th>Email</th>
													</tr>
												</thead>
												
												<tbody>
													<cfoutput query="servlist">
														<cfinvoke component="apis.udfs.cleanphonenumber" method="formatphonenumber2" returnvariable="phonenumber2">
															<cfinvokeargument name="phonenumber2" value="#servlist.servphone#">
														</cfinvoke>
														<tr>
															<cfif isuserinrole("admin")>
															<td class="actions">
																
																	<a href="#application.root#?event=page.menu.servicer.detail&srvid=#servid#" class="btn btn-small btn-warning">
																		<i class="btn-icon-only icon-ok"></i>										
																	</a>
																	
																	<a href="#application.root#?event=page.menu.servicer.edit&srvid=#servid#" class="btn btn-small">
																		<i class="btn-icon-only icon-pencil"></i>										
																	</a>
																	
																	<a href="#application.root#?event=page.menu.servicer.delete&srvid=#servid#" class="btn btn-small btn-inverse">
																		<i class="btn-icon-only icon-trash"></i>										
																	</a>
																	
															</td>
															</cfif>
															<td>#servtype#</td>
															<td>#servname#</td>
															<td>#servcity#</td>
															<td>#servstate#</td>
															<td><span class="label label-inverse">#phonenumber2#</span></td>
															<td>#servemail#</td>
														</tr>						
													</cfoutput>											
												</tbody>
											</table>
										
										<cfelse>
											
											<p>
												<div class="alert alert-error">
													<button type="button" class="close" data-dismiss="alert">&times;</button>
													<strong>No records found!</strong> Sorry, your search query did not match any records in the database...
												</div>
											</p>
										
										</cfif>
											
											<cfoutput>
												<p style="margin-top:20px;">
													<a href="#application.root#?event=page.menu.servicers" class="btn btn-secondary" style="margin-right:7px;"><i class="icon-search"></i> Search Again</a>  <a href="#application.root#?event=page.menu" class="btn btn-primary"><i class="icon-picture"></i> Menu Data</a>
												</p>
											</cfoutput>
									</cfif>
									
									<!--- // clear the last div --->
									<div class="clear"></div>
								
								
								</div> <!-- //.widget-content -->	
									
							</div> <!-- //.widget -->
							
						</div> <!-- //.span12 -->
						
					</div> <!-- //.row -->			
				
				
					<div style="height:100px;"></div>			
				
				</div> <!-- //.container -->
			
			</div> <!-- //.main -->