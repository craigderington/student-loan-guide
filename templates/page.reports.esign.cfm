
			
			
			<!--- // report security filter 
			<cfif not isuserinrole( "admin" ) and not isuserinrole( "co-admin" )>
				<cflocation url="#application.root#?event=page.reports&noaccess=1" addtoken="yes">
			</cfif>
			--->
			
			<!--- // get our data access components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleadsources" returnvariable="leadsources">
				<cfinvokeargument name="companyid" value="#session.companyid#">				
			</cfinvoke>
			
			<cfinvoke component="apis.com.reports.reportgateway" method="getcounselorlist" returnvariable="counselorlist">
				<cfinvokeargument name="companyid" value="#session.companyid#">			
			</cfinvoke>			
			
			<cfinvoke component="apis.com.reports.reportgateway" method="getesignreport" returnvariable="esignreport">
				<cfinvokeargument name="companyid" value="#session.companyid#">
				<cfinvokeargument name="userid" value="#session.userid#">
				<cfinvokeargument name="thisdate" value="#createodbcdatetime( now() )#" />
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
									<h3>Clients E-Sign Follow Up Report for #session.companyname#</h3>
								</div> <!-- /widget-header -->
								</cfoutput>
								
								<div class="widget-content">						
									
									
									<!--- // report filter --->							
									<cfoutput>
										<div class="well">
											<p><i class="icon-check"></i> Filter Your Results</p>
											<form class="form-inline" name="filterresults" method="post">																				
													
													<select name="leadsource" style="margin-left:5px;" class="input-large" onchange="javascript:this.form.submit();">
														<option value="">Select Lead Source</option>
															<cfloop query="leadsources">
																<option value="#leadsourceid#"<cfif isdefined( "form.leadsource" ) and form.leadsource eq leadsources.leadsourceid>selected</cfif>>#leadsource#</option>
															</cfloop>												
													</select>
													
													<cfif not isuserinrole( "counselor" )>
														<select name="counselors" style="margin-left:5px;" class="input-large" onchange="javascript:this.form.submit();">
															<option value="">Select Counselor</option>
																<cfloop query="counselorlist">
																	<option value="#userid#"<cfif isdefined( "form.counselors" ) and form.counselors eq counselorlist.userid>selected</cfif>>#firstname# #lastname#</option>
																</cfloop>												
														</select>
													</cfif>
													
													<input type="text" name="startdate" style="margin-left:5px;" class="input-medium" placeholder="Start Date" id="datepicker-inline4" value="<cfif isdefined( "form.startdate" )>#dateformat( form.startdate, 'mm/dd/yyyy' )#</cfif>">
													<input type="text" name="enddate" style="margin-left:5px;" class="input-medium" placeholder="End Date" id="datepicker-inline5" value="<cfif isdefined( "form.enddate" )>#dateformat( form.enddate, 'mm/dd/yyyy' )#</cfif>">
													<input type="hidden" name="filtermyresults">
													<button type="submit" style="margin-left:5px;" name="filterresults" class="btn btn-small btn-secondary"><i class="icon-search"></i> Filter Results</button>
													<cfif structkeyexists( form, "filtermyresults" )><button type="reset" onclick="location.href='#application.root#?event=#url.event#'" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-check"></i> Reset List</button></cfif>
													<br /><br />												
													<span style="margin-top:10px;font-weight:bold;font-size:14px;">E-Sign Status Filter: <input style="margin-left:5px;" name="rgstat" value="1" type="radio" onclick="javascript:this.form.submit();" <cfif isdefined( "form.rgstat" ) and form.rgstat eq 1>checked</cfif>> Complete &nbsp;<input style="margin-left:5px;" name="rgstat" value="0" type="radio" onclick="javascript:this.form.submit();" <cfif isdefined( "form.rgstat" ) and form.rgstat eq 0>checked</cfif>> Incomplete</span> 
													
												</form>
										</div>
									</cfoutput>
									<!--- // end filter --->
									
									
									
									
									
									
									
									
									<cfif esignreport.recordcount gt 0>				
									
									<cfoutput>
										<h5><i class="icon-th-large"></i> This report found #esignreport.recordcount# client record<cfif esignreport.recordcount gt 1>s</cfif>     <span class="pull-right"><a href="#application.root#?event=page.reports" style="margin-bottom:5px;" class="btn btn-small btn-tertiary"><i class="icon-circle-arrow-left"></i> Reports Home</a><a href="#application.root#?event=page.reports.enrollment" style="margin-left:5px;margin-bottom:5px;" class="btn btn-small btn-default"><i class="icon-list-alt"></i> Outstanding Enrollment Report</a></span></h5>
									</cfoutput>
									
										<table id="tablesorter" class="table table-bordered table-striped table-highlight tablesorter" >
											<thead>
												<tr>
													<th width="5%">Actions</th>
													<th>ID</th>
													<th>Name</th>
													<th>Lead Source</th>
													<th>Contact</th>
													<th>Email</th>
													<th>Last Note Date</th>														
													<th>E-Sign Status</th>																																				
												</tr>
											</thead>
											<tbody>
												
												<cfoutput query="esignreport">
													<cfinvoke component="apis.udfs.cleanphonenumber" method="formatphonenumber" returnvariable="phonenumber">
														<cfinvokeargument name="phonenumber" value="#leadphonenumber#">
													</cfinvoke>													
														<tr>
															<td class="actions">
																<a href="#application.root#?event=page.getlead&fuseaction=leadgen&leadid=#leaduuid#" class="btn btn-mini btn-warning" target="_blank">
																	<i class="btn-icon-only icon-ok"></i>										
																</a>						
															</td>
															<td>#leadid#</td>
															<td>#leadfirst# #leadlast#</td>
															<td>#leadsource#</td>	
															<td><cfif leadphonetype is not ""><span class="label label-info">#leadphonetype#</span> <span style="margin-left:3px;">#phonenumber#</span><cfelse>Number Not Saved</cfif></td>
															<td><a href="#application.root#?event=page.getlead&fuseaction=leadgen&leadid=#leaduuid#&ref=page.email" target="_blank" style="margin-left:3px;"><i class="btn-icon-only icon-envelope"></i></a>  #leademail#</td>															
															<td><cfif lastnotedate is not "">#dateformat( lastnotedate, "mm/dd/yyyy" )#</span><cfif lastnotetext is not "">&nbsp;&nbsp;<a href="javascript:;" rel="popover" data-content="#urldecode( lastnotetext )#" data-original-title="#leadfirst# #leadlast#'s Last Note"><i class="btn-icon-only icon-paper-clip"></i></a></cfif><cfelse>No Notes Entered</cfif></td>
															<td><cfif escompleted eq 1><span class="label label-info">Completed</span><cfelse><span class="label label-important">Incomplete</span></cfif></td>																										
														</tr>
												</cfoutput>
																								
											</tbody>
										</table>
										<p class="tip">
											<span class="label label-info">TIP!</span> &nbsp; Click the column headers to sort the data.  You can sort multiple columns simultaneously by holding down the shift key and clicking a second, third or even fourth column header!
										</p>
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
					
					
					<cfif esignreport.recordcount lt 15>
						<div style="margin-top:425px;"></div>
					<cfelse>
						<div style="margin-top:100px;"></div>
					</cfif>
					
				  
				</div> <!-- / .container -->
				
			</div> <!-- / .main -->