
			
			
			<!--- // include our data components and api --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>			
			
			<cfinvoke component="apis.com.clients.clientgateway" method="getclientsurvey" returnvariable="clientsurvey">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.clients.clientgateway" method="checkforsurvey" returnvariable="checksurvey">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.worksheets.worksheetgateway" method="getworksheets" returnvariable="worksheetlist">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			
			
			<!--- if the student loan questionnaire has not been completed - redirect to the survey page and display a message --->
			<cfif clientsurvey.recordcount eq 0 >
				<cflocation url="#application.root#?event=page.survey&msg=noq" addtoken="no">
			<cfelseif checksurvey.totalquestions gt 0>
				<cflocation url="#application.root#?event=page.survey&msg=noq" addtoken="no">
			<cfelseif worksheetlist.recordcount eq 0>
				<cflocation url="#application.root#?event=page.worksheet" addtoken="no">
			<cfelse>			
				<cfinvoke component="apis.com.trees.optiontree1" method="getoptiontree1" returnvariable="optiontree1">
					<cfinvokeargument name="leadid" value="#session.leadid#">
				</cfinvoke>
				<cfinvoke component="apis.com.trees.optiontree2" method="getoptiontree2" returnvariable="optiontree2">
					<cfinvokeargument name="leadid" value="#session.leadid#">
				</cfinvoke>
				<cfinvoke component="apis.com.trees.optiontree3" method="getoptiontree3" returnvariable="optiontree3">
					<cfinvokeargument name="leadid" value="#session.leadid#">
				</cfinvoke>				
				<cfinvoke component="apis.com.trees.optiontree4" method="getoptiontree4" returnvariable="optiontree4">
					<cfinvokeargument name="leadid" value="#session.leadid#">
				</cfinvoke>				
				<cfinvoke component="apis.com.trees.optiontree5" method="getoptiontree5" returnvariable="optiontree5">
					<cfinvokeargument name="leadid" value="#session.leadid#">
				</cfinvoke>				
				<cfinvoke component="apis.com.trees.optiontree6" method="getoptiontree6" returnvariable="optiontree6">
					<cfinvokeargument name="leadid" value="#session.leadid#">
				</cfinvoke>			
				<cfinvoke component="apis.com.trees.optiontree7" method="getoptiontree7" returnvariable="optiontree7">
					<cfinvokeargument name="leadid" value="#session.leadid#">
				</cfinvoke>			
			</cfif>
			
			
			<!--- // include the tree stylesheet --->
			<link href="./css/pages/plans.css" rel="stylesheet"> 
			<link href="./css/pages/pricing.css" rel="stylesheet">
			
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
							
							<div class="widget stacked">
								<cfoutput>
								<div class="widget-header">		
									<i class="icon-sitemap"></i>							
									<h3>Student Loan Option Tree for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
								</div> <!-- //.widget-header -->
								</cfoutput>
								<div class="widget-content">						
									<!---
									<div class="pricing-header">
													
										<h1><i class="icon-sitemap"></i> Student Loan Admin Option Tree</h1>
										<h2>Quickly find the right student loan solution based<br />on all of the data entered in the worksheet and questionnaire.</h2>
									</div> <!-- /.pricing-header -->
									--->			
										<div class="pricing-plans plans-4">										
											
											<div class="plan-container">
												<div class="plan stacked green">
													<div class="plan-header">
															
														<div class="plan-title">
															Direct Loans       		
														</div> <!-- /plan-title -->
														<!--	
														<div class="plan-price">
															<span class="note">$</span>15<span class="term">Per Month</span>
														</div>  /plan-price -->
															
													</div> <!-- /plan-header -->	        
													
													<cfparam name="subcat1c" default="">
													<cfset subcat1c = false />
													
													<cfif optiontree1.subcat1canceldeath is true >
														<cfset subcat1c = true />													
													<cfelseif optiontree1.subcat1cancelunpaid is true>
														<cfset subcat1c = true />
													<cfelseif optiontree1.subcat1cancel911 is true>
														<cfset subcat1c = true />
													<cfelseif optiontree1.subcat1cancelatb is true>
														<cfset subcat1c = true />
													<cfelseif optiontree1.subcat1cancelcs is true>
														<cfset subcat1c = true />
													<cfelseif optiontree1.subcat1cancelcert is true>
														<cfset subcat1c = true />
													<cfelseif optiontree1.subcat1canceldisable is true>
														<cfset subcat1c = true />
													</cfif>
													
													<cfparam name="subcat1f" default="">
													<cfset subcat1f = false />
													
													<cfif optiontree1.subcat1psforgive is true>
														<cfset subcat1f = true />
													<cfelseif optiontree1.subcat1tlforgive is true>
														<cfset subcat1f = true />
													</cfif>
													
													<cfparam name="subcat1d" default="">
													<cfset subcat1d = false />
													
													<cfif optiontree1.subcat1default is true>
														<cfset subcat1d = true />
													<cfelseif optiontree1.subcat1consol is "yes">
														<cfset subcat1d = true />
													<cfelseif optiontree1.subcat1rehab is "yes">
														<cfset subcat1d = true />
													<cfelseif optiontree1.subcat1wg is "yes">
														<cfset subcat1d = true />
													<cfelseif optiontree1.subcat1to is "yes">
														<cfset subcat1d = true />
													</cfif>
													
													<cfparam name="subcat1p" default="">
													<cfset subcat1p = false />
													
													<cfif optiontree1.subcat1postdefer is "yes">
														<cfset subcat1p = true />
													<cfelseif optiontree1.subcat1postforbear is "yes">
														<cfset subcat1p = true />
													</cfif>

													<cfparam name="subcat1o" default="">
													<cfset subcat1o = false />
													
													<cfif optiontree1.subcat1oic is true>
														<cfset subcat1o = true />
													</cfif>
													
													<cfparam name="subcat1b" default="">
													<cfset subcat1b = false />
													
													<cfif optiontree1.subcat1bk is true>
														<cfset subcat1b = true />
													</cfif>
													
													<div class="plan-features">
														<ul>
															<cfif optiontree1.subcat1 is true>
															
																<cfinvoke component="apis.com.worksheets.worksheetgateway" method="getloansfortree" returnvariable="treeloans">
																	<cfinvokeargument name="leadid" value="#session.leadid#">
																	<cfinvokeargument name="loancodes" value="D,L,I,AC,AD">
																</cfinvoke>
																
																<li>Show eligible loans <a href="javascript:;" rel="popover" data-original-title="Direct Loans" data-html="true" data-content="<cfif treeloans.recordcount gt 0><cfoutput query="treeloans"><li><cfif servid eq -1>#nslservicer#<cfelse>#servname#</cfif> - #acctnum# - #dollarformat( loanbalance )#</li></cfoutput><cfelse>All eligible Direct Loans have already been marked completed. </cfif>"><i class="icon-info-sign"></i></a></li>
																<li><i class="icon-<cfif subcat1c is true>check<cfelse>check-empty</cfif>"></i> Cancellation</li>
																<li><i class="icon-<cfif subcat1f is true>check<cfelse>check-empty</cfif>"></i> Forgiveness</li>
																<li><i class="icon-<cfif subcat1d is true>check<cfelse>check-empty</cfif>"></i> Default Intervention</li>
																<li><i class="icon-check"></i> Repayment</li>
																<li><i class="icon-<cfif subcat1p is true>check<cfelse>check-empty</cfif>"></i> Postponement</li>
																<li><i class="icon-<cfif subcat1o is true>check<cfelse>check-empty</cfif>"></i> Offer in Compromise</li>
																<li><i class="icon-<cfif subcat1b is true>check<cfelse>check-empty</cfif>"></i> Bankruptcy</li>
															<cfelse>
																<li><span class="label label-important">No eligible loans found</span></li>
																<li><i class="icon-check-empty"></i> Cancellation</li>
																<li><i class="icon-check-empty"></i> Forgiveness</li>
																<li><i class="icon-check-empty"></i> Default Intervention</li>
																<li><i class="icon-check-empty"></i> Repayment</li>
																<li><i class="icon-check-empty"></i> Postponement</li>
																<li><i class="icon-check-empty"></i> Offer in Compromise</li>
																<li><i class="icon-check-empty"></i> Bankruptcy</li>
															</cfif>
														</ul>
													</div> <!-- /plan-features -->													
													
													<cfif optiontree1.subcat1 is true>
														<cfoutput>
														<div class="plan-actions">				
															<a href="#application.root#?event=#url.event#.direct" class="btn"><i class="icon-circle-arrow-right"></i>  Continue </a>				
														</div> <!-- /plan-actions -->
														</cfoutput>
													<cfelse>
														<div class="plan-actions">				
														<a href="javascript:;" class="btn"><i class="icon-remove-sign"></i>  Not Qualified </a>				
													</div> <!-- /plan-actions -->
													</cfif>													
											
												</div> <!-- /plan -->
											</div> <!-- /plan-container -->
												
												<div class="plan-container">
													<div class="plan stacked red">
														<div class="plan-header">
															
															<div class="plan-title">
																FFEL Loans        		
															</div> <!-- /plan-title -->															
															
														</div> <!-- /plan-header -->       
														
														<cfparam name="subcat2c" default="">
														<cfset subcat2c = false />
														
														<cfif optiontree2.subcat2canceldeath is true >
															<cfset subcat2c = true />													
														<cfelseif optiontree2.subcat2cancelunpaid is true>
															<cfset subcat2c = true />
														<cfelseif optiontree2.subcat2cancel911 is true>
															<cfset subcat2c = true />
														<cfelseif optiontree2.subcat2cancelatb is true>
															<cfset subcat2c = true />
														<cfelseif optiontree2.subcat2cancelcs is true>
															<cfset subcat2c = true />
														<cfelseif optiontree2.subcat2cancelcert is true>
															<cfset subcat2c = true />
														<cfelseif optiontree2.subcat2canceldisable is true>
															<cfset subcat2c = true />
														</cfif>
														
														<cfparam name="subcat2f" default="">
														<cfset subcat2f = false />
														
														<cfif optiontree2.subcat2psforgive is true>
															<cfset subcat2f = true />
														<cfelseif optiontree2.subcat2tlforgive is true>
															<cfset subcat2f = true />
														</cfif>
														
														<cfparam name="subcat2d" default="">
														<cfset subcat2d = false />
														
														<cfif optiontree2.subcat2default is true>
															<cfset subcat2d = true />
														<cfelseif optiontree2.subcat2consol is true>
															<cfset subcat2d = true />
														<cfelseif optiontree2.subcat2rehab is "yes">
															<cfset subcat2d = true />
														<cfelseif optiontree2.subcat2wg is "yes">
															<cfset subcat2d = true />
														<cfelseif optiontree2.subcat2to is "yes">
															<cfset subcat2d = true />
														</cfif>
														
														<cfparam name="subcat2p" default="">
														<cfset subcat2p = false />
														
														<cfif optiontree2.subcat2postdefer is "yes">
															<cfset subcat2p = true />
														<cfelseif optiontree2.subcat2postforbear is "yes">
															<cfset subcat2p = true />
														</cfif>													
														
														<cfparam name="subcat2b" default="">
														<cfset subcat2b = false />
														
														<cfif optiontree2.subcat2bk is true>
															<cfset subcat2b = true />
														</cfif>
														
														<cfparam name="subcat2o" default="">
														<cfset subcat2o = false />
														
														<cfif optiontree2.subcat2oic is true>
															<cfset subcat2o = true />
														</cfif>
														
														<div class="plan-features">
															<ul>
																<cfif optiontree2.subcat2 is true>
																	
																	<cfinvoke component="apis.com.worksheets.worksheetgateway" method="getloansfortree" returnvariable="treeloans">
																		<cfinvokeargument name="leadid" value="#session.leadid#">
																		<cfinvokeargument name="loancodes" value="A,B,C,G,H,O,P,S,J,AB,AF">
																	</cfinvoke>
																
																	<li>Show eligible loans <a href="" rel="popover" data-original-title="FFEL Loans" data-html="true" data-content="<cfif treeloans.recordcount gt 0><cfoutput query="treeloans"><li><cfif servid eq -1>#nslservicer#<cfelse>#servname#</cfif> - #acctnum# - #dollarformat( loanbalance )#</li></cfoutput><cfelse>All eligible FFEL Loans have already been marked completed.</cfif>"><i class="icon-info-sign"></i></a></li>
																
																	<li><i class="icon-<cfif subcat2c is true>check<cfelse>check-empty</cfif>"></i> Cancellation</li>
																	<li><i class="icon-<cfif subcat2f is true>check<cfelse>check-empty</cfif>"></i> Forgiveness</li>
																	<li><i class="icon-<cfif subcat2d is true>check<cfelse>check-empty</cfif>"></i> Default Intervention</li>
																	<li><i class="icon-check"></i> Repayment</li>
																	<li><i class="icon-<cfif subcat2p is true>check<cfelse>check-empty</cfif>"></i> Postponement</li>
																	<li><i class="icon-<cfif subcat2o is true>check<cfelse>check-empty</cfif>"></i> Offer in Compromise</li>
																	<li><i class="icon-<cfif subcat2b is true>check<cfelse>check-empty</cfif>"></i> Bankruptcy</li>
																<cfelse>
																	<li><span class="label label-important">No eligible loans found</span></li>
																	<li><i class="icon-check-empty"></i> Cancellation</li>
																	<li><i class="icon-check-empty"></i> Forgiveness</li>
																	<li><i class="icon-check-empty"></i> Default Intervention</li>
																	<li><i class="icon-check-empty"></i> Repayment</li>
																	<li><i class="icon-check-empty"></i> Postponement</li>
																	<li><i class="icon-check-empty"></i> Offer in Compromise</li>
																	<li><i class="icon-check-empty"></i> Bankruptcy</li>
																</cfif>
															</ul>
														</div> <!-- /plan-features -->
														
														<cfif optiontree2.subcat2 is true>
															<cfoutput>
															<div class="plan-actions">				
																<a href="#application.root#?event=#url.event#.ffel" class="btn"><i class="icon-circle-arrow-right"></i>  Continue </a>				
															</div> <!-- /plan-actions -->
															</cfoutput>
														<cfelse>
															<div class="plan-actions">				
															<a href="javascript:;" class="btn"><i class="icon-remove-sign"></i>  Not Qualified </a>				
														</div> <!-- /plan-actions -->
														</cfif>
											
													</div> <!-- /plan -->
												</div> <!-- /plan-container -->
												
												<div class="plan-container">
													<div class="plan stacked orange">
														<div class="plan-header">
															
															<div class="plan-title">
																Perkins/Need Based Loans	        		
															</div> <!-- /plan-title -->
															<!--
															<div class="plan-price">
																<span class="note">$</span>75<span class="term">Per Month</span>
															</div>  /plan-price -->
															
														</div> <!-- /plan-header -->	          
														
														<cfparam name="subcat3c" default="">
														<cfset subcat3c = false />
														
														<cfif optiontree3.subcat3canceldeath is true >
															<cfset subcat3c = true />													
														<cfelseif optiontree3.subcat3cancel911 is true>
															<cfset subcat3c = true />													
														<cfelseif optiontree3.subcat3cancelcs is true>
															<cfset subcat3c = true />												
														<cfelseif optiontree3.subcat3canceldisable is true>
															<cfset subcat3c = true />
														</cfif>
														
														<cfparam name="subcat3f" default="">
														<cfset subcat3f = false />
														
														<cfif optiontree3.subcat3ocforgive is true>
															<cfset subcat3f = true />
														<cfelseif optiontree3.subcat3ocforgive is true>
															<cfset subcat3f = true />
														</cfif>
														
														<cfparam name="subcat3d" default="">
														<cfset subcat3d = false />														
														
														<cfif optiontree3.subcat3consol is "yes">
															<cfset subcat3d = true />
														<cfelseif optiontree3.subcat3rehab is "yes">
															<cfset subcat3d = true />
														<cfelse>
															<cfset subcat3d = false />
														</cfif>
														
														<cfparam name="subcat2p" default="">
														<cfset subcat2p = false />
														
														<cfif optiontree3.subcat3postdefer is "yes">
															<cfset subcat3p = true />
														<cfelseif optiontree3.subcat3forbear is "yes">
															<cfset subcat3p = true />
														<cfelse>
															<cfset subcat3p = false />
														</cfif>													
														
														<cfparam name="subcat3b" default="">
														<cfset subcat3b = false />
														
														<cfif optiontree3.subcat3bk is true>
															<cfset subcat3b = true />
														</cfif>
														
														<cfparam name="subcat3o" default="">
														<cfset subcat3o = false />
														
														<cfif optiontree3.subcat3oic is true>
															<cfset subcat3o = true />
														</cfif>
														
														<div class="plan-features">
															<ul>
																<cfif optiontree3.subcat3 is true>
																
																	<cfinvoke component="apis.com.worksheets.worksheetgateway" method="getloansfortree" returnvariable="treeloans">
																		<cfinvokeargument name="leadid" value="#session.leadid#">
																		<cfinvokeargument name="loancodes" value="F,M,N,AE">
																	</cfinvoke>
																
																	<li>Show eligible loans <a href="" rel="popover" data-original-title="Perkins Loans" data-html="true" data-content="<cfif treeloans.recordcount gt 0><cfoutput query="treeloans"><li><cfif servid eq -1>#nslservicer#<cfelse>#servname#</cfif> - #acctnum# - #dollarformat( loanbalance )#</li></cfoutput><cfelse>All eligible Perkins Loans have already been marked completed.</cfif>"><i class="icon-info-sign"></i></a></li>
																
																
																	<li><i class="icon-<cfif subcat3c is true>check<cfelse>check-empty</cfif>"></i> Cancellation</li>
																	<li><i class="icon-<cfif subcat3f is true>check<cfelse>check-empty</cfif>"></i> Forgiveness</li>
																	<li><i class="icon-<cfif subcat3d is true>check<cfelse>check-empty</cfif>"></i> Default Intervention</li>
																	<li><i class="icon-check"></i> Repayment</li>
																	<li><i class="icon-<cfif subcat3p is true>check<cfelse>check-empty</cfif>"></i> Postponement</li>
																	<li><i class="icon-<cfif subcat3o is true>check<cfelse>check-empty</cfif>"></i> Offer in Compromise</li>
																	<li><i class="icon-<cfif subcat3b is true>check<cfelse>check-empty</cfif>"></i> Bankruptcy</li>
																<cfelse>
																	<li><span class="label label-important">No eligible loans found</span></li>
																	<li><i class="icon-check-empty"></i> Cancellation</li>
																	<li><i class="icon-check-empty"></i> Forgiveness</li>
																	<li><i class="icon-check-empty"></i> Default Intervention</li>
																	<li><i class="icon-check-empty"></i> Repayment</li>
																	<li><i class="icon-check-empty"></i> Postponement</li>
																	<li><i class="icon-check-empty"></i> Offer in Compromise</li>
																	<li><i class="icon-check-empty"></i> Bankruptcy</li>
																</cfif>
															</ul>
														</div> <!-- /plan-features -->
														
														<cfif optiontree3.subcat3 is true>
															<cfoutput>
															<div class="plan-actions">				
																<a href="#application.root#?event=#url.event#.perkins" class="btn"><i class="icon-circle-arrow-right"></i>  Continue </a>				
															</div> <!-- /plan-actions -->
															</cfoutput>
														<cfelse>
															<div class="plan-actions">				
															<a href="javascript:;" class="btn"><i class="icon-remove-sign"></i>  Not Qualified </a>				
														</div> <!-- /plan-actions -->
														</cfif>
											
													</div> <!-- /plan -->
												</div> <!-- /plan-container -->
												
												<div class="plan-container">
													<div class="plan stacked skyblue">
														<div class="plan-header">
															
															<div class="plan-title">
																Direct Consolidation Loans        		
															</div> <!-- /plan-title -->
															
															<!--
															<div class="plan-price">
																<span class="note">$</span>125<span class="term">Per Month</span>
															</div> /plan-price -->
															
														</div> <!-- /plan-header -->	       
														
														<cfparam name="subcat4c" default="">
														<cfset subcat4c = false />
														
														<cfif optiontree4.subcat4canceldeath is true >
															<cfset subcat4c = true />													
														<cfelseif optiontree4.subcat4cancelunpaid is true>
															<cfset subcat4c = true />
														<cfelseif optiontree4.subcat4cancel911 is true>
															<cfset subcat4c = true />
														<cfelseif optiontree4.subcat4cancelatb is true>
															<cfset subcat4c = true />
														<cfelseif optiontree4.subcat4cancelcs is true>
															<cfset subcat4c = true />
														<cfelseif optiontree4.subcat4cancelcert is true>
															<cfset subcat4c = true />
														<cfelseif optiontree4.subcat4canceldisable is true>
															<cfset subcat4c = true />
														</cfif>
														
														<cfparam name="subcat4f" default="">
														<cfset subcat4f = false />
														
														<cfif optiontree4.subcat4psforgive is true>
															<cfset subcat4f = true />
														<cfelseif optiontree4.subcat4tlforgive is true>
															<cfset subcat4f = true />
														</cfif>
														
														<cfparam name="subcat4d" default="">
														<cfset subcat4d = false />
														
														<cfif optiontree4.subcat4default is true>
															<cfset subcat4d = true />
														<cfelseif optiontree4.subcat4consol is true>
															<cfset subcat4d = true />
														<cfelseif optiontree4.subcat4rehab is "yes">
															<cfset subcat4d = true />
														<cfelseif optiontree4.subcat4wg is "yes">
															<cfset subcat4d = true />
														<cfelseif optiontree4.subcat4to is "yes">
															<cfset subcat4d = true />
														</cfif>
														
														<cfparam name="subcat4p" default="">
														<cfset subcat4p = false />
														
														<cfif optiontree4.subcat4postdefer is "yes">
															<cfset subcat4p = true />
														<cfelseif optiontree4.subcat4postforbear is "yes">
															<cfset subcat4p = true />
														</cfif>													
														
														<cfparam name="subcat4b" default="">
														<cfset subcat4b = false />
														
														<cfif optiontree4.subcat4bk is true>
															<cfset subcat4b = true />
														</cfif>
														
														<cfparam name="subcat4o" default="">
														<cfset subcat4o = false />
														
														<cfif optiontree4.subcat4oic is true>
															<cfset subcat4o = true />
														</cfif>
														
														<div class="plan-features" disabled>
															<ul>
																<cfif optiontree4.subcat4 is true>
																
																	<cfinvoke component="apis.com.worksheets.worksheetgateway" method="getloansfortree" returnvariable="treeloans">
																		<cfinvokeargument name="leadid" value="#session.leadid#">
																		<cfinvokeargument name="loancodes" value="E,K,V">
																	</cfinvoke>
																
																	<li>Show eligible loans <a href="" rel="popover" data-original-title="Direct Consolidation Loans" data-html="true" data-content="<cfif treeloans.recordcount gt 0><cfoutput query="treeloans"><li><cfif servid eq -1>#nslservicer#<cfelse>#servname#</cfif> - #acctnum# - #dollarformat( loanbalance )#</li></cfoutput><cfelse>All eligible Direct Consolidation Loans have already been marked completed.</cfif>"><i class="icon-info-sign"></i></a></li>
																
																
																	<li><i class="icon-<cfif subcat4c is true>check<cfelse>check-empty</cfif>"></i> Cancellation</li>
																	<li><i class="icon-<cfif subcat4f is true>check<cfelse>check-empty</cfif>"></i> Forgiveness</li>
																	<li><i class="icon-<cfif subcat4d is true>check<cfelse>check-empty</cfif>"></i> Default Intervention</li>
																	<li><i class="icon-check"></i> Repayment</li>
																	<li><i class="icon-<cfif subcat4p is true>check<cfelse>check-empty</cfif>"></i> Postponement</li>
																	<li><i class="icon-<cfif subcat4o is true>check<cfelse>check-empty</cfif>"></i> Offer in Compromise</li>
																	<li><i class="icon-<cfif subcat4b is true>check<cfelse>check-empty</cfif>"></i> Bankruptcy</li>
																<cfelse>
																	<li><span class="label label-important">No eligible loans found</span></li>
																	<li><i class="icon-check-empty"></i> Cancellation</li>
																	<li><i class="icon-check-empty"></i> Forgiveness</li>
																	<li><i class="icon-check-empty"></i> Default Intervention</li>
																	<li><i class="icon-check-empty"></i> Repayment</li>
																	<li><i class="icon-check-empty"></i> Postponement</li>
																	<li><i class="icon-check-empty"></i> Offer in Compromise</li>
																	<li><i class="icon-check-empty"></i> Bankruptcy</li>
																</cfif>
															</ul>
														</div> <!-- /plan-features -->
														
														<cfif optiontree4.subcat4 is true>
															<cfoutput>
															<div class="plan-actions">				
																<a href="#application.root#?event=#url.event#.consol" class="btn"><i class="icon-circle-arrow-right"></i>  Continue </a>				
															</div> <!-- /plan-actions -->
															</cfoutput>
														<cfelse>
															<div class="plan-actions">				
															<a href="javascript:;" class="btn"><i class="icon-remove-sign"></i>  Not Qualified </a>				
														</div> <!-- /plan-actions -->
														</cfif>
											
													</div> <!-- /plan -->
													
												</div> <!-- /plan-container -->
												
												<div class="plan-container">
													<div class="plan stacked black">
														<div class="plan-header">
															
															<div class="plan-title">
																Health Professional Loans       		
															</div> <!-- /plan-title -->
															
															<!--
															<div class="plan-price">
																<span class="note">$</span>125<span class="term">Per Month</span>
															</div> /plan-price -->
															
														</div> <!-- /plan-header -->	       
														
														<cfparam name="subcat5c" default="">
														<cfset subcat5c = false />
														
														<cfif optiontree5.subcat5canceldeath is true >
															<cfset subcat5c = true />														
														<cfelseif optiontree5.subcat5canceldisable is true>
															<cfset subcat5c = true />
														</cfif>
														
														<cfparam name="subcat5f" default="">
														<cfset subcat5f = false />
														
														<cfif optiontree5.subcat5psforgive is true>
															<cfset subcat5f = true />														
														</cfif>
														
														<cfparam name="subcat5d" default="">
														<cfset subcat5d = false />
														
														<cfif optiontree5.subcat5default is true>
															<cfset subcat5d = true />
														<cfelseif optiontree5.subcat5consol is "yes">
															<cfset subcat5d = true />
														<cfelseif optiontree5.subcat5rehab is "yes">
															<cfset subcat5d = true />
														</cfif>
														
														<cfparam name="subcat5p" default="">
														<cfset subcat5p = false />
														
														<cfif optiontree5.subcat5postdefer is "yes">
															<cfset subcat5p = true />
														<cfelseif optiontree5.subcat5forbear is "yes">
															<cfset subcat5p = true />
														</cfif>													
														
														<cfparam name="subcat5b" default="">
														<cfset subcat5b = false />
														
														<cfif optiontree5.subcat5bk is true>
															<cfset subcat5b = true />
														</cfif>
														
														<cfparam name="subcat5o" default="">
														<cfset subcat5o = false />
														
														<cfif optiontree5.subcat5oic is true>
															<cfset subcat5o = true />
														</cfif>
														
														<div class="plan-features">
															<ul>
																<cfif optiontree5.subcat5 is true>
																
																	<cfinvoke component="apis.com.worksheets.worksheetgateway" method="getloansfortree" returnvariable="treeloans">
																		<cfinvokeargument name="leadid" value="#session.leadid#">
																		<cfinvokeargument name="loancodes" value="Q,R,Y,Z">
																	</cfinvoke>
																
																	<li>Show eligible loans <a href="" rel="popover" data-original-title="Health Professional Loans" data-html="true" data-content="<cfif treeloans.recordcount gt 0><cfoutput query="treeloans"><li><cfif servid eq -1>#nslservicer#<cfelse>#servname#</cfif> - #acctnum# - #dollarformat( loanbalance )#</li></cfoutput><cfelse>All eligible Health Professional Loans have already been marked completed.</cfif>"><i class="icon-info-sign"></i></a></li>
																
																
																	<li><i class="icon-<cfif subcat5c is true>check<cfelse>check-empty</cfif>"></i> Cancellation</li>
																	<li><i class="icon-<cfif subcat5f is true>check<cfelse>check-empty</cfif>"></i> Forgiveness</li>
																	<li><i class="icon-<cfif subcat5d is true>check<cfelse>check-empty</cfif>"></i> Default Intervention</li>
																	<li><i class="icon-check"></i> Repayment</li>
																	<li><i class="icon-<cfif subcat5p is true>check<cfelse>check-empty</cfif>"></i> Postponement</li>
																	<li><i class="icon-<cfif subcat5o is true>check<cfelse>check-empty</cfif>"></i> Offer in Compromise</li>
																	<li><i class="icon-<cfif subcat5b is true>check<cfelse>check-empty</cfif>"></i> Bankruptcy</li>
																<cfelse>
																	<li><span class="label label-important">No eligible loans found</span></li>
																	<li><i class="icon-check-empty"></i> Cancellation</li>
																	<li><i class="icon-check-empty"></i> Forgiveness</li>
																	<li><i class="icon-check-empty"></i> Default Intervention</li>
																	<li><i class="icon-check-empty"></i> Repayment</li>
																	<li><i class="icon-check-empty"></i> Postponement</li>
																	<li><i class="icon-check-empty"></i> Offer in Compromise</li>
																	<li><i class="icon-check-empty"></i> Bankruptcy</li>
																</cfif>
															</ul>
														</div> <!-- /plan-features -->
														
														<cfif optiontree5.subcat5 is true>
															<cfoutput>
															<div class="plan-actions">				
																<a href="#application.root#?event=#url.event#.healthpro" class="btn"><i class="icon-circle-arrow-right"></i>  Continue </a>				
															</div> <!-- /plan-actions -->
															</cfoutput>
														<cfelse>
															<div class="plan-actions">				
															<a href="javascript:;" class="btn"><i class="icon-remove-sign"></i>  Not Qualified </a>				
														</div> <!-- /plan-actions -->
														</cfif>
											
													</div> <!-- /plan -->
													
												</div> <!-- /plan-container -->
												
												
												<div class="plan-container">
													<div class="plan stacked lavendar">
														<div class="plan-header">
															
															<div class="plan-title">
																Parent PLUS Loans        		
															</div> <!-- /plan-title -->
															
															<!--
															<div class="plan-price">
																<span class="note">$</span>125<span class="term">Per Month</span>
															</div> /plan-price -->
															
														</div> <!-- /plan-header -->	       
														
														<cfparam name="subcat6c" default="">
														<cfset subcat6c = false />
														
														<cfif optiontree6.subcat6canceldeath is true >
															<cfset subcat6c = true />													
														<cfelseif optiontree6.subcat6cancelunpaid is true>
															<cfset subcat6c = true />
														<cfelseif optiontree6.subcat6cancel911 is true>
															<cfset subcat6c = true />
														<cfelseif optiontree6.subcat6cancelatb is true>
															<cfset subcat6c = true />
														<cfelseif optiontree6.subcat6cancelcs is true>
															<cfset subcat6c = true />
														<cfelseif optiontree6.subcat6cancelcert is true>
															<cfset subcat6c = true />
														<cfelseif optiontree6.subcat6canceldisable is true>
															<cfset subcat6c = true />
														</cfif>
														
														<cfparam name="subcat6f" default="">
														<cfset subcat6f = false />
														
														<cfif optiontree6.subcat6psforgive is true>
															<cfset subcat6f = true />
														<cfelseif optiontree6.subcat6tlforgive is true>
															<cfset subcat6f = true />
														</cfif>
														
														<cfparam name="subcat6d" default="">
														<cfset subcat6d = false />
														
														<cfif optiontree6.subcat6default is true>
															<cfset subcat6d = true />
														<cfelseif optiontree6.subcat6consol is true>
															<cfset subcat6d = true />
														<cfelseif optiontree6.subcat6rehab is "yes">
															<cfset subcat6d = true />
														<cfelseif optiontree6.subcat6wg is "yes">
															<cfset subcat6d = true />
														<cfelseif optiontree6.subcat6to is "yes">
															<cfset subcat6d = true />
														</cfif>
														
														<cfparam name="subcat6p" default="">
														<cfset subcat6p = false />
														
														<cfif optiontree6.subcat6postdefer is "yes">
															<cfset subcat6p = true />
														<cfelseif optiontree6.subcat6postforbear is "yes">
															<cfset subcat6p = true />
														</cfif>													
														
														<cfparam name="subcat6b" default="">
														<cfset subcat6b = false />
														
														<cfif optiontree6.subcat6bk is true>
															<cfset subcat6b = true />
														</cfif>
														
														<cfparam name="subcat6o" default="">
														<cfset subcat6o = false />
														
														<cfif optiontree6.subcat6oic is true>
															<cfset subcat6o = true />
														</cfif>
														
														<div class="plan-features">
															<ul>
																<cfif optiontree6.subcat6 is true>
																
																	<cfinvoke component="apis.com.worksheets.worksheetgateway" method="getloansfortree" returnvariable="treeloans">
																		<cfinvokeargument name="leadid" value="#session.leadid#">
																		<cfinvokeargument name="loancodes" value="T,U,X">
																	</cfinvoke>
																
																	<li>Show eligible loans <a href="" rel="popover" data-original-title="Parent PLUS Loans" data-html="true" data-content="<cfif treeloans.recordcount gt 0><cfoutput query="treeloans"><li><cfif servid eq -1>#nslservicer#<cfelse>#servname#</cfif> - #acctnum# - #dollarformat( loanbalance )#</li></cfoutput><cfelse>All eligible Parent PLUS Loans have already been marked completed.</cfif>"><i class="icon-info-sign"></i></a></li>
																
																	<li><i class="icon-<cfif subcat6c is true>check<cfelse>check-empty</cfif>"></i> Cancellation</li>
																	<li><i class="icon-<cfif subcat6f is true>check<cfelse>check-empty</cfif>"></i> Forgiveness</li>
																	<li><i class="icon-<cfif subcat6d is true>check<cfelse>check-empty</cfif>"></i> Default Intervention</li>
																	<li><i class="icon-check"></i> Repayment</li>
																	<li><i class="icon-<cfif subcat6p is true>check<cfelse>check-empty</cfif>"></i> Postponement</li>
																	<li><i class="icon-<cfif subcat6o is true>check<cfelse>check-empty</cfif>"></i> Offer in Compromise</li>
																	<li><i class="icon-<cfif subcat6b is true>check<cfelse>check-empty</cfif>"></i> Bankruptcy</li>
																<cfelse>
																	<li><span class="label label-important">No eligible loans found</span></li>
																	<li><i class="icon-check-empty"></i> Cancellation</li>
																	<li><i class="icon-check-empty"></i> Forgiveness</li>
																	<li><i class="icon-check-empty"></i> Default Intervention</li>
																	<li><i class="icon-check-empty"></i> Repayment</li>
																	<li><i class="icon-check-empty"></i> Postponement</li>
																	<li><i class="icon-check-empty"></i> Offer in Compromise</li>
																	<li><i class="icon-check-empty"></i> Bankruptcy</li>
																</cfif>
															</ul>
														</div> <!-- /plan-features -->
														
														<cfif optiontree6.subcat6 is true>
															<cfoutput>
															<div class="plan-actions">				
																<a href="#application.root#?event=#url.event#.plus" class="btn"><i class="icon-circle-arrow-right"></i>  Continue </a>				
															</div> <!-- /plan-actions -->
															</cfoutput>
														<cfelse>
															<div class="plan-actions">				
															<a href="javascript:;" class="btn"><i class="icon-remove-sign"></i>  Not Qualified </a>				
														</div> <!-- /plan-actions -->
														</cfif>
											
													</div> <!-- /plan -->
													
												</div> <!-- /plan-container -->
												
												<div class="plan-container">
													<div class="plan stacked teal">
														<div class="plan-header">
															
															<div class="plan-title">
																Private Loans     		
															</div> <!-- /plan-title -->
															
															<!--
															<div class="plan-price">
																<span class="note">$</span>125<span class="term">Per Month</span>
															</div> /plan-price -->
															
														</div> <!-- /plan-header -->	       
														
														<cfparam name="subcat7c" default="">
														<cfset subcat7c = false />														
														<cfif optiontree7.subcat7canceldeath is true>
															<cfset subcat7c = true />
														<cfelseif optiontree7.subcat7idtheft is true>														
															<cfset subcat7c = true />
														<cfelseif optiontree7.subcat7mixeduse is true>
															<cfset subcat7c = true />
														<cfelseif optiontree7.subcat7ftcrule is true>
															<cfset subcat7c = true />
														<cfelseif  optiontree7.subcat7legalage is true>
															<cfset subcat7c = true />
														</cfif>												
														
														<cfparam name="subcat7d" default="">
														<cfset subcat7d = false />														
														<cfif optiontree7.subcat7default is true>														
															<cfset subcat7d = true />
														<cfelseif optiontree7.subcat7validate is true>
															<cfset subcat7d = true />
														</cfif>																																		
														
														
														<cfparam name="subcat7b" default="">
														<cfset subcat7b = false />														
														<cfif optiontree7.subcat7bk is true>
															<cfset subcat7b = true />
														</cfif>
														
														<cfparam name="subcat7o" default="">
														<cfset subcat7o = false />
														<cfif optiontree7.subcat7oic is true >
															<cfset subcat7o = true />
														</cfif>
														
														<div class="plan-features">
															<ul>
																<cfif optiontree7.subcat7 is true>
																
																	<cfinvoke component="apis.com.worksheets.worksheetgateway" method="getloansfortree" returnvariable="treeloans">
																		<cfinvokeargument name="leadid" value="#session.leadid#">
																		<cfinvokeargument name="loancodes" value="AA">
																	</cfinvoke>
																
																	<li>Show eligible loans <a href="" rel="popover" data-original-title="Private Loans" data-html="true" data-content="<cfif treeloans.recordcount gt 0><cfoutput query="treeloans"><li><cfif servid eq -1>#nslservicer#<cfelse>#servname#</cfif> - #acctnum# - #dollarformat( loanbalance )#</li></cfoutput><cfelse>All eligible Private Loans have already been marked completed.</cfif>"><i class="icon-info-sign"></i></a></li>
																
																	<li><i class="icon-<cfif subcat7c is true>check<cfelse>check-empty</cfif>"></i> Cancellation</li>																	
																	<li><i class="icon-<cfif subcat7d is true>check<cfelse>check-empty</cfif>"></i> Default Intervention</li>
																	<li><i class="icon-check"></i> Repayment</li>
																	<li><i class="icon-check"></i> Postponement</li>
																	<li><i class="icon-<cfif subcat7o is true>check<cfelse>check-empty</cfif>"></i> Offer in Compromise</li>
																	<li><i class="icon-<cfif subcat7b is true>check<cfelse>check-empty</cfif>"></i> Bankruptcy</li>
																	<li>&nbsp;</li>
																<cfelse>																	
																	<li><span class="label label-important">No eligible loans found</span></li>
																	<li><i class="icon-check-empty"></i> Cancellation</li>																	
																	<li><i class="icon-check-empty"></i> Default Intervention</li>
																	<li><i class="icon-check-empty"></i> Repayment</li>
																	<li><i class="icon-check-empty"></i> Postponement</li>
																	<li><i class="icon-check-empty"></i> Offer in Compromise</li>
																	<li><i class="icon-check-empty"></i> Bankruptcy</li>
																	<li>&nbsp;</li>
																</cfif>
															</ul>
														</div> <!-- /plan-features -->
														
														<cfif optiontree7.subcat7 is true>
															<cfoutput>
															<div class="plan-actions">				
																<a href="#application.root#?event=#url.event#.private" class="btn"><i class="icon-circle-arrow-right"></i>  Continue </a>				
															</div> <!-- /plan-actions -->
															</cfoutput>
														<cfelse>
															<div class="plan-actions">				
															<a href="javascript:;" class="btn"><i class="icon-remove-sign"></i>  Not Qualified </a>				
														</div> <!-- /plan-actions -->
														</cfif>
											
													</div> <!-- /plan -->													
													
													
												</div> <!-- /plan-container -->										
										
											</div> <!-- /pricing-plans -->

											<!---// dump the trees 
											<cfdump var="#optiontree1#" label="FFEL - Option Tree 1">											
											<cfdump var="#optiontree3#" label="Perkins - Option Tree 3">
											--->
											
									<div class="clear"></div>
								</div> <!-- //.widget-content -->	

									
							</div> <!-- //.widget -->
							
						</div> <!-- //.span12 -->
						
					</div> <!-- //.row -->				
				
					<div style="height:100px;"></div>			
				
				</div> <!-- //.container -->
			
			</div> <!-- //.main -->