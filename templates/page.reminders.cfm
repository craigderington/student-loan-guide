


			<!--- // get our data access components --->
			<cfinvoke component="apis.com.tasks.remindergateway" method="gettaskreminders" returnvariable="taskreminderlist">
				<cfinvokeargument name="userid" value="#session.userid#">
			</cfinvoke>	
			
			<cfinvoke component="apis.com.tasks.remindergateway" method="getuserreminders" returnvariable="userreminderlist">
				<cfinvokeargument name="userid" value="#session.userid#">
			</cfinvoke>	
			
			<cfinvoke component="apis.com.users.usergateway" method="getuserprofile" returnvariable="quserprofile">
				<cfinvokeargument name="userid" value="#session.userid#">
			</cfinvoke>
			
			<!--- // perform necessary user reminder management functions // --->
			<cfif structkeyexists( url, "fuseaction" )>
				<cfif structkeyexists( url, "rmid" ) and isvalid( "uuid", url.rmid )>
					<cfinvoke component="apis.com.tasks.remindergateway" method="getuserreminderdetail" returnvariable="userreminderdetail">
						<cfinvokeargument name="reminderid" value="#url.rmid#">
					</cfinvoke>
					<cfif structkeyexists( url, "rmaction" )>
						<cfset rmid = url.rmid />
							<cfif trim( url.rmaction ) is "delete">							
								<!--- // get the reminder pkid --->
								<cfquery datasource="#application.dsn#" name="getreminder">
									select reminderid 
									  from userreminders
									 where reminderuuid = <cfqueryparam value="#rmid#" cfsqltype="cf_sql_varchar" maxlength="35" />
								</cfquery>
								<!--- // kill the reminder --->
								<cfquery datasource="#application.dsn#" name="killreminder">
									delete 
									  from userreminders
									 where reminderid = <cfqueryparam value="#getreminder.reminderid#" cfsqltype="cf_sql_integer" />
								</cfquery>
								<cflocation url="#application.root#?event=#url.event#&msg=complete&action=deleted" addtoken="no" />
							<cfelseif trim( url.rmaction ) is "archive">							
								<!--- // get the reminder pkid --->
								<cfquery datasource="#application.dsn#" name="getreminder">
									select reminderid
									  from userreminders
									 where reminderuuid = <cfqueryparam value="#rmid#" cfsqltype="cf_sql_varchar" maxlength="35" />
								</cfquery>
								<!--- // archive the reminder --->
								<cfquery datasource="#application.dsn#" name="killreminder">
									update userreminders
									   set showreminder = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />
									 where reminderid = <cfqueryparam value="#getreminder.reminderid#" cfsqltype="cf_sql_integer" />
								</cfquery>
								<cflocation url="#application.root#?event=#url.event#&msg=complete&action=archived" addtoken="no" />
							</cfif>
					</cfif>					
				</cfif>				
			</cfif>
			
			
			
			
			<!--- // perform necessary client task reminder management functions // --->			
			<cfif structkeyexists( url, "taskaction" )>
				<cfparam name="thisaction" default="">
				<cfset thisaction = trim( url.taskaction ) />
					<cfif structkeyexists( url, "taskid" ) and isvalid( "uuid", url.taskid )>
						<cfparam name="taskid" default="">
						<cfset taskid = url.taskid />
							
							<!--- // get task by task uuid --->
							<cfquery datasource="#application.dsn#" name="gettask">
								select taskid, taskuuid, mtaskid, leadid
								  from tasks
								 where taskuuid = <cfqueryparam value="#taskid#" cfsqltype="cf_sql_varchar" maxlength="35" />
							</cfquery>
						
							<cfif structkeyexists( url, "rid" )>
								<cfparam name="reminderid" default="">
								<cfset reminderid = url.rid />
									<!--- // get the task reminder --->
									<cfquery datasource="#application.dsn#" name="gettaskreminder">
										select reminderid, taskuuid, userid, reminderdate, remindertime
										  from taskreminders
										 where taskuuid = <cfqueryparam value="#taskid#" cfsqltype="cf_sql_varchar" maxlength="35" />
										   and reminderid = <cfqueryparam value="#reminderid#" cfsqltype="cf_sql_integer" />
									</cfquery>
									
									
										<!-- // perform the requested action --->
										<cfif thisaction is "deletereminder">
										
											<cfquery datasource="#application.dsn#" name="gettaskreminder">
												delete from taskreminders
												 where taskuuid = <cfqueryparam value="#taskid#" cfsqltype="cf_sql_varchar" maxlength="35" />
												   and reminderid = <cfqueryparam value="#reminderid#" cfsqltype="cf_sql_integer" />
											</cfquery>
											
											<cflocation url="#application.root#?event=#url.event#&msg=complete&action=deleted" addtoken="no">
										
										<cfelseif thisaction is "archivereminder">
										
											<cfquery datasource="#application.dsn#" name="gettaskreminder">
												update taskreminders
												   set showreminder = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />
												 where taskuuid = <cfqueryparam value="#taskid#" cfsqltype="cf_sql_varchar" maxlength="35" />
												   and reminderid = <cfqueryparam value="#reminderid#" cfsqltype="cf_sql_integer" />
											</cfquery>
											
											<cflocation url="#application.root#?event=#url.event#&msg=complete&action=archived" addtoken="no">
										
										</cfif>						
									
									
							</cfif>
						
					</cfif>
			
			</cfif>
			
			
			
			
			<!--- // extra styling --->
			<style>
				.rlist {
					background-color:#f2f2f2;
					margin-top:5px;
					margin-bottom:7px;
					border-bottom: 1px solid #000;
					padding: 25px;
					font-weight:bold;
					font-size:18px;
				}
			</style>
			
			
			
			
			
			<!--- lead notes page --->			
			
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
							
							<!--- // show system messages --->
							
							<cfif structkeyexists( url, "msg" ) and trim( url.msg ) is "complete">						
								
								<cfif structkeyexists( url, "action" ) and trim( url.action ) is "deleted">						
									<div class="row">
										<div class="span12">										
											<div class="alert alert-info">
												<button type="button" class="close" data-dismiss="alert">&times;</button>
												<strong><i class="icon-check"></i> REMINDER STATUS:</strong>  The reminder was successfully deleted...
											</div>										
										</div>								
									</div>
								<cfelseif structkeyexists( url, "action" ) and trim( url.action ) is "archived">						
									<div class="row">
										<div class="span12">										
											<div class="alert alert-success">
												<button type="button" class="close" data-dismiss="alert">&times;</button>
												<strong><i class="icon-check"></i> REMINDER STATUS:</strong>  The reminder was successfully archived...
											</div>										
										</div>								
									</div>
								</cfif>
							<cfelseif structkeyexists( url, "msg" ) and trim( url.msg ) is "reminder.created">	
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
							</cfif>	
							
							<!--- // end system messages --->
							
							
							<!--- // begin widget --->
							
							<div class="widget stacked">
								<cfoutput>
								<div class="widget-header">		
									<i class="icon-calendar"> </i>							
									<h3>Reminders for #session.username#</h3>						
								</div> <!-- //.widget-header -->
								</cfoutput>
							
								<div class="widget-content">
									
									<!--- // validate CFC Form Processing --->							
									
									<cfif isDefined("form.fieldnames")>
										<cfscript>
											objValidation = createObject("component","apis.com.ui.validation").init();
											objValidation.setFields(form);
											objValidation.validate();
										</cfscript>

										<cfif objValidation.getErrorCount() is 0>							
											
											<cfset r.reminderid = form.reminderid />
											<cfset r.userid = form.thisuserid />											
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
												
												<cfquery datasource="#application.dsn#" name="createreminder">
													insert into userreminders(reminderuuid, userid, leadid, dateadded, reminderdate, remindertime, reminderampm, remindertext, alerttype, alertdeltatype, alertdeltanum, alertsent)
														values(
																<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar" maxlength="35" />,
																<cfqueryparam value="#r.userid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																<cfqueryparam value="#r.rmdate#" cfsqltype="cf_sql_date" />,
																<cfqueryparam value="#r.rmtime#" cfsqltype="cf_sql_timestamp" />,
																<cfqueryparam value="pm" cfsqltype="cf_sql_char" />,
																<cfqueryparam value="#r.rmtext#" cfsqltype="cf_sql_varchar" maxlength="1000" />,
																<cfqueryparam value="#r.rmtype#" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="minute" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="15" cfsqltype="cf_sql_varchar" />,																
																<cfqueryparam value="0" cfsqltype="cf_sql_bit" />													
															   );
												</cfquery>		
													
													<!--- // redirect to success message --->
													<cflocation url="#application.root#?event=#url.event#&msg=reminder.created" addtoken="yes">
											
											<cfelse>
												
												<cfquery datasource="#application.dsn#" name="savereminder">
													update userreminders
													   set reminderdate = <cfqueryparam value="#r.rmdate#" cfsqltype="cf_sql_date" />,
													       remindertime = <cfqueryparam value="#r.rmtime#" cfsqltype="cf_sql_timestamp" />,
														   alerttype = <cfqueryparam value="#r.rmtype#" cfsqltype="cf_sql_char" />,
														   remindertext = <cfqueryparam value="#r.rmtext#" cfsqltype="cf_sql_varchar" maxlength="1000" />														   
													 where reminderuuid = <cfqueryparam value="#r.reminderid#" cfsqltype="cf_sql_varchar" maxlength="35" />
												</cfquery>										
												
													<!--- // redirect to success message --->
													<cflocation url="#application.root#?event=#url.event#&msg=reminder.saved" addtoken="yes">
												
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
									
									
									
									
									
									
									<div class="span6">
										
											<cfif userreminderlist.recordcount gt 0>
											
												<h5 style="margin-bottom:25px;"><i class="icon-calendar"></i> Your Personal Reminders</h5>
												<p class="help-block">Hover your cursor over the &nbsp;<i class="icon-info-sign" style="color:red;"></i>&nbsp; for reminder text.</p>
												
													<ul style="list-style:none;">
														
														<cfoutput query="userreminderlist">
															<li class="rlist">#dateformat( reminderdate , "mm/dd/yyyy" )# &nbsp;&nbsp;  #timeformat( remindertime, "hh:mm TT" )# &nbsp;&nbsp;   <span class="pull-right"><cfif trim( alerttype ) is "eml"><i class="icon-envelope" title="Email Message" style="margin-right:5px;"></i><cfelse><i class="icon-phone" title="Text Message" style="margin-right:5px;"></i></cfif><i style="margin-right:5px;" class="icon-check<cfif alertsent eq 0>-empty</cfif>" title="Alert <cfif alertsent eq 0>Not</cfif> Sent"></i><a style="margin-right:5px;" title="Delete Reminder" href="#application.root#?event=#url.event#&fuseaction=dothis&rmid=#reminderuuid#&rmaction=delete" onclick="javascript:return confirm('Confirm Delete?');"><i class="icon-trash"></i></a> <cfif alertsent eq 0><a style="margin-right:5px" href="#application.root#?event=#url.event#&fuseaction=editreminder&rmid=#reminderuuid#" title="Edit Reminder"><i class="icon-edit"></i></a></cfif>   <a style="margin-right:5px;" title="Archive Reminder" href="#application.root#?event=#url.event#&fuseaction=dothis&rmid=#reminderuuid#&rmaction=archive" onclick="javascript:return confirm('Confirm Archive?');"><i class="icon-remove-sign"></i></a>    <a style="margin-right:5px" href="javascript:;" rel="popover" data-original-title="#dateformat( reminderdate, "mm/dd/yyyy" )#" data-content="#remindertext#"><i class="icon-info-sign"></i></a></span></li>
														</cfoutput>
													
													</ul>
										
											<cfelse>
										
												<div class="alert alert-error">
												<a class="close" data-dismiss="alert">&times;</a>
													<h5><error>There are no saved reminders</error></h5>
													<p>Create a reminder - use the form below...</p>
											</div>
										
											</cfif>

											<cfif taskreminderlist.recordcount gt 0>
											
											<br /><br />
												
												
												<h5 style="margin-top:25px;margin-bottom:25px;"><i class="icon-calendar"></i> Client Task Reminders</h5>
												
												
													<ul style="list-style:none;">
														
														<cfoutput query="taskreminderlist">
															<li class="rlist">#dateformat( reminderdate , "mm/dd/yyyy" )# &nbsp;&nbsp;  #timeformat( remindertime, "hh:mm TT" )# <br/>
															<span style="font-size:12px;">#leadfirst# #leadlast# (#leadid#) - #mtaskname#</span> <span class="pull-right"><cfif trim( alerttype ) is "eml"><i class="icon-envelope" title="Email Message" style="margin-right:5px;"></i><cfelse><i class="icon-phone" title="Text Message" style="margin-right:5px;"></i></cfif><i style="margin-right:5px;" class="icon-check<cfif alertsent eq 0>-empty</cfif>" title="Alert <cfif alertsent eq 0>Not</cfif> Sent"></i><a style="margin-right:5px;" title="Delete Reminder" href="#application.root#?event=#url.event#&taskaction=deletereminder&taskid=#taskuuid#&rid=#reminderid#" onclick="javascript:return confirm('Delete Task Reminder?');"><i class="icon-trash"></i></a> <cfif alertsent eq 0><a style="margin-right:5px" href="#application.root#?event=page.reminder.edit&taskid=#taskuuid#&rmid=#reminderid#" title="Edit Reminder"><i class="icon-edit"></i></a></cfif>   <a style="margin-right:5px;" title="Archive Reminder" href="#application.root#?event=#url.event#&taskaction=archivereminder&taskid=#taskuuid#&rid=#reminderid#" onclick="javascript:return confirm('Archive Task Reminder?');"><i class="icon-remove-sign"></i></a>    <a style="margin-right:5px" href="javascript:;" rel="popover" data-original-title="#dateformat( reminderdate, "mm/dd/yyyy" )#" data-content="#remindertext#"><i class="icon-info-sign"></i></a></span></li>
														</cfoutput>
														
													</ul>
											</cfif>
										
										
									</div>
									
									<div class="span5">			
																				
										<div id="datepicker-multi"></div>									
										<br />
										<h4><i class="icon-calendar"></i> <cfif structkeyexists( url, "rmid" )>Edit<cfelse>Create</cfif> Reminder</h4>
										
										<div class="well">
											<cfoutput>
												<form class="form-horizontal" name="addreminder" method="post">

													<cfif not structkeyexists( url, "rmid" )>
													
														<div class="control-group">											
															<label class="control-label" for="reminderdate">Reminder Date</label>
																<div class="controls">
																	<input type="text" class="input-small" name="reminderdate" id="datepicker-inline" value="<cfif isdefined( "form.reminderdate" )>#dateformat( form.reminderdate, "mm/dd/yyyy" )#<cfelse>#dateformat( now(), "mm/dd/yyyy" )#</cfif>" />
																</div> <!-- /controls -->				
														</div> <!-- /control-group -->
													
													<cfelse>
													
														<div class="control-group">											
															<label class="control-label" for="reminderdate">Reminder Date</label>
																<div class="controls">
																	<input type="text" class="input-small" id="datepicker-inline4" name="reminderdate" value="<cfif isvalid( "uuid", url.rmid ) and userreminderdetail.reminderdate is not "">#dateformat( userreminderdetail.reminderdate, "mm/dd/yyyy" )#</cfif>" />
																</div> <!-- /controls -->				
														</div> <!-- /control-group -->

													
													</cfif>
													
													<div class="control-group">											
														<label class="control-label" for="remindertime">Reminder Time</label>
															<div class="controls">
																<select name="remindertime" class="input-medium">
																	<option value="08:00"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "08:00">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 8>selected</cfif>>8:00 am</option>
																	<option value="08:15"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "08:15">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 8 and datepart( "n", userreminderdetail.remindertime ) eq 15>selected</cfif>>8:15 am</option>
																	<option value="08:30"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "08:30">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 8 and datepart( "n", userreminderdetail.remindertime ) eq 30>selected</cfif>>8:30 am</option>
																	<option value="08:45"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "08:45">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 8 and datepart( "n", userreminderdetail.remindertime ) eq 45>selected</cfif>>8:45 am</option>
																	<option value="09:00"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "09:00">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 9>selected</cfif>>9:00 am</option>
																	<option value="09:15"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "09:15">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 9 and datepart( "n", userreminderdetail.remindertime ) eq 15>selected</cfif>>9:15 am</option>
																	<option value="09:30"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "09:30">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 9 and datepart( "n", userreminderdetail.remindertime ) eq 30>selected</cfif>>9:30 am</option>
																	<option value="09:45"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "09:45">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 9 and datepart( "n", userreminderdetail.remindertime ) eq 45>selected</cfif>>9:45 am</option>
																	<option value="10:00"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "10:00">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 10 and datepart( "n", userreminderdetail.remindertime ) eq 0>selected</cfif>>10:00 am</option>
																	<option value="10:15"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "10:15">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 10 and datepart( "n", userreminderdetail.remindertime ) eq 15>selected</cfif>>10:15 am</option>
																	<option value="10:30"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "10:30">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 10 and datepart( "n", userreminderdetail.remindertime ) eq 30>selected</cfif>>10:30 am</option>
																	<option value="10:45"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "10:45">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 10 and datepart( "n", userreminderdetail.remindertime ) eq 45>selected</cfif>>10:45 am</option>
																	<option value="11:00"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "11:00">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 11 and datepart( "n", userreminderdetail.remindertime ) eq 0>selected</cfif>>11:00 am</option>
																	<option value="11:15"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "11:15">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 11 and datepart( "n", userreminderdetail.remindertime ) eq 15>selected</cfif>>11:15 am</option>
																	<option value="11:30"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "11:30">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 11 and datepart( "n", userreminderdetail.remindertime ) eq 30>selected</cfif>>11:30 am</option>
																	<option value="11:45"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "11:45">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 11 and datepart( "n", userreminderdetail.remindertime ) eq 45>selected</cfif>>11:45 am</option>
																	<option value="12:00"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "12:00">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 12 and datepart( "n", userreminderdetail.remindertime ) eq 0>selected</cfif>>12:00 pm</option>
																	<option value="12:15"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "12:15">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 12 and datepart( "n", userreminderdetail.remindertime ) eq 15>selected</cfif>>12:15 pm</option>
																	<option value="12:30"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "12:30">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 12 and datepart( "n", userreminderdetail.remindertime ) eq 30>selected</cfif>>12:30 pm</option>
																	<option value="12:45"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "12:45">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 12 and datepart( "n", userreminderdetail.remindertime ) eq 45>selected</cfif>>12:45 pm</option>
																	<option value="13:00"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "13:00">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 13 and datepart( "n", userreminderdetail.remindertime ) eq 0>selected</cfif>>1:00 pm</option>
																	<option value="13:15"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "13:15">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 13 and datepart( "n", userreminderdetail.remindertime ) eq 15>selected</cfif>>1:15 pm</option>
																	<option value="13:30"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "13:30">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 13 and datepart( "n", userreminderdetail.remindertime ) eq 30>selected</cfif>>1:30 pm</option>
																	<option value="13:45"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "13:45">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 13 and datepart( "n", userreminderdetail.remindertime ) eq 45>selected</cfif>>1:45 pm</option>
																	<option value="14:00"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "14:00">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 14 and datepart( "n", userreminderdetail.remindertime ) eq 0>selected</cfif>>2:00 pm</option>
																	<option value="14:15"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "14:15">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 14 and datepart( "n", userreminderdetail.remindertime ) eq 15>selected</cfif>>2:15 pm</option>
																	<option value="14:30"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "14:30">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 14 and datepart( "n", userreminderdetail.remindertime ) eq 30>selected</cfif>>2:30 pm</option>
																	<option value="14:45"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "14:45">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 14 and datepart( "n", userreminderdetail.remindertime ) eq 45>selected</cfif>>2:45 pm</option>
																	<option value="15:00"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "15:00">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 15 and datepart( "n", userreminderdetail.remindertime ) eq 0>selected</cfif>>3:00 pm</option>
																	<option value="15:15"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "15:15">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 15 and datepart( "n", userreminderdetail.remindertime ) eq 15>selected</cfif>>3:15 pm</option>
																	<option value="15:30"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "15:30">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 15 and datepart( "n", userreminderdetail.remindertime ) eq 30>selected</cfif>>3:30 pm</option>
																	<option value="15:45"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "15:45">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 15 and datepart( "n", userreminderdetail.remindertime ) eq 45>selected</cfif>>3:45 pm</option>
																	<option value="16:00"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "16:00">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 16 and datepart( "n", userreminderdetail.remindertime ) eq 0>selected</cfif>>4:00 pm</option>
																	<option value="16:15"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "16:15">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 16 and datepart( "n", userreminderdetail.remindertime ) eq 15>selected</cfif>>4:15 pm</option>
																	<option value="16:30"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "16:30">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 16 and datepart( "n", userreminderdetail.remindertime ) eq 30>selected</cfif>>4:30 pm</option>
																	<option value="16:45"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "16:45">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 16 and datepart( "n", userreminderdetail.remindertime ) eq 45>selected</cfif>>4:45 pm</option>
																	<option value="17:00"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "17:00">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 17 and datepart( "n", userreminderdetail.remindertime ) eq 0>selected</cfif>>5:00 pm</option>
																	<option value="17:15"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "17:15">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 17 and datepart( "n", userreminderdetail.remindertime ) eq 15>selected</cfif>>5:15 pm</option>
																	<option value="17:30"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "17:30">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 17 and datepart( "n", userreminderdetail.remindertime ) eq 30>selected</cfif>>5:30 pm</option>
																	<option value="17:45"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "17:45">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 17 and datepart( "n", userreminderdetail.remindertime ) eq 45>selected</cfif>>5:45 pm</option>
																	<option value="18:00"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "18:00">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 18 and datepart( "n", userreminderdetail.remindertime ) eq 0>selected</cfif>>6:00 pm</option>
																	<option value="18:15"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "18:15">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 18 and datepart( "n", userreminderdetail.remindertime ) eq 15>selected</cfif>>6:15 pm</option>
																	<option value="18:30"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "18:30">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 18 and datepart( "n", userreminderdetail.remindertime ) eq 30>selected</cfif>>6:30 pm</option>
																	<option value="18:45"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "18:45">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 18 and datepart( "n", userreminderdetail.remindertime ) eq 45>selected</cfif>>6:45 pm</option>
																	<option value="19:00"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "19:00">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 19 and datepart( "n", userreminderdetail.remindertime ) eq 0>selected</cfif>>7:00 pm</option>
																	<option value="19:15"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "19:15">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 19 and datepart( "n", userreminderdetail.remindertime ) eq 15>selected</cfif>>7:15 pm</option>
																	<option value="19:30"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "19:30">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 19 and datepart( "n", userreminderdetail.remindertime ) eq 30>selected</cfif>>7:30 pm</option>
																	<option value="19:45"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "19:45">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 19 and datepart( "n", userreminderdetail.remindertime ) eq 45>selected</cfif>>7:45 pm</option>
																	<option value="20:00"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "20:00">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 20 and datepart( "n", userreminderdetail.remindertime ) eq 0>selected</cfif>>8:00 pm</option>
																	<option value="20:15"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "20:15">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 20 and datepart( "n", userreminderdetail.remindertime ) eq 15>selected</cfif>>8:15 pm</option>
																	<option value="20:30"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "20:30">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 20 and datepart( "n", userreminderdetail.remindertime ) eq 30>selected</cfif>>8:30 pm</option>
																	<option value="20:45"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "20:45">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 20 and datepart( "n", userreminderdetail.remindertime ) eq 45>selected</cfif>>8:45 pm</option>
																	<option value="21:00"<cfif isdefined( "form.remindertime" ) and form.reminderhour is "21:00">selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq 21 and datepart( "n", userreminderdetail.remindertime ) eq 0>selected</cfif>>9:00 pm</option>
																	
																</select>																																																													
															</div> <!-- /controls -->				
													</div> <!-- /control-group -->
													<div class="control-group">
															<label class="control-label" for="rgtype">Type</label>
															<div class="controls">
																<label class="radio">
																	<input type="radio" name="rgtype" value="eml" <cfif isdefined( "form.rgtype" ) and trim( form.rgtype ) is "eml">checked<cfelseif structkeyexists( url, "rmid" ) and trim( userreminderdetail.alerttype ) is "eml">checked<cfelse>checked</cfif> />
																	Email
																</label>
																<cfif ( trim( quserprofile.txtmsgaddress ) is not "" ) and ( trim( quserprofile.txtmsgprovider ) is not "" )>
																	<label class="radio">
																		<input type="radio" name="rgtype" value="txt" <cfif isdefined( "form.rgtype" ) and trim( form.rgtype ) is "txt">checked<cfelseif structkeyexists( url, "rmid" ) and trim( userreminderdetail.alerttype ) is "txt">checked</cfif> />
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
																<textarea name="remindertext" class="input-large" rows="5" /><cfif isdefined( "form.remindertext" )>#form.remindertext#<cfelseif structkeyexists( url, "rmid" )>#userreminderdetail.remindertext#</cfif></textarea>
															</div> <!-- /controls -->				
													</div> <!-- /control-group -->
												
													<button style="margin-left:180px;" type="submit" class="btn btn-mini btn-secondary" name="savereminder"><i class="icon-calendar"></i> Save Reminder</button>
													<cfif structkeyexists( url, "rmid" )>
													<a style="margin-right:5px;" name="cancelform" class="btn btn-primary btn-mini" href="#application.root#?event=#url.event#"><i class="icon-reorder"></i> Cancel</a>
													</cfif>
													<button type="reset" name="resethisform" class="btn btn-default btn-mini"><i class="icon-remove"></i> Reset</button>
														<input name="utf8" type="hidden" value="&##955;">
														<input type="hidden" name="__authToken" value="#randout#" />
														<input type="hidden" name="thisuserid" value="#session.userid#" />
														<cfif structkeyexists( url, "rmid" )>
															<input type="hidden" name="reminderid" value="#url.rmid#" />
														<cfelse>
															<input type="hidden" name="reminderid" value="0" />
														</cfif>
														<input name="validate_require" type="hidden" value="reminderdate|The reminder date is required,;remindertext|The reminder text is required to save the record." />														
													</div> 
												
												
												
												
												</form>
											</cfoutput>
										
											
										
										</div>
										
										
										
									</div>
									
									
								</div> <!-- /. widget-content -->
							
							</div> <!-- /. widget-stacked -->
						
						</div><!-- / .span12 -->
					
					</div> <!-- / .row -->							
					
					
				<div style="height:150px;"></div>
					
					
				</div> <!-- / .container -->
			
			</div> <!-- / .main -->
		