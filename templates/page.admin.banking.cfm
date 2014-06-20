
						
						
						
						
						
						
							<cfif not isuserinrole( "admin" ) and not isuserinrole( "co-admin" )>
								<cflocation url="#application.root#?event-page.index&error=1" addtoken="yes">
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
							<cfinvoke component="apis.com.admin.companybankinggateway" method="getachdata" returnvariable="achdata">
								<cfinvokeargument name="companyid" value="#session.companyid#">
								<cfinvokeargument name="startdate" value="#startdate#">
								<cfinvokeargument name="enddate" value="#enddate#">
							</cfinvoke>

							<cfinvoke component="apis.com.system.companysettings" method="getcompanysettings" returnvariable="companysettings">
								<cfinvokeargument name="companyid" value="#session.companyid#">
							</cfinvoke>
		
		
		
		
		
		
		
		
		
		
							
							
							
							
							
							
							
		
		
		
		
		
		
		
		
							<!--- // begin admin baking page --->			
							<div class="main">

								<div class="container">				

									<div class="row">
									
										<div class="span12">
											
											<div class="widget stacked">
												
												<cfoutput>	
												<div class="widget-header">
													<i class="icon-money"></i>
													<h3>Company Banking Center for #session.companyname#</h3>
												</div> <!-- /widget-header -->
												</cfoutput>
												
												<div class="widget-content">						
													
													
													<!--- // report filter --->						
													<cfoutput>
														<div class="well">
															<p><i class="icon-check"></i> Filter Your Results</p>
															<form class="form-inline" name="filterresults" method="post">					
																
																<select name="feetype" class="input-large" onchange="javascript:this.form.submit();">
																	<option value="--">Filter by Fee Type</option>
																	<option value="A"<cfif isdefined( "form.feetype" ) and trim( form.feetype ) is "a">selected</cfif>>Advisory Only</option>
																	<option value="I"<cfif isdefined( "form.feetype" ) and trim( form.feetype ) is "i">selected</cfif>>Implementation Only</option>
																<select>

																<select name="paytype" class="input-large" onchange="javascript:this.form.submit();">
																	<option value="--">Filter by Payment Type</option>
																	<option value="ACH"<cfif isdefined( "form.paytype" ) and trim( form.paytype ) is "ach">selected</cfif>>ACH</option>
																	<option value="CC"<cfif isdefined( "form.paytype" ) and trim( form.paytype ) is "cc">selected</cfif>>Credit Card</option>
																	<option value="MO"<cfif isdefined( "form.paytype" ) and trim( form.paytype ) is "mo">selected</cfif>>Money Order</option>
																	<option value="CHK"<cfif isdefined( "form.paytype" ) and trim( form.paytype ) is "chk">selected</cfif>>Check</option>
																	<option value="CSH"<cfif isdefined( "form.paytype" ) and trim( form.paytype ) is "csh">selected</cfif>>Cash</option>
																<select>
																
																<input type="text" name="startdate" style="margin-left:5px;" class="input-medium" placeholder="Start Date" id="datepicker-inline4" value="<cfif isdefined( "form.startdate" )>#dateformat( form.startdate, 'mm/dd/yyyy' )#<cfelse>#dateformat( startdate, 'mm/dd/yyyy' )#</cfif>">
																<input type="text" name="enddate" style="margin-left:5px;" class="input-medium" placeholder="End Date" id="datepicker-inline5" value="<cfif isdefined( "form.enddate" )>#dateformat( form.enddate, 'mm/dd/yyyy' )#<cfelse>#dateformat( enddate, 'mm/dd/yyyy' )#</cfif>">
																<input type="hidden" name="filtermyresults">
																<button type="submit" style="margin-left:5px;" name="filterresults" class="btn btn-small btn-secondary"><i class="icon-search"></i> Filter Results</button>
																<cfif structkeyexists( form, "filtermyresults" )><button type="reset" onclick="location.href='#application.root#?event=#url.event#'" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-check"></i> Reset List</button></cfif>
																<br /><br />								
															</form>
														</div>
													</cfoutput>
													<!--- // end filter --->
													
													
													
													
													
													
													
													
													<cfif achdata.recordcount gt 0>				
													
													<cfoutput>
														<h5><i class="icon-th-large"></i> The banking center found #achdata.recordcount# fee<cfif achdata.recordcount gt 1>s</cfif> due between #dateformat( startdate, "mm/dd/yyyy" )# to #dateformat( enddate, "mm/dd/yyyy" )#  <span class="pull-right"><a href="#application.root#?event=page.admin" style="margin-bottom:5px;" class="btn btn-small btn-tertiary"><i class="icon-home"></i> Admin Home</a><a style="margin-left:5px;margin-bottom:5px;" href="#application.root#?event=#url.event#.summary" class="btn btn-small btn-default"><i class="icon-list-alt"></i> Financial Summary</a></span></h5>
													</cfoutput>
													
														<table id="tablesorter" class="table table-bordered table-striped table-highlight tablesorter" >
															<thead>
																<tr>
																	<th width="5%">Actions</th>
																	<th>Client Name</th>
																	<th>Fee Type</th>
																	<th>Pay Type</th>
																	<th>Due Date</th>
																	<th>Fee Amount</th>																	
																	<th>Paid Date</th>
																	<th>Paid Amount</th>
																	<th>Status</th>
																	<th>Collected</th>																																																					
																</tr>
															</thead>
															<tbody>
																
																<cfoutput query="achdata">
																													
																		<tr>
																			<td class="actions">
																				<a href="#application.root#?event=page.getlead&fuseaction=leadgen&leadid=#leaduuid#" class="btn btn-mini btn-warning" target="_blank">
																					<i class="btn-icon-only icon-ok"></i>										
																				</a>						
																			</td>
																			<td>#leadfirst# #leadlast#   <cfif leadactive neq 1><small><span style="color:red;margin-left:5px;">(Inactive)</span></small></cfif></td>
																			<td><cfif trim( feeprogram ) is "a">Advisory<cfelseif trim( feeprogram ) is "i">Implementation</cfif></td>																				
																			<td>#feepaytype#</td>
																			<td>#dateformat( feeduedate, "mm/dd/yyyy" )#</td>
																			<td>#dollarformat( feeamount )#  <cfif esignrouting is "" or esignaccount is ""><a href="javascript;:" rel="popover" style="color:red;margin-left:5px;" data-original-title="Warning: Missing Banking Information" data-content="This client has fees due and no ACH or banking details saved.  No payments will be released for processing with missing or incomplete banking information."><i class="icon-warning-sign"></i></a></cfif> <cfif trim( leadachhold ) is "Y"><a href="javascript;:" rel="popover" style="color:blue;margin-left:5px;" data-original-title="ACH Hold" data-content="This client is currently on ACH Hold.  <br/><br/> Hold Date: #dateformat( leadachholddate, 'mm/dd/yyyy' )#<br />Hold Reason: #leadachholdreason#"><i class="icon-warning-sign"></i></a></cfif></td>
																			<td><cfif feepaiddate is not ""><span class="label label-success">#dateformat( feepaiddate, "mm/dd/yyyy" )#</span><cfelseif feestatus is "pending" and feetransdate is not ""><span class="label label-warning">Sent on #dateformat( feetransdate, "mm/dd/yyyy" )#</span><cfelse><span class="label label-warning">Not Paid</span></cfif></td>															
																			<td>#dollarformat( feepaid )#</td>
																			<td><cfif trim( feestatus ) is "paid"><span class="label label-success">PAID</span><cfelseif trim( feestatus ) is "pending"><span class="label label-info">PENDING</span><cfelseif trim( feestatus ) is "unpaid"><span class="label label-warning">UNPAID</span></cfif></td>
																			<td><cfif feecollected eq 1><span class="label label-inverse">YES</span><cfelse><span class="label label-important">NO</span></cfif></td>																										
																		</tr>
																		<cfset achtotals = achtotals + feeamount />
																		<cfset achpaidtotals = achpaidtotals + feepaid />
																</cfoutput>
																
																<!--- // show the totals row --->
																<cfoutput>
																	<tr style="font-size:16px;font-weight:bold;" class="alert alert-info">
																		<td colspan="4">&nbsp;</td>
																		<td style="font-weight:bold;"><div align="left">TOTALS:</td>																		
																		<td style="font-weight:bold;">#dollarformat( achtotals )#</td>
																		<td style="font-weight:bold;">&nbsp;</td>
																		<td style="font-weight:bold;">#dollarformat( achpaidtotals )#</td>
																		<td colspan="2"><cfif achdata.recordcount gt 0><a href="templates/#companysettings.achdatafile#.cfm?sdate=#dateformat( startdate, "yyyy-mm-dd" )#&edate=#dateformat( enddate, "yyyy-mm-dd" )#" onclick="javascript:window.location.href=window.location.href;" class="btn btn-small btn-inverse"><i class="icon-file-alt"></i> Generate #companysettings.achprovider# Data File</cfif></td>
																	<tr>
																</cfoutput>
																
															</tbody>
														</table>
														<p class="tip">
															<span class="label label-info">TIP!</span> &nbsp; Click the column headers to sort the data.  You can sort multiple columns simultaneously by holding down the shift key and clicking a second, third or even fourth column header!
														</p>
														<p class="tip">
															<span class="label label-important">IMPORTANT!</span> &nbsp; No ACH or fee transactions will be processed for <span style="color:red;">inactive</span> clients, clients <span style="color:orange;">missing banking information</span> or clients on <span style="color:blue;">ACH Hold</span>. </span>
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
									
									
									<cfif achdata.recordcount lt 15>
										<div style="margin-top:325px;"></div>
									<cfelse>
										<div style="margin-top:100px;"></div>
									</cfif>
									
								  
								</div> <!-- / .container -->
								
							</div> <!-- / .main -->
		
		
		
		
		
		
		
		
		