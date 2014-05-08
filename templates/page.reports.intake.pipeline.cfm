
			
			
			<!--- // report security filter --->
			<cfif not isuserinrole( "admin" ) and not isuserinrole( "co-admin" )>
				<cflocation url="#application.root#?event=page.reports&noaccess=1" addtoken="yes">
			</cfif>
			
			<!--- // get our data access components --->
						
			<cfinvoke component="apis.com.leads.leadgateway" method="getleadsources" returnvariable="leadsources">
				<cfinvokeargument name="companyid" value="#session.companyid#">				
			</cfinvoke>
			
			<cfinvoke component="apis.com.reports.reportgateway" method="getintakepipelinereport" returnvariable="intakepipelinereport">
				<cfinvokeargument name="companyid" value="#session.companyid#">
				<cfinvokeargument name="thisdate" value="#createodbcdatetime( now() )#" />
			</cfinvoke>

			<cfinvoke component="apis.com.reports.reportgateway" method="getreportroles" returnvariable="reportroles">
				<cfinvokeargument name="companyid" value="#session.companyid#">
				<cfinvokeargument name="roletype" value="intake">
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
									<h3>Intake Pipeline Report for #session.companyname#</h3>
								</div> <!-- /widget-header -->
								</cfoutput>
								<div class="widget-content">						
									
									<cfif intakepipelinereport.recordcount gt 0>
									
										<!--- // report filter 	--->							
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
													
													<select name="counselors" style="margin-left:5px;" class="input-large" onchange="javascript:this.form.submit();">
														<option value="">Select Intake Advisor</option>
														<cfloop query="reportroles">
															<option value="#userid#"<cfif isdefined( "form.counselors" ) and form.counselors eq reportroles.userid>selected</cfif>>#firstname# #lastname#</option>
														</cfloop>												
													</select>
													<input type="text" name="startdate" style="margin-left:5px;" class="input-medium" placeholder="Start Date" id="datepicker-inline4" value="<cfif isdefined( "form.startdate" )>#dateformat( form.startdate, 'mm/dd/yyyy' )#</cfif>">
													<input type="text" name="enddate" style="margin-left:5px;" class="input-medium" placeholder="End Date" id="datepicker-inline5" value="<cfif isdefined( "form.enddate" )>#dateformat( form.enddate, 'mm/dd/yyyy' )#</cfif>">
													<input type="hidden" name="filtermyresults">
													<button type="submit" style="margin-left:5px;" name="filterresults" class="btn btn-small btn-secondary"><i class="icon-search"></i> Filter Results</button>
													<cfif structkeyexists( form, "filtermyresults" )><button type="reset" onclick="location.href='#application.root#?event=#url.event#'" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-check"></i> Reset List</button></cfif>
												</form>
											</div>
										</cfoutput>
										<!--- // end filter --->		
									
										
									
									
									
									
									
									
										<h5><i class="icon-th-large"></i> This report found <cfoutput>#intakepipelinereport.recordcount#</cfoutput> client record<cfif intakepipelinereport.recordcount gt 1>s</cfif></h5>
									
									
										<table id="tablesorter" class="table table-bordered table-striped table-highlight tablesorter">
											<thead>
												<tr>
													<th width="5%">Actions</th>																									
													<th width="15%">Name</th>
													<th width="12%">Phone</th>																									
													<th width="8%">Enroll Complete</th>
													<th width="12%" >Intake Advisor</th>													
													<th>Intake Tasks Incomplete</th>												
													<th>Intake Tasks Completed</th>
													<th width="12%">Last Note</th>	
													<th>Last Pay</th>
													<th>Paid in Full</th>
													<th>Email/Text</th>
												</tr>
											</thead>
											<tbody>
												<cfoutput query="intakepipelinereport">
													
													<cfif totalfees is "">
														<cfset totalfees = 0.00 />
													</cfif>
													<cfif totalfeespaid is "">
														<cfset totalfeespaid = 0.00>
													</cfif>
													
													<cfinvoke component="apis.udfs.cleanphonenumber" method="formatphonenumber" returnvariable="phonenumber">
														<cfinvokeargument name="phonenumber" value="#leadphonenumber#">
													</cfinvoke>													
														<tr>
															<td class="actions">
																<a href="#application.root#?event=page.getlead&fuseaction=leadgen&leadid=#leaduuid#" class="btn btn-mini btn-warning" target="_blank">
																	<i class="btn-icon-only icon-ok"></i>										
																</a>						
															</td>																														
															<td>#leadfirst# #leadlast# (#leadid#)</td>
															<td>#phonenumber#</td>														
															<td>#dateformat( slenrollreturndate, "mm/dd/yyyy" )#</td>
															<td>#intakefirstname# #intakelastname#</td>
															<td>#totalincompletetasks#</td>
															<td>#totalcompletedtasks#</td>															
															<td><cfif lastnotedate is not "">#dateformat( lastnotedate, "mm/dd/yyyy" )#<cfif lastnotetext is not "">&nbsp;&nbsp;<a href="javascript:;" rel="popover" data-content="#urldecode( lastnotetext )#" data-original-title="#leadfirst# #leadlast#'s Last Note"><i class="btn-icon-only icon-paper-clip"></i></a></cfif><cfelse>No Notes Entered</cfif></td>
															<td><cfif lastpaymentdate is not "">#dateformat( lastpaymentdate, "mm/dd/yyyy" )#<cfelse>NO PAYMENTS</cfif></td>
															<td><cfif ( totalfees eq totalfeespaid ) and ( totalfeespaid neq 0.00 and totalfeespaid is not "" )><span class="label label-success">YES</span><cfelse><span class="label label-important">NO</span></cfif></td>
															<td><a href="#application.root#?event=page.getlead&fuseaction=leadgen&leadid=#leaduuid#&ref=page.email" target="_blank" style="margin-left:3px;"><i class="btn-icon-only icon-envelope"></i></a>  <a href="#application.root#?event=page.getlead&fuseaction=leadgen&leadid=#leaduuid#&ref=page.txtmsg" target="_blank" style="margin-left:3px;"><i class="btn-icon-only icon-phone"></i></a></td>
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
					
					
					<cfif intakepipelinereport.recordcount lt 15>
						<div style="margin-top:425px;"></div>
					<cfelse>
						<div style="margin-top:100px;"></div>
					</cfif>
					
				  
				</div> <!-- / .container -->
				
			</div> <!-- / .main -->