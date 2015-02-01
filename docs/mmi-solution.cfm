													
													
													
													
													
													
													
													
													
													
													
													<!--- // begin option tree 5 // health pro loans --->
													<cfparam name="subcat5c" default="">
													<cfparam name="subcat5clist" default="">
													
													<cfif optiontree5.subcat5 is true>
														
														<cfset subcat5c = false />					
														
														<cfinvoke component="apis.com.worksheets.worksheetgateway" method="getloansfortree" returnvariable="treeloans">
															<cfinvokeargument name="leadid" value="#session.leadid#">
															<cfinvokeargument name="loancodes" value="Q,R,Y,Z">
														</cfinvoke>
														
														<h6><small><i class="icon-th-large"></i> HEALTH PRO LOANS</small>    <span class="pull-right"><small><i>Show eligible loans</i> <a href="javascript:;" rel="popover" data-original-title="FFEL Loans" data-html="true" data-content="<cfif treeloans.recordcount gt 0><cfoutput query="treeloans"><li><cfif servid eq -5>#nslservicer#<cfelse>#servname#</cfif> - #acctnum# - #dollarformat( loanbalance )#</li></cfoutput><cfelse>All eligible FFEL Loans have already been marked completed. </cfif>"><i class="icon-info-sign"></i></a></small></span></h6>												
														
															
																
																	
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
																					<li style="margin-bottom:3px;"><i class="icon-check"></i> Cancellation</li>																					
																						<ol style="list-style:none;margin-bottom:5px;">
																							<cfloop list="#subcat5clist#" index="j" delimiters=",">
																								<cfoutput>
																									<li><i class="icon-caret-right"></i> #j#</li>
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
																					<li style="margin-bottom:3px;"><i class="icon-check"></i> Forgiveness</li>																						
																						<ol style="list-style:none;margin-bottom:5px;">
																							<cfloop list="#subcat5flist#" index="j" delimiters=",">
																								<cfoutput>
																									<li><i class="icon-caret-right"></i> #j#</li>
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
																					<cfset subcat5flist = listappend( subcat5flist, "Rehabilitation" ) />																				
																				</cfif>															
																				
																				<cfif subcat5d is true>
																					<li style="margin-bottom:3px;"><i class="icon-check"></i> Default Intervention</li>																
																						<ol style="list-style:none;margin-bottom:5px;">
																							<cfloop list="#subcat5dlist#" index="m" delimiters=",">
																								<cfoutput>
																									<li><i class="icon-caret-right"></i> #m#</li>
																								</cfoutput>
																							</cfloop>
																						</ol>																	
																						<cfoutput>
																							<!--- tree 5 forgiveness sub categories --->
																							<input type="hidden" name="subcat5d" value="Default Intervention" />
																							<input type="hidden" name="subcat5flist" value="#subcat5dlist#" />
																						</cfoutput>
																				</cfif>
																				
																				
																				
																				
																			
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
																					<li style="margin-bottom:3px;"><i class="icon-check"></i> Postponement</li>																					
																						<ol style="list-style:none;margin-bottom:5px;">
																							<cfloop list="#subcat5plist#" index="i" delimiters=",">
																								<cfoutput>
																									<li><i class="icon-caret-right"></i> #i#</li>
																								</cfoutput>
																							</cfloop>
																						</ol>																				
																						<cfoutput>
																							<!--- tree 5 postponement sub categories --->
																							<input type="hidden" name="subcat5d" value="Postponement" />
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
																					<li style="margin-bottom:3px;"><i class="icon-check"></i> Offer in Compromise</li>	
																					<cfoutput>
																						<!--- tree 5 postponement sub categories --->
																						<input type="hidden" name="subcat5o" value="Offer in Compromise" />
																						<input type="hidden" name="subcat5plist" value="" />
																					</cfoutput>
																				</cfif>
																				
																			
																			
																				<!--- // option tree5 - bankruptcy --->
																				<cfparam name="subcat5b" default="">
																				<cfparam name="subcat5blist" default="">
																				<cfset subcat5b = false />
																				
																				<cfif optiontree5.subcat5bk is true>
																					<cfset subcat5b = true />
																					<cfset subcat5blist = listappend( subcat5blist, "Bankruptcy" ) />
																					<li style="margin-bottom:3px;"><i class="icon-check"></i> Bankruptcy</li>	
																					<cfoutput>
																						<!--- tree 5 bankruptcy sub categories --->
																						<input type="hidden" name="subcat5b" value="Bankruptcy" />
																						<input type="hidden" name="subcat5blist" value="" />
																					</cfoutput>
																				</cfif>						
																			
																				
																				
																				
																				
																				
																			
																			
																			
																	</ol><!-- / . close main ordered list for tree 5 -->
													</cfif>
													<!-- // end tree 5 --->
													
													
													
													
													
													
													
													
													
													