





				<!--- user manual documentation page --->				  
					  
					  
					  
				<!--- // get our data access components --->
				<cfinvoke component="apis.com.system.usermanualgateway" method="getusermanual" returnvariable="usermanual">
					<cfif structkeyexists( url, "section" ) and url.section neq "">
						<cfinvokeargument name="section" value="#trim( url.section )#">
					</cfif>
				</cfinvoke>
				
				<!--- // get our data access components --->
				<cfinvoke component="apis.com.system.usermanualgateway" method="getusermanualsidebar" returnvariable="usermanualsidebar">
				
				
				<!--- // include the tinymce js path --->
				<script src="//tinymce.cachefly.net/4.0/tinymce.min.js"></script>
				
				<!--- // initialize tinymce --->
				<script type="text/javascript">
					tinymce.init({
						selector: "textarea",
						auto_focus: "ibody",
						plugins: ["code, table"],
						width: 800,
						height: 600,
						paste_as_text: true,
						toolbar: "sizeselect | bold italic | fontselect | fontsizeselect",
						font_size_style_values: ["8px,10px,12px,13px,14px,16px,18px,20px"],
					});
				</script>
				
				<style type="text/css">
					pre {
					 white-space: pre-wrap;       /* css-3 */
					 white-space: -moz-pre-wrap;  /* Mozilla, since 1999 */
					 white-space: -pre-wrap;      /* Opera 4-6 */
					 white-space: -o-pre-wrap;    /* Opera 7 */
					 word-wrap: break-word;       /* Internet Explorer 5.5+ */
					}
				</style>
				

				<div class="main">
				
					<div class="container">
						
						
						<cfoutput>
							<div class="row">
								
								<!--- // show system messages --->								
								<cfif structkeyexists( url, "msg" ) and url.msg is "saved">								
									<div class="span12">										
										<div class="alert alert-success">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong><i class="icon-check"></i> SUCCESS!</strong>  The SLA User Manual Section Text was successfully saved.  Please select a new record to continue...
										</div>										
									</div>								
								<cfelseif structkeyexists( url, "msg" ) and url.msg is "added">						
									<div class="span12">										
										<div class="alert alert-info">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong><i class="icon-check"></i> SUCCESS!</strong>  The SLA User Manual Section was successfully added to the documenation.  Please select a new record to continue...
										</div>										
									</div>								
								</cfif>
								
								
								
								<div class="span9">
									<div class="widget stacked">							
										<div class="widget-header">		
											<i class="icon-book"></i>							
												<h3>Student Loan Advisor Online | User Manual <cfif structkeyexists( url, "section" )> | Section: #ucase( url.section )#<cfelseif structkeyexists( url, "searchresults" )> | Search Results</cfif><cfif structkeyexists( url, "fuseaction" )> | #ucase( url.fuseaction )#</cfif></h3>						
										</div> <!-- //.widget-header -->
								
								
										
										<div class="widget-content">
										
										
											<!--- // begin form processing --->
											<cfif isDefined( "form.fieldnames" ) and not isdefined( "form.search" )>
												<cfscript>
													objValidation = createobject( "component","apis.com.ui.validation" ).init();
													objValidation.setFields( form );
													objValidation.validate();
												</cfscript>

												<cfif objValidation.getErrorCount() is 0>							
													
													<!--- define our structure and set form values --->
													<cfset um = structnew() />													
													<cfset um.sectionid = trim( form.sectionid ) />
													<cfset um.sectionname = trim( form.sectionname ) />
													<cfset um.sectiontext = #urlencodedformat( form.sectiontext )# />													
													<cfset um.sid = form.sid />
																								
													<!--- // some other variables --->
													<cfset um.today = now() />											
																								
													<cfif um.sid eq 0>									
														<cfset um.newuuid = #createuuid()# />
														<!--- // create the database record --->
														<cfquery datasource="#application.dsn#" name="addnewsection">
															insert into usermanual(usermanualuuid, usermanualsection, usermanualsectionname, usermanualsectiontext, usermanualcreatedate, usermanuallastupdated, usermanuallastupdatedby)
																values (
																		<cfqueryparam value="#um.newuuid#" cfsqltype="cf_sql_varchar" maxlength="35" />,
																		<cfqueryparam value="#um.sectionid#" cfsqltype="cf_sql_varchar" />,
																		<cfqueryparam value="#um.sectionname#" cfsqltype="cf_sql_varchar" />,
																		<cfqueryparam value="#um.sectiontext#" cfsqltype="cf_sql_varchar" />,
																		<cfqueryparam value="#um.today#" cfsqltype="cf_sql_timestamp" />,
																		<cfqueryparam value="#um.today#" cfsqltype="cf_sql_timestamp" />,
																		<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />
																	   );
														</cfquery>															
														
														<cflocation url="#application.root#?event=#url.event#&msg=added" addtoken="no">
													
													<cfelse>																					
														
														<!--- // update the database record --->
														<cfquery datasource="#application.dsn#" name="saveplanitem">
															update usermanual
															   set usermanualsection = <cfqueryparam value="#um.sectionid#" cfsqltype="cf_sql_varchar" />,
																   usermanualsectionname = <cfqueryparam value="#um.sectionname#" cfsqltype="cf_sql_varchar" />,
																   usermanualsectiontext = <cfqueryparam value="#um.sectiontext#" cfsqltype="cf_sql_varchar" />,
																   usermanuallastupdated = <cfqueryparam value="#um.today#" cfsqltype="cf_sql_timestamp" />,
																   usermanuallastupdatedby = <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />
															 where usermanualid = <cfqueryparam value="#um.sid#" cfsqltype="cf_sql_integer" />															
														</cfquery>																											
														
														<cflocation url="#application.root#?event=#url.event#&msg=saved" addtoken="no">												
													
													</cfif>													
										
												<!--- if the required data is missing - throw the validation error --->
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
										
										
										
										
										
											<!--- // begin api docs --->
											
											<cfif not structkeyexists( url, "section" ) and not structkeyexists( url, "searchresults" ) and not structkeyexists( url, "fuseaction" )>
											
												<i class="icon-info-sign"></i> The Student Loan Advisor Online User Manual is provided for your reference.  Please search the manual for specific features.
												
												<br />									
												
												<h5 style="margin-top:20px;">
												<i class="icon-book"></i> Table Of Contents</h5>							
												
												
												<ul style="list-style:none;">													
													<!-- // output the list of api docs sections --->
													<cfloop query="usermanual">
														<li><cfif isuserinrole( "admin" )><a href="#application.root#?event=#url.event#&fuseaction=editsection&section=#usermanualsection#"><i style="margin-right:5px;" class="icon-edit"></i></a></cfif><i class="icon-bookmark"></i> <a href="#application.root#?event=#url.event#&section=#usermanualsection#">#usermanualsectionname#</a></li>
													</cfloop>													
												</ul>
												<div style="margin-top:100px;"></div>
												<div style="float:right;margin-top:25px;">
													<cfif isuserinrole( "admin" )>
														<a href="#application.root#?event=#url.event#&fuseaction=addsection"><i class="icon-plus-sign"></i> Add Section</a>													
													</cfif>
												</div>				
												
												
											</cfif>
											
											
											<cfif ( structkeyexists( url, "section" ))  and ( not structkeyexists( url, "fuseaction" )) and ( not structkeyexists( url, "searchresults" )) >
												
												<!--- // bredcrumbs --->
												<p style="margin-top:-10px;margin-bottom:25px;"><a href="#application.root#?event=#url.event#"><i class="icon-circle-arrow-left"></i> Return to Table of Contents</a>
												</p>
											
												<h4 style="margin-top: 25px;">
													<i class="icon-bookmark"></i>
														#usermanual.usermanualsectionname#												
												</h4>
												
													<p style="margin-top:25px;">
													
														#urldecode( usermanual.usermanualsectiontext )#
													
													</p>
																										
													
													<p style="margin-top:35px;" class="help-block">
													Document Last Updated: #dateformat( usermanual.usermanuallastupdated, "full" )# at #timeformat( usermanual.usermanuallastupdated, "hh:mm:ss tt" )#<br />
													Document Created: #dateformat( usermanual.usermanualcreatedate, "full" )# at at #timeformat( usermanual.usermanualcreatedate, "hh:mm:ss tt" )#
													
													
													</p>
													
													<p class="help-block">
													By: #usermanual.firstname# #usermanual.lastname# <small><a style="margin-left:10px;" href="mailto:craig@efiscal.net?subject=Web Services&body=Login Service"><i class="icon-envelope"></i> Discuss This Page</a></small>
													</p>
											
											
													<p style="margin-top:100px;">
													
														<cfif isuserinrole( "admin" )><a href="#application.root#?event=#url.event#&fuseaction=editsection&section=#usermanual.usermanualsection#"><i class="icon-edit"></i> Edit Section</a></cfif>
													
													</p>
											
											
											</cfif>
											
											<cfif structkeyexists( url, "searchresults" ) and ( not structkeyexists( url, "fuseaction" )) and ( not structkeyexists( url, "section" ))>
												
												<cfif structkeyexists( form, "search" ) and structkeyexists( form, "__authtoken" )>
													<cfinvoke component="apis.com.system.usermanualgateway" method="getsearch" returnvariable="searchresults">
														<cfinvokeargument name="search" value="#trim( form.search )#">
													</cfinvoke>
												</cfif>
												
												<h5><i class="icon-search"></i> Search Results <span class="pull-right"><small><i class="icon-home"></i> <a href="#application.root#?event=page.user.manual">SLA User Manual Home</a></span></small></h5>
												<cfif searchresults.recordcount gt 0>
												
													<p class="help-block">Your search returned #searchresults.recordcount# result<cfif searchresults.recordcount gt 1>s</cfif>.</p>
												
												
													<cfloop query="searchresults">
														<p><i class="icon-zoom-in"></i> <a href="#application.root#?event=page.user.manual&section=#usermanualsection#">#usermanualsectionname#</a>
														<small>#left( urldecode( usermanualsectiontext ), 99 )# ... <a href="#application.root#?event=page.user.manual&section=#usermanualsection#">< more ></a></small>
														</p>
														<hr style="margin-top:15px;border:1px solid ##f2f2f2;">
													</cfloop>
												<cfelse>						
													<div style="margin-top:25px;" class="alert alert-block alert-error">
														<button type="button" class="close" data-dismiss="alert">&times;</button>
														<h5><strong><i class="icon-warning-sign"></i> NOTICE:</strong></h5>
														<p>Sorry, your query did not match any user manual documents...  Please refine your query and try your search again.</span></p>
													</div>																									
												</cfif>
												
												
												
											</cfif>
											
											<cfif structkeyexists( url, "fuseaction" )>
											
												<cfif isuserinrole( "admin" )>
												
													<cfif trim( url.fuseaction ) eq "addsection">
														<!-- place this in the body of the page content --->
															
															<h5><i class="icon-plus-sign"></i> Add User Manual Documentation Section</h5>
															
															<br />
															
															<form name="add-new-user-manual-section" action="#cgi.script_name#?event=#url.event#&fuseaction=#url.fuseaction#" method="post">
																
																<fieldset>										
																	
																	<div class="control-group" style="margin-top:5px;">											
																		<label class="control-label" for="sectionid"><strong>Section ID</strong></label>
																		<div class="controls">
																			<input type="text" name="sectionid" id="sectionid" class="input-xlarge" />
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->
																	
																	<div class="control-group">											
																		<label class="control-label" for="sectionname"><strong>Section Name</strong></label>
																		<div class="controls">
																			<input type="text" name="sectionname" id="sectionname" class="input-xlarge" />
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->
																	
																	<div class="control-group">	
																		<label class="control-label" for="sectiontext"><strong>Section Text</strong></label>
																		<div class="controls">
																			<textarea id="ibody" name="sectiontext"></textarea>
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->
															
																	<br />
																	
																	<div class="form-actions">													
																		<button type="submit" class="btn btn-secondary" name="savesection"><i class="icon-save"></i> Save Section</button>																									
																		<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.user.manual'"><i class="icon-remove-sign"></i> Cancel</a>													
																		<input name="utf8" type="hidden" value="&##955;">													
																		<input type="hidden" name="sid" value="0" />														
																		<input type="hidden" name="__authToken" value="#randout#" />
																		<input name="validate_require" type="hidden" value="sid|Opps, sorry... the form can not be posted due to an internal error.  Please re-load the page and try again.;sectionid|Please enter the section identifier.;sectionname|Please enter the section name.;sectiontext|Please enter the section text." />															
																	</div> <!-- /form-actions -->
															
																</fieldset>
															</form>
													<cfelseif trim( url.fuseaction ) eq "editsection">
														<cfparam name="thissection" default="">
														<cfset thissection = rereplace( url.section , "\b(\S)(\S*)\b" , "\u\1\L\2" , "all" ) />
														<h5><i class="icon-plus-sign-alt"></i> Edit User Manual Documentation Section</h5>
															
															<br />
															
															<form name="edit-user-manual-section" action="#cgi.script_name#?event=#url.event#&fuseaction=#url.fuseaction#" method="post">
																
																<fieldset>										
																	
																	<div class="control-group" style="margin-top:5px;">											
																		<label class="control-label" for="sectionid"><strong>Section URL Identifier</strong></label>
																		<div class="controls">
																			<input type="text" name="sectionid" id="sectionid" class="input-small" value="#usermanual.usermanualsection#" />
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->
																	
																	<div class="control-group">											
																		<label class="control-label" for="sectionname"><strong>Section Name</strong></label>
																		<div class="controls">
																			<input type="text" name="sectionname" id="sectionname" class="input-xlarge" value="#usermanual.usermanualsectionname#" />
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->
																	
																	<div class="control-group">	
																		<label class="control-label" for="sectiontext"><strong>Section Text</strong></label>
																		<div class="controls">
																			<textarea id="ibody" name="sectiontext">#urldecode( usermanual.usermanualsectiontext )#</textarea>
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->
															
																	<br />
																	
																	<div class="form-actions">													
																		<button type="submit" class="btn btn-secondary" name="savesection"><i class="icon-save"></i> Save #thissection# Section</button>																									
																		<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.user.manual'"><i class="icon-remove-sign"></i> Cancel</a>													
																		<input name="utf8" type="hidden" value="&##955;">													
																		<input type="hidden" name="sid" value="#usermanual.usermanualid#" />														
																		<input type="hidden" name="__authToken" value="#randout#" />
																		<input name="validate_require" type="hidden" value="sid|Opps, sorry... the form can not be posted due to an internal error.  Please re-load the page and try again.;sectionid|Please enter the section identifier.;sectionname|Please enter the section name.;sectiontext|Please enter the section text." />															
																	</div> <!-- /form-actions -->
															
																</fieldset>
															</form>
													</cfif>
												
												
												<cfelse>
													
													<div class="alert alert-box">
														<h4><i class="icon-warning-sign"></i> SYSTEM WARNING</h4>
														<p>This feature is reserved for system administrators...</p>
													</div>
												
												</cfif><!-- / .end check admin security --->
											
											</cfif><!-- / .end check url fuseaction param -->
											
											
										
											
										</div><!-- / .widget-content -->
										
									</div><!-- / .widget -->
								</div><!-- / .span9 -->
								
								<div class="span3">
									
									<div class="widget stacked">							
										<div class="widget-header">		
											<i class="icon-search"></i>							
												<h3>Search User Manual</h3>						
										</div> <!-- //.widget-header -->
								
										<div class="widget-content">									
											<form class="form-inline" method="post" action="#application.root#?event=#url.event#&searchresults=true" name="dosearch">
												<div class="input-append">										 
													<input type="text" onblur="javascript:this.form.submit();" id="search" name="search" class="input-small" value="<cfif isdefined( "form.search" )>#trim( form.search )#</cfif>" placeholder="Search Docs" />
													<input type="hidden" name="__authToken" value="#randout#" />
													<span class="add-on"><i class="icon-search"></i></span>
												</div>
												<p style="margin-top:10px;" class="help-block">Search the Online User Manual.</p>
										   </form>
										</div>
									</div>
									
									
									<cfif (( structkeyexists( url, "section" )) or ( structkeyexists( url, "searchresults" )) or ( structkeyexists( url, "fuseaction" )))>
									
										<div class="widget stacked">							
										<div class="widget-header">		
											<i class="icon-bookmark"></i>							
												<h3>Table of Contents</h3>						
										</div> <!-- //.widget-header -->
										
										
										
											<div class="widget-content">									
											   <!-- // output the list of user manual sections --->
												<ul style="list-style:none;margin-left:-5px;">	
													<cfloop query="usermanualsidebar">
														<li style="margin-bottom:3px;"><i class="icon-bookmark" <cfif structkeyexists( url, "section" ) and ( trim( usermanualsection ) eq trim( url.section ))>style="color:##ff9900;"</cfif>></i> <a href="#application.root#?event=#url.event#&section=#usermanualsection#">#usermanualsectionname#</a></li>
													</cfloop>
												</ul>
											</div>
										
									</div>
									
									</cfif>
									
								</div><!-- / .span3 -->
							
							</div><!-- / .row -->
						</cfoutput>
						
						<cfif structkeyexists( url, "searchresults" )>
							<div style="margin-top:300px;">
							</div>
						<cfelse>
							<div style="margin-top:100px;">
							</div>
						</cfif>
					
					</div><!-- / .container -->			
				
				</div><!-- / .main -->