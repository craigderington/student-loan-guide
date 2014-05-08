






						
					<!doctype html>
					<html lang="en">
						<!--[if lt IE 7]> <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
						<!--[if IE 7]>    <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
						<!--[if IE 8]>    <html class="no-js lt-ie9" lang="en"> <![endif]-->
						<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
						<title>Standard Repayment Plan</title>
							
							<head>
								<meta charset="utf-8">
								<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
								<meta name="apple-mobile-web-app-capable" content="yes"> 
								<link href="../css/bootstrap.min.css" rel="stylesheet" type="text/css" />
								<link href="../css/bootstrap-responsive.min.css" rel="stylesheet" type="text/css" />				
								<link href="../css/font-awesome.min.css" rel="stylesheet">
								<link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Open+Sans:400italic,600italic,400,600" >				
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
											
											<!--- Standard --->
											<cfinvoke component="apis.com.calculator.slcalc" method="calcSTD" returnvariable="monthlyPaymentStd">
												<cfinvokeargument name="loanterm" value="#cloanterm#">
												<cfinvokeargument name="leadid" value="#leaddetail.leadid#">
											</cfinvoke>
											
											
											
									
									
									
									
									
									
									
									
									
									
									<div class="widget stacked">
										
										<div class="widget-header">		
											<i class="icon-money"></i>							
											<h3>Standard Repayment Plan</h3>						
										</div>				
										
										<div class="widget-content">						
											
											<h4>Standard Repayment Plan</h4>
											<p>You will pay a fixed amount each month until your loan(s) are paid in full.  Your monthly payments will be at least $50.00 for up to 30 years, based on your <strong>total education indebtedness</strong>.</p>
											<p>Use the estimated details shown below to compare this plan to other plans for which you are eligible.  If you have other outstanding education loans, be sure to consider the esimated monthly paymwents shown here for your Direct Consolidation Loan and your other education loan payments in order to select the plan that best fits your circumstances.  Remember that you can change repayments plans at any time.</p>
											
											
											<div class="span6">
												<h5 style="margin-top:25px;"><strong>Interest Rate - Consolidation Loan</strong></h5>
											
												<h5 style="margin-top:25px;"><strong>Total Loan Balances</strong></h5>
												<p>Total Consolidation Loan Amount</p>
												<p>Total Education Indebtedness</p>
											
												<h5 style="margin-top:25px;"><strong>Totals</strong></h5>
												<p>Months in Repayment<p>
												<p>Monthly Payment</p>
												<p>Total Interest Payments</p>
												<p>Total Loan Payments</p>
											</div>
											
											
											<div class="span4">
												<cfoutput>	
													<h5 style="margin-top:25px;">#numberformat( cloaninfo.weightrate, '99.99' )#%</h5>
													
													<h5 style="margin-top:25px;">&nbsp;</h5>
													<p>#dollarformat( cloaninfo.totalloanamount )#</p>
													<p>#dollarformat( cloaninfo.totalloandebt )#</p>
													
													<h5 style="margin-top:25px;">&nbsp;</h5>
													<p>#cloanterm#</p>
													<p>#dollarformat( monthlyPaymentStd )#</p>
													<p>#dollarformat( ( monthlyPaymentStd * cloanterm ) - cloaninfo.totalloanamount )#</p>
													<p>#dollarformat( monthlyPaymentStd * cloanterm )#</p>
												</cfoutput>
											</div>			
										</div><!-- / .widget-content -->										
									</div><!-- // .widget -->
									
									<a style=" margin-top:10px;" href="javascript:window.close();" class="btn btn-medium btn-secondary"><i class="icon-refresh"></i> Close Window</a>
									
									<!-- this is a commit change in github --->
									<!-- will it scan the directory for changes ?  -->
									
								</body>		
					</html>