


		
			<!--- // get our data access components --->

			
			<cfinvoke component="apis.com.system.activitylog" method="getcompanyuseractivity" returnvariable="companyuseractivity">
				<cfinvokeargument name="companyid" value="#session.companyid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.admin.useradmingateway" method="getusers" returnvariable="userlist">
				<cfinvokeargument name="companyid" value="#session.companyid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.clients.clientgateway" method="getclientlist" returnvariable="clientlist">
				<cfinvokeargument name="companyid" value="#session.companyid#">
				<cfinvokeargument name="userid" value="#session.userid#">				
			</cfinvoke>

			<!--- // side bar stats data --->
			<cfinvoke component="apis.com.admin.admindashboard" method="getreportdashboard" returnvariable="reportdashboard">
				<cfinvokeargument name="companyid" value="#session.companyid#">
				<cfinvokeargument name="userid" value="#session.userid#">
			</cfinvoke>
			
			












					<!--- // system activity log --->
					<div class="main">
					
						<div class="container">
						
							<div class="row">
								
								<div class="span12">
								
									<div class="widget stacked">
										<cfoutput>
										<div class="widget-header">
											<i class="icon-cogs"></i>
											<h3>Company Activity Log for #session.companyname#</h3>
										</div>
										</cfoutput>
										
										<div class="widget-content">
											
											<!--- // report filter --->									
											<cfoutput>
												<div class="well">
													<p><i class="icon-check"></i> Filter Your Results</p>
													<form class="form-inline" name="filterresults" method="post">																				
														
														<select name="leadid" style="margin-left:5px;" class="input-large" onchange="javascript:this.form.submit();">
															<option value="">Filter By Client Name</option>
																<cfloop query="clientlist">
																	<option value="#leadid#"<cfif isdefined( "form.leadid" ) and form.leadid eq clientlist.leadid>selected</cfif>>#leadfirst# #leadlast#</option>
																</cfloop>												
														</select>

														<select name="thisuser" style="margin-left:5px;" class="input-large" onchange="javascript:this.form.submit();">
															<option value="">Select Activity User</option>
																<cfloop query="userlist">
																	<option value="#userid#"<cfif isdefined( "form.thisuser" ) and form.thisuser eq userlist.userid>selected</cfif>>#firstname# #lastname#</option>
																</cfloop>												
														</select>				
														<input type="text" name="filterstartdate" style="margin-left:5px;" class="input-medium" placeholder="Select Start Date" id="datepicker-inline4" value="<cfif isdefined( "form.filterstartdate" )>#dateformat( form.filterstartdate, 'mm/dd/yyyy' )#</cfif>">
														<input type="text" name="filterenddate" style="margin-left:5px;" class="input-medium" placeholder="Select End Filter" id="datepicker-inline5" value="<cfif isdefined( "form.filterenddate" )>#dateformat( form.filterenddate, 'mm/dd/yyyy' )#</cfif>">		
														<input type="hidden" name="filtermyresults">
														<button type="submit" style="margin-left:5px;" name="filterresults" class="btn btn-small btn-secondary"><i class="icon-search"></i> Filter Results</button>
														<cfif structkeyexists( form, "filtermyresults" )><button type="reset" onclick="location.href='#application.root#?event=#url.event#'" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-check"></i> Reset List</button></cfif>
													</form>
												</div>
											</cfoutput>
											<!--- // end filter --->
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											<cfif companyuseractivity.recordcount gt 0>
											
												<!--- activity log pagination --->
												<cfparam name="startrow" default="1">
												<cfparam name="displayrows" default="100">
												<cfparam name="torow" default="0">												
												
												<cfset torow = startrow + ( displayrows - 1 ) />
												<cfif torow gt companyuseractivity.recordcount>
													<cfset torow = companyuseractivity.recordcount />
												</cfif>												
												
												<cfset next = startrow + displayrows>
												<cfset prev = startrow - displayrows>				
												
												
												<h5><i class="icon-th-large"></i> <cfoutput>#companyuseractivity.recordcount# records found.  Displaying #startrow# to #torow#.</cfoutput>    <span class="pull-right"><cfoutput> <cfif prev gte 1><a style="margin-left:5px;" href="#application.root#?event=#url.event#&startrow=#prev#" class="btn btn-small btn-secondary"><i class="icon-circle-arrow-left"></i> Previous #displayrows# Records</a></cfif><cfif next lte companyuseractivity.recordcount><a style="margin-left:7px;" class="btn btn-small btn-default" href="#application.root#?event=#url.event#&startrow=#next#">Next <cfif( companyuseractivity.recordcount - next ) lt displayrows>#evaluate(( companyuseractivity.recordcount - next ) + 1 )#<cfelse>#displayrows#</cfif> Records <i class="icon-circle-arrow-right"></i></cfif></a><a href="#application.root#?event=page.admin" style="margin-left:5px;" class="btn btn-small btn-tertiary"><i class="icon-home"></i> Admin Home</a></cfoutput></span></h5>									
												
												<table class="table table-bordered table-striped">
													<thead>
														<tr>												
															<th width="5%">ID</th>
															<th width="15%">Date</th>
															<th width="12%">Client Name</th>
															<th>Activity</th>												
														</tr>
													</thead>
													<tbody>
														<cfoutput query="companyuseractivity" startrow="#startrow#" maxrows="#displayrows#">
															<tr>												
																<td>#activityid#</td>
																<td>#dateformat( activitydate, "mm/dd/yyyy" )# at #timeformat( activitydate, "hh:mm tt" )#</td>
																<td>#leadfirst# #leadlast#</td>
																<td>#activity#
															</tr>
														</cfoutput>											
													</tbody>
												</table>											
											
											<cfelse>
											
											
												<div class="alert alert-block alert-info">
													<button type="button" class="close" data-dismiss="alert">&times;</button>
													<h3><i style="font-weight:bold;" class="icon-warning-sign"></i>WARNING!</h3>
													<p>Sorry, the system can not find any activity records...</p>
												</div>										
											
											</cfif>
											
											
											
											
											
										</div><!-- / .widget-content -->
									
									</div><!-- / .widget -->
								
								</div><!-- / .span12 -->							
								
							</div><!-- / .row -->
							
							<cfif companyuseractivity.recordcount lt 10>
								<div style="margin-top:300px;"></div>
							<cfelse>
								<div style="margin-top:100px;"></div>
							</cfif>
							
						
						</div><!-- / .container -->
					
					</div><!-- / .main -->
			
			