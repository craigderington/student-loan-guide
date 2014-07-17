
			
			
			<!--- // call our data access components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#" >
			</cfinvoke>
			
			<cfinvoke component="apis.com.leads.leadgateway" method="getleadsummary" returnvariable="leadsummary">
				<cfinvokeargument name="leadid" value="#session.leadid#" >
			</cfinvoke>

			<cfinvoke component="apis.com.esign.esigngateway" method="getesigninfo" returnvariable="esigninfo">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.clients.clientgateway" method="getclientfeetotals" returnvariable="clientfeetotals">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>							
			
			<!--- declare forms vars --->			
			<cfparam name="enrolldate" default="">
			<cfparam name="enrolldocs" default="">
			<cfparam name="enrolldocsreturndate" default="">
			<cfparam name="enrolldocsuploaddate" default="">
			<cfparam name="slsassigndate" default="">
			<cfparam name="slscontactdate" default="">
			<cfparam name="enrolldocsclientmethod" default="">
			
			<!--- lead summary page --->
			
			
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
						
						<!--- show system messages --->
						<cfif structkeyexists( url, "msg" ) and url.msg is "saved">						
							<div class="row">
								<div class="span12">										
									<div class="alert alert-info">
										<button type="button" class="close" data-dismiss="alert">&times;</button>
										<strong><i class="icon-check"></i> SUCCESS!</strong>  The client program enrollment status dates and settings were successfully updated.  Please use the navigation in the sidebar to continue...
									</div>										
								</div>								
							</div>
						<cfelseif structkeyexists( url, "msg" ) and url.msg is "email" and structkeyexists( url, "status" ) and url.status is "sent">						
							<div class="row">
								<div class="span12">										
									<div class="alert alert-block alert-info">
										<button type="button" class="close" data-dismiss="alert">&times;</button>
										<strong><i class="icon-check"></i> SUCCESS!</strong> The program enrollment documents were successfully sent to the client by email... 
											<ul><cfoutput>
													<li> The client program enrollment document was successfully sent to the client as an attachment. </li>
													<li> The client agreement was also saved to the document library. Access the new enrollment document here.  <a title="Print Client Enrollment Document" name="thisdoc" target="_blank" href="../library/clients/enrollment/#leaddetail.leadfirst#-#leaddetail.leadlast#-#leaddetail.leadid#-Student-Loan-Advisor-Agreement.pdf">View New Enrollment Document</a></li>
												</cfoutput>
											</ul>
									</div>										
								</div>								
							</div>
						</cfif>
						<!--- // end system messages --->
						
							<div class="widget stacked">
								<cfoutput>	
								<div class="widget-header">		
									<i class="icon-user"></i>							
									<h3>Enrollment Status for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
								</div> <!-- //.widget-header -->
								</cfoutput>	
							
								<div class="widget-content">
								
										<!--- // form processing --->
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
											<cfset lead.enrolldate = #form.enrolldate# />											
											<cfset lead.docsdate = #form.enrolldocsdate# />
											<cfset lead.docsmethod = #form.docsmethod# />
											<cfset lead.returndate = #form.enrolldocsreturndate# />
											<cfset lead.uploaddate = #form.enrolldocsuploaddate# />								
											
											<!--- // some other variables --->
											<cfset today = #CreateODBCDateTime(now())# />																					
											
											<cfquery datasource="#application.dsn#" name="summary">
													update slsummary
													   set slenrolldate = <cfqueryparam value="#lead.enrolldate#" cfsqltype="cf_sql_date" />,														   
														   slenrollclientdocsdate = <cfqueryparam value="#lead.docsdate#" cfsqltype="cf_sql_date" />,
														   slenrollreturndate = <cfqueryparam value="#lead.returndate#" cfsqltype="cf_sql_date" />,
														   slenrolldocsuploaddate = <cfqueryparam value="#lead.uploaddate#" cfsqltype="cf_sql_date" />,
														   slenrollclientdocsmethod = <cfqueryparam value="#lead.docsmethod#" cfsqltype="cf_sql_varchar" />
													 where summaryid = <cfqueryparam value="#lead.summaryid#" cfsqltype="cf_sql_integer" />
											</cfquery>
											
											
											<!--- // do task automation --->
											<cfif lead.docsdate is not "">
												<cfinvoke component="apis.com.tasks.taskautomation" method="marktaskcompleted" returnvariable="taskmsg">
													<cfinvokeargument name="leadid" value="#session.leadid#">
													<cfinvokeargument name="taskref" value="enrolldocs">
												</cfinvoke>
											</cfif>
											
											<cfif lead.returndate is not "" and lead.uploaddate is not "">
												<cfinvoke component="apis.com.tasks.taskautomation" method="marktaskcompleted" returnvariable="taskmsg">
													<cfinvokeargument name="leadid" value="#session.leadid#">
													<cfinvokeargument name="taskref" value="signeddocs">
												</cfinvoke>
											</cfif>
											

											<!--- // if the enrollment docs upload date is a valid date, then set the lead converted flag to true --->
											<cfif lead.uploaddate is not "" and lead.returndate is not "">											
												
													<!--- // convert the lead and show all menu items --->
													<cfquery datasource="#application.dsn#" name="convertlead">
														update leads
														   set leadconv = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
														 where leadid = <cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />
													</cfquery>											
													
													<!--- // assign the intake advisor --->
													<cfif isvalid( "date", lead.uploaddate ) and lead.uploaddate is not "">													
														<cfinvoke component="apis.com.tasks.taskautomation" method="marktaskcompleted" returnvariable="taskmsg">
															<cfinvokeargument name="leadid" value="#session.leadid#">
															<cfinvokeargument name="taskref" value="intnot">
														</cfinvoke>													
														<cfinvoke component="apis.com.clients.assigngateway" method="assignintake">
															<cfinvokeargument name="companyid" value="#session.companyid#">
															<cfinvokeargument name="leadid" value="#session.leadid#">
														</cfinvoke>
													</cfif>
													
													<!--- // start the lead converted session to begin adding sl worksheets --->
													<cfset session.leadconv = 1 />												
											
											<cfelse>
											
												<!--- // leave the client flagged as not converted --->
												<cfquery datasource="#application.dsn#" name="convertlead">
													update leads
													   set leadconv = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />
													 where leadid = <cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />
												</cfquery>
												
												<!--- // start the lead converted session to begin adding sl worksheets --->
												<cfset session.leadconv = 0 />
											
											</cfif>										
											
												<!--- // log the client activity --->
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
													<cflocation url="#application.root#?event=page.docs" addtoken="no">
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
													
													<h3><i class="icon-bar-chart"></i> Enrollment Status <span style="float:right;font-size:16px;">Entered: #dateformat(leaddetail.leaddate, "mm/dd/yyyy")#</span></h3>
													
													<p>This section is used to track the progression throughout the enrollment process.  You should complete the fields below to document date and times when documents are sent to and received from the client.  Once the client has been enrolled, the status will change to enrolled and you can begin working on the advisory services.</p>
													
													<br>
													
													<form id="edit-enrollment" class="form-horizontal" method="post" action="#application.root#?event=#url.event#" style="margin-left;10px;">
														<fieldset>				
															
															<div class="control-group">											
																<label class="control-label" for="enrolldate">Enrollment Date</label>
																<div class="controls">
																	<input type="text" class="input-small" name="enrolldate" id="datepicker-inline3" value="<cfif isdefined( "form.enrolldate" )>#dateformat( form.enrolldate, "mm/dd/yyyy" )#<cfelse>#dateformat(leadsummary.slenrolldate, 'mm/dd/yyyy')#</cfif>" />
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->

															<div class="control-group">											
																<label class="control-label" for="Contact Method">Send Method</label>
																<div class="controls">
																	<select name="docsmethod" id="docsmethod" class="input-medium">
																		<option value="">Select Send Method</option>
																		<option value="Email"<cfif trim( leadsummary.slenrollclientdocsmethod ) is "email">selected</cfif>>Email</option>
																		<option value="Fax"<cfif trim( leadsummary.slenrollclientdocsmethod ) is "fax">selected</cfif>>Fax</option>
																		<option value="In Person"<cfif trim( leadsummary.slenrollclientdocsmethod ) is "In Person">selected</cfif>>In Person</option>
																		<option value="Post"<cfif trim( leadsummary.slenrollclientdocsmethod ) is "Post">selected</cfif>>Post</option>
																		<option value="ESIGN"<cfif trim( leadsummary.slenrollclientdocsmethod ) is "ESIGN">selected</cfif>>E-Sign Invitation</option>
																	</select>&nbsp;
																	
																	
																	<!--- // 7-9-2014 // need to be able to print enrollment agreements for clients not signing electronically --->
																	<!--- // only show links if the documents have not been returned, once returned, hide buttons --->
																	<!--- // 7-15-2014 // alert user if the client has no fee schedule --->
																	<cfif leadsummary.slenrollreturndate is "">
																		
																		<cfif trim( leadsummary.slenrollclientdocsmethod ) is "email">
																			
																			<!--- // if not client fees have been created, redirect and alert user --->
																			<cfif clientfeetotals.numpayments eq 0>
																				<a href="javascript:;" class="btn btn-small btn-default" onclick="javascript:alert('Sorry, you can not generate the enrollment agreement because the selected client does not have a valid fee schedule.');"><i class="icon-envelope"></i> Send Enrollment Documents by Email</a>
																			<cfelse>
																				<a href="#application.root#?event=page.enroll.docs&fuseaction=email&do=enrolldocs" class="btn btn-small btn-default"><i class="icon-envelope"></i> Send Enrollment Documents by Email</a>
																			</cfif>
																		
																		<cfelseif trim( leadsummary.slenrollclientdocsmethod ) is "fax">
																			
																			<cfif clientfeetotals.numpayments eq 0>
																				<a href="javascript:;" class="btn btn-small btn-default" onclick="javascript:alert('Sorry, you can not generate the enrollment agreement because the selected client does not have a valid fee schedule.');"><i class="icon-print"></i> Print Enrollment Documents</a>
																			<cfelse>
																				<a href="#application.root#?event=page.enroll.docs&fuseaction=print&do=enrolldocs" class="btn btn-small btn-default"><i class="icon-print"></i> Print Enrollment Documents</a>
																			</cfif>
																			
																		<cfelseif trim( leadsummary.slenrollclientdocsmethod ) is "post">
																			
																			<cfif clientfeetotals.numpayments eq 0>
																				<a href="javascript:;" class="btn btn-small btn-default" onclick="javascript:alert('Sorry, you can not generate the enrollment agreement because the selected client does not have a valid fee schedule.');"><i class="icon-truck"></i> Print Enrollment Documents</a>
																			<cfelse>
																				<a href="#application.root#?event=page.enroll.docs&fuseaction=print&do=enrolldocs" class="btn btn-small btn-default"><i class="icon-truck"></i> Print Enrollment Documents</a>
																			</cfif>
																			
																		<cfelseif trim( leadsummary.slenrollclientdocsmethod ) is "in person">
																			
																			<cfif clientfeetotals.numpayments eq 0>
																				<a href="javascript:;" class="btn btn-small btn-default" onclick="javascript:alert('Sorry, you can not generate the enrollment agreement because the selected client does not have a valid fee schedule.');"><i class="icon-user"></i> Print Enrollment Documents</a>
																			<cfelse>
																				<a href="#application.root#?event=page.enroll.docs&fuseaction=print&do=enrolldocs" class="btn btn-small btn-default"><i class="icon-user"></i> Print Enrollment Documents</a>
																			</cfif>
																		
																		</cfif>
																	</cfif>
																	
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->
															
															<div class="control-group">											
																<label class="control-label" for="enrolldocs">Enrollment Docs Submitted Date</label>
																<div class="controls">
																	<input type="text" class="input-small" name="enrolldocsdate" id="datepicker-inline4" value="<cfif isdefined( "form.enrolldocsdate" )>#dateformat( form.enrolldocsdate, 'mm/dd/yyyy' )#<cfelse>#dateformat(leadsummary.slenrollclientdocsdate, 'mm/dd/yyyy')#</cfif>" />
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->
															
															<div class="control-group">											
																<label class="control-label" for="returndate">Enrollment Docs Return Date</label>
																<div class="controls">
																	<input type="text" class="input-small" name="enrolldocsreturndate" id="datepicker-inline5" value="<cfif isdefined( "form.enrolldocsreturndate" )>#dateformat( form.enrolldocsreturndate, 'mm/dd/yyyy' )#<cfelse>#dateformat(leadsummary.slenrollreturndate, 'mm/dd/yyyy')#</cfif>" />
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->

															<div class="control-group">											
																<label class="control-label" for="uploaddate">Document Upload Date</label>
																<div class="controls">
																	<input type="text" class="input-small" name="enrolldocsuploaddate" id="datepicker-inline6" value="<cfif isdefined( "form.enrolldocsuploaddate" )>#dateformat( form.enrolldocsuploaddate, 'mm/dd/yyyy' )#<cfelse>#dateformat(leadsummary.slenrolldocsuploaddate, 'mm/dd/yyyy')#</cfif>" /> 
																	<cfif leaddetail.leadesign eq 1><p class="help-block" style="color:##ff0000;"><i class="icon-file"></i>  Documents e-signed on #dateformat( esigninfo.esdatestamp, "mm/dd/yyyy" )# by #esigninfo.esconfirminitials#</p></cfif>
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->													
															
															<!---
															<div class="control-group">											
																<label class="control-label" for="slsassigndate">SLS Assign Date</label>
																<div class="controls">
																	<input type="text" class="input-small" name="slsassigndate" id="sls-assign-date-inline" value="" />
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->
															
															<div class="control-group">											
																<label class="control-label" for="uploaddate">SLS Contact Date</label>
																<div class="controls">
																	<input type="text" class="input-small" name="slscontactdatedate" id="sls-contact-date-inline" value="" />
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->											
															--->
															<!--- // form action --->
															<br />
															<div class="form-actions">													
																<button type="submit" class="btn btn-secondary" name="savelead"><i class="icon-save"></i> Save Enrollment Status</button>																										
																<button type="submit" class="btn btn-tertiary" name="saveleadcontinue"><i class="icon-refresh"></i> Save Status &amp; Continue</button>
																<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.summary'"><i class="icon-remove-sign"></i> Cancel</a>													
																<input name="utf8" type="hidden" value="&##955;">													
																<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
																<input type="hidden" name="leadsummaryid" value="#leadsummary.summaryid#" />
																<input type="hidden" name="__authToken" value="#randout#" />
																<input name="validate_require" type="hidden" value="leadid|'Lead ID' is a required field.;leadsummaryid|Opps, there was a problem and the form could not be posted.  Please check your data and try again.;enrolldate|Please set the client program enrollment date.;docsmethod|Please select the method you used to send the enrollment document to the client." />															
															</div> <!-- /form-actions -->														
															
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
		
		
		