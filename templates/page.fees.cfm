

			
			<!--- // get our data access components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.clients.clientgateway" method="getclientfees" returnvariable="clientfees">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			
			<!--- // delete selected fee - check query string param --->
			<cfif structkeyexists( url, "fuseaction" ) and url.fuseaction is "deletefee">				
				<cfparam name="feeid" default="">
				<cfparam name="today" default="">
				
				<cfset feeid = #url.feeid# />
				<cfset today = now() />
				<!--- // get the fee record by uuid --->
				<cfquery datasource="#application.dsn#" name="getfeedetail">
					select feeid
					  from fees
					 where feeuuid = <cfqueryparam value="#feeid#" cfsqltype="cf_sql_varchar" maxlength="35" />
				</cfquery>				
				<!--- // check to make sure we have a valid fee record --->
				<cfif getfeedetail.recordcount eq 1 and isvalid( "integer", getfeedetail.feeid )>
					<cfquery datasource="#application.dsn#" name="killfee">
						delete
						  from fees
						 where feeid = <cfqueryparam value="#getfeedetail.feeid#" cfsqltype="cf_sql_integer" />
					</cfquery>
						<!--- // log the user activity --->
						<cfquery datasource="#application.dsn#" name="logact">
							insert into activity(leadid, userid, activitydate, activitytype, activity)
								values (
										<cfqueryparam value="#leaddetail.leadid#" cfsqltype="cf_sql_integer" />,
										<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
										<cfqueryparam value="#createodbcdatetime( today )#" cfsqltype="cf_sql_timestamp" />,
										<cfqueryparam value="Record Deleted" cfsqltype="cf_sql_varchar" />,
										<cfqueryparam value="#session.username# deleted a fee from the client's fee schedule." cfsqltype="cf_sql_varchar" />
										);
						</cfquery>
					<cflocation url="#application.root#?event=#url.event#&msg=deleted" addtoken="no">
				<cfelse>
					<script>
						alert('Sorry, the selected record can not be found.  Operation aborted.');
						self.location="javascript:history.back(-1);"
					</script>
				</cfif>			
			</cfif>
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			

			<!--- define our form vars --->
			<cfparam name="startdate" default="">
			<cfparam name="payamt" default="">
			<cfparam name="paynum" default="">
			<cfparam name="feetotal" default="0.00">

			<!--- lead fee schedule page --->
			
			
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
											<strong><i class="icon-check"></i> SUCCESS!</strong>  The client enrollment fee schedule has been successfully created.  Please use the navigation in the sidebar to continue...
										</div>										
									</div>								
								</div>
							<cfelseif structkeyexists(url, "msg") and url.msg is "deleted">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-success">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong>DELETE SUCCESS!</strong>  The selected fee was successfully deleted from the client's schedule.  Please use the navigation in the sidebar to continue...
										</div>										
									</div>								
								</div>
							<cfelseif structkeyexists(url, "msg") and url.msg is "updated">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-success">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong>SUCCESS!</strong>  The selected fee record was successfully updated in the client's fee schedule.  Please use the navigation in the sidebar to continue...
										</div>										
									</div>								
								</div>
							<cfelseif structkeyexists(url, "msg") and url.msg is "error">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-error">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong>ERROR!</strong>  There was a problem with the selected document record and the operation was aborted.  Please use the navigation in the sidebar to continue...
										</div>										
									</div>								
								</div>
							</cfif>	
						
							<div class="widget stacked">
								
								<cfoutput>	
									<div class="widget-header">		
										<i class="icon-money"></i>							
										<h3>Fee Schedule for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
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
											<cfset lead = structnew() />
											<cfset lead.leadid = #form.leadid# />
											<cfset lead.feeuuid = #createuuid()# />
											<cfset lead.startdate = #form.startdate# />
											<cfset lead.numberpays = #form.paynum# />
											<cfset lead.paymentamount = #form.payamt# />																					
											<cfset lead.nextdate = #lead.startdate# />											
											<cfset lead.paymentamount = rereplace( lead.paymentamount, "[\$,]", "", "all" ) />
											
											<cfif isdefined( "form.rgfeetype" )>
												<cfset lead.feetype = #form.rgfeetype# />
											<cfelse>
												<cfset lead.feetype = 1 />
											</cfif>
											
											<!--- // some other variables --->
											<cfset today = #CreateODBCDateTime(now())# />											
											
											<cfif lead.numberpays lte 10>
												
												<cfloop from="1" to="#lead.numberpays#" index="i">										
													<!--- // create the database records --->
													<cfquery datasource="#application.dsn#" name="dofees">
														insert into fees(feeuuid, leadid, feetype, createddate, feeduedate, feeamount, userid)
															values (
																	<cfqueryparam value="#lead.feeuuid#" cfsqltype="cf_sql_varchar" />,
																	<cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />,
																	<cfqueryparam value="#lead.feetype#" cfsqltype="cf_sql_integer" />,
																	<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																	<cfqueryparam value="#lead.nextdate#" cfsqltype="cf_sql_date" />,
																	<cfqueryparam value="#lead.paymentamount#" cfsqltype="cf_sql_float" />,
																	<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />																
																   );
													</cfquery>
													
													<cfset lead.nextdate = dateadd( "m", 1, lead.nextdate ) />
													<cfset lead.feeuuid = #createuuid()# />
												</cfloop>
												
												<cfif lead.startdate is not "" and lead.numberpays is not "">
													<cfinvoke component="apis.com.tasks.taskautomation" method="marktaskcompleted" returnvariable="taskmsg">
														<cfinvokeargument name="leadid" value="#session.leadid#">
														<cfinvokeargument name="taskref" value="feesch">
													</cfinvoke>
												</cfif>
												
												
												<!--- // log the activity --->
												<cfquery datasource="#application.dsn#" name="logact">
													insert into activity(leadid, userid, activitydate, activitytype, activity)
														values (
																<cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																<cfqueryparam value="Record Added" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="#session.username# created the enrollment fee schedule for #leaddetail.leadfirst# #leaddetail.leadlast#." cfsqltype="cf_sql_varchar" />
																);
												</cfquery>																					
												
												<cfif structkeyexists( form, "savelead" )>
													<cflocation url="#application.root#?event=#url.event#&msg=saved" addtoken="no">
												<cfelseif structkeyexists( form, "saveleadcontinue" )>
													<cflocation url="#application.root#?event=page.enroll.status" addtoken="no">
												<cfelse>
													<cflocation url="#application.root#?event=#url.event#&msg=saved" addtoken="no">
												</cfif>
												
											<cfelse>
											
												<div class="alert alert-error">
													<a class="close" data-dismiss="alert">&times;</a>
														<h5><error>There were errors in your submission:</error></h5>
														<ul>
															<li>Sorry, you can not create more than 10 fees at once...</li>
														</ul>
												</div>
												
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
												
												<div class="tab-pane active" id="tab1">
													<cfoutput>
													<h3><i class="icon-money"></i> Fee Schedule <cfif clientfees.recordcount gt 0><span style="float:right;"><a href="#application.root#?event=page.fees&fuseaction=addfees" class="btn btn-small btn-primary"><i class="icon-money"></i> Add Fees</a></span></cfif></h3>
													</cfoutput>
													<p>The client fee schedule is based on the services the client has chosen to engage.  The initial enrollment fees are paid by the client to engage student loan advisory services.  You can create a secondary fee schedule for student loan implementation services once the advisory services have been completed.  Please refer to the enrollment fee schedule for more information.</p>													
													<br>
													
													
													<cfif clientfees.recordcount gt 0 and not structkeyexists( url, "fuseaction" )>
													
														<table class="table table-bordered table-striped table-highlight">
															<thead>
																<tr>
																	<th width="15%">Actions</th>																	
																	<th>Type</th>
																	<th>Due Date</th>
																	<th>Amount</th>
																	<th>Status</th>
																</tr>
															</thead>
															<tbody>
																<cfoutput query="clientfees">
																<tr>
																	<td class="actions">											
																			
																			<cfif isuserinrole("admin") or isuserinrole("sls") or isuserinrole("co-admin")>
																				<cfif clientfees.feecollected neq 1>
																					<a href="#application.root#?event=page.fee.edit&fuseaction=editfee&feeid=#feeuuid#" class="btn btn-small">
																						<i class="btn-icon-only icon-pencil"></i>										
																					</a>
																					
																					<a href="#application.root#?event=#url.event#&fuseaction=deletefee&feeid=#feeuuid#" class="btn btn-small btn-inverse" onclick="return confirm('Are you sure you want to delete this fee?  This action can not be undone!');">
																						<i class="btn-icon-only icon-trash"></i>										
																					</a>
																				<cfelse>
																					<a href="javascript:;" class="btn btn-small btn-tertiary" rel="popover" data-original-title="Fee Record Information" data-content="Fees that have already been paid and collected can not be modified">
																						<i class="btn-icon-only icon-exclamation-sign"></i>										
																					</a>
																				</cfif>
																			</cfif>
																	</td>
																	<td><cfif feetype eq 1><span class="label label-default">Advisory</span><cfelseif feetype eq 2><span class="label label-info">Implementation</span><cfelseif feetype eq 3><span class="label label-success">Ancillary Fees</span><cfelseif feetype eq 0><span class="label label-info">Returned Item</span><cfelse></cfif></td>
																	<td>#dateformat( feeduedate, "mm/dd/yyyy" )# by <span style="margin-left:5px;" class="label label-info">#feepaytype#</span></td>
																	<td>#dollarformat( feeamount )#</td>																	
																	<td><cfif trim( feestatus ) is "paid"><span class="label label-success">#feestatus# <cfif feepaiddate is not ""> - #dateformat( feepaiddate, "mm/dd/yyyy" )#</cfif></span><cfelseif trim( feestatus ) is "pending"><span class="label label-info">#feestatus# <cfif feetransdate is not ""> - #dateformat( feetransdate, "mm/dd/yyyy" )#</cfif></span><cfelseif trim( feestatus ) is "nsf"><span class="label label-info">#feestatus#<cfelse><span class="label label-default">#feestatus#</span></cfif></td>
																</tr>
																<cfset feetotal = feetotal + feeamount />
																</cfoutput>
																
																<cfoutput>
																	<tr class="alert alert-info">
																		<td colspan="3"><div align="right"><strong>Total Fees</strong></div></td>
																		<td><strong>#dollarformat( feetotal )#</strong></td>
																		<td>&nbsp;</td>
																	</tr>
																</cfoutput>
															</tbody>
														</table>
														<span style="float:right;"><cfoutput><small>The enrollment fee schedule was created on #dateformat(clientfees.createddate, "mm/dd/yyyy")# by #clientfees.firstname# #clientfees.lastname#.</small></cfoutput></span>
													
													
													<cfelse>
														
														<cfoutput>
															<form id="create-fee-schedule" class="form-horizontal" method="post" action="#application.root#?event=page.fees">
																<fieldset>
																
																	<div class="control-group">											
																		<label class="control-label" for="firstname">Start Date</label>
																		<div class="controls">
																			<input type="text" class="input-small" id="datepicker-inline2" name="startdate">
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->																
																	
																	<div class="control-group">											
																		<label class="control-label" for="password1">Number of Payments</label>
																		<div class="controls">
																			<input type="text" class="input-small" id="paynum" name="paynum">
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->															
																	
																	<div class="control-group">											
																		<label class="control-label" for="password2">Payment Amount</label>
																		<div class="controls">
																			<input type="text" class="input-small" id="payamt" name="payamt">
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->																			
																	
																	<cfif leaddetail.leadimp eq 1>
																		<div class="control-group">
																			<label class="control-label" for="rgfeetype">Type</label>
																			<div class="controls">
																				<label class="radio">
																					<input type="radio" name="rgfeetype" value="1" checked>
																					ADVISORY
																				</label>
																				<label class="radio">
																					<input type="radio" name="rgfeetype" value="2">
																					IMPLEMENTATION
																				</label>
																				<label class="radio">
																					<input type="radio" name="rgfeetype" value="3">
																					ANCILLARY FEES
																				</label>
																			</div>
																		</div>
																	</cfif>
																	
																	<br /><br />
																	
																	<div class="form-actions">													
																		<button type="submit" class="btn btn-secondary" name="savelead"><i class="icon-save"></i> Create Fee Schedule</button>																										
																		<button type="submit" class="btn btn-tertiary" name="saveleadcontinue"><i class="icon-refresh"></i> Create Schedule &amp; Continue</button>
																		<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.summary'"><i class="icon-remove-sign"></i> Cancel</a>													
																		<input name="utf8" type="hidden" value="&##955;">													
																		<input type="hidden" name="leadid" value="#leaddetail.leadid#" />																	
																		<input type="hidden" name="__authToken" value="#randout#" />
																		<input name="validate_require" type="hidden" value="leadid|Opps, sorry... the form can not be posted due to an internal error.  Please re-load the page and try again.;startdate|The fee schedule start date is required to create the fees.;payamt|Please enter the fee amount to create the fee schedule.;paynum|The number of payments is required to create the fee schedule." />
																		<input name="validate_numeric" type="hidden" value="paynum|'Number of Payments' must be a numeric value..." />
																	</div> <!-- /form-actions -->
																</fieldset>
															</form>																							
														
														</cfoutput>
														
													</cfif>									
													
													
												</div> <!-- /#tab1 -->										 
											
											</div> <!-- /.tab-content -->
											
										</div> <!-- /.span8 -->
			
									
					
								</div> <!-- /. widget-content -->
							
							</div> <!-- /. widget-stacked -->
						
						</div><!-- / .span12 -->
					
					</div> <!-- / .row -->
					<cfif clientfees.recordcount lt 5>
						<div style="margin-top:150px;"></div>
					<cfelse>
						<div style="margin-top:50px;"></div>
					</cfif>
				</div> <!-- / .container -->
			
			</div> <!-- / .main -->
		
		
		