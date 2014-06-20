
			
			
			<!--- // report security filter --->
			<cfif not isuserinrole( "admin" ) and not isuserinrole( "co-admin" )>
				<cflocation url="#application.root#?event=page.reports&noaccess=1" addtoken="yes">
			</cfif>
			
			<!--- // get our data access components --->		
			
			<cfinvoke component="apis.com.reports.reportgateway" method="getsolutionreport" returnvariable="solutionreport">
				<cfinvokeargument name="companyid" value="#session.companyid#">
				<cfinvokeargument name="thisdate" value="#createodbcdatetime( now() )#" />
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
									<h3>Client Solution Summary Report for #session.companyname#</h3>
								</div> <!-- /widget-header -->
								</cfoutput>
								<div class="widget-content">						
									
									
									
										<!--- // report filter 	--->							
										<cfoutput>
											<div class="well">
												<p><i class="icon-check"></i> Filter Your Results</p>
												<form class="form-inline" name="filterresults" method="post">											
													
													<!---
													<select name="status" style="margin-left:5px;" class="input-xlarge" onchange="javascript:this.form.submit();">
														<option value="">Filter by Status</option>														
															<option value="1"<cfif isdefined( "form.status" ) and form.status eq 1>selected</cfif>>Completed</option>
															<option value="0"<cfif isdefined( "form.status" ) and form.status eq 1>selected</cfif>>Incomplete</option>										
													</select>
													--->
													
													<select name="counselors" style="margin-left:5px;" class="input-xlarge" onchange="javascript:this.form.submit();">
														<option value="">Filter by Advisor</option>
														<cfloop query="reportroles">
															<option value="#userid#"<cfif isdefined( "form.counselors" ) and form.counselors eq reportroles.userid>selected</cfif>>#firstname# #lastname#</option>
														</cfloop>												
													</select>
													
													<input type="text" name="startdate" style="margin-left:5px;" class="input-medium" placeholder="Start Date" id="datepicker-inline4" value="<cfif isdefined( "form.startdate" )>#dateformat( form.startdate, 'mm/dd/yyyy' )#</cfif>">
													<input type="text" name="enddate" style="margin-left:5px;" class="input-medium" placeholder="End Date" id="datepicker-inline5" value="<cfif isdefined( "form.enddate" )>#dateformat( form.enddate, 'mm/dd/yyyy' )#</cfif>">
													<input type="hidden" name="filtermyresults">
													<button type="submit" style="margin-left:5px;" name="filtermyresults" class="btn btn-small btn-secondary"><i class="icon-search"></i> Filter Results</button>
													<cfif structkeyexists( form, "filtermyresults" )><button type="reset" onclick="location.href='#application.root#?event=#url.event#'" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-check"></i> Reset List</button></cfif>
												</form>
											</div>
										</cfoutput>
										<!--- // end filter --->		
									
										
									
									<cfif solutionreport.recordcount gt 0>
									
									
									
											<cfoutput>
												<h5><i class="icon-th-large"></i> This report found #solutionreport.recordcount# client record<cfif solutionreport.recordcount gt 1>s</cfif>      <span class="pull-right"><a href="#application.root#?event=page.reports" style="margin-bottom:5px;" class="btn btn-small btn-tertiary"><i class="icon-circle-arrow-left"></i> Reports Home</a><a href="#application.root#?event=page.reports.solutions.status" style="margin-left:5px;margin-bottom:5px;" class="btn btn-small btn-default"><i class="icon-list-alt"></i> Solution Status Report</a></span>        </h5>
											</cfoutput>
											
												<table class="table table-bordered table-striped table-highlight">
													<thead>
														<tr>
															<th width="6%">Actions</th>																									
															<th>Name</th>
															<th>Contact</th>
															<th>Email/Text</th>																																
															<th>Advisor</th>
															<th>Date Assigned</th>
															<th>Debts/Solutions</th>
															<th>Last Note</th>
															<th>Option Tree</th>
														</tr>
													</thead>
													<tbody>
														<cfoutput query="solutionreport">								
															
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
																	<td>#sladvisorfirst# #sladvisorlast#  <cfif leadassignacceptdate is ""><a style="margin-left:3px;" title="Transfer Advisor" href="javascript:;" onclick="window.open('templates/page.transfer.advisor.cfm?leadid=#leaduuid#&role=sls','','scrollbars=yes,width=840,height=540');"><i class="btn-icon-only icon-refresh"></i></a></cfif></td>
																	<td>#dateformat( leadassigndate, "mm/dd/yyyy" )#</td>
																	<td><cfif ( totaldebts eq totalsolutions ) and totalsolutions neq 0><span class="label label-success">#totaldebts# / #totalsolutions#</span><cfelseif totaldebts gt totalsolutions><span class="label label-important">#totaldebts# / #totalsolutions#</span></cfif></td>
																	<td><cfif lastnotedate is not "">#dateformat( lastnotedate, "mm/dd/yyyy" )#<cfif lastnotetext is not "">&nbsp;&nbsp;<a href="javascript:;" rel="popover" data-content="#urldecode( lastnotetext )#" data-original-title="#leadfirst# #leadlast#'s Last Note"><i class="btn-icon-only icon-paper-clip"></i></a></cfif><cfelse>NO NOTES</cfif></td>
																	<td><a href="#application.root#?event=page.getlead&fuseaction=leadgen&leadid=#leaduuid#&ref=page.tree" target="_blank" style="margin-left:3px;"><i class="btn-icon-only icon-sitemap"></i></a></td>
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
					
					
					<cfif solutionreport.recordcount lt 15>
						<div style="margin-top:425px;"></div>
					<cfelse>
						<div style="margin-top:100px;"></div>
					</cfif>
					
				  
				</div> <!-- / .container -->
				
			</div> <!-- / .main -->