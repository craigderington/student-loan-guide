
			
			
			<!--- // report security filter --->
			<cfif not isuserinrole( "admin" ) and not isuserinrole( "co-admin" )>
				<cflocation url="#application.root#?event=page.reports&noaccess=1" addtoken="yes">
			</cfif>
			
			<!--- set default start and end date values --->
			<cfparam name="thisdate" default="">
			<cfparam name="startdate" default="">
			<cfparam name="enddate" default="">							
			<cfset thisdate = now() />
			
			<!--- set default start and end date values for our query --->
			<cfif structkeyexists( form, "filtermyresults" )>								
				<cfset startdate = createodbcdate( createdate( year( form.startdate ), month( form.startdate ), day( form.startdate ) ) ) />
				<cfset enddate = createodbcdate( createdate( year( form.enddate ), month( form.enddate ), day( form.enddate ))) />
			<cfelse>							
				<cfset startdate = createodbcdate( createdate( year( thisdate ), month( thisdate ), 1 ) ) />
				<cfset enddate = createodbcdate( createdate( year( thisdate ), month( thisdate ), daysinmonth( thisdate ))) />							
			</cfif>
			
			
			<!--- // get our data access components --->		
			
			<cfinvoke component="apis.com.reports.reportgateway" method="getimplementationreport" returnvariable="implementationreport">
				<cfinvokeargument name="companyid" value="#session.companyid#">
				<cfinvokeargument name="thisdate" value="#createodbcdatetime( now() )#" />
				<cfinvokeargument name="sdate" value="#startdate#">
				<cfinvokeargument name="edate" value="#enddate#">
			</cfinvoke>

			<cfinvoke component="apis.com.reports.reportgateway" method="getreportroles" returnvariable="reportroles">
				<cfinvokeargument name="companyid" value="#session.companyid#">
				<cfinvokeargument name="roletype" value="sls">
			</cfinvoke>
			
			
			
			
			<!--- reports css --->		
			<link href="./css/pages/reports.css" rel="stylesheet">

			
			
			<!--- // begin reports page --->			
			<div class="main">

				<div class="container">				

					<div class="row">
					
						<div class="span12">
							
							<div class="widget stacked">
								<cfoutput>
								<div class="widget-header">
									<i class="icon-globe"></i>
									<h3>Client Implementation Summary Report for #session.companyname#</h3>
								</div> <!-- /widget-header -->
								</cfoutput>
								<div class="widget-content">						
									
									
									
										<!--- // report filter 	--->							
										<cfoutput>
											<div class="well">
												<p><i class="icon-check"></i> Filter Your Results</p>
												<form class="form-inline" name="filterresults" method="post">				
													
													<select name="counselors" style="margin-left:5px;" class="input-large" onchange="javascript:this.form.submit();">
														<option value="">Filter by Advisor</option>
														<cfloop query="reportroles">
															<option value="#userid#"<cfif isdefined( "form.counselors" ) and form.counselors eq reportroles.userid>selected</cfif>>#firstname# #lastname#</option>
														</cfloop>												
													</select>
													
													<select name="showthis" style="margin-left:5px;" class="input-medium" onchange="javascript:this.form.submit();">
														<option value="false"<cfif isdefined( "form.showthis" ) and form.showthis eq "false">selected<cfelseif not isdefined( "form.showthis" )>selected</cfif>>All Records</option>
														<option value="true"<cfif isdefined( "form.showthis" ) and form.showthis eq "true">selected</cfif>>Hide Completed</option>																									
													</select>
													
													<input type="text" name="startdate" style="margin-left:5px;" class="input-medium" placeholder="Plan Start Date" id="datepicker-inline4" value="<cfif isdefined( "form.startdate" )>#dateformat( form.startdate, 'mm/dd/yyyy' )#<cfelse>#dateformat( startdate, 'mm/dd/yyyy' )#</cfif>">
													<input type="text" name="enddate" style="margin-left:5px;" class="input-medium" placeholder="Plan End Date" id="datepicker-inline5" value="<cfif isdefined( "form.enddate" )>#dateformat( form.enddate, 'mm/dd/yyyy' )#<cfelse>#dateformat( enddate, 'mm/dd/yyyy' )#</cfif>">
													<input type="hidden" name="filtermyresults">
													<button type="submit" style="margin-left:5px;" name="filtermyresults" class="btn btn-small btn-secondary"><i class="icon-search"></i> Filter Results</button>
													<cfif structkeyexists( form, "filtermyresults" )><button type="reset" onclick="location.href='#application.root#?event=#url.event#'" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-check"></i> Reset List</button></cfif>
												</form>
											</div>
										</cfoutput>
										<!--- // end filter --->		
									
										
									
									<cfif implementationreport.recordcount gt 0>
									
									
									
											<cfoutput>
												<h5><i class="icon-th-large"></i> This report found #implementationreport.recordcount# implementation plan record<cfif implementationreport.recordcount gt 1>s</cfif>      <span class="pull-right"><a href="#application.root#?event=page.reports" style="margin-bottom:5px;" class="btn btn-small btn-tertiary"><i class="icon-circle-arrow-left"></i> Reports Home</a><a href="#application.root#?event=page.reports.solutions.status" style="margin-left:5px;margin-bottom:5px;" class="btn btn-small btn-default"><i class="icon-list-alt"></i> Solution Status Report</a></span>        </h5>
											</cfoutput>
											
												<table id="tablesorter" class="table tablesorter table-bordered table-striped table-highlight">
													<thead>
														<tr>
															<th>Actions</th>
															<th>Servicer</th>
															<th>Solution</th>
															<th>Start Date</th>
															<th>Completed Date</th>
															<th>Status</th>
															<th>Plan Notes</th>															
														</tr>
													</thead>
													<tbody>
														<cfoutput query="implementationreport" group="clientname">
														<tr style="background-color:##f2f2f2;">
															<td colspan="7"><strong>#clientname# (#leadid#)</strong></td>
														</tr>											
															
															
															<!--- // show the servicer and school/loan type info --->
															<cfinvoke component="apis.com.implementation.implementgateway" method="getimplementedsolutions" returnvariable="implementedsolutions">
																<cfinvokeargument name="solutionid" value="#implementationreport.solutionid#">
															</cfinvoke>
															
																<!--- // show the grouped output --->
																<cfoutput>														
																<tr>												
																	<td>
																		<a href="#application.root#?event=page.getlead&fuseaction=leadgen&leadid=#leaduuid#&ref=page.implement" class="btn btn-mini btn-warning" target="_blank">
																			<i class="btn-icon-only icon-ok"></i>										
																		</a>
																	</td>
																	<td><cfif implementedsolutions.servicerid eq -1>#implementedsolutions.nslservicer#<cfelse>#implementedsolutions.servname#</cfif></td>
																	<td>#solutionsubcat# #solutionoption#</td>
																	<td>#dateformat( impstartdate, "mm/dd/yyyy" )# <span style="margin-left:7px;" class="label label-notice">#datediff( "d", impstartdate, now() )# Days</span></td>
																	<td><cfif impcompleted eq 1 and impenddate is not "">#dateformat( impenddate, "mm/dd/yyyy" )#<cfelse><span class="label label-inverse">In Progress</span></cfif></td>
																	<td><cfif impcompleted eq 1><span class="label label-success">Completed<cfelse><span class="label label-warning">Incomplete</span></cfif></td>
																	<td><cfif plannotes is not ""><a href="javascript:;" rel="popover" data-content="#urldecode( plannotes )#" data-original-title="Implementation Plan Notes"><i class="btn-icon-only icon-paper-clip"></i></a><cfelse>No Notes Entered</cfif></td>																	
																</tr>
																</cfoutput>
														</cfoutput>
													</tbody>
												</table>
									
									<cfelse>
									
										<h5><i class="icon-th-large"></i> No Records Found</h5>
										<div class="alert alert-block alert-error">
											<h5><strong>Sorry</strong>, the report can not find any clients matching the report input filter...</h5>
											<p><i class="icon-warning-sign"></i> That's OK!  The filter is most likely working correctly, however, no database records match your input filter. <br />  Please use the button below to reset the filters and restore the default report.</p>
											<p>&nbsp;</p>
											<cfoutput>
											<p><a href="#application.root#?event=#url.event#" class="btn btn-small btn-secondary"><i class="icon-retweet"></i> Reset Filter</a></p>
											</cfoutput>
											
										</div>
									
									</cfif>
								</div> <!-- /widget-content -->
									
							</div> <!-- / .widget -->
							
						</div> <!-- /span12 -->
					
					</div> <!-- / .row -->
					
					
					<cfif implementationreport.recordcount lt 15>
						<div style="margin-top:300px;"></div>
					<cfelse>
						<div style="margin-top:100px;"></div>
					</cfif>
					
				  
				</div> <!-- / .container -->
				
			</div> <!-- / .main -->