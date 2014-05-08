

			<!--- get our data components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>	
			
			<cfinvoke component="apis.com.clients.budgetgateway" method="getbudget" returnvariable="budget">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>		
			
			<cfinvoke component="apis.com.clients.budgetgateway" method="getdeductions" returnvariable="deductions">
				<cfinvokeargument name="budgetid" value="#budget.budgetid#">		
			</cfinvoke>
			
			<cfinvoke component="apis.com.clients.budgetgateway" method="getdeductiontypes" returnvariable="deducttypes">
			
			<cfinvoke component="apis.com.clients.budgetgateway" method="getincometotals" returnvariable="incometotals">
				<cfinvokeargument name="budgetid" value="#budget.budgetid#">
			</cfinvoke>
			
			
			
			<!--- // delete an income deduction from the grid --->
			<cfif structkeyexists( url, "fuseaction" ) and url.fuseaction is "deletededuct" >			
				<cfif structkeyexists( url, "deductid") and url.deductid is not "">
					<cfparam name="deductid" default="">
					<cfset deductid = #url.deductid# />					
					<cfquery datasource="#application.dsn#" name="killdeduct">
						delete
						  from deductions
						 where deductid = <cfqueryparam value="#deductid#" cfsqltype="cf_sql_integer" />
					</cfquery>					
					<cflocation url="#application.root#?event=#url.event#" addtoken="no">				
				<cfelse>				
					<script>
						alert('Sorry, there was a problem with the selected record and the operation has been aborted.  Please try again...');
						self.location="javascript:history.back(-1);"
					</script>				
				</cfif>			
			</cfif>
			
			
			<!--- // lead monthly budget income form vars --->
			<cfparam name="deductamt" default="">
			<cfparam name="deductdescr" default="">
			<cfparam name="deducttypeid" default="">
			<cfparam name="deductname" default="">
			
			<!--- // default our variables to zero values for empty strings --->
			<cfparam name="totalincome" default="0.00">
			<cfparam name="totaldeductions" default="0.00">
			<cfparam name="netincome" default="0.00">
			
			
			<cfif incometotals.totalincome is "">
				<cfset totalincome = 0.00 />
			<cfelse>
				<cfset totalincome = incometotals.totalincome />
			</cfif>
			
			<cfif incometotals.totaldeductions is "">
				<cfset totaldeductions = 0.00 />
			<cfelse>
				<cfset totaldeductions = incometotals.totaldeductions />
			</cfif>			
			
			<!--- // begin income page --->
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
											<strong><i class="icon-check"></i> SAVE SUCCESS!</strong>  The income deduction was successfully added to the client budget profile.  Please continue...
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
									<h3>Monthly Budget Income Deductions for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
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
											<cfset deduct = structnew() />
											<cfset deduct.budgetid = #form.budgetid# />										 
											<cfset deduct.deducttype = #form.deducttype# />										
											<cfset deduct.deductother = #form.deductother# />
											<cfset deduct.deductdescr = #form.deductdescr# />
											<cfset deduct.deductamount = #rereplace( form.deductamt, "[\$,]", "", "all" )# />									
											
											<!--- // some other variables --->
											<cfset today = #CreateODBCDateTime(now())# />											
																						
											
											<!--- // if income other is selected in the drop menu, make sure the user filled out the income other field --->
											<cfif deduct.deducttype eq 107 and deduct.deductother is "">
											
												<script>
													alert('You selected Other Deduction but did not include the other deduction description');
													self.location="javascript:history.back(-1);"												
												</script>
											
											<cfelse>
											
												<!--- // insert the record --->
												<cfquery datasource="#application.dsn#" name="adddeduction">
													insert into deductions(budgetid, deducttypeid, deducttypeother, deductdescr, deductamount)
														values (
																<cfqueryparam value="#deduct.budgetid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#deduct.deducttype#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#deduct.deductother#" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="#deduct.deductdescr#" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="#deduct.deductamount#" cfsqltype="cf_sql_float" />													
																);
												</cfquery>											
											
											
												<cfquery datasource="#application.dsn#" name="logact">
													insert into activity(leadid, userid, activitydate, activitytype, activity)
														values (
																<cfqueryparam value="#leaddetail.leadid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="#session.username# added income deduction details for #leaddetail.leadfirst# #leaddetail.leadlast#." cfsqltype="cf_sql_varchar" />
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
													
													<h3><i class="icon-list-alt"></i> Budget - Income - Deductions</h3>										
													
														<cfoutput>
															<ul class="nav nav-tabs">
																<li><a href="#application.root#?event=page.budget">Summary</a></li>
																<li><a href="#application.root#?event=page.budget.employment">Employer</a></li>															
																<li><a href="#application.root#?event=page.budget.income">Primary Income</a></li>
																<li><a href="#application.root#?event=page.budget.income2">Secondary Income</a></li>
																<li><a href="#application.root#?event=page.budget.expenses">Expenses</a></li>
																<li><a href="#application.root#?event=page.budget.assets">Assets &amp; Liabilities</a></li>
																<li class="active"><a href="#application.root#?event=#url.event#">Income Deductions</a></li>
															</ul>
																																															
														
															<!--- show income and deductions --->
															<div class="widget big-stats-container stacked">
						
																<div class="widget-content">
																	
																	<div id="big_stats" class="cf">
																		<div class="stat">								
																			<h4>Gross Income</h4>
																			<span class="value">#dollarformat( totalincome )#</span>								
																		</div> <!-- .stat -->
																		
																		<div class="stat">								
																			<h4>Total Deductions</h4>
																			<span class="value">#dollarformat( totaldeductions )#</span>																		
																		</div> <!-- .stat -->

																		<div class="stat">								
																			<h4>Net Income</h4>
																			<span class="value">#dollarformat( totalincome - totaldeductions )#</span>								
																		</div> <!-- .stat -->
																		
																	</div>
																
																</div> <!-- /widget-content -->
																
															</div> <!-- /widget -->
														</cfoutput>	
													
														<cfif deductions.recordcount gt 0>
															<!-- show a table listing the deduction items entered --->														
															<table class="table table-bordered table-striped">
																<thead>
																	<tr>
																		<th width="10%">Actions</th>
																		<th>Type</th>
																		<th>Description</th>
																		<th>Amount</th>																	
																	</tr>
																</thead>
																<tbody>
																	<cfoutput query="deductions">
																	<tr>
																		<td class="actions">
																			<a href="#application.root#?event=#url.event#&fuseaction=deletededuct&deductid=#deductid#" onclick="return confirmdelete();" class="btn btn-small btn-inverse">
																				<i class="btn-icon-only icon-trash"></i>										
																		</a>																		
																		</td>															
																		<td>#deducttypename# <cfif deducttypename is "other"> - #deducttypeother#</cfif></td>
																		<td>#deductdescr#</td>
																		<td><span class="label label-info">#dollarformat( deductamount )#</span></td>
																	</tr>
																	</cfoutput>
																</tbody>
															</table>
														<cfelse>
															<div class="alert alert-error">
																<button type="button" class="close" data-dismiss="alert">&times;</button>
																<strong><i class="icon-warning-sign"></i> NO RECORDS FOUND!</strong>  No income deductions have been entered in the client budget profile.  Please use the form below to add income deductions.
															</div>
														</cfif>
														<!--- // end grid view --->
													
															
															<!--- // begin deduction form --->
															<cfoutput>			
														
																<br /><br />
																<form id="manage-client-budget" class="form-horizontal" method="post" action="#application.root#?event=#url.event#">															
																	
																	<fieldset style="padding: 25px;border: 1px solid ##f2f2f2;">														
																		<h5>Enter Income Deductions</h5><br />
																		<div class="control-group">											
																			<label class="control-label" for="employer">Deduction Type</label>
																			<div class="controls">
																				<select name="deducttype" class="input-large">
																					<option value="">Select Deduct Category</option>
																					<cfloop query="deducttypes">																				
																						<option value="#deducttypeid#">#deducttypename#</option>
																					</cfloop>
																				</select>&nbsp; 																		
																				<input type="text" class="input-large" name="deductother" placeholder="Other Deduction Type" />
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->
																		
																		<div class="control-group">											
																			<label class="control-label" for="incomedescr">Deduction Description</label>
																			<div class="controls">
																				<input type="text" class="input-medium" name="deductdescr" />
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->

																		<div class="control-group">											
																			<label class="control-label" for="incomeamt">Deduct Amount</label>
																			<div class="controls">
																				<input type="text" class="input-small" name="deductamt" />
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->							
																		
																		<br />
																		<div class="form-actions">													
																			<button type="submit" class="btn btn-secondary" name="savebudget"><i class="icon-save"></i> Save Income Deduction</button>																										
																			<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.budget.income'"><i class="icon-remove-sign"></i> Cancel</a>													
																			<input name="utf8" type="hidden" value="&##955;">													
																			<input type="hidden" name="leadid" value="#leaddetail.leadid#" />																	
																			<input type="hidden" name="budgetid" value="#budget.budgetid#" />
																			<input type="hidden" name="buuid" value="#budget.budgetuuid#" />																	
																			<input type="hidden" name="__authToken" value="#randout#" />
																			<input name="validate_require" type="hidden" value="budgetid|Opps, sorry... the form can not be posted due to an internal error.  Please re-load the page and try again.;deducttype|The income deduction category is required.;deductamt|The income deduction amount is required.;deductdescr|Please enter a description for the income deduction source." />
																			<input name="validate_numeric" type="hidden" value="deductamt|'The deduction amount field' must be a numeric value..." />
																		</div> <!-- /form-actions -->
																	</fieldset>
																</form>
															
															</cfoutput>			
													
																	
												</div> <!-- / .tab1 -->										 
											
											</div> <!-- / .tab-content -->
										
										</div><!-- // .tabbable -->
											
										</div> <!-- / .span8 -->
									
									
										<script LANGUAGE="JavaScript">
											<!--
											// *** CLD - 2007-08-06 - Alert Confirm Delete
											function confirmdelete()
											{
											var agree=confirm("Are you sure you want to delete this income deduction?");
											if (agree)
												return true ;
											else
												return false ;
											}
											// -->
										</script>

								
								
								</div> <!-- / .widget-content -->
							
							</div> <!-- / .widget-stacked -->
						
						</div><!-- / .span12 -->
					
					</div> <!-- / .row -->
				
				</div> <!-- / .container -->
			
			</div> <!-- / .main -->
		
		
		