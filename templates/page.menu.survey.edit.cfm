
		
		
		<cfinvoke component="apis.com.clients.surveygateway" method="getsurveydetail" returnvariable="surveydetail">
			<cfinvokeargument name="slqid" value="#url.surveyid#" >
		</cfinvoke>

		<!--- // menu system data - survey --->
		
		<cfparam name="slqid" default="">
		<cfparam name="slqtext" default="">
		<cfparam name="chkqstat" default="">
		
		<div class="main">	
				
			<div class="container">
					
				<div class="row">
			
					<div class="span12">
							
						<div class="widget stacked">
								
							<div class="widget-header">		
								<i class="icon-copy"></i>							
								<h3>Edit Student Loan Questionnaire</h3>						
							</div> <!-- //.widget-header -->
								
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
											<cfset q = structnew() />
											<cfset q.slqid = #form.slqid# />
											<cfset q.slqtext = #form.slqtext# />
											
											<cfif isdefined("form.chkqstat")>
												<cfset q.stat = 1 />
											<cfelse>
												<cfset q.stat = 0 />
											</cfif>
																				
											<!--- // manipulate some strings for proper case --->																				
											<cfset today = #CreateODBCDateTime(now())# />
											
											<cfquery datasource="#application.dsn#" name="saveq">
												update slquestionnaire												   
												   set slqtext = <cfqueryparam value="#q.slqtext#" cfsqltype="cf_sql_varchar" />,
													   active = <cfqueryparam value="#q.stat#" cfsqltype="cf_sql_bit" />
												 where slqid = <cfqueryparam value="#q.slqid#" cfsqltype="cf_sql_integer" /> 		  
											</cfquery>
											
											<cfquery datasource="#application.dsn#" name="logact">
												insert into activity(leadid, userid, activitydate, activitytype, activity)
													values (
															<cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
															<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#session.username# edited student loan questionnaire question number #q.slqid# in the system." cfsqltype="cf_sql_varchar" />
															);
											</cfquery>

											<cflocation url="#application.root#?event=page.menu.survey&msg=saved" addtoken="no">
										
										
										<!--- If the required data is missing - throw the validation error --->
										<cfelse>
										
											<div class="alert alert-error">
												<a class="close" data-dismiss="alert">&times;</a>
													<h5><error>There were <cfoutput>#objValidation.getErrorCount()#</cfoutput> errors in your submission:</error></h2>
													<ul>
														<cfloop collection="#variables.objValidation.getMessages()#" item="rr">
															<li class="formerror"><cfoutput>#variables.objValidation.getMessage(rr)#"</cfoutput></li>
														</cfloop>
													</ul>
											</div>
								
										</cfif>
									</cfif>
									
									<!--- // end form processing --->
									
									<div class="tab-pane active" id="q">
										<cfoutput>	
										<form id="editquestion-profile" class="form-horizontal" method="post" action="#cgi.script_name#?event=#url.event#&surveyid=#surveydetail.slqid#">
											<fieldset>									
												<br />						
												
												
												<div class="control-group">											
													<label class="control-label" for="slqnum">Question Number</label>
													<div class="controls">
														<input type="text" class="input-small disabled" id="slqnum" name="slqnum" value="#surveydetail.slqid#" disabled >
													</div> <!-- /controls -->				
												</div> <!-- /control-group -->
													
													
												<div class="control-group">											
													<label class="control-label" for="slqtext">Question Text</label>
													<div class="controls">
														<textarea name="slqtext" id="slqtext" class="input-large span8" rows="8">#surveydetail.slqtext#</textarea> 
													</div> <!-- /controls -->				
												</div> <!-- /control-group -->

												<div class="control-group">											
													<label class="control-label" for="chkqstat">Question Status</label>
													<div class="controls">
														<input type="checkbox" name="chkqstat" value="1"<cfif surveydetail.active eq 1>checked</cfif>> 
													</div> <!-- /controls -->				
												</div> <!-- /control-group -->
																			
													
												<br />												
														
												<div class="form-actions">													
													<button type="submit" class="btn btn-secondary" name="saveq"><i class="icon-save"></i> Save Question</button>																										
													<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.menu.survey'"><i class="icon-remove-sign"></i> Cancel</a>													
													<input name="utf8" type="hidden" value="&##955;">
													<input name="slqid" id="slqid" type="hidden" value="#surveydetail.slqid#" />
													<input type="hidden" name="__authToken" value="#randout#" />
													<input name="validate_require" type="hidden" value="slqtext|You must enter some text to save the question.  The question text is a required field." />								
												</div> <!-- /form-actions -->
											</fieldset>
										</form>
										</cfoutput>
									</div>
								

								<div class="clear"></div>
							</div> <!-- //.widget-content -->	
									
						</div> <!-- //.widget -->
							
					</div> <!-- //.span12 -->
						
				</div> <!-- //.row -->			
				
				
				<div style="height:300px;"></div>			
				
			</div> <!-- //.container -->
			
		</div> <!-- //.main -->