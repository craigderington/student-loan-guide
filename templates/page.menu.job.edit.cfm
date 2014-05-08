


			<!-- get our data component and populate table --->
			<cfinvoke component="apis.com.system.settingsgateway" method="getjobdetail" returnvariable="jobdetail">
				<cfinvokeargument name="jobid" value="#url.jobid#">
			</cfinvoke>
			
			
			<!--- declare our form vars --->
			<cfparam name="jobid" default="">
			<cfparam name="jobuuid" default="">
			<cfparam name="jobname" default="">
			<cfparam name="jobstatus" default="">
			<cfparam name="perk8087" default="">
			<cfparam name="perkpre80" default="">
			<cfparam name="perk8793" default="">
			<cfparam name="perkafter93" default="">

			
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
							
							<div class="widget stacked">
								
								<cfoutput>
								<div class="widget-header">		
									<i class="icon-briefcase"></i>							
									<h3>Modify #left(jobdetail.condition,20)#... </h3>						
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
											<cfset job = structnew() />
											<cfset job.jobid = #form.jobid# />
											<cfset job.jobuuid = #createuuid()# />
											<cfset job.jobname = #form.jobname# />
																						
											
											<cfif isdefined("form.jobstatus")>
												<cfset job.status = 1 />
											<cfelse>
												<cfset job.status = 0 />
											</cfif>	

											<cfif isdefined("form.perk8087")>
												<cfset job.perk8087 = 1 />
											<cfelse>
												<cfset job.perk8087 = 0 />
											</cfif>	
											
											<cfif isdefined("form.perkpre80")>
												<cfset job.perkpre80 = 1 />
											<cfelse>
												<cfset job.perkpre80 = 0 />
											</cfif>

											<cfif isdefined("form.perk8793")>
												<cfset job.perk8793 = 1 />
											<cfelse>
												<cfset job.perk8793 = 0 />
											</cfif>
											
											<cfif isdefined("form.perkafter93")>
												<cfset job.perkafter93 = 1 />
											<cfelse>
												<cfset job.perkafter93 = 0 />
											</cfif>
											
											<cfset today = #CreateODBCDateTime(now())# />
										
											
											<cfquery datasource="#application.dsn#" name="savecondition">
												update conditions													
												   set condition = <cfqueryparam value="#job.jobname#" cfsqltype="cf_sql_varchar" />,
													   conditionuuid = <cfqueryparam value="#job.jobuuid#" cfsqltype="cf_sql_varchar" maxlength="35" />,
													   perkins8087 = <cfqueryparam value="#job.perk8087#" cfsqltype="cf_sql_bit" />,
													   perkinspre80 = <cfqueryparam value="#job.perkpre80#" cfsqltype="cf_sql_bit" />,
													   perkins8793 = <cfqueryparam value="#job.perk8793#" cfsqltype="cf_sql_bit" />,
													   perkinsafter93 = <cfqueryparam value="#job.perkafter93#" cfsqltype="cf_sql_bit" />,
													   active = <cfqueryparam value="#job.status#" cfsqltype="cf_sql_bit" />												 
												 where conditionid = <cfqueryparam value="#job.jobid#" cfsqltype="cf_sql_integer" />	  
											</cfquery>
											
											
											<cfquery datasource="#application.dsn#" name="logact">
												insert into activity(leadid, userid, activitydate, activitytype, activity)
													values (
															<cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#today#" cfsqltype="cf_sql_date" />,
															<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#session.username# updated the conditions for #job.jobname# in the system." cfsqltype="cf_sql_varchar" />
															);
											</cfquery>										

											<cflocation url="#application.root#?event=page.menu.jobs&msg=saved" addtoken="no">
								
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
										<form id="editcondition-profile" class="form-horizontal" method="post" action="#application.root#?event=#url.event#&jobid=#jobdetail.conditionuuid#">
											<fieldset>									
												<br />							
												
												<div class="control-group">											
													<label class="control-label" for="jobname">Condition</label>
													<div class="controls">
														<textarea class="input-large span8" rows="6" id="jobname" name="jobname">#jobdetail.condition#</textarea>
													</div> <!-- /controls -->				
												</div> <!-- /control-group -->
												
												<div class="control-group">											
													<label class="control-label" for="perk8087">Applies to Rules</label>
													<div class="controls">														 
														
														<input type="checkbox" class="input-large" id="perk8087" name="perk8087" <cfif jobdetail.perkins8087 eq 1>checked</cfif>>
														<span style="margin-left:7px;margin-right:5px;">Perkins 1980-1987</span>
														
														<input type="checkbox" class="input-large" id="perkpre80" name="perkpre80" <cfif jobdetail.perkinspre80 eq 1>checked</cfif>>
														<span style="margin-left:7px;margin-right:5px;">Perkins Pre 1980</span> 
														
														<input type="checkbox" class="input-large" id="perk8793" name="perk8793" <cfif jobdetail.perkins8793 eq 1>checked</cfif>>
														<span style="margin-left:7px;margin-right:5px;">Perkins 1987-1993</span>
														
														<input type="checkbox" class="input-large" id="perkafter93" name="perkafter93" <cfif jobdetail.perkinsafter93 eq 1>checked</cfif>>
														<span style="margin-left:7px;margin-right:5px;">Perkins After 1993</span>
														
													</div> <!-- /controls -->				
												</div> <!-- /control-group -->					

												<div class="control-group">											
													<label class="control-label" for="jobstatus">Status</label>
													<div class="controls">
														<input type="checkbox" class="input-large" id="jobstatus" name="jobstatus" <cfif jobdetail.active eq 1>checked</cfif>>
													</div> <!-- /controls -->				
												</div> <!-- /control-group -->
													
												<br />												
														
												<div class="form-actions">													
													<button type="submit" class="btn btn-secondary" name="saveoc"><i class="icon-save"></i> Update Condition</button>																										
													<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.menu.jobs'"><i class="icon-remove-sign"></i> Cancel</a>													
													<input name="utf8" type="hidden" value="&##955;">													
													<input type="hidden" name="jobid" value="#jobdetail.conditionid#" />
													<input type="hidden" name="jobuuid" value="#jobdetail.conditionuuid#" />													
													<input type="hidden" name="__authToken" value="#randout#" />
													<input name="validate_require" type="hidden" value="jobid|Sorry, am internal error has occured and the form can no tbe posted.  Please go back and try again..." />												
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