


		<!--- // get our data access components --->
		<cfinvoke component="apis.com.system.presentationgateway" method="getplanlist" returnvariable="planlist">
			<cfinvokeargument name="companyid" value="#session.companyid#">
		</cfinvoke>
		
		<!--- get our plan detail if one is selected for editing --->
		<cfif ( structkeyexists( url, "fuseaction" ) and url.fuseaction is "editplan" ) and ( structkeyexists( url, "planid" ) and isvalid( "uuid", url.planid ))>
			<cfinvoke component="apis.com.system.presentationgateway" method="getplandetail" returnvariable="plandetail">
				<cfinvokeargument name="planid" value="#url.planid#">
			</cfinvoke>		
		</cfif>
		
		
		<!--- // include the tinymce js path --->
		<script src="//tinymce.cachefly.net/4.0/tinymce.min.js"></script>
		
		<!--- // initialize tinymce --->
		<script type="text/javascript">
			tinymce.init({
				selector: "textarea",
				auto_focus: "apbody",
				plugins: ["code, table"],
				width: 960,
				height: 400,
				paste_as_text: true,
				toolbar: "sizeselect | bold italic | fontselect | fontsizeselect",
				font_size_style_values: ["8px,10px,12px,13px,14px,16px,18px,20px"],
			});
		</script>
		
		
		
		<!--- // define form vars --->
		<cfparam name="apname" default="">
		<cfparam name="apbody" default="">
		<cfparam name="apuuid" default="">
		<cfparam name="apcompid" default="">
		<cfparam name="apoption" default="">
		<cfparam name="aptree" default="">
		<cfparam name="apsubcat" default="">
		
		
		
		
		
		
		
		
		
		
		
		<!--- // begin action plan management page --->
		
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
											<strong><i class="icon-check"></i> SUCCESS!</strong>  The action plan item was successfully saved to the company profile.  Please select a new record to continue...
										</div>										
									</div>								
								</div>
							<cfelseif structkeyexists(url, "msg") and url.msg is "updated">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-success">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong>SUCCESS!</strong>  The action plan item was successfully updated in the company profile.  Please select a new record to continue...
										</div>										
									</div>								
								</div>
							<cfelseif structkeyexists(url, "msg") and url.msg is "error">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-error">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong>SYSTEM ERROR!</strong>  Sorry, the note could not be deleted due to a system error.  Please use the navigation in the sidebar to continue...
										</div>										
									</div>								
								</div>
							</cfif>
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
							
						<div class="widget stacked">
								
							<div class="widget-header">		
								<i class="icon-briefcase"></i>							
								<h3>Action Plan Presentation Content <cfif structkeyexists( url, "planid" ) and url.planid eq 0>| Add Action Plan Item <cfelseif structkeyexists( url, "planid" ) and isvalid( "uuid", url.planid )> | Edit Action Plan Item | Plan ID: <cfoutput>#plandetail.actionplanuuid#</cfoutput></cfif></h3>						
							</div> <!-- //.widget-header -->
								
							<div class="widget-content">
							
								<!--- // begin form processing --->
									<cfif isDefined("form.fieldnames")>
										<cfscript>
											objValidation = createobject( "component","apis.com.ui.validation" ).init();
											objValidation.setFields(form);
											objValidation.validate();
										</cfscript>

										<cfif objValidation.getErrorCount() is 0>							
											
											<!--- define our structure and set form values --->
											<cfset ap = structnew() />
											<cfset ap.planid = #form.planid# />
											<cfset ap.apuuid = #createuuid()# />
											<cfset ap.apname = #form.apheader# />
											<cfset ap.apbody = #form.apbody# />
											<cfset ap.apcompid = #form.compid# />
											<cfset ap.aptree = #form.aptree# />
											<cfset ap.apoption = #form.apoption# />
											<cfset ap.apsubcat = #form.apsubcat# />
																						
											<!--- // some other variables --->
											<cfset today = #CreateODBCDateTime(now())# />											
																						
											<cfif ap.planid eq 0>									
											
												<!--- // create the database record --->
												<cfquery datasource="#application.dsn#" name="addplanitem">
													insert into actionplan(actionplanuuid, companyid, actionplanheader, actionplanbodya, optiontree, optiondescr, optionsubcat)
														values (
																<cfqueryparam value="#ap.apuuid#" cfsqltype="cf_sql_varchar" maxlength="35" />,
																<cfqueryparam value="#ap.apcompid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#ap.apname#" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="#ap.apbody#" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="#ap.aptree#" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="#ap.apoption#" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="#ap.apsubcat#" cfsqltype="cf_sql_varchar" />
															   );
												</cfquery>									
												
												<!--- // log the activity --->
												<cfquery datasource="#application.dsn#" name="logact">
													insert into activity(leadid, userid, activitydate, activitytype, activity)
														values (
																<cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																<cfqueryparam value="Record Added" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="#session.username# added action plan item #ap.apname# for solution presentation." cfsqltype="cf_sql_varchar" />
																);
												</cfquery>																					
												
												<cflocation url="#application.root#?event=#url.event#&msg=saved" addtoken="no">
											
											<cfelse>
											
												<!--- // get the PK for the action plan record for update --->
												<cfquery datasource="#application.dsn#" name="getplanitem">
													select actionplanid
													  from actionplan
													 where actionplanuuid = <cfqueryparam value="#ap.planid#" cfsqltype="cf_sql_varchar" maxlength="35" />
												</cfquery>												
												
												<!--- // update the database record --->
												<cfquery datasource="#application.dsn#" name="saveplanitem">
													update actionplan
													   set actionplanheader = <cfqueryparam value="#ap.apname#" cfsqltype="cf_sql_varchar" maxlength="500" />,
														   actionplanbodya = <cfqueryparam value="#ap.apbody#" cfsqltype="cf_sql_varchar" />,
														   optiontree = <cfqueryparam value="#ap.aptree#" cfsqltype="cf_sql_varchar" />,
														   optiondescr = <cfqueryparam value="#ap.apoption#" cfsqltype="cf_sql_varchar" />,
														   optionsubcat = <cfqueryparam value="#ap.apsubcat#" cfsqltype="cf_sql_varchar" />
													 where actionplanid = <cfqueryparam value="#getplanitem.actionplanid#" cfsqltype="cf_sql_integer" />															
												</cfquery>									
												
												<!--- // log the activity --->
												<cfquery datasource="#application.dsn#" name="logact">
													insert into activity(leadid, userid, activitydate, activitytype, activity)
														values (
																<cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="#session.username# updated action plan item #ap.apname# for solution presentation." cfsqltype="cf_sql_varchar" />
																);
												</cfquery>																					
												
												<cflocation url="#application.root#?event=#url.event#&msg=updated" addtoken="no">
											
											
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









































							
								<cfif not structkeyexists( url, "fuseaction" )>	
									
									<cfif planlist.recordcount gt 0>
										<div style="float:left;"><cfoutput><strong>Found #planlist.recordcount# action plan items...</strong></cfoutput></div>
										<div style="float:right;margin-bottom:5px;"><cfoutput><a href="#application.root#?event=#url.event#&fuseaction=addplan&planid=0" class="btn btn-mini btn-secondary"><i class="icon-briefcase"></i> Add Action Plan Item</a></cfoutput></div>
										<table class="table table-bordered table-striped table-highlight">
											<thead>
												<tr>
													<th width="5%"><div align="center">Actions</div></th>
													<th>Header</th>
													<th>Option</th>
													<th>Descr</th>																									
												</tr>
											</thead>
											<tbody>
												<cfoutput query="planlist">
												<tr>													
													<td class="actions">
														<div align="center"><a href="#application.root#?event=#url.event#&fuseaction=editplan&planid=#actionplanuuid#" class="btn btn-mini btn-warning">
															<i class="btn-icon-only icon-pencil"></i>										
														</a></div>				
													</td>												
													<td>#actionplanheader#</td>
													<td>#listfirst( optiontree, "," )#</td>
													<td><cfif optionsubcat is not "">#optionsubcat# - </cfif>#optiondescr#</td>						
												</tr>
												</cfoutput>
											</tbody>
										</table>
									
									<cfelse>
										<div class="alert alert-error">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<i class="icon-warning-sign"></i> <strong>NO RECORDS FOUND!</strong>  Sorry, there are no action plan items to display.  Please click the button above to add a new action plan item...
										</div>
										<div style="float:left;margin-top:5px;"><cfoutput><a href="#application.root#?event=#url.event#&fuseaction=addplan&planid=0" class="btn btn-mini btn-secondary"><i class="icon-briefcase"></i> Add Action Plan Item</a></cfoutput></div>
									
									
									</cfif>
								
								
								<cfelse>
								
									<cfif structkeyexists( url, "planid" ) and isvalid( "uuid", url.planid )>
											
										<cfoutput>
										<h5>Please enter the plan item name and content for the solution presentation...</h5>
								
											<!-- Place this in the body of the page content --->
											<form name="edit-action-plan-item" action="#cgi.script_name#?event=#url.event#&fuseaction=#url.fuseaction#&planid=#url.planid#" method="post">
												
												<fieldset>						

													<div class="control-group" style="margin-top:5px;">											
														<label class="control-label" for="apheader"><strong>Action Plan Header</strong></label>
														<div class="controls">
															<input type="text" name="apheader" id="apheader" class="input-xlarge" value="#plandetail.actionplanheader#" />
														</div> <!-- /controls -->				
													</div> <!-- /control-group -->
													
													<div class="control-group" style="margin-top:5px;">											
														<label class="control-label" for="apheader"><strong>Option Tree</strong></label>
														<div class="controls">
															<input type="text" name="aptree" id="aptree" class="input-xlarge" value="#plandetail.optiontree#" />
														</div> <!-- /controls -->				
													</div> <!-- /control-group -->
													
													<div class="control-group" style="margin-top:5px;">											
														<label class="control-label" for="apheader"><strong>Option and Category</strong></label>
														<div class="controls">
															<input type="text" name="apoption" id="apoption" class="input-xlarge" value="#plandetail.optiondescr#" /> &nbsp; <input type="text" name="apsubcat" id="apsubcat" class="input-large" value="#plandetail.optionsubcat#" />
														</div> <!-- /controls -->				
													</div> <!-- /control-group -->
													
													<div class="control-group">	
														<div class="controls">
															<textarea id="apbody" name="apbody">#urldecode( plandetail.actionplanbodya )#</textarea>
														</div> <!-- /controls -->				
													</div> <!-- /control-group -->
											
													<br />
													
													<div class="form-actions">													
														<button type="submit" class="btn btn-secondary" name="saveplan"><i class="icon-save"></i> Update Action Plan Item</button>																									
														<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.menu.plans'"><i class="icon-remove-sign"></i> Cancel</a>													
														<input name="utf8" type="hidden" value="&##955;">													
														<input type="hidden" name="planid" value="#url.planid#" />
														<input type="hidden" name="compid" value="#session.companyid#" />
														<input type="hidden" name="__authToken" value="#randout#" />
														<input name="validate_require" type="hidden" value="planid|Opps, sorry... the form can not be posted due to an internal error.  Please re-load the page and try again.;apheader|The action plan header name is required.  Please try again..." />															
													</div> <!-- /form-actions -->
											
												</fieldset>
											</form>
										</cfoutput>
									
									<cfelse>
										
										
										<cfoutput>
										<h5>Please enter the plan item name and content for the solution presentation...</h5>
								
											<!-- Place this in the body of the page content --->
											<form name="add-action-plan-item" action="#cgi.script_name#?event=#url.event#&fuseaction=#url.fuseaction#&planid=#url.planid#" method="post">
												
												<fieldset>						

													<div class="control-group" style="margin-top:5px;">											
														<label class="control-label" for="apheader"><strong>Action Plan Header</strong></label>
														<div class="controls">
															<input type="text" name="apheader" id="apheader" class="input-xlarge" />
														</div> <!-- /controls -->				
													</div> <!-- /control-group -->
													
													<div class="control-group" style="margin-top:5px;">											
														<label class="control-label" for="aptree"><strong>Option Tree</strong></label>
														<div class="controls">
															<input type="text" name="aptree" id="aptree" class="input-xlarge" />
														</div> <!-- /controls -->				
													</div> <!-- /control-group -->
													
													<div class="control-group" style="margin-top:5px;">											
														<label class="control-label" for="apoption"><strong>Option and Category</strong></label>
														<div class="controls">
															<input type="text" name="apoption" id="apoption" class="input-xlarge" /> &nbsp; <input type="text" name="apsubcat" id="apsubcat" class="input-large" />
														</div> <!-- /controls -->				
													</div> <!-- /control-group -->
													
													<div class="control-group">	
														<div class="controls">
															<textarea id="apbody" name="apbody"></textarea>
														</div> <!-- /controls -->				
													</div> <!-- /control-group -->
											
													<br />
													
													<div class="form-actions">													
														<button type="submit" class="btn btn-secondary" name="saveplan"><i class="icon-save"></i> Save Plan Item</button>																									
														<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.menu.plans'"><i class="icon-remove-sign"></i> Cancel</a>													
														<input name="utf8" type="hidden" value="&##955;">													
														<input type="hidden" name="planid" value="#url.planid#" />
														<input type="hidden" name="compid" value="#session.companyid#" />
														<input type="hidden" name="__authToken" value="#randout#" />
														<input name="validate_require" type="hidden" value="planid|Opps, sorry... the form can not be posted due to an internal error.  Please re-load the page and try again.;apheader|The action plan header name is required.  Please try again..." />															
													</div> <!-- /form-actions -->
											
												</fieldset>
											</form>
										</cfoutput>
									</cfif>								
								
								
								</cfif>
												
										
									

									<div class="clear"></div>
							</div> <!-- //.widget-content -->	
									
						</div> <!-- //.widget -->
							
					</div> <!-- //.span12 -->
						
				</div> <!-- //.row -->				
				
				<cfif not structkeyexists( url, "fuseaction" ) and planlist.recordcount LTE 5>
				<div style="height:400px;"></div>			
				<cfelseif planlist.recordcount LTE 5 and structkeyexists( url, "fuseaction" )>
				<div style="height:400px;"></div>	
				<cfelse>
				<div style="height:100px;"></div>
				</cfif>
			</div> <!-- //.container -->
			
		</div> <!-- //.main -->