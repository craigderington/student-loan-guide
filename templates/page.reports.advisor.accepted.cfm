
			
			
			<!--- // report security filter --->
			<cfif not isuserinrole( "admin" ) and not isuserinrole( "co-admin" )>
				<cflocation url="#application.root#?event=page.reports&noaccess=1" addtoken="yes">
			</cfif>
			
			<!--- // get our data access components --->		
			
			<cfinvoke component="apis.com.reports.reportgateway" method="getadvisoracceptedreport" returnvariable="advisoracceptedreport">
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
									<h3>Advisor Cases Waiting Acceptance Report for #session.companyname#</h3>
								</div> <!-- /widget-header -->
								</cfoutput>
								<div class="widget-content">						
									
									<cfif advisoracceptedreport.recordcount gt 0>
									
										<!--- // report filter 	--->							
										<cfoutput>
											<div class="well">
												<p><i class="icon-check"></i> Filter Your Results</p>
												<form class="form-inline" name="filterresults" method="post">												
													<label class="radio">
														<input style="margin-left:5px;" name="rgaccept" type="radio" value="0" <cfif isdefined( "form.rgaccept" ) and trim( form.rgaccept ) is "0">checked</cfif> <cfif not isdefined( "form.rgaccept" )>checked</cfif> onclick="javascript:this.form.submit();" /> <strong>Not Accepted (Default)</strong>
													</label>
													<label class="radio">
														<input style="margin-left:5px;" name="rgaccept" type="radio" value="1" <cfif isdefined( "form.rgaccept" ) and trim( form.rgaccept ) is "1">checked</cfif> onclick="javascript:this.form.submit();" /> <strong>Accepted</strong>
													</label>
													
													<select name="counselors" style="margin-left:5px;" class="input-xlarge" onchange="javascript:this.form.submit();">
														<option value="">Select Advisor</option>
														<cfloop query="reportroles">
															<option value="#userid#"<cfif isdefined( "form.counselors" ) and form.counselors eq reportroles.userid>selected</cfif>>#firstname# #lastname#</option>
														</cfloop>												
													</select>
													
													<input type="text" name="filterdate" style="margin-left:5px;" class="input-medium" placeholder="Select Date Filter" id="datepicker-inline4" value="<cfif isdefined( "form.filterdate" )>#dateformat( form.filterdate, 'mm/dd/yyyy' )#</cfif>">		
													<input type="hidden" name="filtermyresults">
													<button type="submit" style="margin-left:5px;" name="filterresults" class="btn btn-small btn-secondary"><i class="icon-search"></i> Filter Results</button>
													<cfif structkeyexists( form, "filtermyresults" )><button type="reset" onclick="location.href='#application.root#?event=#url.event#'" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-check"></i> Reset List</button></cfif>
												</form>
											</div>
										</cfoutput>
										<!--- // end filter --->		
									
										
									
									
									
									
									
									<cfoutput>
										<h5><i class="icon-th-large"></i> This report found #advisoracceptedreport.recordcount# client record<cfif advisoracceptedreport.recordcount gt 1>s</cfif>      <span class="pull-right"><a href="#application.root#?event=page.reports" style="margin-bottom:5px;" class="btn btn-small btn-tertiary"><i class="icon-circle-arrow-left"></i> Reports Home</a><a href="#application.root#?event=page.reports.advisor.completed" style="margin-left:5px;margin-bottom:5px;" class="btn btn-small btn-default"><i class="icon-list-alt"></i> Completed Advisory Cases</a></span>        </h5>
									</cfoutput>
									
										<table class="table table-bordered table-striped table-highlight">
											<thead>
												<tr>
													<th width="6%">Actions</th>																									
													<th>Name</th>
													<th>Contact</th>																										
													<th>Intake Completed</th>
													<th>Intake Advisor</th>													
													<th>Student Loan Advisor</th>
													<th>Accept Status</th>
													<th>Last Note</th>
													<th>Email/Text</th>
												</tr>
											</thead>
											<tbody>
												<cfoutput query="advisoracceptedreport">								
													
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
															<td>#dateformat( leadintakecompdate, "mm/dd/yyyy" )#</td>
															<td>#intakeadvisorname#</td>
															<td>#sladvisorfirst# #sladvisorlast#  <cfif leadassignacceptdate is ""><a style="margin-left:3px;" title="Transfer Advisor" href="javascript:;" onclick="window.open('templates/page.transfer.advisor.cfm?leadid=#leaduuid#&role=sls','','scrollbars=yes,width=500,height=500');"><i class="btn-icon-only icon-refresh"></i></a></cfif></td>
															<td><cfif leadassignacceptdate is not ""><span class="label label-success">ACCEPTED</span> <span style="margin-left:3px;" class="label label-info">#datediff( "d", leadassigndate, leadassignacceptdate )# day<cfif datediff( "d", leadassigndate, leadassignacceptdate ) gt 1>s</cfif></span><cfelse><span class="label label-important">NOT ACCEPTED</span> <span style="margin-left:3px;" class="label label-info">#datediff( "d", leadassigndate, now() )# day<cfif datediff( "d", leadassigndate, now() ) gt 1>s</cfif></span></cfif></td>
															<td><cfif lastnotedate is not "">#dateformat( lastnotedate, "mm/dd/yyyy" )#<cfif lastnotetext is not "">&nbsp;&nbsp;<a href="javascript:;" rel="popover" data-content="#urldecode( lastnotetext )#" data-original-title="#leadfirst# #leadlast#'s Last Note"><i class="btn-icon-only icon-paper-clip"></i></a></cfif><cfelse>NO NOTES</cfif></td>
															<td><a href="#application.root#?event=page.getlead&fuseaction=leadgen&leadid=#leaduuid#&ref=page.email" target="_blank" style="margin-left:3px;"><i class="btn-icon-only icon-envelope"></i></a>  <a href="#application.root#?event=page.getlead&fuseaction=leadgen&leadid=#leaduuid#&ref=page.txtmsg" target="_blank" style="margin-left:3px;"><i class="btn-icon-only icon-phone"></i></a></td>
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
					
					
					<cfif advisoracceptedreport.recordcount lt 15>
						<div style="margin-top:425px;"></div>
					<cfelse>
						<div style="margin-top:100px;"></div>
					</cfif>
					
				  
				</div> <!-- / .container -->
				
			</div> <!-- / .main -->