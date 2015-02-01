	
			
								
								
								
								
								
												
											   
													
													
													
													<!--- // begin tree 1 // direct loans --->																										
													<cfparam name="subcat1c" default="">
													<cfparam name="subcat1clist" default="">
													
													<cfif optiontree1.subcat1 is true>
														<input type="hidden" name="tree1" value="1" />
														<cfset subcat1c = false />
														
														<!--- // get loans to show for this tree --->
														<cfinvoke component="apis.com.worksheets.worksheetgateway" method="getloansfortree" returnvariable="treeloans">
															<cfinvokeargument name="leadid" value="#session.leadid#">
															<cfinvokeargument name="loancodes" value="D,L,I,AC,AD">
														</cfinvoke>				
														
														
														<h6><small><i class="icon-th-large"></i> DIRECT LOANS</small>   <span class="pull-right"><small><i> Show eligible loans</i> <a href="javascript:;" rel="popover" data-original-title="Direct Loans" data-html="true" data-content="<cfif treeloans.recordcount gt 0><cfoutput query="treeloans"><li><cfif servid eq -1>#nslservicer#<cfelse>#servname#</cfif> - #acctnum# - #dollarformat( loanbalance )#</li></cfoutput><cfelse>All eligible Direct Loans have already been marked completed. </cfif>"><i class="icon-info-sign"></i></a></small></span></h6>									
																
																	
																<!--- // tree1 nested ordered list --->																	
																<ol style="list-style:none;">										
																				
																				<!--- // cancellation sub categories --->
																				<cfif optiontree1.subcat1canceldeath is true >
																					<cfset subcat1c = true />
																					<cfset subcat1clist = listappend( subcat1clist, "Death" ) />																					
																				</cfif>
																				
																				<cfif optiontree1.subcat1cancelunpaid is true>
																					<cfset subcat1c = true />
																					<cfset subcat1clist = listappend( subcat1clist, "Unpaid Refund" ) />																					
																				</cfif>
																				
																				<cfif optiontree1.subcat1cancel911 is true>
																					<cfset subcat1c = true />
																					<cfset subcat1clist = listappend( subcat1clist, "9/11" ) />																					
																				</cfif>
																				
																				<cfif optiontree1.subcat1cancelatb is true>
																					<cfset subcat1c = true />
																					<cfset subcat1clist = listappend( subcat1clist, "Ability to Benefit" ) />																					
																				</cfif>																			
																				
																				<cfif optiontree1.subcat1cancelcs is true>
																					<cfset subcat1c = true />
																					<cfset subcat1clist = listappend( subcat1clist, "Closed School" ) />																					
																				</cfif>
																				
																				<cfif optiontree1.subcat1cancelcert is true>
																					<cfset subcat1c = true />
																					<cfset subcat1clist = listappend( subcat1clist, "False Certification" ) />																					
																				</cfif>
																				
																				<cfif optiontree1.subcat1canceldisable is true>
																					<cfset subcat1c = true />
																					<cfset subcat1clist = listappend( subcat1clist, "Disability" ) />																					
																				</cfif>
																				
																				
																				<cfif subcat1c is true>
																				
																					<!--- tree 1 cancellation sub categories --->
																					<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Cancellation</li>	
																						
																						<ol style="list-style:none;margin-bottom:5px;">
																							<cfloop list="#subcat1clist#" index="j" delimiters=",">
																								<cfoutput>
																									<li style="font-size:10px;"><i class="icon-caret-right"></i> #j#</li>
																								</cfoutput>
																							</cfloop>
																						</ol>
																					
																						<!--- // tree1 cancellation vars --->
																						<cfoutput>	
																							<input type="hidden" name="subcat1c" value="Cancellation" />
																							<input type="hidden" name="subcat1clist" value="#subcat1clist#" />
																						</cfoutput>
																				
																				</cfif>
																	
																		
																	
																		
																			<!--- // option tree1 - forgiveness --->																							
																			
																			<cfparam name="subcat1f" default="">
																			<cfparam name="subcat1flist" default="">																			
																			<cfset subcat1f = false />											
																			
																			<cfif optiontree1.subcat1psforgive is true>
																				<cfset subcat1f = true />
																				<cfset subcat1flist = listappend( subcat1flist, "Public Service Loan" ) />																				
																			</cfif>
																			
																			<cfif optiontree1.subcat1tlforgive is true>
																				<cfset subcat1f = true />																				
																				<cfset subcat1flist = listappend( subcat1flist, "Teacher Loan" ) />																																								
																			</cfif>
																			
																			
																			<cfif subcat1f is true>
																				<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Forgiveness</li>																						
																							
																					<ol style="list-style:none;margin-bottom:5px;">
																						<cfloop list="#subcat1flist#" index="j" delimiters=",">
																							<cfoutput>
																								<li style="font-size:10px;"><i class="icon-caret-right"></i> #j#</li>
																							</cfoutput>
																						</cfloop>
																					</ol>
																			
																			
																				<cfoutput>
																					<!--- tree 1 forgiveness sub categories --->
																					<input type="hidden" name="subcat1f" value="Forgiveness" />
																					<input type="hidden" name="subcat1flist" value="#subcat1flist#" />
																				</cfoutput>
																			</cfif>
																		
																		
																		
																			<!--- // option tree1 - default intervention --->																		
																		
																			<cfparam name="subcat1d" default="">
																			<cfparam name="subcat1dlist" default="">
																			<cfset subcat1d = false />
																			
																			<cfif optiontree1.subcat1default is true>
																				<cfset subcat1d = true />																																						
																			</cfif>
																			
																			<cfif optiontree1.subcat1consol is "yes">
																				<cfset subcat1d = true />																																							
																				<cfset subcat1dlist = listappend( subcat1dlist, "Consolidation" ) />																				
																			</cfif>
																			
																			<cfif optiontree1.subcat1rehab is "yes">
																				<cfset subcat1d = true />																																								
																				<cfset subcat1flist = listappend( subcat1dlist, "Rehabilitation" ) />																				
																			</cfif>
																			
																			<cfif optiontree1.subcat1wg is "yes">
																				<cfset subcat1d = true />																																							
																				<cfset subcat1flist = listappend( subcat1dlist, "Wage Garnishment" ) />																				
																			</cfif>
																			
																			<cfif optiontree1.subcat1to is "yes">
																				<cfset subcat1d = true />																																								
																				<cfset subcat1flist = listappend( subcat1dlist, "Tax Offset" ) />																				
																			</cfif>
																			
																			<cfif subcat1d is true>
																				<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Default Intervention</li>																						
																							
																					<ol style="list-style:none;margin-bottom:5px;">
																						<cfloop list="#subcat1dlist#" index="m" delimiters=",">
																							<cfoutput>
																								<li style="font-size:10px;"><i class="icon-caret-right"></i> #m#</li>
																							</cfoutput>
																						</cfloop>
																					</ol>
																			
																			
																					<cfoutput>
																						<!--- tree 1 default intervention sub categories --->
																						<input type="hidden" name="subcat1d" value="Default Intervention" />
																						<input type="hidden" name="subcat1dlist" value="#subcat1dlist#" />
																					</cfoutput>
																			</cfif>
																			
																			
																				<!--- option trees // repayment plan --->
																				<!--- no conditional statements required 
																				      for all trees --->
																				<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Repayment Plan</li>																						
																							
																					<ol style="list-style:none;margin-bottom:5px;">
																						<li style="font-size:10px;"><i class="icon-caret-right"></i> Consolidation</li>
																						<li style="font-size:10px;"><i class="icon-caret-right"></i> Non-Consolidation</li>
																					</ol>
																			
																			
																					<cfoutput>
																						<!--- tree 1 repayment plan sub categories --->
																						<input type="hidden" name="subcat1r" value="Repayment Plan" />
																						<input type="hidden" name="subcat1rlist" value="Consolidation,Non-Consolidation" />
																					</cfoutput>
																			
																			
																			
																		
																			<!--- // option tree1 - postponement --->	
																		
																			<cfparam name="subcat1p" default="">
																			<cfparam name="subcat1plist" default="">
																			<cfset subcat1p = false />
																			
																			<cfif optiontree1.subcat1postdefer is "yes">
																				<cfset subcat1p = true />
																				<cfset subcat1plist = listappend( subcat1plist, "Deferment" ) />																				
																			</cfif>
																			
																			<cfif optiontree1.subcat1postforbear is "yes">
																				<cfset subcat1p = true />
																				<cfset subcat1plist = listappend( subcat1plist, "Forbearance" ) />																				
																			</cfif>
																			
																			<cfif subcat1p is true>
																				<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Postponement</li>																						
																							
																					<ol style="list-style:none;margin-bottom:5px;">
																						<cfloop list="#subcat1plist#" index="i" delimiters=",">
																							<cfoutput>
																								<li style="font-size:10px;"><i class="icon-caret-right"></i> #i#</li>
																							</cfoutput>
																						</cfloop>
																					</ol>
																			
																					<cfoutput>
																						<!--- tree 1 postponement sub categories --->
																						<input type="hidden" name="subcat1p" value="Postponement" />
																						<input type="hidden" name="subcat1plist" value="#subcat1plist#" />
																					</cfoutput>
																			</cfif>
																			
																		
																		
																			<!--- // option tree1 - offer in compromise --->																		
																			<cfparam name="subcat1o" default="">
																			<cfparam name="subcat1olist" default="">
																			<cfset subcat1o = false />
																			
																			<cfif optiontree1.subcat1oic is true>
																				<cfset subcat1o = true />																		
																				<cfset subcat1olist = listappend( subcat1olist, "Offer in Compromise" ) />
																				<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Offer in Compromise</li>	
																				<cfoutput>
																					<!--- tree 1 postponement sub categories --->
																					<input type="hidden" name="subcat1o" value="Offer in Compromise" />
																					<input type="hidden" name="subcat1olist" value="" />
																				</cfoutput>
																			</cfif>
																			
																		
																		
																			<!--- // option tree1 - bankruptcy --->
																			<cfparam name="subcat1b" default="">
																			<cfparam name="subcat1blist" default="">
																			<cfset subcat1b = false />
																			
																			<cfif optiontree1.subcat1bk is true>
																				<cfset subcat1b = true />
																				<cfset subcat1blist = listappend( subcat1blist, "Bankruptcy" ) />
																				<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Bankruptcy</li>	
																				<cfoutput>
																					<!--- tree 1 bankruptcy sub categories --->
																					<input type="hidden" name="subcat1b" value="Bankruptcy" />
																					<input type="hidden" name="subcat1blist" value="" />
																				</cfoutput>
																			</cfif>											
																		
																</ol><!-- / . close main ordered list for tree 1 -->
															
															
													</cfif>												
													<!--- // close option tree 1 --->
													
													
													
													
													<!--- // begin tree 2 // ffel loans --->
													<cfparam name="subcat2c" default="">
													<cfparam name="subcat2clist" default="">
													
													<cfif optiontree2.subcat2 is true>
														<input type="hidden" name="tree2" value="2" />
														<cfset subcat2c = false />
														
														<!--- // get loans to show for this tree --->
														<cfinvoke component="apis.com.worksheets.worksheetgateway" method="getloansfortree" returnvariable="treeloans">
															<cfinvokeargument name="leadid" value="#session.leadid#">
															<cfinvokeargument name="loancodes" value="A,B,C,G,H,O,P,S,J,AB,AF">
														</cfinvoke>		
														
														
														<h6><small><i class="icon-th-large"></i> FFEL LOANS</small><span class="pull-right"><small><i>Show eligible loans</i> <a href="javascript:;" rel="popover" data-original-title="FFEL Loans" data-html="true" data-content="<cfif treeloans.recordcount gt 0><cfoutput query="treeloans"><li><cfif servid eq -1>#nslservicer#<cfelse>#servname#</cfif> - #acctnum# - #dollarformat( loanbalance )#</li></cfoutput><cfelse>All eligible FFEL Loans have already been marked completed. </cfif>"><i class="icon-info-sign"></i></a></small></span></h6>		
																
																	
																<!--- // option tree2 ordered list --->																	
																<ol style="list-style:none;">										
																				
																				<!--- // cancellation sub categories --->
																				<cfif optiontree2.subcat2canceldeath is true >
																					<cfset subcat2c = true />
																					<cfset subcat2clist = listappend( subcat2clist, "Death" ) />																					
																				</cfif>
																				
																				<cfif optiontree2.subcat2cancelunpaid is true>
																					<cfset subcat2c = true />
																					<cfset subcat2clist = listappend( subcat2clist, "Unpaid Refund" ) />																					
																				</cfif>
																				
																				<cfif optiontree2.subcat2cancel911 is true>
																					<cfset subcat2c = true />
																					<cfset subcat2clist = listappend( subcat2clist, "9/11" ) />																					
																				</cfif>
																				
																				<cfif optiontree2.subcat2cancelatb is true>
																					<cfset subcat2c = true />
																					<cfset subcat2clist = listappend( subcat2clist, "Ability to Benefit" ) />																					
																				</cfif>																			
																				
																				<cfif optiontree2.subcat2cancelcs is true>
																					<cfset subcat2c = true />
																					<cfset subcat2clist = listappend( subcat2clist, "Closed School" ) />																					
																				</cfif>
																				
																				<cfif optiontree2.subcat2cancelcert is true>
																					<cfset subcat2c = true />
																					<cfset subcat2clist = listappend( subcat2clist, "False Certification" ) />																					
																				</cfif>
																				
																				<cfif optiontree2.subcat2canceldisable is true>
																					<cfset subcat2c = true />
																					<cfset subcat2clist = listappend( subcat2clist, "Disability" ) />																					
																				</cfif>
																				
																				
																				<cfif subcat2c is true>
																				
																					<!--- option tree 2 cancellation sub categories --->
																					<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Cancellation</li>	
																						
																						<ol style="list-style:none;margin-bottom:5px;">
																							<cfloop list="#subcat2clist#" index="j" delimiters=",">
																								<cfoutput>
																									<li style="font-size:10px;"><i class="icon-caret-right"></i> #j#</li>
																								</cfoutput>
																							</cfloop>
																						</ol>
																					
																						<!--- // tree1 cancellation vars --->
																						<cfoutput>	
																							<input type="hidden" name="subcat2c" value="Cancellation" />
																							<input type="hidden" name="subcat2clist" value="#subcat2clist#" />
																						</cfoutput>
																				
																				</cfif>
																	
																		
																	
																		
																			<!--- // option tree2 - forgiveness --->																							
																			
																			<cfparam name="subcat2f" default="">
																			<cfparam name="subcat2flist" default="">																			
																			<cfset subcat2f = false />											
																			
																			<cfif optiontree2.subcat2psforgive is true>
																				<cfset subcat2f = true />
																				<cfset subcat2flist = listappend( subcat2flist, "Public Service Loan" ) />																				
																			</cfif>
																			
																			<cfif optiontree2.subcat2tlforgive is true>
																				<cfset subcat2f = true />																				
																				<cfset subcat2flist = listappend( subcat2flist, "Teacher Loan" ) />																																								
																			</cfif>
																			
																			
																			<cfif subcat2f is true>
																				<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Forgiveness</li>																						
																							
																					<ol style="list-style:none;margin-bottom:5px;">
																						<cfloop list="#subcat2flist#" index="j" delimiters=",">
																							<cfoutput>
																								<li style="font-size:10px;"><i class="icon-caret-right"></i> #j#</li>
																							</cfoutput>
																						</cfloop>
																					</ol>
																			
																			
																				<cfoutput>
																					<!--- option tree 2 forgiveness sub categories --->
																					<input type="hidden" name="subcat2f" value="Forgiveness" />
																					<input type="hidden" name="subcat2flist" value="#subcat2flist#" />
																				</cfoutput>
																			</cfif>
																		
																		
																		
																			<!--- // option tree2 - default intervention --->																		
																		
																			<cfparam name="subcat2d" default="">
																			<cfparam name="subcat2dlist" default="">
																			<cfset subcat2d = false />
																			
																			<cfif optiontree2.subcat2default is true>
																				<cfset subcat2d = true />																																						
																			</cfif>
																			
																			<cfif optiontree2.subcat2consol is "yes">
																				<cfset subcat2d = true />																																							
																				<cfset subcat2dlist = listappend( subcat2dlist, "Consolidation" ) />																				
																			</cfif>
																			
																			<cfif optiontree2.subcat2rehab is "yes">
																				<cfset subcat2d = true />																																								
																				<cfset subcat2dlist = listappend( subcat2dlist, "Rehabilitation" ) />																				
																			</cfif>
																			
																			<cfif optiontree2.subcat2wg is "yes">
																				<cfset subcat2d = true />																																							
																				<cfset subcat2dlist = listappend( subcat2dlist, "Wage Garnishment" ) />																				
																			</cfif>
																			
																			<cfif optiontree2.subcat2to is "yes">
																				<cfset subcat2d = true />																																								
																				<cfset subcat2dlist = listappend( subcat2dlist, "Tax Offset" ) />																				
																			</cfif>
																			
																			<cfif subcat2d is true>
																				<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Default Intervention</li>																						
																							
																					<ol style="list-style:none;margin-bottom:5px;">
																						<cfloop list="#subcat2dlist#" index="m" delimiters=",">
																							<cfoutput>
																								<li style="font-size:10px;"><i class="icon-caret-right"></i> #m#</li>
																							</cfoutput>
																						</cfloop>
																					</ol>
																			
																			
																					<cfoutput>
																						<!--- option tree 2 default intervention sub categories --->
																						<input type="hidden" name="subcat2d" value="Default Intervention" />
																						<input type="hidden" name="subcat2dlist" value="#subcat2dlist#" />
																					</cfoutput>
																			</cfif>
																			
																				
																				<!--- option tree 2 - repayment plan --->
																				<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Repayment Plan</li>																						
																							
																					<ol style="list-style:none;margin-bottom:5px;">
																						<li style="font-size:10px;"><i class="icon-caret-right"></i> Consolidation</li>
																						<li style="font-size:10px;"><i class="icon-caret-right"></i> Non-Consolidation</li>
																					</ol>
																			
																			
																					<cfoutput>
																						<!--- option tree 2 repayment plan sub categories --->
																						<input type="hidden" name="subcat2r" value="Repayment Plan" />
																						<input type="hidden" name="subcat2rlist" value="Consolidation,Non-Consolidation" />
																					</cfoutput>
																			
																			
																		
																			<!--- // option tree2 - postponement --->	
																		
																			<cfparam name="subcat2p" default="">
																			<cfparam name="subcat2plist" default="">
																			<cfset subcat2p = false />
																			
																			<cfif optiontree2.subcat2postdefer is "yes">
																				<cfset subcat2p = true />
																				<cfset subcat2plist = listappend( subcat2plist, "Deferment" ) />																				
																			</cfif>
																			
																			<cfif optiontree2.subcat2postforbear is "yes">
																				<cfset subcat2p = true />
																				<cfset subcat2plist = listappend( subcat2plist, "Forbearance" ) />																				
																			</cfif>
																			
																			<cfif subcat2p is true>
																				<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Postponement</li>																						
																							
																					<ol style="list-style:none;margin-bottom:5px;">
																						<cfloop list="#subcat2plist#" index="i" delimiters=",">
																							<cfoutput>
																								<li style="font-size:10px;"><i class="icon-caret-right"></i> #i#</li>
																							</cfoutput>
																						</cfloop>
																					</ol>
																			
																					<cfoutput>
																						<!--- option tree 2 postponement sub categories --->
																						<input type="hidden" name="subcat2p" value="Postponement" />
																						<input type="hidden" name="subcat2plist" value="#subcat2plist#" />
																					</cfoutput>
																			</cfif>																	
																		
																			<!--- // option tree2 // offer in compromise --->																		
																			<cfparam name="subcat2o" default="">
																			<cfparam name="subcat2olist" default="">
																			<cfset subcat2o = false />
																			
																			<cfif optiontree2.subcat2oic is true>
																				<cfset subcat2o = true />																		
																				<cfset subcat2olist = listappend( subcat2olist, "Offer in Compromise" ) />
																				<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Offer in Compromise</li>	
																				<cfoutput>
																					<!--- option tree 2 oic sub categories --->
																					<input type="hidden" name="subcat2o" value="Offer in Compromise" />
																					<input type="hidden" name="subcat2olist" value="" />
																				</cfoutput>
																			</cfif>																	
																		
																			<!--- // option tree 2 - bankruptcy --->
																			<cfparam name="subcat2b" default="">
																			<cfparam name="subcat2blist" default="">
																			<cfset subcat2b = false />
																			
																			<cfif optiontree2.subcat2bk is true>
																				<cfset subcat2b = true />
																				<cfset subcat2blist = listappend( subcat2blist, "Bankruptcy" ) />
																				<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Bankruptcy</li>	
																				<cfoutput>
																					<!--- tree 1 bankruptcy sub categories --->
																					<input type="hidden" name="subcat2b" value="Bankruptcy" />
																					<input type="hidden" name="subcat2blist" value="" />
																				</cfoutput>
																			</cfif>															
																</ol><!-- / . close main ordered list for tree 2 -->
															
													</cfif>												
													<!--- // end option tree 2 --->

													
													
													
													
													<!--- // begin option tree 3 // perkins loans --->
													<cfparam name="subcat3c" default="">
													<cfparam name="subcat3clist" default="">
													
													<cfif optiontree3.subcat3 is true>
														<input type="hidden" name="tree3" value="3" />
														<cfset subcat3c = false />
														
														<!--- // get loans to show for this tree --->
														<cfinvoke component="apis.com.worksheets.worksheetgateway" method="getloansfortree" returnvariable="treeloans">
															<cfinvokeargument name="leadid" value="#session.leadid#">
															<cfinvokeargument name="loancodes" value="A,B,C,G,H,O,P,S,J,AB,AF">
														</cfinvoke>		
														
														
														<h6><small><i class="icon-th-large"></i> PERKINS LOANS</small>    <span class="pull-right"><small><i>Show eligible loans</i> <a href="javascript:;" rel="popover" data-original-title="FFEL Loans" data-html="true" data-content="<cfif treeloans.recordcount gt 0><cfoutput query="treeloans"><li><cfif servid eq -1>#nslservicer#<cfelse>#servname#</cfif> - #acctnum# - #dollarformat( loanbalance )#</li></cfoutput><cfelse>All eligible FFEL Loans have already been marked completed. </cfif>"><i class="icon-info-sign"></i></a></small></span></h6>												
																									
																<!--- // option tree3 nested ordered list --->																	
																<ol style="list-style:none;">										
																				
																				<!--- // cancellation sub categories --->
																				<cfif optiontree3.subcat3canceldeath is true >
																					<cfset subcat3c = true />
																					<cfset subcat3clist = listappend( subcat3clist, "Death" ) />																					
																				</cfif>																			
																				
																				<cfif optiontree3.subcat3cancel911 is true>
																					<cfset subcat3c = true />
																					<cfset subcat3clist = listappend( subcat3clist, "9/11" ) />																					
																				</cfif>																																					
																				
																				<cfif optiontree3.subcat3cancelcs is true>
																					<cfset subcat3c = true />
																					<cfset subcat3clist = listappend( subcat3clist, "Closed School" ) />																					
																				</cfif>																			
																				
																				<cfif optiontree3.subcat3canceldisable is true>
																					<cfset subcat3c = true />
																					<cfset subcat3clist = listappend( subcat3clist, "Disability" ) />																					
																				</cfif>
																				
																				
																				<cfif subcat3c is true>
																				
																					<!--- option tree 3 cancellation sub categories --->
																					<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Cancellation</li>																						
																						<ol style="list-style:none;margin-bottom:5px;">
																							<cfloop list="#subcat3clist#" index="j" delimiters=",">
																								<cfoutput>
																									<li style="font-size:10px;"><i class="icon-caret-right"></i> #j#</li>
																								</cfoutput>
																							</cfloop>
																						</ol>																					
																						<!--- // option tree3 cancellation vars --->
																						<cfoutput>	
																							<input type="hidden" name="subcat3c" value="Cancellation" />
																							<input type="hidden" name="subcat3clist" value="#subcat3clist#" />
																						</cfoutput>																				
																				</cfif>																	
																	
																		
																			<!--- // option tree3 - forgiveness --->																							
																			
																			<cfparam name="subcat3f" default="">
																			<cfparam name="subcat3flist" default="">																			
																			<cfset subcat3f = false />											
																			
																			<cfif optiontree3.subcat3ocforgive is true>
																				<cfset subcat3f = true />
																				<cfset subcat3flist = listappend( subcat3flist, "Occupational" ) />																				
																			</cfif>											
																			
																			<cfif subcat3f is true>
																				<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Forgiveness</li>																						
																					<ol style="list-style:none;">
																						<cfloop list="#subcat3flist#" index="j" delimiters=",">
																							<cfoutput>
																								<li style="font-size:10px;"><i class="icon-caret-right"></i> #j#</li>
																							</cfoutput>
																						</cfloop>
																					</ol>																	
																				<cfoutput>
																					<!--- option tree 3 forgiveness sub categories --->
																					<input type="hidden" name="subcat3f" value="Forgiveness" />
																					<input type="hidden" name="subcat3flist" value="#subcat3flist#" />
																				</cfoutput>
																			</cfif>																	
																		
																			<!--- // option tree3 - default intervention --->																	
																			<cfparam name="subcat3d" default="">
																			<cfparam name="subcat3dlist" default="">
																			<cfset subcat3d = false />										
																			
																			<cfif optiontree3.subcat3consol is "yes">
																				<cfset subcat3d = true />																																							
																				<cfset subcat3dlist = listappend( subcat3dlist, "Consolidation" ) />																				
																			</cfif>
																			
																			<cfif optiontree3.subcat3rehab is "yes">
																				<cfset subcat3d = true />																																								
																				<cfset subcat3dlist = listappend( subcat3dlist, "Rehabilitation" ) />																				
																			</cfif>																		
																			
																			
																			<cfif subcat3d is true>
																				<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Default Intervention</li>																						
																					<ol style="list-style:none;">
																						<cfloop list="#subcat3dlist#" index="m" delimiters=",">
																							<cfoutput>
																								<li style="font-size:10px;"><i class="icon-caret-right"></i> #m#</li>
																							</cfoutput>
																						</cfloop>
																					</ol>																		
																					<cfoutput>
																						<!--- tree 1 default intervention sub categories --->
																						<input type="hidden" name="subcat3d" value="Default Intervention" />
																						<input type="hidden" name="subcat3dlist" value="#subcat3dlist#" />
																					</cfoutput>
																			</cfif>

																			<!--- option tree 3 // repayment plan --->
																				<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Repayment Plan</li>																						
																							
																					<ol style="list-style:none;margin-bottom:5px;">
																						<li style="font-size:10px;"><i class="icon-caret-right"></i> Consolidation</li>
																						<li style="font-size:10px;"><i class="icon-caret-right"></i> Non-Consolidation</li>
																					</ol>
																			
																			
																					<cfoutput>
																						<!--- option tree 3 repayment plan sub categories --->
																						<input type="hidden" name="subcat3r" value="Repayment Plan" />
																						<input type="hidden" name="subcat3rlist" value="Consolidation,Non-Consolidation" />
																					</cfoutput>
																		
																			<!--- // option tree3 - postponement --->	
																		
																			<cfparam name="subcat3p" default="">
																			<cfparam name="subcat3plist" default="">
																			<cfset subcat3p = false />
																			
																			<cfif optiontree3.subcat3postdefer is "yes">
																				<cfset subcat3p = true />
																				<cfset subcat3plist = listappend( subcat3plist, "Deferment" ) />																				
																			</cfif>
																			
																			<cfif optiontree3.subcat3forbear is "yes">
																				<cfset subcat3p = true />
																				<cfset subcat3plist = listappend( subcat3plist, "Forbearance" ) />																				
																			</cfif>
																			
																			<cfif subcat3p is true>
																				<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Postponement</li>																						
																					<ol style="list-style:none;">
																						<cfloop list="#subcat3plist#" index="i" delimiters=",">
																							<cfoutput>
																								<li style="font-size:10px;"><i class="icon-caret-right"></i> #i#</li>
																							</cfoutput>
																						</cfloop>
																					</ol>																			
																					<cfoutput>
																						<!--- option tree 3 postponement sub categories --->
																						<input type="hidden" name="subcat3p" value="Postponement" />
																						<input type="hidden" name="subcat3plist" value="#subcat3plist#" />
																					</cfoutput>
																			</cfif>																	
																		
																			<!--- // option tree3 // offer in compromise --->																		
																			<cfparam name="subcat3o" default="">
																			<cfparam name="subcat3olist" default="">
																			<cfset subcat3o = false />
																			
																			<cfif optiontree3.subcat3oic is true>
																				<cfset subcat3o = true />																		
																				<cfset subcat3olist = listappend( subcat3olist, "Offer in Compromise" ) />
																				<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Offer in Compromise</li>	
																				<cfoutput>
																					<!--- option tree 3 oic sub categories --->
																					<input type="hidden" name="subcat3o" value="Offer in Compromise" />
																					<input type="hidden" name="subcat3olist" value="" />
																				</cfoutput>
																			</cfif>																	
																		
																			<!--- // option tree3 - bankruptcy --->
																			<cfparam name="subcat3b" default="">
																			<cfparam name="subcat3blist" default="">
																			<cfset subcat3b = false />
																			
																			<cfif optiontree3.subcat3bk is true>
																				<cfset subcat3b = true />
																				<cfset subcat3blist = listappend( subcat3blist, "Bankruptcy" ) />
																				<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Bankruptcy</li>	
																				<cfoutput>
																					<!--- option tree 3 bankruptcy sub categories --->
																					<input type="hidden" name="subcat3b" value="Bankruptcy" />
																					<input type="hidden" name="subcat3blist" value="" />
																				</cfoutput>
																			</cfif>							
																		
																</ol><!-- / . close main ordered list for tree 3 -->															
															
													</cfif>						
													<!--- // end option tree 3 --->
													
													
													<!--- // begin option tree 4 // direct consolidation loans --->
													<cfparam name="subcat4c" default="">
													<cfparam name="subcat4clist" default="">
													
													<cfif optiontree4.subcat4 is true>
														<input type="hidden" name="tree4" value="4" />
														<cfset subcat4c = false />
														
														<cfinvoke component="apis.com.worksheets.worksheetgateway" method="getloansfortree" returnvariable="treeloans">
															<cfinvokeargument name="leadid" value="#session.leadid#">
															<cfinvokeargument name="loancodes" value="E,K,V">
														</cfinvoke>
														
														
														<h6><small><i class="icon-th-large"></i> DIRECT CONSOLIDATION LOANS</small>    <span class="pull-right"><small><i>Show eligible loans</i> <a href="javascript:;" rel="popover" data-original-title="FFEL Loans" data-html="true" data-content="<cfif treeloans.recordcount gt 0><cfoutput query="treeloans"><li><cfif servid eq -4>#nslservicer#<cfelse>#servname#</cfif> - #acctnum# - #dollarformat( loanbalance )#</li></cfoutput><cfelse>All eligible FFEL Loans have already been marked completed. </cfif>"><i class="icon-info-sign"></i></a></small></span></h6>												
																												
																	
																<!--- // option tree4 nested ordered list --->																	
																<ol style="list-style:none;">										
																				
																				<!--- // cancellation sub categories --->
																				<cfif optiontree4.subcat4canceldeath is true >
																					<cfset subcat4c = true />
																					<cfset subcat4clist = listappend( subcat4clist, "Death" ) />																					
																				</cfif>
																				
																				<cfif optiontree4.subcat4cancelunpaid is true>
																					<cfset subcat4c = true />
																					<cfset subcat4clist = listappend( subcat4clist, "Unpaid Refund" ) />																					
																				</cfif>
																				
																				<cfif optiontree4.subcat4cancel911 is true>
																					<cfset subcat4c = true />
																					<cfset subcat4clist = listappend( subcat4clist, "9/11" ) />																					
																				</cfif>
																				
																				<cfif optiontree4.subcat4cancelatb is true>
																					<cfset subcat4c = true />
																					<cfset subcat4clist = listappend( subcat4clist, "Ability to Benefit" ) />																					
																				</cfif>																			
																				
																				<cfif optiontree4.subcat4cancelcs is true>
																					<cfset subcat4c = true />
																					<cfset subcat4clist = listappend( subcat4clist, "Closed School" ) />																					
																				</cfif>
																				
																				<cfif optiontree4.subcat4cancelcert is true>
																					<cfset subcat4c = true />
																					<cfset subcat4clist = listappend( subcat4clist, "False Certification" ) />																					
																				</cfif>
																				
																				<cfif optiontree4.subcat4canceldisable is true>
																					<cfset subcat4c = true />
																					<cfset subcat4clist = listappend( subcat4clist, "Disability" ) />																					
																				</cfif>
																				
																				
																				<cfif subcat4c is true>																				
																					<!--- option tree 4 cancellation sub categories --->
																					<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Cancellation</li>																					
																						<ol style="list-style:none;margin-bottom:5px;">
																							<cfloop list="#subcat4clist#" index="j" delimiters=",">
																								<cfoutput>
																									<li style="font-size:10px;"><i class="icon-caret-right"></i> #j#</li>
																								</cfoutput>
																							</cfloop>
																						</ol>																					
																						<!--- // tree4 cancellation vars --->
																						<cfoutput>	
																							<input type="hidden" name="subcat4c" value="Cancellation" />
																							<input type="hidden" name="subcat4clist" value="#subcat4clist#" />
																						</cfoutput>																				
																				</cfif>
																	
																		
																	
																		
																				<!--- // option tree4 - forgiveness --->																				
																				<cfparam name="subcat4f" default="">
																				<cfparam name="subcat4flist" default="">																			
																				<cfset subcat4f = false />											
																				
																				<cfif optiontree4.subcat4psforgive is true>
																					<cfset subcat4f = true />
																					<cfset subcat4flist = listappend( subcat4flist, "Public Service Loan" ) />																				
																				</cfif>
																				
																				<cfif optiontree4.subcat4tlforgive is true>
																					<cfset subcat4f = true />																				
																					<cfset subcat4flist = listappend( subcat4flist, "Teacher Loan" ) />																																								
																				</cfif>
																				
																				
																				<cfif subcat4f is true>
																					<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Forgiveness</li>																						
																						<ol style="list-style:none;margin-bottom:5px;">
																							<cfloop list="#subcat4flist#" index="j" delimiters=",">
																								<cfoutput>
																									<li style="font-size:10px;"><i class="icon-caret-right"></i> #j#</li>
																								</cfoutput>
																							</cfloop>
																						</ol>																	
																						<cfoutput>
																							<!--- tree 4 forgiveness sub categories --->
																							<input type="hidden" name="subcat4f" value="Forgiveness" />
																							<input type="hidden" name="subcat4flist" value="#subcat4flist#" />
																						</cfoutput>
																				</cfif>
																			
																			
																			
																				<!--- // option tree4 - default intervention --->																		
																				<cfparam name="subcat4d" default="">
																				<cfparam name="subcat4dlist" default="">
																				<cfset subcat4d = false />
																				
																				<cfif optiontree4.subcat4default is true>
																					<cfset subcat4d = true />																																						
																				</cfif>
																				
																				<cfif optiontree4.subcat4consol is "yes">
																					<cfset subcat4d = true />																																							
																					<cfset subcat4dlist = listappend( subcat4dlist, "Consolidation" ) />																				
																				</cfif>
																				
																				<cfif optiontree4.subcat4rehab is "yes">
																					<cfset subcat4d = true />																																								
																					<cfset subcat4flist = listappend( subcat4dlist, "Rehabilitation" ) />																				
																				</cfif>
																				
																				<cfif optiontree4.subcat4wg is "yes">
																					<cfset subcat4d = true />																																							
																					<cfset subcat4flist = listappend( subcat4dlist, "Wage Garnishment" ) />																				
																				</cfif>
																				
																				<cfif optiontree4.subcat4to is "yes">
																					<cfset subcat4d = true />																																								
																					<cfset subcat4flist = listappend( subcat4dlist, "Tax Offset" ) />																				
																				</cfif>
																				
																				<cfif subcat4d is true>
																					<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Default Intervention</li>																
																						<ol style="list-style:none;margin-bottom:5px;">
																							<cfloop list="#subcat4dlist#" index="m" delimiters=",">
																								<cfoutput>
																									<li style="font-size:10px;"><i class="icon-caret-right"></i> #m#</li>
																								</cfoutput>
																							</cfloop>
																						</ol>																	
																						<cfoutput>
																							<!--- tree 4 default intervention sub categories --->
																							<input type="hidden" name="subcat4d" value="Default Intervention" />
																							<input type="hidden" name="subcat4dlist" value="#subcat4dlist#" />
																						</cfoutput>
																				</cfif>
																				
																				<!--- option tree 4 - repayment plan --->
																				<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Repayment Plan</li>																						
																							
																					<ol style="list-style:none;margin-bottom:5px;">
																						<li style="font-size:10px;"><i class="icon-caret-right"></i> Consolidation</li>
																						<li style="font-size:10px;"><i class="icon-caret-right"></i> Non-Consolidation</li>
																					</ol>
																			
																			
																					<cfoutput>
																						<!--- tree 4 repayment plan sub categories --->
																						<input type="hidden" name="subcat4r" value="Repayment Plan" />
																						<input type="hidden" name="subcat4rlist" value="Consolidation,Non-Consolidation" />
																					</cfoutput>
																				
																				
																			
																				<!--- // option tree4 - postponement --->																			
																				<cfparam name="subcat4p" default="">
																				<cfparam name="subcat4plist" default="">
																				<cfset subcat4p = false />
																				
																				<cfif optiontree4.subcat4postdefer is "yes">
																					<cfset subcat4p = true />
																					<cfset subcat4plist = listappend( subcat4plist, "Deferment" ) />																				
																				</cfif>
																				
																				<cfif optiontree4.subcat4postforbear is "yes">
																					<cfset subcat4p = true />
																					<cfset subcat4plist = listappend( subcat4plist, "Forbearance" ) />																				
																				</cfif>
																				
																				<cfif subcat4p is true>
																					<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Postponement</li>																					
																						<ol style="list-style:none;margin-bottom:5px;">
																							<cfloop list="#subcat4plist#" index="i" delimiters=",">
																								<cfoutput>
																									<li style="font-size:10px;"><i class="icon-caret-right"></i> #i#</li>
																								</cfoutput>
																							</cfloop>
																						</ol>																				
																						<cfoutput>
																							<!--- tree 4 postponement sub categories --->
																							<input type="hidden" name="subcat4p" value="Postponement" />
																							<input type="hidden" name="subcat4plist" value="#subcat4plist#" />
																						</cfoutput>
																				</cfif>
																				
																			
																			
																				<!--- // option tree4 - offer in compromise --->																		
																				<cfparam name="subcat4o" default="">
																				<cfparam name="subcat4olist" default="">
																				<cfset subcat4o = false />
																				
																				<cfif optiontree4.subcat4oic is true>
																					<cfset subcat4o = true />																		
																					<cfset subcat4olist = listappend( subcat4olist, "Offer in Compromise" ) />
																					<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Offer in Compromise</li>	
																					<cfoutput>
																						<!--- tree 4 oic sub categories --->
																						<input type="hidden" name="subcat4o" value="Offer in Compromise" />
																						<input type="hidden" name="subcat4olist" value="" />
																					</cfoutput>
																				</cfif>
																				
																			
																			
																				<!--- // option tree4 - bankruptcy --->
																				<cfparam name="subcat4b" default="">
																				<cfparam name="subcat4blist" default="">
																				<cfset subcat4b = false />
																				
																				<cfif optiontree4.subcat4bk is true>
																					<cfset subcat4b = true />
																					<cfset subcat4blist = listappend( subcat4blist, "Bankruptcy" ) />
																					<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Bankruptcy</li>	
																					<cfoutput>
																						<!--- tree 4 bankruptcy sub categories --->
																						<input type="hidden" name="subcat4b" value="Bankruptcy" />
																						<input type="hidden" name="subcat4blist" value="" />
																					</cfoutput>
																				</cfif>						
																			
																				
																				
																				
																				
																				
																			
																			
																			
																	</ol><!-- / . close main ordered list for tree 4 -->
														          
														
													</cfif>
													<!--- // end option tree 4 --->
														
														
													<!--- // begin option tree 5 // health pro loans --->
													<cfparam name="subcat5c" default="">
													<cfparam name="subcat5clist" default="">
													
													<cfif optiontree5.subcat5 is true>
														<input type="hidden" name="tree5" value="5" />
														<cfset subcat5c = false />					
														
														<cfinvoke component="apis.com.worksheets.worksheetgateway" method="getloansfortree" returnvariable="treeloans">
															<cfinvokeargument name="leadid" value="#session.leadid#">
															<cfinvokeargument name="loancodes" value="Q,R,Y,Z">
														</cfinvoke>
														
														<h6><small><i class="icon-th-large"></i> HEALTH PROFESSIONAL LOANS</small>    <span class="pull-right"><small><i>Show eligible loans</i> <a href="javascript:;" rel="popover" data-original-title="FFEL Loans" data-html="true" data-content="<cfif treeloans.recordcount gt 0><cfoutput query="treeloans"><li><cfif servid eq -5>#nslservicer#<cfelse>#servname#</cfif> - #acctnum# - #dollarformat( loanbalance )#</li></cfoutput><cfelse>All eligible FFEL Loans have already been marked completed. </cfif>"><i class="icon-info-sign"></i></a></small></span></h6>												
														
															
																
																	
																<!--- // option tree5 nested ordered list --->																	
																<ol style="list-style:none;">										
																				
																				<!--- // cancellation sub categories --->
																				<cfif optiontree5.subcat5canceldeath is true >
																					<cfset subcat5c = true />
																					<cfset subcat5clist = listappend( subcat5clist, "Death" ) />																					
																				</cfif>															
																				
																				<cfif optiontree5.subcat5canceldisable is true>
																					<cfset subcat5c = true />
																					<cfset subcat5clist = listappend( subcat5clist, "Disability" ) />																					
																				</cfif>																				
																				
																				<cfif subcat5c is true>																				
																					<!--- option tree 5 cancellation sub categories --->
																					<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Cancellation</li>																					
																						<ol style="list-style:none;margin-bottom:5px;">
																							<cfloop list="#subcat5clist#" index="j" delimiters=",">
																								<cfoutput>
																									<li style="font-size:10px;"><i class="icon-caret-right"></i> #j#</li>
																								</cfoutput>
																							</cfloop>
																						</ol>																					
																						<!--- // tree5 cancellation vars --->
																						<cfoutput>	
																							<input type="hidden" name="subcat5c" value="Cancellation" />
																							<input type="hidden" name="subcat5clist" value="#subcat5clist#" />
																						</cfoutput>																				
																				</cfif>
																	
																		
																	
																		
																				<!--- // option tree5 - forgiveness --->																				
																				<cfparam name="subcat5f" default="">
																				<cfparam name="subcat5flist" default="">																			
																				<cfset subcat5f = false />											
																				
																				<cfif optiontree5.subcat5psforgive is true>
																					<cfset subcat5f = true />
																					<cfset subcat5flist = listappend( subcat5flist, "Public Service Loan" ) />																				
																				</cfif>								
																				
																				<cfif subcat5f is true>
																					<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Forgiveness</li>																						
																						<ol style="list-style:none;margin-bottom:5px;">
																							<cfloop list="#subcat5flist#" index="j" delimiters=",">
																								<cfoutput>
																									<li style="font-size:10px;"><i class="icon-caret-right"></i> #j#</li>
																								</cfoutput>
																							</cfloop>
																						</ol>																	
																						<cfoutput>
																							<!--- tree 5 forgiveness sub categories --->
																							<input type="hidden" name="subcat5f" value="Forgiveness" />
																							<input type="hidden" name="subcat5flist" value="#subcat5flist#" />
																						</cfoutput>
																				</cfif>
																			
																			
																			
																				<!--- // option tree5 - default intervention --->																		
																				<cfparam name="subcat5d" default="">
																				<cfparam name="subcat5dlist" default="">
																				<cfset subcat5d = false />
																				
																				<cfif optiontree5.subcat5default is true>
																					<cfset subcat5d = true />																																						
																				</cfif>
																				
																				<cfif optiontree5.subcat5consol is "yes">
																					<cfset subcat5d = true />																																							
																					<cfset subcat5dlist = listappend( subcat5dlist, "Consolidation" ) />																				
																				</cfif>
																				
																				<cfif optiontree5.subcat5rehab is "yes">
																					<cfset subcat5d = true />																																								
																					<cfset subcat5flist = listappend( subcat5dlist, "Rehabilitation" ) />																				
																				</cfif>															
																				
																				<cfif subcat5d is true>
																					<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Default Intervention</li>																
																						<ol style="list-style:none;margin-bottom:5px;">
																							<cfloop list="#subcat5dlist#" index="m" delimiters=",">
																								<cfoutput>
																									<li style="font-size:10px;"><i class="icon-caret-right"></i> #m#</li>
																								</cfoutput>
																							</cfloop>
																						</ol>																	
																						<cfoutput>
																							<!--- tree 5 default intervention sub categories --->
																							<input type="hidden" name="subcat5d" value="Default Intervention" />
																							<input type="hidden" name="subcat5dlist" value="#subcat5dlist#" />
																						</cfoutput>
																				</cfif>
																				
																				<!--- option tree 5 - repayment plan --->
																				<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Repayment Plan</li>																						
																							
																					<ol style="list-style:none;margin-bottom:5px;">
																						<li style="font-size:10px;"><i class="icon-caret-right"></i> Consolidation</li>
																						<li style="font-size:10px;"><i class="icon-caret-right"></i> Non-Consolidation</li>
																					</ol>
																			
																			
																					<cfoutput>
																						<!--- tree 5 repayment plan sub categories --->
																						<input type="hidden" name="subcat5r" value="Repayment Plan" />
																						<input type="hidden" name="subcat5rlist" value="Consolidation,Non-Consolidation" />
																					</cfoutput>
																				
																				
																			
																				<!--- // option tree5 - postponement --->																			
																				<cfparam name="subcat5p" default="">
																				<cfparam name="subcat5plist" default="">
																				<cfset subcat5p = false />
																				
																				<cfif optiontree5.subcat5postdefer is "yes">
																					<cfset subcat5p = true />
																					<cfset subcat5plist = listappend( subcat5plist, "Deferment" ) />																				
																				</cfif>
																				
																				<cfif optiontree5.subcat5forbear is "yes">
																					<cfset subcat5p = true />
																					<cfset subcat5plist = listappend( subcat5plist, "Forbearance" ) />																				
																				</cfif>
																				
																				<cfif subcat5p is true>
																					<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Postponement</li>																					
																						<ol style="list-style:none;margin-bottom:5px;">
																							<cfloop list="#subcat5plist#" index="i" delimiters=",">
																								<cfoutput>
																									<li style="font-size:10px;"><i class="icon-caret-right"></i> #i#</li>
																								</cfoutput>
																							</cfloop>
																						</ol>																				
																						<cfoutput>
																							<!--- tree 5 postponement sub categories --->
																							<input type="hidden" name="subcat5p" value="Postponement" />
																							<input type="hidden" name="subcat5plist" value="#subcat5plist#" />
																						</cfoutput>
																				</cfif>
																				
																			
																			
																				<!--- // option tree5 - offer in compromise --->																		
																				<cfparam name="subcat5o" default="">
																				<cfparam name="subcat5olist" default="">
																				<cfset subcat5o = false />
																				
																				<cfif optiontree5.subcat5oic is true>
																					<cfset subcat5o = true />																		
																					<cfset subcat5olist = listappend( subcat5olist, "Offer in Compromise" ) />
																					<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Offer in Compromise</li>	
																					<cfoutput>
																						<!--- tree 5 oic sub categories --->
																						<input type="hidden" name="subcat5o" value="Offer in Compromise" />
																						<input type="hidden" name="subcat5olist" value="" />
																					</cfoutput>
																				</cfif>
																				
																			
																			
																				<!--- // option tree5 - bankruptcy --->
																				<cfparam name="subcat5b" default="">
																				<cfparam name="subcat5blist" default="">
																				<cfset subcat5b = false />
																				
																				<cfif optiontree5.subcat5bk is true>
																					<cfset subcat5b = true />
																					<cfset subcat5blist = listappend( subcat5blist, "Bankruptcy" ) />
																					<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Bankruptcy</li>	
																					<cfoutput>
																						<!--- tree 5 bankruptcy sub categories --->
																						<input type="hidden" name="subcat5b" value="Bankruptcy" />
																						<input type="hidden" name="subcat5blist" value="" />
																					</cfoutput>
																				</cfif>						
																			
																				
																				
																				
																				
																				
																			
																			
																			
																	</ol><!-- / . close main ordered list for tree 5 -->
													</cfif>
													<!-- // end tree 5 --->				       
														
														
													<!--- // begin option tree 6 // parent plus loans --->
													<cfparam name="subcat6c" default="">
													<cfparam name="subcat6clist" default="">
													
													<cfif optiontree6.subcat6 is true>
														<input type="hidden" name="tree6" value="6" />
														<cfset subcat6c = false />					
														
														<cfinvoke component="apis.com.worksheets.worksheetgateway" method="getloansfortree" returnvariable="treeloans">
															<cfinvokeargument name="leadid" value="#session.leadid#">
															<cfinvokeargument name="loancodes" value="T,U,X">
														</cfinvoke>
														
														<h6><small><i class="icon-th-large"></i> PARENT PLUS LOANS</small>    <span class="pull-right"><small><i>Show eligible loans</i> <a href="javascript:;" rel="popover" data-original-title="FFEL Loans" data-html="true" data-content="<cfif treeloans.recordcount gt 0><cfoutput query="treeloans"><li><cfif servid eq -6>#nslservicer#<cfelse>#servname#</cfif> - #acctnum# - #dollarformat( loanbalance )#</li></cfoutput><cfelse>All eligible FFEL Loans have already been marked completed. </cfif>"><i class="icon-info-sign"></i></a></small></span></h6>												
														
															
																
																	
																<!--- // option tree6 nested ordered list --->																	
																<ol style="list-style:none;">										
																				
																				<!--- // cancellation sub categories --->
																				<cfif optiontree6.subcat6canceldeath is true >
																					<cfset subcat6c = true />
																					<cfset subcat6clist = listappend( subcat6clist, "Death" ) />																					
																				</cfif>
																				
																				<cfif optiontree6.subcat6cancelunpaid is true>
																					<cfset subcat6c = true />
																					<cfset subcat6clist = listappend( subcat6clist, "Unpaid Refund" ) />																					
																				</cfif>
																				
																				<cfif optiontree6.subcat6cancel911 is true>
																					<cfset subcat6c = true />
																					<cfset subcat6clist = listappend( subcat6clist, "9/11" ) />																					
																				</cfif>
																				
																				<cfif optiontree6.subcat6cancelatb is true>
																					<cfset subcat6c = true />
																					<cfset subcat6clist = listappend( subcat6clist, "Ability to Benefit" ) />																					
																				</cfif>																			
																				
																				<cfif optiontree6.subcat6cancelcs is true>
																					<cfset subcat6c = true />
																					<cfset subcat6clist = listappend( subcat6clist, "Closed School" ) />																					
																				</cfif>
																				
																				<cfif optiontree6.subcat6cancelcert is true>
																					<cfset subcat6c = true />
																					<cfset subcat6clist = listappend( subcat6clist, "False Certification" ) />																					
																				</cfif>
																				
																				<cfif optiontree6.subcat6canceldisable is true>
																					<cfset subcat6c = true />
																					<cfset subcat6clist = listappend( subcat6clist, "Disability" ) />																					
																				</cfif>
																				
																				
																				<cfif subcat6c is true>																				
																					<!--- option tree 6 cancellation sub categories --->
																					<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Cancellation</li>																					
																						<ol style="list-style:none;margin-bottom:5px;">
																							<cfloop list="#subcat6clist#" index="j" delimiters=",">
																								<cfoutput>
																									<li style="font-size:10px;"><i class="icon-caret-right"></i> #j#</li>
																								</cfoutput>
																							</cfloop>
																						</ol>																					
																						<!--- // tree6 cancellation vars --->
																						<cfoutput>	
																							<input type="hidden" name="subcat6c" value="Cancellation" />
																							<input type="hidden" name="subcat6clist" value="#subcat6clist#" />
																						</cfoutput>																				
																				</cfif>
																	
																		
																	
																		
																				<!--- // option tree6 - forgiveness --->																				
																				<cfparam name="subcat6f" default="">
																				<cfparam name="subcat6flist" default="">																			
																				<cfset subcat6f = false />											
																				
																				<cfif optiontree6.subcat6psforgive is true>
																					<cfset subcat6f = true />
																					<cfset subcat6flist = listappend( subcat6flist, "Public Service Loan" ) />																				
																				</cfif>
																				
																				<cfif optiontree6.subcat6tlforgive is true>
																					<cfset subcat6f = true />																				
																					<cfset subcat6flist = listappend( subcat6flist, "Teacher Loan" ) />																																								
																				</cfif>
																				
																				
																				<cfif subcat6f is true>
																					<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Forgiveness</li>																						
																						<ol style="list-style:none;margin-bottom:5px;">
																							<cfloop list="#subcat6flist#" index="j" delimiters=",">
																								<cfoutput>
																									<li style="font-size:10px;"><i class="icon-caret-right"></i> #j#</li>
																								</cfoutput>
																							</cfloop>
																						</ol>																	
																						<cfoutput>
																							<!--- tree 6 forgiveness sub categories --->
																							<input type="hidden" name="subcat6f" value="Forgiveness" />
																							<input type="hidden" name="subcat6flist" value="#subcat6flist#" />
																						</cfoutput>
																				</cfif>
																			
																			
																			
																				<!--- // option tree6 - default intervention --->																		
																				<cfparam name="subcat6d" default="">
																				<cfparam name="subcat6dlist" default="">
																				<cfset subcat6d = false />
																				
																				<cfif optiontree6.subcat6default is true>
																					<cfset subcat6d = true />																																						
																				</cfif>
																				
																				<cfif optiontree6.subcat6consol is "yes">
																					<cfset subcat6d = true />																																							
																					<cfset subcat6dlist = listappend( subcat6dlist, "Consolidation" ) />																				
																				</cfif>
																				
																				<cfif optiontree6.subcat6rehab is "yes">
																					<cfset subcat6d = true />																																								
																					<cfset subcat6flist = listappend( subcat6dlist, "Rehabilitation" ) />																				
																				</cfif>
																				
																				<cfif optiontree6.subcat6wg is "yes">
																					<cfset subcat6d = true />																																							
																					<cfset subcat6flist = listappend( subcat6dlist, "Wage Garnishment" ) />																				
																				</cfif>
																				
																				<cfif optiontree6.subcat6to is "yes">
																					<cfset subcat6d = true />																																								
																					<cfset subcat6flist = listappend( subcat6dlist, "Tax Offset" ) />																				
																				</cfif>
																				
																				<cfif subcat6d is true>
																					<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Default Intervention</li>																
																						<ol style="list-style:none;margin-bottom:5px;">
																							<cfloop list="#subcat6dlist#" index="m" delimiters=",">
																								<cfoutput>
																									<li style="font-size:10px;"><i class="icon-caret-right"></i> #m#</li>
																								</cfoutput>
																							</cfloop>
																						</ol>																	
																						<cfoutput>
																							<!--- tree 6 default intervention sub categories --->
																							<input type="hidden" name="subcat6d" value="Default Intervention" />
																							<input type="hidden" name="subcat6dlist" value="#subcat6dlist#" />
																						</cfoutput>
																				</cfif>
																				
																				<!--- option tree 6 - repayment plan --->
																				<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Repayment Plan</li>																						
																							
																					<ol style="list-style:none;margin-bottom:5px;">
																						<li style="font-size:10px;"><i class="icon-caret-right"></i> Consolidation</li>
																						<li style="font-size:10px;"><i class="icon-caret-right"></i> Non-Consolidation</li>
																					</ol>
																			
																			
																					<cfoutput>
																						<!--- tree 1 repayment plan sub categories --->
																						<input type="hidden" name="subcat6r" value="Repayment Plan" />
																						<input type="hidden" name="subcat6rlist" value="Consolidation,Non-Consolidation" />
																					</cfoutput>
																				
																				
																			
																				<!--- // option tree6 - postponement --->																			
																				<cfparam name="subcat6p" default="">
																				<cfparam name="subcat6plist" default="">
																				<cfset subcat6p = false />
																				
																				<cfif optiontree6.subcat6postdefer is "yes">
																					<cfset subcat6p = true />
																					<cfset subcat6plist = listappend( subcat6plist, "Deferment" ) />																				
																				</cfif>
																				
																				<cfif optiontree6.subcat6postforbear is "yes">
																					<cfset subcat6p = true />
																					<cfset subcat6plist = listappend( subcat6plist, "Forbearance" ) />																				
																				</cfif>
																				
																				<cfif subcat6p is true>
																					<li style="margin-bottom:3px;font-size:12px;"><i class="icon-check"></i> Postponement</li>																					
																						<ol style="list-style:none;margin-bottom:5px;">
																							<cfloop list="#subcat6plist#" index="i" delimiters=",">
																								<cfoutput>
																									<li style="font-size:10px;"><i class="icon-caret-right"></i> #i#</li>
																								</cfoutput>
																							</cfloop>
																						</ol>																				
																						<cfoutput>
																							<!--- tree 6 postponement sub categories --->
																							<input type="hidden" name="subcat6p" value="Postponement" />
																							<input type="hidden" name="subcat6plist" value="#subcat6plist#" />
																						</cfoutput>
																				</cfif>
																				
																			
																			
																				<!--- // option tree6 - offer in compromise --->																		
																				<cfparam name="subcat6o" default="">
																				<cfparam name="subcat6olist" default="">
																				<cfset subcat6o = false />
																				
																				<cfif optiontree6.subcat6oic is true>
																					<cfset subcat6o = true />																		
																					<cfset subcat6olist = listappend( subcat6olist, "Offer in Compromise" ) />
																					<li style="margin-bottom:3px;font-size:10px;"><i class="icon-check"></i> Offer in Compromise</li>	
																					<cfoutput>
																						<!--- tree 6 postponement sub categories --->
																						<input type="hidden" name="subcat6o" value="Offer in Compromise" />
																						<input type="hidden" name="subcat6olist" value="" />
																					</cfoutput>
																				</cfif>
																				
																			
																			
																				<!--- // option tree6 - bankruptcy --->
																				<cfparam name="subcat6b" default="">
																				<cfparam name="subcat6blist" default="">
																				<cfset subcat6b = false />
																				
																				<cfif optiontree6.subcat6bk is true>
																					<cfset subcat6b = true />
																					<cfset subcat6blist = listappend( subcat6blist, "Bankruptcy" ) />
																					<li style="margin-bottom:3px;font-size:10px;"><i class="icon-check"></i> Bankruptcy</li>	
																					<cfoutput>
																						<!--- tree 6 bankruptcy sub categories --->
																						<input type="hidden" name="subcat6b" value="Bankruptcy" />
																						<input type="hidden" name="subcat6blist" value="" />
																					</cfoutput>
																				</cfif>						
																			
																				
																				
																				
																				
																				
																			
																			
																			
																	</ol><!-- / . close main ordered list for tree 6 -->
													</cfif>						
													<!--- // end parent plus // tree 6 --->
													
												

									
							