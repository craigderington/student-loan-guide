

			
			<!--- get our data components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>				
			
			<cfinvoke component="apis.com.worksheets.worksheetgateway" method="getworksheet" returnvariable="worksheet">
				<cfinvokeargument name="worksheet" value="#url.worksheetid#">
			</cfinvoke>			
			
				
			
			<!-- // define our form vars --->
			
			<cfparam name="worksheetid" default="">
			<cfparam name="slname" default="">
			

			<!--- student loan debt worksheet page --->
			
			
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
						
							<div class="widget stacked">
								<cfoutput>	
								<div class="widget-header">		
									<i class="icon-refresh"></i>							
									<h3>Delete Student Loan Debt Worksheet for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
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
											<cfset debt.worksheetid = #form.worksheetid# />										
																						
											<!--- // some other variables --->
											<cfset today = #CreateODBCDateTime(now())# />											
																						
											<!--- // create the database record --->
											<cfquery datasource="#application.dsn#" name="killworksheet">
												delete 
												  from slworksheet												   														
												 where worksheetid = <cfqueryparam value="#debt.worksheetid#" cfsqltype="cf_sql_integer" />
											</cfquery>											
											
											<!--- // log the activity --->
											<cfquery datasource="#application.dsn#" name="logact">
												insert into activity(leadid, userid, activitydate, activitytype, activity)
													values (
															<cfqueryparam value="#debt.leadid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
															<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#session.username# deleted student loan debt worksheet ID #debt.worksheetid# for #debt.name#." cfsqltype="cf_sql_varchar" />
															);
											</cfquery>																					
											
											<cflocation url="#application.root#?event=page.worksheet&msg=deleted" addtoken="no">
								
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
													
													<h3><i class="icon-trash"></i> Delete Student Loan Debt Worksheet</h3>												
													
													<p>Please use the form below to delete the selected student loan debt worksheet.  Special note, once you have deleted the debt worksheet, you can not un-do the action...</p>												
																																							
													<cfoutput>													
													
													<br />
														<form id="kill-debt-worksheet" class="form-horizontal" method="post" action="#application.root#?event=#url.event#&worksheetid=#worksheet.worksheetuuid#">
															<fieldset>													
																<div class="form">
																	<h5 style="font-weight:bold;">Are you absolutley sure you want to delete this student loan debt worksheet?  
																	<br />
																	
																	<h4><small>ID: #worksheet.worksheetuuid#</small></h4>																	
																	
																	<br />
																	
																	<h5 style="font-weight:bold;color:red;"><i class="icon-warning-sign"></i> This action can not be undone...</h5>												
																</div>											
															
																<br /><br />
																
																
																<div class="form-actions">																
																	<button type="submit" class="btn btn-secondary" name="deletedebt"><i class="icon-trash"></i> Delete Worksheet</button>
																	<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.worksheet'"><i class="icon-remove-sign"></i> Cancel</a>													
																	<input name="utf8" type="hidden" value="&##955;">													
																	<input type="hidden" name="leadid" value="#leaddetail.leadid#" />																	
																	<input type="hidden" name="__authToken" value="#randout#" />
																	<input type="hidden" name="worksheetid" value="#worksheet.worksheetid#" />
																	<input type="hidden" name="slname" value="#leaddetail.leadfirst# #leaddetail.leadlast#" />
																	<input name="validate_require" type="hidden" value="worksheetid|Sorry... the form can not be posted due to an internal error.  Please go back and try again..." />															
																	
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