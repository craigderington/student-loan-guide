
			
			
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
			
			<!--- declare forms vars --->			
			<cfparam name="enrolldate" default="">
			<cfparam name="enrolldocsendmethod" default="">
			<cfparam name="enrolldocreturndate" default="">
			<cfparam name="enrolldocuploaddate" default="">			
			<cfparam name="enrolldocsubmitdate" default="">
			
			<!--- lead summary page --->
			
			
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
						
						<!--- show system messages --->
						<cfif structkeyexists(url, "msg") and url.msg is "saved">						
							<div class="row">
								<div class="span12">										
									<div class="alert alert-info">
										<button type="button" class="close" data-dismiss="alert">&times;</button>
										<strong><i class="icon-check"></i> SUCCESS!</strong>  The implementation enrollment status dates and settings were successfully updated.  Please use the navigation in the sidebar to continue...
									</div>										
								</div>								
							</div>							
						</cfif>
						<!--- // end system messages --->
						
							<div class="widget stacked">
								<cfoutput>	
								<div class="widget-header">		
									<i class="icon-user"></i>							
									<h3>Implementation Enrollment Status for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
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
											<cfset lead.enrolldate = #form.implenrolldate# />											
											<cfset lead.docsdate = #form.implenrolldocsubmitdate# />
											<cfset lead.docsmethod = #form.implenrolldocsendmethod# />
											<cfset lead.returndate = #form.implenrolldocreturndate# />
											<cfset lead.uploaddate = #form.implenrolldocuploaddate# />								
											
											<!--- // some other variables --->
											<cfset today = #CreateODBCDateTime(now())# />																					
											
											<cfquery datasource="#application.dsn#" name="summary">
													update slsummary
													   set implenrolldate = <cfqueryparam value="#lead.enrolldate#" cfsqltype="cf_sql_date" />,														   
														   implenrolldocsubmitdate = <cfqueryparam value="#lead.docsdate#" cfsqltype="cf_sql_date" />,
														   implenrolldocreturndate = <cfqueryparam value="#lead.returndate#" cfsqltype="cf_sql_date" />,
														   implenrolldocuploaddate = <cfqueryparam value="#lead.uploaddate#" cfsqltype="cf_sql_date" />,
														   implenrolldocsendmethod = <cfqueryparam value="#lead.docsmethod#" cfsqltype="cf_sql_varchar" />
													 where summaryid = <cfqueryparam value="#lead.summaryid#" cfsqltype="cf_sql_integer" />
											</cfquery>
											
											
											<!--- // do task automation 
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
											--->

																				
											
												<!--- // log the client activity --->
												<cfquery datasource="#application.dsn#" name="logact">
													insert into activity(leadid, userid, activitydate, activitytype, activity)
														values (
																<cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="#session.username# updated the implementation enrollment details for #leaddetail.leadfirst# #leaddetail.leadlast#." cfsqltype="cf_sql_varchar" />
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
											<cfinclude template="page.implement.nav.cfm">		
										</div> <!-- /.span3 -->
			
			
										<div class="span8">
											
											<div class="tab-content">
												<cfoutput>
												<div class="tab-pane active" id="tab1">
													
													<h3><i class="icon-cogs"></i> Implementation Enrollment Status</h3>
													
													<p>This section is used to track the progression throughout the implementation enrollment process.  You should complete the fields below to document date and times when documents are sent to and received from the client.</p>
													
													<br>
													
													<form id="edit-enrollment" class="form-horizontal" method="post" action="#application.root#?event=#url.event#" style="margin-left;10px;">
														<fieldset>				
															
															<div class="control-group">											
																<label class="control-label" for="implenrolldate">Enrollment Date</label>
																<div class="controls">
																	<input type="text" class="input-small" name="implenrolldate" id="datepicker-inline3" value="<cfif isdefined( "form.implenrolldate" )>#dateformat( form.implenrolldate, "mm/dd/yyyy" )#<cfelse>#dateformat( leadsummary.implenrolldate, "mm/dd/yyyy" )#</cfif>" />
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->

															<div class="control-group">											
																<label class="control-label" for="Contact Method">Enrollment Documents Send Method</label>
																<div class="controls">
																	<select name="implenrolldocsendmethod" id="docsmethod" class="input-large">
																		<option value="">Select Send Method</option>
																		<option value="Email"<cfif trim(leadsummary.implenrolldocsendmethod) is "email">selected</cfif>>Email</option>
																		<option value="Fax"<cfif trim(leadsummary.implenrolldocsendmethod) is "fax">selected</cfif>>Fax</option>
																		<option value="In Person"<cfif trim(leadsummary.implenrolldocsendmethod) is "In Person">selected</cfif>>In Person</option>
																		<option value="Post"<cfif trim(leadsummary.implenrolldocsendmethod) is "Post">selected</cfif>>Post</option>
																		<option value="ESIGN"<cfif trim(leadsummary.implenrolldocsendmethod) is "ESIGN">selected</cfif>>E-Sign Invitation</option>
																	</select>
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->
															
															<div class="control-group">											
																<label class="control-label" for="enrolldocs">Enrollment Docs Submitted Date</label>
																<div class="controls">
																	<input type="text" class="input-small" name="implenrolldocsubmitdate" id="datepicker-inline4" value="<cfif isdefined( "form.implenrolldocsubmitdate" )>#dateformat( form.implenrolldocsubmitdate, 'mm/dd/yyyy' )#<cfelse>#dateformat( leadsummary.implenrolldocsubmitdate, 'mm/dd/yyyy' )#</cfif>" />
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->
															
															<div class="control-group">											
																<label class="control-label" for="returndate">Enrollment Docs Return Date</label>
																<div class="controls">
																	<input type="text" class="input-small" name="implenrolldocreturndate" id="datepicker-inline5" value="<cfif isdefined( "form.implenrolldocreturndate" )>#dateformat( form.implenrolldocreturndate, 'mm/dd/yyyy' )#<cfelse>#dateformat( leadsummary.implenrolldocreturndate, 'mm/dd/yyyy' )#</cfif>" />
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->

															<div class="control-group">											
																<label class="control-label" for="uploaddate">Document Upload Date</label>
																<div class="controls">
																	<input type="text" class="input-small" name="implenrolldocuploaddate" id="datepicker-inline6" value="<cfif isdefined( "form.implenrolldocuploaddate" )>#dateformat( form.implenrolldocuploaddate, 'mm/dd/yyyy' )#<cfelse>#dateformat( leadsummary.implenrolldocuploaddate, 'mm/dd/yyyy' )#</cfif>" /> 
																	<!---<p class="help-block" style="color:##ff0000;"><i class="icon-file"></i>  Documents e-signed on </p>--->
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->													
															
															
															<!--- // form action --->
															<br />
															<div class="form-actions">													
																<button type="submit" class="btn btn-secondary" name="saveimplementationenrollment"><i class="icon-save"></i> Save Implementation Status</button>							
																<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.summary'"><i class="icon-remove-sign"></i> Cancel</a>													
																<input name="utf8" type="hidden" value="&##955;">													
																<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
																<input type="hidden" name="leadsummaryid" value="#leadsummary.summaryid#" />
																<input type="hidden" name="__authToken" value="#randout#" />
																<input name="validate_require" type="hidden" value="leadid|'Lead ID' is a required field.;leadsummaryid|Opps, there was a problem and the form could not be posted.  Please check your data and try again.;implenrolldate|Please set the client program enrollment date.;implenrolldocsendmethod|Please select the method you used to send the enrollment document to the client." />															
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
		
		
		