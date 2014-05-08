
				
				
				
				
				
				<!--- // get our data access components --->
				
				<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
					<cfinvokeargument name="leadid" value="#session.leadid#">
				</cfinvoke>
				
				<!--- // set up some page params --->
				<cfparam name="treename" default="">				
				<cfset treename = #url.tree# />
				<cfset treename = rereplace( treename , "\b(\S)(\S*)\b" , "\u\1\L\2" , "all" ) />
				
						
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
												<h1><i class="icon-sitemap"></i> #treename# Loan Options</h1>
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
									
												
												<!--- // set up the ui for stafford loans option tree 2 --->
												<cfif trim( treename ) is "stafford">
													
													<!--- get our tree structure for stafford loans --->
													<cfinvoke component="apis.com.trees.optiontree2" method="getoptiontree2" returnvariable="optiontree2">
														<cfinvokeargument name="leadid" value="#session.leadid#">
													</cfinvoke>								
												
												
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
																						<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
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
																					  
																			<div id="cTwo" class="accordion-body collapse">
																				<div class="accordion-inner">
																					<ul>
																						<cfoutput query="schoollist">
																						<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
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
																					  
																			<div id="cThree" class="accordion-body collapse">
																				<div class="accordion-inner">
																					<ul>
																						<cfoutput query="nine11list">
																						<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
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
																					  
																			<div id="cfour" class="accordion-body collapse">
																				<div class="accordion-inner">
																					<ul>
																						<cfoutput query="deathlist">
																						<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
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
																					  
																			<div id="cfive" class="accordion-body collapse">
																				<div class="accordion-inner">
																					<ul>
																						<cfoutput query="atblist">
																						<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
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
																					  
																			<div id="csix" class="accordion-body collapse">
																				<div class="accordion-inner">
																					<ul>
																						<cfoutput query="certlist">
																						<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
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
																					  
																			<div id="cseven" class="accordion-body collapse">
																				<div class="accordion-inner">
																					<ul>
																						<cfoutput query="disablelist">
																						<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
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
															<cfif optiontree2.subcat2psforgive is true >
																
																<cfinvoke component="apis.com.clarifyingpoints" method="getpslist" returnvariable="pslist">
																	<cfinvokeargument name="treenum" value="2">
																	<cfinvokeargument name="branchname" value="Public Service Loan Forgiveness">
																</cfinvoke>
																
																		<div class="accordion-group">
																			<div class="accordion-heading">
																				<a class="accordion-toggle" data-toggle="collapse" data-parent="#basic-accordion" href="#ceight">
																					Public Service Loan Forgiveness
																				</a>
																			</div>
																					  
																			<div id="ceight" class="accordion-body in collapse">
																				<div class="accordion-inner">
																					<ul>
																						<cfoutput query="pslist">
																						<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
																			</div>
																		</div>															
															
															<cfelseif optiontree2.subcat2tlforgive is true >
																
																<cfinvoke component="apis.com.clarifyingpoints" method="getteachlist" returnvariable="teachlist">
																	<cfinvokeargument name="treenum" value="2">
																	<cfinvokeargument name="branchname" value="Teacher Loan Forgiveness">
																</cfinvoke>
																		
																		<div class="accordion-group">
																			<div class="accordion-heading">
																				<a class="accordion-toggle" data-toggle="collapse" data-parent="#basic-accordion" href="#cnine">
																					Teacher Loan Forgiveness
																				</a>
																			</div>
																					  
																			<div id="cnine" class="accordion-body collapse">
																				<div class="accordion-inner">
																					<ul>
																						<cfoutput query="teachlist">
																						<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
																			</div>
																		</div>
															
															<cfelse>
																
																<div class="alert alert-error">
																	<button type="button" class="close" data-dismiss="alert">&times;</button>
																	<strong><i class="icon-check"></i> NOT QUALIFIED!</strong>  Sorry, based on the information entered, you do not qualify for any concessions under Forgiveness for Stafford Loans...
																</div>
																<div style="height:350px;"></div>
															
															</cfif>
															
															
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
																						<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
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
																					  
																			<div id="celeven" class="accordion-body collapse">
																				<div class="accordion-inner">
																					<ul>
																						<cfoutput query="consollist">
																						<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
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
																					  
																			<div id="ctweleve" class="accordion-body collapse">
																				<div class="accordion-inner">
																					<ul>
																						<cfoutput query="wglist">
																						<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
																			</div>
																		</div>
																
																
																<cfelseif trim( optiontree2.subcatto ) is "yes" >
																	
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
																					  
																			<div id="cthirteen" class="accordion-body collapse">
																				<div class="accordion-inner">
																					<ul>
																						<cfoutput query="tolist">
																						<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
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
														
														
														<div class="tab-pane" id="tabrepay">
															{{{ this is the repayments tab }}}
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
																					  
																			<div id="cfourteen" class="accordion-body collapse">
																				<div class="accordion-inner">
																					<ul>
																						<cfoutput query="deferlist">
																						<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
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
																					  
																			<div id="cfifteen" class="accordion-body collapse">
																				<div class="accordion-inner">
																					<ul>
																						<cfoutput query="forbearlist">
																						<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
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
																					  
																			<div id="csixteen" class="accordion-body collapse">
																				<div class="accordion-inner">
																					<ul>
																						<cfoutput query="oiclist">
																						<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
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
																					  
																			<div id="cseventeen" class="accordion-body collapse">
																				<div class="accordion-inner">
																					<ul>
																						<cfoutput query="bklist">
																						<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																						</cfoutput>
																					</ul>
																				</div>
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
														
														
														<!--- // show solution buttons --->
														<cfoutput>
														<div style="float:right;"><a href="#application.root#?event=page.tree" class="btn btn-small btn-secondary"><i class="icon-hand-left"></i> Return to Option Tree</a>&nbsp;<a href="javascript:;" class="btn btn-small btn-primary"><i class="icon-check"></i> Choose This Solution</a>
														</cfoutput>
													
													
													
													</div><!-- / .tab-content -->											
													
													
												</cfif><!--- // .end of the check on the tree type --->
												
												
												
												</div><!-- /.tabbable .tabsmenu -->
											

										<div class="clear"></div>
										</div> <!-- //.widget-content -->	
									
								</div> <!-- //.widget -->
							
							</div> <!-- //.span12 -->
						
						</div> <!-- //.row -->				
				
					<div style="height:200px;"></div>			
				
				</div> <!-- //.container -->
			
			</div> <!-- //.main -->


				