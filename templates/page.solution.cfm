

			
			<!--- // get our data access components --->
			
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.leads.leadgateway" method="getleadsummary" returnvariable="leadsummary">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.solutions.solutiongateway" method="getsolutions" returnvariable="solutionlist">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.worksheets.worksheetgateway" method="getworksheets" returnvariable="worksheetlist">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.solutions.solutiongateway" method="getcompletedsolutions" returnvariable="completedsolutions">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			
			
			
			<!--- define page vars --->
			<cfparam name="showcalc" default="no">
			<cfparam name="pplus" default="">
			
			<cfset pplus = valuelist( worksheetlist.loancode ) />
			
			<!--- // check our worksheets to see if any are included in consolidation and set the flag --->
			<cfloop query="solutionlist">
				<cfif incconsol eq 1>
					<cfset showcalc = "yes" />
				</cfif>
			</cfloop>
			
			
			<!--- // update which loans to consolidate --->
			
			<cfif structkeyexists( form, "updateconsolworksheet" ) and isvalid("integer", form.worksheetid )>
				<cfparam name="worksheetid" default="">
				<cfparam name="status" default="">
				<cfset worksheetid = #form.worksheetid# />
				
				<cfif isdefined( "form.chkInc" )>
					<cfset status = 1 />
				<cfelse>
					<cfset status = 0 />				
				</cfif>
				
				
				<cfquery datasource="#application.dsn#" name="updateworksheet">
					update slworksheet
					   set incconsol = <cfqueryparam value="#status#" cfsqltype="cf_sql_bit" />
					 where worksheetid = <cfqueryparam value="#worksheetid#" cfsqltype="cf_sql_integer" />
				</cfquery>
				
				<cflocation url="#application.root#?event=#url.event#" addtoken="no" >
				
			</cfif>
			
			

						
			<!--- // solution shopping cart page --->			
			
			
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
						
						
						<!--- // show system messages --->
						<cfif structkeyexists( url, "msg" ) and url.msg is "deleted" >					
							<div class="row">
								<div class="span12">										
									<div class="alert alert-info">
										<button type="button" class="close" data-dismiss="alert">&times;</button>
										<strong><i class="icon-check"></i> SUCCESS!</strong>  The selected solution was successfully removed from the solution cart.  Please select a new action to continue...
									</div>										
								</div>								
							</div>
						<cfelseif structkeyexists( url, "msg" ) and url.msg is "saved" >					
							<div class="row">
								<div class="span12">										
									<div class="alert alert-notice">
										<button type="button" class="close" data-dismiss="alert">&times;</button>
										<strong><i class="icon-check"></i> SUCCESS!</strong>  The explanation and student loan solution narrative was successfully saved.  Please select a new task or action to continue...
									</div>										
								</div>								
							</div>					
						</cfif>
							
							<div class="widget stacked">
								
								<cfoutput>
								<div class="widget-header">		
									<i class="icon-book"></i>							
									<h3>Student Loan Solutions for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
								</div> <!-- //.widget-header -->
								</cfoutput>
								
								<div class="widget-content">						
									<!---
									<div class="pricing-header">
													
										<h1><i class="icon-shopping-cart"></i> Your Student Loan Solutions</h1>
										<h2 style="margin-top:-20px;">Solution Shopping Cart</h2>
									</div> <!-- /.pricing-header -->
									--->			
										<div class="pricing-plans plans-4">
													
											
											<cfif solutionlist.recordcount gt 0>
												
												<cfif trim( showcalc ) is "yes">
													<div class="alert alert-info">
														<button type="button" class="close" data-dismiss="alert">&times;</button>
														<strong><i class="icon-check"></i> NOTICE!</strong> To view consolidation repayment calculator, check the box under column "Select" to include those student loans in the repayment calculator.  
													</div>
												</cfif>
											
											
												<table class="table table-bordered table-striped table-highlight">
													<thead>
														<tr>
															<th>Select</th>
															<th>Solution</th>
															<th>Loan Type</th>
															<th>Servicer</th>
															<th>Loan Balance</th>
															<th>School Attended</th>
															<th>Int Rate</th>
															<th>Date Selected</th>
															<th>Chosen By</th>
															<th width="10%">Solution Tasks</th>
														</tr>
													</thead>
													<tbody>
														<cfoutput query="solutionlist">
														<tr>
															<td><cfif solutionsubcat contains "consolidation"><div align="center"><form name="consol-date-this" method="post" action="#cgi.script_name#?event=#url.event#"><input type="checkbox" name="chkInc" value="1" onclick="this.form.submit();"<cfif incconsol eq 1>checked</cfif>><input type="hidden" name="worksheetid" value="#solutionworksheetid#"><input type="hidden" name="updateconsolworksheet" value="true"></form><cfelse><span class="label label-important">N/A</span></div></cfif></td>													
															<td>#solutionsubcat# #solutionoption#</td>
															<td><cfif solutionoptiontree eq 1>Direct Loan<cfelseif solutionoptiontree eq 2>FFEL Loan<cfelseif solutionoptiontree eq 2><cfelseif solutionoptiontree eq 3>Perkins Loan<cfelseif solutionoptiontree eq 4>Direct Consolidation<cfelseif solutionoptiontree eq 5>Health Professional<cfelseif solutionoptiontree eq 6>Parent PLUS<cfelseif solutionoptiontree eq 7>Private Loan</cfif></td>
															<td><cfif servid neq -1>#servname#<cfelse>#nslservicer#</cfif></td>
															<td>#dollarformat( loanbalance )#</td>
															<td>#attendingschool#</td>
															<td>#numberformat( intrate, '9.99')#%</td>
															<td>#dateformat( solutiondate, 'mm/dd/yyyy' )#</td>
															<td>#firstname# #lastname#</td>															
															<td class="actions">																
																<a href="#application.root#?event=#url.event#.notes&sid=#solutionuuid#" class="btn btn-small btn-warning" rel="popover" data-original-title="Write Option Narrative" data-content="Write a personalized narrative for the selected solution.">
																	<i class="btn-icon-only icon-comments"></i>										
																</a>														
																	
																<a href="#application.root#?event=#url.event#.remove&sid=#solutionuuid#" class="btn btn-small btn-secondary" rel="popover" data-original-title="Remove the Selected Solution" data-content="Remove this solution from your solution cart." >
																	<i class="btn-icon-only icon-trash"></i>										
																</a>																
															</td>
														</tr>
														</cfoutput>
													</tbody>
												</table>
													
												<cfoutput>	
													<a href="#application.root#?event=page.solution.checkout" class="btn btn-small btn-secondary"><i class="icon-shopping-cart"></i> Solution Check Out</a>  <a href="#application.root#?event=page.tree" style="margin-left: 5px;" class="btn btn-small btn-primary"><i class="icon-sitemap"></i> Return to Option Tree</a>  <!---<a href="index.cfm?event=page.solution.present" class="btn btn-large btn-default" target="_blank">Create Presentation</a>--->
												</cfoutput>
														
												
												
												
												
												
													<cfif trim( showcalc ) is "yes" >
														<!--- // show the repayment calculator --->
														<cfinvoke component="apis.com.calculator.clientloanoptions" method="getclientloaninfo" returnvariable="cloaninfo">
															<cfinvokeargument name="leadid" value="#session.leadid#">
														</cfinvoke>
												
														<!--- // determine the loan term // this is needed for other functions --->
														<cfparam name="cloanterm" default="0">
														<cfif cloaninfo.totalloanamount LT 10000>
															<cfset cloanterm = 144 />
														<cfelseif cloaninfo.totalloanamount GT 10000 AND cloaninfo.totalloanamount LTE 19999>
															<cfset cloanterm = 180 />
														<cfelseif cloaninfo.totalloanamount GT 19999 AND cloaninfo.totalloanamount LTE 39999>
															<cfset cloanterm = 240 />
														<cfelseif cloaninfo.totalloanamount GT 39999 AND cloaninfo.totalloanamount LTE 59999>
															<cfset cloanterm = 300 />
														<cfelse>
															<cfset cloanterm = 360 />
														</cfif>		
												
														<!--- // qualify the client based on the poverty lookup --->
														<cfinvoke component="apis.com.calculator.studentloancalculator" method="qualifyclient" returnvariable="qualifyThisClient">
															<cfinvokeargument name="agi" value="#leadsummary.primaryagi#">
															<cfinvokeargument name="famsize" value="#leadsummary.familysize#">
															<cfif trim( leaddetail.leadstate ) IS "AK">
																<cfinvokeargument name="region" value="AK">
															<cfelseif trim( leaddetail.leadstate ) IS "HI">
																<cfinvokeargument name="region" value="AK">
															<cfelse>
																<cfinvokeargument name="region" value="CS">
															</cfif>
														</cfinvoke>
														
														<!--- // calculate the income based plan --->
														<cfinvoke component="apis.com.calculator.studentloancalculator" method="calcIBR" returnvariable="mIBR">
															<cfinvokeargument name="agi" value="#leadsummary.primaryagi#">
															<cfinvokeargument name="famsize" value="#leadsummary.familysize#">
															<cfif trim( leaddetail.leadstate ) IS "AK">
																<cfinvokeargument name="region" value="AK">
															<cfelseif trim( leaddetail.leadstate ) IS "HI">
																<cfinvokeargument name="region" value="AK">
															<cfelse>
																<cfinvokeargument name="region" value="CS">
															</cfif>
														</cfinvoke>
														
														
														<!--- // calculate the income contingent plan --->
														<cfinvoke component="apis.com.calculator.studentloancalculator" method="calcICR" returnvariable="monthlyPaymentICR">
															<cfinvokeargument name="agi" value="#leadsummary.primaryagi#">
															<cfinvokeargument name="famsize" value="#leadsummary.familysize#">
															<cfinvokeargument name="maritalstatus" value="#leadsummary.filingstatus#">		
															<cfinvokeargument name="leadid" value="#leaddetail.leadid#">
															
															<cfif trim( leaddetail.leadstate ) IS "AK">
																<cfinvokeargument name="region" value="AK">
															<cfelseif trim( leaddetail.leadstate ) IS "HI">
																<cfinvokeargument name="region" value="AK">
															<cfelse>
																<cfinvokeargument name="region" value="CS">
															</cfif>
														</cfinvoke>										
														
														
														<!--- Standard --->
														<cfinvoke component="apis.com.calculator.studentloancalculator" method="calcSTD" returnvariable="monthlyPaymentStd">
															<cfinvokeargument name="loanterm" value="#cloanterm#">
															<cfinvokeargument name="leadid" value="#leaddetail.leadid#">
														</cfinvoke>
																
														<!--- Extended --->
														<cfinvoke component="apis.com.calculator.studentloancalculator" method="calcExt" returnvariable="mExtPay">
															<cfinvokeargument name="loanterm" value="#cloanterm#">
															<cfinvokeargument name="leadid" value="#leaddetail.leadid#">
														</cfinvoke>
															
														<!--- Graduated --->
														<cfinvoke component="apis.com.calculator.studentloancalculator" method="calcGrad" returnvariable="gradInitialPayAmt">
															<cfinvokeargument name="loanterm" value="#cloanterm#">
															<cfinvokeargument name="leadid" value="#leaddetail.leadid#">
														</cfinvoke>
															
														<!--- Extended Graduated --->
														<cfinvoke component="apis.com.calculator.studentloancalculator" method="calcExtGrad" returnvariable="strExtGrad">
															<cfinvokeargument name="loanterm" value="#cloanterm#">
															<cfinvokeargument name="leadid" value="#leaddetail.leadid#">
														</cfinvoke>
														
														<!--- // end data components for calculators --->
													
														<cfoutput>	
														<br /><br />
														<!---
														<h5><i class="icon-folder-open"></i> <strong>Student Loan Debt Summary:</strong></h5>
																									
															
															<p><strong>Estimated Consolidation Interest Rate:</strong> #numberformat( cloaninfo.weightrate, '99.99' )#%</p>
															<p><strong>Estimated Total Loan Balances:</strong> #dollarformat( cloaninfo.totalloanamount )#</p>
															<p><strong>Total Loans for Consolidation:</strong> #numberformat( cloaninfo.totalloans, '99' )#</p>
															<p><strong>Total Education Indebtedness:</strong> #dollarformat( cloaninfo.totalloandebt )#</p>
														
															<br />
														--->
															<p><h5><i class="icon-money"></i><strong> View Consolidation Repayment Options:</strong></h5></p>
																
																
																												
																	<table class="table table-bordered table-striped table-highlight">
																		<thead>
																			<tr>																			
																				<th>Repayment Plan</th>
																				<th>Months in Repayment</th>
																				<th>Monthly Payment</th>
																				<th>Total Payments</th>
																				<!---<th>Details</th>--->
																			</tr>
																		</thead>
																		<tbody>
																			<!--- // standard repayment --->																
																			<tr>																																							
																				<td>Standard</td>
																				<td>#cloanterm#</td>
																				<td>#dollarformat( monthlyPaymentStd )#</td>
																				<td>#dollarformat( monthlyPaymentStd * cloanterm )#</td>
																				<!---<td><span class="label label-default">View Detail</span></td>--->
																			</tr>																	
																			
																			<!--- graduated --->																				
																			<tr>																																					
																				<td>Graduated</td>
																				<td>#cloanterm#</td>
																				<td>#dollarformat( gradInitialPayAmt )#  <span style="margin-left:7px;" class="label label-important">See Note 1</span></td>
																				<td>#dollarformat( ( gradInitialPayAmt * cloanterm )  / 0.64  )#</td>
																				<!---<td><span class="label label-default">View Detail</span>&nbsp;<span class="label label-inverse">See Note 1</span></td>--->
																			</tr>
																			<!--- // extended --->
																			<cfif cloaninfo.totalloanamount GT 30000 >
																			<tr>																																								
																				<td>Extended</td>
																				<td>#mExtPay.mExtTerm#</td>
																				<td>#dollarformat( mExtPay.mExtPayAmt )#</td>
																				<td>#dollarformat( mExtPay.mExtPayAmt * mExtPay.mExtTerm )#</td>
																				<!---<td><span class="label label-default">View Detail</span></td>--->
																			</tr>
																			<!--- // extended graduated --->
																			<tr>																																							
																				<td>Extended Graduated</td>
																				<td>#strExtGrad.newloanterm#</td>
																				<td>#dollarformat( strExtGrad.gradExtInitialPayAmt )#  <span style="margin-left:7px;" class="label label-important">See Note 2</span></td>
																				<td>#dollarformat( strExtGrad.gradExtInitialPayAmt * strExtGrad.newloanterm )#</td>
																				<!---<td><span class="label label-default">View Detail</span></td>--->
																			</tr>
																			</cfif>																			
																			<!--- // income contingent --->
																			<tr>																																							
																				<td>Income Contingent</td>
																				<td><span class="label label-warning">See Note 2</span></td>
																				<td>#dollarformat( monthlyPaymentICR )#</td>
																				<td>#dollarformat( monthlyPaymentICR * 300 )#</td>
																				<!---<td><cfif qualifythisclient is true><span class="label label-default">View Detail</span><cfelse><span class="label label-important">Not Qualified</span></cfif></td>--->
																			</tr>
																			<!--- // income based --->
																			<cfif not listcontains( pplus, "T", ",") and not listcontains( pplus, "U", ",") and not listcontains( pplus, "X", ",")>
																				<cfif mIBR.mIBRPayAmt LTE mIBR.mIBRStd>
																					<tr>																																							
																						<td>Income Based</td>
																						<td><span class="label label-warning">See Note 2</span></td>
																						<td>#dollarformat( mIBR.mIBRPayAmt )#</td>
																						<td>#dollarformat( mIBR.mIBRPayAmt * 300 )#</td>
																						<!---<td><cfif qualifythisclient is true><span class="label label-default">View Detail</span><cfelse><span class="label label-important">Not Qualified</span></cfif></td>--->
																					</tr>
																				</cfif>
																				<!--- // pay as you earn --->
																					<tr>																																								
																						<td>Pay As You Earn</td>
																						<td><span class="label label-warning">See Note 2</span>  <span style="margin-left:7px;" class="label label-inverse">See Note 4</span></td>
																						<td>#dollarformat( mIBR.mIBRPAYE )#</td>
																						<td>#dollarformat( mIBR.mIBRPAYE * 300 )#</td>
																						<!---<td><span class="label label-default">View Detail</span></td>--->
																					</tr>
																			</cfif>
																		</tbody>
																	</table>									
																</form>

																
															</cfoutput>
													
															<br />
														
															<div class="well" style="padding:15px;">
																<span class="small">
																<p><strong>Note 1:</strong>
																This is an estimated monthly payment amount for the first two years of the term. The monthly payment amount generally will increase every two years, based on a gradation factor. 
																</p>						  
																						  
																<p><strong>Note 2:</strong>	
																This is an estimated repayment amount for the first year and total loan payment, based on the information you provided. 
																This repayment amount will be recalculated annually based on your income (and the Poverty Guidelines for your family size as determined by the U.S Dept of Health & Human Service for ICR and your family size for IBR). 
																The ICR and IBR Plans have a maximum term of 25 years.
																</p>													
																						  
																<p><strong>Note 3:</strong>
																You are not eligible for the IBR Plan because you included ineligible PLUS loans. If you want to repay under the IBR Plan, you need to exclude your parent PLUS Loan(s).
																</p>

																<p><strong>Note 4:</strong>
																A borrower is only eligible for Pay As You Earn if your loan originated on or after October 1st, 2011.  The borrower must not have a balance on any existing student loans that originated before October 1st, 2007.
																</p>
																</small>
															</div>
													
													
													</cfif>
												
												
											
											<cfelse>
											
												<div class="alert alert-info">
													<button type="button" class="close" data-dismiss="alert">&times;</button>
													<strong><i class="icon-warning-sign"></i> NO SOLUTIONS FOUND!</strong>  Sorry, no student loan solutions have been saved.  Please navigate to the option tree to get started browsing solutions....
												</div>
												
												
												<cfoutput>
													<a href="#application.root#?event=page.tree" class="btn btn-medium btn-secondary"><i class="icon-sitemap"></i> View Option Tree</a>&nbsp;&nbsp;<a href="#application.root#?event=page.survey" class="btn btn-medium btn-primary"><i class="icon-question-sign"></i> Go to Questionnaire</a><cfif completedsolutions.recordcount gt 0>&nbsp;&nbsp;<a href="#application.root#?event=page.solution.final" class="btn btn-medium btn-default"><i class="icon-book"></i> Previously Completed Solutions</a></cfif>
												</cfoutput>
											
											</cfif>
											
										
										
										</div> <!-- /pricing-plans -->
									

									<div class="clear"></div>
								</div> <!-- //.widget-content -->	
									
							</div> <!-- //.widget -->
							
						</div> <!-- //.span12 -->
						
					</div> <!-- //.row -->				
				
					<cfif solutionlist.recordcount lt 5>
					<div style="height:450px;"></div>							
					<cfelse>
					<div style="height:150px;"></div>
					</cfif>
				</div> <!-- //.container -->
			
			</div> <!-- //.main -->