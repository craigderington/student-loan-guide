			
			
			
			<!--- get our data access components --->
			<cfinvoke component="apis.com.system.portalinstructions" method="getportalcats" returnvariable="portalcats">
			
			
			<!--- get the list of instructions by category, if selected --->
			<cfinvoke component="apis.com.system.portalinstructions" method="getportalinstructions" returnvariable="portalinstruct">				
				<cfif structkeyexists( form, "instructcat" ) and form.instructcat is not "">
					<cfinvokeargument name="instructcat" value="#trim( form.instructcat )#">
				</cfif>				
			</cfinvoke>			
			
			<!--- // get the detail --->
			<cfif structkeyexists( url, "fuseaction" ) and url.fuseaction is "editinstructions">
				<cfif structkeyexists( url, "iid" ) and ( isvalid( "uuid", url.iid ) or url.iid eq 0 )>
					<cfinvoke component="apis.com.system.portalinstructions" method="getportalinstructdetail" returnvariable="portalinstructdetail">
						<cfinvokeargument name="iid" value="#url.iid#">
					</cfinvoke>
				</cfif>
			</cfif>
			
			
			
			<!--- delete the instruction record --->
			<cfif structkeyexists( url, "fuseaction" ) and url.fuseaction is "deleteinstructions">
				<cfparam name="iid" default="#url.iid#">
				<cfif structkeyexists( url, "iid" ) and isvalid( "uuid", url.iid )>
					<cfset iid = #trim( url.iid )# />
					<cfquery datasource="#application.dsn#" name="deleteinstruction">
						delete from portalinstructions
						 where instructuuid = <cfqueryparam value="#iid#" cfsqltype="cf_sql_varchar" maxlength="35" />					  
					</cfquery>
					<cflocation url="#application.root#?event=#url.event#&msg=deleted" addtoken="no" />
				</cfif>
			</cfif>
			
			
			
			<!--- // include the tinymce js path --->
			<script src="//tinymce.cachefly.net/4.0/tinymce.min.js"></script>
			
			<!--- // initialize tinymce --->
			<script type="text/javascript">
				tinymce.init({
					selector: "textarea",
					auto_focus: "ibody",
					plugins: ["code, table"],
					width: 860,
					height: 400,
					paste_as_text: true,
					toolbar: "sizeselect | bold italic | fontselect | fontsizeselect",
					font_size_style_values: ["8px,10px,12px,13px,14px,16px,18px,20px"],
				});
			</script>
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			<div class="main">
			
				<div class="container">
				
					<div class="row">
						
						<div class="span12">						
						
								<!--- // show system messages --->								
								<cfif structkeyexists( url, "msg" ) and url.msg is "saved">						
									<div class="row">
										<div class="span12">										
											<div class="alert alert-success">
												<button type="button" class="close" data-dismiss="alert">&times;</button>
												<strong><i class="icon-check"></i> SUCCESS!</strong>  The portal instructions were successfully saved.  Please select a new record to continue...
											</div>										
										</div>								
									</div>
								<cfelseif structkeyexists( url, "msg" ) and url.msg is "added">						
									<div class="row">
										<div class="span12">										
											<div class="alert alert-info">
												<button type="button" class="close" data-dismiss="alert">&times;</button>
												<strong>SUCCESS!</strong>  The portal instruction record was successfully added to the system.  Please select a new record to continue...
											</div>										
										</div>								
									</div>
								<cfelseif structkeyexists( url, "msg" ) and url.msg is "deleted">						
									<div class="row">
										<div class="span12">										
											<div class="alert alert-notice">
												<button type="button" class="close" data-dismiss="alert">&times;</button>
												<strong>SUCCESS!</strong>  The portal instruction record was successfully deleted.  Please select a new record to continue...
											</div>										
										</div>								
									</div>
								<cfelseif structkeyexists( url, "msg" ) and url.msg is "error">						
									<div class="row">
										<div class="span12">										
											<div class="alert alert-error">
												<button type="button" class="close" data-dismiss="alert">&times;</button>
												<strong>SYSTEM ERROR!</strong>  Sorry, the record could not be deleted due to a system error.  Please use the navigation in the sidebar to continue...
											</div>										
										</div>								
									</div>
								</cfif>
						
									<div class="widget stacked">
										
										<div class="widget-header">
											<i class="icon-bookmark"></i>
											<h3>Manage Client Portal Instructions Content</h3>
										</div>
										
										<div class="widget-content">
										
											
											<!--- // begin form processing --->
											<cfif isDefined("form.fieldnames") and not isdefined( "form.instructcat" )>
												<cfscript>
													objValidation = createObject("component","apis.com.ui.validation").init();
													objValidation.setFields(form);
													objValidation.validate();
												</cfscript>

												<cfif objValidation.getErrorCount() is 0>							
													
													<!--- define our structure and set form values --->
													<cfset iportal = structnew() />													
													<cfset iportal.instructcategory = #trim( form.instructcategory )# />
													<cfset iportal.instructtext = #urlencodedformat( form.instructtext )# />
													<cfset iportal.instructorder = #form.instructorder# />
													<cfset iportal.iid = #form.iid# />
																								
													<!--- // some other variables --->
													<cfset today = #CreateODBCDateTime(now())# />											
																								
													<cfif iportal.iid eq 0>									
														<cfset iportal.newuuid = #createuuid()# />
														<!--- // create the database record --->
														<cfquery datasource="#application.dsn#" name="addinstructions">
															insert into portalinstructions(instructuuid, instructcategory, instructtext, instructorder)
																values (
																		<cfqueryparam value="#iportal.newuuid#" cfsqltype="cf_sql_varchar" maxlength="35" />,
																		<cfqueryparam value="#iportal.instructcategory#" cfsqltype="cf_sql_varchar" />,
																		<cfqueryparam value="#iportal.instructtext#" cfsqltype="cf_sql_varchar" />,
																		<cfqueryparam value="#iportal.instructorder#" cfsqltype="cf_sql_numeric" />
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
																		<cfqueryparam value="#session.username# added a new instruction set for the client portal." cfsqltype="cf_sql_varchar" />
																		);
														</cfquery>																					
														
														<cflocation url="#application.root#?event=#url.event#&msg=added" addtoken="no">
													
													<cfelse>																					
														
														<!--- // update the database record --->
														<cfquery datasource="#application.dsn#" name="saveplanitem">
															update portalinstructions
															   set instructcategory = <cfqueryparam value="#iportal.instructcategory#" cfsqltype="cf_sql_varchar" />,
																   instructtext = <cfqueryparam value="#iportal.instructtext#" cfsqltype="cf_sql_varchar" />,
																   instructorder = <cfqueryparam value="#iportal.instructorder#" cfsqltype="cf_sql_numeric" />
															 where instructuuid = <cfqueryparam value="#iportal.iid#" cfsqltype="cf_sql_varchar" maxlength="35" />															
														</cfquery>									
														
														<!--- // log the activity --->
														<cfquery datasource="#application.dsn#" name="logact">
															insert into activity(leadid, userid, activitydate, activitytype, activity)
																values (
																		<cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
																		<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																		<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																		<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
																		<cfqueryparam value="The user updated portal instructions for #iportal.instructcategory#." cfsqltype="cf_sql_varchar" />
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
											
											
											
											
											
										
										
											
											<cfif not structkeyexists( url, "fuseaction" )>
											
												<!--- // portal instructions filter --->									
												<cfoutput>
													<div class="well">
														<p><i class="icon-check"></i> Filter Portal Instructions</p>
														<form class="form-inline" name="filterresults" method="post">						
															<select name="instructcat" style="margin-left:5px;" class="input-xlarge" onchange="javascript:this.form.submit();">
																<option value="">Select Instructions Category</option>
																	<cfloop query="portalcats">
																		<option value="#instructcategory#"<cfif isdefined( "form.instructcat" ) and form.instructcat eq portalcats.instructcategory>selected</cfif>>#instructcategory#</option>
																	</cfloop>												
															</select>					
															<input type="hidden" name="filtermyresults" id="filtermyresults" valuue="true" />
															<button type="submit" style="margin-left:5px;" name="filterresults" class="btn btn-small btn-secondary"><i class="icon-search"></i> Filter Results</button>
															<cfif structkeyexists( form, "filtermyresults" )><button type="reset" onclick="location.href='#application.root#?event=#url.event#'" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-check"></i> Reset List</button></cfif>
														</form>
													</div>
												</cfoutput>
												<!--- // end filter --->	
												
												
												<cfoutput>
												<h5><i class="icon-th-large"></i> Found #portalinstruct.recordcount# client portal instruction record<cfif portalinstruct.recordcount gt 1>s</cfif> <cfif structkeyexists( form, "instructcat" ) and form.instructcat is not ""> for the category: #form.instructcat#</cfif>   <span class="pull-right"><a href="#application.root#?event=#url.event#&fuseaction=addnew" class="btn btn-default btn-small"><i class="icon-plus"></i> Add Instruction</a></span></h5>
												</cfoutput>
												
												
												
												<table class="table table-bordered table-striped table-highlight">
												<thead>
													<tr>
														<th width="10%">Actions</th>
														<th>Content Order</th>
														<th>Category</th>														
													</tr>
												</thead>
												<tbody>
													<cfoutput query="portalinstruct">
													<tr>
														<td class="actions">													
															<a href="#application.root#?event=#url.event#&fuseaction=editinstructions&iid=#instructuuid#" class="btn btn-mini btn-warning">
																<i class="btn-icon-only icon-ok"></i>										
															</a>
															<a href="#application.root#?event=#url.event#&fuseaction=deleteinstructions&iid=#instructuuid#" class="btn btn-mini btn-default" onclick="javascript:return confirm('Are you absolutely sure you want to delete this portal instruction record?  This action can not be undone!');">
																<i class="btn-icon-only icon-trash"></i>										
															</a>
														</td>
														<td>#instructorder#</td>												
														<td>#instructcategory#</td>																								
													</tr>
													</cfoutput>
												</tbody>
											</table>									
											
										
										<cfelseif structkeyexists( url, "fuseaction" ) and url.fuseaction is "editinstructions">
										
										
											<cfoutput>
												<h5><cfif structkeyexists( form, "instructcat" ) and form.instructcat is not "">Enter the content for the client portal instructions for category: #form.instructcat#</cfif></h5>
										
													<!-- Place this in the body of the page content --->
													<form name="edit-portal-instructions-item" action="#cgi.script_name#?event=#url.event#&fuseaction=#url.fuseaction#&iid=#url.iid#" method="post">
														
														<fieldset>										
															
															<div class="control-group" style="margin-top:5px;">											
																<label class="control-label" for="instructcategory"><strong>Portal Instruction Category</strong></label>
																<div class="controls">
																	<input type="text" name="instructcategory" id="instructcategory" class="input-xlarge" value="#portalinstructdetail.instructcategory#" />
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->
															
															<div class="control-group">											
																<label class="control-label" for="instructorder"><strong>Order</strong></label>
																<div class="controls">
																	<input type="text" name="instructorder" id="instructorder" class="input-xlarge" value="#portalinstructdetail.instructorder#" />
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->
															
															<div class="control-group">	
																<div class="controls">
																	<textarea id="ibody" name="instructtext">#urldecode( portalinstructdetail.instructtext )#</textarea>
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->
													
															<br />
															
															<div class="form-actions">													
																<button type="submit" class="btn btn-secondary" name="saveinstructions"><i class="icon-save"></i> Save Portal Instructions</button>																									
																<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.menu.portal.instructions'"><i class="icon-remove-sign"></i> Cancel</a>													
																<input name="utf8" type="hidden" value="&##955;">													
																<input type="hidden" name="iid" value="#url.iid#" />														
																<input type="hidden" name="__authToken" value="#randout#" />
																<input name="validate_require" type="hidden" value="iid|Opps, sorry... the form can not be posted due to an internal error.  Please re-load the page and try again.;instructcategory|The portal instructions category is required to save the record.;instructtext|The client portal instructions text content is required to save the record.  Please try again..." />															
															</div> <!-- /form-actions -->
													
														</fieldset>
													</form>
												</cfoutput>
										
										
										
										<cfelseif structkeyexists( url, "fuseaction" ) and url.fuseaction is "addnew">
										
										
											<cfoutput>
												<h5><cfif structkeyexists( form, "instructcat" ) and form.instructcat is not ""> Enter the content for the client portal instructions for category: #form.instructcat#</cfif></h5>
										
													<!-- Place this in the body of the page content --->
													<form name="edit-portal-instructions-item" action="#cgi.script_name#?event=#url.event#&fuseaction=#url.fuseaction#" method="post">
														
														<fieldset>										
															
															<div class="control-group" style="margin-top:5px;">											
																<label class="control-label" for="instructcategory"><strong>Portal Instruction Category</strong></label>
																<div class="controls">
																	<input type="text" name="instructcategory" id="instructcategory" class="input-xlarge" />
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->
															
															<div class="control-group">											
																<label class="control-label" for="instructorder"><strong>Order</strong></label>
																<div class="controls">
																	<input type="text" name="instructorder" id="instructorder" class="input-xlarge" />
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->
															
															<div class="control-group">	
																<div class="controls">
																	<textarea id="ibody" name="instructtext"></textarea>
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->
													
															<br />
															
															<div class="form-actions">													
																<button type="submit" class="btn btn-secondary" name="saveinstructions"><i class="icon-save"></i> Save Portal Instructions</button>																									
																<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.menu.portal.instructions'"><i class="icon-remove-sign"></i> Cancel</a>													
																<input name="utf8" type="hidden" value="&##955;">													
																<input type="hidden" name="iid" value="0" />														
																<input type="hidden" name="__authToken" value="#randout#" />
																<input name="validate_require" type="hidden" value="iid|Opps, sorry... the form can not be posted due to an internal error.  Please re-load the page and try again.;instructcategory|The portal instructions category is required to save the record.;instructtext|The client portal instructions text content is required to save the record.  Please try again..." />															
															</div> <!-- /form-actions -->
													
														</fieldset>
													</form>
												</cfoutput>
										
										
										</cfif>
										
										
										
										</div><!-- / .widget-content -->
									
									</div><!-- / .widget -->
							
						</div><!-- / .span12 -->
						
					</div><!-- / .row -->
					<div style="margin-top:200px"></div>
				</div><!-- / .container -->			
			
			</div><!-- / .main -->