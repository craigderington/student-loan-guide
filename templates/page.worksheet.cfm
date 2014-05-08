

			
			<!--- get our data components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>			
			
			<cfinvoke component="apis.com.worksheets.worksheetgateway" method="getworksheets" returnvariable="worksheetlist">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
	
			<!--- // define a few page vars --->
			<cfparam name="totalstudentloandebt" default="0">
			<cfparam name="totalpayments" default="0">
			<cfparam name="totalintrate" default="0">
			<cfparam name="avgintrate" default="0">
			
			

			<!--- student loan debt worksheet page --->			
			
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
						
							<cfif structkeyexists(url, "msg")>						
								<div class="row">
									<div class="span12">
										<cfif url.msg is "saved">
											<div class="alert alert-success">
												<button type="button" class="close" data-dismiss="alert">&times;</button>
												<strong><i class="icon-check"></i>SUCCESS!</strong>  The student loan debt worksheet was successfully updated.  Please clear this message to continue...  
											</div>
										<cfelseif url.msg is "added">
											<div class="alert alert-success">
												<button type="button" class="close" data-dismiss="alert">&times;</button>
												<strong><i class="icon-check"></i> SUCCESS!</strong>  The new student loan debt worksheet was successfully added to the client's profile...
											</div>
										<cfelseif url.msg is "deleted">
											<div class="alert alert-error">
												<button type="button" class="close" data-dismiss="alert">&times;</button>
												<strong><i class="icon-warning-sign"></i> RECORD DELETED!</strong>  The student loan debt worksheet was successfully deleted from the client's profile...
											</div>
										</cfif>
									</div>								
								</div>							
							</cfif>	
						
						
							<div class="widget stacked">
								<cfoutput>	
								<div class="widget-header">		
									<i class="icon-refresh"></i>							
									<h3>Student Loan Debt Worksheets for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
								</div> <!-- //.widget-header -->
								</cfoutput>	
							
								<div class="widget-content">
								
												
								
										<!--- // include the side bar nav --->
										<div class="span3">					
											<cfinclude template="page.sidebar.nav.cfm">		
										</div> <!-- /.span3 -->
			
			
										<div class="span8">
											
											<div class="tab-content">
												
												<div class="tab-pane active" id="tab1">
													
													<cfoutput>
													<h3><i class="icon-refresh"></i> Student Loan Debt Worksheet List 
														<span style="float:right;margin-right:15px;">
															<!-- Split button -->
															<div class="btn-group">
																<button type="button" class="btn btn-primary"><i class="icon-upload-alt"></i> Add Worksheet</button>
																<button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown">
																	<span class="caret"></span>																	
																</button>
																<ul class="dropdown-menu" role="menu">
																	<li><a href="#application.root#?event=page.worksheet.add">Add Student Loan Manually</a></li>
																	<li><a href="#application.root#?event=page.nslds.upload">Upload NSLDS Text File</a></li>																																
																</ul>
															</div>												
														</span>
													</h3>
													</cfoutput>
													
														<p>The Student Loan Debt Worksheet will display the student loans selected by the user and it is assumed user has entered ALL federal student loans into the worksheet. The information contained is an estimation based on the data provided by the user.</p> 

														<p>For the most accurate information for your FEDERAL loans, we ask you to access your NSLDS (National Student Loan Data System) file and upload into the debt worksheet.   For instructions on how to access this information, please <a href="javascript:;" onclick="window.open('templates/page.instructions.cfm#worksheet','','scrollbars=yes,location=no,status=no,width=821,height=711');"> click here <i class="icon-question-sign"></i></a>.</p>
													</p>
													<br>
													<cfif worksheetlist.recordcount gt 0>
													
														<table class="table table-bordered table-striped table-highlight">
															<thead>
																<tr>
																	<th width="12%">Actions</th>
																	<th>Servicer</th>
																	<th>Loan Type</th>
																	<th>Loan Status</th>																	
																	<th>Balance</th>
																	<th>Payment</th>																	
																	<th>Rate</th>
																	<th>Loan Date</th>																	
																</tr>
															</thead>
															<tbody>																		
																<cfoutput query="worksheetlist">
																<tr>
																	<td>
																		<a href="#application.root#?event=#url.event#.edit&worksheetid=#worksheetuuid#" class="btn btn-mini btn-primary">
																			<i class="btn-icon-only icon-pencil"></i>										
																		</a>
																		<cfif isuserinrole( "admin" ) or isuserinrole( "sls" )>
																			<a href="#application.root#?event=#url.event#.delete&worksheetid=#worksheetuuid#" class="btn btn-mini btn-secondary">
																				<i class="btn-icon-only icon-trash"></i>										
																			</a>
																		</cfif>
																	</td>
																	<td><cfif servid neq -1>#servname#<cfelse>#nslservicer#</cfif><cfif active eq 0>&nbsp;<small><i class="icon-asterisk"></i></small><cfelseif completed eq 1><small><i class="icon-bookmark" style="color:red;margin-left:3px;"></i></small></cfif></td>																	
																	<td>#codedescr#</td>
																	<td>#statuscodedescr#</td>																	
																	<td>#dollarformat( loanbalance )#</td>
																	<td>#dollarformat( currentpayment )#</td>
																	<td><span class="label">#numberformat( intrate, '999.99' )#%</span></td>
																	<td>#dateformat( closeddate, 'mm/dd/yyy' )#</td>																																																		
																</tr>
																<cfset totalstudentloandebt = totalstudentloandebt + loanbalance />
																<cfset totalpayments = totalpayments + currentpayment />
																<cfset totalintrate = totalintrate + intrate />
																<cfset avgintrate = totalintrate / worksheetlist.recordcount />
																</cfoutput>
																
																<!--- // do sub totals and average interest rate --->
																<cfoutput>
																<tr style="font-weight:bold;" class="alert alert-notice">
																	<td colspan="4" style="color:black;text-align:right;">TOTALS:</td>
																	<td style="color:black;">#dollarformat( totalstudentloandebt )#</td>
																	<td style="color:black;">#dollarformat( totalpayments )#</td>
																	<td><span class="label">#numberformat( avgintrate, '999.99' )#%</span></td>
																	<td>&nbsp;</td>																	
																</tr>
																</cfoutput>
															</tbody>
														</table>								
														<span style="float:right"><small><i class="icon-asterisk"></i> Loan not included in consolidation or repayment calculation.</small></span>
														<span style="float:right"><small><i class="icon-bookmark" style="color:red;"></i> Loans that already have a solution and have been marked completed.&nbsp;  </small></span>
														<span style="float:right"><small>Note: The interest rate total is displayed as the average rate and not a sum of all of the loan interest rates.</small></span>												
														
													<cfelse>												
														
														<!--- // if recordset is empty - show alert --->									
														<div class="alert alert-block alert-error">
															<button type="button" class="close" data-dismiss="alert">&times;</button>
															<h4><strong>NO RECORDS FOUND!</strong></h4>
															<p>No student loan debt worksheet have been created for the selected client.  Please use button above to add worksheets to the list...</p>											
														</div>
															
														
																					
														
													</cfif>
													
													<div style="margin-top:100px;">
														<a href="index.cfm?event=page.nslds.upload" class="btn btn-default btn-small"><i class="icon-upload"></i> Upload NSLDS Text File</a> &nbsp; <a href="javascript:;" onclick="window.open('templates/page.instructions.cfm#worksheet','','scrollbars=yes,location=no,status=no,width=821,height=711');" title="View Debt Worksheet Instructions"><small>View Help <i class="icon-question-sign"></i></small></a>
													</div>				
												</div> <!-- /#tab1 -->										 
											
											</div> <!-- /.tab-content -->
											
										</div> <!-- /.span8 -->
			
									
					
								</div> <!-- /. widget-content -->
							
							</div> <!-- /. widget-stacked -->
						
						</div><!-- / .span12 -->
					
					</div> <!-- / .row -->
					
					<div style="margin-top:150px;"></div>
				
				</div> <!-- / .container -->
			
			</div> <!-- / .main -->