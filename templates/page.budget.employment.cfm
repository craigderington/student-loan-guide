

			<!--- get our data components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>	
			
			<cfinvoke component="apis.com.clients.budgetgateway" method="getbudget" returnvariable="budget">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			


			<!--- lead monthly budget page --->
			<cfparam name="budgetuuid" default="">
			<cfparam name="leadid" default="">
			<cfparam name="payfreq" default="">
			<cfparam name="employername" default="">
			<cfparam name="employeradd1" default="">
			<cfparam name="employeradd2" default="">
			<cfparam name="employercity" default="">
			<cfparam name="employerstate" default="">
			<cfparam name="employerzip" default="">			
			<cfparam name="currentjob" default="" />
			<cfparam name="dateemployed" default="">
			<cfparam name="spousename" default="">
			<cfparam name="spousesocial" default="">
			
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
											<strong><i class="icon-check"></i> SAVE SUCCESS!</strong>  The employer details were successfully updated in the client profile.  Please use the tabs below to continue...
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
									<h3>Employement Details for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
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
											<cfset emp = structnew() />
											<cfset emp.budgetid = #form.budgetid# />
											<cfset emp.leadid = #form.leadid# />
											<cfset emp.payfreq = #form.rgpayfreq# />
											<cfset emp.employer = #form.employer# />
											<cfset emp.empadd1 = #form.empadd1# />
											<cfset emp.empadd2 = #form.empadd2# />
											<cfset emp.empcity = #form.empcity# />
											<cfset emp.empzip = #form.empzip# />
											<cfset emp.currentjob = #form.myjob# />										
											
											<!--- 01-8-2014 // remove spousename and ssn 
											<cfset emp.spouse = #form.spousename# />
											<cfset emp.spousessn = #form.spousessn# />
											--->
											<cfset emp.empdate = #form.dateemployed# />
											<cfif isdefined( "form.empstate" )>
												<cfset emp.empstate = #ucase( left( form.empstate, 2 ))# />
											<cfelse>
												<cfset emp.empstate = "NN" />
											</cfif>										
											
											<!--- // some other variables --->
											<cfset today = #CreateODBCDateTime(now())# />
																				
																						
											<!--- // update the record --->
											<cfquery datasource="#application.dsn#" name="employerdata">
												update budget
												   set payfreq = <cfqueryparam value="#emp.payfreq#" cfsqltype="cf_sql_varchar" />,
												       employername = <cfqueryparam value="#emp.employer#" cfsqltype="cf_sql_varchar" />,
													   employeradd1 = <cfqueryparam value="#emp.empadd1#" cfsqltype="cf_sql_varchar" />,
													   employeradd2 = <cfqueryparam value="#emp.empadd2#" cfsqltype="cf_sql_varchar" />,
													   employercity = <cfqueryparam value="#emp.empcity#" cfsqltype="cf_sql_varchar" />,
													   employerstate = <cfqueryparam value="#emp.empstate#" cfsqltype="cf_sql_varchar" />,
													   employerzip = <cfqueryparam value="#emp.empzip#" cfsqltype="cf_sql_varchar" />,													   
													   currentjob = <cfqueryparam value="#emp.currentjob#" cfsqltype="cf_sql_varchar" />,
													   dateemployed = <cfqueryparam value="#emp.empdate#" cfsqltype="cf_sql_date" />
													   <!--- // remove spouse name and ssn 
													   spousename = <cfqueryparam value="#emp.spouse#" cfsqltype="cf_sql_varchar" />,
													   spousesocial = <cfqueryparam value="#emp.spousessn#" cfsqltype="cf_sql_varchar" />
													   --->
												 where budgetid = <cfqueryparam value="#emp.budgetid#" cfsqltype="cf_sql_integer" />											
											</cfquery>											
											
											
											<cfquery datasource="#application.dsn#" name="logact">
												insert into activity(leadid, userid, activitydate, activitytype, activity)
													values (
															<cfqueryparam value="#emp.leadid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
															<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#session.username# updated the client employment details for #leaddetail.leadfirst# #leaddetail.leadlast#." cfsqltype="cf_sql_varchar" />
															); select @@identity as newactid
											</cfquery>
											
											<cfquery datasource="#application.dsn#">
												insert into recent(userid, leadid, activityid, recentdate)
													values (
															<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#emp.leadid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#logact.newactid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />
															);
											</cfquery>

											<cfif isuserinrole( "bclient" )>																										
												<cfinvoke component="apis.com.portal.portaltaskgateway" method="markportaltaskcompleted" returnvariable="taskstatusmsg">
													<cfinvokeargument name="portaltaskid" value="1414">
													<cfinvokeargument name="leadid" value="#session.leadid#">
												</cfinvoke>
											</cfif>
											
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
													
													<h3><i class="icon-list-alt"></i> Employment Information</h3>										
													
														<cfoutput>
														<ul class="nav nav-tabs">
															<li><a href="#application.root#?event=page.budget">Summary</a></li>
															<li class="active"><a href="#application.root#?event=#url.event#">Employment</a></li>															
															<li><a href="#application.root#?event=page.budget.income">Primary Income</a></li>
															<li><a href="#application.root#?event=page.budget.income2">Spouse/Co-Borrower Income</a></li>
															<li><a href="#application.root#?event=page.budget.expenses">Expenses</a></li>															
														</ul>
														</cfoutput>												
														
														<cfif isuserinrole( "bclient" )>
															Please enter your employment information to include the employers name, address, income payment frequency, employment position, number of dependents and spouse name and identifying information.
														<cfelse>
															Please enter the client's employment information to include the employers name, address, income payment frequency, employment position, number of dependents and spouse name and identifying information.
														</cfif>
													<br>																					
													
													
													<cfoutput>
														
														<br />
														<form id="manage-client-budget" class="form-horizontal" method="post" action="#application.root#?event=page.budget.employment">															
															
															<fieldset>
																
																<div class="control-group">
																	<label class="control-label" for="rgpayfreq">Pay Frequency</label>
																	<div class="controls">
																		<label class="radio">
																			<input type="radio" name="rgpayfreq" value="Monthly" <cfif trim( budget.payfreq ) is "Monthly">checked</cfif>>
																			Monthly
																		</label>
																		<label class="radio">
																			<input type="radio" name="rgpayfreq" value="Semi-Monthly" <cfif trim( budget.payfreq ) is "Semi-Monthly">checked</cfif>>
																			Semi-Monthly
																		</label>
																		<label class="radio">
																			<input type="radio" name="rgpayfreq" value="Bi-Weekly" <cfif trim( budget.payfreq ) is "Bi-Weekly">checked</cfif>>
																			Bi-Weekly
																		</label>
																		<label class="radio">
																			<input type="radio" name="rgpayfreq" value="Weekly" <cfif trim( budget.payfreq ) is "Weekly">checked</cfif>>
																			Weekly
																		</label>																		
																	</div>
																</div>
																
																<div class="control-group">											
																	<label class="control-label" for="employer">Employer</label>
																	<div class="controls">
																		<input type="text" class="input-large" name="employer" value="<cfif isdefined( "form.employer" )>#form.employer#<cfelse>#budget.employername#</cfif>" />
																	</div> <!-- /controls -->				
																</div> <!-- /control-group -->

																<div class="control-group">											
																	<label class="control-label" for="budgetamt">Employer Address</label>
																	<div class="controls">
																		<input type="text" class="input-large" name="empadd1" value="<cfif isdefined( "form.empadd1" )>#form.empadd1#<cfelse>#budget.employeradd1#</cfif>" />&nbsp;<input type="text" class="input-medium" name="empadd2" value="<cfif isdefined( "form.empadd2" )>#form.empadd2#<cfelse>#budget.employeradd2#</cfif>" />
																	</div> <!-- /controls -->				
																</div> <!-- /control-group -->
																
																<div class="control-group">											
																	<label class="control-label" for="employercity">City, State, Zip</label>
																	<div class="controls">
																		<input type="text" class="input-medium" name="empcity" value="<cfif isdefined( "form.empcity" )>#form.empcity#<cfelse>#budget.employercity#</cfif>" />&nbsp;<input type="text" class="input-mini" name="empstate" value="<cfif isdefined( "form.empstate" )>#form.empstate#<cfelse>#budget.employerstate#</cfif>" maxlength="2" />&nbsp;<input type="text" class="input-small" name="empzip" value="<cfif isdefined( "form.empzip" )>#form.empzip#<cfelse>#budget.employerzip#</cfif>" maxlength="5" />
																	</div> <!-- /controls -->				
																</div> <!-- /control-group -->																
																<!---
																<div class="control-group">											
																	<label class="control-label" for="numdep">Number of Dependents</label>
																	<div class="controls">
																		<input type="text" class="input-mini" name="numdep" value="#budget.numdependents#" />																		
																	</div> <!-- /controls -->				
																</div> <!-- /control-group -->																								
																--->	
																<div class="control-group">											
																	<label class="control-label" for="myjob">Current Position</label>
																	<div class="controls">
																		<input type="text" class="input-medium" name="myjob" value="<cfif isdefined( "form.myjob" )>#form.myjob#<cfelse>#budget.currentjob#</cfif>" />
																	</div> <!-- /controls -->				
																</div> <!-- /control-group -->														

																<div class="control-group">											
																	<label class="control-label" for="dateemployed">Date Employed</label>
																	<div class="controls">
																		<input type="text" class="input-small" name="dateemployed" id="datepicker-inline3" value="#dateformat( budget.dateemployed, 'mm/dd/yyyy' )#">
																	</div> <!-- /controls -->				
																</div> <!-- /control-group -->
																
																<!--- // remove spouse name and social 
																<div class="control-group">											
																	<label class="control-label" for="spousename">Spouse Name</label>
																	<div class="controls">
																		<input type="text" class="input-large" name="spousename" value="#budget.spousename#" />
																	</div> <!-- /controls -->				
																</div> <!-- /control-group -->
																
																<div class="control-group">											
																	<label class="control-label" for="spousessn">Spouse SSN</label>
																	<div class="controls">
																		<input type="text" class="input-medium" name="spousessn" value="#budget.spousesocial#" />
																	</div> <!-- /controls -->				
																</div> <!-- /control-group -->
																--->
																
															    <br />
																<div class="form-actions">													
																	<button type="submit" class="btn btn-secondary" name="savebudget"><i class="icon-save"></i> Save Employer</button>																										
																	<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.summary'"><i class="icon-remove-sign"></i> Cancel</a>													
																	<input name="utf8" type="hidden" value="&##955;">													
																	<input type="hidden" name="leadid" value="#leaddetail.leadid#" />																	
																	<input type="hidden" name="budgetid" value="#budget.budgetid#" />
																	<input type="hidden" name="buuid" value="#budget.budgetuuid#" />																	
																	<input type="hidden" name="__authToken" value="#randout#" />
																	<input name="validate_require" type="hidden" value="budgetid|Opps, sorry... the form can not be posted due to an internal error.  Please re-load the page and try again.;employer|The employer name is required to save this form." />																	
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
		
		
		