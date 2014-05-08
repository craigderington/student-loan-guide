


				<!--- // option tree clarifying points // add new record --->					
				
				
				<!--- define our form variables --->
				<cfparam name="pointtitle" default="">
				<cfparam name="pointtext" default="">
				<cfparam name="optiontree" default="">
				<cfparam name="pointtype" default="">
				<cfparam name="pointuuid" default="">
				<cfparam name="pointid" default="">
				<cfparam name="pointorder" default="">
				<cfparam name="pointredflag" default="">
								
				
				
				<!--- // create new clarifying point for the library --->	
			
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
							
							<div class="widget stacked">
								
								<div class="widget-header">		
									<i class="icon-umbrella"></i>							
									<h3>Add New Option Tree Loan Type Category Clarifying Point</h3>						
								</div> <!-- /.widget-header -->
								
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
											<cfset point = structnew() />
											<cfset point.puuid = #createuuid()# />
											<cfset point.type = #trim( left( form.pointtype, 250 ))# />
											<cfset point.tree = "#form.optiontree#" />
											<cfset point.title = #form.pointtitle# />
											<cfset point.porder = #form.pointorder# />
											<cfif isdefined( "form.redflag" )>
												<cfset point.redflag = 1 />
											<cfelse>
												<cfset point.redflag = 0 />
											</cfif>
										
																				
											<!--- // manipulate some strings for proper case --->											
											<cfset point.ptext = urlencodedformat(form.pointtext) />											
											<cfset today = #CreateODBCDateTime(now())# />
										
											<cfquery datasource="#application.dsn#" name="addclarifyingpoint">
												insert into clarifyingpoints(pointuuid, optiontree, pointtype, title, pointtext, active, pointorder, redflag)
													values (
															<cfqueryparam value="#point.puuid#" cfsqltype="cf_sql_varchar" maxlength="35" />,
															<cfqueryparam value="#point.tree#" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#point.type#" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#point.title#" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#point.ptext#" cfsqltype="cf_sql_varchar" />,																												
															<cfqueryparam value="1" cfsqltype="cf_sql_bit" />,
															<cfqueryparam value="#point.porder#" cfsqltype="cf_sql_numeric" />,
															<cfqueryparam value="#point.redflag#" cfsqltype="cf_sql_bit" />
														   ); 
											</cfquery>
											
											<cfquery datasource="#application.dsn#" name="logact">
												insert into activity(leadid, userid, activitydate, activitytype, activity)
													values (
															<cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#today#" cfsqltype="cf_sql_date" />,
															<cfqueryparam value="Record Added" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#session.username# added added a new option tree loan type category clarifying point to the system." cfsqltype="cf_sql_varchar" />
															);
											</cfquery>

											<cflocation url="#application.root#?event=page.menu.points&msg=added" addtoken="no">
								
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
									
									
									<div class="tab-pane active" id="newservicer">
										<cfoutput>	
										<form id="newpoint-profile" class="form-horizontal" method="post" action="#cgi.script_name#?event=#url.event#">
											<fieldset>									
												<br />
												
												<div class="control-group">									
													<label class="control-label" for="optiontree">Loan Types</label>
													<div class="controls">
														<select name="optiontree" id="optiontree" size="7" multiple>
															<option value="1">Direct Loans</option>
															<option value="2">FFEL Loans</option>
															<option value="3">Perkins/Need Based</option>
															<option value="4">Direct Consolidation Loans</option>
															<option value="5">Health Professional Loans</option>
															<option value="6">Parent PLUS Loans</option>
															<option value="7">Private Loans</option>
														</select><br />
														<small>This is a multi-select field.  Ctrl-Click to select multiple options.</small>
													</div> <!-- /controls -->				
												</div> <!-- /control-group -->
												
												<div class="control-group">											
													<label class="control-label" for="pointtitle">Title</label>
													<div class="controls">
														<input type="text" class="input-medium span4" id="pointtitle" name="pointtitle" maxlength="50">
													</div> <!-- /controls -->				
												</div> <!-- /control-group -->
												
												<div class="control-group">											
													<label class="control-label" for="pointtype">Type</label>
													<div class="controls">
														<textarea name="pointtype" id="pointtype" class="input-large span8" rows="2"></textarea>
													</div> <!-- /controls -->				
												</div> <!-- /control-group -->											
												
												<div class="control-group">											
													<label class="control-label" for="pointtext">Point Text</label>
													<div class="controls">
														<textarea name="pointtext" id="pointtext" class="input-large span8" rows="8"></textarea> 
													</div> <!-- /controls -->				
												</div> <!-- /control-group -->
												
												<div class="control-group">
													<label class="control-label">Red Flag</label>
														<div class="controls">
															<label class="checkbox">
																<input type="checkbox" name="redflag" value="1">
																 Set as Red Flag Point
															</label>
															<p class="help-block"><strong>Note:</strong> Red flags will appear highlighted in the option tree claryifying points.</p>			              
														</div>
												</div>
												
												
												<div class="control-group">											
													<label class="control-label" for="pointorder">Point Display Order</label>
													<div class="controls">
														<input type="text" class="input-medium span1" name="pointorder" maxlength="2">
													</div> <!-- /controls -->				
												</div> <!-- /control-group -->
												
																			
													
												<br />												
														
												<div class="form-actions">													
													<button type="submit" class="btn btn-secondary" name="savepoint"><i class="icon-save"></i> Save Clarifying Point</button>																										
													<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.menu.points'"><i class="icon-remove-sign"></i> Cancel</a>													
													<input name="utf8" type="hidden" value="&##955;">													
													<input type="hidden" name="__authToken" value="#randout#" />
													<input name="validate_require" type="hidden" value="optiontree|'Please select at least 1 loan type category.';pointtitle|'Please enter a short title for this point'.;pointtype|'Please enter the category types'.;pointtext|Please enter the clarifying point text.  This is a required field." />								
												</div> <!-- /form-actions -->
											</fieldset>
										</form>
										</cfoutput>
									</div>							
									
									
								</div> <!-- /.widget-content -->	
									
							</div> <!-- /.widget -->
							
						</div> <!-- /.span12 -->					
					
					</div> <!-- /.row -->			
				
					
				
					<div style="height:100px;"></div>
				
				
				</div><!-- /container -->