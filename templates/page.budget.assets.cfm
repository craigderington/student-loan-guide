

			<!--- get our data components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>	
			
			<cfinvoke component="apis.com.clients.budgetgateway" method="getbudget" returnvariable="budget">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.clients.assetgateway" method="getassettypes" returnvariable="assettypes">				
			</cfinvoke>			
			
			<cfinvoke component="apis.com.clients.assetgateway" method="getassets" returnvariable="myassets">
				<cfinvokeargument name="budgetid" value="#budget.budgetid#">
				<cfinvokeargument name="leadid" value="#leaddetail.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.clients.assetgateway" method="getassetsbycat" returnvariable="assetsbycat">
				<cfinvokeargument name="budgetid" value="#budget.budgetid#">				
			</cfinvoke>
			
			
			<cfinvoke component="apis.com.clients.assetgateway" method="getassettotals" returnvariable="assettotals">
				<cfinvokeargument name="budgetid" value="#budget.budgetid#">				
			</cfinvoke>
			
			
			
			<!--- // define asset and libailities vars and set default values --->
			<cfparam name="totalassets" default="0.00">
			<cfparam name="totalliabilities" default="0.00">
			<cfparam name="networth" default="0.00">
			
			<cfif assettotals.totalassets is "">
				<cfset totalassets = 0.00 />
			<cfelse>
				<cfset totalassets = assettotals.totalassets />
			</cfif>
			
			<cfif assettotals.totalliabilities is "">
				<cfset totalliabilities = 0.00 />
			<cfelse>
				<cfset totalliabilities = assettotals.totalliabilities />
			</cfif>
			
			<cfset networth = ( totalassets - totalliabilities ) />			


			<!--- define form vars --->
			<cfparam name="assetcatid" default="">
			<cfparam name="leadid" default="">
			<cfparam name="budgetid" default="">
			<cfparam name="assetother" default="">
			<cfparam name="assetdescr" default="">
			<cfparam name="assetvalue" default="">
			<cfparam name="liabilityvalue" default="">
								
			
			
			<!--- // begin assets and liabilites page --->
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
						
							<!--- system messages --->
							<cfif structkeyexists(url, "msg") and url.msg is "saved">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-info">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong><i class="icon-check"></i> SAVE SUCCESS!</strong>  The assets and liabilities data was successfully added to the client's budget profile.  Please use the tabs below to continue...
										</div>										
									</div>								
								</div>
							<cfelseif structkeyexists(url, "msg") and url.msg is "deleted">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-success">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong>DELETE SUCCESS!</strong>  The budget item was successfully deleted from the client's profile.  Please use the navigation in the sidebar to continue...
										</div>										
									</div>								
								</div>
							<cfelseif structkeyexists(url, "msg") and url.msg is "error">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-error">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong>ERROR!</strong>  Sorry, there was a problem with the selected record and the operation was aborted.  Please use the navigation in the sidebar to continue...
										</div>										
									</div>								
								</div>
							</cfif>						
						
							<!--- // begin widget --->
							<div class="widget stacked">
								
								<cfoutput>
								<div class="widget-header">		
									<i class="icon-list-alt"></i>							
									<h3>Monthly Budget Income Details for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
								</div> <!-- //.widget-header -->
								</cfoutput>	
								
								<div class="widget-content">
								
									<!--- // validate CFC Form Processing --->				
									
									<cfif isDefined("form.fieldnames")>
										<cfscript>
											objValidation = createObject("component","apis.com.ui.validation").init();
											objValidation.setFields(form);
											objValidation.validate();
										</cfscript>

										<cfif objValidation.getErrorCount() is 0>							
											
											<!--- define our structure and set form values --->
											<cfset myassets = structnew() />
											<cfset myassets.budgetid = #form.budgetid# />
											<cfset myassets.leadid = #form.leadid# />
											<cfset myassets.assettype = #form.assettype# />
											<cfset myassets.assetother = #form.assetother# />
											<cfset myassets.assetdescr = #form.assetdescr# />
											<cfset myassets.assetvalue = #form.assetvalue# />
											<cfset myassets.liabvalue = #form.liabvalue# />
											
											<cfif myassets.assetvalue is "">
												<cfset myassets.assetvalue = 0.00 />
											<cfelse>
												<cfset myassets.assetvalue = rereplace( form.assetvalue, "[\$,]", "", "all" ) />
											</cfif>
											
											<cfif myassets.liabvalue is "">
												<cfset myassets.liabvalue = 0.00 />
											<cfelse>												
												<cfset myassets.liabvalue = rereplace( form.liabvalue, "[\$,]", "", "all" ) />
											</cfif>
											
											<!--- // some other variables --->
											<cfset today = #CreateODBCDateTime(now())# />
											
											<cfif myassets.assettype eq 135 and myassets.assetother is "">
											
												<script>
													alert('You selected asset type other but did not fill in the asset other text field.  The operation has been aborted...');
													self.location="javascript:history.back(-1);"												
												</script>
											
											<cfelse>
																						
												<!--- // update the record --->
												<cfquery datasource="#application.dsn#" name="addassetdata">
													insert into assets(budgetid, leadid, assetcatid, assetdescr, assetother, assetamount, liabilityamount)
														values (
																<cfqueryparam value="#myassets.budgetid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#myassets.leadid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#myassets.assettype#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#myassets.assetdescr#" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="#myassets.assetother#" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="#myassets.assetvalue#" cfsqltype="cf_sql_float" />,
																<cfqueryparam value="#myassets.liabvalue#" cfsqltype="cf_sql_float" />														
																);
												</cfquery>											
												
												
												<cfquery datasource="#application.dsn#" name="logact">
													insert into activity(leadid, userid, activitydate, activitytype, activity)
														values (
																<cfqueryparam value="#leaddetail.leadid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="#session.username# added assets and liabilities data for #leaddetail.leadfirst# #leaddetail.leadlast#." cfsqltype="cf_sql_varchar" />
																); select @@identity as newactid
												</cfquery>
												
												<cfquery datasource="#application.dsn#">
													insert into recent(userid, leadid, activityid, recentdate)
														values (
																<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#leaddetail.leadid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#logact.newactid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />
																);
												</cfquery>											
												
												<cflocation url="#application.root#?event=#url.event#&msg=saved" addtoken="no">
											
											</cfif>
										<!--- If the required data is missing - throw the validation error --->
										<cfelse>
										
											<div class="alert alert-error">
												<a class="close" data-dismiss="alert">&times;</a>
													<h5><error>There were <cfoutput>#objValidation.getErrorCount()#</cfoutput> errors in your submission:</error></h2>
													<ul>
														<cfloop collection="#variables.objValidation.getMessages()#" item="rr">
															<li class="formerror"><cfoutput>#variables.objValidation.getMessage(rr)#</cfoutput></li>
														</cfloop>
													</ul>
											</div>
								
										</cfif>
									</cfif>
									
									<!--- // end form processing --->										
								
										<!--- // include the side bar nav --->
										<div class="span3">					
											<cfinclude template="page.sidebar.nav.cfm">		
										</div> <!-- /.span3 -->
			
			
										<div class="span8">
										
										<div class="tabbable">										
											
											<div class="tab-content">
												
												<div class="tab-pane active" id="tab1">
													
													<h3><i class="icon-list-alt"></i> Budget - Assets &amp; Liabilities</h3>										
													
														<cfoutput>
															<ul class="nav nav-tabs">
																<li><a href="#application.root#?event=page.budget">Summary</a></li>
																<li><a href="#application.root#?event=page.budget.employment">Employment</a></li>															
																<li><a href="#application.root#?event=page.budget.income">Primary Income</a></li>
																<li><a href="#application.root#?event=page.budget.income2">Secondary Income</a></li>
																<li><a href="#application.root#?event=page.budget.expenses">Expenses</a></li>
																<li class="active"><a href="#application.root#?event=#url.event#">Assets &amp; Liabilities</a></li>
															</ul>
															
																<div class="widget big-stats-container stacked">
																	<div class="widget-content">																		
																		<div id="big_stats" class="cf">
																			<div class="stat">								
																				<h4>Total Assets</h4>
																				<span class="value">#dollarformat( totalassets )#</span>								
																			</div> <!-- .stat -->										
																		
																			<div class="stat">								
																				<h4>Total Liabilities</h4>
																				<span class="value">#dollarformat( totalliabilities )#</span>								
																			</div> <!-- .stat -->																
																		
																			<div class="stat">								
																				<h4>Total Net Worth</h4>
																				<span class="value">#dollarformat( networth )#</span>								
																			</div> <!-- .stat -->																	
																		</div><!-- //.big-stats -->																		
																	</div><!-- //.widget-content -->
																</div><!-- // .widget -->										
														</cfoutput>												
														
														
														<!--- // show the grid of assets and liabilities --->													
														<cfif assetsbycat.recordcount gt 0>
															<table class="table table-bordered table-striped">
																<thead>
																	<tr>
																		<th width="10%">Actions</th>
																		<th>Category</th>
																		<th>Asset Amount</th>
																		<th>Liability Amount</th>																		
																	</tr>
																</thead>
																<tbody>
																	<cfoutput query="assetsbycat">
																	<tr>
																		<td class="actions">																			
																			<a href="#application.root#?event=#url.event#" class="btn btn-small btn-inverse">
																				<i class="btn-icon-only icon-trash"></i>										
																			</a>									
																		</td>																		
																		<td>#assetcatname# (#totalcat#)</td>
																		<td><span class="label label-success">#dollarformat( totalassets )#</span></td>																		
																		<td><span class="label label-important">#dollarformat( totalliabilities )#</span></td>
																	</tr>
																	</cfoutput>
																</tbody>
															</table>
														<cfelse>
															
															<div class="alert alert-error">
																<button type="button" class="close" data-dismiss="alert">&times;</button>
																<strong><i class="icon-warning-sign"></i> NO RECORDS FOUND!</strong> No assets or liabilities have been entered into the client's budget profile.  Please use the asset form below to continue...
															</div>
														
														</cfif>
													
													
														<!--- // draw the assets and liabilities form --->
														<cfoutput>			
														
															<br />
															<form id="manage-client-budget" class="form-horizontal" method="post" action="#application.root#?event=#url.event#">															
																
																<fieldset style="padding:25px;border:1px solid ##f2f2f2;">														
																	<h5>Enter Assets and Liabilities</h5><br />
																	
																	<div class="control-group">											
																		<label class="control-label" for="employer">A & L Category</label>
																		<div class="controls">
																			<select name="assettype" class="input-large">
																				<option value="">Select A &amp; L Category</option>
																				<cfloop query="assettypes">																				
																					<option value="#assetcatid#">#assetcatname#</option>
																				</cfloop>
																			</select>&nbsp; 																		
																			<input type="text" class="input-large" name="assetother" placeholder="Other Category" />
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->
																
																	<div class="control-group">											
																		<label class="control-label" for="assetdescr">Description</label>
																		<div class="controls">
																			<input type="text" class="input-large" name="assetdescr" />
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->

																	<div class="control-group">											
																		<label class="control-label" for="assetvalue">Asset Value</label>
																		<div class="controls">
																			<input type="text" class="input-medium" name="assetvalue" placeholder="Estimated Asset Value"/>&nbsp;&nbsp;<input type="text" class="input-medium" name="liabvalue" placeholder="Liability Amount" />
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->							
																
																	<br />
																	<div class="form-actions">													
																		<button type="submit" class="btn btn-secondary" name="savebudget"><i class="icon-save"></i> Save Asset</button>																										
																		<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.budget'"><i class="icon-remove-sign"></i> Cancel</a>													
																		<input name="utf8" type="hidden" value="&##955;">													
																		<input type="hidden" name="leadid" value="#leaddetail.leadid#" />																	
																		<input type="hidden" name="budgetid" value="#budget.budgetid#" />
																		<input type="hidden" name="buuid" value="#budget.budgetuuid#" />																	
																		<input type="hidden" name="__authToken" value="#randout#" />
																		<input name="validate_require" type="hidden" value="budgetid|Opps, sorry... the form can not be posted due to an internal error.  Please re-load the page and try again.;assettype|Please select an asset category.;assetdescr|Please enter a short description for the asset or liability." />
																		<input name="validate_numeric" type="hidden" value="assetvalue|'The income amount field' must be a numeric value...;liabvalue|The liability value must be numeric." />
																	</div> <!-- /form-actions -->
																</fieldset>
															</form>
													
														</cfoutput>			
													
																	
												</div> <!-- / .tab1 -->										 
											
											</div> <!-- / .tab-content -->
										
										</div><!-- // .tabbable -->
											
										</div> <!-- / .span8 -->
									
					
								</div> <!-- / .widget-content -->
							
							</div> <!-- / .widget-stacked -->
						
						</div><!-- / .span12 -->
					
					</div> <!-- / .row -->
				
				</div> <!-- / .container -->
			
			</div> <!-- / .main -->
		
		
		