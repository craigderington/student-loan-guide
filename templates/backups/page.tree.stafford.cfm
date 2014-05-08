				
				
				
				
				<!--- // get our data access components --->
				
				<cfinvoke component="apis.com.leadgateway" method="getleaddetail" returnvariable="leaddetail">
					<cfinvokeargument name="leadid" value="#session.leadid#">
				</cfinvoke>
				
				<cfinvoke component="apis.com.leadgateway" method="getleadsummary" returnvariable="leadsummary">
					<cfinvokeargument name="leadid" value="#session.leadid#">
				</cfinvoke>	
				
				
				<!--- // set up some page params --->
				<cfparam name="tree" default="">
				<cfparam name="treename" default="">				
				<cfset tree = 2 />
				<cfset treename = "Stafford Loan" />
				
						
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
										<h3>Student Loan Option Tree Clarifying Points for #leaddetail.leadfirst# #leaddetail.leadlast# </h3>						
									</div> <!-- //.widget-header -->
									</cfoutput>
										
										<div class="widget-content">						
											
											<div class="pricing-header">
												<cfoutput>	
												<h1><i class="icon-sitemap"></i> #treename# Options</h1>
												<h2>Please review clarifying points for each category within this tree...</h2>
												</cfoutput>
											</div> <!-- /.pricing-header -->								
											
											
											<!--- // the sub-category option tree tabs --->
											<div class="tabbable">
												<ul class="nav nav-tabs">
													<li class="active"><a href="#tabcancel" data-toggle="tab"><i class="icon-download"></i> Cancellation</a></li>
													<li><a href="#tabforgive" data-toggle="tab"><i class="icon-cog"></i> Forgiveness</a></li>
													<li><a href="#tabdefault" data-toggle="tab"><i class="icon-folder-open"></i> Default Intervention</a></li>
													<li><a href="#tabrepay" data-toggle="tab"><i class="icon-money"></i> Repayment</a></li>
													<li><a href="#tabpost" data-toggle="tab"><i class="icon-bookmark"></i> Postponement</a></li>
													<li><a href="#taboffer" data-toggle="tab"><i class="icon-credit-card"></i> Offer In Compromise</a></li>
													<li><a href="#tabbank" data-toggle="tab"><i class="icon-legal"></i> Bankruptcy</a></li>
												</ul>
									
												<br>											
													
												<!--- get our tree structure for stafford loans --->
												<cfinvoke component="apis.com.optiontree2" method="getoptiontree2" returnvariable="optiontree2">
													<cfinvokeargument name="leadid" value="#session.leadid#">
												</cfinvoke>								
												
												<cfif optiontree2.subcat2 is not true >
													<cflocation url="#application.root#?event=page.tree" addtoken="no" >
												</cfif>
												
													<div class="tab-content">													
														
														
														
														<!--- // cancellation tab --->
														<div class="tab-pane active" id="tabcancel">
															
															<div class="accordion" id="basic-accordion">
																
																<cfif optiontree2.subcat2cancelunpaid is true>
																	
																	<cfinvoke component="apis.com.clarifyingpoints" method="getunpaidlist" returnvariable="unpaidlist">
																		<cfinvokeargument name="treenum" value="2">
																		<cfinvokeargument name="branchname" value="Unpaid Refund">
																	</cfinvoke>
																		
																		<div class="accordion-group">
																			<div class="accordion-heading">
																				<a class="accordion-toggle" data-toggle="collapse" data-parent="#basic-accordion" href="#cone">
																					Unpaid Refund
																				</a>
																			</div>																			  
																			
																			<div id="cone" class="accordion-body in collapse">
																				<div class="accordion-inner">
																					<ul>
																						<cfoutput query="unpaidlist">
																						<li style="margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
																				
																				<!--- // show the solution button to add to solution presentation --->
																				<cfoutput>
																					<a href="#application.root#?event=page.tree" style="margin-left:30px;" class="btn btn-small btn-secondary"><i class="icon-circle-arrow-left"></i> Return to Option Tree</a><a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=cancel&solution=refund" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-circle-arrow-right"></i> Choose This Solution</a>
																				</cfoutput>
																				
																			</div>												
																		</div>
																
																<cfelseif optiontree2.subcat2cancelcs is true>
																	
																	<cfinvoke component="apis.com.clarifyingpoints" method="getschoollist" returnvariable="schoollist">
																		<cfinvokeargument name="treenum" value="2">
																		<cfinvokeargument name="branchname" value="Closed School">
																	</cfinvoke>
																		
																		<div class="accordion-group">
																			<div class="accordion-heading">
																				<a class="accordion-toggle" data-toggle="collapse" data-parent="#basic-accordion" href="#cTwo">
																					Closed School
																				</a>
																			</div>
																				  
																			
																			<div id="cTwo" class="accordion-body in collapse">
																				<div class="accordion-inner">
																					<ul>
																						<cfoutput query="schoollist">
																						<li style="margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
																				<!--- // show the solution button to add to solution presentation --->
																				<cfoutput>
																					<a href="#application.root#?event=page.tree" style="margin-left:30px;" class="btn btn-small btn-secondary"><i class="icon-circle-arrow-left"></i> Return to Option Tree</a><a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=cancel&solution=school" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-circle-arrow-right"></i> Choose This Solution</a>
																				</cfoutput>
																			</div>														
																		</div>																
																
																<cfelseif optiontree2.subcat2cancel911 is true>
																	
																	<cfinvoke component="apis.com.clarifyingpoints" method="getnine11list" returnvariable="nine11list">
																		<cfinvokeargument name="treenum" value="2">
																		<cfinvokeargument name="branchname" value="9/11">
																	</cfinvoke>
																		
																		<div class="accordion-group">
																			<div class="accordion-heading">
																				<a class="accordion-toggle" data-toggle="collapse" data-parent="#basic-accordion" href="#cThree">
																					9-11
																				</a>
																			</div>
																					  
																			<div id="cThree" class="accordion-body in collapse">
																				<div class="accordion-inner">
																					<ul>
																						<cfoutput query="nine11list">
																						<li style="margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
																				
																				<!--- // show the solution button to add to solution presentation --->
																				<cfoutput>
																					<a href="#application.root#?event=page.tree" style="margin-left:30px;" class="btn btn-small btn-secondary"><i class="icon-circle-arrow-left"></i> Return to Option Tree</a><a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=cancel&solution=911" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-circle-arrow-right"></i> Choose This Solution</a>
																				</cfoutput>
																				
																			</div>													
																		</div>															
																
																<cfelseif optiontree2.subcat2canceldeath is true>
																	<cfinvoke component="apis.com.clarifyingpoints" method="getdeathlist" returnvariable="deathlist">
																		<cfinvokeargument name="treenum" value="2">
																		<cfinvokeargument name="branchname" value="Death">
																	</cfinvoke>
																		
																		<div class="accordion-group">
																			<div class="accordion-heading">
																				<a class="accordion-toggle" data-toggle="collapse" data-parent="#basic-accordion" href="#cfour">
																					Death
																				</a>
																			</div>
																					  
																			<div id="cfour" class="accordion-body in collapse">
																				<div class="accordion-inner">
																					<ul>
																						<cfoutput query="deathlist">
																						<li style="margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
																				
																				<!--- // show the solution button to add to solution presentation --->
																				<cfoutput>
																					<a href="#application.root#?event=page.tree" style="margin-left:30px;" class="btn btn-small btn-secondary"><i class="icon-circle-arrow-left"></i> Return to Option Tree</a><a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=cancel&solution=death" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-circle-arrow-right"></i> Choose This Solution</a>
																				</cfoutput>
																				
																			</div>																			
																		</div>														
																
																<cfelseif optiontree2.subcat2cancelatb is true>
																	
																	<cfinvoke component="apis.com.clarifyingpoints" method="getatblist" returnvariable="atblist">
																		<cfinvokeargument name="treenum" value="2">
																		<cfinvokeargument name="branchname" value="Ability to Benefit">
																	</cfinvoke>
																
																		<div class="accordion-group">
																			<div class="accordion-heading">
																				<a class="accordion-toggle" data-toggle="collapse" data-parent="#basic-accordion" href="#cfive">
																					Ability to Benefit
																				</a>
																			</div>
																					  
																			<div id="cfive" class="accordion-body in collapse">
																				<div class="accordion-inner">
																					<ul>
																						<cfoutput query="atblist">
																						<li style="margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
																				
																				<!--- // show the solution button to add to solution presentation --->
																				<cfoutput>
																					<a href="#application.root#?event=page.tree" style="margin-left:30px;" class="btn btn-small btn-secondary"><i class="icon-circle-arrow-left"></i> Return to Option Tree</a><a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=cancel&solution=atb" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-circle-arrow-right"></i> Choose This Solution</a>
																				</cfoutput>
																				
																			</div>																	
																		</div>														
																
																<cfelseif optiontree2.subcat2cancelcert is true>
																	
																	<cfinvoke component="apis.com.clarifyingpoints" method="getcertlist" returnvariable="certlist">
																		<cfinvokeargument name="treenum" value="2">
																		<cfinvokeargument name="branchname" value="False Certification">
																	</cfinvoke>
																
																		<div class="accordion-group">
																			<div class="accordion-heading">
																				<a class="accordion-toggle" data-toggle="collapse" data-parent="#basic-accordion" href="#csix">
																					False Certification
																				</a>
																			</div>
																					  
																			<div id="csix" class="accordion-body in collapse">
																				<div class="accordion-inner">
																					<ul>
																						<cfoutput query="certlist">
																						<li style="margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
																				
																				<!--- // show the solution button to add to solution presentation --->
																				<cfoutput>
																					<a href="#application.root#?event=page.tree" style="margin-left:30px;" class="btn btn-small btn-secondary"><i class="icon-circle-arrow-left"></i> Return to Option Tree</a><a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=cancel&solution=cert" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-circle-arrow-right"></i> Choose This Solution</a>
																				</cfoutput>
																				
																			</div>										
																		</div>														
																
																<cfelseif optiontree2.subcat2canceldisable is true>
																	
																	<cfinvoke component="apis.com.clarifyingpoints" method="getdisablelist" returnvariable="disablelist">
																		<cfinvokeargument name="treenum" value="2">
																		<cfinvokeargument name="branchname" value="Disability">
																	</cfinvoke>
																
																		<div class="accordion-group">
																			<div class="accordion-heading">
																				<a class="accordion-toggle" data-toggle="collapse" data-parent="#basic-accordion" href="#cseven">
																					Disability
																				</a>
																			</div>
																					  
																			<div id="cseven" class="accordion-body in collapse">
																				<div class="accordion-inner">
																					<ul>
																						<cfoutput query="disablelist">
																						<li style="margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
																				
																				<!--- // show the solution button to add to solution presentation --->
																				<cfoutput>
																					<a href="#application.root#?event=page.tree" style="margin-left:30px;" class="btn btn-small btn-secondary"><i class="icon-circle-arrow-left"></i> Return to Option Tree</a><a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=cancel&solution=disability" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-circle-arrow-right"></i> Choose This Solution</a>
																				</cfoutput>
																				
																			</div>													
																		</div>
																
																<cfelse>
																
																	<div class="alert alert-error">
																		<button type="button" class="close" data-dismiss="alert">&times;</button>
																		<strong><i class="icon-check"></i> NOT QUALIFIED!</strong>  Sorry, based on the information entered, you do not qualify for any concessions under Cancellation for Stafford Loans...
																	</div>
																	<div style="height:350px;"></div>
																
																</cfif>
																
																
																
															</div>
														</div>
														
														
														
														
														<!--- // forgiveness tab --->
														
														<div class="tab-pane" id="tabforgive">								
															
															<div class="accordion" id="basic-accordion2">
															
															
																<cfif trim( optiontree2.subcat2tlforgive ) is true or trim( optiontree2.subcat2psforgive ) is true >
																	
																	<cfif optiontree2.subcat2tlforgive is true >
																	
																		<cfinvoke component="apis.com.clarifyingpoints" method="getteachlist" returnvariable="teachlist">
																			<cfinvokeargument name="treenum" value="2">
																			<cfinvokeargument name="branchname" value="Teacher Loan Forgiveness">
																		</cfinvoke>
																			
																			<div class="accordion-group">
																				<div class="accordion-heading">
																					<a class="accordion-toggle" data-toggle="collapse" data-parent="#basic-accordion2" href="#cnine">
																						Teacher Loan Forgiveness
																					</a>
																				</div>
																						  
																				<div id="cnine" class="accordion-body in collapse">
																					<div class="accordion-inner">
																						<ul>
																							<cfoutput query="teachlist">
																							<li style="margin-top:5px;"><strong>#title#</strong><br />
																								#urldecode( pointtext )#</li>
																							</cfoutput>
																						</ul>
																					</div>
																					
																					<!--- // show the solution button to add to solution presentation --->
																					<cfoutput>
																						<a href="#application.root#?event=page.tree" style="margin-left:30px;" class="btn btn-small btn-secondary"><i class="icon-circle-arrow-left"></i> Return to Option Tree</a><a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=forgive&solution=tlf" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-circle-arrow-right"></i> Choose This Solution</a>
																					</cfoutput>
																					
																				</div>
																			</div>															
																			
																	<cfelseif optiontree2.subcat2psforgive is true >		
																		
																		<div class="alert alert-info">
																			<button type="button" class="close" data-dismiss="alert">&times;</button>
																			<strong><i class="icon-check"></i> NOTICE!</strong> Stafford loans are not qualified for public service loan forgiveness, however, if you consolidate to a new direct loan then you may be eligible depending on your job type. 																		
																		</div>
																		<br />
																		<cfinvoke component="apis.com.clarifyingpoints" method="getpslist" returnvariable="pslist">
																			<cfinvokeargument name="treenum" value="2">
																			<cfinvokeargument name="branchname" value="Public Service Loan Forgiveness">
																		</cfinvoke>
																			
																			<div class="accordion-group">
																				<div class="accordion-heading">
																					<a class="accordion-toggle" data-toggle="collapse" data-parent="#basic-accordion2" href="#ctwentyone">
																						Public Service Loan Forgiveness
																					</a>
																				</div>
																						  
																				<div id="ctwentyone" class="accordion-body in collapse">
																					<div class="accordion-inner">
																						<ul>
																							<cfoutput query="pslist">
																							<li style="margin-top:5px;"><strong>#title#</strong><br />
																								#urldecode( pointtext )#</li>
																							</cfoutput>
																						</ul>
																					</div>
																					
																					<!--- // show the solution button to add to solution presentation --->
																					<cfoutput>
																						<a href="#application.root#?event=page.tree" style="margin-left:30px;" class="btn btn-small btn-secondary"><i class="icon-circle-arrow-left"></i> Return to Option Tree</a><a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=forgive&solution=pslf" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-circle-arrow-right"></i> Choose This Solution</a>
																					</cfoutput>
																					
																				</div>
																			</div>
																				
																	</cfif>
																	
																	
																<cfelse>
																	
																	<div class="alert alert-error">
																		<button type="button" class="close" data-dismiss="alert">&times;</button>
																		<strong><i class="icon-check"></i> NOT QUALIFIED!</strong>  Sorry, based on the information entered, you do not qualify for any concessions under Forgiveness for Stafford Loans...
																	</div>
																	<div style="height:350px;"></div>
																
																</cfif>
															
															</div>
														</div>
														
														
														<!--- // default intervention tab --->
														
														<div class="tab-pane" id="tabdefault">
															<cfif optiontree2.subcat2default is true >
																<cfif trim( optiontree2.subcat2rehab ) is "yes" >
																	
																	<cfinvoke component="apis.com.clarifyingpoints" method="getrehablist" returnvariable="rehablist">
																		<cfinvokeargument name="treenum" value="2">
																		<cfinvokeargument name="branchname" value="Rehabilitation">
																	</cfinvoke>
																
																
																		<div class="accordion-group">
																			<div class="accordion-heading">
																				<a class="accordion-toggle" data-toggle="collapse" data-parent="#basic-accordion" href="#cten">
																					Rehabilitation
																				</a>
																			</div>
																					  
																			<div id="cten" class="accordion-body in collapse">
																				<div class="accordion-inner">
																					<ul>
																						<cfoutput query="rehablist">
																						<li style="margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
																				
																				<!--- // show the solution button to add to solution presentation --->
																				<cfoutput>
																					<a href="#application.root#?event=page.tree" style="margin-left:30px;" class="btn btn-small btn-secondary"><i class="icon-circle-arrow-left"></i> Return to Option Tree</a><a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=default&solution=rehab" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-circle-arrow-right"></i> Choose This Solution</a>
																				</cfoutput>
																				
																			</div>
																		</div>
																
																
																<cfelseif trim( optiontree2.subcat2consol ) is "yes" >
																	
																	<cfinvoke component="apis.com.clarifyingpoints" method="getconsollist" returnvariable="consollist">
																		<cfinvokeargument name="treenum" value="2">
																		<cfinvokeargument name="branchname" value="Consolidation">
																	</cfinvoke>
																	
																		<div class="accordion-group">
																			<div class="accordion-heading">
																				<a class="accordion-toggle" data-toggle="collapse" data-parent="#basic-accordion" href="#celeven">
																					Consolidation
																				</a>
																			</div>
																					  
																			<div id="celeven" class="accordion-body in collapse">
																				<div class="accordion-inner">
																					<ul>
																						<cfoutput query="consollist">
																						<li style="margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
																				
																				<!--- // show the solution button to add to solution presentation --->
																				<cfoutput>
																					<a href="#application.root#?event=page.tree" style="margin-left:30px;" class="btn btn-small btn-secondary"><i class="icon-circle-arrow-left"></i> Return to Option Tree</a><a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=default&solution=consol" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-circle-arrow-right"></i> Choose This Solution</a>
																				</cfoutput>
																				
																			</div>
																		</div>
																
																
																<cfelseif trim( optiontree2.subcat2wg ) is "yes" >
																	
																	<cfinvoke component="apis.com.clarifyingpoints" method="getwglist" returnvariable="wglist">
																		<cfinvokeargument name="treenum" value="2">
																		<cfinvokeargument name="branchname" value="Wage Garnishment">
																	</cfinvoke>
																
																		<div class="accordion-group">
																			<div class="accordion-heading">
																				<a class="accordion-toggle" data-toggle="collapse" data-parent="#basic-accordion" href="#ctweleve">
																					Wage Garnishment
																				</a>
																			</div>
																					  
																			<div id="ctweleve" class="accordion-body in collapse">
																				<div class="accordion-inner">
																					<ul>
																						<cfoutput query="wglist">
																						<li style="margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
																				
																				<!--- // show the solution button to add to solution presentation --->
																				<cfoutput>
																					<a href="#application.root#?event=page.tree" style="margin-left:30px;" class="btn btn-small btn-secondary"><i class="icon-circle-arrow-left"></i> Return to Option Tree</a><a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=default&solution=wg" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-circle-arrow-right"></i> Choose This Solution</a>
																				</cfoutput>
																				
																			</div>
																		</div>
																
																
																<cfelseif trim( optiontree2.subcat2to ) is "yes" >
																	
																	<cfinvoke component="apis.com.clarifyingpoints" method="gettolist" returnvariable="tolist">
																		<cfinvokeargument name="treenum" value="2">
																		<cfinvokeargument name="branchname" value="Tax Offset">
																	</cfinvoke>
																
																		<div class="accordion-group">
																			<div class="accordion-heading">
																				<a class="accordion-toggle" data-toggle="collapse" data-parent="#basic-accordion" href="#cthirteen">
																					Tax Offset
																				</a>
																			</div>
																					  
																			<div id="cthirteen" class="accordion-body in collapse">
																				<div class="accordion-inner">
																					<ul>
																						<cfoutput query="tolist">
																						<li style="margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
																				
																				<!--- // show the solution button to add to solution presentation --->
																				<cfoutput>
																					<a href="#application.root#?event=page.tree" style="margin-left:30px;" class="btn btn-small btn-secondary"><i class="icon-circle-arrow-left"></i> Return to Option Tree</a><a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=default&solution=to" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-circle-arrow-right"></i> Choose This Solution</a>
																				</cfoutput>
																				
																			</div>
																		</div>
																</cfif>
															
															<cfelse>
																<div class="alert alert-error">
																	<button type="button" class="close" data-dismiss="alert">&times;</button>
																	<strong><i class="icon-check"></i> NOT QUALIFIED!</strong>  Sorry, based on the information entered, you do not qualify for any concessions under Default Intervention for Stafford Loans...
																</div>
																<div style="height:350px;"></div>
															</cfif>
														</div>
														
														
														<!--- // repayments tab --->
														<div class="tab-pane" id="tabrepay">
															
															<!--- // non-consolidated repayment clarifying points --->
															<cfinvoke component="apis.com.clarifyingpoints" method="getrepaynonconsollist" returnvariable="repaynonconsollist">
																<cfinvokeargument name="treenum" value="2">
																<cfinvokeargument name="branchname" value="Non-Consolidated Repayment">
															</cfinvoke>
																
																<div class="accordion-group">
																	<div class="accordion-heading">
																		<a class="accordion-toggle" data-toggle="collapse" data-parent="#basic-accordion" href="#cnineteen">
																			Non-Consolidated Repayment
																		</a>
																	</div>
																					  
																	<div id="cnineteen" class="accordion-body in collapse">
																		<div class="accordion-inner">
																			<ul>
																				<cfoutput query="repaynonconsollist">
																				<li style="margin-top:5px;"><strong>#title#</strong><br />
																					#urldecode( pointtext )#</li>
																				</cfoutput>
																			</ul>
																		</div>
																		
																		<!--- // show the solution button to add to solution presentation --->
																		<cfoutput>
																			<a href="#application.root#?event=page.tree" style="margin-left:30px;" class="btn btn-small btn-secondary"><i class="icon-circle-arrow-left"></i> Return to Option Tree</a><a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=repay&solution=nonconsol" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-circle-arrow-right"></i> Choose This Solution</a>
																		</cfoutput>
																		
																	</div>
																</div>
																
															<!--- // consolidated repayment clarifying points --->
															<cfinvoke component="apis.com.clarifyingpoints" method="getrepayconsollist" returnvariable="repayconsollist">
																<cfinvokeargument name="treenum" value="2">
																<cfinvokeargument name="branchname" value="Consolidated Repayment">
															</cfinvoke>
																
																<div class="accordion-group">
																	<div class="accordion-heading">
																		<a class="accordion-toggle" data-toggle="collapse" data-parent="#basic-accordion" href="#ctwenty">
																			Consolidated Repayment
																		</a>
																	</div>																
																
																	<!--- // show repayment calculator table --->
																
																	<cfinvoke component="apis.com.clientloanoptions" method="getclientloaninfo" returnvariable="cloaninfo">
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
																		<cfinvoke component="apis.com.studentloancalculator" method="qualifyclient" returnvariable="qualifyThisClient">
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
																		<cfinvoke component="apis.com.studentloancalculator" method="calcIBR" returnvariable="mIBR">
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
																		<cfinvoke component="apis.com.studentloancalculator" method="calcICR" returnvariable="monthlyPaymentICR">
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
																		<cfinvoke component="apis.com.studentloancalculator" method="calcSTD" returnvariable="monthlyPaymentStd">
																			<cfinvokeargument name="loanterm" value="#cloanterm#">
																			<cfinvokeargument name="leadid" value="#leaddetail.leadid#">
																		</cfinvoke>
																				
																		<!--- Extended --->
																		<cfinvoke component="apis.com.studentloancalculator" method="calcExt" returnvariable="mExtPay">
																			<cfinvokeargument name="loanterm" value="#cloanterm#">
																			<cfinvokeargument name="leadid" value="#leaddetail.leadid#">
																		</cfinvoke>
																			
																		<!--- Graduated --->
																		<cfinvoke component="apis.com.studentloancalculator" method="calcGrad" returnvariable="gradInitialPayAmt">
																			<cfinvokeargument name="loanterm" value="#cloanterm#">
																			<cfinvokeargument name="leadid" value="#leaddetail.leadid#">
																		</cfinvoke>
																			
																		<!--- Extended Graduated --->
																		<cfinvoke component="apis.com.studentloancalculator" method="calcExtGrad" returnvariable="strExtGrad">
																			<cfinvokeargument name="loanterm" value="#cloanterm#">
																			<cfinvokeargument name="leadid" value="#leaddetail.leadid#">
																		</cfinvoke>
																		
																		<!--- // end data components for calculators --->
																
																
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
																			<cfoutput>
																			<tbody>
																				<!--- // standard repayment --->																
																				<tr>																																									
																					<td>Standard</td>
																					<td>#cloanterm#</td>
																					<td>#dollarformat( monthlyPaymentStd )#</td>
																					<td>#dollarformat( monthlyPaymentStd * cloanterm )#</td>
																					<td><span class="label label-default">View Detail</span></td>
																				</tr>
																				<!--- graduated --->
																				<tr>																																										
																					<td>Graduated</td>
																					<td>#cloanterm#</td>
																					<td>#dollarformat( gradInitialPayAmt )#</td>
																					<td>#dollarformat( gradInitialPayAmt * cloanterm )#</td>
																					<td><span class="label label-default">View Detail</span>&nbsp;<span class="label label-inverse">See Note 1</span></td>
																				</tr>
																				<!--- // extended --->
																				<cfif cloaninfo.totalloanamount GT 30000 >
																				<tr>																																										
																					<td>Extended</td>
																					<td>#mExtPay.mExtTerm#</td>
																					<td>#dollarformat( mExtPay.mExtPayAmt )#</td>
																					<td>#dollarformat( mExtPay.mExtPayAmt * mExtPay.mExtTerm )#</td>
																					<td><span class="label label-default">View Detail</span></td>
																				</tr>
																				<!--- // extended graduated --->
																				<tr>																																									
																					<td>Extended Graduated</td>
																					<td>#strExtGrad.newloanterm#</td>
																					<td>#dollarformat( strExtGrad.gradExtInitialPayAmt )#</td>
																					<td>#dollarformat( strExtGrad.gradExtInitialPayAmt * strExtGrad.newloanterm )#</td>
																					<td><span class="label label-default">View Detail</span></td>
																				</tr>
																				</cfif>
																				<!--- // pay as you earn --->
																				<tr>																																									
																					<td>Pay As You Earn</td>
																					<td><span class="label label-warning">See Note 2</span></td>
																					<td>#dollarformat( mIBR.mIBRPAYE )#</td>
																					<td>#dollarformat( mIBR.mIBRPAYE * 300 )#</td>
																					<td><span class="label label-default">View Detail</span></td>
																				</tr>
																				<!--- // income contingent --->
																				<tr>																																										
																					<td>Income Contingent</td>
																					<td><span class="label label-warning">See Note 2</span></td>
																					<td>#dollarformat( monthlyPaymentICR )#</td>
																					<td>#dollarformat( monthlyPaymentICR * 300 )#</td>
																					<td><cfif qualifythisclient is true><span class="label label-default">View Detail</span><cfelse><span class="label label-important">Not Qualified</span></cfif></td>
																				</tr>
																				<!--- // income based --->
																				<cfif mIBR.mIBRPayAmt LTE mIBR.mIBRStd>
																				<tr>																																									
																					<td>Income Based</td>
																					<td><span class="label label-warning">See Note 2</span></td>
																					<td>#dollarformat( mIBR.mIBRPayAmt )#</td>
																					<td>#dollarformat( mIBR.mIBRPayAmt * 300 )#</td>
																					<td><cfif qualifythisclient is true><span class="label label-default">View Detail</span><cfelse><span class="label label-important">Not Qualified</span></cfif></td>
																				</tr>
																				</cfif>
																			</tbody>
																			</cfoutput>
																		</table>							
																
																
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
																				You are not eligible for the IBR Plan because you do not have a partial financial hardship based on the income and family size information you provided.
																				</p>						 
																									  
																				<p><strong>Note 5:</strong>
																				The IBR Plan Estimated Total Loan Balances include your spouse's total indebtedness, if applicable.
																				</p>
																			</small>
																		</div>
																
																	<div id="ctwenty" class="accordion-body in collapse">
																		<div class="accordion-inner">
																			<h5><small><strong>Clarifying Points for Consolidated Repayment</strong></small></h5>
																			<ul>
																				<cfoutput query="repayconsollist">
																				<li style="margin-top:5px;"><strong>#title#</strong><br />
																					#urldecode( pointtext )#</li>
																				</cfoutput>
																			</ul>
																		</div>
																		
																		<!--- // show the solution button to add to solution presentation --->
																		<cfoutput>
																			<a href="#application.root#?event=page.tree" style="margin-left:30px;" class="btn btn-small btn-secondary"><i class="icon-circle-arrow-left"></i> Return to Option Tree</a><a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=repay&solution=consol" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-circle-arrow-right"></i> Choose This Solution</a>
																		</cfoutput>
																		
																	</div>
																
																
																</div><!--- /.accordion-group --->	
														</div>
														
														
														<div class="tab-pane" id="tabpost">
															<cfif optiontree2.subcat2post is true >
																<cfif trim( optiontree2.subcat2postdefer ) is "yes" >
																	
																	<cfinvoke component="apis.com.clarifyingpoints" method="getdeferlist" returnvariable="deferlist">
																		<cfinvokeargument name="treenum" value="2">
																		<cfinvokeargument name="branchname" value="Deferment">
																	</cfinvoke>
																		
																		<div class="accordion-group">
																			<div class="accordion-heading">
																				<a class="accordion-toggle" data-toggle="collapse" data-parent="#basic-accordion" href="#cfourteen">
																					Deferment
																				</a>
																			</div>
																					  
																			<div id="cfourteen" class="accordion-body in collapse">
																				<div class="accordion-inner">
																					<ul>
																						<cfoutput query="deferlist">
																						<li style="margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
																				
																				<!--- // show the solution button to add to solution presentation --->
																				<cfoutput>
																					<a href="#application.root#?event=page.tree" style="margin-left:30px;" class="btn btn-small btn-secondary"><i class="icon-circle-arrow-left"></i> Return to Option Tree</a><a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=post&solution=defer" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-circle-arrow-right"></i> Choose This Solution</a>
																				</cfoutput>
																				
																			</div>
																		</div>
																
																
																<cfelseif trim( optiontree2.subcat2postforbear ) is "yes" >
																	
																	<cfinvoke component="apis.com.clarifyingpoints" method="getforbearlist" returnvariable="forbearlist">
																		<cfinvokeargument name="treenum" value="2">
																		<cfinvokeargument name="branchname" value="Forbearance">
																	</cfinvoke>
																		
																		<div class="accordion-group">
																			<div class="accordion-heading">
																				<a class="accordion-toggle" data-toggle="collapse" data-parent="#basic-accordion" href="#cfifteen">
																					Forbearance
																				</a>
																			</div>
																					  
																			<div id="cfifteen" class="accordion-body in collapse">
																				<div class="accordion-inner">
																					<ul>
																						<cfoutput query="forbearlist">
																						<li style="margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
																				
																				<!--- // show the solution button to add to solution presentation --->
																				<cfoutput>
																					<a href="#application.root#?event=page.tree" style="margin-left:30px;" class="btn btn-small btn-secondary"><i class="icon-circle-arrow-left"></i> Return to Option Tree</a><a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=post&solution=forbear" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-circle-arrow-right"></i> Choose This Solution</a>
																				</cfoutput>
																				
																			</div>
																		</div>
																</cfif>
															
															<cfelse>
																
																<div class="alert alert-error">
																	<button type="button" class="close" data-dismiss="alert">&times;</button>
																	<strong><i class="icon-check"></i> NOT QUALIFIED!</strong>  Sorry, based on the information entered, you do not qualify for any concessions under Postponement for Stafford Loans...
																</div>
																<div style="height:350px;"></div>
															
															</cfif>
														</div>
														
														
														<!--- // offer in compromise tab --->
														<div class="tab-pane" id="taboffer">
															<cfif optiontree2.subcat2oic is true >
																
																<cfinvoke component="apis.com.clarifyingpoints" method="getoiclist" returnvariable="oiclist">
																	<cfinvokeargument name="treenum" value="2">
																	<cfinvokeargument name="branchname" value="Offer in Compromise">
																</cfinvoke>
																
																		<div class="accordion-group">
																			<div class="accordion-heading">
																				<a class="accordion-toggle" data-toggle="collapse" data-parent="#basic-accordion" href="#csixteen">
																					Offer in Compromise
																				</a>
																			</div>
																					  
																			<div id="csixteen" class="accordion-body in collapse">
																				<div class="accordion-inner">
																					<ul>
																						<cfoutput query="oiclist">
																						<li style="margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
																				
																				<!--- // show the solution button to add to solution presentation --->
																				<cfoutput>
																					<a href="#application.root#?event=page.tree" style="margin-left:30px;" class="btn btn-small btn-secondary"><i class="icon-circle-arrow-left"></i> Return to Option Tree</a><a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=oic&solution=oic" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-circle-arrow-right"></i> Choose This Solution</a>
																				</cfoutput>																				
																				
																			</div>
																		</div>
															
															
															<cfelse>
															
																<div class="alert alert-error">
																	<button type="button" class="close" data-dismiss="alert">&times;</button>
																	<strong><i class="icon-check"></i> NOT QUALIFIED!</strong>  Sorry, based on the information entered, you do not qualify for any concessions under Offer in Compromise for Stafford Loans...
																</div>
																<div style="height:350px;"></div>
															
															</cfif>
														</div>
														
														
														<!--- // bankruptcy tab --->
														<div class="tab-pane" id="tabbank">
															<cfif optiontree2.subcat2bk is true >
															
																<cfinvoke component="apis.com.clarifyingpoints" method="getbklist" returnvariable="bklist">
																	<cfinvokeargument name="treenum" value="2">
																	<cfinvokeargument name="branchname" value="Bankruptcy">
																</cfinvoke>
																
																		<div class="accordion-group">
																			<div class="accordion-heading">
																				<a class="accordion-toggle" data-toggle="collapse" data-parent="#basic-accordion" href="#cseventeen">
																					Bankruptcy
																				</a>
																			</div>
																					  
																			<div id="cseventeen" class="accordion-body in collapse">
																				<div class="accordion-inner">
																					<ul>
																						<cfoutput query="bklist">
																						<li style="margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
																				
																				<!--- // show the solution button to add to solution presentation --->
																				<cfoutput>
																					<a href="#application.root#?event=page.tree" style="margin-left:30px;" class="btn btn-small btn-secondary"><i class="icon-circle-arrow-left"></i> Return to Option Tree</a><a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=bk&solution=bk" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-circle-arrow-right"></i> Choose This Solution</a>
																				</cfoutput>
																				
																			</div>
																		</div>
																
															
															<cfelse>
																
																<div class="alert alert-error">
																	<button type="button" class="close" data-dismiss="alert">&times;</button>
																	<strong><i class="icon-check"></i> NOT QUALIFIED!</strong>  Sorry, based on the information entered, you do not qualify for any concessions under bankruptcy for Stafford Loans...
																</div>
																<div style="height:350px;"></div>
															
															</cfif>
														</div>
														
														
														<!--- // show solution buttons 
														<cfoutput>
														<div style="float:right;"><a href="#application.root#?event=page.tree" class="btn btn-small btn-secondary"><i class="icon-hand-left"></i> Return to Option Tree</a>&nbsp;<a href="javascript:;" class="btn btn-small btn-primary"><i class="icon-check"></i> Choose This Solution</a>
														</cfoutput>
														--->
													
													
													</div><!-- / .tab-content -->				
												
												
												</div><!-- /.tabbable .tabsmenu -->
											

										<div class="clear"></div>
										</div> <!-- //.widget-content -->	
									
								</div> <!-- //.widget -->
							
							</div> <!-- //.span12 -->
						
						</div> <!-- //.row -->				
				
					<div style="height:200px;"></div>			
				
				</div> <!-- //.container -->
			
			</div> <!-- //.main -->


				