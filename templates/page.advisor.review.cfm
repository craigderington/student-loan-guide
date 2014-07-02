


		<!--- get our sdata access components --->
		<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
			<cfinvokeargument name="leadid" value="#session.leadid#">
		</cfinvoke>
		
		<cfinvoke component="apis.com.leads.leadgateway" method="getadvisortasks" returnvariable="advisortasklist">
			<cfinvokeargument name="leadid" value="#session.leadid#">
		</cfinvoke>
		
		
		
		
		<!--- // 3-12-2014 // add intake review page to trigger advisory options --->
		
		
		
		
		<div class="container">			
				
			<div class="row">			
					
				<div class="span12">				
						
					<div class="widget stacked">							
							
						<cfoutput>	
						<div class="widget-header">		
							<i class="icon-book"></i>							
							<h3>Student Loan Advisor Task Completion &amp; Review for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
						</div> <!-- //.widget-header -->
						</cfoutput>
						
						
						<div class="widget-content">
							
							<!--- // form processing --->
							<cfif isDefined("form.fieldnames")>
								<cfscript>
									objValidation = createobject( "component","apis.com.ui.validation" ).init();
									objValidation.setFields( form );
									objValidation.validate();
								</cfscript>

									<cfif objValidation.getErrorCount() is 0>
										
										<cfset lead = structnew() />
										<cfset lead.leadid = #form.leadid# />
										<cfset lead.advisorinitials = #ucase( form.advisorcompinitials )# />

										
										<!--- // some other variables --->
										<cfset today = #createodbcdatetime( now() )# />																					
											
										<cfquery datasource="#application.dsn#" name="summary">
											update leads
											   set leadadvisorycompdate = <cfqueryparam value="#createodbcdatetime( today )#" cfsqltype="cf_sql_timestamp" />,
												   leadadvisorycompby = <cfqueryparam value="#lead.advisorinitials#" cfsqltype="cf_sql_varchar" />
											 where leadid = <cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />
										</cfquery>						

										<!--- // task automation 
										<cfinvoke component="apis.com.tasks.taskautomation" method="marktaskcompleted" returnvariable="taskmsg">
											<cfinvokeargument name="leadid" value="#session.leadid#">
											<cfinvokeargument name="taskref" value="advreview">
										</cfinvoke>
										--->
											
										<!--- // log the client activity --->
										<cfquery datasource="#application.dsn#" name="logact">
											insert into activity(leadid, userid, activitydate, activitytype, activity)
												values (
														<cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />,
														<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
														<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
														<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
														<cfqueryparam value="#session.username# completed the intake review for #leaddetail.leadfirst# #leaddetail.leadlast#." cfsqltype="cf_sql_varchar" />
														); 
											</cfquery>
										
										<cflocation url="#application.root#?event=#url.event#" addtoken="no">
								
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
							
							
							
							
							
							
							<div class="span3">
								<cfinclude template="page.sidebar.nav.cfm">
							</div>
							
							<div class="span8">
								
								
								<h3><i class="icon-flag"></i> Review Advisor Task Completion</h3>
								<p>Please take a moment to review all of the client's student loan advisory services information.  This includes the student loan debt worksheet, loan solutions, selecting the right solution and creating the client's Solution Presentation.  Click the checkmark in the actions column next to each task item to go to that page.  Once all the data has been reviewed, please select an advisor completion date and enter your initials to certify that advisory services has been completed.</p>
								<br />							

									
								<cfif advisortasklist.recordcount gt 0>									
									
									<table class="table table-bordered table-striped table-highlight">
										<thead>
											<tr>
												<th width="10%">Actions</th>
												<th>Type</th>
												<th>Task Name</th>
												<th>Task Status</th>
												<th>Task Date</th>
											</tr>
										</thead>
										<tbody>
											<cfoutput query="advisortasklist">										
											<tr>
												<td class="actions">													
													<div align="center"><cfif taskcompleteddate is not ""><i class="icon-check"></i><cfelse><i class="icon-check-empty"></i></cfif></div>			
												</td>												
												<td><span class="label label-warning">Advisory</span></td>
												<td>#mtaskname#</td>
												<td>#taskstatus#
												<td><cfif taskcompleteddate is ""><span class="label label-warning">#dateformat( taskduedate, 'mm/dd/yyyy' )#</span><cfelse><span class="label label-success">#dateformat( taskcompleteddate, 'mm/dd/yyyy' )#</span></cfif></td>											
											</tr>
											</cfoutput>
										</tbody>
									</table>						
									<br />
									
									<h5><i class="icon-check"></i> Student Loan Advisor Review</h5>
									
									<!--- // new advisor complete form --->
									<cfoutput>
										<cfif leaddetail.leadadvisorycompdate is "" and leaddetail.leadadvisorycompby is "">
											<form class="form-inline" method="post" action="#cgi.script_name#?event=#url.event#">
												
												<input type="text" name="advisorcompdate" class="input-medium" placeholder="Select Date" id="datepicker-inline4" value="<cfif isdefined( "form.advisorcompdate" )>#dateformat( form.advisorcompdate, 'mm/dd/yyyy' )#</cfif>">
												
												<input type="text" name="advisorcompinitials" style="margin-left:5px;" class="input-medium" placeholder="Enter Initials" value="<cfif isdefined( "form.advisorcompinitials" )>#ucase( form.advisorcompinitials )#</cfif>">
												
												<label class="checkbox">
													<input style="margin-left:5px;" name="chkcertify" type="checkbox"> Certify Advisory Services Completed
												</label>
												
												<button type="submit" style="margin-left:5px;" name="saveintake" class="btn btn-small btn-secondary"><i class="icon-save"></i> Complete Advisory</button>
												
												<p style="margin-top:5px;">By checking Advisory Complete, you hereby certify that all of the student loan advisory loan services have been completed.  The client is ready to begin Implementation, if selected...
												
												<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
												<input name="validate_require" type="hidden" value="leadid|'Lead ID' is a required field.;advisorcompdate|The advisor review completion date is required.  Please try again.;advisorcompinitials|Please enter your initials to complete the advisor review.;chkcertify|Please check the box to certify you have completed the student loan advisory services.">
											</form>
										<cfelse>
											<p style="color:##F00;">The lead advisory services review was completed on #dateformat( leaddetail.leadadvisorycompdate, 'mm/dd/yyyy' )# by #leaddetail.leadadvisorycompby#.</p>
										</cfif>
									</cfoutput>
									
								<cfelse>
	
									
									<cfoutput>
										<div class="alert alert-block alert-notice">
											<a class="close" data-dismiss="alert">&times;</a>
												<h5 style="font-weight:bold;"><i class="icon-warning-sign"></i> NOTICE</h5>
												<p>The advisor review can not be performed because the advisor tasks are incomplete. Please review the client tasks list before reviewing the advusory services task completion</p>
												<p style="margin-top:25px;"><a href="#application.root#?event=page.tasks" class="btn btn-small btn-default"><i class="icon-tasks"></i> View Task List</a></p>
										</div>
									</cfoutput>
									
	
								</cfif>
									
									
								
							</div>
						
						</div>
						
					</div><!-- / .widget -->
					
				</div><!-- / .span12 -->
						
						
			</div><!-- /  .row -->

		</div><!-- / .container -->