






						
					<!doctype html>
					<html lang="en">
						<!--[if lt IE 7]> <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
						<!--[if IE 7]>    <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
						<!--[if IE 8]>    <html class="no-js lt-ie9" lang="en"> <![endif]-->
						<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
						<title>Income Based Repayment Plan (IBR)</title>
							
							<head>
								<meta charset="utf-8">
								<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
								<meta name="apple-mobile-web-app-capable" content="yes"> 
								<link href="../css/bootstrap.min.css" rel="stylesheet" type="text/css" />
								<link href="../css/bootstrap-responsive.min.css" rel="stylesheet" type="text/css" />				
								<link href="../css/font-awesome.min.css" rel="stylesheet">
								<link rel="stylesheet" type="text/css" href="//fonts.googleapis.com/css?family=Open+Sans:400italic,600italic,400,600" >				
								<link href="../css/ui-lightness/jquery-ui-1.10.0.custom.min.css" rel="stylesheet">				
								<link href="../css/base-admin-2.css" rel="stylesheet">
								<link href="../css/base-admin-2-responsive.css" rel="stylesheet">
								<link href="../css/pages/dashboard.css" rel="stylesheet">				
								<link href="../css/custom.css" rel="stylesheet">
								<link href="../css/pages/reports.css" rel="stylesheet">					
								
							<!--- // auto-refresh the parent window when the child window closes --->
							<script language="JavaScript">
								<!--
									function refreshParent() {
										window.opener.location.href = window.opener.location.href;

										  if (window.opener.progressWindow)
												
										 {
											window.opener.progressWindow.close()
										  }
										  window.close();
										}
										//-->
							</script>
							
							</head>
							
							
							
						
						
								<body style="padding:15px;">
								
										<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
											<cfinvokeargument name="leadid" value="#session.leadid#">
										</cfinvoke>
										
										<cfinvoke component="apis.com.leads.leadgateway" method="getleadsummary" returnvariable="leadsummary">
											<cfinvokeargument name="leadid" value="#session.leadid#">
										</cfinvoke>
									
										<!--- get the data access components --->
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
											
											
											
									
									
									
									
									
									
									
									
									
									
									<div class="widget stacked">
										
										<div class="widget-header">		
											<i class="icon-money"></i>							
											<h3>Income Based Repayment Plan (IBR)</h3>						
										</div>				
										
										<div class="widget-content">						
											
											<h4>Income Based Repayment Plan (IBR)</h4>
											
											<div class="alert alert-error alert-block">												
												<h6><strong><i class="icon-file-alt"></i> Special Note</strong></h6>
												<p>This is an estimated repayment amount for the first year and total loan payment, based on the information you provided. This repayment amount will be recalculated annually based on your income (and the Poverty Guidelines for your family size as determined by the U.S Dept of Health & Human Service for ICR and your family size for IBR). The ICR and IBR Plans have a maximum term of 25 years.</p>
											</div>
											
											
											<p>Income Based Repayment Plan: The Income Based Repayment Plan (IBR) gives you the flexibility to meet your Direct Loan obligations without undue financial hardship. Each year, your monthly payments will be recalculated on the basis of your annual income, family size and the total amount of your Direct Loans.</p>
											<p>You will pay an amount based on the Adjusted Gross Income (AGI) you report on your federal tax return, or, if you submit alternative documentation of income, you will pay an amount based on your current income. If you're married, the amount you pay will be based on your income and your spouse's income.</p>
																						
											<div class="span6">
												<h5 style="margin-top:25px;"><strong>Interest Rate - Consolidation Loan</strong></h5>
											
												<h5 style="margin-top:25px;"><strong>Total Consolidation Loan Amount</strong></h5>												
											
												<h5 style="margin-top:25px;"><strong>Totals</strong></h5>
												<p>Months in Repayment<p>
												<p>Monthly Payment</p>
												<p>Total Interest Payments</p>
												<p>Total Loan Payments</p>
											</div>
											
											
											<div class="span4">
												<cfoutput>	
													<h5 style="margin-top:25px;">#numberformat( cloaninfo.weightrate, '99.99' )#%</h5>
													
													<h5 style="margin-top:25px;">#dollarformat( cloaninfo.totalloanamount )#</h5>
																										
													<h5 style="margin-top:25px;">&nbsp;</h5>
													<p>#cloanterm#</p>
													<p>#dollarformat( mIBR.mIBRPayAmt )#</p>
													<p>#dollarformat( cloaninfo.totalloanamount  * ( cloaninfo.weightrate / 100.00 ) * ( cloanterm / 12 ) )#</p>
													<p>#dollarformat( cloaninfo.totalloanamount + ( cloaninfo.totalloanamount  * ( cloaninfo.weightrate / 100.00 ) * ( cloanterm / 12 ) )  )#</p>
												</cfoutput>
											</div>			
										</div><!-- / .widget-content -->										
									</div><!-- // .widget -->
									
									<a style=" margin-top:10px;" href="javascript:window.close();" class="btn btn-medium btn-secondary"><i class="icon-refresh"></i> Close Window</a>
									
									
									
								</body>		
					</html>