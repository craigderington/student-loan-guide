

			
			
				<!--- // kill any exisiting plan sessions --->
				<cfif structkeyexists( session, "planid" )>
					<cfset tempR = structdelete( session, "planid" ) />
				</cfif>


				<!--- // include our data components and api --->
				<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
					<cfinvokeargument name="leadid" value="#session.leadid#">
				</cfinvoke>					
				
				<cfinvoke component="apis.com.worksheets.worksheetgateway" method="getworksheets" returnvariable="worksheetlist">
					<cfinvokeargument name="leadid" value="#session.leadid#">
				</cfinvoke>
				
					<!--- // **** 1-19-2015 ***  // **** build solution matrix --->
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
					
					<!--- // include the tinymce js path --->
					<script src="//tinymce.cachefly.net/4.0/tinymce.min.js"></script>
				
					<!--- // initialize tinymce --->
					<script type="text/javascript">
						tinymce.init({
							selector: "textarea",
							auto_focus: "ibody",
							plugins: ["table"],
							width: 700,
							height: 400,
							paste_as_text: true,
							toolbar: "sizeselect | bold italic | fontselect | fontsizeselect",
							font_size_style_values: ["8px,10px,12px,13px,14px,16px,18px,20px"],
						});
					</script>	
				
				
				
			
					
						<div class="main">	
							
							<div class="container">
								
								<cfoutput>
								<form name="add-solution-text-section" action="#cgi.script_name#?event=page.mmi.solution.process" method="post">	
								</cfoutput>
								
									<div class="row">
						
										<div class="span8">																		
											
											<div class="widget stacked">										
												<cfoutput>
													<div class="widget-header">		
														<i class="icon-sitemap"></i>							
														<h3>#session.companyname# &raquo; Add Personalized Solution Narrative for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
													</div> <!-- //.widget-header -->
												</cfoutput>
												
												
												
												<div class="widget-content">				
												
													<a style="margin-top:5px;margin-left:5px;" href="#application.root#?event=page.tree"><i class="icon-circle-arrow-left"></i> Return to Options</a>
													
													<h4 style="margin-top:15px;margin-left:15px;"><i class="icon-edit"></i> <small>Add A Custom Student Loan Solution Narrative</small></h4>
																		
														<br />											
																		
															<fieldset>																
																			
																	<div class="control-group">																	
																		<div class="controls">
																			<textarea id="ibody" name="solutiontext"></textarea>
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->																	
																	
																	<br />										
																	
																		

																		<!--- // draw the form action buttons --->					
																		<cfoutput>
																			<div class="form-actions">													
																				<button type="submit" class="btn btn-secondary" name="create-action-plan"><i class="icon-arrow-circle-right"></i> Continue to Action Plan</button>																									
																					<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.tree'"><i class="icon-remove-sign"></i> Cancel</a>													
																					<input name="utf8" type="hidden" value="&##955;">													
																					<input type="hidden" name="leadid" value="#session.leadid#" />														
																					<input type="hidden" name="__authToken" value="#randout#" />
																					<input name="validate_require" type="hidden" value="leadid|Opps, sorry... the form can not be posted due to an internal error.  Please re-load the page and try again.;solutiontext|You did not enter a personal solution narrative." />															
																			</div> <!-- /form-actions -->
																		</cfoutput>
															</fieldset>
																								
											
											
												</div><!-- / .widget-content -->
											</div><!-- / .widget-content -->
										</div><!-- / .widget -->			
									
									
									
									<!--- // 11-18-2014 // add sidebar --->
									
										<div class="span4">										
											
											<div class="widget stacked">
												
												<div class="widget-header">		
													<i class="icon-list-alt"></i>							
													<h3>Qualified Solutions by Loan Type</h3>						
												</div> <!-- //.widget-header -->
												
												<div class="widget-content">													
													<cfinclude template="page.mmi.solution.matrix.cfm">													
												</div>
											</div>
											
											
											<!---<br />
											<div class="widget stacked">
												
												<div class="widget-header">		
													<i class="icon-money"></i>							
													<h3>Loan Summary</h3>						
												</div> <!-- //.widget-header -->
													
													
														<div class="widget-content">
															<small>
																<ul>									
																	<cfoutput query="worksheetlist">
																		<li><strong><cfif servid neq -1>#servname#<cfelse>#nslservicer#</cfif>:</strong> #dollarformat( loanbalance )#</li>
																	</cfoutput>
																</ul>			
															</small>											
														</div>
													
											</div>									
											--->
										</div><!-- / .span4 -->									
									</div>
									<div style="margin-top:150px;"></div>
								</form>
							</div>
						</div>
					