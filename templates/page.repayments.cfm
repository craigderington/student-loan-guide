

			<!--- get our data components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.leads.leadgateway" method="getleadsummary" returnvariable="leadsummary">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.worksheets.worksheetgateway" method="getworksheets" returnvariable="worksheetlist">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			

			<!--- // student loan repayment page --->		
					
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
						
							<!--- // show system messages --->
							
							<cfif structkeyexists(url, "msg") and url.msg is "saved">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-info">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong><i class="icon-check"></i> SUCCESS!</strong>  The financial information was successfully saved to the client's profile.  Please use the navigation in the sidebar to continue...
										</div>										
									</div>								
								</div>
							<cfelseif structkeyexists(url, "msg") and url.msg is "deleted">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-success">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong><i class="icon-check"></i> SUCCESS!</strong>  The note was successfully deleted from the client's profile.  Please use the navigation in the sidebar to continue...
										</div>										
									</div>								
								</div>
							<cfelseif structkeyexists(url, "msg") and url.msg is "error">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-error">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong><i class="icon-warning-sign"></i> SYSTEM ERROR!</strong>  Sorry, the note could not be deleted due to a system error.  Please use the navigation in the sidebar to continue...
										</div>										
									</div>								
								</div>
							</cfif>	
						
						
							<!--- // begin widget --->
							<div class="widget stacked">
								<cfoutput>
								<div class="widget-header">		
									<i class="icon-retweet"></i>							
									<h3>Student Loan Adjusted Gross Income and Family Size for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
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
											<cfset leadincome = structnew() />
											<cfset leadincome.leadid = #form.leadid# />
											<cfset leadincome.pagi = #rereplace( form.primaryagi, "[\$,]", "", "all" )# />
											<cfset leadincome.sagi = #rereplace( form.secondaryagi, "[\$,]", "", "all" )# />
											<cfset leadincome.spousedebt = rereplace( form.spousedebt, "[\$,]", "", "all" ) />
											<cfset leadincome.filingstatus = #form.filingstatus# />											
											<cfset leadincome.famsize = #form.familysize# />
											<cfif isdefined( "form.mfj" )>
												<cfset leadincome.mfj = "YES" />
											<cfelse>
												<cfset leadincome.mfj = "NO" />
											</cfif>
																						
											<!--- // some other variables --->
											<cfset today = #CreateODBCDateTime(now())# />											
																						
											<!--- // create the database record --->
											<cfquery datasource="#application.dsn#" name="saveincome">
												update slsummary
												   set primaryagi = <cfqueryparam value="#leadincome.pagi#" cfsqltype="cf_sql_float" />,
												       secondaryagi = <cfqueryparam value="#leadincome.sagi#" cfsqltype="cf_sql_float" />,
													   filingstatus = <cfqueryparam value="#leadincome.filingstatus#" cfsqltype="cf_sql_varchar" />,
													   familysize = <cfqueryparam value="#leadincome.famsize#" cfsqltype="cf_sql_numeric" />,
													   mfj = <cfqueryparam value="#leadincome.mfj#" cfsqltype="cf_sql_varchar" />,													   
													   spousedebt = <cfqueryparam value="#leadincome.spousedebt#" cfsqltype="cf_sql_float" />,
													   finsaved = <cfqueryparam value="YES" cfsqltype="cf_sql_varchar" />
												 where leadid = <cfqueryparam value="#leadincome.leadid#" cfsqltype="cf_sql_integer" />													  
											</cfquery>

											<!--- // task automation --->
											<cfinvoke component="apis.com.tasks.taskautomation" method="marktaskcompleted" returnvariable="taskmsg">
												<cfinvokeargument name="leadid" value="#session.leadid#">
												<cfinvokeargument name="taskref" value="agi">
											</cfinvoke>
											
											<!--- // log the activity --->
											<cfquery datasource="#application.dsn#" name="logact">
												insert into activity(leadid, userid, activitydate, activitytype, activity)
													values (
															<cfqueryparam value="#leadincome.leadid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
															<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#session.username# saved the loan calculator's financial details for #leaddetail.leadfirst# #leaddetail.leadlast#." cfsqltype="cf_sql_varchar" />
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
									<!-- // end form processing --->
								
									
									<!--- // include the sidebar navigation --->
									<div class="span3">
										<cfinclude template="page.sidebar.nav.cfm">
									</div>
									
									
									<div class="span8">
										<cfoutput>
										<h3><i class="icon-retweet"></i> Adjusted Gross Income and Family Size <span class="pull-right"><a href="javascript:;" onclick="window.open('templates/page.instructions.cfm##agi','','scrollbars=yes,location=no,status=no,width=821,height=711');"><small>View Help <i class="icon-question-sign"></i></small></a></span></h3>
										</cfoutput>
									
										
											<cfoutput>
											<br />
											<form id="lead-financials" class="form-horizontal" method="post" action="#application.root#?event=page.repayments">
												<fieldset>						
																	
													<!--- // 12-5-2013 // remove - not needed without implementation 
													<div class="control-group">										
														<label class="control-label" for="docdate">Debit Authorization</label>
														<div class="controls">
															<select id="eda" name="eda" class="input-medium">
																<option value="YES"<cfif trim( leadsummary.eda ) is "yes">selected</cfif>>Yes</option>
																<option value="NO"<cfif trim( leadsummary.eda ) is "no">selected</cfif>>No</option>																
															</select>
														</div> <!-- /controls -->				
													</div> <!-- /control-group -->
													--->
													
													<div class="control-group">											
														<label class="control-label" for="docdate">Adjusted Gross Income</label>
														<div class="controls">
															<input type="text" id="primaryagi" name="primaryagi" class="input-small" value="#numberformat( leadsummary.primaryagi, 'L999999.99' )#">															
														</div> <!-- /controls -->				
													</div> <!-- /control-group -->

													<div class="control-group">											
														<label class="control-label" for="docdate">AGI (if married)</label>
														<div class="controls">
															<input type="text" id="secondaryagi" name="secondaryagi" class="input-small" value="#numberformat( leadsummary.secondaryagi, 'L999999.99' )#">															
														</div> <!-- /controls -->				
													</div> <!-- /control-group -->
													
													<div class="control-group">										
														<label class="control-label" for="docdate">Filing Status</label>
														<div class="controls">
															<select id="filingstatus" name="filingstatus" class="input-medium">
																<option value="Single"<cfif trim( leadsummary.filingstatus ) is "single">selected</cfif>>Single</option>
																<option value="Married"<cfif trim( leadsummary.filingstatus ) is "married">selected</cfif>>Married</option>
																<option value="HoH"<cfif trim( leadsummary.filingstatus ) is "hoh">selected</cfif>>Head of Household</option>
															</select>
														</div> <!-- /controls -->				
													</div> <!-- /control-group -->
													
													<div class="control-group">											
														<label class="control-label" for="docdate">Family Size</label>
														<div class="controls">
															<input type="text" id="familysize" name="familysize" class="input-small span1" value="#leadsummary.familysize#">															
														</div> <!-- /controls -->				
													</div> <!-- /control-group -->
													
													<div class="control-group">											
														<label class="control-label" for="docdate">Married Filing Joint</label>
														<div class="controls">
															<input type="checkbox" id="mfj" name="mfj" class="input-small"<cfif trim( leadsummary.mfj ) is "yes">checked</cfif>>															
														</div> <!-- /controls -->				
													</div> <!-- /control-group -->
													
													<div class="control-group">											
														<label class="control-label" for="docdate">Spouse Student Loan Indebtedness</label>
														<div class="controls">
															<input type="text" id="spousedebt" name="spousedebt" class="input-small" value="#numberformat( leadsummary.spousedebt, 'L999999.99' )#">															
														</div> <!-- /controls -->				
													</div> <!-- /control-group -->
																																						
																	
													<br />
													<div class="form-actions">													
														<button type="submit" class="btn btn-secondary" name="savelead"><i class="icon-save"></i> Save Income</button>																										
														<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.repayments'"><i class="icon-remove-sign"></i> Cancel</a>													
														<input name="utf8" type="hidden" value="&##955;">													
														<input type="hidden" name="leadid" value="#leaddetail.leadid#" />																	
														<input type="hidden" name="__authToken" value="#randout#" />
														<input name="validate_require" type="hidden" value="leadid|Opps, sorry... the form can not be posted due to an internal error.  Please re-load the page and try again.;primaryagi|The Primary Agjusted Gross Income can not be blank.;familysize|The family size can not be blank." />															
														</div> <!-- /form-actions -->
												</fieldset>
											</form>
											</cfoutput>
										
										
												
										
										</div><!-- //.span8 -->
									
									<div class="clear"></div>
								</div> <!-- //.widget-content -->	
									
							</div> <!-- //.widget -->
							
						</div> <!-- //.span12 -->
						
					</div> <!-- //.row -->				
				
					<div style="height:100px;"></div>			
				
				</div> <!-- //.container -->
			
			</div> <!-- //.main -->