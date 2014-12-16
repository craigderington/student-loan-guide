


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
											<cfset stat.compid = #compdetails.companyid# />
											<cfset stat.comptype = trim( form.comptype ) />											
											<cfset stat.achprov = trim( form.achprov ) />
											<cfset stat.achdata = trim( form.achdatafile ) />
											<cfset stat.chatcode = urlencodedformat( form.chatcode ) />
											<cfset stat.achprovid = trim( form.achprovid ) />
											
											<!--- // some other variables --->
											<cfset today = #CreateODBCDateTime(now())# />	
											
											<!--- // check for program membership --->
											<cfif isdefined( "form.adv" )>
												<cfset stat.adv = 1 />
											<cfelse>
												<cfset stat.adv = 0 />
											</cfif>
											
											<cfif isdefined( "form.imp" )>
												<cfset stat.imp = 1 />
											<cfelse>
												<cfset stat.imp = 0 />
											</cfif>
											
											<!--- // check the company active status --->
											<cfif isuserinrole( "admin" )>
												<cfif isdefined( "form.rgstatus" )>
													<cfif form.rgstatus eq 1>
														<cfset stat.status = 1 />
													<cfelse>
														<cfset stat.status = 0 />
													</cfif>
												</cfif>
											</cfif>
											
																															
											<!--- // update the company settings --->
											<cfquery datasource="#application.dsn#" name="savesettings">
												update company
												   set comptype = <cfqueryparam value="#stat.comptype#" cfsqltype="cf_sql_varchar" maxlength="2" />,
												       achprovider = <cfqueryparam value="#stat.achprov#" cfsqltype="cf_sql_varchar" />,
													   achdatafile = <cfqueryparam value="#stat.achdata#" cfsqltype="cf_sql_varchar" maxlength="500" />,
													   luckyorangecode = <cfqueryparam value="#stat.chatcode#" cfsqltype="cf_sql_varchar" />,
													   advisory = <cfqueryparam value="#stat.adv#" cfsqltype="cf_sql_bit" />,
													   implement = <cfqueryparam value="#stat.imp#" cfsqltype="cf_sql_bit" />,
													   achprovideruniqueid = <cfqueryparam value="#stat.achprovid#" cfsqltype="cf_sql_varchar" />											   
													   <cfif isuserinrole( "admin" )>
													   , active = <cfqueryparam value="#stat.status#" cfsqltype="cf_sql_bit" />
													   </cfif>
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
											<li><a href="#application.root#?event=page.settings.disclosure">Disclosure Statement</a></li>
											<li><a href="#application.root#?event=page.settings.webservices">Webservices</a></li>										
											<li><a href="#application.root#?event=page.settings.docs">Source Documents</a></li>
											<li class="active"><a href="#application.root#?event=#url.event#">Other Settings</a></li>
																											
										</ul>											
											
											
										<form id="company-other-settings" class="form-horizontal" method="post" action="#application.root#?event=#url.event#">
																			
											<fieldset>
															
															
															
															<div class="control-group">											
																<label class="control-label" for="regcode">Company Type</label>
																	<div class="controls">
																		<input type="text" class="input-mini" name="comptype" id="comptype" value="#compdetails.comptype#" maxlength="2" />
																		<p class="help-block">TE (Tax Exempt Non-Profit Business), NP (Non-Profit Business), FP (For Profit Business)</p>
																	</div> <!-- /controls -->				
															</div> <!-- /control-group -->
					
															<div class="control-group">											
																<label class="control-label" for="regcode">ACH Provider</label>
																	<div class="controls">
																		<input type="text" class="input-large" name="achprov" id="achprov" value="#compdetails.achprovider#" />
																	</div> <!-- /controls -->				
															</div> <!-- /control-group -->
															
															<div class="control-group">											
																<label class="control-label" for="regcode">ACH Provider ID</label>
																	<div class="controls">
																		<input type="text" class="input-small" name="achprovid" id="achprovid" value="#compdetails.achprovideruniqueid#" />
																	</div> <!-- /controls -->				
															</div> <!-- /control-group -->
															
															<div class="control-group">											
																<label class="control-label" for="regcode">Ach Data File</label>
																	<div class="controls">
																		<input type="text" class="input-large" name="achdatafile" id="achdatafile" value="#compdetails.achdatafile#" />
																	</div> <!-- /controls -->				
															</div> <!-- /control-group -->															
															
															<div class="control-group">
																<label class="control-label" for="adv">Program Settings</label>
																<div class="controls">
																	<label class="checkbox">
																		<input type="checkbox" name="adv" value="1"<cfif compdetails.advisory eq 1>checked</cfif> />
																		Advisory &nbsp;<small>(Enrollment and Advisory Services Only)</small>
																	</label>
																	<label class="checkbox">
																		<input type="checkbox" name="imp" value="1" <cfif compdetails.implement eq 1>checked</cfif> />
																		Implementation &nbsp;<small>(Implementation Services)</small>
																	</label>
																</div>
															</div>				
															
															<div class="control-group">											
																<label class="control-label" for="chatcode">Chat Code</label>
																	<div class="controls">
																		<textarea name="chatcode" rows="12" class="input-xxlarge span8">#urldecode( compdetails.luckyorangecode )#</textarea>
																		<p style="margin-top:3px;margin-left:3px"><i class="icon-paste"></i> Copy &amp; paste your third-party intergrated chat and analytics service javascript code.  Do not include "script" tags!
																	</div> <!-- /controls -->				
															</div> <!-- /control-group -->

															<!--- // 7-20-2014 // don't allow company admin to change this setting ---->
															<cfif isuserinrole( "admin" )>
																<div class="control-group">
																	<label class="control-label" for="rgstatus">Active Status</label>
																	<div class="controls">
																		<label class="checkbox">
																			<input type="checkbox" name="rgstatus" value="1"<cfif compdetails.active eq 1>checked</cfif> />
																			Company Active
																		</label>
																		<label class="checkbox">
																			<input type="checkbox" name="rgstatus" value="0"<cfif compdetails.active eq 0>checked</cfif> />
																			Company Inactive
																		</label>
																	</div>
																</div>
															</cfif>
															
															<div class="form-actions">													
																<button type="submit" class="btn btn-secondary" name="savesettings"><i class="icon-save"></i> Save Settings</button>																
																<a href="#application.root#?event=page.index" class="btn btn-medium btn-primary"><i class="icon-remove-sign"></i> Cancel</a>
																<input name="utf8" type="hidden" value="&##955;">							
																<input type="hidden" name="compid" value="#compdetails.companyid#" />
																<input type="hidden" name="__authToken" value="#randout#" />
																<input name="validate_require" type="hidden" value="comptype|The company business type is required." />
															</div> <!-- /form-actions -->
																				
														</fieldset>
													</form>
												</div>												
									
										</div><!-- / .widget-content -->
								
							</cfoutput>							
								
						</div><!-- / .widget -->
						
						</div><!-- / .span12 -->
					
					</div><!-- / . row -->					
					
					
				</div>
			
			</div><!-- / .main -->
			
			
			
			