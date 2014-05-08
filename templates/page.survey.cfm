
			
			<!--- get our data components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>

			<cfinvoke component="apis.com.clients.surveygateway" method="getsurvey" returnvariable="survey1">
			
			<cfinvoke component="apis.com.clients.clientgateway" method="getclientsurvey" returnvariable="clientsurvey">
				<cfinvokeargument name="leadid" value="#session.leadid#">
				<cfif structkeyexists( url, "step" ) >
					<cfinvokeargument name="step" value="#url.step#">
				<cfelse>
					<cfinvokeargument name="step" value="0">
				</cfif>
			</cfinvoke>
			
			<cfinvoke component="apis.com.clients.surveygateway" method="getQ13" returnvariable="Q13">
			<cfinvoke component="apis.com.clients.surveygateway" method="getQ15" returnvariable="Q15">
			<cfinvoke component="apis.com.clients.surveygateway" method="getQ16" returnvariable="Q16">
			<cfinvoke component="apis.com.clients.surveygateway" method="getQ17" returnvariable="Q17">
			<cfinvoke component="apis.com.clients.surveygateway" method="getQ18" returnvariable="Q18">
			<cfinvoke component="apis.com.clients.surveygateway" method="getQ19" returnvariable="Q19">
			<cfinvoke component="apis.com.clients.surveygateway" method="getQ20" returnvariable="Q20">
			<cfinvoke component="apis.com.clients.surveygateway" method="getQ21" returnvariable="Q21">
			<cfinvoke component="apis.com.clients.surveygateway" method="getQ22" returnvariable="Q22">
			<cfinvoke component="apis.com.clients.surveygateway" method="getQ23" returnvariable="Q23">
			<cfinvoke component="apis.com.clients.surveygateway" method="getQ31" returnvariable="Q31">
			
			
			<!--- // if questionnaire does not exists - create new --->
			<cfif structkeyexists(form, "createquestionnaire") and structkeyexists(form, "leadid") and form.leadid is not "">			
				<cfparam name="leadid" default="">
				<cfset leadid = #form.leadid# />				
				<cfloop query="survey1">
					<cfquery datasource="#application.dsn#" name="createq">
						insert into slanswer(leadid, slqid)
							values (
									<cfqueryparam value="#leadid#" cfsqltype="cf_sql_integer" />,
									<cfqueryparam value="#survey1.slqid#" cfsqltype="cf_sql_integer" />
									);
					</cfquery>
				</cfloop>				
				<cflocation url="#application.root#?event=#url.event#&step=1" addtoken="no">			
			</cfif>
			<!--- // end create questionnaire --->
			
			
			
			<cfparam name="qa" default="">
			<cfparam name="qstep" default="">
			<cfparam name="nstep" default="">
			<cfparam name="slq" default="">
			<cfparam name="slqa" default="">
			
			
			<!--- // client questionnaire and answer page  --->
			
			
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
						
						<cfif structkeyexists( url, "msg" ) and url.msg is "noq">
							<div class="alert alert-error">
								<button type="button" class="close" data-dismiss="alert">&times;</button>
								<strong><i class="icon-warning-sign"></i> ALERT!</strong>&nbsp;  The student loan questionnaire has not yet been fully completed, therefore, the option tree can not be displayed.  Please complete the questionnaire before continuing...
							</div>
						</cfif>
						
							<div class="widget stacked">
									
								<div class="widget-header">		
									<cfoutput>
									<i class="icon-question-sign"></i>							
									<h3>Student Loan Questionnaire for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>
									</cfoutput>
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
											<cfset lead = structnew() />
											<cfset lead.leadid = #form.leadid# />
											<cfset lead.slq = #form.question# />
											<cfset lead.slqa = #form.answer# />
											<cfset lead.qa = #form.rgAn# />
											<cfset lead.qstep = #form.step# />
											
											<cfif lead.qstep lt survey1.recordcount>											
												<cfset nstep = lead.qstep + 1 />
											<cfelseif lead.qstep eq survey1.recordcount>
												<cfset nstep = 0 />
											</cfif>
																					
											<!--- // some other variables --->
											<cfset today = #CreateODBCDateTime(now())# />

											
											<!--- // define vars for job types and rules --->
											<cfif lead.qstep eq 13>
												<cfset lead.ruleid = #form.rule13# />
											<cfelseif lead.qstep eq 15>
												<cfset lead.ruleid = #form.rule15# />
											<cfelseif lead.qstep eq 16>
												<cfset lead.ruleid = #form.rule16# />
											<cfelseif lead.qstep eq 17>
												<cfset lead.ruleid = #form.rule17# />
											<cfelseif lead.qstep eq 18>
												<cfset lead.ruleid = #form.rule18# />
											<cfelseif lead.qstep eq 19>
												<cfset lead.ruleid = #form.rule19# />
											<cfelseif lead.qstep eq 20>
												<cfset lead.ruleid = #form.rule20# />
											<cfelseif lead.qstep eq 21>
												<cfset lead.ruleid = #form.rule21# />
											<cfelseif lead.qstep eq 22>
												<cfset lead.ruleid = #form.rule22# />
											<cfelseif lead.qstep eq 23>
												<cfset lead.ruleid = #form.rule23# />
											<cfelseif lead.qstep eq 31>
												<cfset lead.ruleid = #form.rule31# />
											</cfif>

											
											
											<!--- // update our questionnaire answers table --->
											<cfquery datasource="#application.dsn#" name="markq">
												update slanswer
												   set slqa = <cfqueryparam value="#lead.qa#" cfsqltype="cf_sql_varchar" />
													   <cfif isdefined("lead.ruleid")>
													   , ruleid = <cfqueryparam value="#lead.ruleid#" cfsqltype="cf_sql_integer" />
													   </cfif>
												 where slqaid = <cfqueryparam value="#lead.slqa#" cfsqltype="cf_sql_integer" />  
											</cfquery>
											
											<!--- // log some of the questionnaire activity 
											<cfif ( lead.slq eq 3 ) or ( lead.slq eq 11 ) or ( lead.slq eq 27 )>
												<cfquery datasource="#application.dsn#" name="logact">
													insert into activity(leadid, userid, activitydate, activitytype, activity)
														values (
																<cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="The user worked on the student loan questionnaire for #leaddetail.leadfirst# #leaddetail.leadlast#." cfsqltype="cf_sql_varchar" />
																);
												</cfquery>
											</cfif>										
											--->
											
											<cfif lead.qstep eq 31>
												
												<!--- // task automation // mark task completed --->
												<cfinvoke component="apis.com.tasks.taskautomation" method="marktaskcompleted" returnvariable="taskmsg">
													<cfinvokeargument name="leadid" value="#session.leadid#">
													<cfinvokeargument name="taskref" value="surveycomp">
												</cfinvoke>
												
												<!--- if this is a portal user, update the portal task --->
												<cfif isuserinrole( "bclient" )>																										
													<cfinvoke component="apis.com.portal.portaltaskgateway" method="markportaltaskcompleted" returnvariable="taskstatusmsg">
														<cfinvokeargument name="portaltaskid" value="1415">
														<cfinvokeargument name="leadid" value="#session.leadid#">
													</cfinvoke>
												</cfif>				
											</cfif>
											
											
											<cflocation url="#application.root#?event=#url.event#&step=#nstep#" addtoken="no">
								
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
									
									
									
										<!--- // include the sidebar nav --->
										<div class="span3">					
											<cfinclude template="page.sidebar.nav.cfm">			
										</div> <!-- /.span3 -->
			
			
										<div class="span8">
											
											<div class="tab-content">
												
												<div class="tab-pane active" id="tab1">
													<cfoutput>
													<h3><i class="icon-question-sign"></i> Complete Student Loan Questionnaire <span style="float:right;"><cfif clientsurvey.recordcount neq 0 and not structkeyexists( url, "step" )><a href="#application.root#?event=#url.event#&step=0" class="btn btn-small btn-secondary"><i class="icon-reorder"></i> View Summary</a><cfelseif structkeyexists( url, "step" ) and url.step neq 0><a href="#application.root#?event=#url.event#&step=0" class="btn btn-small btn-secondary"><i class="icon-reorder"></i> View Summary</a><cfelseif structkeyexists( url, "step") and url.step eq 0 ><a href="#application.root#?event=#url.event#" class="btn btn-small btn-secondary"><i class="icon-reorder"></i> Hide Summary</a></cfif></h3>
													</cfoutput>
													
													<cfif not isuserinrole( "bclient" )>
													<p>Please answer the following questions to determine eligibility for many student loan repayment options including forgiveness, deferment, cancellation or rehabilitation.  The answers chose here will be used to complete the student loan option tree in the next few steps of the process.  Try to answer the questionnaire completely without skipping any questions.</p>
													<cfelse>
													<p>Please answer the following questions to help determine the potential eligibility for a variety of student loan relief options.  <strong>An answer must be selected for every question</strong>…if the question does not apply to your situation, select Not Applicable.  </p>
													</cfif>
													<br>
												

												<cfif clientsurvey.recordcount eq 0>
													<cfoutput>
														<form id="create-questionnaire" class="form-horizontal" method="post" action="#application.root#?event=#url.event#">
															<fieldset>
																
																<div class="form">
																<h5 style="font-weight:bold;"><i class="icon-question-sign"></i> Do you want to create the client questionnaire? 
																<br />
																
																<h4><small>Questionnaire Date: #dateformat(now(), "mm/dd/yyyy")#</small></h4>
																	<p>
																		#leaddetail.leadfirst# #leaddetail.leadlast#
																	</p>
																
																<br />													
																											
															</div>											
																
																<br /><br />					
																
																
																<div class="form-actions">													
																	<button type="submit" class="btn btn-secondary" name="createquestionnaire"><i class="icon-save"></i> Create Questionnaire</button>																													
																	<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.summary'"><i class="icon-remove-sign"></i> Cancel</a>													
																	<input name="utf8" type="hidden" value="&##955;">													
																	<input type="hidden" name="__authToken" value="#randout#" />
																	<input type="hidden" name="leadid" value="#session.leadid#" />
																	<input name="validate_require" type="hidden" value="leadid|Sorry, there was an internal error and the form can not be posted.  Please go back and try again..." />														
																</div> <!-- /form-actions -->
															</fieldset>
														</form>
													</cfoutput>
													
												<cfelse>
													
													<cfif not structkeyexists( url, "step" )>
														
														<cfoutput>
															<!--- // allow user to recover a partial completed questionnaire --->
															<form id="continue-questionnaire" class="form-horizontal" method="post">
																<fieldset>
																	
																	<div class="form">
																	<h5 style="font-weight:bold;"><i class="icon-question-sign"></i> Do you want to continue the client student loan questionnaire for #leaddetail.leadfirst# #leaddetail.leadlast#? 
																	<br /><br />
																	
																	<h5 style="color:red;margin-top:10px;"><i class="icon-warning-sign"></i> The questionnaire will re-start at question 1.  You will be able to page through each question...</h4>														
																	
																	<br />													
																												
																</div>											
																	
																	<br /><br />															
																	
																	<div class="form-actions">													
																		<a name="restart" class="btn btn-secondary" onclick="location.href='#application.root#?event=#url.event#&step=1'"><i class="icon-save"></i> Continue Questionnaire</button></a>																													
																		<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.summary'"><i class="icon-remove-sign"></i> Cancel</a>													
																		<input name="utf8" type="hidden" value="&##955;">													
																		<input type="hidden" name="__authToken" value="#randout#" />
																		<input type="hidden" name="leadid" value="#session.leadid#" />																															
																	</div> <!-- /form-actions -->
																</fieldset>
															</form>
														</cfoutput>
														
													<cfelse>													
													
														<cfif structkeyexists( url, "step" ) and url.step is not "" and url.step neq 0 >
															
															<cfparam name="step" default="">
															<cfparam name="nextstep" default="">
															<cfparam name="prevstep" default="">
															<cfparam name="progress" default="">
															<cfset step = #url.step# />
															<cfset nextstep = step + 1 />
															<cfset prevstep = step -1 />
															<cfset progress = ( step / survey1.recordcount ) * 100.00 />
															<cfset progress = numberformat( progress, '99.99' ) />									
															
																
																<cfoutput>
																
																	<div class="progress progress-primary progress-striped active">
																		<div class="bar" style="width: #progress#%"></div> <!-- /.bar -->				
																	</div>
																
																	<br />
																	
																	<form id="questions-answers" class="form-horizontal" method="post" action="#application.root#?event=#url.event#&step=#nextstep#">
																		<fieldset>													
																			
																			<cfif step eq 13>
																				<div class="control-group">		
																					<label class="control-label" for="jobtype">Job Type</label>
																					<div class="controls">
																						<select name="rule13" id="rule13" class="input-large">
																							<option value="0" selected>Select Job Type</option>
																								<cfloop query="Q13">
																									<option value="#jobtypeid#">#jobtypecat# - #jobtype#</option>
																								</cfloop>
																						</select><br />
																						<h6><small>NP: Non-Profit, HNN: High National Need</small> &nbsp; <small><a href="javascript:;" onclick="window.open('templates/page.instructions.cfm##q13defertypes','','scrollbars=yes,location=no,width=821,height=711');">View Help <i class="icon-question-sign"></i></a></small></h6>
																					</div> <!-- // .controls -->
																				</div><!--// .control-group -->																			
																			<cfelseif step eq 15>
																				<div class="control-group">		
																					<label class="control-label" for="jobtype">Perkins Job Type</label>
																					<div class="controls">
																						<select name="rule15" id="rule15" class="input-large">
																							<option value="0" selected>Select Job Type</option>
																								<cfloop query="Q15">
																									<option value="#perkinscancelid#">#perkinscanceljob#</option>
																								</cfloop>
																						</select>																						
																					</div> <!-- // .controls -->
																				</div><!--// .control-group -->
																			<cfelseif step eq 16>
																				<div class="control-group">		
																					<label class="control-label" for="jobtype">Deferment Types</label>
																					<div class="controls">
																						<select name="rule16" id="rule16" class="input-large">
																							<option value="0" selected>Select Defer Type</option>
																								<cfloop query="Q16">
																									<option value="#conditionid#">#condition#</option>
																								</cfloop>
																						</select>
																						<small><a style="margin-left:5px;" href="javascript:;" onclick="window.open('templates/page.instructions.cfm##q16defertypes','','scrollbars=yes,location=no,width=821,height=711');">View Help <i class="icon-question-sign"></i></a></small>
																					</div> <!-- // .controls -->
																				</div><!--// .control-group -->
																			<cfelseif step eq 17>
																				<div class="control-group">		
																					<label class="control-label" for="jobtype">Deferment Types</label>
																					<div class="controls">
																						<select name="rule17" id="rule17" class="input-large">
																							<option value="0" selected>Select Defer Type</option>
																								<cfloop query="Q17">
																									<option value="#conditionid#">#condition#</option>
																								</cfloop>
																						</select>
																						<small><a style="margin-left:5px;" href="javascript:;" onclick="window.open('templates/page.instructions.cfm##q17defertypes','','scrollbars=yes,location=no,width=821,height=711');">View Help <i class="icon-question-sign"></i></a></small>
																					</div> <!-- // .controls -->
																				</div><!--// .control-group -->
																			<cfelseif step eq 18>
																				<div class="control-group">		
																					<label class="control-label" for="jobtype">Deferment Types</label>
																					<div class="controls">
																						<select name="rule18" id="rule18" class="input-large">
																							<option value="0" selected>Select Defer Type</option>
																								<cfloop query="Q18">
																									<option value="#conditionid#">#condition#</option>
																								</cfloop>
																						</select>
																						<small><a style="margin-left:5px;" href="javascript:;" onclick="window.open('templates/page.instructions.cfm##q18defertypes','','scrollbars=yes,location=no,width=821,height=711');">View Help <i class="icon-question-sign"></i></a></small>
																					</div> <!-- // .controls -->
																				</div><!--// .control-group -->
																			<cfelseif step eq 19>
																				<div class="control-group">		
																					<label class="control-label" for="jobtype">Deferment Types</label>
																					<div class="controls">
																						<select name="rule19" id="rule19" class="input-large">
																							<option value="0" selected>Select Defer Type</option>
																								<cfloop query="Q19">
																									<option value="#conditionid#">#condition#</option>
																								</cfloop>
																						</select>
																						<small><a style="margin-left:5px;" href="javascript:;" onclick="window.open('templates/page.instructions.cfm##q19defertypes','','scrollbars=yes,location=no,width=821,height=711');">View Help <i class="icon-question-sign"></i></a></small>
																					</div> <!-- // .controls -->
																				</div><!--// .control-group -->
																			<cfelseif step eq 20>
																				<div class="control-group">		
																					<label class="control-label" for="jobtype">Deferment Types</label>
																					<div class="controls">
																						<select name="rule20" id="rule20" class="input-large">
																							<option value="0" selected>Select Defer Type</option>
																								<cfloop query="Q20">
																									<option value="#defertypeid#">#defertype#</option>
																								</cfloop>
																						</select>
																						<small><a style="margin-left:5px;" href="javascript:;" onclick="window.open('templates/page.instructions.cfm##q20defertypes','','scrollbars=yes,location=no,width=821,height=711');">View Help <i class="icon-question-sign"></i></a></small>
																					</div> <!-- // .controls -->
																				</div><!--// .control-group -->
																			<cfelseif step eq 21>
																				<div class="control-group">		
																					<label class="control-label" for="jobtype">Deferment Types</label>
																					<div class="controls">
																						<select name="rule21" id="rule21" class="input-large">
																							<option value="0" selected>Select Defer Type</option>
																								<cfloop query="Q21">
																									<option value="#defertypeid#">#defertype#</option>
																								</cfloop>
																						</select>
																						<small><a style="margin-left:5px;" href="javascript:;" onclick="window.open('templates/page.instructions.cfm##q21defertypes','','scrollbars=yes,location=no,width=821,height=711');">View Help <i class="icon-question-sign"></i></a></small>
																					</div> <!-- // .controls -->
																				</div><!--// .control-group -->
																			<cfelseif step eq 22>
																				<div class="control-group">		
																					<label class="control-label" for="jobtype">Deferment Types</label>
																					<div class="controls">
																						<select name="rule22" id="rule22" class="input-large">
																							<option value="0" selected>Select Defer Type</option>
																								<cfloop query="Q22">
																									<option value="#defertypeid#">#defertype#</option>
																								</cfloop>
																						</select>
																						<small><a style="margin-left:5px;" href="javascript:;" onclick="window.open('templates/page.instructions.cfm##q22defertypes','','scrollbars=yes,location=no,width=821,height=711');">View Help <i class="icon-question-sign"></i></a></small>
																					</div> <!-- // .controls -->
																				</div><!--// .control-group -->
																			<cfelseif step eq 23>
																				<div class="control-group">		
																					<label class="control-label" for="jobtype">Forbearance Types</label>
																					<div class="controls">
																						<select name="rule23" id="rule23" class="input-large">
																							<option value="0" selected>Select Type</option>
																								<cfloop query="Q23">
																									<option value="#forbearid#">#forbeartype#</option>
																								</cfloop>
																						</select>
																						<small><a style="margin-left:5px;" href="javascript:;" onclick="window.open('templates/page.instructions.cfm##q23defertypes','','scrollbars=yes,location=no,width=821,height=711');">View Help <i class="icon-question-sign"></i></a></small>
																					</div> <!-- // .controls -->
																				</div><!--// .control-group -->
																			<cfelseif step eq 31>
																				<div class="control-group">		
																					<label class="control-label" for="jobtype">Category Types</label>
																					<div class="controls">
																						<select name="rule31" id="rule31" class="input-large">
																							<option value="0" selected>Select Type</option>
																								<cfloop query="Q31">
																									<option value="#forbearcat5id#">#forbearcat5type#</option>
																								</cfloop>
																						</select>
																						<small><a style="margin-left:5px;" href="javascript:;" onclick="window.open('templates/page.instructions.cfm##q31defertypes','','scrollbars=yes,location=no,width=821,height=711');">View Help <i class="icon-question-sign"></i></a></small>
																					</div> <!-- // .controls -->
																				</div><!--// .control-group -->
																			</cfif>
																			
																			<div class="control-group">											
																				<label class="control-label" for="#clientsurvey.slqid#">Question #clientsurvey.slqid#</label>
																				<div class="controls">
																					#clientsurvey.slqtext# <br />
																					<input type="hidden" id="question" name="question" value="#clientsurvey.slqid#" />
																					<input type="hidden" id="answer" name="answer" value="#clientsurvey.slqaid#" />
																					<br />
																					<!--- // show answer form elements --->
																					<label class="radio">
																						<input type="radio" name="rgAn" value="YES"<cfif ( clientsurvey.slqid eq url.step ) and ( clientsurvey.slqa is "yes" )>checked</cfif>>
																						YES
																					</label>
																					<label class="radio">
																						<input type="radio" name="rgAn" value="NO"<cfif ( clientsurvey.slqid eq url.step ) and ( clientsurvey.slqa is "no" )>checked</cfif>>
																						NO
																					</label>
																					<label class="radio">
																						<input type="radio" name="rgAn" value="N/A"<cfif ( clientsurvey.slqid eq url.step ) and ( clientsurvey.slqa is "n/a" )>checked</cfif>>
																						Not Applicable
																					</label>
																				</div> <!-- /controls -->																
																			</div> <!-- /control-group -->															
																			
																			<cfif step eq 4>
																				<a href="javascript:;" class="label label-important" style="margin-left:175px;" onclick="window.open('listclosedschools.cfm','','scrollbars=1, width=720,height=460');">List of Closed Schools</a>
																			<cfelseif step eq 14>
																				<a href="http://www.tcli.ed.gov/CBSWebApp/tcli/TCLIPubSchoolSearch.jsp" target="_blank" class="label label-important" style="margin-left:175px;">Verify Low Income Schools</a>
																			</cfif>
																			
																			<br />					
																			
																			<div class="form-actions">													
																				<cfif step neq 1>
																					<a class="btn btn-tertiary btn-medium" name="prevq" onclick="location.href='#application.root#?event=#url.event#&step=#prevstep#'"><i class="icon-circle-arrow-left"></i> Previous Question</a>																				
																				</cfif>
																				<cfif step neq survey1.recordcount>
																					<button type="submit" class="btn btn-secondary" name="nextq">Next Question <i class="icon-circle-arrow-right"></i></button>																								
																				<cfelse>
																					<button type="submit" class="btn btn-primary" name="completeq"><i class="icon-save"></i> Finish Questionnaire</button>
																				</cfif>
																				<input name="utf8" type="hidden" value="&##955;">													
																				<input type="hidden" name="__authToken" value="#randout#" />
																				<input type="hidden" name="leadid" value="#session.leadid#" />
																				<input type="hidden" name="step" value="#url.step#" />
																				<input name="validate_require" type="hidden" value="rgAn|Please answer the questions by selecting either YES or NO.  Please try again...;answer|Sorry, there was a problem with the form and the questionnaire can not continue.  Please go back to the summary and try again..." />
																			</div> <!-- /form-actions -->
																			
																		</fieldset>
																	</form>
																</cfoutput>
															
														<cfelse>
														
															<table class="table table-bordered table-striped table-highlight">
																<thead>
																	<tr>
																		<th width="7%">Go To</th>
																		<th>Question</th>
																		<th>Answer</th>																		
																	</tr>
																</thead>
																<tbody>
																	<cfoutput query="clientsurvey">
																		<tr>
																			<td class="actions">																		
																				<a href="#application.root#?event=#url.event#&step=#slqid#" class="btn btn-small btn-warning">
																					<i class="btn-icon-only icon-ok"></i>										
																				</a>											
																			</td>																		
																			<td>#slqtext#</td>																			
																			<td><span class="label label-<cfif trim( slqa ) is "yes">success<cfelseif trim( slqa ) is "N/A">default<cfelse>important</cfif>">#slqa#</span></td>
																		</tr>
																	</cfoutput>
																</tbody>
															</table>													
														
													
														</cfif><!--- // end steps or summary --->
														
													</cfif><!--- // end no url step --->
													
												</cfif><!--- // end empty recordset to create questionnaire --->
												
																	
												</div> <!-- /#tab1 -->										 
											
											</div> <!-- /.tab-content -->
											
										</div> <!-- /.span8 -->								
					
								</div> <!-- /. widget-content -->
							
							</div> <!-- /. widget-stacked -->
						
						</div><!-- / .span12 -->
					
					</div> <!-- / .row -->
					<div style="margin-top:100px;"></div>
				</div> <!-- / .container -->
			
			</div> <!-- / .main -->
		
		
		