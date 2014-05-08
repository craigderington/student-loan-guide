
			
			
			<!--- // call our data access components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#" >
			</cfinvoke>			
			
			<cfinvoke component="apis.com.leads.leadgateway" method="getleadsummary" returnvariable="leadsummary">
				<cfinvokeargument name="leadid" value="#session.leadid#" >
			</cfinvoke>			
			
			<cfinvoke component="apis.com.system.datasecure" method="getsecretkey" returnvariable="mysecretkey">
			
			
			
			<!--- declare forms vars --->			
			<cfparam name="spousefirstname" default="">
			<cfparam name="spouselastname" default="">
			<cfparam name="spousessn" default="">
			<cfparam name="spousedob" default="">
			<cfparam name="employer" default="">
			<cfparam name="occupation" default="">		
			<cfparam name="thissecretkey" default="">
			
			<!--- // set up our encrypt/decrypt chromium secret key --->
			<cfset thissecretkey = mysecretkey.thekey />
			
			<!--- // decrypt the borrowser ssn and store it in the form var --->
			<cfif leadsummary.spousessn is not "">
				<cfset spousessn = decrypt( leadsummary.spousessn, thissecretkey, "AES", "Base64" ) />
			<cfelse>
				<cfset spousessn = "none" />
			</cfif>
			
			
			<!--- implementation borrower personal data page --->
			
			
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
						
						<!--- show system messages --->
						<cfif structkeyexists( url, "msg" ) and url.msg is "saved">						
							<div class="row">
								<div class="span12">										
									<div class="alert alert-info">
										<button type="button" class="close" data-dismiss="alert">&times;</button>
										<strong><i class="icon-check"></i> SUCCESS!</strong>  The implementation spouse/partner information was successfully updated.  Please use the navigation in the sidebar to continue...
									</div>										
								</div>								
							</div>							
						</cfif>
						<!--- // end system messages --->
						
							<div class="widget stacked">
								<cfoutput>	
								<div class="widget-header">		
									<i class="icon-user"></i>							
									<h3>Implementation Enrollment Spouse or Partner Information for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
								</div> <!-- //.widget-header -->
								</cfoutput>	
							
								<div class="widget-content">
								
									<!--- // form processing --->
									<cfif isdefined( "form.fieldnames" )>
										
										<cfscript>
											objValidation = createobject( "component","apis.com.ui.validation" ).init();
											objValidation.setFields( form );
											objValidation.validate();
										</cfscript>

										<cfif objValidation.getErrorCount() is 0>							
											
											<!--- define our structure and set form values --->
											<cfset sp = structnew() />
											<cfset sp.leadid = form.leadid />
											<cfset sp.summaryid = form.leadsummaryid />
											<cfset sp.spousefirstname = trim( form.spousefirstname ) />
											<cfset sp.spouselastname = trim( form.spouselastname ) />
											<cfset sp.spousessn = encrypt( form.spousessn, thissecretkey, "AES", "Base64" ) />
											<cfset sp.spousedob = createdate( form.dobyear, form.dobmonth, form.dobday ) />											
											<cfset sp.spouseemployer = trim( form.spouseemployer ) />
											<cfset sp.spouseoccupation = trim( form.spouseoccupation ) />
																				
											
											<!--- // some other variables --->
											<cfset today = #CreateODBCDateTime(now())# />																					
											
											<cfquery datasource="#application.dsn#" name="spousepersonal">
												update slsummary
												   set spousefirstname = <cfqueryparam value="#sp.spousefirstname#" cfsqltype="cf_sql_varchar" />,
												       spouselastname = <cfqueryparam value="#sp.spouselastname#" cfsqltype="cf_sql_varchar" />,
													   spousessn = <cfqueryparam value="#sp.spousessn#" cfsqltype="cf_sql_varchar" />,
													   spousedob = <cfqueryparam value="#sp.spousedob#" cfsqltype="cf_sql_date" />,			  
													   spouseemployer = <cfqueryparam value="#sp.spouseemployer#" cfsqltype="cf_sql_varchar" />,
													   spouseoccupation = <cfqueryparam value="#sp.spouseoccupation#" cfsqltype="cf_sql_varchar" />													   
												 where summaryid = <cfqueryparam value="#sp.summaryid#" cfsqltype="cf_sql_integer" />
											</cfquery>											
											
												<!--- // log the client activity --->
												<cfquery datasource="#application.dsn#" name="logact">
													insert into activity(leadid, userid, activitydate, activitytype, activity)
														values (
																<cfqueryparam value="#sp.leadid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="#session.username# saved the implementation spouse information for #leaddetail.leadfirst# #leaddetail.leadlast#." cfsqltype="cf_sql_varchar" />
																); select @@identity as newactid
												</cfquery>
												
												<cfquery datasource="#application.dsn#">
													insert into recent(userid, leadid, activityid, recentdate)
														values (
																<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#sp.leadid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#logact.newactid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />
																);
												</cfquery>											
											
												
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
								
										<!--- // include the side bar nav --->
										<div class="span3">					
											<cfinclude template="page.implement.nav.cfm">		
										</div> <!-- /.span3 -->
			
			
										<div class="span8">
											
											<div class="tab-content">
												<cfoutput>
												<div class="tab-pane active" id="tab1">
												
													<ul class="nav nav-tabs">
														<li><a href="#application.root#?event=page.implement.personal">Borrower Information</a></li>
														<li class="active"><a href="#application.root#?event=#url.event#">Spouse/Partner Information</a></li>															
														<li><a href="#application.root#?event=page.implement.personal.references">Personal References</a></li>																															
													</ul>
													
													<h3><i class="icon-bar-chart"></i> Implementation | Spouse/Partner Information</h3>
													
													<p>For solution implementation, please enter required spouse or partner implementation form data required by the Department of Education.  You should complete the fields below to capture spouse or partner personal information to complete DOE solution implementation forms..</p>
													
													<br>
													
													<form id="edit-enrollment" class="form-horizontal" method="post" action="#application.root#?event=#url.event#" style="margin-left:10px;">
														<fieldset>				
															
															<div class="control-group">											
																<label class="control-label" for="spousefirstname">Spouse First Name</label>
																<div class="controls">
																	<input type="text" class="input-large" name="spousefirstname" value="<cfif isdefined( "form.spousefirstname" )>#form.spousefirstname#<cfelse>#leadsummary.spousefirstname#</cfif>" />
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->												
															
															<div class="control-group">											
																<label class="control-label" for="spouselastname">Spouse Last Name</label>
																<div class="controls">
																	<input type="text" class="input-large" name="spouselastname" value="<cfif isdefined( "form.spouselastname" )>#form.spouselastname#<cfelse>#leadsummary.spouselastname#</cfif>" />
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->
															
															<div class="control-group">											
																<label class="control-label" for="spousessn">Spouse SSN</label>
																<div class="controls">
																	<input type="text" class="input-large" name="spousessn" value="<cfif spousessn is not "none"><cfif isdefined( "form.spousessn" )>#form.spousessn#<cfelse>#spousessn#</cfif></cfif>" />
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->
															
															<!--- // 12-13-2013 // add date of birth --->
															<div class="control-group">											
																<label class="control-label" for="dobmonth">Spouse Date of Birth</label>
																	<div class="controls">
																		<select name="dobmonth" id="dobmonth" class="input-medium">
																			<cfloop from="1" to="12" index="month" step="1">
																				<option value="#month#"<cfif datepart( "m", leadsummary.spousedob ) eq month>selected</cfif>>#monthasstring(month)#</option>																			
																			</cfloop>																	
																		</select>&nbsp;
																		<select name="dobday" id="dobday" class="input-small">
																			<cfloop from="1" to="31" index="j">
																				<option value="#j#"<cfif datepart( "d", leadsummary.spousedob ) eq j>selected</cfif>>#j#</option>																			
																			</cfloop>																	
																		</select>&nbsp;
																		<select name="dobyear" id="dobyear" class="input-small">
																			<cfloop from="2013" to="1920" index="q" step="-1">
																				<option value="#q#"<cfif datepart( "yyyy", leadsummary.spousedob ) eq q>selected</cfif>>#q#</option>																			
																			</cfloop>																	
																		</select>
																	</div> <!-- /controls -->				
															</div> <!-- /control-group -->														
															
															<div class="control-group">											
																<label class="control-label" for="spouseemployer">Employer</label>
																<div class="controls">
																	<input type="text" class="input-large" name="spouseemployer" value="<cfif isdefined( "form.spouseemployer" )>#form.spouseemployer#<cfelse>#leadsummary.spouseemployer#</cfif>" />
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->
															
															<div class="control-group">											
																<label class="control-label" for="spouseoccupation">Occupation</label>
																<div class="controls">
																	<input type="text" class="input-large" name="spouseoccupation" value="<cfif isdefined( "form.spouseoccupation" )>#form.spouseoccupation#<cfelse>#leadsummary.spouseoccupation#</cfif>" />
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->								
														
														<!--- // form action --->
														<br />
														<div class="form-actions">													
															<button type="submit" class="btn btn-secondary" name="saveimplementationenrollment"><i class="icon-save"></i> Save Personal Data</button>							
															<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.implement.enroll'"><i class="icon-remove-sign"></i> Cancel</a>													
															<input name="utf8" type="hidden" value="&##955;">													
															<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
															<input type="hidden" name="leadsummaryid" value="#leadsummary.summaryid#" />
															<input type="hidden" name="__authToken" value="#randout#" />
															<input name="validate_require" type="hidden" value="leadid|'Lead ID' is a required field.;leadsummaryid|Opps, there was a problem and the form could not be posted.  Please check your data and try again.;spousefirstname|The borrower first name is required to save this record.;spouselastname|The borrower last name is also required.;spousessn|The borrower social security number is required." />															
														</div> <!-- /form-actions -->														
															
													</fieldset>
												</form>
																	
												</div> <!-- / .tab1 -->										 
												</cfoutput>
											</div> <!-- /.tab-content -->
											
										</div> <!-- / .span8 -->			
									
					
								</div> <!-- /. widget-content -->
							
							</div> <!-- /. widget-stacked -->
						
						</div><!-- / .span12 -->
					
					</div> <!-- / .row -->
				
				</div> <!-- / .container -->
			
			</div> <!-- / .main -->
		
		
		