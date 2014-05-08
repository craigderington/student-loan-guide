

		
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
				<cfset tree = 2 />
				<cfset treename = "FFEL Loan" />
				
				
				
				<!--- get our tree structure for stafford loans --->
				<cfinvoke component="apis.com.trees.optiontree2" method="getoptiontree2" returnvariable="optiontree2">
					<cfinvokeargument name="leadid" value="#session.leadid#">
				</cfinvoke>
												
				
				<!--- // if option tree 2 is not valid - redirect to the options tree page --->				
				<cfif optiontree2.subcat2 is not true >
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
				
				<cfif optiontree2.subcat2cancelunpaid is true >
					<cfset tabcancel = true />
				<cfelseif optiontree2.subcat2cancelcs is true >
					<cfset tabcancel = true />
				<cfelseif optiontree2.subcat2cancel911 is true >
					<cfset tabcancel = true />
				<cfelseif optiontree2.subcat2canceldeath is true >
					<cfset tabcancel = true />
				<cfelseif optiontree2.subcat2cancelatb is true >
					<cfset tabcancel = true />
				<cfelseif optiontree2.subcat2cancelcert is true >
					<cfset tabcancel = true />
				<cfelseif optiontree2.subcat2canceldisable is true >
					<cfset tabcancel = true />
				</cfif>
				
				<cfif optiontree2.subcat2psforgive is true >
					<cfset tabforgive = true />
				<cfelseif optiontree2.subcat2tlforgive is true >
					<cfset tabforgive = true />
				</cfif>
				
				<cfif optiontree2.subcat2default is true >
					<cfset tabdefault = true />
				</cfif>
				
				<cfset tabrepay = true />
				
				<cfif optiontree2.subcat2post is true >
					<cfset tabpost = true />
				</cfif>
				
				<cfif optiontree2.subcat2oic is true >
					<cfset taboffer = true />
				</cfif>
				
				<cfif optiontree2.subcat2bk is true >
					<cfset tabbk = true />
				</cfif>
				
				<!--- // end tab defintion and order --->
				
			

				<!--- // 10-15-2013 // Re-work the Option Tree Page --->
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
														<div class="tab-pane <cfif tabcancel is true>active</cfif>" id="tabcancel">									
																
																	
															<cfif optiontree2.subcat2cancelunpaid is true>
																		
																<cfinvoke component="apis.com.clients.clarifyingpoints" method="getunpaidlist" returnvariable="unpaidlist">
																	<cfinvokeargument name="treenum" value="2">
																	<cfinvokeargument name="branchname" value="Unpaid Refund">
																</cfinvoke>
																			
																<table class="table table-bordered table-striped table-highlight">
																	<thead>
																		<cfoutput>
																		<tr>
																			<th>Unpaid Refund Cancellation <span style="float:right;"><a href="#application.root#?event=page.tree" class="btn btn-mini btn-tertiary">Return to Option Tree</a>&nbsp;&nbsp;<a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=cancel&solution=refund" class="btn btn-mini btn-primary">Choose This Solution</a></span></th>
																		</tr>
																		</cfoutput>
																	</thead>
																	<tbody>
																		<tr>
																			<td>
																				<cfoutput query="unpaidlist">
																					<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																						#urldecode( pointtext )#</li>
																				</cfoutput>
																			</td>
																		</tr>
																	</tbody>
																</table>	
															
															</cfif>
																	
																	
															<cfif optiontree2.subcat2cancelcs is true>
																		
																<cfinvoke component="apis.com.clients.clarifyingpoints" method="getschoollist" returnvariable="schoollist">
																	<cfinvokeargument name="treenum" value="2">
																	<cfinvokeargument name="branchname" value="Closed School">
																</cfinvoke>																			
																			
																<table class="table table-bordered table-striped table-highlight">
																	<thead>
																		<cfoutput>
																		<tr>
																			<th>Closed School Cancellation <span style="float:right;"><a href="#application.root#?event=page.tree" class="btn btn-mini btn-tertiary">Return to Option Tree</a>&nbsp;&nbsp;<a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=cancel&solution=school" class="btn btn-mini btn-primary">Choose This Solution</a></span></th>
																		</tr>
																		</cfoutput>
																	</thead>
																	<tbody>
																		<tr>
																			<td>
																				<cfoutput query="schoollist">
																					<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																						#urldecode( pointtext )#</li>
																				</cfoutput>
																			</td>
																		</tr>
																	</tbody>
																</table>																
															
															</cfif>
																	
																	
															<cfif optiontree2.subcat2cancel911 is true>
																		
																<cfinvoke component="apis.com.clients.clarifyingpoints" method="getnine11list" returnvariable="nine11list">
																	<cfinvokeargument name="treenum" value="2">
																	<cfinvokeargument name="branchname" value="9/11">
																</cfinvoke>
																			
																<table class="table table-bordered table-striped table-highlight">
																	<thead>
																		<cfoutput>
																		<tr>
																			<th>9/11 Cancellation <span style="float:right;"><a href="#application.root#?event=page.tree" class="btn btn-mini btn-tertiary">Return to Option Tree</a>&nbsp;&nbsp;<a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=cancel&solution=911" class="btn btn-mini btn-primary">Choose This Solution</a></span></th>
																		</tr>
																		</cfoutput>
																	</thead>
																	<tbody>
																		<tr>
																			<td>
																				<cfoutput query="nine11list">
																					<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																						#urldecode( pointtext )#</li>
																				</cfoutput>
																			</td>
																		</tr>
																	</tbody>
																</table>														

															</cfif>
															
																	
															<cfif optiontree2.subcat2canceldeath is true>
																	
																<cfinvoke component="apis.com.clients.clarifyingpoints" method="getdeathlist" returnvariable="deathlist">
																	<cfinvokeargument name="treenum" value="2">
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
																	
																	
															<cfif optiontree2.subcat2cancelatb is true>
																		
																<cfinvoke component="apis.com.clients.clarifyingpoints" method="getatblist" returnvariable="atblist">
																	<cfinvokeargument name="treenum" value="2">
																	<cfinvokeargument name="branchname" value="Ability to Benefit">
																</cfinvoke>
																	
																<table class="table table-bordered table-striped table-highlight">
																	<thead>
																		<cfoutput>
																		<tr>
																			<th>Ability to Benefit Cancellation <span style="float:right;"><a href="#application.root#?event=page.tree" class="btn btn-mini btn-tertiary">Return to Option Tree</a>&nbsp;&nbsp;<a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=cancel&solution=atb" class="btn btn-mini btn-primary">Choose This Solution</a></span></th>
																		</tr>
																		</cfoutput>
																	</thead>
																	<tbody>
																		<tr>
																			<td>
																				<cfoutput query="atblist">
																					<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																						#urldecode( pointtext )#</li>
																				</cfoutput>
																			</td>
																		</tr>
																	</tbody>
																</table>	
																
															</cfif>
																	
																	
															<cfif optiontree2.subcat2cancelcert is true>
																		
																<cfinvoke component="apis.com.clients.clarifyingpoints" method="getcertlist" returnvariable="certlist">
																	<cfinvokeargument name="treenum" value="2">
																	<cfinvokeargument name="branchname" value="False Certification">
																</cfinvoke>
																	
																<table class="table table-bordered table-striped table-highlight">
																	<thead>
																		<cfoutput>
																		<tr>
																			<th>False Certification Cancellation <span style="float:right;"><a href="#application.root#?event=page.tree" class="btn btn-mini btn-tertiary">Return to Option Tree</a>&nbsp;&nbsp;<a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=cancel&solution=cert" class="btn btn-mini btn-primary">Choose This Solution</a></span></th>
																		</tr>
																		</cfoutput>
																	</thead>
																	<tbody>
																		<tr>
																			<td>
																				<cfoutput query="certlist">
																					<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																						#urldecode( pointtext )#</li>
																				</cfoutput>
																			</td>
																		</tr>
																	</tbody>
																</table>	
																
															</cfif>
																	
																	
															<cfif optiontree2.subcat2canceldisable is true>
																		
																<cfinvoke component="apis.com.clients.clarifyingpoints" method="getdisablelist" returnvariable="disablelist">
																	<cfinvokeargument name="treenum" value="2">
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
														
														<div class="tab-pane <cfif tabforgive is true and tabcancel is false>active</cfif>" id="tabforgive">														
																
															<cfif optiontree2.subcat2psforgive is true >
																	
																<cfinvoke component="apis.com.clients.clarifyingpoints" method="getpslist" returnvariable="pslist">
																	<cfinvokeargument name="treenum" value="2">
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
																
															<cfif optiontree2.subcat2tlforgive is true >
																	
																<cfinvoke component="apis.com.clients.clarifyingpoints" method="getteachlist" returnvariable="teachlist">
																	<cfinvokeargument name="treenum" value="2">
																	<cfinvokeargument name="branchname" value="Teacher Loan Forgiveness">
																</cfinvoke>
																			
																<table class="table table-bordered table-striped table-highlight">
																	<thead>
																		<cfoutput>
																		<tr>
																			<th>Teacher Loan Forgiveness <span style="float:right;"><a href="#application.root#?event=page.tree" class="btn btn-mini btn-tertiary">Return to Option Tree</a>&nbsp;&nbsp;<a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=forgive&solution=tlf" class="btn btn-mini btn-primary">Choose This Solution</a></span></th>
																		</tr>
																		</cfoutput>
																	</thead>
																	<tbody>
																		<tr>
																			<td>
																				<cfoutput query="teachlist">
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
														
														<div class="tab-pane <cfif tabdefault is true and tabcancel is false and tabforgive is false>active</cfif>" id="tabdefault">													
															
															<cfif optiontree2.subcat2default is true >
																	
																<cfif trim( optiontree2.subcat2rehab ) is "yes" >
																		
																	<cfinvoke component="apis.com.clients.clarifyingpoints" method="getrehablist" returnvariable="rehablist">
																		<cfinvokeargument name="treenum" value="2">
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
																	
																	
																<cfif trim( optiontree2.subcat2consol ) is "yes" >
																		
																	<cfinvoke component="apis.com.clients.clarifyingpoints" method="getconsollist" returnvariable="consollist">
																		<cfinvokeargument name="treenum" value="2">
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


																
																<cfif trim( optiontree2.subcat2wg ) is "yes" >
																		
																	<cfinvoke component="apis.com.clients.clarifyingpoints" method="getwglist" returnvariable="wglist">
																		<cfinvokeargument name="treenum" value="2">
																		<cfinvokeargument name="branchname" value="Wage Garnishment">
																	</cfinvoke>
																	
																	<table class="table table-bordered table-striped table-highlight">
																		<thead>
																			<cfoutput>
																				<tr>
																					<th>Wage Garnishment (Default Intervention) <span style="float:right;"><a href="#application.root#?event=page.tree" class="btn btn-mini btn-tertiary">Return to Option Tree</a>&nbsp;&nbsp;<a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=default&solution=wg" class="btn btn-mini btn-primary">Choose This Solution</a></span></th>
																				</tr>
																			</cfoutput>
																		</thead>
																		<tbody>
																			<tr>
																				<td>
																					<cfoutput query="wglist">
																						<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																					</cfoutput>
																				</td>
																			</tr>
																		</tbody>
																	</table>
																
																</cfif>
																	
																	
																<cfif trim( optiontree2.subcat2to ) is "yes" >
																		
																	<cfinvoke component="apis.com.clients.clarifyingpoints" method="gettolist" returnvariable="tolist">
																		<cfinvokeargument name="treenum" value="2">
																		<cfinvokeargument name="branchname" value="Tax Offset">
																	</cfinvoke>
																	
																	<table class="table table-bordered table-striped table-highlight">
																		<thead>
																			<cfoutput>
																				<tr>
																					<th>Tax Offset (Default Intervention) <span style="float:right;"><a href="#application.root#?event=page.tree" class="btn btn-mini btn-tertiary">Return to Option Tree</a>&nbsp;&nbsp;<a href="#application.root#?event=page.worksheet.solution&tree=#tree#&option=default&solution=to" class="btn btn-mini btn-primary">Choose This Solution</a></span></th>
																				</tr>
																			</cfoutput>
																		</thead>
																		<tbody>
																			<tr>
																				<td>
																					<cfoutput query="tolist">
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
														<div class="tab-pane <cfif tabrepay is true and tabcancel is false and tabforgive is false and tabdefault is false>active</cfif>" id="tabrepay">														
															
															
															<div class="alert alert-info fade in">
																<button type="button" class="close" data-dismiss="alert">&times;</button>
																<h5><i class="icon-comments"></i> STUDENT LOAN DEBT CONSOLIDATION</h5>
																<p style="margin-top:7px;"><strong>To view repayment options and the student loan repayment calculator, please add one of these consolidation solutions to your solution cart and include the student loan in your consolidation.</strong></p>
															</div>
															
															
															
															<!--- // non-consolidated repayment clarifying points --->
															<cfinvoke component="apis.com.clients.clarifyingpoints" method="getrepaynonconsollist" returnvariable="repaynonconsollist">
																<cfinvokeargument name="treenum" value="2">
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
															
															
															<!--- // consolidated repayment clarifying points --->
															<cfinvoke component="apis.com.clients.clarifyingpoints" method="getrepayconsollist" returnvariable="repayconsollist">
																<cfinvokeargument name="treenum" value="2">
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
																		
																		
																		
																															
																	
															
															
														</div><!-- /. repayment-tab -->
														
														
														
														
														<!--- // postponement tab --->
														<div class="tab-pane <cfif tabpost is true and tabcancel is false and tabforgive is false and tabdefault is false and tabrepay is false>active</cfif>" id="tabpost">														
															
															<cfif optiontree2.subcat2post is true >
																	
																<cfif trim( optiontree2.subcat2postdefer ) is "yes" >
																		
																	<cfinvoke component="apis.com.clients.clarifyingpoints" method="getdeferlist" returnvariable="deferlist">
																		<cfinvokeargument name="treenum" value="2">
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
																	
																	
																<cfif trim( optiontree2.subcat2postforbear ) is "yes" >
																		
																	<cfinvoke component="apis.com.clients.clarifyingpoints" method="getforbearlist" returnvariable="forbearlist">
																		<cfinvokeargument name="treenum" value="2">
																		<cfinvokeargument name="branchname" value="Forbearance">
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
																					<cfoutput query="forbearlist">
																						<li style="margin-left:10px;margin-top:5px;"><strong>#title#</strong><br />
																							#urldecode( pointtext )#</li>
																					</cfoutput>
																				</td>
																			</tr>
																		</tbody>
																	</table>	
																
																</cfif>
															
															</cfif>															
																
														</div><!-- /. postponement-tab -->
														
														
														
														
														
														
														<!--- // offer in compromise tab --->
														<div class="tab-pane <cfif taboffer is true and tabcancel is false and tabforgive is false and tabdefault is false and tabrepay is false and tabpost is false>active</cfif>" id="taboffer">													
															
															<cfif optiontree2.subcat2oic is true >
																	
																<cfinvoke component="apis.com.clients.clarifyingpoints" method="getoiclist" returnvariable="oiclist">
																	<cfinvokeargument name="treenum" value="2">
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
														<div class="tab-pane <cfif tabbk is true and tabcancel is false and tabforgive is false and tabdefault is false and tabrepay is false and tabpost is false and taboffer is false>active</cfif>" id="tabbank">									
															
															<cfif optiontree2.subcat2bk is true >
																
																<cfinvoke component="apis.com.clients.clarifyingpoints" method="getbklist" returnvariable="bklist">
																	<cfinvokeargument name="treenum" value="2">
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