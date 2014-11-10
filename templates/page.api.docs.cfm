





				<!--- api documentation page 
				      fpr our web services api --->
					  
					  
					  
					  
					  
					  
				<!--- // get our data access components --->
				<cfinvoke component="apis.com.system.apidocsgateway" method="getapidocs" returnvariable="apidocs">
					<cfif structkeyexists( url, "section" ) and url.section neq "">
						<cfinvokeargument name="section" value="#trim( url.section )#">
					</cfif>
				</cfinvoke>
				
				<!--- // get our data access components --->
				<cfinvoke component="apis.com.system.apidocsgateway" method="getapidocssidebar" returnvariable="apidocssidebar">
				
				
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
									<div class="row">
										<div class="span12">										
											<div class="alert alert-success">
												<button type="button" class="close" data-dismiss="alert">&times;</button>
												<strong><i class="icon-check"></i> SUCCESS!</strong>  The API Web Services Section Text was successfully saved.  Please select a new record to continue...
											</div>										
										</div>								
									</div>
								<cfelseif structkeyexists( url, "msg" ) and url.msg is "added">						
									<div class="row">
										<div class="span12">										
											<div class="alert alert-success">
												<button type="button" class="close" data-dismiss="alert">&times;</button>
												<strong><i class="icon-check"></i> SUCCESS!</strong>  The API Web Services Section Text was successfully added to the documenation.  Please select a new record to continue...
											</div>										
										</div>								
									</div>
								</cfif>
								
								
								
								<div class="span9">
									<div class="widget stacked">							
										<div class="widget-header">		
											<i class="icon-book"></i>							
												<h3>Student Loan Advisor Online | API Documentation <cfif structkeyexists( url, "section" )> | Section: #ucase( url.section )#<cfelseif structkeyexists( url, "searchresults" )> | Search Results</cfif><cfif structkeyexists( url, "fuseaction" )> | #ucase( url.fuseaction )#</cfif></h3>						
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
													<cfset ws = structnew() />													
													<cfset ws.sectionid = trim( form.sectionid ) />
													<cfset ws.sectionname = trim( form.sectionname ) />
													<cfset ws.sectiontext = #urlencodedformat( form.sectiontext )# />													
													<cfset ws.sid = form.sid />
																								
													<!--- // some other variables --->
													<cfset ws.today = now() />											
																								
													<cfif ws.sid eq 0>									
														<cfset ws.newuuid = #createuuid()# />
														<!--- // create the database record --->
														<cfquery datasource="#application.dsn#" name="addnewsection">
															insert into apidocs(apidocsuuid, apidocssection, apidocssectionname, apidocssectiontext, apidocscreatedate, apidocslastupdated, apidocslastupdatedby)
																values (
																		<cfqueryparam value="#ws.newuuid#" cfsqltype="cf_sql_varchar" maxlength="35" />,
																		<cfqueryparam value="#ws.sectionid#" cfsqltype="cf_sql_varchar" />,
																		<cfqueryparam value="#ws.sectionname#" cfsqltype="cf_sql_varchar" />,
																		<cfqueryparam value="#ws.sectiontext#" cfsqltype="cf_sql_varchar" />,
																		<cfqueryparam value="#ws.today#" cfsqltype="cf_sql_timestamp" />,
																		<cfqueryparam value="#ws.today#" cfsqltype="cf_sql_timestamp" />,
																		<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />
																	   );
														</cfquery>															
														
														<cflocation url="#application.root#?event=#url.event#&msg=added" addtoken="no">
													
													<cfelse>																					
														
														<!--- // update the database record --->
														<cfquery datasource="#application.dsn#" name="saveplanitem">
															update apidocs
															   set apidocssection = <cfqueryparam value="#ws.sectionid#" cfsqltype="cf_sql_varchar" />,
																   apidocssectionname = <cfqueryparam value="#ws.sectionname#" cfsqltype="cf_sql_varchar" />,
																   apidocssectiontext = <cfqueryparam value="#ws.sectiontext#" cfsqltype="cf_sql_varchar" />,
																   apidocslastupdated = <cfqueryparam value="#ws.today#" cfsqltype="cf_sql_timestamp" />,
																   apidocslastupdatedby = <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />
															 where apidocsid = <cfqueryparam value="#ws.sid#" cfsqltype="cf_sql_integer" />															
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
											
												<i class="icon-info-sign"></i> The Student Loan Advisor Online API is a collection of webservices that can be consumed by any web based platforms with the ability to invoke web services and components; or make basic HTTP calls to a remote URL invoking a method and passing arguments as a collection.
												
												<br />									
												
												<h5 style="margin-top:20px;">
												<i class="icon-book"></i> Table Of Contents</h5>							
												
												
												<ul style="list-style:none;">													
													<!-- // output the list of api docs sections --->
													<cfloop query="apidocs">
														<li><cfif isuserinrole( "admin" )><a href="#application.root#?event=#url.event#&fuseaction=editsection&section=#apidocssection#"><i style="margin-right:5px;" class="icon-edit"></i></a></cfif><i class="icon-bookmark"></i> <a href="#application.root#?event=#url.event#&section=#apidocssection#">#apidocssectionname#</a></li>
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
														#apidocs.apidocssectionname#												
												</h4>
												
													<p style="margin-top:25px;">
													
														#urldecode( apidocs.apidocssectiontext )#
													
													</p>
																										
													
													<p style="margin-top:35px;" class="help-block">
													Document Last Updated: #dateformat( apidocs.apidocslastupdated, "full" )# at #timeformat( apidocs.apidocslastupdated, "hh:mm:ss tt" )#<br />
													Document Created: #dateformat( apidocs.apidocscreatedate, "full" )# at at #timeformat( apidocs.apidocscreatedate, "hh:mm:ss tt" )#
													
													
													</p>
													
													<p class="help-block">
													By: #apidocs.firstname# #apidocs.lastname# <small><a style="margin-left:10px;" href="mailto:craig@efiscal.net?subject=Web Services&body=Login Service"><i class="icon-envelope"></i> Discuss This Page</a></small>
													</p>
											
											
													<p style="margin-top:100px;">
													
														<cfif isuserinrole( "admin" )><a href="#application.root#?event=#url.event#&fuseaction=editsection&section=#apidocs.apidocssection#"><i class="icon-edit"></i> Edit Section</a></cfif>
													
													</p>
											
											
											</cfif>
											
											<cfif structkeyexists( url, "searchresults" ) and ( not structkeyexists( url, "fuseaction" )) and ( not structkeyexists( url, "section" ))>
												
												<cfif structkeyexists( form, "search" ) and structkeyexists( form, "__authtoken" )>
													<cfinvoke component="apis.com.system.apidocsgateway" method="getsearch" returnvariable="searchresults">
														<cfinvokeargument name="search" value="#trim( form.search )#">
													</cfinvoke>
												</cfif>
												
												<h5><i class="icon-search"></i> Search Results <span class="pull-right"><small><i class="icon-home"></i> <a href="#application.root#?event=page.api.docs">API Home</a></span></small></h5>
												<cfif searchresults.recordcount gt 0>
												
													<p class="help-block">Your search returned #searchresults.recordcount# result<cfif searchresults.recordcount gt 1>s</cfif>.</p>
												
												
													<cfloop query="searchresults">
														<p><i class="icon-zoom-in"></i> <a href="#application.root#?event=page.api.docs&section=#apidocssection#">#apidocssectionname#</a>
														<small>#left( urldecode( apidocssectiontext ), 199 )# ... <a href="#application.root#?event=page.api.docs&section=#apidocssection#">< more ></a></small>
														</p>
														<hr style="margin-top:15px;border:1px solid ##f2f2f2;">
													</cfloop>
												<cfelse>
													<span style="margin-top:10px;color:red;"><i class="icon-warning-sign"></i> Sorry, your query did not match any API documents...  Please refine your query and try your search again.</span>
												</cfif>
												
												
												
											</cfif>
											
											<cfif structkeyexists( url, "fuseaction" )>
											
												<cfif isuserinrole( "admin" )>
												
													<cfif trim( url.fuseaction ) eq "addsection">
														<!-- place this in the body of the page content --->
															
															<h5><i class="icon-plus-sign"></i> Add Web Services Documentation Section</h5>
															
															<br />
															
															<form name="add-new-web-services-section" action="#cgi.script_name#?event=#url.event#&fuseaction=#url.fuseaction#" method="post">
																
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
																		<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.api.docs'"><i class="icon-remove-sign"></i> Cancel</a>													
																		<input name="utf8" type="hidden" value="&##955;">													
																		<input type="hidden" name="sid" value="0" />														
																		<input type="hidden" name="__authToken" value="#randout#" />
																		<input name="validate_require" type="hidden" value="sid|Opps, sorry... the form can not be posted due to an internal error.  Please re-load the page and try again.;sectionid|Please enter the section identifier.;sectionname|Please enter the section name.;sectiontext|Please enter the section text." />															
																	</div> <!-- /form-actions -->
															
																</fieldset>
															</form>
													<cfelseif trim( url.fuseaction ) eq "editsection">
														<h5><i class="icon-plus-sign-alt"></i> Edit Web Services Documentation Section</h5>
															
															<br />
															
															<form name="add-new-web-services-section" action="#cgi.script_name#?event=#url.event#&fuseaction=#url.fuseaction#" method="post">
																
																<fieldset>										
																	
																	<div class="control-group" style="margin-top:5px;">											
																		<label class="control-label" for="sectionid"><strong>Section URL Identifier</strong></label>
																		<div class="controls">
																			<input type="text" name="sectionid" id="sectionid" class="input-small" value="#apidocs.apidocssection#" />
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->
																	
																	<div class="control-group">											
																		<label class="control-label" for="sectionname"><strong>Section Name</strong></label>
																		<div class="controls">
																			<input type="text" name="sectionname" id="sectionname" class="input-xlarge" value="#apidocs.apidocssectionname#" />
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->
																	
																	<div class="control-group">	
																		<label class="control-label" for="sectiontext"><strong>Section Text</strong></label>
																		<div class="controls">
																			<textarea id="ibody" name="sectiontext">#urldecode( apidocs.apidocssectiontext )#</textarea>
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->
															
																	<br />
																	
																	<div class="form-actions">													
																		<button type="submit" class="btn btn-secondary" name="savesection"><i class="icon-save"></i> Save Section</button>																									
																		<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.api.docs'"><i class="icon-remove-sign"></i> Cancel</a>													
																		<input name="utf8" type="hidden" value="&##955;">													
																		<input type="hidden" name="sid" value="#apidocs.apidocsid#" />														
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
												
												</cfif>
											
											</cfif>
											
											
										
											
										</div><!-- / .widget-content -->
										
									</div><!-- / .widget -->
								</div><!-- / .span9 -->
								
								<div class="span3">
									
									<div class="widget stacked">							
										<div class="widget-header">		
											<i class="icon-search"></i>							
												<h3>Search API</h3>						
										</div> <!-- //.widget-header -->
								
										<div class="widget-content">									
											<form class="form-inline" method="post" action="#application.root#?event=#url.event#&searchresults=true" name="dosearch">
												<div class="input-append">										 
													<input type="text" onblur="javascript:this.form.submit();" id="search" name="search" class="input-small" value="<cfif isdefined( "form.search" )>#trim( form.search )#</cfif>" placeholder="Search API" />
													<input type="hidden" name="__authToken" value="#randout#" />
													<span class="add-on"><i class="icon-search"></i></span>
												</div>
												<p style="margin-top:10px;" class="help-block">Search the Web Services API.</p>
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
											   <!-- // output the list of api docs sections --->
												<ul style="list-style:none;margin-left:-5px;">	
													<cfloop query="apidocssidebar">
														<li style="margin-bottom:3px;"><i class="icon-bookmark" <cfif trim( apidocssection ) eq trim( url.section )>style="color:##ff9900;"</cfif>></i> <a href="#application.root#?event=#url.event#&section=#apidocssection#">#apidocssectionname#</a></li>
													</cfloop>
												</ul>
											</div>
										
									</div>
									
									</cfif>
									
								</div><!-- / .span3 -->
							
							</div><!-- / .row -->
						</cfoutput>
						
						<div style="margin-top:100px;">
						</div>
					
					</div><!-- / .container -->			
				
				</div><!-- / .main -->