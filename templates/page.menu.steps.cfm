


			<!--- // get our data access components --->
			<cfinvoke component="apis.com.system.implementstepgateway" method="getcats" returnvariable="impstepcat">
			
			
			<!-- // create some session vars we will need for this section --->
			<cfif structkeyexists( form, "stepcat" ) and form.stepcat is not "">
				<cfparam name="stepcat" default="">
				<cfset session.stepcat = #trim( form.stepcat )# />
				<cflocation url="#application.root#?event=#url.event#" addtoken="no">
			</cfif>
			
			<cfif structkeyexists( url, "resetfilter" )>
				<cfparam name="killcat" default="">
				<cfset killcat = structdelete( session, "stepcat" ) />
				<cflocation url="#application.root#?event=#url.event#" addtoken="no">
			</cfif>
			
			
			<!--- // form processing --->
			<cfif structkeyexists( url, "fuseaction" ) and url.fuseaction is "deletestep">
				<cfparam name="stepid" default="">
				<cfset stepid = url.stepid />
				<cfif isvalid( "integer", stepid )>
					<cfquery datasource="#application.dsn#" name="killstep">
						delete
						  from masterstepsimpl
						 where msimpstepid = <cfqueryparam value="#stepid#" cfsqltype="cf_sql_integer" />
					</cfquery>
					<cflocation url="#application.root#?event=#url.event#&msg=saved" addtoken="no">
				</cfif>
			</cfif>
			
			
			<!--- // master implementation steps --->
			
			
			<div class="main">
				<div class="container">					
					<div class="row">						
						<div class="span12">
							
							<!--- // show system messages --->
							
							<cfif structkeyexists( url, "msg" ) and url.msg is "saved">						
																		
								<div class="alert alert-info">
									<button type="button" class="close" data-dismiss="alert">&times;</button>
									<strong><i class="icon-check"></i> SUCCESS!</strong>  The master implemetation step was successfully updated...
								</div>										
									
							<cfelseif structkeyexists( url, "msg" ) and url.msg is "deleted">						
																		
								<div class="alert alert-error">
									<button type="button" class="close" data-dismiss="alert">&times;</button>
									<strong>SUCCESS!</strong>  The master implemetation step was successfully deleted...																
								</div>
							
							<cfelseif structkeyexists( url, "msg" ) and url.msg is "added">						
																		
								<div class="alert alert-info">
									<button type="button" class="close" data-dismiss="alert">&times;</button>
									<strong>SUCCESS!</strong>  The master implemetation step was successfully added...
								</div>								
								
							<cfelseif structkeyexists( url, "msg" ) and url.msg is "error">						
																		
								<div class="alert alert-error">
									<button type="button" class="close" data-dismiss="alert">&times;</button>
									<strong>SYSTEM ERROR!</strong>  Sorry, the master implementation step could not be deleted due to a system error.  Please use the navigation in the sidebar to continue...
								</div>										
									
							</cfif>
							
							
							<div class="widget stacked">
							
								<div class="widget-header">
									<i class="icon-cogs"></i>
									<h3> Manage Master Implementation Steps</h3>									
								</div>
								
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
											<cfset step = structnew() />
											<cfset step.stepid = form.stepid />
											<cfset step.steptype =  trim( form.steptype ) />
											<cfset step.stepcategory = trim( session.stepcat ) />
											<cfset step.stepgroup = trim( form.stepgrp ) />
											<cfset step.steptrees = trim( form.steptrees ) />
											<cfset step.stepnum = form.stepnum />
											<cfset step.steptask = trim( form.steptask ) />											
																						
											<!--- // some other variables --->
											<cfset today = #CreateODBCDateTime(now())# />

											<cfif structkeyexists( form, "stepreason" )>
												<cfset step.stepreason = #form.stepreason# />
												<cfset step.stepreasonnum = #form.stepreasonnum# />
											</cfif>
										
																						
											
											<!--- if this is a new entry, do this --->
											<cfif step.stepid eq 0>
											
												<!--- // update the database record --->
												<cfquery datasource="#application.dsn#" name="savemasterstep">
													insert into masterstepsimpl(msimpcat, msimptype, msimpstepcat, msimpstepnum, msimpstepstat, msimpsteptask, msimpstepreasonnumber, msimpstepreason)
													   values(
																<cfqueryparam value="#step.steptrees#" cfsqltype="cf_sql_varchar" maxlength="13" />,
																<cfqueryparam value="#step.steptype#" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="#step.stepcategory#" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="#step.stepnum#" cfsqltype="cf_sql_numeric" />,
																<cfqueryparam value="#step.stepgroup#" cfsqltype="cf_sql_char" />,
																<cfqueryparam value="#step.steptask#" cfsqltype="cf_sql_varchar" maxlength="150" />
																<cfif structkeyexists( step, "stepreason" )>,
																<cfqueryparam value="#step.stepreasonnum#" cfsqltype="cf_sql_numeric" />,
																<cfqueryparam value="#step.stepreason#" cfsqltype="cf_sql_varchar" maxlength="150" />
																</cfif>
															 );
												</cfquery>											
												
												<!--- // log the activity --->
												<cfquery datasource="#application.dsn#" name="logact">
													insert into activity(leadid, userid, activitydate, activitytype, activity)
														values (
																<cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="#session.username# added a master implementation step #step.stepcategory# #step.steptype#." cfsqltype="cf_sql_varchar" />
																);
												</cfquery>																					
												
												<cflocation url="#application.root#?event=#url.event#&msg=added" addtoken="no">
											
											<cfelse>										
											
												<!--- // update the database record --->
												<cfquery datasource="#application.dsn#" name="savemasterstep">
													update masterstepsimpl
													   set msimpcat = <cfqueryparam value="#step.steptrees#" cfsqltype="cf_sql_varchar" maxlength="13" />,
														   msimptype = <cfqueryparam value="#step.steptype#" cfsqltype="cf_sql_varchar" />,
														   msimpstepcat = <cfqueryparam value="#step.stepcategory#" cfsqltype="cf_sql_varchar" />,
														   msimpstepnum = <cfqueryparam value="#step.stepnum#" cfsqltype="cf_sql_numeric" />,
														   msimpstepstat = <cfqueryparam value="#step.stepgroup#" cfsqltype="cf_sql_char" />,
														   msimpsteptask = <cfqueryparam value="#step.steptask#" cfsqltype="cf_sql_varchar" maxlength="150" />
														    <cfif structkeyexists( step, "stepreason" )>
																, msimpstepreasonnumber = <cfqueryparam value="#step.stepreasonnum#" cfsqltype="cf_sql_numeric" />
																, msimpstepreason = <cfqueryparam value="#step.stepreason#" cfsqltype="cf_sql_varchar" maxlength="150" />
														    </cfif>
													 where msimpstepid = <cfqueryparam value="#step.stepid#" cfsqltype="cf_sql_integer" />
												</cfquery>											
												
												<!--- // log the activity --->
												<cfquery datasource="#application.dsn#" name="logact">
													insert into activity(leadid, userid, activitydate, activitytype, activity)
														values (
																<cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="#session.username# updated master implementation step #step.stepcategory# #step.steptype#." cfsqltype="cf_sql_varchar" />
																);
												</cfquery>																					
												
												<cflocation url="#application.root#?event=#url.event#&msg=saved" addtoken="no">
											
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
									<!-- // end form processing --->
								
								
								
								
								
								
									<cfif not structkeyexists( session, "stepcat" )>
										<p>To get started, please select a master implementation category...
									<cfelse>
										<cfif not structkeyexists( url, "fuseaction" )>
											<p>Please select the master implementation step record you wish to edit. <span class="pull-right"><a href="index.cfm?event=page.menu.steps&fuseaction=addstep" class="btn btn-default btn-small" style="margin-right:5px;"><i class="icon-plus"></i> Add Step</a><a href="index.cfm?event=page.menu.steps&resetfilter=true" class="btn btn-small btn-tertiary"><i class="icon-cog"></i> Reset Category</a></span></p>										
										</cfif>
									</cfif>
									
									
									
									
									<cfif not structkeyexists( session, "stepcat" )>
										
										<cfoutput>	
										
										<br />									
										<br />
																		
											<form id="master-step-cat" class="form-horizontal" method="post" action="#application.root#?event=#url.event#">
												<fieldset>
													<div class="control-group">											
														<label class="control-label" for="firstname"><strong>Select Category</strong></label>
															<div class="controls">
																<select name="stepcat" id="stepcat" onchange="this.form.submit();">
																	<option value="">Please select a category...</option>
																	<cfloop query="impstepcat">
																		<option value="#msimpstepcat#">#msimpstepcat#</option>
																	</cfloop>
																</select>
															</div> <!-- /controls -->				
													</div> <!-- /control-group -->																
												</fieldset>
											</form>						
										
										</cfoutput>
									
									</cfif>
									
									<cfif structkeyexists( session, "stepcat" )>							
										
										<cfif not structkeyexists( url, "fuseaction" )>
											
											<!--- // include the component to get the records by category --->
											<cfinvoke component="apis.com.system.implementstepgateway" method="getsteps" returnvariable="mimplementsteps">
												<cfinvokeargument name="stepcat" value="#session.stepcat#">
											</cfinvoke>
											
											<cfoutput><h4 style="margin-bottom:5px;">Selected Category: #session.stepcat#</h4></cfoutput>
											
											<table id="tablesorter" class="table tablesorter table-bordered table-striped table-highlight">
												<thead>
													<tr>
														<th width="10%">Actions</th>
														<th>Trees</th>
														<th>Category</th>
														<th>Type</th>														
														<cfif session.stepcat is "wage garnishment" or session.stepcat is "tax offset" >
														<th>Reason</th>														
														<th>Step</th>
														<cfelse>
														<th>Step Number</th>														
														<th>Step</th>
														</cfif>
													</tr>
												</thead>
												<tbody>
													<cfoutput query="mimplementsteps">
														<tr>
															<td class="actions">														
																<a href="#application.root#?event=#url.event#&fuseaction=editstep&stepid=#msimpstepid#" class="btn btn-small btn-warning">
																	<i class="btn-icon-only icon-ok"></i>										
																</a>															
																<a href="#application.root#?event=#url.event#&fuseaction=deletestep&stepid=#msimpstepid#" onclick="return confirm('Are you sure you want to delete the selected implementation step?  This action can not be undone.');" class="btn btn-small btn-secondary">
																	<i class="btn-icon-only icon-remove"></i>										
																</a>													
															</td>												
															<td><span class="label label-info">#msimpcat#</span></td>
															<td>#msimpstepcat#</td>
															<td>#msimptype#</td>														
															<cfif session.stepcat is "wage garnishment" or session.stepcat is "tax offset" >
															    <td><span class="label label-warning">#msimpstepreasonnumber#</span>  #msimpstepreason#</td>
																<td><span class="label label-success">#msimpstepnum#</span>  #msimpsteptask#
															<cfelse>																 
																<td>#msimpstepnum#</td>
																<td>#msimpsteptask#</td>
															</cfif>															
														</tr>
													</cfoutput>
												</tbody>
											</table>
										
										</cfif>
										
										<cfif structkeyexists( url, "fuseaction" ) and url.fuseaction is "editstep" and structkeyexists( url, "stepid" ) and url.stepid neq "">
										
											<!--- // include the component to get the records by category --->
											<cfinvoke component="apis.com.system.implementstepgateway" method="getstep" returnvariable="stepdetail">
												<cfinvokeargument name="stepid" value="#url.stepid#">
											</cfinvoke>
											
											<cfoutput>									
												<form id="master-step-edit" class="form-horizontal" method="post" action="#application.root#?event=#url.event#&fuseaction=#url.fuseaction#&stepid=#url.stepid#">
													<fieldset>
														
														<h5 style="font-weight:bold;"><i>You are editing #stepdetail.msimpstepcat# #stepdetail.msimptype#</i></h5>											
														<br />
														<div class="control-group">											
															<label class="control-label" for="stepcategory">Step Category</label>
																<div class="controls">
																	<select name="stepcategory" class="input-large">
																		<option value="">Please select a category...</option>																		
																			<cfloop query="impstepcat">
																				<option value="#msimpstepcat#"<cfif stepdetail.msimpstepcat eq impstepcat.msimpstepcat>selected</cfif>>#msimpstepcat#</option>
																			</cfloop>																		
																	</select>																
																</div> <!-- /controls -->				
														</div> <!-- /control-group -->
														
														<div class="control-group">											
															<label class="control-label" for="steptype">Category Type</label>
																<div class="controls">
																	<input type="text" class="input-medium" name="steptype" value="#stepdetail.msimptype#" />																
																</div> <!-- /controls -->				
														</div> <!-- /control-group -->
														
														<div class="control-group">											
															<label class="control-label" for="steptrees">Option Trees</label>
																<div class="controls">
																	<input type="text" class="input-medium" name="steptrees" value="#stepdetail.msimpcat#" />																
																</div> <!-- /controls -->				
														</div> <!-- /control-group -->
														
														<div class="control-group">											
															<label class="control-label" for="stepgrp">Step Group</label>
																<div class="controls">
																	<input type="text" class="input-mini" name="stepgrp" value="#stepdetail.msimpstepstat#" />																
																</div> <!-- /controls -->				
														</div> <!-- /control-group -->
														
														
														<cfif session.stepcat is "wage garnishment" or session.stepcat is "tax offset" >
														
															<div class="control-group">											
																<label class="control-label" for="stepreason">Reason for #session.stepcat#</label>
																	<div class="controls">
																		<input type="text" class="input-large" name="stepreason" value="#stepdetail.msimpstepreason#" /> &nbsp;&nbsp;Reason Number &nbsp;&nbsp; <input type="text" class="input-small" name="stepreasonnum" value="#stepdetail.msimpstepreasonnumber#" /></span>																
																	</div> <!-- /controls -->				
															</div> <!-- /control-group -->
														
														</cfif>
														
														<div class="control-group">											
															<label class="control-label" for="stepnum">Step Number</label>
																<div class="controls">
																	<input type="text" class="input-mini" name="stepnum" value="#stepdetail.msimpstepnum#" />																
																</div> <!-- /controls -->				
														</div> <!-- /control-group -->													
														
														
														<div class="control-group">											
															<label class="control-label" for="steptask">Step Task</label>
																<div class="controls">
																	<textarea name="steptask" class="input-large span6" rows="5">#stepdetail.msimpsteptask#</textarea>															
																</div> <!-- /controls -->				
														</div> <!-- /control-group -->														
														
														
														<br /><br />
														<div class="form-actions">													
															<button type="submit" class="btn btn-secondary" name="savelead"><i class="icon-save"></i> Save Implementation Step</button>								
															<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=#url.event#'"><i class="icon-remove-sign"></i> Cancel</a>													
															<input name="utf8" type="hidden" value="&##955;">																									
															<input type="hidden" name="stepid" value="#stepdetail.msimpstepid#" />
															<input type="hidden" name="__authToken" value="#randout#" />
															<input name="validate_require" type="hidden" value="stepcategory|Please select a step category from the list.;steptrees|The field Option Trees is required to save this record.;stepgrp|The step group must be either Current or Default.;stepnum|The step number is required to save this record.;steptask|The master implementation step is required to save this record.  Please enter the step task." />
															<input name="validate_numeric" type="hidden" value="stepnum|The step number must be in a valid numeric format.  Please check your entry and try again..." />
														</div> <!-- /form-actions -->
														
													</fieldset>
												</form>						
											</cfoutput>
										</cfif>
										<cfif structkeyexists( url, "fuseaction" ) and url.fuseaction is "addstep">
										
												<cfoutput>									
												<form id="master-step-edit" class="form-horizontal" method="post" action="#application.root#?event=#url.event#&fuseaction=#url.fuseaction#">
													<fieldset>
														
														<h5 style="font-weight:bold;"><i>You are adding a new implementation step for category #session.stepcat#...</i></h5>											
														<br />													
														<div class="control-group">											
															<label class="control-label" for="steptype">Category Type</label>
																<div class="controls">
																	<input type="text" class="input-large" name="steptype" <cfif isdefined( "form.steptype" )>value="#form.steptype#"</cfif> <cfif session.stepcat is "wage garnishment" or session.stepcat is "tax offset">value="Default Intervention"</cfif>  />
																	<p class="help-block">Types like Forgiveness, Default Intervention, Cancellation, Postponement</p>
																</div> <!-- /controls -->				
														</div> <!-- /control-group -->
														
														<div class="control-group">											
															<label class="control-label" for="steptrees">Option Trees</label>
																<div class="controls">
																	<input type="text" class="input-medium" name="steptrees" value="<cfif isdefined( "form.steptrees" )>#form.steptrees#</cfif>" />
																	<p class="help-block">Option Trees in a numerical comma delimited format, like '1,2,4,7' (no quotes)</p>
																</div> <!-- /controls -->				
														</div> <!-- /control-group -->
														
														<div class="control-group">											
															<label class="control-label" for="stepgrp">Step Group</label>
																<div class="controls">
																	<input type="text" class="input-mini" name="stepgrp" value="C" />
																	<p class="help-block">Always Default to C</p>
																</div> <!-- /controls -->				
														</div> <!-- /control-group -->
														
														<cfif session.stepcat is "wage garnishment" or session.stepcat is "tax offset" >
														
															<div class="control-group">											
																<label class="control-label" for="stepreason">Reason for #session.stepcat#</label>
																	<div class="controls">
																		<input type="text" class="input-large" name="stepreason" value="<cfif isdefined( "form.stepreason" )>#form.stepreason#</cfif>" />  &nbsp;&nbsp;Reason Number &nbsp;&nbsp;<input type="text" class="input-small" name="stepreasonnum" value="<cfif isdefined( "form.stepreasonnum" )>#form.stepreasonnum#</cfif>" /></span>																
																	</div> <!-- /controls -->				
															</div> <!-- /control-group -->
														
														</cfif>
														
														<div class="control-group">											
															<label class="control-label" for="stepnum">Step Number</label>
																<div class="controls">
																	<input type="text" class="input-mini" name="stepnum" value="<cfif isdefined( "form.stepnum" )>#form.stepnum#</cfif>" />
																	<p class="help-block">Enter the step number</p>
																</div> <!-- /controls -->				
														</div> <!-- /control-group -->
														
														<div class="control-group">											
															<label class="control-label" for="steptask">Step Task</label>
																<div class="controls">
																	<textarea name="steptask" class="input-large span6" rows="5"><cfif isdefined( "form.steptype" )>#form.steptask#</cfif></textarea>
																	<p class="help-block">Enter the task detail</p>
																</div> <!-- /controls -->				
														</div> <!-- /control-group -->
														
														
														
														<br /><br />
														<div class="form-actions">													
															<button type="submit" class="btn btn-secondary" name="savestep"><i class="icon-save"></i> Save Implementation Step</button>								
															<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=#url.event#'"><i class="icon-remove-sign"></i> Cancel</a>													
															<input name="utf8" type="hidden" value="&##955;">																									
															<input type="hidden" name="stepid" value="0" />
															<input type="hidden" name="__authToken" value="#randout#" />
															<input name="validate_require" type="hidden" value="steptrees|The field Option Trees is required to save this record.;stepgrp|The step group must be either Current or Default.;stepnum|The step number is required to save this record.;steptask|The master implementation step is required to save this record.  Please enter the step task." />
															<input name="validate_numeric" type="hidden" value="stepnum|The step number must be in a valid numeric format.  Please check your entry and try again..." />
														</div> <!-- /form-actions -->
														
													</fieldset>
												</form>						
											</cfoutput>
										
										</cfif>
									</cfif>
									
									
								</div><!-- / .widget-content -->
								
							</div><!-- / .widget -->					
							
							
						</div><!-- / .span12 -->						
					</div><!-- / .row -->
					<div style="margin-top:350px;"></div>
				</div><!-- / .container -->
			</div><!-- / .main -->
