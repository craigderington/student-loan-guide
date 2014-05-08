

		
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
				
				<cfinvoke component="apis.com.solutions.solutiongateway" method="getsolutions" returnvariable="solutionlist">
					<cfinvokeargument name="leadid" value="#session.leadid#">
				</cfinvoke>
				
				
				
				<!--- // set up some page params --->
				<cfparam name="tree" default="">
				<cfparam name="treename" default="">				
				<cfset tree = 5 />
				<cfset treename = "Health Professional Loan" />
			
				<!--- get our tree structure for stafford loans --->
				<cfinvoke component="apis.com.trees.optiontree5" method="getoptiontree5" returnvariable="optiontree5">
					<cfinvokeargument name="leadid" value="#session.leadid#">
				</cfinvoke>
												
				<cfif optiontree5.subcat5 is not true >
					<cflocation url="#application.root#?event=page.tree" addtoken="no" >
				</cfif>
				
				<!--- // get our tabs and tab order --->
				
				<cfparam name="tabcancel" default="false">
				<cfparam name="tabforgive" default="false">
				<cfparam name="tabdefault" default="false">
				<cfparam name="tabrepay" default="false">
				<cfparam name="tabpost" default="false">
				<cfparam name="taboffer" default="false">
				<cfparam name="tabbk" default="false">
				<cfparam name="taborder" default="0">			
				
				
				<cfif optiontree5.subcat5canceldeath is true >
					<cfset tabcancel = true />
				<cfelseif optiontree5.subcat5canceldisable is true >
					<cfset tabcancel = true />
				</cfif>
				
				<cfif optiontree5.subcat5psforgive is true >
					<cfset tabforgive = true />				
				</cfif>
				
				<cfif optiontree5.subcat5default is true >
					<cfset tabdefault = true />
				</cfif>
				
				<cfset tabrepay = true />
				
				<cfif optiontree5.subcat5post is true >
					<cfset tabpost = true />
				<cfelseif optiontree5.subcat5postdefer is "yes">
					<cfset tabpost = true />
				<cfelseif optiontree5.subcat5forbear is true>
					<cfset tabpost = true />
				</cfif>
				
				<cfif optiontree5.subcat5oic is true >
					<cfset taboffer = true />
				</cfif>
				
				<cfif optiontree5.subcat5bk is true >
					<cfset tabbk = true />
				</cfif>
				
				<!--- // end tab defintion and order --->
				
				
				
				<!--- // 10-15-2013 // Re-work the Option Tree Page --->
				<!--- // begin option tree 5 --->
				
				<div class="main">	
				
					<div class="container">
					
						<div class="row">
			
							<div class="span9">
							
								<div class="widget stacked">
									<cfoutput>
									<div class="widget-header">		
										<i class="icon-sitemap"></i>							
										<h3>#treename# Option Tree Clarifying Points for #leaddetail.leadfirst# #leaddetail.leadlast# </h3>						
									</div> <!-- //.widget-header -->
									</cfoutput>
										
										
										
										<div class="widget-content">							
											
											<div class="alert alert-error">
												<button type="button" class="close" data-dismiss="alert">&times;</button>
												<strong><i class="icon-question-sign"></i> IMPORTANT!</strong>  Please do not select any solution until you have reviewed all eligible loan options.
											</div>
											
											<!--- // the sub-category option tree tabs --->
											<div class="tabbable">
												
												<ul class="nav nav-tabs">
													<cfif tabcancel is true >
													<li class="active"><a href="#tabcancel" data-toggle="tab">Cancellation</a></li>
													</cfif>
													
													<cfif tabforgive is true >
													<li <cfif tabcancel is false >class="active"</cfif>><a href="#tabforgive" data-toggle="tab">Forgiveness</a></li>
													</cfif>
													
													<cfif tabdefault is true >
													<li <cfif tabcancel is false and tabforgive is false>class="active"</cfif>><a href="#tabdefault" data-toggle="tab">Default Intervention</a></li>
													</cfif>
													
													<cfif tabrepay is true >
													<li <cfif tabcancel is false and tabforgive is false and tabdefault is false>class="active"</cfif>><a href="#tabrepay" data-toggle="tab">Repayment</a></li>
													</cfif>
													
													<cfif tabpost is true >
													<li <cfif tabcancel is false and tabforgive is false and tabdefault is false and tabrepay is false>class="active"</cfif>><a href="#tabpost" data-toggle="tab">Postponement</a></li>
													</cfif>
													
													<cfif taboffer is true >													
													<li <cfif tabcancel is false and tabforgive is false and tabdefault is false and tabrepay is false and tabpost is false>class="active"</cfif>><a href="#taboffer" data-toggle="tab">Offer In Compromise</a></li>
													</cfif>
													
													<cfif tabbk is true >
													<li <cfif tabcancel is false and tabforgive is false and tabdefault is false and tabrepay is false and tabpost is false and taboffer is false>class="active"</cfif>><a href="#tabbank" data-toggle="tab">Bankruptcy</a></li>
													</cfif>
												</ul>
									
												<br>											
													
												

												
												<!--- // begin tab content --->
												<div class="tab-content">													
														
														
														
														<!--- // cancellation tab --->
														<div class="tab-pane <cfif tabcancel is true >active</cfif>" id="tabcancel">									
																	
															<cfif optiontree5.subcat5canceldeath is true>
																	
																<cfinvoke component="apis.com.clients.clarifyingpoints" method="getdeathlist" returnvariable="deathlist">
																	<cfinvokeargument name="treenum" value="5">
																	<cfinvokeargument name="branchname" value="Death">
																</cfinvoke>
																			
																<table class="table table-bordered table-striped table-highlight">
																	<thead>
																		<cfoutput>
																		<tr>
																			<th>Death Cancellation <span style="float:right;"><a href="#application.root#?event=page.tree" class="btn btn-mini btn-tertiary">Return to Option Tree</a>&nbsp;&nbsp;<a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=cancel&solution=death" class="btn btn-mini btn-primary">Choose This Solution</a></span></th>
																		</tr>
																		</cfoutput>
																	</thead>
																	<tbody>
																		<tr>
																			<td>
																				<cfoutput query="deathlist">
																					<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																						#urldecode( pointtext )#</li>
																				</cfoutput>
																			</td>
																		</tr>
																	</tbody>
																</table>
																
															</cfif>														
																	
																	
															<cfif optiontree5.subcat5canceldisable is true>
																		
																<cfinvoke component="apis.com.clients.clarifyingpoints" method="getdisablelist" returnvariable="disablelist">
																	<cfinvokeargument name="treenum" value="3">
																	<cfinvokeargument name="branchname" value="Disability">
																</cfinvoke>
																	
																<table class="table table-bordered table-striped table-highlight">
																	<thead>
																		<cfoutput>
																		<tr>
																			<th>Disability Cancellation <span style="float:right;"><a href="#application.root#?event=page.tree" class="btn btn-mini btn-tertiary">Return to Option Tree</a>&nbsp;&nbsp;<a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=cancel&solution=disability" class="btn btn-mini btn-primary">Choose This Solution</a></span></th>
																		</tr>
																		</cfoutput>
																	</thead>
																	<tbody>
																		<tr>
																			<td>
																				<cfoutput query="disablelist">
																					<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																						#urldecode( pointtext )#</li>
																				</cfoutput>
																			</td>
																		</tr>
																	</tbody>
																</table>							
																	
															</cfif>				
																													
															
															</div><!-- /. cancel tab -->					
														
														
														
														
														
														
														
														<!--- // forgiveness tab --->
														
														<div class="tab-pane <cfif tabforgive is true and tabcancel is false >active</cfif>" id="tabforgive">														
																
															<cfif optiontree5.subcat5psforgive is true >
																	
																<cfinvoke component="apis.com.clients.clarifyingpoints" method="getpslist" returnvariable="pslist">
																	<cfinvokeargument name="treenum" value="5">
																	<cfinvokeargument name="branchname" value="Public Service Loan Forgiveness">
																</cfinvoke>
																	
																
																<table class="table table-bordered table-striped table-highlight">
																	<thead>
																		<cfoutput>
																		<tr>
																			<th>Public Service Loan Forgiveness <span style="float:right;"><a href="#application.root#?event=page.tree" class="btn btn-mini btn-tertiary">Return to Option Tree</a>&nbsp;&nbsp;<a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=forgive&solution=pslf" class="btn btn-mini btn-primary">Choose This Solution</a></span></th>
																		</tr>
																		</cfoutput>
																	</thead>
																	<tbody>
																		<tr>
																			<td>
																				<cfoutput query="pslist">
																					<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																						#urldecode( pointtext )#</li>
																				</cfoutput>
																			</td>
																		</tr>
																	</tbody>
																</table>	
																
															</cfif>													
																										
															
														</div><!-- /.forgiveness tab -->
														
														
														
														
														
														
														<!--- // default intervention tab --->
														
														<div class="tab-pane <cfif tabdefault is true and tabforgive is false and tabcancel is false >active</cfif>" id="tabdefault">													
															
															
																	
																<cfif trim( optiontree5.subcat5rehab ) is "yes" >
																		
																	<cfinvoke component="apis.com.clients.clarifyingpoints" method="getrehablist" returnvariable="rehablist">
																		<cfinvokeargument name="treenum" value="5">
																		<cfinvokeargument name="branchname" value="Rehabilitation">
																	</cfinvoke>																	
																	
																	<table class="table table-bordered table-striped table-highlight">
																		<thead>
																			<cfoutput>
																				<tr>
																					<th>Rehabilitation (Default Intervention) <span style="float:right;"><a href="#application.root#?event=page.tree" class="btn btn-mini btn-tertiary">Return to Option Tree</a>&nbsp;&nbsp;<a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=default&solution=rehab" class="btn btn-mini btn-primary">Choose This Solution</a></span></th>
																				</tr>
																			</cfoutput>																		
																		</thead>
																		<tbody>
																			<tr>
																				<td>
																					<cfoutput query="rehablist">
																						<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																					</cfoutput>
																				</td>
																			</tr>
																		</tbody>
																	</table>
																
																</cfif>
																	
																	
																<cfif trim( optiontree5.subcat5consol ) is "yes" >
																	
																	<!--- // 12-9-2013 // add qualifier for subcat5 repayment --->
																	<cfif optiontree5.subcat5repay is true >
																			
																		<cfinvoke component="apis.com.clients.clarifyingpoints" method="getconsollist" returnvariable="consollist">
																			<cfinvokeargument name="treenum" value="5">
																			<cfinvokeargument name="branchname" value="Consolidation">
																		</cfinvoke>
																			
																		<table class="table table-bordered table-striped table-highlight">
																			<thead>																			
																				<cfoutput>
																					<tr>
																						<th>Consolidation (Default Intervention) <span style="float:right;"><a href="#application.root#?event=page.tree" class="btn btn-mini btn-tertiary">Return to Option Tree</a>&nbsp;&nbsp;<a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=default&solution=consol" class="btn btn-mini btn-primary">Choose This Solution</a></span></th>
																					</tr>
																				</cfoutput>
																			</thead>
																			<tbody>
																				<tr>
																					<td>
																						<cfoutput query="consollist">
																							<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																								#urldecode( pointtext )#</li>
																						</cfoutput>
																					</td>
																				</tr>
																			</tbody>
																		</table>	
																	</cfif>
																</cfif>								
															
															
														</div><!-- /.default-intervention-tab -->												
														
														
														
														
														
														<!--- // repayments tab --->
														<div class="tab-pane <cfif tabrepay is true and tabdefault is false and tabforgive is false and tabcancel is false >active</cfif>" id="tabrepay">														
															
															<div class="alert alert-info fade in">
																<button type="button" class="close" data-dismiss="alert">&times;</button>
																<h5><i class="icon-comments"></i> STUDENT LOAN DEBT CONSOLIDATION</h5>
																<p style="margin-top:7px;"><strong>To view repayment options and the student loan repayment calculator, please add one of these consolidation solutions to your solution cart and include the student loan in your consolidation.</strong></p>
															</div>
															
															
															
															<!--- // non-consolidated repayment clarifying points --->
															<cfinvoke component="apis.com.clients.clarifyingpoints" method="getrepaynonconsollist" returnvariable="repaynonconsollist">
																<cfinvokeargument name="treenum" value="5">
																<cfinvokeargument name="branchname" value="Non-Consolidated Repayment">
															</cfinvoke>
																	
															<table class="table table-bordered table-striped table-highlight">
																<thead>
																	<cfoutput>
																		<tr>
																			<th>Non-Consolidation Repayment <span style="float:right;"><a href="#application.root#?event=page.tree" class="btn btn-mini btn-tertiary">Return to Option Tree</a>&nbsp;&nbsp;<a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=repay&solution=nonconsol" class="btn btn-mini btn-primary">Choose This Solution</a></span></th>
																		</tr>
																	</cfoutput>
																</thead>
																<tbody>
																	<tr>
																		<td>
																			<cfoutput query="repaynonconsollist">
																				<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																					#urldecode( pointtext )#</li>
																			</cfoutput>
																		</td>
																	</tr>
																</tbody>
															</table>																	
															
															<!--- // 12-9-2013 // add qualifier for subcat5 repayment --->
															<cfif optiontree5.subcat5repay is true >
																<!--- // consolidated repayment clarifying points --->
																<cfinvoke component="apis.com.clients.clarifyingpoints" method="getrepayconsollist" returnvariable="repayconsollist">
																	<cfinvokeargument name="treenum" value="5">
																	<cfinvokeargument name="branchname" value="Consolidated Repayment">
																</cfinvoke>
																		
																<table class="table table-bordered table-striped table-highlight">
																	<thead>
																		<cfoutput>
																			<tr>
																				<th>Consolidation Repayment <span style="float:right;"><a href="#application.root#?event=page.tree" class="btn btn-mini btn-tertiary">Return to Option Tree</a>&nbsp;&nbsp;<a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=repay&solution=consol" class="btn btn-mini btn-primary">Choose This Solution</a></span></th>
																			</tr>
																		</cfoutput>
																	</thead>
																	<tbody>
																		<tr>
																			<td>
																				<cfoutput query="repayconsollist">
																					<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																						#urldecode( pointtext )#</li>
																				</cfoutput>
																			</td>
																		</tr>
																	</tbody>
																</table>
															</cfif>
																	
															
															
														</div><!-- /. repayment-tab -->
														
														
														
														
														<!--- // postponement tab --->
														<div class="tab-pane <cfif tabpost is true and tabrepay is false and tabdefault is false and tabforgive is false and tabcancel is false >active</cfif>" id="tabpost">														
															
															
																	
																<cfif trim( optiontree5.subcat5postdefer ) is "yes" >
																		
																	<cfinvoke component="apis.com.clients.clarifyingpoints" method="getdeferlist" returnvariable="deferlist">
																		<cfinvokeargument name="treenum" value="5">
																		<cfinvokeargument name="branchname" value="Deferment">
																	</cfinvoke>
																			
																	<table class="table table-bordered table-striped table-highlight">
																		<thead>
																			<cfoutput>
																				<tr>
																					<th>Deferment (Postponement) <span style="float:right;"><a href="#application.root#?event=page.tree" class="btn btn-mini btn-tertiary">Return to Option Tree</a>&nbsp;&nbsp;<a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=post&solution=defer" class="btn btn-mini btn-primary">Choose This Solution</a></span></th>
																				</tr>
																			</cfoutput>
																		</thead>
																		<tbody>
																			<tr>
																				<td>
																					<cfoutput query="deferlist">
																						<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																					</cfoutput>
																				</td>
																			</tr>
																		</tbody>
																	</table>
																
																</cfif>
																	
																	
																<cfif optiontree5.subcat5forbear is true >
																		
																	<cfinvoke component="apis.com.clients.clarifyingpoints" method="getfinhardlist" returnvariable="finhardlist">
																		<cfinvokeargument name="treenum" value="5">
																		<cfinvokeargument name="branchname" value="Financial Hardship Forbearance">
																	</cfinvoke>
																			
																	<table class="table table-bordered table-striped table-highlight">
																		<thead>
																			<cfoutput>
																				<tr>
																					<th>Forbearance (Postponement) <span style="float:right;"><a href="#application.root#?event=page.tree" class="btn btn-mini btn-tertiary">Return to Option Tree</a>&nbsp;&nbsp;<a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=post&solution=forbear" class="btn btn-mini btn-primary">Choose This Solution</a></span></th>
																				</tr>
																			</cfoutput>
																		</thead>
																		<tbody>
																			<tr>
																				<td>
																					<cfoutput query="finhardlist">
																						<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																					</cfoutput>
																				</td>
																			</tr>
																		</tbody>
																	</table>	
																
																</cfif>
															
																												
																
														</div><!-- /. postponement-tab -->
														
														
														
														
														
														
														<!--- // offer in compromise tab --->
														<div class="tab-pane <cfif taboffer is true and tabpost is false and tabrepay is false and tabdefault is false and tabforgive is false and tabcancel is false >active</cfif>" id="taboffer">													
															
															<cfif optiontree5.subcat5oic is true >
																	
																<cfinvoke component="apis.com.clients.clarifyingpoints" method="getoiclist" returnvariable="oiclist">
																	<cfinvokeargument name="treenum" value="5">
																	<cfinvokeargument name="branchname" value="Offer in Compromise">
																</cfinvoke>
																	
																<table class="table table-bordered table-striped table-highlight">
																	<thead>
																		<cfoutput>
																			<tr>
																				<th>Offer in Compromise <span style="float:right;"><a href="#application.root#?event=page.tree" class="btn btn-mini btn-tertiary">Return to Option Tree</a>&nbsp;&nbsp;<a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=oic&solution=oic" class="btn btn-mini btn-primary">Choose This Solution</a></span></th>
																			</tr>
																		</cfoutput>
																	</thead>
																	<tbody>
																		<tr>
																			<td>
																				<cfoutput query="oiclist">
																					<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																						#urldecode( pointtext )#</li>
																				</cfoutput>
																			</td>
																		</tr>
																	</tbody>
																</table>							
																
															</cfif>
															
														</div><!-- /.oic-tab -->
														
														
														
														
														
														<!--- // bankruptcy tab --->
														<div class="tab-pane <cfif tabbk is true and taboffer is false and tabpost is false and tabrepay is false and tabdefault is false and tabforgive is false and tabcancel is false >active</cfif>" id="tabbank">									
															
															<cfif optiontree5.subcat5bk is true >
																
																<cfinvoke component="apis.com.clients.clarifyingpoints" method="getbklist" returnvariable="bklist">
																	<cfinvokeargument name="treenum" value="5">
																	<cfinvokeargument name="branchname" value="Bankruptcy">
																</cfinvoke>
																	
																<table class="table table-bordered table-striped table-highlight">
																	<thead>
																		<cfoutput>
																			<tr>
																				<th>Bankruptcy <span style="float:right;"><a href="#application.root#?event=page.tree" class="btn btn-mini btn-tertiary">Return to Option Tree</a>&nbsp;&nbsp;<a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=bk&solution=bk" class="btn btn-mini btn-primary">Choose This Solution</a></span></th>
																			</tr>
																		</cfoutput>
																	</thead>
																	<tbody>
																		<tr>
																			<td>
																				<cfoutput query="bklist">
																					<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																						#urldecode( pointtext )#</li>
																				</cfoutput>
																			</td>
																		</tr>
																	</tbody>
																</table>					
																
															</cfif>
															
														</div><!-- /.bk-tab -->					
													
													
												</div><!-- / .tab-content -->				
												
												
											</div><!-- /.tabbable .tabsmenu -->
											

										<div class="clear"></div>
										</div> <!-- //.widget-content -->	
									
								</div> <!-- //.widget -->
							
							</div> <!-- //.span9 -->
							
							
							<!--- // solution cart sidebar --->
							<div class="span3">
								
								<div class="widget stacked">
									
									<div class="widget-header">
										<i class="icon-book"></i> 
										<h3>Your Solutions   <cfif solutionlist.recordcount gt 0><span style="margin-left:10px;" class="badge badge-important"><cfoutput>#solutionlist.recordcount#</cfoutput></span></cfif></h3>
									</div>
								
									<div class="widget-content">
										
										<cfif solutionlist.recordcount gt 0>										
											<cfoutput query="solutionlist">
												<i class="icon-check"></i> #solutionoption# - #servname#<br />
											</cfoutput>
											<cfoutput>
												<span><a href="#application.root#?event=page.solution" class="btn btn-mini btn-primary" style="margin-top:10px;"><i class="icon-shopping-cart"></i> View Solution Cart</a>&nbsp;<a href="#application.root#?event=page.tree" class="btn btn-mini btn-secondary"><i class="icon-sitemap"></i> More Options</a></span>											
											</cfoutput>
										<cfelse>
											<i class="icon-warning-sign"></i> No solutions selected
										</cfif>								
										
									</div>
								</div>
								
								<div class="widget stacked">
									
									<div class="widget-header">
										<i class="icon-refresh"></i> 
										<h3>Your Student Loans</h3>
									</div>
								
									<div class="widget-content">
										<ul>									
											<cfoutput query="worksheetlist">
												<li><strong><cfif servid neq -1>#servname#<cfelse>#nslservicer#</cfif>:</strong> #dollarformat(loanbalance)#</li>
											</cfoutput>
										</ul>										
									</div>
								</div>
								
								<!--- // remove for now
								<div class="widget stacked">
									
									<div class="widget-header">
										<i class="icon-sitemap"></i> 
										<h3>Additional Options</h3>
									</div>
								
									<div class="widget-content">
										<ul>
											<li>Stafford</li>
											<li>Perkins</li>
											<li>Direct Consolidation</li>
											<li>Health Professionals</li>
											<li>Parent Plus</li>
											<li>Private Loans</li>
										</ul>										
									</div>
								</div>
								--->
							
							</div><!-- /.span3 -->
						
						</div> <!-- //.row -->				
				
					<div style="height:200px;"></div>			
				
				</div> <!-- //.container -->
			
			</div> <!-- //.main -->