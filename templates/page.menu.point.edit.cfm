

				<!--- // get our data access components --->
				<cfinvoke component="apis.com.system.pointsgateway" method="getpoint" returnvariable="pointdetail">
					<cfinvokeargument name="pid" value="#url.pid#">
				</cfinvoke>
				
				
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
								
								<cfoutput>
								<div class="widget-header">		
									<i class="icon-umbrella"></i>							
									<h3>Edit Option Tree Loan Type Category Clarifying Point #pointdetail.title#</h3>						
								</div> <!-- /.widget-header -->
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
											
											<!--- define our structure and set form values --->
											<cfset point = structnew() />
											<cfset point.puuid = #createuuid()# />
											<cfset point.pointid = #form.pointid# />
											<cfset point.type = #form.pointtype# />
											<cfset point.tree = #form.optiontree# />
											<cfset point.title = #form.pointtitle# />
											<cfset point.porder = #form.pointorder# />
											<cfif isdefined( "form.redflag" )>
												<cfset point.redflag = 1 />
											<cfelse>
												<cfset point.redflag = 0 />
											</cfif>
																				
											<!--- // manipulate some strings for proper case --->											
											<cfset point.ptext = #urlencodedformat( form.pointtext )# />
											<cfif point.porder is "">
												<cfset point.porder = 0 />
											</cfif>
											<cfset today = #CreateODBCDateTime(now())# />
										
											<cfquery datasource="#application.dsn#" name="saveclarifyingpoint">
												update clarifyingpoints
												   set pointuuid = <cfqueryparam value="#point.puuid#" cfsqltype="cf_sql_varchar" maxlength="35" />,
													   optiontree = <cfqueryparam value="#point.tree#" cfsqltype="cf_sql_varchar" />,
													   pointtype = <cfqueryparam value="#point.type#" cfsqltype="cf_sql_varchar" maxlength="250" />,
													   title = <cfqueryparam value="#point.title#" cfsqltype="cf_sql_varchar" />,
													   pointtext = <cfqueryparam value="#point.ptext#" cfsqltype="cf_sql_varchar" />,
													   pointorder = <cfqueryparam value="#point.porder#" cfsqltype="cf_sql_numeric" />,
													   redflag = <cfqueryparam value="#point.redflag#" cfsqltype="cf_sql_bit" />
												 where pointid = <cfqueryparam value="#point.pointid#" cfsqltype="cf_sql_integer" />
											</cfquery>
											
											<cfquery datasource="#application.dsn#" name="logact">
												insert into activity(leadid, userid, activitydate, activitytype, activity)
													values (
															<cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#today#" cfsqltype="cf_sql_date" />,
															<cfqueryparam value="Record Added" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#session.username# updated option tree sub category clarifying point #point.title#." cfsqltype="cf_sql_varchar" />
															);
											</cfquery>

											<cflocation url="#application.root#?event=page.menu.points&msg=saved&filter=true" addtoken="no">
								
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
									
									
									<div class="tab-pane active" id="clarpoint">
										
										<cfoutput>	
										<form id="savepoint-profile" class="form-horizontal" method="post" action="#cgi.script_name#?event=#url.event#&pID=#url.pid#">
											<fieldset>									
												<br />
												
												<div class="control-group">									
													<label class="control-label" for="optiontree">Sub Categories</label>
													<div class="controls">
														<select name="optiontree" id="optiontree" size="7" multiple>
															<option value="1"<cfif listcontains( pointdetail.optiontree, "1" )>selected</cfif>>Direct Loans</option>
															<option value="2"<cfif listcontains( pointdetail.optiontree, "2" )>selected</cfif>>FFEL Loans</option>
															<option value="3"<cfif listcontains( pointdetail.optiontree, "3" )>selected</cfif>>Perkins/Need Based Loans</option>
															<option value="4"<cfif listcontains( pointdetail.optiontree, "4" )>selected</cfif>>Direct Consolidation Loans</option>
															<option value="5"<cfif listcontains( pointdetail.optiontree, "5" )>selected</cfif>>Health Professional Loans</option>
															<option value="6"<cfif listcontains( pointdetail.optiontree, "6" )>selected</cfif>>Parent PLUS Loans</option>
															<option value="7"<cfif listcontains( pointdetail.optiontree, "7" )>selected</cfif>>Private Loans</option>
														</select><br />
														<p class="help-block"><small>This is a multi-select field.  Ctrl-Click to select multiple options.</small></p>
													</div> <!-- /controls -->				
												</div> <!-- /control-group -->
												
												<div class="control-group">											
													<label class="control-label" for="pointtitle">Title</label>
													<div class="controls">
														<input type="text" class="input-medium span4" id="pointtitle" name="pointtitle" maxlength="50" value="#pointdetail.title#" />
													</div> <!-- /controls -->				
												</div> <!-- /control-group -->
												
												<div class="control-group">											
													<label class="control-label" for="pointtype">Type</label>
													<div class="controls">
														<textarea name="pointtype" id="pointtype" class="input-large span8" rows="2">#urldecode( pointdetail.pointtype )#</textarea>
													</div> <!-- /controls -->				
												</div> <!-- /control-group -->											
												
												<div class="control-group">											
													<label class="control-label" for="pointtext">Point Text</label>
													<div class="controls">
														<textarea name="pointtext" id="pointtext" class="input-large span8" rows="8">#urldecode( pointdetail.pointtext )#</textarea> 
													</div> <!-- /controls -->				
												</div> <!-- /control-group -->
												
												<div class="control-group">
													<label class="control-label">Red Flag</label>
														<div class="controls">
															<label class="checkbox">
																<input type="checkbox" name="redflag" value="1"<cfif pointdetail.redflag eq 1>checked</cfif>>
																 Set as Red Flag Point
															</label>
															<p class="help-block"><strong>Note:</strong> Red flags will appear highlighted in the option tree claryifying points.</p>			              
														</div>
												</div>
												
												<div class="control-group">											
													<label class="control-label" for="pointorder">Point Order</label>
													<div class="controls">
														<input type="text" class="input-medium span1" name="pointorder" maxlength="2" value="#pointdetail.pointorder#" />
													</div> <!-- /controls -->				
												</div> <!-- /control-group -->
												
																			
													
												<br />												
														
												<div class="form-actions">													
													<button type="submit" class="btn btn-secondary" name="savepoint"><i class="icon-save"></i> Save Clarifying Point</button>																										
													<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.menu.points'"><i class="icon-remove-sign"></i> Cancel</a>													
													<input name="utf8" type="hidden" value="&##955;">													
													<input type="hidden" name="pointid" value="#pointdetail.pointid#" />
													<input type="hidden" name="__authToken" value="#randout#" />
													<input name="validate_require" type="hidden" value="optiontree|'Please select at least 1 sub category'.;pointtitle|'Please enter a short title for this point'.;pointtype|'Please enter the category types'.;pointtext|Please enter the clarifying point text.  This is a required field." />								
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