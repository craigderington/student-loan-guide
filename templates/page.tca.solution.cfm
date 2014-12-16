






			<!--- // Take Charge America Workflow --->
			
			
			<!--- // include our data components and api --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>			
			
			<cfinvoke component="apis.com.clients.clientgateway" method="getclientsurvey" returnvariable="clientsurvey">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>			
			
			<cfinvoke component="apis.com.worksheets.worksheetgateway" method="getworksheets" returnvariable="worksheetlist">
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
				
				
				<cfset tca = structnew() />
				
				
					<cfif structkeyexists( form, "tcasolution" )>
						<!--- // create a struct of selected options --->																			
						
						<cfif isdefined( "form.idrconsol" )>
							<cfset tca.idrconsol = trim( form.idrconsol ) />						
						</cfif>
						
						<cfif isdefined( "form.consol" )>
							<cfset tca.consol = trim( form.consol ) />						
						</cfif>
						
						<cfif isdefined( "form.econdefer" )>						
							<cfset tca.econdefer = trim( form.econdefer ) />						
						</cfif>
						
						<cfif isdefined( "form.forbear" )>						
							<cfset tca.forbear = trim( form.forbear ) />						
						</cfif>
						
						<cfif isdefined( "form.ibr" )>
							<cfset tca.ibr = trim( form.ibr ) />						
						</cfif>
						
						<cfif isdefined( "form.icr" )>
							<cfset tca.icr = trim( form.icr ) />						
						</cfif>
						
						<cfif isdefined( "form.paye" )>
							<cfset tca.paye = trim( form.paye ) />
						</cfif>
						
						<cfif isdefined( "form.pslfconsol" )>
							<cfset tca.pslfconsol = trim( form.pslfconsol ) />
						</cfif>
						
						<cfif isdefined( "form.pslf" )>
							<cfset tca.pslf = trim( form.pslf ) />
						</cfif>
						
						<cfif isdefined( "form.rehab" )>
							<cfset tca.rehab = trim( form.rehab ) />
						</cfif>
						
						<cfif isdefined( "form.tlf" )>
							<cfset tca.tlf = trim( form.tlf ) />
						</cfif>
						
						<cfif isdefined( "form.unempdefer" )>
							<cfset tca.unempdefer = trim( form.unempdefer ) />
						</cfif>
					</cfif>
				
				
					<cfif structisempty( tca )>					
						
						<cflocation url="#application.root#?event=page.tree&tca_error=1" addtoken="no">		
						
					</cfif>
				
			
					<cfoutput>
						<div class="main">	
							
							<div class="container">
								
								<div class="row">
						
									<div class="span8">
										
										<div class="widget stacked">
											
											<div class="widget-header">		
												<i class="icon-sitemap"></i>							
												<h3>Take Charge America &raquo; Add Solution Narrative for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
											</div> <!-- //.widget-header -->
											
											<div class="widget-content">				
											
												<a style="margin-top:5px;margin-left:5px;" href="#application.root#?event=page.tree"><i class="icon-circle-arrow-left"></i> Return to Options</a>
												
												<h4 style="margin-top:15px;margin-left:15px;"><i class="icon-edit"></i> Add A Personal Message</h4>
																	
													<br />
																	
														<form name="add-solution-text-section" action="#cgi.script_name#?event=page.tca.solution.process" method="post">
																		
															<fieldset>																
																			
																	<div class="control-group">																	
																		<div class="controls">
																			<textarea id="ibody" name="solutiontext"></textarea>
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->
																	
																	<!--- // hidden form layer containing selected solution options --->
																	<cfset thiskeytostruct = structkeyarray( tca ) /> 
																		<cfloop index="i" from="1" to="#arraylen( thiskeytostruct )#"> 												
																			 <input type="hidden" name="#thiskeytostruct[i]#" value="Y" /> 
																		</cfloop>
																	
																	<br />
																			
																	<div class="form-actions">													
																		<button type="submit" class="btn btn-secondary" name="create-action-plan"><i class="icon-arrow-circle-right"></i> Continue to Action Plan</button>																									
																			<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.tree'"><i class="icon-remove-sign"></i> Cancel</a>													
																			<input name="utf8" type="hidden" value="&##955;">													
																			<input type="hidden" name="leadid" value="#session.leadid#" />														
																			<input type="hidden" name="__authToken" value="#randout#" />
																			<input name="validate_require" type="hidden" value="leadid|Opps, sorry... the form can not be posted due to an internal error.  Please re-load the page and try again.;solutiontext|You did not enter a personal solution narrative." />															
																	</div> <!-- /form-actions -->
																	
															</fieldset>
														</form>											
											
											
											</div>
										</div>
									</div>
									
									
									
									
									
									
									
									
									
									
									
									
									<!--- // 11-18-2014 // add sidebar --->
									
									<div class="span4">
										
										<div class="widget stacked">
											
											<div class="widget-header">		
												<i class="icon-list-alt"></i>							
												<h3>The Solutions You've Selected</h3>						
											</div> <!-- //.widget-header -->
											
											<div class="widget-content">
											
												
												<!---// --->
												<cfif structisempty( tca )>
													<small>
														<error>
															You did not select any options from the client options menu.  Please go back.
														</error>
													</small>
												
												<cfelse>
													
													<h5 style="color:red;"><i class="icon-cogs"></i> You've selected #structcount( tca )# solutions.</h5>
													
													<cfset keystostruct = structkeyarray( tca ) /> 
													<cfloop index="i" from="1" to="#arraylen( keystostruct )#"> 												
														<p style="font-weight:bold;"><i class="icon-ok"></i> #tca[keysToStruct[i]]#</p> 
													</cfloop>										
												
												</cfif>
												
												<!---
												<cfdump var="#tca#" label="TCA Form Vars">
												--->
												
												
												
												
											
											</div>
										</div>
										<br />
										<div class="widget stacked">
											
											<div class="widget-header">		
												<i class="icon-money"></i>							
												<h3>Loan Summary</h3>						
											</div> <!-- //.widget-header -->
											
											<div class="widget-content">
												<small>
													<ul>									
														<cfloop query="worksheetlist">
															<li><strong><cfif servid neq -1>#servname#<cfelse>#nslservicer#</cfif>:</strong> #dollarformat( loanbalance )#</li>
														</cfloop>
													</ul>			
												</small>											
											</div>
										</div>									
										
									</div>									
								</div>
								<div style="margin-top:150px;"></div>
							</div>
						</div>
					</cfoutput>