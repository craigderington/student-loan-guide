


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
									<p>The company API settings were successfully updated.  It is now safe to navigate away from this page...</p>
								</div>				
							</cfif>						
						
							<div class="widget stacked">					
								
								<cfoutput>
									<div class="widget-header">
										<i class="icon-cogs"></i>
										<h3>System Settings for #compdetails.companyname#</h3>
									</div>
								
								
									<div class="widget-content">							
									
									
										<ul class="nav nav-tabs">
											<li><a href="#application.root#?event=page.settings">Company Summary</a></li>
											<li class="active"><a href="#application.root#?event=#url.event#">API Key</a></li>
											<li><a href="#application.root#?event=page.settings.welcomemessage">Welcome Message</a></li>
											<li><a href="#application.root#?event=page.settings.disclosure">Disclosure Statement</a></li>
											<li><a href="#application.root#?event=page.settings.webservices">Webservices</a></li>										
											<li><a href="#application.root#?event=page.settings.docs">Source Documents</a></li>
											<li><a href="#application.root#?event=page.settings.other">Other Settings</a></li>																											
										</ul>
															

																				
												
											<form id="company-api-license-profile" class="form-horizontal" method="post" action="#application.root#?event=#url.event#">
																			
												<fieldset>
													<br /><br />	
													<div class="control-group">											
														<label class="control-label" for="regcode">API Reg Code</label>
															<div class="controls">
																<input type="text" class="input-xxlarge" name="apiregcode" id="apirecode" readonly="true" value="#compdetails.regcode#" />
																	<p class="help-block">This unique code must be used to login and validate all API requests.  This code can not be changed.</p>
																	<p class="help-block"></p>For more information about the Student Loan Advisor Online API, please <a href="#application.root#?event=page.api.docs">click here</a>.
															</div> <!-- /controls -->				
													</div> <!-- /control-group -->
															
													<div class="control-group">											
														<label class="control-label" for="numliceses">Licenses</label>
															<div class="controls">
																<input type="text" class="input-mini disabled" name="numlicenses" id="numlicenses" value="#compdetails.numlicenses#" maxlength="2" disabled />
																<p class="help-block">Total number of purchased SLA software licenses</p>
															</div> <!-- /controls -->				
													</div> <!-- /control-group -->														
															
															
													<div class="form-actions" style="margin-top:50px;">													
														<button type="submit" class="btn btn-secondary" name="savesettings" disabled><i class="icon-save"></i> Save Settings</button>																
														<a href="#application.root#?event=page.settings" class="btn btn-medium btn-primary"><i class="icon-remove-sign"></i> Cancel</a>
														<input name="utf8" type="hidden" value="&##955;">							
														<input type="hidden" name="compid" value="#compdetails.companyid#" />
														<input type="hidden" name="__authToken" value="#randout#" />
														<input name="validate_require" type="hidden" value="apiregcode|The application programming interface is required to save this record.;comptype|The company business type is required.;" />
													</div> <!-- /form-actions -->
																				
												</fieldset>
											</form>								
										
									</div><!-- / .widget-content -->								
								</cfoutput>
											
								
							</div><!-- / .widget -->
						
						</div><!-- / .span12 -->
					
					</div><!-- / . row -->					
					
					
				</div>
			
			</div><!-- / .main -->
			
			
			
			