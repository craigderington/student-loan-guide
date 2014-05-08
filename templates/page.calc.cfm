


			<!--- // get our data access components --->
			
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.leads.leadgateway" method="getleadsummary" returnvariable="leadsummary">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.worksheets.worksheetgateway" method="getworksheets" returnvariable="worksheetlist">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			
			<cfif worksheetlist.recordcount eq 0>
				<cflocation url="#application.root#?event=page.worksheet" addtoken="no">
			</cfif>
			
			<!--- define some page vars --->
			<cfparam name="pplus" default="">			
			<cfset pplus = valuelist( worksheetlist.loancode ) />
			
			
			
			<!--- // the repayment calculator --->
			<div class="main">
			
				<div class="container">
					
					<div class="row">
						
						<div class="span12">
						
							<div class="widget">
								
								<cfoutput>
								<div class="widget-header">
									<i class="icon-money"></i>
									<h3>Student Loan Repayment Calculator &amp; Options for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>	
								</div>
								</cfoutput>
								
								
								<div class="widget-content">
							
										<cfinvoke component="apis.com.calculator.slloanoptions" method="getclientloaninfo" returnvariable="cloaninfo">
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
										<cfinvoke component="apis.com.calculator.slcalc" method="qualifyclient" returnvariable="qualifyThisClient">
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
										<cfinvoke component="apis.com.calculator.slcalc" method="calcIBR" returnvariable="mIBR">
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
										<cfinvoke component="apis.com.calculator.slcalc" method="calcICR" returnvariable="monthlyPaymentICR">
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
										<cfinvoke component="apis.com.calculator.slcalc" method="calcSTD" returnvariable="monthlyPaymentStd">
											<cfinvokeargument name="loanterm" value="#cloanterm#">
											<cfinvokeargument name="leadid" value="#leaddetail.leadid#">
										</cfinvoke>
																			
										<!--- Extended --->
										<cfinvoke component="apis.com.calculator.slcalc" method="calcExt" returnvariable="mExtPay">
											<cfinvokeargument name="loanterm" value="#cloanterm#">
											<cfinvokeargument name="leadid" value="#leaddetail.leadid#">
										</cfinvoke>															
										
										<!--- Graduated --->
										<cfinvoke component="apis.com.calculator.slcalc" method="calcGrad" returnvariable="gradInitialPayAmt">
											<cfinvokeargument name="loanterm" value="#cloanterm#">
											<cfinvokeargument name="leadid" value="#leaddetail.leadid#">
										</cfinvoke>
																		
										<!--- Extended Graduated --->
										<cfinvoke component="apis.com.calculator.slcalc" method="calcExtGrad" returnvariable="strExtGrad">
											<cfinvokeargument name="loanterm" value="#cloanterm#">
											<cfinvokeargument name="leadid" value="#leaddetail.leadid#">
										</cfinvoke>
																	
										<!--- // end data components for calculators --->
																
										
										

										<cfoutput>	
										
																	
										
										<h5><i class="icon-folder-open"></i> <strong>Student Loan Debt Summary:</strong></h5>
																												
																	
											<p><strong>Estimated Consolidation Interest Rate:</strong> #numberformat( cloaninfo.weightrate, '99.99' )#%</p>
											<p><strong>Estimated Total Loan Balances:</strong> #dollarformat( cloaninfo.totalloanamount )#</p>
											<p><strong>Total Loans for Consolidation:</strong> #numberformat( cloaninfo.totalloans, '99' )#</p>
											<p><strong>Total Education Indebtedness:</strong> #dollarformat( cloaninfo.totalloandebt )#</p>
											
											
										<br />
																	
										<p><h5><i class="icon-money"></i><strong> View Consolidation Repayment Options:</strong></h5></p>
																			
																			
																															
											<table class="table table-bordered table-striped table-highlight">
												<thead>
													<tr>																			
														<th>Repayment Plan</th>
														<th>Months in Repayment</th>
														<th>Monthly Payment</th>
														<th>Total Payments</th>
														<th>Details</th>
													</tr>
												</thead>
												<tbody>
																						
													<!--- // standard repayment --->															
													<tr>																																							
														<td>Standard</td>
														<td>#cloanterm#</td>
														<td>#dollarformat( monthlyPaymentStd )#</td>
														<td>#dollarformat( monthlyPaymentStd * cloanterm )#</td>
														<td><a href="javascript:;" onclick="window.open('templates/standardrepaymentplan.cfm','','scollbars=no,location=no,width=830,height=720');" class="label label-default">View Detail</a></td>
													</tr>																	
																						
													<!--- graduated --->																			
													<tr>																																					
														<td>Graduated</td>
														<td>#cloanterm#</td>
														<td>#dollarformat( gradInitialPayAmt )#</td>
														<td>#dollarformat( ( gradInitialPayAmt * cloanterm )  / 0.64  )#</td>
														<td><a href="javascript:;" onclick="window.open('','','');" class="label label-default">View Detail</a>&nbsp;<span class="label label-important">See Note 1</span></td>
													</tr>
													
													
													<!--- // extended --->
													<cfif cloaninfo.totalloanamount GT 30000 >
														<tr>																																								
															<td>Extended</td>
															<td>#mExtPay.mExtTerm#</td>
															<td>#dollarformat( mExtPay.mExtPayAmt )#</td>
															<td>#dollarformat( mExtPay.mExtPayAmt * mExtPay.mExtTerm )#</td>
															<td><a href="javascript:;" onclick="window.open('','','');" class="label label-default">View Detail</a></td>
														</tr>
																						
														<!--- // extended graduated --->
														<tr>																																							
															<td>Extended Graduated</td>
															<td>#strExtGrad.newloanterm#</td>
															<td>#dollarformat( strExtGrad.gradExtInitialPayAmt )#  <span style="margin-left:7px;" class="label label-important">See Note 2</span></td>
															<td>#dollarformat( strExtGrad.gradExtInitialPayAmt * strExtGrad.newloanterm )#</td>
															<td><a href="javascript:;" onclick="window.open('','','');" class="label label-default">View Detail</a></td>
														</tr>
													</cfif>																			
																			
													<!--- // income contingent --->
													<tr>																																							
														<td>Income Contingent</td>
														<td><span class="label label-warning">See Note 2</span></td>
														<td>#dollarformat( monthlyPaymentICR )#</td>
														<td>#dollarformat( cloaninfo.totalloanamount + ( monthlyPaymentICR * ( 300 / 12 ) * ( cloaninfo.weightrate / 100.00 ) ))#</td>
														<td><cfif qualifythisclient is true><a href="javascript:;" onclick="window.open('templates/icr-repaymentplan.cfm','','scollbars=no,location=no,width=830,height=720');" class="label label-default">View Detail</a><cfelse><span class="label label-important">Not Qualified</span></cfif></td>
													</tr>
																						
													<!--- // income based ---> 
													<cfif not listcontains( pplus, "T", ",") and not listcontains( pplus, "U", ",") and not listcontains( pplus, "X", ",")>
														<cfif mIBR.mIBRPayAmt LTE mIBR.mIBRStd>
															<tr>																																							
																<td>Income Based</td>
																<td><span class="label label-warning">See Note 2</span></td>
																<td>#dollarformat( mIBR.mIBRPayAmt )#</td>
																<td>#dollarformat( mIBR.mIBRPayAmt * 300 )#</td>
																<td><cfif qualifythisclient is true><cfif mIBR.mIBRPayAmt gt 0.00><a href="javascript:;" onclick="window.open('','','');" class="label label-default">View Detail</a></cfif><cfelse><span class="label label-important">Not Qualified</span></cfif></td>
															</tr>
														</cfif>
																						
														<!--- // pay as you earn --->
														<tr>																																								
															<td>Pay As You Earn</td>
															<td><span class="label label-warning">See Note 2</span>  <span style="margin-left:7px;" class="label label-inverse">See Note 4</span></td>
															<td>#dollarformat( mIBR.mIBRPAYE )#</td>
															<td>#dollarformat( mIBR.mIBRPAYE * 300 )#</td>
															<td><cfif mIBR.mIBRPAYE gt 0.00><a href="javascript:;" onclick="window.open('','','');" class="label label-default">View Detail</a></cfif></td>
														</tr>
													</cfif>
													
													
												</tbody>
												</table>									
												
													
																			
										</cfoutput>
																
										<br />
																	
											<h5><i class="icon-info-sign"></i> Repayment Calculator Special Notes</h5>
											
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
								
								</div><!--- / .widget-content --->
							</div><!--- / .widget --->
		
							
						</div>
						
						
					</div>
					
				</div>
			
			</div>