
			
			
			<!--- // report security filter --->
			<cfif not isuserinrole( "admin" ) and not isuserinrole( "co-admin" )>
				<cflocation url="#application.root#?event=page.reports&noaccess=1" addtoken="yes">
			</cfif>
			
			
			
			<!--- set default start and end date values --->
			<cfparam name="thisdate" default="">
			<cfparam name="startdate" default="">
			<cfparam name="enddate" default="">
			<cfparam name="achtotals" default="0.00">
			<cfparam name="achpaidtotals" default="0.00">
			<cfset thisdate = now() />
							
			<!--- set default start and end date values for our query --->
			<cfif structkeyexists( form, "filtermyresults" )>								
				<cfset startdate = createodbcdate( createdate( year( form.startdate ), month( form.startdate ), day( form.startdate ) ) ) />
				<cfset enddate = createodbcdate( createdate( year( form.enddate ), month( form.enddate ), day( form.enddate ))) />
			<cfelse>							
				<cfset startdate = createodbcdate( createdate( year( thisdate ), month( thisdate ), 1 ) ) />
				<cfset enddate = createodbcdate( createdate( year( startdate ), month( startdate ), daysinmonth( startdate ))) />							
			</cfif>	
			
			<!--- // get our data access components --->
			
			<cfinvoke component="apis.com.reports.reportgateway" method="getsolutionstatusreport" returnvariable="solutionstatusreport">
				<cfinvokeargument name="companyid" value="#session.companyid#">
				<cfinvokeargument name="thisdate" value="#createodbcdatetime( now() )#" >
				<cfinvokeargument name="sdate" value="#dateformat( startdate, "mm/dd/yyyy" )#">
				<cfinvokeargument name="edate" value="#dateformat( enddate, "mm/dd/yyyy" )#">
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
									<h3>Client Solution Status Report for #session.companyname#</h3>
								</div> <!-- /widget-header -->
								</cfoutput>
								<div class="widget-content">						
									
									
									
										<!--- // report filter 	--->							
										<cfoutput>
											<div class="well">
												<p><i class="icon-check"></i> Filter Your Results</p>
												<form class="form-inline" name="filterresults" method="post">											
													
													
													<select name="status" style="margin-left:5px;" class="input-large" onchange="javascript:this.form.submit();">
														<option value="">Filter by Status</option>														
															<option value="1"<cfif isdefined( "form.status" ) and form.status eq 1>selected</cfif>>Completed</option>
															<option value="0"<cfif isdefined( "form.status" ) and form.status eq 0>selected</cfif>>Incomplete</option>										
													</select>
													
													
													<select name="counselors" style="margin-left:5px;" class="input-large" onchange="javascript:this.form.submit();">
														<option value="">Filter by Advisor</option>
														<cfloop query="reportroles">
															<option value="#userid#"<cfif isdefined( "form.counselors" ) and form.counselors eq reportroles.userid>selected</cfif>>#firstname# #lastname#</option>
														</cfloop>												
													</select>
													
													<input type="text" name="startdate" style="margin-left:5px;" class="input-medium" placeholder="Start Date" id="datepicker-inline4" value="<cfif isdefined( "form.startdate" )>#dateformat( form.startdate, 'mm/dd/yyyy' )#<cfelse>#dateformat( startdate, 'mm/dd/yyyy' )#</cfif>">
													<input type="text" name="enddate" style="margin-left:5px;" class="input-medium" placeholder="End Date" id="datepicker-inline5" value="<cfif isdefined( "form.enddate" )>#dateformat( form.enddate, 'mm/dd/yyyy' )#<cfelse>#dateformat( enddate, 'mm/dd/yyyy' )#</cfif>">
													<input type="hidden" name="filtermyresults">
													<button type="submit" style="margin-left:5px;" name="filtermyresults" class="btn btn-small btn-secondary"><i class="icon-search"></i> Filter Results</button>
													<cfif structkeyexists( form, "filtermyresults" )><button type="reset" onclick="location.href='#application.root#?event=#url.event#'" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-check"></i> Reset List</button></cfif>
												</form>
											</div>
										</cfoutput>
										<!--- // end filter --->		
									
										
									
									<cfif solutionstatusreport.recordcount gt 0>
									
									
									
											<cfoutput>
												<h5><i class="icon-th-large"></i> This report found #solutionstatusreport.recordcount# client record<cfif solutionstatusreport.recordcount gt 1>s</cfif>      <span class="pull-right"><a href="#application.root#?event=page.reports" style="margin-bottom:5px;" class="btn btn-small btn-tertiary"><i class="icon-circle-arrow-left"></i> Reports Home</a><a href="#application.root#?event=page.reports.solutions" style="margin-left:5px;margin-bottom:5px;" class="btn btn-small btn-default"><i class="icon-list-alt"></i> Solution Summary Report</a></span>        </h5>
											</cfoutput>
											
												<table class="table table-bordered table-striped table-highlight">
													<thead>
														<tr>
															<th width="6%">Actions</th>																									
															<th width="15%">Name</th>
															<th width="10%">Contact</th>
															<th>Email/Text</th>																																
															<th width="10%">Advisor</th>
															<th>Solution Date</th>
															<th>Status</th>
															<th>Servicer</th>
															<th>Attending School</th>
															<th>Solution Cart</th>
														</tr>
													</thead>
													<tbody>
														<cfoutput query="solutionstatusreport">								
															
															<cfinvoke component="apis.udfs.cleanphonenumber" method="formatphonenumber" returnvariable="phonenumber">
																<cfinvokeargument name="phonenumber" value="#leadphonenumber#">
															</cfinvoke>													
																<tr>
																	<td class="actions">
																		<a title="Select Record" href="#application.root#?event=page.getlead&fuseaction=leadgen&leadid=#leaduuid#" class="btn btn-mini btn-warning" target="_blank">
																			<i class="btn-icon-only icon-ok"></i>										
																		</a>																
																	</td>																														
																	<td>#leadfirst# #leadlast# (#leadid#)</td>
																	<td>#phonenumber#</td>
																	<td><a href="#application.root#?event=page.getlead&fuseaction=leadgen&leadid=#leaduuid#&ref=page.email" target="_blank" style="margin-left:3px;"><i class="btn-icon-only icon-envelope"></i></a>  <a href="#application.root#?event=page.getlead&fuseaction=leadgen&leadid=#leaduuid#&ref=page.txtmsg" target="_blank" style="margin-left:3px;"><i class="btn-icon-only icon-phone"></i></a></td>
																	<td>#sladvisorfirst# #sladvisorlast#</td>
																	<td>#dateformat( solutiondate, "mm/dd/yyyy" )#</td>
																	<td><cfif solutioncompleted eq 1><span class="label label-success">Completed</span><cfelse><span class="label label-important">Incomplete</span></cfif></td>
																	<td><cfif servicerid eq -1>#nslservicer#<cfelse>#servname#</cfif></td>
																	<td>#attendingschool#</td>
																	<td><a href="#application.root#?event=page.getlead&fuseaction=leadgen&leadid=#leaduuid#&ref=page.solution" target="_blank" style="margin-left:3px;"><i class="btn-icon-only icon-shopping-cart"></i></a></td>
																</tr>
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
					
					
					<cfif solutionstatusreport.recordcount lt 15>
						<div style="margin-top:425px;"></div>
					<cfelse>
						<div style="margin-top:100px;"></div>
					</cfif>
					
				  
				</div> <!-- / .container -->
				
			</div> <!-- / .main -->