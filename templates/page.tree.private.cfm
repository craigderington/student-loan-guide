

			
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
				<cfset tree = 7 />
				<cfset treename = "Private Loan" />
				
				<!--- get our tree structure for stafford loans --->
				<cfinvoke component="apis.com.trees.optiontree7" method="getoptiontree7" returnvariable="optiontree7">
					<cfinvokeargument name="leadid" value="#session.leadid#">
				</cfinvoke>
												
				<cfif optiontree7.subcat7 is not true >
					<cflocation url="#application.root#?event=page.tree" addtoken="no" >
				</cfif>
				
				<!--- // get our tabs and tab order --->
				
				<cfparam name="tabcancel" default="false">				
				<cfparam name="tabdefault" default="false">
				<cfparam name="tabrepay" default="false">
				<cfparam name="tabpost" default="false">
				<cfparam name="taboffer" default="false">
				<cfparam name="tabbk" default="false">
				<cfparam name="taborder" default="0">			
				
				<cfif optiontree7.subcat7canceldeath is true >
					<cfset tabcancel = true />
				<cfelseif optiontree7.subcat7legalage is true >
					<cfset tabcancel = true />
				<cfelseif optiontree7.subcat7ftcrule is true >
					<cfset tabcancel = true />
				<cfelseif optiontree7.subcat7mixeduse is true >
					<cfset tabcancel = true />
				<cfelseif optiontree7.subcat7idtheft is true >
					<cfset tabcancel = true />				
				</cfif>		
				
				<cfif optiontree7.subcat7default is true >
					<cfset tabdefault = true />
				</cfif>
				
				<cfset tabrepay = true />
				
				<cfset tabpost = true />
				
				<cfif optiontree7.subcat7oic is true >
					<cfset taboffer = true />
				</cfif>
				
				<cfif optiontree7.subcat7bk is true >
					<cfset tabbk = true />
				</cfif>
				
				<!--- // end tab defintion and order --->
			

				<!--- // 10-15-2013 // re-work the Option Tree Page --->
				<!--- // begin option tree 2 --->
				
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
													
													<cfif tabdefault is true >
													<li <cfif tabcancel is false>class="active"</cfif>><a href="#tabdefault" data-toggle="tab">Default Intervention</a></li>
													</cfif>
													
													<cfif tabrepay is true >
													<li <cfif tabcancel is false and tabdefault is false>class="active"</cfif>><a href="#tabrepay" data-toggle="tab">Repayment</a></li>
													</cfif>
													
													<cfif tabpost is true >
													<li <cfif tabcancel is false and tabdefault is false and tabrepay is false>class="active"</cfif>><a href="#tabpost" data-toggle="tab">Postponement</a></li>
													</cfif>
													
													<cfif taboffer is true >													
													<li <cfif tabcancel is false and tabdefault is false and tabrepay is false and tabpost is false>class="active"</cfif>><a href="#taboffer" data-toggle="tab">Offer In Compromise</a></li>
													</cfif>
													
													<cfif tabbk is true >
													<li <cfif tabcancel is false and tabdefault is false and tabrepay is false and tabpost is false and taboffer is false>class="active"</cfif>><a href="#tabbank" data-toggle="tab">Bankruptcy</a></li>
													</cfif>
												</ul>
									
												<br>											
													
												

												
												<!--- // begin tab content --->
												<div class="tab-content">													
														
														
														
														<!--- // cancellation tab --->
														<div class="tab-pane <cfif tabcancel is true >active</cfif>" id="tabcancel">														
																	
															<cfif optiontree7.subcat7legalage is true>
																		
																<cfinvoke component="apis.com.clients.clarifyingpoints" method="getlegallist" returnvariable="legallist">
																	<cfinvokeargument name="treenum" value="7">
																	<cfinvokeargument name="branchname" value="Legal Age">
																</cfinvoke>																			
																			
																<table class="table table-bordered table-striped table-highlight">
																	<thead>
																		<cfoutput>
																		<tr>
																			<th>Legal Age Cancellation <span style="float:right;"><a href="#application.root#?event=page.tree" class="btn btn-mini btn-tertiary">Return to Option Tree</a>&nbsp;&nbsp;<a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=cancel&solution=age" class="btn btn-mini btn-primary">Choose This Solution</a></span></th>
																		</tr>
																		</cfoutput>
																	</thead>
																	<tbody>
																		<tr>
																			<td>
																				<cfoutput query="legallist">
																					<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																						#urldecode( pointtext )#</li>
																				</cfoutput>
																			</td>
																		</tr>
																	</tbody>
																</table>																
															
															</cfif>
																	
																	
															<cfif optiontree7.subcat7mixeduse is true>
																		
																<cfinvoke component="apis.com.clients.clarifyingpoints" method="getmxlist" returnvariable="mxlist">
																	<cfinvokeargument name="treenum" value="7">
																	<cfinvokeargument name="branchname" value="Mixed Use Loan">
																</cfinvoke>
																			
																<table class="table table-bordered table-striped table-highlight">
																	<thead>
																		<cfoutput>
																		<tr>
																			<th>Mixed Use Cancellation <span style="float:right;"><a href="#application.root#?event=page.tree" class="btn btn-mini btn-tertiary">Return to Option Tree</a>&nbsp;&nbsp;<a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=cancel&solution=mixed" class="btn btn-mini btn-primary">Choose This Solution</a></span></th>
																		</tr>
																		</cfoutput>
																	</thead>
																	<tbody>
																		<tr>
																			<td>
																				<cfoutput query="mxlist">
																					<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																						#urldecode( pointtext )#</li>
																				</cfoutput>
																			</td>
																		</tr>
																	</tbody>
																</table>														

															</cfif>
															
																	
															<cfif optiontree7.subcat7canceldeath is true>
																	
																<cfinvoke component="apis.com.clients.clarifyingpoints" method="getdeathlist" returnvariable="deathlist">
																	<cfinvokeargument name="treenum" value="7">
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
																	
																	
															<cfif optiontree7.subcat7ftcrule is true>
																		
																<cfinvoke component="apis.com.clients.clarifyingpoints" method="getftclist" returnvariable="ftclist">
																	<cfinvokeargument name="treenum" value="7">
																	<cfinvokeargument name="branchname" value="FTC Holder Rule">
																</cfinvoke>
																	
																<table class="table table-bordered table-striped table-highlight">
																	<thead>
																		<cfoutput>
																		<tr>
																			<th>FTC Holder Rule Cancellation <span style="float:right;"><a href="#application.root#?event=page.tree" class="btn btn-mini btn-tertiary">Return to Option Tree</a>&nbsp;&nbsp;<a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=cancel&solution=ftc" class="btn btn-mini btn-primary">Choose This Solution</a></span></th>
																		</tr>
																		</cfoutput>
																	</thead>
																	<tbody>
																		<tr>
																			<td>
																				<cfoutput query="ftclist">
																					<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																						#urldecode( pointtext )#</li>
																				</cfoutput>
																			</td>
																		</tr>
																	</tbody>
																</table>							
																	
															</cfif>

															
															<cfif optiontree7.subcat7idtheft is true>
																		
																<cfinvoke component="apis.com.clients.clarifyingpoints" method="gettheftlist" returnvariable="theftlist">
																	<cfinvokeargument name="treenum" value="7">
																	<cfinvokeargument name="branchname" value="ID Theft">
																</cfinvoke>
																	
																<table class="table table-bordered table-striped table-highlight">
																	<thead>
																		<cfoutput>
																		<tr>
																			<th>Identity Theft Cancellation <span style="float:right;"><a href="#application.root#?event=page.tree" class="btn btn-mini btn-tertiary">Return to Option Tree</a>&nbsp;&nbsp;<a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=cancel&solution=theft" class="btn btn-mini btn-primary">Choose This Solution</a></span></th>
																		</tr>
																		</cfoutput>
																	</thead>
																	<tbody>
																		<tr>
																			<td>
																				<cfoutput query="theftlist">
																					<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																						#urldecode( pointtext )#</li>
																				</cfoutput>
																			</td>
																		</tr>
																	</tbody>
																</table>							
																	
															</cfif>					
															
															
															</div><!-- /. cancel tab -->								
														
														
														
														
														<!--- // default intervention tab --->
														
														<div class="tab-pane <cfif tabdefault is true and tabcancel is false >active</cfif>" id="tabdefault">													
															
															<cfif optiontree7.subcat7default is true >
																	
																<cfif trim( optiontree7.subcat7defaultstat ) is "yes" >
																		
																	<cfinvoke component="apis.com.clients.clarifyingpoints" method="getstatlist" returnvariable="statlist">
																		<cfinvokeargument name="treenum" value="7">
																		<cfinvokeargument name="branchname" value="Statue of Limitations on Collections">
																	</cfinvoke>																	
																	
																	<table class="table table-bordered table-striped table-highlight">
																		<thead>
																			<cfoutput>
																				<tr>
																					<th>Statue of Limitations on Collections <span style="float:right;"><a href="#application.root#?event=page.tree" class="btn btn-mini btn-tertiary">Return to Option Tree</a>&nbsp;&nbsp;<a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=default&solution=statute" class="btn btn-mini btn-primary">Choose This Solution</a></span></th>
																				</tr>
																			</cfoutput>																		
																		</thead>
																		<tbody>
																			<tr>
																				<td>
																					<cfoutput query="statlist">
																						<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																					</cfoutput>
																				</td>
																			</tr>
																		</tbody>
																	</table>
																
																</cfif>
																	
																	
																<cfif optiontree7.subcat7validate is true >
																		
																	<cfinvoke component="apis.com.clients.clarifyingpoints" method="getvalidatelist" returnvariable="validatelist">
																		<cfinvokeargument name="treenum" value="7">
																		<cfinvokeargument name="branchname" value="Validation">
																	</cfinvoke>
																		
																	<table class="table table-bordered table-striped table-highlight">
																		<thead>																			
																			<cfoutput>
																				<tr>
																					<th>Debt Validation (Default Intervention) <span style="float:right;"><a href="#application.root#?event=page.tree" class="btn btn-mini btn-tertiary">Return to Option Tree</a>&nbsp;&nbsp;<a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=default&solution=debtval" class="btn btn-mini btn-primary">Choose This Solution</a></span></th>
																				</tr>
																			</cfoutput>
																		</thead>
																		<tbody>
																			<tr>
																				<td>
																					<cfoutput query="validatelist">
																						<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																					</cfoutput>
																				</td>
																			</tr>
																		</tbody>
																	</table>	
																	
																</cfif>
															
															</cfif>														
															
															
														</div><!-- /.default-intervention -->												
														
														
														
														
														
														<!--- // repayments tab --->
														<div class="tab-pane <cfif tabrepay is true and tabdefault is false and tabcancel is false >active</cfif>" id="tabrepay">														
															
															<cfif optiontree7.subcat7hardship is true >
															
																<!--- // hard ship eleigibility clarifying points --->
																<cfinvoke component="apis.com.clients.clarifyingpoints" method="gethardshiplist" returnvariable="hardshiplist">
																	<cfinvokeargument name="treenum" value="7">
																	<cfinvokeargument name="branchname" value="Hardship Eligibility">
																</cfinvoke>
																		
																<table class="table table-bordered table-striped table-highlight">
																	<thead>
																		<cfoutput>
																			<tr>
																				<th>Hardship Eligibility <span style="float:right;"><a href="#application.root#?event=page.tree" class="btn btn-mini btn-tertiary">Return to Option Tree</a>&nbsp;&nbsp;<a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=repay&solution=hardship" class="btn btn-mini btn-primary">Choose This Solution</a></span></th>
																			</tr>
																		</cfoutput>
																	</thead>
																	<tbody>
																		<tr>
																			<td>
																				<cfoutput query="hardshiplist">
																					<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																						#urldecode( pointtext )#</li>
																				</cfoutput>
																			</td>
																		</tr>
																	</tbody>
																</table>																	
															
															</cfif>
															
															
															<cfif optiontree7.subcat7mod is true >
															
																<!--- // loam modifications clarifying points --->
																<cfinvoke component="apis.com.clients.clarifyingpoints" method="getmodlist" returnvariable="modlist">
																	<cfinvokeargument name="treenum" value="7">
																	<cfinvokeargument name="branchname" value="Modifications">
																</cfinvoke>
																		
																<table class="table table-bordered table-striped table-highlight">
																	<thead>
																		<cfoutput>
																			<tr>
																				<th>Loan Modifications <span style="float:right;"><a href="#application.root#?event=page.tree" class="btn btn-mini btn-tertiary">Return to Option Tree</a>&nbsp;&nbsp;<a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=repay&solution=mod" class="btn btn-mini btn-primary">Choose This Solution</a></span></th>
																			</tr>
																		</cfoutput>
																	</thead>
																	<tbody>
																		<tr>
																			<td>
																				<cfoutput query="modlist">
																					<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																						#urldecode( pointtext )#</li>
																				</cfoutput>
																			</td>
																		</tr>
																	</tbody>
																</table>
															
															</cfif>
																		
															
															<cfif optiontree7.subcat7ext is true>
															
																<!--- // consolidation repayment clarifying points --->
																<cfinvoke component="apis.com.clients.clarifyingpoints" method="getextlist" returnvariable="extlist">
																	<cfinvokeargument name="treenum" value="7">
																	<cfinvokeargument name="branchname" value="Extensions">
																</cfinvoke>
																		
																<table class="table table-bordered table-striped table-highlight">
																	<thead>
																		<cfoutput>
																			<tr>
																				<th>Loan Extensions <span style="float:right;"><a href="#application.root#?event=page.tree" class="btn btn-mini btn-tertiary">Return to Option Tree</a>&nbsp;&nbsp;<a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=repay&solution=ext" class="btn btn-mini btn-primary">Choose This Solution</a></span></th>
																			</tr>
																		</cfoutput>
																	</thead>
																	<tbody>
																		<tr>
																			<td>
																				<cfoutput query="extlist">
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
														<div class="tab-pane <cfif tabpost is true and tabrepay is false and tabdefault is false and tabcancel is false >active</cfif>" id="tabpost">														
															
															<cfinvoke component="apis.com.clients.clarifyingpoints" method="getpostlist" returnvariable="postlist">
																<cfinvokeargument name="treenum" value="7">
																<cfinvokeargument name="branchname" value="Postponement">
															</cfinvoke>
																			
																	<table class="table table-bordered table-striped table-highlight">
																		<thead>
																			<cfoutput>
																				<tr>
																					<th>Postponement <span style="float:right;"><a href="#application.root#?event=page.tree" class="btn btn-mini btn-tertiary">Return to Option Tree</a>&nbsp;&nbsp;<a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=post&solution=forbear" class="btn btn-mini btn-primary">Choose This Solution</a></span></th>
																				</tr>
																			</cfoutput>
																		</thead>
																		<tbody>
																			<tr>
																				<td>
																					<cfoutput query="postlist">
																						<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																					</cfoutput>
																				</td>
																			</tr>
																		</tbody>
																	</table>		
																														
																
														</div><!-- /. postponement-tab -->
														
														
														
														
														
														
														<!--- // offer in compromise tab --->
														<div class="tab-pane <cfif taboffer is true and tabpost is false and tabrepay is false and tabdefault is false and tabcancel is false >active</cfif>" id="taboffer">													
															
															<cfif optiontree7.subcat7oic is true >
																	
																<cfinvoke component="apis.com.clients.clarifyingpoints" method="getoiclist" returnvariable="oiclist">
																	<cfinvokeargument name="treenum" value="7">
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
														<div class="tab-pane <cfif tabbk is true and taboffer is false and tabpost is false and tabrepay is false and tabdefault is false and tabcancel is false >active</cfif>" id="tabbank">									
															
															<cfif optiontree7.subcat7bk is true >
																
																<cfinvoke component="apis.com.clients.clarifyingpoints" method="getbklist" returnvariable="bklist">
																	<cfinvokeargument name="treenum" value="7">
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
												<i class="icon-check"></i> #solutionoption# - <cfif servid neq -1>#servname#<cfelse>#nslservicer#</cfif><br />
											</cfoutput>
											<cfoutput>
												<span style="float;right;margin-top:10px;"><a href="#application.root#?event=page.solution" class="btn btn-mini btn-primary"><i class="icon-shopping-cart"></i> View Solution Cart</a>&nbsp;<a href="#application.root#?event=page.tree" class="btn btn-mini btn-secondary"><i class="icon-sitemap"></i> More Options</a></span>											
											</cfoutput>
										<cfelse>
											<i class="icon-warning-sign"></i>  No solutions selected
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