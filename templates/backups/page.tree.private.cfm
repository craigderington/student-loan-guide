
				
				
				
				
				
				<!--- // get our data access components --->
				
				<cfinvoke component="apis.com.leadgateway" method="getleaddetail" returnvariable="leaddetail">
					<cfinvokeargument name="leadid" value="#session.leadid#">
				</cfinvoke>
				
				<cfinvoke component="apis.com.leadgateway" method="getleadsummary" returnvariable="leadsummary">
					<cfinvokeargument name="leadid" value="#session.leadid#">
				</cfinvoke>
				
				<!--- // set up some page params --->
				<cfparam name="treename" default="">
				<cfparam name="tree" default="">
				<cfset tree = 7 />
				<cfset treename = "Private Loan" />
				
						
				<!--- // include the tree stylesheet --->
				<link href="./css/pages/plans.css" rel="stylesheet"> 
				<link href="./css/pages/pricing.css" rel="stylesheet">				
			

				<!--- // begin option tree --->
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
													<li><a href="#tabdefault" data-toggle="tab"><i class="icon-folder-open"></i> Default Intervention</a></li>
													<li><a href="#tabrepay" data-toggle="tab"><i class="icon-money"></i> Repayment</a></li>
													<li><a href="#tabpost" data-toggle="tab"><i class="icon-bookmark"></i> Postponement</a></li>
													<li><a href="#taboffer" data-toggle="tab"><i class="icon-credit-card"></i> Offer In Compromise</a></li>
													<li><a href="#tabbank" data-toggle="tab"><i class="icon-legal"></i> Bankruptcy</a></li>
												</ul>
									
												<br>											
													
												<!--- get our tree structure for stafford loans --->
												<cfinvoke component="apis.com.optiontree7" method="getoptiontree7" returnvariable="optiontree7">
													<cfinvokeargument name="leadid" value="#session.leadid#">
												</cfinvoke>								
												
																						
													
													<div class="tab-content">										
														
														
														<!--- // cancellation tab --->
														<div class="tab-pane active" id="tabcancel">
															
															<div class="accordion" id="basic-accordion">																															
																
																<cfif optiontree7.subcat7canceldeath is true>
																	
																	<cfinvoke component="apis.com.clarifyingpoints" method="getdeathlist" returnvariable="deathlist">
																		<cfinvokeargument name="treenum" value="7">
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
																</cfif>
																
																<cfif optiontree7.subcat7mixeduse is true>
																	
																	<cfinvoke component="apis.com.clarifyingpoints" method="getmxlist" returnvariable="mxlist">
																		<cfinvokeargument name="treenum" value="7">
																		<cfinvokeargument name="branchname" value="Mixed Use Loan">
																	</cfinvoke>
																
																		<div class="accordion-group">
																			<div class="accordion-heading">
																				<a class="accordion-toggle" data-toggle="collapse" data-parent="#basic-accordion" href="#cfive">
																					Mixed Use Loan
																				</a>
																			</div>
																					  
																			<div id="cfive" class="accordion-body in collapse">
																				<div class="accordion-inner">
																					<ul>
																						<cfoutput query="mxlist">
																						<li style="margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
																				
																				<!--- // show the solution button to add to solution presentation --->
																				<cfoutput>
																					<a href="#application.root#?event=page.tree" style="margin-left:30px;" class="btn btn-small btn-secondary"><i class="icon-circle-arrow-left"></i> Return to Option Tree</a><a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=cancel&solution=mixed" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-circle-arrow-right"></i> Choose This Solution</a>
																				</cfoutput>																		
																				
																			</div>
																		</div>
																</cfif>
																
																<cfif optiontree7.subcat7idtheft is true>
																	
																	<cfinvoke component="apis.com.clarifyingpoints" method="gettheftlist" returnvariable="theftlist">
																		<cfinvokeargument name="treenum" value="7">
																		<cfinvokeargument name="branchname" value="ID Theft">
																	</cfinvoke>
																
																		<div class="accordion-group">
																			<div class="accordion-heading">
																				<a class="accordion-toggle" data-toggle="collapse" data-parent="#basic-accordion" href="#csix">
																					ID Theft
																				</a>
																			</div>
																					  
																			<div id="csix" class="accordion-body in collapse">
																				<div class="accordion-inner">
																					<ul>
																						<cfoutput query="theftlist">
																						<li style="margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
																				
																				<!--- // show the solution button to add to solution presentation --->
																				<cfoutput>
																					<a href="#application.root#?event=page.tree" style="margin-left:30px;" class="btn btn-small btn-secondary"><i class="icon-circle-arrow-left"></i> Return to Option Tree</a><a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=cancel&solution=theft" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-circle-arrow-right"></i> Choose This Solution</a>
																				</cfoutput>
																				
																			</div>
																		</div>
																</cfif>
																

																<cfif optiontree7.subcat7legalage is true>
																	
																																
																	<cfinvoke component="apis.com.clarifyingpoints" method="getlegallist" returnvariable="legallist">
																		<cfinvokeargument name="treenum" value="7">
																		<cfinvokeargument name="branchname" value="Legal Age">
																	</cfinvoke>
																
																		<div class="accordion-group">
																			<div class="accordion-heading">
																				<a class="accordion-toggle" data-toggle="collapse" data-parent="#basic-accordion" href="#cthirtysix">
																					Legal Age
																				</a>
																			</div>
																					  
																			<div id="cthirtysix" class="accordion-body in collapse">
																				<div class="accordion-inner">
																					<ul>
																						<cfoutput query="legallist">
																						<li style="margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
																				
																				<!--- // show the solution button to add to solution presentation --->
																				<cfoutput>
																					<a href="#application.root#?event=page.tree" style="margin-left:30px;" class="btn btn-small btn-secondary"><i class="icon-circle-arrow-left"></i> Return to Option Tree</a><a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=cancel&solution=legal" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-circle-arrow-right"></i> Choose This Solution</a>
																				</cfoutput>
																				
																			</div>
																		</div>
																</cfif>
																
																<cfif optiontree7.subcat7ftcrule is true>
																	
																	<cfinvoke component="apis.com.clarifyingpoints" method="getftclist" returnvariable="ftclist">
																		<cfinvokeargument name="treenum" value="7">
																		<cfinvokeargument name="branchname" value="FTC Holder Rule">
																	</cfinvoke>
																
																		<div class="accordion-group">
																			<div class="accordion-heading">
																				<a class="accordion-toggle" data-toggle="collapse" data-parent="#basic-accordion" href="#cfourtysix">
																					ID Theft
																				</a>
																			</div>
																					  
																			<div id="cfourtysix" class="accordion-body in collapse">
																				<div class="accordion-inner">
																					<ul>
																						<cfoutput query="ftclist">
																						<li style="margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
																				
																				<!--- // show the solution button to add to solution presentation --->
																				<cfoutput>
																					<a href="#application.root#?event=page.tree" style="margin-left:30px;" class="btn btn-small btn-secondary"><i class="icon-circle-arrow-left"></i> Return to Option Tree</a><a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=cancel&solution=ftcrule" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-circle-arrow-right"></i> Choose This Solution</a>
																				</cfoutput>
																				
																			</div>
																		</div>
																
																</cfif>
																<!---
																<cfelse>
																
																	<div class="alert alert-error">
																		<button type="button" class="close" data-dismiss="alert">&times;</button>
																		<strong><i class="icon-check"></i> NOT QUALIFIED!</strong>  Sorry, based on the information entered, you do not qualify for any concessions under Cancellation for Private Loans...
																	</div>
																	<div style="height:350px;"></div>
																
																</cfif>
																--->
																
																
															</div>
														</div>				
														
														
														<!--- // default intervention tab --->
														
														<div class="tab-pane" id="tabdefault">
															
															<div class="accordion" id="basic-accordion2">
															
																<cfif optiontree7.subcat7default is true >
																	
																	<cfif trim( optiontree7.subcat7defaultstat ) is "yes" >
																		
																		<cfinvoke component="apis.com.clarifyingpoints" method="getstatlist" returnvariable="statlist">
																			<cfinvokeargument name="treenum" value="7">
																			<cfinvokeargument name="branchname" value="Statue of Limitations on Collections">
																		</cfinvoke>
																	
																	
																			<div class="accordion-group">
																				<div class="accordion-heading">
																					<a class="accordion-toggle" data-toggle="collapse" data-parent="#basic-accordion2" href="#cten">
																						Statue of Limitations on Collections 
																					</a>
																				</div>
																						  
																				<div id="cten" class="accordion-body in collapse">
																					<div class="accordion-inner">
																						<ul>
																							<cfoutput query="statlist">
																							<li style="margin-top:5px;"><strong>#title#</strong><br />
																								#urldecode( pointtext )#</li>
																							</cfoutput>
																						</ul>
																					</div>
																					
																					<!--- // show the solution button to add to solution presentation --->
																					<cfoutput>
																						<a href="#application.root#?event=page.tree" style="margin-left:30px;" class="btn btn-small btn-secondary"><i class="icon-circle-arrow-left"></i> Return to Option Tree</a><a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=default&solution=sol" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-circle-arrow-right"></i> Choose This Solution</a>
																					</cfoutput>
																					
																				</div>
																			</div>
																	
																	<cfelseif optiontree7.subcat7validate is true >
																		
																			<cfinvoke component="apis.com.clarifyingpoints" method="getvalidatelist" returnvariable="validatelist">
																				<cfinvokeargument name="treenum" value="7">
																				<cfinvokeargument name="branchname" value="Validation">
																			</cfinvoke>
																	
																	
																			<div class="accordion-group">
																				<div class="accordion-heading">
																					<a class="accordion-toggle" data-toggle="collapse" data-parent="#basic-accordion2" href="#celeven">
																						Validation of Debt
																					</a>
																				</div>
																						  
																				<div id="celeven" class="accordion-body in collapse">
																					<div class="accordion-inner">
																						<ul>
																							<cfoutput query="validatelist">
																							<li style="margin-top:5px;"><strong>#title#</strong><br />
																								#urldecode( pointtext )#</li>
																							</cfoutput>
																						</ul>
																					</div>
																					
																					<!--- // show the solution button to add to solution presentation --->
																					<cfoutput>
																						<a href="#application.root#?event=page.tree" style="margin-left:30px;" class="btn btn-small btn-secondary"><i class="icon-circle-arrow-left"></i> Return to Option Tree</a><a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=default&solution=validate" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-circle-arrow-right"></i> Choose This Solution</a>
																					</cfoutput>
																					
																				</div>
																			</div>																
																	
																
																	</cfif>
																	
																
																<cfelse>
																			
																			
																	<div class="alert alert-error">
																	<button type="button" class="close" data-dismiss="alert">&times;</button>
																		<strong><i class="icon-check"></i> NOT QUALIFIED!</strong>  Sorry, based on the information entered, you do not qualify for any concessions under Default Intervention for Private Loans...
																	</div>
																	<div style="height:350px;"></div>														
																		
																
																</cfif>
															</div>
														</div>
														
														
														<!--- // repayments tab ---> 
														<div class="tab-pane" id="tabrepay">
														
															<div class="accordion" id="basic-accordion3">
															
																<cfif optiontree7.subcat7hardship is true >															
																	
																	<cfinvoke component="apis.com.clarifyingpoints" method="gethardshiplist" returnvariable="hardshiplist">
																		<cfinvokeargument name="treenum" value="7">
																		<cfinvokeargument name="branchname" value="Hardship Eligibility">
																	</cfinvoke>
																			
																		<div class="accordion-group">
																			<div class="accordion-heading">
																				<a class="accordion-toggle" data-toggle="collapse" data-parent="#basic-accordion3" href="#ctwentyfour">
																					Hardship Eligibility
																				</a>
																			</div>
																						  
																			<div id="ctwentyfour" class="accordion-body in collapse">
																				<div class="accordion-inner">
																					<ul>
																						<cfoutput query="hardshiplist">
																						<li style="margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
																				
																				<!--- // show the solution button to add to solution presentation --->
																				<cfoutput>
																					<a href="#application.root#?event=page.tree" style="margin-left:30px;" class="btn btn-small btn-secondary"><i class="icon-circle-arrow-left"></i> Return to Option Tree</a><a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=repay&solution=hardship" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-circle-arrow-right"></i> Choose This Solution</a>
																				</cfoutput>
																				
																			</div>
																		</div>																
																
																
																
																<cfelseif optiontree7.subcat7mod is true >

																	<cfinvoke component="apis.com.clarifyingpoints" method="getmodlist" returnvariable="modlist">
																		<cfinvokeargument name="treenum" value="7">
																		<cfinvokeargument name="branchname" value="Modifications">
																	</cfinvoke>
																			
																		<div class="accordion-group">
																			<div class="accordion-heading">
																				<a class="accordion-toggle" data-toggle="collapse" data-parent="#basic-accordion3" href="#ctwentyfive">
																					Modifications
																				</a>
																			</div>
																						  
																			<div id="ctwentyfive" class="accordion-body in collapse">
																				<div class="accordion-inner">
																					<ul>
																						<cfoutput query="modlist">
																						<li style="margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
																				
																				<!--- // show the solution button to add to solution presentation --->
																				<cfoutput>
																					<a href="#application.root#?event=page.tree" style="margin-left:30px;" class="btn btn-small btn-secondary"><i class="icon-circle-arrow-left"></i> Return to Option Tree</a><a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=repay&solution=mod" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-circle-arrow-right"></i> Choose This Solution</a>
																				</cfoutput>
																				
																			</div>
																		</div>
																		
																
																<cfelseif optiontree7.subcat7ext is true >													
																	
																	<cfinvoke component="apis.com.clarifyingpoints" method="getextlist" returnvariable="extlist">
																		<cfinvokeargument name="treenum" value="7">
																		<cfinvokeargument name="branchname" value="Extensions">
																	</cfinvoke>
																			
																		<div class="accordion-group">
																			<div class="accordion-heading">
																				<a class="accordion-toggle" data-toggle="collapse" data-parent="#basic-accordion3" href="#ctwentysix">
																					Repayment Extensions
																				</a>
																			</div>
																						  
																			<div id="ctwentysix" class="accordion-body in collapse">
																				<div class="accordion-inner">
																					<ul>
																						<cfoutput query="extlist">
																						<li style="margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
																				
																				<!--- // show the solution button to add to solution presentation --->
																				<cfoutput>
																					<a href="#application.root#?event=page.tree" style="margin-left:30px;" class="btn btn-small btn-secondary"><i class="icon-circle-arrow-left"></i> Return to Option Tree</a><a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=repay&solution=ext" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-circle-arrow-right"></i> Choose This Solution</a>
																				</cfoutput>
																				
																			</div>
																		</div>
																	
																	
																<cfelse>

																	<div class="alert alert-error">
																		<button type="button" class="close" data-dismiss="alert">&times;</button>
																		<strong><i class="icon-check"></i> NOTICE!</strong>  Sorry, based on the information entered, you do not qualify for any additional repayment options for Private Loans other than your current repayment plan...
																	</div>
																	<div style="height:350px;"></div>
																
																</cfif>
															
															</div>
															
														</div>
														
														
														<!--- // postponement tab - no conditional statements --->
														<div class="tab-pane" id="tabpost">
															
															<div class="accordion" id="basic-accordion4">	
																
																<cfinvoke component="apis.com.clarifyingpoints" method="getpostlist" returnvariable="postlist">
																	<cfinvokeargument name="treenum" value="7">
																	<cfinvokeargument name="branchname" value="Postponement">
																</cfinvoke>
																		
																	<div class="accordion-group">
																		<div class="accordion-heading">
																			<a class="accordion-toggle" data-toggle="collapse" data-parent="#basic-accordion4" href="#cfourteen">
																				Postponement
																			</a>
																		</div>
																					  
																		<div id="cfourteen" class="accordion-body in collapse">
																			<div class="accordion-inner">
																				<ul>
																					<cfoutput query="postlist">
																					<li style="margin-top:5px;"><strong>#title#</strong><br />
																						#urldecode( pointtext )#</li>
																					</cfoutput>
																				</ul>
																			</div>
																			
																			<!--- // show the solution button to add to solution presentation --->
																			<cfoutput>
																				<a href="#application.root#?event=page.tree" style="margin-left:30px;" class="btn btn-small btn-secondary"><i class="icon-circle-arrow-left"></i> Return to Option Tree</a><a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=post&solution=post" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-circle-arrow-right"></i> Choose This Solution</a>
																			</cfoutput>
																			
																		</div>
																	</div>
																
																	<div style="height:300px;"></div>
															</div>
															
														</div>
														
														
														<!--- // offer in compromise tab --->
														<div class="tab-pane" id="taboffer">
															
															<div class="accordion" id="basic-accordion5">
															
															
																<cfif optiontree7.subcat7oic is true >
																	
																	<cfinvoke component="apis.com.clarifyingpoints" method="getoiclist" returnvariable="oiclist">
																		<cfinvokeargument name="treenum" value="7">
																		<cfinvokeargument name="branchname" value="Offer in Compromise">
																	</cfinvoke>
																	
																			<div class="accordion-group">
																				<div class="accordion-heading">
																					<a class="accordion-toggle" data-toggle="collapse" data-parent="#basic-accordion5" href="#csixteen">
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
																		<strong><i class="icon-check"></i> NOT QUALIFIED!</strong>  Sorry, based on the information entered, you do not qualify for any concessions under Offer in Compromise for Private Loans...
																	</div>
																	<div style="height:300px;"></div>
																
																</cfif>
															
															</div>
															
														</div>
														
														
														<!--- // bankruptcy tab --->
														<div class="tab-pane" id="tabbank">
															
															<div class="accordion" id="basic-accordion6">
															
																<cfif optiontree7.subcat7bk is true >
																
																	<cfinvoke component="apis.com.clarifyingpoints" method="getbklist" returnvariable="bklist">
																		<cfinvokeargument name="treenum" value="7">
																		<cfinvokeargument name="branchname" value="Bankruptcy">
																	</cfinvoke>
																	
																			<div class="accordion-group">
																				<div class="accordion-heading">
																					<a class="accordion-toggle" data-toggle="collapse" data-parent="#basic-accordion6" href="#cseventeen">
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
																		<strong><i class="icon-check"></i> NOT QUALIFIED!</strong>  Sorry, based on the information entered, you do not qualify for any concessions under bankruptcy for Private Loans...
																	</div>
																	<div style="height:300px;"></div>
																
																</cfif>
															
															</div>
															
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


				