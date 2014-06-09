


							
							
							<cfif not isuserinrole( "admin" ) and not isuserinrole( "co-admin" )>
								<cflocation url="#application.root#?event-page.index&error=1" addtoken="yes">
							</cfif>
							
							
							
							
							
							
							<!--- set default start and end date values --->
							<cfparam name="thisdate" default="">
							<cfparam name="startdate" default="">
							<cfparam name="enddate" default="">
							<cfparam name="achtotals" default="0.00">
							<cfset thisdate = now() />
							
							<!--- set default start and end date values for our query --->
							<cfif structkeyexists( form, "filtermyresults" )>								
								<cfset startdate = createodbcdate( createdate( year( form.startdate ), month( form.startdate ), day( form.startdate ) ) ) />
								<cfset enddate = createodbcdate( createdate( year( form.enddate ), month( form.enddate ), day( form.enddate ))) />
							<cfelse>							
								<cfset startdate = createodbcdate( createdate( year( thisdate ), 1, 1 ) ) />
								<cfset enddate = createodbcdate( createdate( year( thisdate ), month( thisdate ), daysinmonth( thisdate ))) />							
							</cfif>						
							
							<!--- // get our data access components --->
							<cfinvoke component="apis.com.admin.companybankinggateway" method="getachsummarydata" returnvariable="achsummarydata">
								<cfinvokeargument name="companyid" value="#session.companyid#">
								<cfinvokeargument name="startdate" value="#startdate#">
								<cfinvokeargument name="enddate" value="#enddate#">
							</cfinvoke>	
							
		
							<!--- // format our numeric database values --->
							<cfif achsummarydata.totalfeescollected is "">
								<cfset totalfeescollected = 0 />
							<cfelse>
								<cfset totalfeescollected = achsummarydata.totalfeescollected />
							</cfif>
							
							<cfif achsummarydata.totalpendingpayments is "">
								<cfset totalpendingpayments = 0 />
							<cfelse>
								<cfset totalpendingpayments = achsummarydata.totalpendingpayments />
							</cfif>
		
		
		
		
		
		
		
							
							
							
							
							
							
							
		
		
		
		
		
		
		
		
							<!--- // begin admin baking page --->			
							<div class="main">

								<div class="container">				

									<div class="row">
									
										<div class="span12">
											
											<div class="widget stacked">
												
												<cfoutput>	
												<div class="widget-header">
													<i class="icon-money"></i>
													<h3>ACH and Banking Summary Report for #session.companyname#</h3>
												</div> <!-- /widget-header -->
												</cfoutput>
												
												<div class="widget-content">						
													
													
													<!--- // report filter --->						
													<cfoutput>
														<div class="well">
															<p><i class="icon-check"></i> Filter Your Results</p>
															<form class="form-inline" name="filterresults" method="post">								
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


													
							
														<!--- fee stats and financial summary --->										
							
							
								
														<div class="row" style="margin-left:5px;margin-right:5px;">
															
															
															
															<cfoutput>
															
															
															<h5><i class="icon-th-large"></i> Financial Summary | Evaluating Dates | #dateformat( startdate, "mm/dd/yyyy" )# through #dateformat( enddate, "mm/dd/yyyy" )#  <span class="pull-right"><a href="#application.root#?event=page.admin" style="margin-bottom:5px;" class="btn btn-small btn-tertiary"><i class="icon-home"></i> Admin Home</a><a style="margin-left:5px;margin-bottom:5px;" href="#application.root#?event=page.admin.banking" class="btn btn-small btn-default"><i class="icon-building"></i> Banking Center</a></span></h5>
															<br />
															
															
															
															
																<div id="big_stats" class="cf">													
																									
																	<div class="stat">								
																		<h4>Total Fee Count</h4>
																		<span class="value"><small>#numberformat( achsummarydata.totalfeecount, "99" )#</small></span>								
																	</div> <!-- .stat -->
																	
																	<div class="stat">								
																		<h4>Total Fees Due</h4>
																		<span class="value"><small>#dollarformat( achsummarydata.totalfeesdue )#</small></span>								
																	</div> <!-- .stat -->
																									
																	<div class="stat">								
																		<h4>Total Fees Paid</h4>
																		<span class="value"><small>#dollarformat( achsummarydata.totalfeespaid )#</small></span>								
																	</div> <!-- .stat -->																
																									
																	<div class="stat">								
																		<h4>Total Projected Fees</h4>
																		<span class="value"><small>#dollarformat( achsummarydata.totalprojectedfees )#</small></span>								
																	</div> <!-- .stat -->
																	
																	
																	
																													
																</div>
															
															</cfoutput>				
														
														
														</div><!-- / .row -->
														
														
														<div class="row" style="margin-left:5px;margin-right:5px;margin-top:10px;padding-top:10px;border-top:1px dotted #f2f2f2;">
															
															
															<cfoutput>
															
																<div id="big_stats" class="cf">													
																									
																	<div class="stat">								
																		<h4>Total Fees Collected</h4>
																		<span class="value"><small>#numberformat( totalfeescollected, "999" )#</small></span>								
																	</div> <!-- .stat -->
																									
																	<div class="stat">								
																		<h4>Total Uncollected Fees</h4>
																		<span class="value"><small>#numberformat( achsummarydata.totaluncollectedfeecount, "99" )#</small></span>								
																	</div> <!-- .stat -->

																	<div class="stat">								
																		<h4>Total Pending Payment Count</h4>
																		<span class="value"><small>#numberformat( achsummarydata.totalpendingpaycount, "99" )#</small></span>								
																	</div> <!-- .stat -->
																									
																	<div class="stat">								
																		<h4>Total Pending Payments</h4>
																		<span class="value"><small>#dollarformat( totalpendingpayments )# </small></span>								
																	</div> <!-- .stat -->
																	
																														
																													
																</div>
															
															</cfoutput>				
														
														
														</div><!-- / .row -->
							
														
													
												</div> <!-- /widget-content -->
													
											</div> <!-- / .widget -->
											
										</div> <!-- /span12 -->
									
									</div> <!-- / .row -->
									
									<div style="margin-top:100px;"></div>
								  
								</div> <!-- / .container -->
								
							</div> <!-- / .main -->
		
		
		
		
		
		
		
		
		