

			
			<!--- get our data components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.clients.budgetgateway" method="getbudget" returnvariable="budget">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<!--- // set our totals for the primary income payroll deductions --->
			<cfparam name="totalprimarydeductions" default="0.00">
			<cfset totalprimarydeductions = budget.primarywithholding + budget.primaryfica + budget.primarymedicare + budget.primary401k + budget.primarybenefits + budget.primarycitytax + budget.primarystatetax />
			<cfset totalprimarydeductions = numberformat ( totalprimarydeductions, "99.99" ) />
			
			
			
			<!--- define our form params --->
			<cfparam name="primarygrossmonthly" default="0.00">
			<cfparam name="primarynetincome" default="0.00">
			<cfparam name="primarypjt" default="0.00">
			<cfparam name="primarypjtdescr" default="0.00">
			<cfparam name="primarypension" default="0.00">
			<cfparam name="primaryssi" default="0.00">
			<cfparam name="primarychildsupport" default="0.00">
			<cfparam name="primaryrentalprop" default="0.00">
			<cfparam name="primaryfoodstamps" default="0.00">
			<cfparam name="primaryincomeother" default="0.00">
			<cfparam name="primaryincomeotherdescr" default="0.00">
			<cfparam name="primarytotalincome" default="0.00">
			<cfparam name="calcnetincome" default="0.00">
			
			
			
			
					
			
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
											<strong><i class="icon-check"></i> SAVE SUCCESS!</strong>  The budget primary income details were successfully updated in the client profile.  Please use the tabs below to continue...
										</div>										
									</div>								
								</div>
							
							<cfelseif structkeyexists(url, "msg") and url.msg is "error">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-error">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong><i class="icon-warning-sign"></i> ERROR!</strong>  Sorry, there was a problem with the selected record and the operation was aborted.  Please use the navigation in the sidebar to continue...
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
											<cfset income = structnew() />
											<cfset income.budgetuuid = #form.budgetuuid# />										 
											<cfset income.grossincome = #replace( form.primarygrossmonthly, "[\$,]", "", "all" )# />										
											<cfset income.netincome = #replace( form.primarynetincome, "[\$,]", "", "all" )# />
											<cfset income.parttimeincome = #replace( form.primaryptj, "[\$,]", "", "all" )# />
											<cfset income.parttimedescr = #form.primaryptjdescr# />
											<cfset income.pension = #rereplace( form.primarypension, "[\$,]", "", "all" )# />
											<cfset income.ssi = #replace( form.primaryssi, "[\$,]", "", "all" )# />
											<cfset income.childsupport = #replace( form.primarychildsupport, "[\$,]", "", "all" )# />
											<cfset income.rentalprop = #replace( form.primaryrentalprop, "[\$,]", "", "all" )# />
											<cfset income.foodstamps = #replace( form.primaryfoodstamps, "[\$,]", "", "all" )# />
											<cfset income.incomeother = #replace( form.primaryincomeother, "[\$,]", "", "all" )# />
											<cfset income.incomeotherdescr = #form.primaryincomeotherdescr# />
											
											
											<cfset income.totalincome = ( income.grossincome - totalprimarydeductions ) + income.parttimeincome + income.pension + income.ssi + income.childsupport + income.rentalprop + income.foodstamps + income.incomeother />
											<cfset income.totalincome = numberformat( income.totalincome, "999.99" ) />
											
											<!--- // some other variables --->
											<cfset today = #CreateODBCDateTime(now())# />											
																						
											
											
											
												<!--- // update the record --->
												<cfquery datasource="#application.dsn#" name="saveincomedata">
													update budget
													   set primarygrossmonthly = <cfqueryparam value="#income.grossincome#" cfsqltype="cf_sql_float" />,													       
														   primaryparttimejob = <cfqueryparam value="#income.parttimeincome#" cfsqltype="cf_sql_float" />,
														   primaryparttimejobdescr = <cfqueryparam value="#income.parttimedescr#" cfsqltype="cf_sql_varchar" />,
														   primarypension = <cfqueryparam value="#income.pension#" cfsqltype="cf_sql_float" />,
														   primaryssi = <cfqueryparam value="#income.ssi#" cfsqltype="cf_sql_float" />,
														   primarychildsupport = <cfqueryparam value="#income.childsupport#" cfsqltype="cf_sql_float" />,
														   primaryrentalproperty = <cfqueryparam value="#income.rentalprop#" cfsqltype="cf_sql_float" />,
														   primaryfoodstamps = <cfqueryparam value="#income.foodstamps#" cfsqltype="cf_sql_float" />,
														   primaryincomeothera = <cfqueryparam value="#income.incomeother#" cfsqltype="cf_sql_float" />,
														   primaryincomeotheradescr = <cfqueryparam value="#income.incomeotherdescr#" cfsqltype="cf_sql_varchar" />,
														   primarytotalincome = <cfqueryparam value="#income.totalincome#" cfsqltype="cf_sql_float" />,														   
														   primarynetincome = <cfqueryparam value="#income.netincome#" cfsqltype="cf_sql_float" />														   
													 where budgetuuid = <cfqueryparam value="#income.budgetuuid#" cfsqltype="cf_sql_varchar" maxlength="35" />
												</cfquery>											
											
											
												<cfquery datasource="#application.dsn#" name="logact">
													insert into activity(leadid, userid, activitydate, activitytype, activity)
														values (
																<cfqueryparam value="#leaddetail.leadid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="#session.username# saved the income details for #leaddetail.leadfirst# #leaddetail.leadlast#." cfsqltype="cf_sql_varchar" />
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
													
													<h3><i class="icon-list-alt"></i> Budget - Primary Income</h3>										
													
														
														
														<cfoutput>
														<ul class="nav nav-tabs">
															<li><a href="#application.root#?event=page.budget">Summary</a></li>
															<li><a href="#application.root#?event=page.budget.employment">Employment</a></li>															
															<li class="active"><a href="#application.root#?event=#url.event#">Primary Income</a></li>
															<li><a href="#application.root#?event=page.budget.income2">Spouse/Co-Borrower Income</a></li>
															<li><a href="#application.root#?event=page.budget.expenses">Expenses</a></li>															
														</ul>
														</cfoutput>
														
														
														
														<br />
														
														
														<!--- // begin new budget form --->
														<cfoutput>
															
															<form id="lead-budget-income" class="form-horizontal" method="post" action="#application.root#?event=#url.event#">
																<fieldset>						

																	<div class="control-group">											
																		<label class="control-label" for="primarygrossmonthly">Gross Monthly Income</label>
																		<div class="controls">
																			<input type="text" class="input-small" name="primarygrossmonthly" value="#numberformat( budget.primarygrossmonthly, 'L99.99' )#" /><a href="javascript:;" style="margin-left:7px;" class="btn btn-default btn-mini" onclick="window.open('templates/primary-payroll-deductions.cfm','','scrollbars=yes, top=300, left=450, width=680, height=590');"><i class="icon-money"></i> Enter Payroll Deductions <cfif totalprimarydeductions neq 0.00> - Total: #dollarformat( totalprimarydeductions )#</cfif></a>
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->
																	
																	<cfset calcnetincome = numberformat( budget.primarygrossmonthly - totalprimarydeductions, "99999.99" ) />
																	
																	<div class="control-group">											
																		<label class="control-label" for="primarynetincome">Net Income</label>
																		<div class="controls">
																			<input type="text" class="input-small" name="primarynetincome" value="#numberformat( calcnetincome, 'L99.99' )#" style="background-color:##ffffcc;font-weight:bold;"  />
																			<span class="help-block">The net income field is auto-calculated.  Enter gross monthly income and deductions, then save.</span>
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->

																	<p style="margin-left:10px;margin-bottom:10px;" class="help-block">The following income categories should be entered as the net monthly income.</p>
																	
																	<div class="control-group">											
																		<label class="control-label" for="primaryptj">Part Time Job</label>
																		<div class="controls">
																			<input type="text" class="input-small" name="primaryptj" value="#numberformat( budget.primaryparttimejob, 'L99.99' )#" />&nbsp;&nbsp;<input type="text" class="input-large" name="primaryptjdescr" value="#trim( budget.primaryparttimejobdescr )#" placeholder="Part Time Job Description"/>
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->
																	
																	<div class="control-group">											
																		<label class="control-label" for="primarypension">Pension</label>
																		<div class="controls">
																			<input type="text" class="input-small" name="primarypension" value="#numberformat( budget.primarypension, 'L99.99' )#" />
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->
																	
																	<div class="control-group">											
																		<label class="control-label" for="primaryssi">Social Security</label>
																		<div class="controls">
																			<input type="text" class="input-small" name="primaryssi" value="#numberformat( budget.primaryssi, 'L99.99' )#" />
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->
																	
																	<div class="control-group">											
																		<label class="control-label" for="primarychildsupport">Child Support</label>
																		<div class="controls">
																			<input type="text" class="input-small" name="primarychildsupport" value="#numberformat( budget.primarychildsupport, 'L99.99' )#" />
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->
																	
																	<div class="control-group">											
																		<label class="control-label" for="primaryrentalprop">Rental Property</label>
																		<div class="controls">
																			<input type="text" class="input-small" name="primaryrentalprop" value="#numberformat( budget.primaryrentalproperty, 'L99.99' )#" />
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->
																	
																	<div class="control-group">											
																		<label class="control-label" for="primaryfoodstamps">Food Stamps</label>
																		<div class="controls">
																			<input type="text" class="input-small" name="primaryfoodstamps" value="#numberformat( budget.primaryfoodstamps, 'L99.99' )#" />
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->
																	
																	<div class="control-group">											
																		<label class="control-label" for="primaryincomeother">Other Income</label>
																		<div class="controls">
																			<input type="text" class="input-small" name="primaryincomeother" value="#numberformat( budget.primaryincomeothera, 'L99.99' )#" />&nbsp;&nbsp;<input type="text" class="input-large" name="primaryincomeotherdescr" value="#trim( budget.primaryincomeotheradescr )#" placeholder="Other Income Description" />
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->
																	
																	<div class="control-group">											
																		<label class="control-label" for="primarytotalincome">Total Income</label>
																		<div class="controls">
																			<input type="text" class="input-small" name="primarytotalincome" value="#numberformat( budget.primarytotalincome, 'L99.99' )#" readonly="true" style="background-color:red;color:white;font-weight:bold;" />
																			<span class="help-block">The total income field is auto-calculated</span>
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->
																																						
																	
																	<br />
																	
																	<div class="form-actions">													
																		<button type="submit" class="btn btn-secondary" name="saveincome"><i class="icon-save"></i> Save Primary Income</button>																									
																		<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.budget'"><i class="icon-remove-sign"></i> Cancel</a>									
																		<input name="utf8" type="hidden" value="&##955;">													
																		<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
																		<input type="hidden" name="budgetuuid" value="#budget.budgetuuid#" />																		
																		<input type="hidden" name="__authToken" value="#randout#" />
																		<input name="validate_require" type="hidden" value="primarygrossmonthly|The primary gross monthly income is required to post this form." />															
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

		