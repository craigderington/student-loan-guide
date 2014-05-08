
			
			
			<!--- get our data components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>					
			
			<cfinvoke component="apis.com.tasks.taskgateway" method="gettask" returnvariable="taskdetail">
				<cfinvokeargument name="taskid" value="#url.taskid#">
			</cfinvoke>		
			
			
			<!--- // define form vars --->
			<cfparam name="taskname" default="">
			<cfparam name="taskduedate" default="">
			<cfparam name="tasknote" default="">
			<cfparam name="taskstatus" default="">
			

			<!--- // student loan edit task detail page --->		
					
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">			
						
							<div class="widget stacked">
								
								<div class="widget-header">		
									<cfoutput>
									<i class="icon-tasks"></i>							
									<h3>Edit Student Loan Task: #taskdetail.mtaskname# for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>
									</cfoutput>
								</div> <!-- //.widget-header -->
								
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
											<cfset task = structnew() />
											<cfset task.leadid = #form.leadid# />
											<cfset task.taskid = #form.taskid# />
											<cfset task.taskuuid = #createuuid()# />
											<cfset task.taskduedate = #form.taskduedate# />
											<cfset task.taskname = #form.taskname# />
											<cfset task.taskstatus = #form.taskstatus# />
											<cfset task.tasknote = #urlencodedformat( form.tasknote )# />
																						
											<!--- // some other variables --->
											<cfset today = #CreateODBCDateTime(now())# />	
											<cfset task.tasklastupdate = #today# />
											<cfset task.tasklastupdateby = #session.username# />
											
											<!--- // check the task status --->
											<cfif trim( task.taskstatus ) is "completed">
												<cfset task.taskcompdate = #today# />
												<cfset task.taskcompby = #session.username# />
											</cfif>

											<cfquery datasource="#application.dsn#" name="chktaskstat">
												select taskid, taskstatus
												  from tasks
												 where taskid = <cfqueryparam value="#task.taskid#" cfsqltype="cf_sql_integer" />
											</cfquery>
																															
											<!--- // update the task record --->
											<cfquery datasource="#application.dsn#" name="savetaskdetail">
													update tasks
													   set taskuuid = <cfqueryparam value="#task.taskuuid#" cfsqltype="cf_sql_varchar" maxlength="35" />,
														   taskname = <cfqueryparam value="#task.taskname#" cfsqltype="cf_sql_varchar" maxlength="250" />,
														   taskstatus = <cfqueryparam value="#task.taskstatus#" cfsqltype="cf_sql_varchar" />,
														   taskduedate = <cfqueryparam value="#task.taskduedate#" cfsqltype="cf_sql_date" />,
														   tasklastupdated = <cfqueryparam value="#task.tasklastupdate#" cfsqltype="cf_sql_date" />,
														   tasklastupdatedby = <cfqueryparam value="#task.tasklastupdateby#" cfsqltype="cf_sql_varchar" />,
														   tasknotes = <cfqueryparam value="#task.tasknote#" cfsqltype="cf_sql_varchar" />
														   <cfif trim( task.taskstatus ) is "completed" and trim( chktaskstat.taskstatus ) is not "completed">
														   ,taskcompleteddate = <cfqueryparam value="#task.taskcompdate#" cfsqltype="cf_sql_timestamp" />
														   ,taskcompletedby = <cfqueryparam value="#task.taskcompby#" cfsqltype="cf_sql_varchar" />
														   </cfif>
													 where taskid = <cfqueryparam value="#task.taskid#" cfsqltype="cf_sql_integer" />
											</cfquery>																			
											
											<!--- // log the client activity --->
											<cfquery datasource="#application.dsn#" name="logact">
												insert into activity(leadid, userid, activitydate, activitytype, activity)
													values (
															<cfqueryparam value="#leaddetail.leadid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
															<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#session.username# updated task #taskdetail.mtaskname# for #leaddetail.leadfirst# #leaddetail.leadlast#." cfsqltype="cf_sql_varchar" />
															); select @@identity as newactid
											</cfquery>
											
											<cfquery datasource="#application.dsn#">
												insert into recent(userid, leadid, activityid, recentdate)
													values (
															<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#leaddetail.leadid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#logact.newactid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />
															);
											</cfquery>											
											
											<cflocation url="#application.root#?event=page.tasks&msg=taskupdated" addtoken="no">
								
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

								
									
									<!--- // show form to edit note --->												
														
									<cfoutput>
									<br />
									
									<cfif trim( taskdetail.taskstatus ) is "completed"><span class="label label-success">This task has been marked completed.  Date completed: #dateformat( taskdetail.taskcompleteddate, 'mm/dd/yyyy' )# by #taskdetail.taskcompletedby#</span><br /><br /></cfif>
									
									<form id="edit-lead-task" class="form-horizontal" method="post" action="#application.root#?event=page.task.edit&taskid=#taskdetail.taskuuid#">
										<fieldset>						

											<div class="control-group">											
												<label class="control-label" for="taskname">Task Name</label>
												<div class="controls">
													<input type="text" name="taskname" class="input-xlarge" value="<cfif taskdetail.taskname is "none">#taskdetail.mtaskname#<cfelse>#taskdetail.taskname#</cfif>" />
												</div> <!-- /controls -->				
											</div> <!-- /control-group -->
											
											<div class="control-group">											
												<label class="control-label" for="taskduedate">Task Due Date</label>
												<div class="controls">
													<input type="text" class="input-small" name="taskduedate" id="datepicker-inline3" value="#dateformat( taskdetail.taskduedate, 'mm/dd/yyyy' )#" />
												</div> <!-- /controls -->				
											</div> <!-- /control-group -->
											
											<div class="control-group">											
												<label class="control-label" for="taskstatus">Task Status</label>
												<div class="controls">
													<select name="taskstatus" class="input-medium">
														<option value="Assigned"<cfif trim( taskdetail.taskstatus ) is "assigned">selected</cfif>>Assigned</option>
														<option value="In Progress"<cfif trim( taskdetail.taskstatus ) is "in progress">selected</cfif>>In Progress</option>
														<option value="Pending"<cfif trim( taskdetail.taskstatus ) is "pending">selected</cfif>>Pending</option>
														<option value="Delegated"<cfif trim( taskdetail.taskstatus ) is "delegated">selected</cfif>>Delegated</option>
														<option value="Completed"<cfif trim( taskdetail.taskstatus ) is "completed">selected</cfif>>Completed</option>
													</select>
												</div> <!-- /controls -->				
											</div> <!-- /control-group -->		
											
											<div class="control-group">											
												<label class="control-label" for="tasknote">Task Notes</label>
												<div class="controls">
													<textarea name="tasknote" class="input-large span6" rows="8">#urldecode(taskdetail.tasknotes)#</textarea>
												</div> <!-- /controls -->				
											</div> <!-- /control-group -->															
											
											<div class="control-group">											
												<label class="control-label"></label>
												<div class="controls">
													<h6>Task Last Updated: #dateformat( taskdetail.tasklastupdated, 'mm/dd/yyyy' )# at #timeformat( taskdetail.tasklastupdated, 'hh:mm tt' )# by #taskdetail.tasklastupdatedby#</h6>
												</div> <!-- /controls -->				
											</div> <!-- /control-group -->
																	
											<br />
											<div class="form-actions">													
												<button type="submit" class="btn btn-secondary" name="savetask"><i class="icon-save"></i> Save Task Detail</button>																									
												<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.tasks'"><i class="icon-remove-sign"></i> Cancel</a>													
												<input name="utf8" type="hidden" value="&##955;">													
												<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
												<input type="hidden" name="taskid" value="#taskdetail.taskid#" />
												<input type="hidden" name="taskuuid" value="#taskdetail.taskuuid#" />
												<input type="hidden" name="__authToken" value="#randout#" />
												<input name="validate_require" type="hidden" value="taskid|Opps, sorry... the form can not be posted due to an internal error.  Please re-load the page and try again.;taskname|The task name is required.  The field can not be blank.;taskduedate|The task due date is required to post this form." />															
											</div> <!-- /form-actions -->
																	
										</fieldset>
									</form>
									</cfoutput>
									
									<div class="clear"></div>
								</div> <!-- //.widget-content -->	
									
							</div> <!-- //.widget -->
							
						</div> <!-- //.span12 -->
						
					</div> <!-- //.row -->			
				
				
				<div style="height:100px;"></div>			
				
				</div> <!-- //.container -->
			
			</div> <!-- //.main -->