


			<!-- get our data component and populate table --->
			<cfinvoke component="apis.com.system.settingsgateway" method="getOCDetail" returnvariable="ocdetail">
				<cfinvokeargument name="ocid" value="#url.ocid#">
			</cfinvoke>
			
			
			<!--- declare our form vars --->
			<cfparam name="ocid" default="">
			<cfparam name="ocname" default="">
			<cfparam name="ocstatus" default="">

			
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
							
							<div class="widget stacked">
								
								<cfoutput>
								<div class="widget-header">		
									<i class="icon-briefcase"></i>							
									<h3>Modify #left(ocdetail.occupationcancelcondition,18)# </h3>						
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
											
											<!--- define our structure and set form values--->
											<cfset cancelcode = structnew() />
											<cfset cancelcode.ocid = #form.ocid# />
											<cfset cancelcode.name = #form.ocname# />
											<cfset cancelcode.status = #form.ocstatus# />
											
											
											<cfif isdefined("form.ocstatus")>
												<cfset cancelcode.status = 1 />
											<cfelse>
												<cfset cancelcode.status = 0 />
											</cfif>										
											
											<cfset today = #CreateODBCDateTime(now())# />
										
											
											<cfquery datasource="#application.dsn#" name="editservicer">
												update occupationcancel
													
												   set occupationcancelcondition = <cfqueryparam value="#cancelcode.name#" cfsqltype="cf_sql_varchar" />,													   												   													   
													   active = <cfqueryparam value="#cancelcode.status#" cfsqltype="cf_sql_bit" />
												 
												 where occupationcancelid = <cfqueryparam value="#cancelcode.ocid#" cfsqltype="cf_sql_integer" />	  
											</cfquery>
											
											
											<cfquery datasource="#application.dsn#" name="logact">
												insert into activity(leadid, userid, activitydate, activitytype, activity)
													values (
															<cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#today#" cfsqltype="cf_sql_date" />,
															<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#session.username# updated the condition for cancellation for #cancelcode.name# in the system." cfsqltype="cf_sql_varchar" />
															);
											</cfquery>										

											<cflocation url="#application.root#?event=page.menu.cancel&msg=saved" addtoken="no">
								
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
									
									
									<div class="tab-pane active" id="editcondition">
										<cfoutput>	
										<form id="editcondition-profile" class="form-horizontal" method="post" action="#cgi.script_name#?event=#url.event#&ocid=#ocdetail.occupationcancelid#">
											<fieldset>									
												<br />							
												
												
												<div class="control-group">											
													<label class="control-label" for="ocname">Condition</label>
													<div class="controls">
														<textarea class="input-large span8" rows="6" id="ocname" name="ocname">#ocdetail.occupationcancelcondition#</textarea>
													</div> <!-- /controls -->				
												</div> <!-- /control-group -->
												

												<div class="control-group">											
													<label class="control-label" for="ocstatus">Condition Active</label>
													<div class="controls">
														<input type="checkbox" class="input-large" id="ocstatus" name="ocstatus" <cfif ocdetail.active eq 1>checked</cfif>>
													</div> <!-- /controls -->				
												</div> <!-- /control-group -->
													
												<br />												
														
												<div class="form-actions">													
													<button type="submit" class="btn btn-secondary" name="saveoc"><i class="icon-save"></i> Update Condition</button>																										
													<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.menu.cancel'"><i class="icon-remove-sign"></i> Cancel</a>													
													<input name="utf8" type="hidden" value="&##955;">													
													<input type="hidden" name="ocid" value="#ocdetail.occupationcancelid#" />
													<input type="hidden" name="__authToken" value="#randout#" />
													<input name="validate_require" type="hidden" value="ocid|'Occupation Cancel ID' is a required field.;ocname|'Cancel Condition' is a required field." />												
												</div> <!-- /form-actions -->
											</fieldset>
										</form>
										</cfoutput>
									</div>
									

									<div class="clear"></div>
								</div> <!-- //.widget-content -->	
									
							</div> <!-- //.widget -->
							
						</div> <!-- //.span12 -->
						
					</div> <!-- //.row -->				
				
					<div style="height:200px;"></div>			
				
				</div> <!-- //.container -->
			
			</div> <!-- //.main -->