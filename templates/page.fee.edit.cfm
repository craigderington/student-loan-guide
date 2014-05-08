

			
			<!--- // get our data access components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.clients.clientgateway" method="getfeedetail" returnvariable="feedetail">
				<cfinvokeargument name="feeid" value="#url.feeid#">
			</cfinvoke>
			
			
			<!--- // a few form params --->
			<cfparam name="feeduedate" default="">
			<cfparam name="feeamount" default="">

			

			<!--- edit fee schedule page --->
			
			
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">						
						
						
							<div class="widget stacked">
								
								<cfoutput>	
									<div class="widget-header">		
										<i class="icon-money"></i>							
										<h3>Edit Fee Record #feedetail.feeuuid# for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
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
											<cfset fee = structnew() />
											<cfset fee.feeid = #form.feeid# />
											<cfset fee.duedate = #form.feeduedate# />
											<cfset fee.amount = #rereplace( form.feeamt, "[\$,]", "", "all" )# />
											
											<!--- // some other variables --->
											<cfset today = #CreateODBCDateTime(now())# />											
											
											<!--- // get the selected fee record --->
											<cfif isvalid( "uuid", fee.feeid )>
												<cfquery datasource="#application.dsn#" name="feeinfo">
													select feeid
													  from fees
													 where feeuuid = <cfqueryparam value="#fee.feeid#" cfsqltype="cf_sql_varchar" maxlength="35" />
												</cfquery>
											
												<!--- // if the fee info record is found, save the new fee details --->
												<cfif feeinfo.recordcount eq 1>
													<cfquery datasource="#application.dsn#" name="savefee">
														update fees
														   set feeduedate = <cfqueryparam value="#fee.duedate#" cfsqltype="cf_sql_date" />,
														       feeamount = <cfqueryparam value="#fee.amount#" cfsqltype="cf_sql_float" />
														 where feeid = <cfqueryparam value="#feeinfo.feeid#" cfsqltype="cf_sql_integer" /> 
													</cfquery>
													
													<!--- // log the activity --->
													<cfquery datasource="#application.dsn#" name="logact">
														insert into activity(leadid, userid, activitydate, activitytype, activity)
															values (
																	<cfqueryparam value="#leaddetail.leadid#" cfsqltype="cf_sql_integer" />,
																	<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																	<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																	<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
																	<cfqueryparam value="#session.username# edited fee record for #leaddetail.leadfirst# #leaddetail.leadlast#." cfsqltype="cf_sql_varchar" />
																	);
													</cfquery>
													
													<cflocation url="#application.root#?event=page.fees&msg=updated" addtoken="no">

												<cfelse>
												
													<!--- // if the fee info recordset is empty, alert the user --->
													<script>
														alert('The fee record can not be updated because the system can not find the selected record.  Please go back and try again.');
														self.location="javascript:history.back(-1);"
													</script>
													
												</cfif>
												
											
											<cfelse>
											
												<!--- // if not a valid uuid, then alert the user --->
												<script>
													alert('Sorry, the fee record you selected to edit has a malformed record ID and can not be modified at this time.  Please go back and try again.');
													self.location="javascript:history.back(-1);"
												</script>
											
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
												
												<div class="tab-pane active" id="editfee">												
													<h3><i class="icon-money"></i> Edit Client Fee Record </h3>										
													<p>To edit the client fee record, please select a new fee due date and new fee amount.</p>												
													<br />
													<br />
													<cfoutput>
														<form id="edit-fee" class="form-horizontal" method="post" action="#application.root#?event=#url.event#&fuseaction=#url.fuseaction#&feeid=#url.feeid#">
															<fieldset>
																
																	<div class="control-group">											
																		<label class="control-label" for="feeduedate">Fee Due Date</label>
																		<div class="controls">
																			<input type="text" class="input-small" id="datepicker-inline2" name="feeduedate" value="#dateformat( feedetail.feeduedate, "mm/dd/yyyy" )#">
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->																															
																	
																	<div class="control-group">											
																		<label class="control-label" for="feeamt">Payment Amount</label>
																		<div class="controls">
																			<input type="text" class="input-small" id="feeamt" name="feeamt" value="#numberformat( feedetail.feeamount, 'L99.99')#">
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->																			
																	
																	<br /><br />
																	
																	<div class="form-actions">													
																		<button type="submit" class="btn btn-secondary" name="savelead"><i class="icon-save"></i> Edit Fee</button>																	
																		<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.fees'"><i class="icon-remove-sign"></i> Cancel</a>													
																		<input name="utf8" type="hidden" value="&##955;">													
																		<input type="hidden" name="feeid" value="#feedetail.feeuuid#" />																	
																		<input type="hidden" name="__authToken" value="#randout#" />
																		<input name="validate_require" type="hidden" value="feeid|Opps, sorry... the form can not be posted due to an internal error.  Please re-load the page and try again.;feeduedate|The fee due date is required to create the fees.;feeamt|Please enter the fee amount to modify this fee record." />																	
																	</div> <!-- /form-actions -->
																</fieldset>
															</form>
														</cfoutput>
												</div>											 
											
											</div> <!-- /.tab-content -->
											
										</div> <!-- /.span8 -->
			
									
					
								</div> <!-- /. widget-content -->
							
							</div> <!-- /. widget-stacked -->
						
						</div><!-- / .span12 -->
					
					</div> <!-- / .row -->
				
				</div> <!-- / .container -->
			
			</div> <!-- / .main -->
		
		
		