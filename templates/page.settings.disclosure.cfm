


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
			
			<cfinvoke component="apis.com.system.companysettings" method="getcompanydisclosure" returnvariable="companydisclosure">
				<cfinvokeargument name="companyid" value="#session.companyid#">
			</cfinvoke>
			
			
			
			<!--- // include the tinymce js path --->
			<script src="//tinymce.cachefly.net/4.0/tinymce.min.js"></script>
			
			<!--- // initialize tinymce --->
			<script type="text/javascript">
				tinymce.init({
					selector: "textarea",
					auto_focus: "dsbody",
					plugins: ["code, table"],
					width: 840,
					height: 300,
					paste_as_text: true,
					toolbar: "sizeselect | bold italic | fontselect | fontsizeselect",
					font_size_style_values: ["8px,10px,12px,13px,14px,16px,18px,20px"],
				});
			</script>
			
			
			
			
			
			<div class="main">
			
				<div class="container">					
					
					<div class="row">
					
						<div class="span12">
						
							
							<!--- // show system alerts & messages --->
							<cfif structkeyexists( url, "msg" ) and url.msg is "saved">								
								<div class="alert alert-info">
									<button type="button" class="close" data-dismiss="alert">&times;</button>
									<h4><i style="font-weight:bold;" class="icon-check"></i> COMPANY DISCLOSURE STATEMENT SAVED!</h4>
									<p>The company ESIGN disclousre statement was successfully updated.  It is now safe to navigate away from this page...</p>
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
											<cfset ds = structnew() />
											<cfset ds.companyid = compdetails.companyid />											
											<cfset ds.dstext = trim( urlencodedformat( form.dstext )) />											
																						
											<!--- // some other variables --->
											<cfset today = createodbcdatetime( now() ) />										
																															
											<!--- // update the company welcome message --->
											<cfquery datasource="#application.dsn#" name="savedisclosure">
												update disclosurestatement
												   set disclosuretext = <cfqueryparam value="#ds.dstext#" cfsqltype="cf_sql_varchar" maxlength="40000" />													   												   
											     where disclosureid = <cfqueryparam value="#companydisclosure.disclosureid#" cfsqltype="cf_sql_integer" /> 
											</cfquery>																			
											
											<!--- // log the client activity --->
											<cfquery datasource="#application.dsn#" name="logact">
												insert into activity(leadid, userid, activitydate, activitytype, activity)
													values (
															<cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
															<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#session.username# saved the company ESIGN disclosure statement for #compdetails.companyname#" cfsqltype="cf_sql_varchar" />
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
										<h3>Company ESIGN Disclosure Statement for #compdetails.companyname#</h3>
									</div>
								
								
										<div class="widget-content">								
									
											<ul class="nav nav-tabs">
												<li><a href="#application.root#?event=page.settings">Company Summary</a></li>
												<li><a href="#application.root#?event=page.settings.api">API Key</a></li>
												<li><a href="#application.root#?event=#url.event#">Welcome Message</a></li>
												<li class="active"><a href="#application.root#?event=#url.event#">Disclosure Statement</a></li>
												<li><a href="#application.root#?event=page.settings.webservices">Webservices</a></li>										
												<li><a href="#application.root#?event=page.settings.docs">Source Documents</a></li>
												<li><a href="#application.root#?event=page.settings.other">Other Settings</a></li>
																												
											</ul>											
												
											
											<form style="align:left;" id="company-disclosure-statemente" class="form-horizontal" method="post" action="#application.root#?event=#url.event#">
																			
												<textarea id="dsbody" name="dstext">#urldecode( companydisclosure.disclosuretext )#</textarea>
																
															
												<br />					
															
															<div class="form-actions">													
																<button type="submit" class="btn btn-secondary" name="save-disclosure-statement"><i class="icon-save"></i> Save Disclosure</button>																
																<a href="#application.root#?event=page.settings" class="btn btn-medium btn-primary"><i class="icon-remove-sign"></i> Cancel</a>
																<input name="utf8" type="hidden" value="&##955;">							
																<input type="hidden" name="companyid" value="#compdetails.companyid#" />
																<input type="hidden" name="__authToken" value="#randout#" />
																<input name="validate_require" type="hidden" value="dstext|The disclosure text is required to save this record.  Please try again." />
															</div> <!-- /form-actions -->
															
																				
												
											</form>											
									
										</div><!-- / .widget-content -->
								
								
								</cfoutput>								
								
							</div><!-- / .widget -->
						
						</div><!-- / .span12 -->
					
					</div><!-- / . row -->				
					
				</div><!-- / . container -->
			
			</div><!-- / .main -->
			
			
			
			