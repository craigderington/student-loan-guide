


			<!--- // get our data access components --->
			<cfinvoke component="apis.com.tasks.remindergateway" method="getreminders" returnvariable="reminderlist">
				<cfinvokeargument name="userid" value="#session.userid#">
			</cfinvoke>		
			
			<cfinvoke component="apis.com.tasks.remindergateway" method="getuserreminders" returnvariable="userreminderlist">
				<cfinvokeargument name="userid" value="#session.userid#">
			</cfinvoke>
			
			<cfif structkeyexists( url, "fuseaction" )>
				<cfif structkeyexists( url, "rmid" ) and isvalid( "uuid", url.rmid )>
					<cfinvoke component="apis.com.tasks.remindergateway" method="getuserreminderdetail" returnvariable="userreminderdetail">
						<cfinvokeargument name="reminderid" value="#url.rmid#">
					</cfinvoke>
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
											<cfset r.rmtimehour = form.reminderhour />
											<cfset r.rmtimeminute = form.reminderminutes />
											<cfset r.rmtimeofday = trim( form.rgtime ) />
											<cfset r.rmtype = trim( form.rgtype ) />
											<cfset r.rmtext = left( form.remindertext, 1000 ) />
											
											<!--- // some other variables --->
											<cfset today = #CreateODBCDateTime(now())# />
											<cfset r.rmtime = createdatetime( year( r.rmdate ), month( r.rmdate ), day( r.rmdate ), r.rmtimehour, r.rmtimeminute, 0 ) />							
											
											
											<cfif r.reminderid eq 0>
											
											<!---
											<cfdump var="#r#" label="form structure">
											--->
											
											
												<cfquery datasource="#application.dsn#" name="createreminder">
													insert into userreminders(reminderuuid, userid, leadid, dateadded, reminderdate, remindertime, reminderampm, remindertext, alerttype, alertdeltatype, alertdeltanum, alertsent)
														values(
																<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar" maxlength="35" />,
																<cfqueryparam value="#r.userid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																<cfqueryparam value="#r.rmdate#" cfsqltype="cf_sql_date" />,
																<cfqueryparam value="#r.rmtime#" cfsqltype="cf_sql_timestamp" />,
																<cfqueryparam value="#r.rmtimeofday#" cfsqltype="cf_sql_char" />,
																<cfqueryparam value="#r.rmtext#" cfsqltype="cf_sql_varchar" maxlength="1000" />,
																<cfqueryparam value="#r.rmtype#" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="minute" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="15" cfsqltype="cf_sql_varchar" />,																
																<cfqueryparam value="0" cfsqltype="cf_sql_bit" />													
															   );
												</cfquery>
												
													<cflocation url="#application.root#?event=#url.event#&msg=reminder.created" addtoken="yes">
											
											<cfelse>
												
												<cfquery datasource="#application.dsn#" name="savereminder">
													update userreminders
													   set reminderdate = <cfqueryparam value="#r.rmdate#" cfsqltype="cf_sql_date" />,
													       remindertime = <cfqueryparam value="#r.rmtime#" cfsqltype="cf_sql_time" />,
														   remindertext = <cfqueryparam value="#r.rmtext#" cfsqltype="cf_sql_varchar" maxlength="1000" />				   														   													   
													 where reminderuuid = <cfqueryparam value="#r.reminderid#" cfsqltype="cf_sql_varchar" maxlength="35" />
												</cfquery>
												
												
											
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
											
												<h3 style="margin-bottom:25px;"><i class="icon-calendar"></i> Your Personal Reminders</h3>
												
												
													<ul style="list-style:none;">
														
														<cfoutput query="userreminderlist">
															<li class="rlist">#dateformat( reminderdate , "mm/dd/yyyy" )# &nbsp;&nbsp;  #timeformat( remindertime, "hh:mm" )# #reminderampm# &nbsp;&nbsp;   <span class="pull-right"><i style="margin-right:5px;" class="icon-check<cfif alertsent eq 0>-empty</cfif>" title="Alert <cfif alertsent eq 0>Not</cfif> Sent"></i><a style="margin-right:5px;" title="Delete Reminder" href="index.cfm"><i class="icon-trash"></i></a> <a style="margin-right:5px" href="#application.root#?event=#url.event#&fuseaction=editreminder&rmid=#reminderuuid#" title="Edit Reminder"><i class="icon-edit"></i></a>   <a style="margin-right:5px;" title="Archive Reminder" href="index.cfm"><i class="icon-remove-sign"></i></a>    <a style="margin-right:5px" href="javascript:;" rel="popover" data-original-title="#dateformat( reminderdate, "mm/dd/yyyy" )#" data-content="#remindertext#"><i class="icon-info-sign"></i></a></span></li>
														</cfoutput>
													
													</ul>
										
											<cfelse>
										
												<div class="alert alert-error">
												<a class="close" data-dismiss="alert">&times;</a>
													<h5><error>There are no saved reminders</error></h5>
													<p>Create a reminder - use the form below...</p>
											</div>
										
											</cfif>

											<cfif userreminderlist.recordcount gt 0>
											
												<h3 style="margin-top:25px;margin-bottom:25px;"><i class="icon-calendar"></i> Client Task Reminders</h3>
												
												
													<ul style="list-style:none;">
														<!---
														<cfoutput query="taskreminderlist">
															<li class="rlist">#dateformat( reminderdate , "mm/dd/yyyy" )# &nbsp;&nbsp;  #timeformat( remindertime, "hh:mm" )# #reminderampm# &nbsp;&nbsp;   <span class="pull-right"><i style="margin-right:5px;" class="icon-check<cfif alertsent eq 0>-empty</cfif>" title="Alert <cfif alertsent eq 0>Not</cfif> Sent"></i><a title="Delete Reminder" href="index.cfm"><i class="icon-remove-sign"></i></a> <a style="margin-left:5px;margin-right:5px" href="index.cfm" title="Edit Reminder"><i class="icon-edit"></i></a>    <a href="javascript:;" rel="popover" data-original-title="#dateformat( reminderdate, "mm/dd/yyyy" )#" data-content=#remindertext#"><i class="icon-info-sign"></i></a></span></li>
														</cfoutput>
														--->
													</ul>
											</cfif>
										
										
									</div>
									
									<div class="span5">
										
										<h4><i class="icon-calendar"></i> <cfif structkeyexists( url, "rmid" )>Edit<cfelse>Create</cfif> Reminder</h4>
										
										<div class="well">
											<cfoutput>
												<form class="form-horizontal" name="addreminder" method="post">

													<div class="control-group">											
														<label class="control-label" for="reminderdate">Reminder Date</label>
															<div class="controls">
																<input type="text" class="input-small" name="reminderdate" id="datepicker-inline" value="<cfif isdefined( "form.reminderdate" )>#dateformat( form.reminderdate, "mm/dd/yyyy" )#<cfelseif structkeyexists( url, "rmid" )>#dateformat( userreminderdetail.reminderdate, "mm/dd/yyyy" )#<cfelse>#dateformat( now(), "mm/dd/yyyy" )#</cfif>" />
															</div> <!-- /controls -->				
													</div> <!-- /control-group -->
													
													<div class="control-group">											
														<label class="control-label" for="reminderhour">Reminder Time</label>
															<div class="controls">
																<select name="reminderhour" class="input-mini">
																	<cfloop from="1" to="12" index="i" step="1">
																		<option value="#i#"<cfif isdefined( "form.reminderhour" ) and form.reminderhour eq i>selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "h", userreminderdetail.remindertime ) eq i>selected</cfif>>#i#</option>
																	</cfloop>
																</select>
																<select name="reminderminutes" class="input-mini">
																	<cfloop from="45" to="15" index="j" step="-15">
																		<option value="<cfif len( j ) eq 1>0</cfif>#j#" <cfif isdefined( "form.reminderminutes" ) and form.reminderminutes eq j>selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "n", userreminderdetail.remindertime ) eq j>selected</cfif>><cfif len( j ) eq 1>0</cfif>#j#</option>
																	</cfloop>
																		<option value="00"<cfif isdefined( "form.reminderminutes" ) and form.reminderminutes eq 00>selected<cfelseif structkeyexists( url, "rmid" ) and datepart( "n", userreminderdetail.remindertime ) eq 00>selected</cfif>>00</option>
																</select>&nbsp;<input type="radio" name="rgtime" value="am" checked> AM  <input type="radio" name="rgtime" value="pm" /> PM																																														
															</div> <!-- /controls -->				
													</div> <!-- /control-group -->
													<div class="control-group">
															<label class="control-label" for="rgtype">Type</label>
															<div class="controls">
																<label class="radio">
																	<input type="radio" name="rgtype" value="txt" checked<cfif structkeyexists( url, "rmid" ) and userreminderdetail.alerttype is "txt">checked</cfif> />
																	Text
																</label>
																<label class="radio">
																	<input type="radio" name="rgtype" value="eml" <cfif structkeyexists( url, "rmid" ) and userreminderdetail.alerttype is "eml">checked</cfif> />
																	Email
																</label>
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
										
											<br />
											<div id="datepicker-multi"></div>
										
										
										</div>
										
										
										
									</div>
									
									
								</div> <!-- /. widget-content -->
							
							</div> <!-- /. widget-stacked -->
						
						</div><!-- / .span12 -->
					
					</div> <!-- / .row -->							
					
					
				<div style="height:150px;"></div>
					
					
				</div> <!-- / .container -->
			
			</div> <!-- / .main -->
		