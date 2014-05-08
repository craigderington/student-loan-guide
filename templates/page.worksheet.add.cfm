

			
			<!--- get our data components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>			
			
			<cfinvoke component="apis.com.worksheets.worksheetgateway" method="getloancodes" returnvariable="loancodes">
			<cfinvoke component="apis.com.worksheets.worksheetgateway" method="getrepaycodes" returnvariable="repaycodes">
			<cfinvoke component="apis.com.worksheets.worksheetgateway" method="getstatuscodes" returnvariable="statuscodes">
			<cfinvoke component="apis.com.system.servicers" method="getservicers" returnvariable="servicerlist">
				
			
			<!-- // define our form vars --->
			<cfparam name="servicer" default="">
			<cfparam name="loancode" default="">
			<cfparam name="statuscode" default="">
			<cfparam name="repaycode" default="">
			<cfparam name="acctnum" default="">
			<cfparam name="loanbalance" default="">
			<cfparam name="currpay" default="">
			<cfparam name="intrate" default="">
			<cfparam name="origdate" default="">
			<cfparam name="enddate" default="">
			<cfparam name="duedate" default="">
			<cfparam name="rgprevcon" default="">
			<cfparam name="rgrehab" default="">
			<cfparam name="rginccon" default="">
			<cfparam name="school" default="">
			
			
			

			<!--- student loan debt worksheet page --->
			
			
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
						
							<div class="widget stacked">
								<cfoutput>	
								<div class="widget-header">		
									<i class="icon-refresh"></i>							
									<h3>Student Loan Debt Worksheets for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
								</div> <!-- //.widget-header -->
								</cfoutput>	
							
								<div class="widget-content">
									
									<!--- // begin form processing --->
									<cfif isDefined("form.fieldnames")>
										<cfscript>
											objValidation = createObject("component","apis.com.ui.validation").init();
											objValidation.setFields(form);
											objValidation.validate();
										</cfscript>

										<cfif objValidation.getErrorCount() is 0>							
											
											<!--- define our structure and set form values --->
											<cfset debt = structnew() />
											<cfset debt.leadid = #form.leadid# />
											<cfset debt.name = #form.slname# />
											<cfset debt.worksheetuuid = #createuuid()# />
											<cfset debt.servicerid = #form.servicer# />
											<cfset debt.loancodeid = #form.loancode# />
											<cfset debt.statuscodeid = #form.statuscode# />
											<cfset debt.repaycodeid = #form.repaycode# />
											<cfset debt.acctnum = #form.acctnum# />
											<cfset debt.loanbalance = #form.loanbalance# />
											<cfset debt.currpay = #form.currpay# />
											<cfset debt.intrate = #form.intrate# />
											<cfset debt.origdate = #form.origdate# />
											<cfset debt.enddate = #form.enddate# />
											<cfset debt.duedate = #form.duedate# />											
											<cfset debt.rehab = #form.rgrehab# />
											<cfset debt.school = #trim( form.school )# />

											<cfif form.loancode eq 15 or form.loancode eq 20 >
												<cfset debt.prevcon = "Y" />
											<cfelse>
												<cfset debt.prevcon = #trim( form.rgprevcon )# />
											</cfif>
											
											<cfset debt.loanbalance = rereplace( debt.loanbalance, "[\$,]", "", "all" ) />
											<cfset debt.currpay = rereplace( debt.currpay, "[\$,]", "", "all" ) />
											<cfset debt.intrate = numberformat( debt.intrate, '999.99' ) />
																						
											<!--- // some other variables --->
											<cfset today = #CreateODBCDateTime(now())# />											
																						
											<!--- // create the database record --->
											<cfquery datasource="#application.dsn#" name="addworksheet">
												insert into slworksheet(worksheetuuid, leadid, dateadded, loancodeid, statuscodeid, repaycodeid, servicerid, acctnum, loanbalance, currentpayment, intrate, closeddate, graceenddate, paymentduedate, prevconsol, rehabafter, active, attendingschool)
													values (
															<cfqueryparam value="#debt.worksheetuuid#" cfsqltype="cf_sql_varchar" maxlength="35" />,
															<cfqueryparam value="#debt.leadid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
															<cfqueryparam value="#debt.loancodeid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#debt.statuscodeid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#debt.repaycodeid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#debt.servicerid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#debt.acctnum#" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#debt.loanbalance#" cfsqltype="cf_sql_float" />,
															<cfqueryparam value="#debt.currpay#" cfsqltype="cf_sql_float" />,
															<cfqueryparam value="#debt.intrate#" cfsqltype="cf_sql_float" />,
															<cfqueryparam value="#debt.origdate#" cfsqltype="cf_sql_date" />,
															<cfqueryparam value="#debt.enddate#" cfsqltype="cf_sql_date" />,
															<cfqueryparam value="#debt.duedate#" cfsqltype="cf_sql_date" />,
															<cfqueryparam value="#debt.prevcon#" cfsqltype="cf_sql_char" maxlength="1" />,
															<cfqueryparam value="#debt.rehab#" cfsqltype="cf_sql_char" maxlength="1" />,															
															<cfqueryparam value="1" cfsqltype="cf_sql_bit" />,
															<cfqueryparam value="#debt.school#" cfsqltype="cf_sql_varchar" />
														   );
											</cfquery>

											<!--- // task automation --->
											<cfinvoke component="apis.com.tasks.taskautomation" method="marktaskcompleted" returnvariable="taskmsg">
												<cfinvokeargument name="leadid" value="#session.leadid#">
												<cfinvokeargument name="taskref" value="debtwksht">
											</cfinvoke>
											
											<!--- // mark portal task complete --->
											<cfif isuserinrole( "bclient" )>
												<cfinvoke component="apis.com.portal.portaltaskgateway" method="markportaltaskcompleted" returnvariable="taskstatusmsg">
													<cfinvokeargument name="portaltaskid" value="1410">
													<cfinvokeargument name="leadid" value="#session.leadid#">
												</cfinvoke>
											</cfif>
											
											<!--- // log the activity --->
											<cfquery datasource="#application.dsn#" name="logact">
												insert into activity(leadid, userid, activitydate, activitytype, activity)
													values (
															<cfqueryparam value="#debt.leadid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
															<cfqueryparam value="Record Added" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#session.username# added a student loan debt worksheet for #debt.name#." cfsqltype="cf_sql_varchar" />
															);
											</cfquery>																					
											
											<cflocation url="#application.root#?event=page.worksheet&msg=added" addtoken="no">
								
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
									<!-- // end form processing --->				
									
												
										<!--- // include the side bar nav --->
										<div class="span3">					
											<cfinclude template="page.sidebar.nav.cfm">		
										</div> <!-- /.span3 -->
			
			
										<div class="span8">
											
											<div class="tab-content">
												
												<div class="tab-pane active" id="tab1">										
													
													<h3><i class="icon-refresh"></i> Add Student Loan Debt Worksheet</h3>												
													
													<p>Please use the form below to add a new student loan debt worksheet.  All of the fields below are required to add the student loan debt.  You can either select a loan servicers from the existing list or add a new servicer by completing the servicer fields below.</p>
													
													<br>
													
													<cfoutput>
														<form id="add-debt-worksheet" class="form-horizontal" method="post" action="#application.root#?event=#url.event#">
															<fieldset>																
																<div class="control-group">											
																	<label class="control-label" for="servicer">Select Servicer</label>
																	<div class="controls">
																		<select name="servicer" id="servicer" class="input-large span3">
																			<option value="">Select Servicer</option>
																			<cfloop query="servicerlist">
																				<option value="#servid#"<cfif isdefined("form.servicer") and form.servicer eq servid>selected</cfif>>#servname#</option>
																			</cfloop>
																		</select><a href="javascript:;" class="btn btn-small" style="margin-left:5px;"><i class="icon-cloud-upload"></i> Add Servicer</a>
																	</div> <!-- /controls -->				
																</div> <!-- /control-group -->
																
																<div class="control-group">											
																	<label class="control-label" for="school">School Attended</label>
																	<div class="controls">
																		<input type="text" name="school" id="school" class="input-xlarge" <cfif isdefined( "form.school" )>value="#form.school#"</cfif>>
																	</div> <!-- /controls -->				
																</div> <!-- /control-group -->

																<div class="control-group">											
																	<label class="control-label" for="loancode">Select Loan Code</label>
																	<div class="controls">
																		<select name="loancode" id="loancode" class="input-large span3">
																			<option value="">Select Loan Code</option>
																			<cfloop query="loancodes">
																				<option value="#loancodeid#"<cfif isdefined("form.loancode") and form.loancode eq loancodeid>selected</cfif>>#loancode# - #codedescr#</option>
																			</cfloop>
																		</select>
																	</div> <!-- /controls -->				
																</div> <!-- /control-group -->
																
																<div class="control-group">											
																	<label class="control-label" for="statuscode">Select Status Code</label>
																	<div class="controls">
																		<select name="statuscode" id="statuscode" class="input-large span3">
																			<option value="">Select Status Code</option>
																			<cfloop query="statuscodes">
																				<option value="#statuscodeid#"<cfif isdefined("form.statuscode") and form.statuscode eq statuscodeid>selected</cfif>>#statuscode# - #statuscodedescr#</option>
																			</cfloop>
																		</select>
																	</div> <!-- /controls -->				
																</div> <!-- /control-group -->
																
																<div class="control-group">											
																	<label class="control-label" for="repaycode">Select Current Repayment Code</label>
																	<div class="controls">
																		<select name="repaycode" id="repaycode" class="input-large span3">
																			<option value="">Select Repayment Code</option>
																			<cfloop query="repaycodes">
																				<option value="#repaycodeid#"<cfif isdefined("form.repaycode") and form.repaycode eq repaycodeid>selected</cfif>>#repaycode# - #repaycodedescr#</option>
																			</cfloop>
																		</select>
																	</div> <!-- /controls -->				
																</div> <!-- /control-group -->
																
																<div class="control-group">											
																	<label class="control-label" for="acctnum">Account Number</label>
																	<div class="controls">
																		<input type="text" name="acctnum" id="acctnum" class="input-medium" maxlength="50" <cfif isdefined("form.acctnum")>value="#form.acctnum#"</cfif> />
																	</div> <!-- /controls -->				
																</div> <!-- /control-group -->
																
																<div class="control-group">											
																	<label class="control-label" for="loanbalance">Loan Balance</label>
																	<div class="controls">
																		<input type="text" name="loanbalance" id="loanbalance" class="input-medium" <cfif isdefined("form.loanbalance")>value="#form.loanbalance#"</cfif>>
																	</div> <!-- /controls -->				
																</div> <!-- /control-group -->
																
																<div class="control-group">											
																	<label class="control-label" for="currpay">Current Payment</label>
																	<div class="controls">
																		<input type="text" name="currpay" id="currpay" class="input-small" <cfif isdefined("form.currpay")>value="#form.currpay#"</cfif>>
																	</div> <!-- /controls -->				
																</div> <!-- /control-group -->
																
																<div class="control-group">											
																	<label class="control-label" for="intrate">Interest Rate</label>
																	<div class="controls">
																		<input type="text" name="intrate" id="intrate" class="input-small" <cfif isdefined("form.intrate")>value="#form.intrate#"</cfif>>
																	</div> <!-- /controls -->				
																</div> <!-- /control-group -->
																
																<div class="control-group">											
																	<label class="control-label" for="origdate">Origination Date</label>
																	<div class="controls">
																		<input type="text" name="origdate" id="datepicker-inline2" class="input-small" <cfif isdefined("form.origdate")>value="#form.origdate#"</cfif>>
																	</div> <!-- /controls -->				
																</div> <!-- /control-group -->
																
																<div class="control-group">											
																	<label class="control-label" for="enddate">Grace End Date</label>
																	<div class="controls">
																		<input type="text" name="enddate" id="datepicker-inline3" class="input-small" <cfif isdefined("form.enddate")>value="#form.enddate#"</cfif>>
																	</div> <!-- /controls -->				
																</div> <!-- /control-group -->
																
																<div class="control-group">											
																	<label class="control-label" for="duedate">Due Date</label>
																	<div class="controls">
																		<input type="text" name="duedate" id="datepicker-inline4" class="input-small" <cfif isdefined("form.duedate")>value="#form.duedate#"</cfif>>
																	</div> <!-- /controls -->				
																</div> <!-- /control-group -->
																
																<!--- // 12-5-2013 // remove - not needed - default to true 
																<div class="control-group">
																	<label class="control-label" for="rginccon">Include debt in Repayment Calculator</label>
																	<div class="controls">
																		<label class="radio">
																			<input type="radio" name="rginccon" value="1" id="rginccon" checked>
																			YES 
																		</label>
																		<label class="radio">
																			<input type="radio" name="rginccon" value="0" id="rginccon">
																			NO &nbsp; <a href="javascript:;" rel="popover" data-content="If you include a private loan in the debt worksheet then you must select NO to exclude the loan from consolidation." data-original-title="Notice for Private Loans" ><i class="btn-icon-only icon-warning-sign alert-error"></i></a>
																		</label>																		
																	</div>
																</div>
																--->
																
																<div class="control-group">
																	<label class="control-label" for="accounttype">Previous Consolidation</label>
																	<div class="controls">
																		<label class="radio">
																			<input type="radio" name="rgprevcon" value="Y" id="rgprevcon">
																			YES
																		</label>
																		<label class="radio">
																			<input type="radio" name="rgprevcon" value="N" id="rgprevcon" checked>
																			NO
																		</label>
																	</div>
																</div>
																
																<div class="control-group">
																	<label class="control-label" for="accounttype">Rehab After 8/14/2008</label>
																	<div class="controls">
																		<label class="radio">
																			<input type="radio" name="rgrehab" value="Y" id="rgrehab">
																			YES
																		</label>
																		<label class="radio">
																			<input type="radio" name="rgrehab" value="N" id="rgrehab" checked>
																			NO
																		</label>
																	</div>
																</div>											
																
																<br />
																<div class="form-actions">													
																	<button type="submit" class="btn btn-secondary" name="savedebt"><i class="icon-save"></i> Save Debt Worksheet</button>																										
																	<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.worksheet'"><i class="icon-remove-sign"></i> Cancel</a>													
																	<input name="utf8" type="hidden" value="&##955;">													
																	<input type="hidden" name="leadid" value="#leaddetail.leadid#" />																	
																	<input type="hidden" name="__authToken" value="#randout#" />
																	<input type="hidden" name="slname" value="#leaddetail.leadfirst# #leaddetail.leadlast#" />
																	<input name="validate_require" type="hidden" value="leadid|Sorry... the form can not be posted due to an internal error.  Please re-load the page and try again.;loancode|Please select the loan code from the list.;statuscode|Please select the status code from the list,;repaycode|Please select the repayment code from the list.;acctnum|Please enter the student loan account number.;loanbalance|Please enter the loan balance.;intrate|Please enter the loan interest rate.;origdate|Please select the loan origination date.;rgprevcon|Please select an option for previous consolidation.;rgrehab|Please select an option for loan rehab." />															
																	<input name="validate_numeric" type="hidden" value="intrate|'Interest Rate' must be a number.  Do not enter any special characters..." />
																	<input name="validate_dateus" type="hidden" value="origdate|The origination date is invalid.  Please check your input and try again...;enddate|The grace end date is invalid.  Please check your input and try again...;duedate|The loan due date is invalid.  Please check your input and try again..." />
																</div> <!-- /form-actions -->									
															</fieldset>							
														</form>							
													</cfoutput>											
												</div> <!-- /#tab1 -->										 
											
											</div> <!-- /.tab-content -->
											
										</div> <!-- /.span8 -->
			
									
					
								</div> <!-- /. widget-content -->
							
							</div> <!-- /. widget-stacked -->
						
						</div><!-- / .span12 -->
					
					</div> <!-- / .row -->
					
					<div style="margin-top:150px;"></div>
					
					
				
				</div> <!-- / .container -->
			
			</div> <!-- / .main -->