


			<!--- // admin section // check user roles --->
			<cfif not isuserinrole( "admin" ) and not isuserinrole( "co-admin" )>
				<cflocation url="#application.root#?event=page.index&error=1" addtoken="yes">
			</cfif>
			
			<!--- // get our data access components --->
			<cfinvoke component="apis.com.system.settingsgateway" method="getcompdetails" returnvariable="compdetails">
				<cfinvokeargument name="companyid" value="#session.companyid#">
			</cfinvoke>

			<!--
			<cfinvoke component="apis.com.admin.emailtemplategateway" method="getemailtemplates" returnvariable="emailtemplatelist">
				<cfinvokeargument name="companyid" value="#session.companyid#">
			</cfinvoke>
			--->
			<!--- // include the tinymce js path --->
			<script src="//tinymce.cachefly.net/4.0/tinymce.min.js"></script>
			
			<!--- // initialize tinymce --->
			<script type="text/javascript">
				tinymce.init({
					selector: "textarea",
					auto_focus: "templatecontentbody",
					plugins: ["code, table"],
					width: 840,
					height: 300,
					relative_urls: false,
					convert_urls: false,
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
									<h4><i style="font-weight:bold;" class="icon-check"></i> TEMPLATE SAVED!</h4>
									<p>The email template was successfully updated.  It is now safe to navigate away from this page or select another record....</p>
								</div>				
							</cfif>						
						
							<div class="widget stacked">
							
								<!--- // form processing --->
									<cfif isDefined("form.fieldnames")>
										<cfscript>
											objValidation = createObject( "component","apis.com.ui.validation" ).init();
											objValidation.setFields( form );
											objValidation.validate();
										</cfscript>

										<cfif objValidation.getErrorCount() is 0>							
											
											<!--- define our structure and set form values--->
											<cfset et = structnew() />
											<cfset et.templateid = form.templateid />
											<cfset et.cat = form.templatecategory />
											<cfset et.templatecontent = trim( form.templatecontentbody ) />											
																						
											<!--- // some other variables --->
											<cfset today = createodbcdatetime( now() ) />										
											
												<!--- // the welcome message string is under the allowed limit , allow the update --->
												<!--- // update the company welcome message --->
												<cfquery datasource="#application.dsn#" name="savewelcomemessage">
													update emailtemplates
													   set templatecontent = <cfqueryparam value="#et.templatecontent#" cfsqltype="cf_sql_varchar" />,
														   lastupdated = <cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
														   lastupdatedby = <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />
													 where templateid = <cfqueryparam value="#et.templateid#" cfsqltype="cf_sql_integer" /> 
												</cfquery>																			
												
												<!--- // log the client activity --->
												<cfquery datasource="#application.dsn#" name="logact">
													insert into activity(leadid, userid, activitydate, activitytype, activity)
														values (
																<cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="#session.username# saved the #et.cat# email template for #compdetails.companyname#" cfsqltype="cf_sql_varchar" />
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
										<i class="icon-envelope"></i> 
										<h3>Email Templates for #compdetails.companyname#</h3>
									</div>
									
									
									
									
									<div class="widget-content">
									
										<cfif not structkeyexists( url, "fuseaction" )>									
										
											<h5><i class="icon-envelope"></i> <strong>Found #emailtemplatelist.recordcount# email templates</strong></h5>

												<table class="table table-bordered table-striped table-highlight">
													<thead>
														<tr>
															<th width="15%">Actions</th>
															<th>Category</th>												
															<th>Date Created</th>
															<th>Last Updated</th>												
														</tr>
													</thead>
													<tbody>														
														<cfloop query="emailtemplatelist">
															<tr>
																<td class="actions">												
																	<a href="#application.root#?event=#url.event#&fuseaction=edit&cat=#templatecategory#" class="btn btn-mini btn-warning">
																		<i class="btn-icon-only icon-ok"></i>										
																	</a>						
																</td>												
																<td>#templatecategory#</td>
																<td>#dateformat( templatecreatedate, "mm/dd/yyyy" )#</td>
																<td>#dateformat( lastupdated, "mm/dd/yyyy" )# by #firstname# #lastname#</td>													
															</tr>
														</cfloop>														
													</tbody>
												</table>									
										
										</cfif>
									
										
										
										
										
										<cfif structkeyexists( url, "fuseaction" ) and trim( url.fuseaction ) eq "edit">
											<cfif structkeyexists( url, "cat" ) and trim( url.cat ) neq "">
												<cfset thiscategory = trim( url.cat ) />
												
												<cfinvoke component="apis.com.admin.emailtemplategateway" method="getemailtemplatebycat" returnvariable="emailtemplate">
													<cfinvokeargument name="cat" value="#thiscategory#">
													<cfinvokeargument name="companyid" value="#session.companyid#">
												</cfinvoke>
												
												<form style="align:left;" id="company-email-template" class="form-horizontal" method="post" action="#application.root#?event=#url.event#">
																			
													<textarea id="templatecontentbody" name="templatecontentbody"><cfif isdefined( "form.templatecontentbody" )>#trim( form.templatecontentbody )#<cfelse>#emailtemplate.templatecontent#</cfif></textarea>
																
															
													<br />					
																
														<div class="form-actions">													
															<button type="submit" class="btn btn-secondary" name="savewelcomemessage"><i class="icon-save"></i> Save Email Template</button>																
															<a href="#application.root#?event=page.settings.emailtemplates" class="btn btn-medium btn-primary"><i class="icon-remove-sign"></i> Cancel</a>
															<input name="utf8" type="hidden" value="&##955;">							
															<input type="hidden" name="templateid" value="#emailtemplate.templateid#" />
															<input type="hidden" name="templatecategory" value="#emailtemplate.templatecategory#" />
															<input type="hidden" name="__authToken" value="#randout#" />
															<input name="validate_require" type="hidden" value="templatecontentbody|The email template content body can not be empty.  Please try again." />
														</div> <!-- /form-actions -->																			
												
												</form>				
											</cfif>
										</cfif>
										
									</div><!-- / .widget-content -->						
								</cfoutput>
							</div><!-- / .widget -->					
						
						</div><!-- / .span12 -->
					
					</div><!-- / .row -->
					<div style="margin-top:150px;"></div>
				</div><!-- / .container -->
			
			</div><!-- / .main -->