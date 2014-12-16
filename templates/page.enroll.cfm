
			
			
			<!--- // call our data access components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#" >
			</cfinvoke>
			
			<cfinvoke component="apis.com.leads.leadgateway" method="getleadsummary" returnvariable="leadsummary">
				<cfinvokeargument name="leadid" value="#session.leadid#" >
			</cfinvoke>			
			
			<cfinvoke component="apis.com.leads.leadgateway" method="getsls" returnvariable="slslist">
				<cfinvokeargument name="companyid" value="#session.companyid#" >
			</cfinvoke>
			
			
			<!--- // define our forms vars --->			
			<cfparam name="inquirydate" default="">
			<cfparam name="inquiryoutcome" default="">
			<cfparam name="slbalance" default="">
			<cfparam name="slmonthly" default="">
			<cfparam name="slq1" default="">
			<cfparam name="slq2" default="">
			<cfparam name="contactmethod" default="">
			

			<!--- lead summary page --->			
			
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">						
						
						<!--- // display system messages --->
							
							<cfif structkeyexists(url, "msg") and url.msg is "saved">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-info">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong><i class="icon-check"></i> SUCCESS!</strong>  The client program enrollment details were successfully updated.  Please use the navigation in the sidebar to continue...
										</div>										
									</div>								
								</div>							
							</cfif>	
						
							<!--- // start page widget and draw form --->
						
							<div class="widget stacked">
								<cfoutput>	
								<div class="widget-header">		
									<i class="icon-user"></i>							
									<h3>Program Enrollment for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
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
											
											<!--- define our structure and set form values--->
											<cfset lead = structnew() />
											<cfset lead.leadid = #form.leadid# />
											<cfset lead.summaryid = #form.leadsummaryid# />											
											<cfset lead.inquirydate = #form.inquirydate# />
											<cfset lead.outcome = #form.inquiryoutcome# />
											<cfset lead.balance = #form.slbalance# />
											<cfset lead.monthly = #form.slmonthly# />
											<cfset lead.slq1 = #form.loantype# />
											<cfset lead.slq2 = #form.loanstatus# />
											<cfset lead.method = #form.contactmethod# />
											<cfset lead.agencyid = #form.agencyid# />
											
											<!--- // some other variables --->
											<cfset today = #CreateODBCDateTime(now())# />
											
											<!--- // manipulate some strings for proper case --->
											<cfset lead.balance = rereplace( lead.balance, "[\$,]", "", "all" ) />
											<cfset lead.monthly = rereplace( lead.monthly, "[\$,]", "", "all" ) />											
											
											<cfquery datasource="#application.dsn#" name="summary">
													update slsummary
													   set slq1 = <cfqueryparam value="#lead.slq1#" cfsqltype="cf_sql_varchar" />,
														   slq2 = <cfqueryparam value="#lead.slq2#" cfsqltype="cf_sql_varchar" />,
														   slbalance = <cfqueryparam value="#lead.balance#" cfsqltype="cf_sql_float" />,
														   slmonthly = <cfqueryparam value="#lead.monthly#" cfsqltype="cf_sql_float" />,
														   slinquirydate = <cfqueryparam value="#lead.inquirydate#" cfsqltype="cf_sql_date" />,														  
														   sloutcome = <cfqueryparam value="#lead.outcome#" cfsqltype="cf_sql_varchar" />,
														   slenrollclientmethod = <cfqueryparam value="#lead.method#" cfsqltype="cf_sql_varchar" />
													 where summaryid = <cfqueryparam value="#lead.summaryid#" cfsqltype="cf_sql_integer" />
											</cfquery>
											
											<cfquery datasource="#application.dsn#" name="saveagencyid">
													update leads
													   set agencyuniqueid = <cfqueryparam value="#lead.agencyid#" cfsqltype="cf_sql_varchar" />
													 where leadid = <cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />
											</cfquery>

											<cfif lead.outcome is not "">
												<cfinvoke component="apis.com.tasks.taskautomation" method="marktaskcompleted" returnvariable="taskmsg">
													<cfinvokeargument name="leadid" value="#session.leadid#">
													<cfinvokeargument name="taskref" value="outcome">
												</cfinvoke>
											</cfif>											
											
											<cfif lead.balance is not "">
												<cfinvoke component="apis.com.tasks.taskautomation" method="marktaskcompleted">
													<cfinvokeargument name="leadid" value="#session.leadid#">
													<cfinvokeargument name="taskref" value="debtbal">
												</cfinvoke>
											</cfif>
											
											<cfif lead.monthly is not "">
												<cfinvoke component="apis.com.tasks.taskautomation" method="marktaskcompleted">
													<cfinvokeargument name="leadid" value="#session.leadid#">
													<cfinvokeargument name="taskref" value="monpay">
												</cfinvoke>
											</cfif>
											
											<cfif lead.slq1 is not "">
												<cfinvoke component="apis.com.tasks.taskautomation" method="marktaskcompleted">
													<cfinvokeargument name="leadid" value="#session.leadid#">
													<cfinvokeargument name="taskref" value="loantype">
												</cfinvoke>
											</cfif>
											
											<cfif lead.slq2 is not "">
												<cfinvoke component="apis.com.tasks.taskautomation" method="marktaskcompleted">
													<cfinvokeargument name="leadid" value="#session.leadid#">
													<cfinvokeargument name="taskref" value="loanstat">
												</cfinvoke>
											</cfif>
											
											<cfquery datasource="#application.dsn#" name="logact">
												insert into activity(leadid, userid, activitydate, activitytype, activity)
													values (
															<cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
															<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#session.username# updated and saved the program enrollment details for #leaddetail.leadfirst# #leaddetail.leadlast#." cfsqltype="cf_sql_varchar" />
															); select @@identity as newactid
											</cfquery>
											
											<cfquery datasource="#application.dsn#">
												insert into recent(userid, leadid, activityid, recentdate)
													values (
															<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#logact.newactid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />
															);
											</cfquery>											
											
											<cfif structkeyexists( form, "savelead" )>
												<cflocation url="#application.root#?event=#url.event#&msg=saved" addtoken="no">
											<cfelseif structkeyexists( form, "saveleadcontinue" )>
												<cflocation url="#application.root#?event=page.fees" addtoken="no">
											<cfelse>
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
											
											<div class="tab-content">
												<cfoutput>
												<div class="tab-pane active" id="tab1">
													
													<h3><i class="icon-picture"></i> Inquiry Summary <span style="float:right;font-size:16px;">Entered: #dateformat( leaddetail.leaddate, "mm/dd/yyyy" )#</span></h3>
													
													<p>Please fill in the fields below to begin enrolling in the program.  At a minimum, answer the questions below and select the inquiry reason and inquiry outcome.  Once you have had a counseling session with the client, you can continue completing the required fields for enrollment date and signed agreements.</p>
													
													<br>
													
													<form id="edit-enrollment" class="form-horizontal" method="post" action="#application.root#?event=#url.event#">
														<fieldset>
															
															<!---
															<div class="control-group">											
																<label class="control-label" for="assignedsls">Assigned Specialist</label>
																<div class="controls">
																	<select name="assignedsls" id="assignedsls"	class="input-large">
																		<option value="">Select Specialist</option>
																		<cfloop query="slslist">
																			<option value="#userid#"<cfif leadsummary.slsid eq slslist.userid>selected</cfif>>#firstname# #lastname#</option>
																		</cfloop>
																	</select>
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->															
															
															<div class="control-group">											
																<label class="control-label" for="inquiryreason">Inquiry Reason</label>
																<div class="controls">
																	<select name="inquiryreason" id="inquiryreason"	class="input-large">
																		<option value="">Select Inquiry Reason</option>
																		<option value="Student Loan Help"<cfif trim(leadsummary.slreason) is "student loan help">selected</cfif>>Student Loan Help</option>
																		<option value="Debt Management"<cfif trim(leadsummary.slreason) is "debt management">selected</cfif>>Debt Management</option>																
																	</select>
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->									
															--->
															
															<div class="control-group">											
																<label class="control-label" for="agencyid"><strong>Agency Unique ID</strong></label>
																<div class="controls">
																	<input type="text" class="input-small" maxlength="20" name="agencyid" id="agencyid" value="<cfif isdefined( "form.agencyid" )>#trim( form.agencyid )#<cfelse><cfif leaddetail.agencyuniqueid is not "">#trim( leaddetail.agencyuniqueid )#</cfif></cfif>">
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->
															
															<div class="control-group">											
																<label class="control-label" for="Contact Method">Contact Method</label>
																<div class="controls">
																	<select name="contactmethod" id="contactmethod" class="input-large">
																		<option value="">Select Contact Method</option>
																		<option value="In Person"<cfif isdefined( "form.contactmethod" ) and trim( form.contactmethod ) is "in person">selected<cfelse><cfif trim( leadsummary.slenrollclientmethod ) is "in person">selected</cfif></cfif>>In Person</option>
																		<option value="Phone Call"<cfif isdefined( "form.contactmethod" ) and trim( form.contactmethod ) is "phone call">selected<cfelse><cfif trim( leadsummary.slenrollclientmethod ) is "phone call">selected</cfif></cfif>>Phone Call</option>
																		<option value="Facetime"<cfif isdefined( "form.contactmethod" ) and trim( form.contactmethod ) is "facetime">selected<cfelse><cfif trim( leadsummary.slenrollclientmethod ) is "facetime">selected</cfif></cfif>>Facetime</option>
																		<option value="Skype"<cfif isdefined( "form.contactmethod" ) and trim( form.contactmethod ) is "skype">selected<cfelse><cfif trim( leadsummary.slenrollclientmethod ) is "skype">selected</cfif></cfif>>Skype</option>
																		<option value="GTM"<cfif isdefined( "form.contactmethod" ) and trim( form.contactmethod ) is "gtm">selected<cfelse><cfif trim( leadsummary.slenrollclientmethod ) is "go to meeting">selected</cfif></cfif>>Go To Meeting</option>
																	</select>
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->
															
															<div class="control-group">											
																<label class="control-label" for="inquirydate">Inquiry Date</label>
																<div class="controls">
																	<input type="text" class="input-small" name="inquirydate" id="datepicker-inline" value="<cfif isdefined( "form.inquirydate" )>#dateformat( form.inquirydate, "mm/dd/yyyy" )#<cfelse><cfif leadsummary.slinquirydate is "">#dateformat(leaddetail.leaddate, "mm/dd/yyyy")#<cfelse>#dateformat(leadsummary.slinquirydate, "mm/dd/yyyy")#</cfif></cfif>">
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->														

															<div class="control-group">											
																<label class="control-label" for="inquiryoutcome">Outcome</label>
																<div class="controls">
																	<select name="inquiryoutcome" id="inquiryoutcome" class="input-large">
																		<option value="">Select Inquiry Outcome</option>
																		<option value="Appointment"<cfif isdefined( "form.inquiryoutcome" ) and trim( form.inquiryoutcome ) is "appointment">selected<cfelse><cfif trim( leadsummary.sloutcome ) is "appointment">selected</cfif></cfif>>Appointment</option>
																		<option value="Counseled"<cfif isdefined( "form.inquiryoutcome" ) and trim( form.inquiryoutcome ) is "counseled">selected<cfelse><cfif trim( leadsummary.sloutcome ) is "counseled">selected</cfif></cfif>>Counseled</option>
																		<option value="Loan Analysis"<cfif isdefined( "form.inquiryoutcome" ) and trim( form.inquiryoutcome ) is "loan analysis">selected<cfelse><cfif trim( leadsummary.sloutcome ) is "loan analysis">selected</cfif></cfif>>Loan Analysis</option>
																		<option value="Referred to Agency"<cfif isdefined( "form.inquiryoutcome" ) and trim( form.inquiryoutcome ) is "referred to agency">selected<cfelse><cfif trim( leadsummary.sloutcome ) is "refer to agency">selected</cfif></cfif>>Referred to Agency</option>
																		<option value="Client Making Decision"<cfif isdefined( "form.inquiryoutcome" ) and trim( form.inquiryoutcome ) is "client making decision">selected<cfelse><cfif trim( leadsummary.sloutcome ) is "client making decision">selected</cfif></cfif>>Client Making Decision</option>
																		<option value="Unable to Assist"<cfif isdefined( "form.inquiryoutcome" ) and trim( form.inquiryoutcome ) is "unable to assist">selected<cfelse><cfif trim( leadsummary.sloutcome ) is "unable to assist">selected</cfif></cfif>>Unable to Assist</option>
																	</select>
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->
															
															<div class="control-group">											
																<label class="control-label" for="slbalance">Balance of Student Loan Debt</label>
																<div class="controls">
																	<input type="text" class="input-medium" name="slbalance" id="slbalance" value="<cfif isdefined( "form.slbalance" )>#numberformat( form.slbalance, "L999999.99" )#<cfelse>#numberformat( leadsummary.slbalance, "L999999.99" )#</cfif>">
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->

															<div class="control-group">											
																<label class="control-label" for="monthlypay">Monthly Payment</label>
																<div class="controls">
																	<input type="text" class="input-small" name="slmonthly" id="slmonthly" value="<cfif isdefined( "form.slmonthly" )>#numberformat( form.slmonthly, "L99999.99" )#<cfelse>#numberformat(leadsummary.slmonthly, "L99999.99")#</cfif>">
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->
															
															<div class="control-group">											
																<label class="control-label" for="loantype">Summary Question 1</label>
																<div class="controls" style="padding-bottom:7px;">
																	<span style="font-size:15px;">Are your student loans private or government?</span>
																	<label class="radio" style="padding-top:5px;">
																		<input type="radio" name="loantype" value="private" id="loantype"<cfif isdefined( "form.loantype" ) and trim( form.loantype ) is "private">checked<cfelse><cfif trim( leadsummary.slq1 ) is "private">checked</cfif></cfif>>
																			Private
																	</label>
																	<label class="radio">
																		<input type="radio" name="loantype" id="loantype" value="gov"<cfif isdefined( "form.loantype" ) and trim( form.loantype ) is "gov">checked<cfelse><cfif trim( leadsummary.slq1 ) is "gov">checked</cfif></cfif>>
																			Government
																	</label>
																	<label class="radio">
																		<input type="radio" name="loantype" id="loantype" value="both"<cfif isdefined( "form.loantype" ) and trim( form.loantype ) is "both">checked<cfelse><cfif trim( leadsummary.slq1 ) is "both">checked</cfif></cfif>>
																			Both
																	</label>
																	<label class="radio">
																		<input type="radio" name="loantype" id="loantype" value="ns"<cfif isdefined( "form.loantype" ) and trim( form.loantype ) is "ns">checked<cfelse><cfif trim( leadsummary.slq1 ) is "ns">checked</cfif></cfif>>
																			Not Sure
																	</label>
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->
															
															<div class="control-group">											
																<label class="control-label" for="loanstatus">Summary Question 2</label>
																<div class="controls">
																	<span style="font-size:15px;">Are your student loans current, delinquent, postponement, or in default?</span>
																	<label class="radio" style="padding-top:5px;">
																		<input type="radio" name="loanstatus" id="loanstatus" value="Current"<cfif isdefined( "form.loanstatus" ) and trim( form.loanstatus ) is "current">checked<cfelse><cfif trim( leadsummary.slq2 ) is "current">checked</cfif></cfif>>
																		Current
																	</label>
																	<label class="radio">
																		<input type="radio" name="loanstatus" id="loanstatus" value="Delinquent"<cfif isdefined( "form.loanstatus" ) and trim( form.loanstatus ) is "delinquent">checked<cfelse><cfif trim( leadsummary.slq2 ) is "delinquent">checked</cfif></cfif>>
																		Delinquent
																	</label>
																	<label class="radio">
																		<input type="radio" name="loanstatus" id="loanstatus" value="Default"<cfif isdefined( "form.loanstatus" ) and trim( form.loanstatus ) is "default">checked<cfelse><cfif trim( leadsummary.slq2 ) is "default">checked</cfif></cfif>>
																		Default
																	</label>
																	<label class="radio">
																		<input type="radio" name="loanstatus" id="loanstatus" value="Post"<cfif isdefined( "form.loanstatus" ) and trim( form.loanstatus ) is "post">checked<cfelse><cfif trim( leadsummary.slq2 ) is "post">checked</cfif></cfif>>
																		Postponement
																	</label>
																	<label class="radio">
																		<input type="radio" name="loanstatus" id="loanstatus" value="Not Sure"<cfif isdefined( "form.loanstatus" ) and trim( form.loanstatus ) is "not sure">checked<cfelse><cfif trim( leadsummary.slq2 ) is "not sure">checked</cfif></cfif>>
																		Not Sure
																	</label>
																</div> <!-- / .controls -->				
															</div> <!-- / .control-group -->
															
															
															<div class="form-actions">													
																<button type="submit" class="btn btn-secondary" name="savelead"><i class="icon-save"></i> Save Enrollment Details</button>
																<button type="submit" class="btn btn-tertiary" name="saveleadcontinue"><i class="icon-refresh"></i> Save Enrollment &amp; Continue</button>
																<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.summary'"><i class="icon-remove-sign"></i> Cancel</a>													
																<input name="utf8" type="hidden" value="&##955;">												
																<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
																<input type="hidden" name="leadsummaryid" value="#leadsummary.summaryid#" />
																<input type="hidden" name="__authToken" value="#randout#" />
																<input name="validate_require" type="hidden" value="leadid|'Lead ID' is a required field.;leadsummaryid|Opps, there was a problem with the form and the form can not be posted at this time.;contactmethod|The contact method is required to save the enrollment settings.;loantype|Please select an answer to question 1.;loanstatus|Please select an answer to question 2.;slbalance|Please enter an estimated student loan debt balance.;slmonthly|Please enter the current student loan monthly payment amount." />									
															</div>
														</fieldset>
													</form>
																	
												</div> <!-- / .tab1 -->										 
												</cfoutput>
											</div> <!-- /.tab-content -->
											
										</div> <!-- / .span8 -->			
									
					
								</div> <!-- /. widget-content -->
							
							</div> <!-- /. widget-stacked -->
						
						</div><!-- / .span12 -->
					
					</div> <!-- / .row -->
				
				</div> <!-- / .container -->
			
			</div> <!-- / .main -->