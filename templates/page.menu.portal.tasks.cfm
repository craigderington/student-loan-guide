



				


				<!---- get our data access components --->
				<cfinvoke component="apis.com.system.portaltasks" method="getportaltasklist" returnvariable="portaltasklist">			
				
				<cfif structkeyexists( url, "fuseaction" ) and url.fuseaction is "edittask">
					<cfif structkeyexists( url, "taskid" ) and isvalid( "integer", url.taskid )>
						<cfinvoke component="apis.com.system.portaltasks" method="getportaltaskdetail" returnvariable="portaltaskdetail">
							<cfinvokeargument name="taskid" value="#url.taskid#">
						</cfinvoke>
					</cfif>				
				</cfif>
				
				
				
				
				
				
				
				
				
				<div class="main">				
				
					<div class="container">
					
						<div class="row">

								<!--- system messages --->
								<cfif structkeyexists( url, "msg" ) and url.msg is "saved">						
									<div class="span12">									
										<div class="alert alert-info">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong><i class="icon-check"></i>SUCCESS!</strong>  The portal task was saved successfully...
										</div>										
									</div>
								<cfelseif structkeyexists( url, "msg" ) and url.msg is "added">						
									<div class="span12">									
										<div class="alert alert-success">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong><i class="icon-check"></i>SUCCESS!</strong>  The portal task was successfully added...
										</div>										
									</div>																
								</cfif>												
								<!-- // end system messages --->
						
							
							
									<div class="span8">
									
										<div class="widget stacked">
										
											<!--- // validate CFC Form Processing --->							
											
											<cfif isDefined("form.fieldnames")>
												<cfscript>
													objValidation = createObject("component","apis.com.ui.validation").init();
													objValidation.setFields(form);
													objValidation.validate();
												</cfscript>

												<cfif objValidation.getErrorCount() is 0>							
													
													<!--- define our structure and set form values--->
													<cfset t = structnew() />
													<cfset t.taskid = #form.taskid# />
													<cfset t.taskdescr = trim( form.taskdescr ) />										
																						
													<!--- // manipulate some strings for proper case --->															
													<cfset today = #CreateODBCDateTime(now())# />
													
														<cfif t.taskid neq 0>
												
															<cfquery datasource="#application.dsn#" name="savethistask">
																update portaltasks										   
																   set portaltask = <cfqueryparam value="#t.taskdescr#" cfsqltype="cf_sql_varchar" />														
																 where portaltaskid = <cfqueryparam value="#t.taskid#" cfsqltype="cf_sql_integer" /> 		  
															</cfquery>
															
															<cfquery datasource="#application.dsn#" name="logact">
																insert into activity(leadid, userid, activitydate, activitytype, activity)
																	values (
																			<cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
																			<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																			<cfqueryparam value="#today#" cfsqltype="cf_sql_date" />,
																			<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
																			<cfqueryparam value="#session.username# edited the portal task #t.taskdescr# in the menu system." cfsqltype="cf_sql_varchar" />
																			);
															</cfquery>

															<cflocation url="#application.root#?event=#url.event#&msg=saved" addtoken="no">
														
														<cfelse>
															
															<cfquery datasource="#application.dsn#" name="addnewtask">
																insert into portaltasks(portaltask)										   
																   values(
																		  <cfqueryparam value="#t.taskdescr#" cfsqltype="cf_sql_varchar" />
																		  );														 		  
															</cfquery>
															
															<cfquery datasource="#application.dsn#" name="logact">
																insert into activity(leadid, userid, activitydate, activitytype, activity)
																	values (
																			<cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
																			<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																			<cfqueryparam value="#today#" cfsqltype="cf_sql_date" />,
																			<cfqueryparam value="Record Added" cfsqltype="cf_sql_varchar" />,
																			<cfqueryparam value="#session.username# added a portal task to the menu system." cfsqltype="cf_sql_varchar" />
																			);
															</cfquery>
															
															<cflocation url="#application.root#?event=#url.event#&msg=added" addtoken="no">
														
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
										
										
										
										
										
										
										
										
											<div class="widget-header">
												<i class="icon-tasks"></i> 
												<h3>Administration | System Menus | Manage Client Portal Task List</h3>
											</div>
											
											<div class="widget-content">
												
												<cfif portaltasklist.recordcount gt 0>
												
													<table class="table table-bordered table-striped table-highlight">
														<thead>
															<tr>
																<th width="10%">Actions</th>												
																<th>Task Description</th>
															</tr>
														</thead>
														<tbody>
															<cfoutput query="portaltasklist">
																<tr>
																	<td class="actions">															
																		<a href="#application.root#?event=#url.event#&fuseaction=edittask&taskid=#portaltaskid#" title="Edit Task" class="btn btn-mini btn-inverse">
																			<i class="btn-icon-only icon-ok"></i>										
																		</a>																															
																	</td>						
																	<td>#portaltask#</td>
																</tr>										
															</cfoutput>												
														</tbody>
													</table>								
													
												<cfelse>
												
													<div class="alert alert-block alert-info">
														<button type="button" class="close" data-dismiss="alert">&times;</button>
															<h3><i style="font-weight:bold;" class="icon-warning-sign"></i>WARNING!</h3>
															<p>There are no client portal tasks defined in the system....</p>
													</div>									
												
												
												</cfif>
												
											
											</div>
										
										
										</div>
										
										
									
									
									</div><!-- / .span8 -->
							
							
							
									<div class="span4">
									
										<div class="widget stacked">
											
											<div class="widget-header">
												<i style="margin-right: 5px;" class="icon-tasks"></i> <cfif structkeyexists( url, "fuseaction" ) and url.fuseaction is "edittask"> Edit Portal Task<cfelse> Add Portal Task</cfif>
											</div>
											
											
											<div class="widget-content">
												
															
															<cfoutput>
																<form id="edit-this-form" class="form-horizontal" method="post" action="#application.root#?event=#url.event#">
																	<fieldset>
																		<div class="control-group">											
																			<label style="margin-left:-100px;" class="control-label" for="taskdescr"><strong>Task</strong></label>
																			<div class="controls">
																				<textarea style="margin-left:-100px;" placeholder="Add New Task" class="input-large" rows="5" name="taskdescr" id="taskdescr"><cfif isdefined( "form.taskdescr" )>#trim( form.taskdescr )#<cfelse><cfif structkeyexists( url, "fuseaction" ) and url.fuseaction is "edittask">#portaltaskdetail.portaltask#</cfif></cfif></textarea>
																			</div> <!-- /controls -->				
																		</div> <!-- /control-group -->												
																		<br />									
																			
																			<cfif structkeyexists( url, "fuseaction" )>
																				<button style="margin-left:78px;" type="submit" class="btn btn-small btn-primary" name="savecat"><i class="icon-save"></i> Save Task</button>
																				<a href="#application.root#?event=#url.event#" class="btn btn-small btn-default" name="cancel"><i class="icon-remove"></i> Cancel</a>
																			<cfelse>
																				<button style="margin-left:78px;" type="submit" class="btn btn-small btn-secondary" name="savecat"><i class="icon-save"></i> Add New Task</button>
																				<button type="reset" name="reset" class="btn btn-default btn-small"><i class="icon-reorder"></i> Reset																
																			</cfif>
																			<input name="utf8" type="hidden" value="&##955;">												
																			<input type="hidden" name="taskid" value="<cfif structkeyexists( url, "taskid" )>#url.taskid#<cfelse>0</cfif>" />
																			<input type="hidden" name="__authToken" value="#randout#" />
																			<input name="validate_require" type="hidden" value="taskdescr|You must enter a task description to save the record." />										
																																
																	</fieldset>
																</form>
															</cfoutput>		
												
											</div>								
											
										</div><!-- / .widget -->

							
										<div class="widget stacked">
											
											<div class="widget-header">
												<i style="margin-right: 5px;" class="icon-paste"></i> More System Menu Options
											</div>											
											
											<cfoutput>
												<div class="widget-content">															
													<ul style="list-style:none;">
														<li><a href="#application.root#?event=page.menu"><i class="icon-chevron-right"></i> Menu Home</li></a>
														<li><a href="#application.root#?event=page.menu.servicers"><i class="icon-chevron-right"></i> Servicers</li></a>
														<li><a href="#application.root#?event=page.menu.email"><i class="icon-chevron-right"></i> Message Library</li></a>
														<li><a href="#application.root#?event=page.reports"><i class="icon-chevron-right"></i> Reports</li></a>
														<li><a href="#application.root#?event=page.reminders"><i class="icon-chevron-right"></i> Reminders</li></a>
														<li><a href="#application.root#?event=page.menu.document.categories"><i class="icon-chevron-right"></i> Document Categories</li></a>
														<li><a href="#application.root#?event=page.menu.plans"><i class="icon-chevron-right"></i> Action Plans</li></a>
														<li><a href="#application.root#?event=page.menu.steps"><i class="icon-chevron-right"></i> Implementation Steps</li></a>
														<li><a href="#application.root#?event=page.menu.jobs"><i class="icon-chevron-right"></i> Job Conditions</li></a>
													</ul>	
												</div>								
											</cfoutput>
										</div><!-- / .widget -->

											
									
									</div><!-- / .span4 -->
						
						</div><!-- / .row -->
						<div style="margin-top:175px;"></div>
						
					</div><!-- /.container -->
					
				</div><!-- / .main -->