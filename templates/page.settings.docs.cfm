


			<!--- // admin section // check user roles --->
			<cfif not isuserinrole( "admin" ) and not isuserinrole( "co-admin" )>
				<cflocation url="#application.root#?event=page.index&error=1" addtoken="yes">
			</cfif>	
			
			
			<!--- // get our data access components --->
			<cfinvoke component="apis.com.system.settingsgateway" method="getcompdetails" returnvariable="compdetails">
				<cfinvokeargument name="companyid" value="#session.companyid#">
			</cfinvoke>
			
			<cfinvoke component="apis.udfs.cleanphonenumber" method="formatphonenumber" returnvariable="phonenumber">
				<cfinvokeargument name="phonenumber" value="#compdetails.phone#">
			</cfinvoke>
			
			
			
			
			
			
			
			
			
			<div class="main">
			
				<div class="container">					
					
					<div class="row">
					
						<div class="span12">
						
							
							<!--- // show system alerts & messages --->
							<cfif structkeyexists( url, "msg" ) and url.msg is "saved">								
								<div class="alert alert-info">
									<button type="button" class="close" data-dismiss="alert">&times;</button>
									<h4><i style="font-weight:bold;" class="icon-check"></i> COMPANY SETTINGS SAVED!</h4>
									<p>The company settings were successfully updated.  It is now safe to navigate away from this page...</p>
								</div>				
							</cfif>						
						
							<div class="widget stacked">
							
								<!--- // form processing --->
									<cfif isDefined("form.fieldnames")>
										<cfscript>
											objValidation = createObject( "component","apis.com.ui.validation" ).init();
											objValidation.setFields(form);
											objValidation.validate();
										</cfscript>

										<cfif objValidation.getErrorCount() is 0>							
											
											<!--- define our structure and set form values--->
											<cfset stat = structnew() />
											<cfset stat.compid = compdetails.companyid />											
											<cfset stat.enrollagreepath = trim( form.enrollagreepath ) />
											<cfset stat.implagreepath = trim( form.implagreepath ) />
											<cfset stat.esignagreepath1 = trim( form.esignagreepath1 ) />
																						
											<!--- // some other variables --->
											<cfset today = #CreateODBCDateTime(now())# />								
											
																															
											<!--- // update the company settings --->
											<cfquery datasource="#application.dsn#" name="savesettings">
												update company
												   set enrollagreepath = <cfqueryparam value="#stat.enrollagreepath#" cfsqltype="cf_sql_varchar" />,
													   implagreepath = <cfqueryparam value="#stat.implagreepath#" cfsqltype="cf_sql_varchar" />,
													   esignagreepath1 = <cfqueryparam value="#stat.esignagreepath1#" cfsqltype="cf_sql_varchar" />													   
											     where companyid = <cfqueryparam value="#stat.compid#" cfsqltype="cf_sql_integer" /> 
											</cfquery>																			
											
											<!--- // log the client activity --->
											<cfquery datasource="#application.dsn#" name="logact">
												insert into activity(leadid, userid, activitydate, activitytype, activity)
													values (
															<cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
															<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#session.username# saved the company settings for #compdetails.companyname#" cfsqltype="cf_sql_varchar" />
															);
											</cfquery>																				
											
											<!--- // redirect to save message --->
											<cflocation url="#application.root#?event=#url.event#&msg=saved" addtoken="no">											
											
								
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
									<!--- // end form processing --->
								
								
							
							
							
								
								<cfoutput>
									
									
									<div class="widget-header">
										<i class="icon-cogs"></i>
										<h3>System Settings for #compdetails.companyname#</h3>
									</div>
								
								
										<div class="widget-content">								
									
											<ul class="nav nav-tabs">
												<li><a href="#application.root#?event=page.settings">Company Summary</a></li>
												<li><a href="#application.root#?event=page.settings.api">API Key</a></li>
												<li><a href="#application.root#?event=page.settings.welcomemessage">Welcome Message</a></li>
												<li><a href="#application.root#?event=page.settings.webservices">Webservices</a></li>										
												<li class="active"><a href="#application.root#?event=#url.event#">Source Documents</a></li>
												<li><a href="#application.root#?event=page.settings.other">Other Settings</a></li>
																												
											</ul>											
												
											
											<form id="company-source-esign-docs" class="form-horizontal" method="post" action="#application.root#?event=#url.event#">
																			
												<fieldset>														
															
															<div class="control-group">											
																<label class="control-label" for="enrollagreepath">Enrollment Agreement</label>
																	<div class="controls">
																		<input type="text" class="input-xxlarge" name="enrollagreepath" id="enrollagreepath" value="#compdetails.enrollagreepath#" />
																		<p class="help-block">The full path to the company client enrollment agreement in PDF format.  For pre-populating forms.</p>
																	</div> <!-- /controls -->				
															</div> <!-- /control-group -->
															
															<div class="control-group">											
																<label class="control-label" for="implagreepath">Implementation Agreement</label>
																	<div class="controls">
																		<input type="text" class="input-xxlarge" name="implagreepath" id="implagreepath" value="#compdetails.implagreepath#" />
																		<p class="help-block">The full path to the company implementation client agreement in PDF format.  For pre-populating forms.</p>
																	</div> <!-- /controls -->				
															</div> <!-- /control-group -->
															
															<div class="control-group">											
																<label class="control-label" for="enrollagreepath">Portal ESIGN Agreement</label>
																	<div class="controls">
																		<input type="text" class="input-xxlarge" name="esignagreepath1" id="esignagreepath1" value="#compdetails.esignagreepath1#" />
																		<p class="help-block">The full path to the company client portal enrollment agreement in PDF format.  Auto-generated document upon completion of e-sign.</p>
																	</div> <!-- /controls -->				
															</div> <!-- /control-group -->							
															
															<div class="form-actions">													
																<button type="submit" class="btn btn-secondary" name="savesettings"><i class="icon-save"></i> Save Source Documents</button>																
																<a href="#application.root#?event=page.index" class="btn btn-medium btn-primary"><i class="icon-remove-sign"></i> Cancel</a>
																<input name="utf8" type="hidden" value="&##955;">							
																<input type="hidden" name="compid" value="#compdetails.companyid#" />
																<input type="hidden" name="__authToken" value="#randout#" />
																<input name="validate_require" type="hidden" value="enrollagreepath|The enrollment agreement path is required to save this record.;esignagreepath1|The ESIGN enrollment agreement is required to save this record." />
															</div> <!-- /form-actions -->
															
																				
												</fieldset>
											</form>											
									
										</div><!-- / .widget-content -->
								
								
								</cfoutput>								
								
							</div><!-- / .widget -->
						
						</div><!-- / .span12 -->
					
					</div><!-- / . row -->				
					
				</div><!-- / . container -->
			
			</div><!-- / .main -->
			
			
			
			