
			
			
			<!--- get our data components --->
			<cfinvoke component="apis.com.users.usergateway" method="getuserprofile" returnvariable="quserprofile">
				<cfinvokeargument name="userid" value="#session.userid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>			
			
			<cfinvoke component="apis.com.leads.leadgateway" method="getleadtasks" returnvariable="tasklist">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>			
			
			<cfinvoke component="apis.com.tasks.taskgateway" method="gettask" returnvariable="taskdetail">
				<cfinvokeargument name="taskid" value="#url.taskid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.tasks.remindergateway" method="gettaskreminder" returnvariable="taskreminder">
				<cfinvokeargument name="taskid" value="#url.taskid#">
			</cfinvoke>
			
			<!---// if the user clicks to edit their reminder, invoke the reminder detail --->
			<cfif structkeyexists( url, "fuseaction" )>
				<cfif structkeyexists( url, "rmid" ) and isvalid( "integer", url.rmid )>
					<cfparam name="rmid" default="">
					<cfset rmid = url.rmid />
						<cfif trim( url.fuseaction ) is  "editreminder">					
							<cfinvoke component="apis.com.tasks.remindergateway" method="gettaskreminderdetail" returnvariable="taskreminderdetail">
								<cfinvokeargument name="rmid" value="#rmid#">
							</cfinvoke>							
						<cfelseif trim( url.fuseaction ) is "deletereminder">
							<cfquery datasource="#application.dsn#" name="killtaskreminder">
								delete 
								  from taskreminders
								 where reminderid = <cfqueryparam value="#rmid#" cfsqltype="cf_sql_integer" />
							</cfquery>
							<!--- // redirect to success message --->
							<cflocation url="#application.root#?event=#url.event#&taskid=#url.taskid#&msg=reminder.deleted" addtoken="no">
						</cfif>
				</cfif>		
			</cfif>
			
			
			
			
			

			<!--- // student loan master task list page --->		
					
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
						
							<!--- // show system messages --->
							<cfif structkeyexists( url, "msg" ) and trim( url.msg ) is "reminder.created">	
								<div class="row">
										<div class="span12">										
											<div class="alert alert-success">
												<button type="button" class="close" data-dismiss="alert">&times;</button>
												<strong><i class="icon-check"></i> REMINDER STATUS: </strong>  The reminder was successfully created...
											</div>										
										</div>								
									</div>
							<cfelseif structkeyexists( url, "msg" ) and trim( url.msg ) is "reminder.saved">	
								<div class="row">
										<div class="span12">										
											<div class="alert alert-success">
												<button type="button" class="close" data-dismiss="alert">&times;</button>
												<strong><i class="icon-check"></i> REMINDER STATUS:</strong>  The reminder was successfully updated...
											</div>										
										</div>								
									</div>
							<cfelseif structkeyexists( url, "msg" ) and trim( url.msg ) is "reminder.deleted">	
								<div class="row">
										<div class="span12">										
											<div class="alert alert-info">
												<button type="button" class="close" data-dismiss="alert">&times;</button>
												<strong><i class="icon-check"></i> REMINDER STATUS:</strong>  The reminder was successfully deleted...
											</div>										
										</div>								
									</div>
							</cfif>	
							
							<div class="widget stacked">
								
								<div class="widget-header">		
									<cfoutput>
									<i class="icon-tasks"></i>							
									<h3>Student Loan Task Reminder for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>
									</cfoutput>
								</div> <!-- //.widget-header -->
								
								<div class="widget-content">

									<!--- // validate CFC Form Processing --->							
									
									<cfif isDefined("form.fieldnames")>
										<cfscript>
											objValidation = createobject( "component","apis.com.ui.validation" ).init();
											objValidation.setFields( form );
											objValidation.validate();
										</cfscript>

										<cfif objValidation.getErrorCount() is 0>							
											
											<cfset r.reminderid = form.reminderid />
											<cfset r.userid = form.thisuserid />											
											<cfset r.taskuuid = form.taskuuid />
											<cfset r.rmdate = form.reminderdate />
											<cfset r.rmtime = form.remindertime />
											<cfset r.rmtype = trim( form.rgtype ) />
											<cfset r.rmtext = left( form.remindertext, 1000 ) />
											
											<!--- // some other variables --->
											<cfset today = createodbcdatetime( now() ) />
											<cfset r.rmtime = createdatetime( year( r.rmdate ), month( r.rmdate ), day( r.rmdate ), hour( r.rmtime ), minute( r.rmtime ), 0 ) />						
											
											<!---
											<cfdump var="#r#" label="form structure">
											--->
											
											<cfif r.reminderid eq 0>
												
												<cfquery datasource="#application.dsn#" name="createtaskreminder">
													insert into taskreminders(taskuuid, userid, reminderdate, remindertime, remindertext, alerttype, alertdeltatype, alertdeltanum, alertsent)
														values(
																<cfqueryparam value="#r.taskuuid#" cfsqltype="cf_sql_varchar" maxlength="35" />,
																<cfqueryparam value="#r.userid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#r.rmdate#" cfsqltype="cf_sql_date" />,
																<cfqueryparam value="#r.rmtime#" cfsqltype="cf_sql_timestamp" />,																
																<cfqueryparam value="#r.rmtext#" cfsqltype="cf_sql_varchar" maxlength="1000" />,
																<cfqueryparam value="#r.rmtype#" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="minute" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="30" cfsqltype="cf_sql_varchar" />,																
																<cfqueryparam value="0" cfsqltype="cf_sql_bit" />													
															   );
												</cfquery>		
													
												<!--- // redirect to success message --->
												<cflocation url="#application.root#?event=#url.event#&taskid=#r.taskuuid#&msg=reminder.created" addtoken="yes">
											
											<cfelse>
												
												<cfquery datasource="#application.dsn#" name="savetaskreminder">
													update taskreminders
													   set reminderdate = <cfqueryparam value="#r.rmdate#" cfsqltype="cf_sql_date" />,
													       remindertime = <cfqueryparam value="#r.rmtime#" cfsqltype="cf_sql_timestamp" />,
														   alerttype = <cfqueryparam value="#r.rmtype#" cfsqltype="cf_sql_char" />,
														   remindertext = <cfqueryparam value="#r.rmtext#" cfsqltype="cf_sql_varchar" maxlength="1000" />														   
													 where reminderid = <cfqueryparam value="#r.reminderid#" cfsqltype="cf_sql_integer" />
												</cfquery>										
												
													<!--- // redirect to success message --->
													<cflocation url="#application.root#?event=#url.event#&taskid=#r.taskuuid#&msg=reminder.saved" addtoken="yes">
												
											</cfif>										
								
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
									
									<div class="span5">
										<div class="well">
											<cfoutput>
												<h4><strong><i class="icon-file-alt"></i> Task: #taskdetail.mtaskname#</strong></h4><br />											
												<cfif trim( taskdetail.taskstatus ) is "completed"><span class="label label-success">Completed <cfif taskdetail.taskcompleteddate is not ""> - #dateformat( taskdetail.taskcompleteddate, "mm/dd/yyyy" )#</cfif></span><cfelse><span class="label label-important">Assigned</span></cfif>
												
												<br /><br />
												
												Last Updated: #dateformat( taskdetail.tasklastupdated, "full" )# by #taskdetail.tasklastupdatedby#<br />
												
												
											</cfoutput>
										</div>
										<br />
										<cfif taskreminder.recordcount gt 0>
											<div class="well">
												<h5><i class="icon-tasks"></i> &nbsp;Here are this client's task reminders for the above task:</h5><br />
												<cfoutput query="taskreminder">
													<p style="margin-top:20px;margin-bottom:5px;padding-bottom:20px;border-bottom:1px dotted ##999;"><cfif userid eq session.userid><a href="#application.root#?event=#url.event#&taskid=#url.taskid#&fuseaction=editreminder&rmid=#reminderid#"><i class="icon-edit"></i></a><a style="margin-left:5px;" href="#application.root#?event=#url.event#&taskid=#url.taskid#&fuseaction=deletereminder&rmid=#reminderid#" onclick="javascript:return confirm('Confirm Delete Reminder?');"><i class="icon-remove"></i></a></cfif>&nbsp; #firstname# #lastname# created a reminder for #remindertext# on #dateformat( reminderdate, "mm/dd/yyyy" )# @ #timeformat( remindertime, "hh:mm tt" )# <cfif alertsent eq 1><span class="pull-right"><span class="label label-default"><small>Alert Sent</small></span></span></cfif></p>
												</cfoutput>
											</div>
										</cfif>
									</div>
									
									<div class="span6">
										
										<cfoutput>
											<cfif taskreminder.recordcount gt 0><i style="color:red;" class="icon-warning-sign"></i> #taskreminder.recordcount# reminder<cfif taskreminder.recordcount gt 1>s</cfif> found for this task.  Edit your own reminders by clicking the edit icon below left.</cfif>
										</cfoutput>
										
										
										<div class="well">										
											
											<cfif not structkeyexists( url, "fuseaction" )>
												<h5><i class="icon-plus"></i> Create Task Reminder</h5>
											<cfelse>
												<h5><i class="icon-calendar"></i> Edit Task Reminder <span class="pull-right help-block">ID: <cfoutput>#taskreminderdetail.taskuuid#</cfoutput></span></h5>
												
											</cfif>
											
											<br />
											
												<cfoutput>
													<form class="form-horizontal" name="addreminder" method="post">						
														
														<div class="control-group">											
															<label class="control-label" for="reminderdate">Reminder Date</label>
																<div class="controls">
																	<input type="text" class="input-small" id="datepicker-inline4" name="reminderdate" value="<cfif isdefined( "form.reminderdate" )>#dateformat( form.reminderdate, "mm/dd/yyyy" )#<cfelseif structkeyexists( url, "rmid" )>#dateformat( taskreminderdetail.reminderdate, "mm/dd/yyyy" )#<cfelse>#dateformat( now(), "mm/dd/yyyy" )#</cfif>" />
																</div> <!-- /controls -->				
														</div> <!-- /control-group -->
														
														
														<div class="control-group">											
															<label class="control-label" for="remindertime">Reminder Time</label>
																<div class="controls">
																	<select name="remindertime" class="input-medium">
																		<option value="08:00"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "08:00">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 8>selected</cfif>>8:00 am</option>
																		<option value="08:15"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "08:15">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 8 and datepart( "n", taskreminderdetail.remindertime ) eq 15>selected</cfif>>8:15 am</option>
																		<option value="08:30"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "08:30">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 8 and datepart( "n", taskreminderdetail.remindertime ) eq 30>selected</cfif>>8:30 am</option>
																		<option value="08:45"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "08:45">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 8 and datepart( "n", taskreminderdetail.remindertime ) eq 45>selected</cfif>>8:45 am</option>
																		<option value="09:00"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "09:00">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 9>selected</cfif>>9:00 am</option>
																		<option value="09:15"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "09:15">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 9 and datepart( "n", taskreminderdetail.remindertime ) eq 15>selected</cfif>>9:15 am</option>
																		<option value="09:30"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "09:30">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 9 and datepart( "n", taskreminderdetail.remindertime ) eq 30>selected</cfif>>9:30 am</option>
																		<option value="09:45"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "09:45">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 9 and datepart( "n", taskreminderdetail.remindertime ) eq 45>selected</cfif>>9:45 am</option>
																		<option value="10:00"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "10:00">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 10 and datepart( "n", taskreminderdetail.remindertime ) eq 0>selected</cfif>>10:00 am</option>
																		<option value="10:15"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "10:15">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 10 and datepart( "n", taskreminderdetail.remindertime ) eq 15>selected</cfif>>10:15 am</option>
																		<option value="10:30"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "10:30">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 10 and datepart( "n", taskreminderdetail.remindertime ) eq 30>selected</cfif>>10:30 am</option>
																		<option value="10:45"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "10:45">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 10 and datepart( "n", taskreminderdetail.remindertime ) eq 45>selected</cfif>>10:45 am</option>
																		<option value="11:00"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "11:00">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 11 and datepart( "n", taskreminderdetail.remindertime ) eq 0>selected</cfif>>11:00 am</option>
																		<option value="11:15"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "11:15">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 11 and datepart( "n", taskreminderdetail.remindertime ) eq 15>selected</cfif>>11:15 am</option>
																		<option value="11:30"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "11:30">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 11 and datepart( "n", taskreminderdetail.remindertime ) eq 30>selected</cfif>>11:30 am</option>
																		<option value="11:45"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "11:45">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 11 and datepart( "n", taskreminderdetail.remindertime ) eq 45>selected</cfif>>11:45 am</option>
																		<option value="12:00"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "12:00">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 12 and datepart( "n", taskreminderdetail.remindertime ) eq 0>selected</cfif>>12:00 pm</option>
																		<option value="12:15"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "12:15">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 12 and datepart( "n", taskreminderdetail.remindertime ) eq 15>selected</cfif>>12:15 pm</option>
																		<option value="12:30"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "12:30">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 12 and datepart( "n", taskreminderdetail.remindertime ) eq 30>selected</cfif>>12:30 pm</option>
																		<option value="12:45"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "12:45">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 12 and datepart( "n", taskreminderdetail.remindertime ) eq 45>selected</cfif>>12:45 pm</option>
																		<option value="13:00"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "13:00">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 13 and datepart( "n", taskreminderdetail.remindertime ) eq 0>selected</cfif>>1:00 pm</option>
																		<option value="13:15"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "13:15">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 13 and datepart( "n", taskreminderdetail.remindertime ) eq 15>selected</cfif>>1:15 pm</option>
																		<option value="13:30"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "13:30">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 13 and datepart( "n", taskreminderdetail.remindertime ) eq 30>selected</cfif>>1:30 pm</option>
																		<option value="13:45"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "13:45">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 13 and datepart( "n", taskreminderdetail.remindertime ) eq 45>selected</cfif>>1:45 pm</option>
																		<option value="14:00"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "14:00">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 14 and datepart( "n", taskreminderdetail.remindertime ) eq 0>selected</cfif>>2:00 pm</option>
																		<option value="14:15"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "14:15">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 14 and datepart( "n", taskreminderdetail.remindertime ) eq 15>selected</cfif>>2:15 pm</option>
																		<option value="14:30"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "14:30">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 14 and datepart( "n", taskreminderdetail.remindertime ) eq 30>selected</cfif>>2:30 pm</option>
																		<option value="14:45"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "14:45">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 14 and datepart( "n", taskreminderdetail.remindertime ) eq 45>selected</cfif>>2:45 pm</option>
																		<option value="15:00"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "15:00">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 15 and datepart( "n", taskreminderdetail.remindertime ) eq 0>selected</cfif>>3:00 pm</option>
																		<option value="15:15"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "15:15">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 15 and datepart( "n", taskreminderdetail.remindertime ) eq 15>selected</cfif>>3:15 pm</option>
																		<option value="15:30"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "15:30">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 15 and datepart( "n", taskreminderdetail.remindertime ) eq 30>selected</cfif>>3:30 pm</option>
																		<option value="15:45"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "15:45">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 15 and datepart( "n", taskreminderdetail.remindertime ) eq 45>selected</cfif>>3:45 pm</option>
																		<option value="16:00"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "16:00">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 16 and datepart( "n", taskreminderdetail.remindertime ) eq 0>selected</cfif>>4:00 pm</option>
																		<option value="16:15"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "16:15">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 16 and datepart( "n", taskreminderdetail.remindertime ) eq 15>selected</cfif>>4:15 pm</option>
																		<option value="16:30"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "16:30">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 16 and datepart( "n", taskreminderdetail.remindertime ) eq 30>selected</cfif>>4:30 pm</option>
																		<option value="16:45"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "16:45">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 16 and datepart( "n", taskreminderdetail.remindertime ) eq 45>selected</cfif>>4:45 pm</option>
																		<option value="17:00"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "17:00">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 17 and datepart( "n", taskreminderdetail.remindertime ) eq 0>selected</cfif>>5:00 pm</option>
																		<option value="17:15"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "17:15">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 17 and datepart( "n", taskreminderdetail.remindertime ) eq 15>selected</cfif>>5:15 pm</option>
																		<option value="17:30"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "17:30">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 17 and datepart( "n", taskreminderdetail.remindertime ) eq 30>selected</cfif>>5:30 pm</option>
																		<option value="17:45"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "17:45">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 17 and datepart( "n", taskreminderdetail.remindertime ) eq 45>selected</cfif>>5:45 pm</option>
																		<option value="18:00"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "18:00">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 18 and datepart( "n", taskreminderdetail.remindertime ) eq 0>selected</cfif>>6:00 pm</option>
																		<option value="18:15"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "18:15">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 18 and datepart( "n", taskreminderdetail.remindertime ) eq 15>selected</cfif>>6:15 pm</option>
																		<option value="18:30"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "18:30">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 18 and datepart( "n", taskreminderdetail.remindertime ) eq 30>selected</cfif>>6:30 pm</option>
																		<option value="18:45"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "18:45">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 18 and datepart( "n", taskreminderdetail.remindertime ) eq 45>selected</cfif>>6:45 pm</option>
																		<option value="19:00"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "19:00">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 19 and datepart( "n", taskreminderdetail.remindertime ) eq 0>selected</cfif>>7:00 pm</option>
																		<option value="19:15"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "19:15">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 19 and datepart( "n", taskreminderdetail.remindertime ) eq 15>selected</cfif>>7:15 pm</option>
																		<option value="19:30"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "19:30">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 19 and datepart( "n", taskreminderdetail.remindertime ) eq 30>selected</cfif>>7:30 pm</option>
																		<option value="19:45"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "19:45">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 19 and datepart( "n", taskreminderdetail.remindertime ) eq 45>selected</cfif>>7:45 pm</option>
																		<option value="20:00"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "20:00">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 20 and datepart( "n", taskreminderdetail.remindertime ) eq 0>selected</cfif>>8:00 pm</option>
																		<option value="20:15"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "20:15">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 20 and datepart( "n", taskreminderdetail.remindertime ) eq 15>selected</cfif>>8:15 pm</option>
																		<option value="20:30"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "20:30">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 20 and datepart( "n", taskreminderdetail.remindertime ) eq 30>selected</cfif>>8:30 pm</option>
																		<option value="20:45"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "20:45">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 20 and datepart( "n", taskreminderdetail.remindertime ) eq 45>selected</cfif>>8:45 pm</option>
																		<option value="21:00"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "21:00">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", taskreminderdetail.remindertime ) eq 21 and datepart( "n", taskreminderdetail.remindertime ) eq 0>selected</cfif>>9:00 pm</option>
																		
																	</select>																																																													
																</div> <!-- /controls -->				
														</div> <!-- /control-group -->
														<div class="control-group">
																<label class="control-label" for="rgtype">Type</label>
																<div class="controls">
																	<label class="radio">
																		<input type="radio" name="rgtype" value="eml" <cfif isdefined( "form.rgtype" ) and trim( form.rgtype ) is "eml">checked<cfelseif structkeyexists( url, "rmid" ) and trim( taskreminderdetail.alerttype ) is "eml">checked<cfelse>checked</cfif> />
																		Email
																	</label>
																	<cfif ( trim( quserprofile.txtmsgaddress ) is not "" ) and ( trim( quserprofile.txtmsgprovider ) is not "" )>
																		<label class="radio">
																			<input type="radio" name="rgtype" value="txt" <cfif isdefined( "form.rgtype" ) and trim( form.rgtype ) is "txt">checked<cfelseif structkeyexists( url, "rmid" ) and trim( taskreminderdetail.alerttype ) is "txt">checked</cfif> />
																			Text
																		</label>
																	<cfelse>
																		<label class="radio">
																			<small><i class="icon-warning-sign" style="color:red;"></i> Text Option Disabled <a href="#application.root#?event=page.profile">Click here to update</a></small>
																		</label>
																	</cfif>
																</div>
														</div>
														<div class="control-group">											
															<label class="control-label" for="remindertext">Reminder</label>
																<div class="controls">
																	<textarea name="remindertext" class="input-large" rows="5" /><cfif isdefined( "form.remindertext" )>#form.remindertext#<cfelseif structkeyexists( url, "rmid" )>#taskreminderdetail.remindertext#<cfelse>Reminder:  Complete task: #taskdetail.mtaskname# for #leaddetail.leadfirst# #leaddetail.leadlast# (#leaddetail.leadid#) by #dateformat( taskdetail.taskduedate, "mm/dd/yyyy" )# </cfif></textarea>
																</div> <!-- /controls -->				
														</div> <!-- /control-group -->
													
														<button style="margin-left:180px;" type="submit" class="btn btn-mini btn-secondary" name="savereminder"><i class="icon-calendar"></i> Save Reminder</button>
														<cfif structkeyexists( url, "taskid" )>
														<a style="margin-right:5px;" name="cancelform" class="btn btn-primary btn-mini" href="#application.root#?event=#url.event#&taskid=#url.taskid#"><i class="icon-reorder"></i> Cancel</a>
														</cfif>
														<button type="reset" name="resethisform" class="btn btn-default btn-mini"><i class="icon-remove"></i> Reset</button>
															<input name="utf8" type="hidden" value="&##955;">
															<input type="hidden" name="taskuuid" value="#taskdetail.taskuuid#" />
															<input type="hidden" name="reminderid" value="<cfif structkeyexists( url, "rmid" )>#url.rmid#<cfelse>0</cfif>" />
															<input type="hidden" name="__authToken" value="#randout#" />
															<input type="hidden" name="thisuserid" value="#session.userid#" />														
															<input name="validate_require" type="hidden" value="reminderdate|The reminder date is required,;remindertext|The reminder text is required to save the record." />														
														</div>												
													</form>
												</cfoutput>
											
											
									</div>
									
									
									
									
									
									
									<div class="clear"></div>
								</div> <!-- //.widget-content -->	
									
							</div> <!-- //.widget -->
							
						</div> <!-- //.span12 -->
						
					</div> <!-- //.row -->			
				
				
					<div style="height:100px;"></div>			
				
				</div> <!-- //.container -->
			
			</div> <!-- //.main -->