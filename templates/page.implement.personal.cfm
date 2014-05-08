
			
			
			<!--- // call our data access components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#" >
			</cfinvoke>			
			
			<cfinvoke component="apis.com.leads.leadgateway" method="getleadsummary" returnvariable="leadsummary">
				<cfinvokeargument name="leadid" value="#session.leadid#" >
			</cfinvoke>
			
			<cfinvoke component="apis.com.system.datasecure" method="getsecretkey" returnvariable="mysecretkey">
			
			
			
			<!--- declare forms vars --->			
			<cfparam name="borrowerfirstname" default="">
			<cfparam name="borrowerlastname" default="">
			<cfparam name="borrowerssn" default="">
			<cfparam name="borrowerdob" default="">			
			<cfparam name="borrowerdl" default="">
			<cfparam name="dlstate" default="">
			<cfparam name="employer" default="">
			<cfparam name="occupation" default="">
			<cfparam name="workphone" default="">
			<cfparam name="workphoneext" default="">
			<cfparam name="rgworktype" default="">
			<cfparam name="averageworkhours" default="">
			<cfparam name="thissecretkey" default="">
			
			<cfset thissecretkey = mysecretkey.thekey />
			
			<!--- // decrypt the borrowser ssn and store it in the form var --->
			<cfif leadsummary.borrowerssn is not "">
				<cfset borrowerssn = decrypt( leadsummary.borrowerssn, thissecretkey, "AES", "Base64" ) />
			<cfelse>
				<cfset borrowerssn = "none" />
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
										<strong><i class="icon-check"></i> SUCCESS!</strong>  The implementation borrower personal information was successfully updated.  Please use the navigation in the sidebar to continue...
									</div>										
								</div>								
							</div>							
						</cfif>
						<!--- // end system messages --->
						
							<div class="widget stacked">
								<cfoutput>	
								<div class="widget-header">		
									<i class="icon-user"></i>							
									<h3>Implementation Enrollment Personal Data for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
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
											<cfset brw = structnew() />
											<cfset brw.leadid = form.leadid />
											<cfset brw.summaryid = form.leadsummaryid />
											<cfset brw.borrowerfirstname = trim( form.borrowerfirstname ) />
											<cfset brw.borrowerlastname = trim( form.borrowerlastname ) />
											<cfset brw.borrowerssn = encrypt( form.borrowerssn, thissecretkey, "AES", "Base64" ) />
											<cfset brw.borrowerdob = createdate( form.dobyear, form.dobmonth, form.dobday ) />
											<cfset brw.borrowerdl = trim( form.borrowerdl ) />
											<cfset brw.dlstate = trim( form.dlstate ) />
											<cfset brw.employer = trim( form.employer ) />
											<cfset brw.occupation = trim( form.occupation ) />
											<cfset brw.workphone = trim( form.workphone ) />
											<cfset brw.workphoneext = trim( form.workphoneext ) />
											<cfset brw.worktype = trim( form.rgworktype ) />
											<cfset brw.avghours = form.avgworkhours />										
											
											<!--- // some other variables --->
											<cfset today = #CreateODBCDateTime(now())# />																					
											
											<cfquery datasource="#application.dsn#" name="borrowerpersonal">
												update slsummary
												   set borrowerfirstname = <cfqueryparam value="#brw.borrowerfirstname#" cfsqltype="cf_sql_varchar" />,
												       borrowerlastname = <cfqueryparam value="#brw.borrowerlastname#" cfsqltype="cf_sql_varchar" />,
													   borrowerssn = <cfqueryparam value="#brw.borrowerssn#" cfsqltype="cf_sql_varchar" />,
													   borrowerdob = <cfqueryparam value="#brw.borrowerdob#" cfsqltype="cf_sql_date" />,
													   borrowerdl = <cfqueryparam value="#brw.borrowerdl#" cfsqltype="cf_sql_varchar" />,
													   dlstate = <cfqueryparam value="#brw.dlstate#" cfsqltype="cf_sql_varchar" maxlength="2" />,
													   employer = <cfqueryparam value="#brw.employer#" cfsqltype="cf_sql_varchar" />,
													   occupation = <cfqueryparam value="#brw.occupation#" cfsqltype="cf_sql_varchar" />,
													   workphone = <cfqueryparam value="#brw.workphone#" cfsqltype="cf_sql_varchar" />,
													   workphoneext = <cfqueryparam value="#brw.workphoneext#" cfsqltype="cf_sql_varchar" />,
													   worktype = <cfqueryparam value="#brw.worktype#" cfsqltype="cf_sql_varchar" />,
													   avgworkhours = <cfqueryparam value="#brw.avghours#" cfsqltype="cf_sql_numeric" />
												 where summaryid = <cfqueryparam value="#brw.summaryid#" cfsqltype="cf_sql_integer" />
											</cfquery>											
											
												<!--- // log the client activity --->
												<cfquery datasource="#application.dsn#" name="logact">
													insert into activity(leadid, userid, activitydate, activitytype, activity)
														values (
																<cfqueryparam value="#brw.leadid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="#session.username# saved the implementation borrower information for #leaddetail.leadfirst# #leaddetail.leadlast#." cfsqltype="cf_sql_varchar" />
																); select @@identity as newactid
												</cfquery>
												
												<cfquery datasource="#application.dsn#">
													insert into recent(userid, leadid, activityid, recentdate)
														values (
																<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#brw.leadid#" cfsqltype="cf_sql_integer" />,
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
														<li class="active"><a href="#application.root#?event=#url.event#">Borrower Information</a></li>
														<li><a href="#application.root#?event=#url.event#.partner">Spouse/Partner Information</a></li>															
														<li><a href="#application.root#?event=#url.event#.references">Personal References</a></li>																															
													</ul>
													
													<h3><i class="icon-bar-chart"></i> Implementation | Borrower Information</h3>
													
													<p>For solution implementation, please enter required implementation form data required by the Department of Education.  You should complete the fields below to capture borrower personal information to complete DOE solution implementation forms..</p>
													
													<br>
													
													<form id="edit-enrollment" class="form-horizontal" method="post" action="#application.root#?event=#url.event#" style="margin-left:10px;">
														<fieldset>				
															
															<div class="control-group">											
																<label class="control-label" for="borrowerfirstname">Borrower First Name</label>
																<div class="controls">
																	<input type="text" class="input-large" name="borrowerfirstname" value="<cfif isdefined( "form.borrowerfirstname" )>#form.borrowerfirstname#<cfelse>#leadsummary.borrowerfirstname#</cfif>" />
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->
															
															
															
															<div class="control-group">											
																<label class="control-label" for="borrowerlastname">Borrower Last Name</label>
																<div class="controls">
																	<input type="text" class="input-large" name="borrowerlastname" value="<cfif isdefined( "form.borrowerlastname" )>#form.borrowerlastname#<cfelse>#leadsummary.borrowerlastname#</cfif>" />
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->
															
															<div class="control-group">											
																<label class="control-label" for="borrowerssn">Borrower SSN</label>
																<div class="controls">
																	<input type="text" class="input-large" name="borrowerssn" value="<cfif borrowerssn is not "none"><cfif isdefined( "form.borrowerssn" )>#form.borrowerssn#<cfelse>#borrowerssn#</cfif></cfif>" />
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->
															
															<!--- // 12-13-2013 // add date of birth --->
															<div class="control-group">											
																<label class="control-label" for="dobmonth">Borrower Date of Birth</label>
																	<div class="controls">
																		<select name="dobmonth" id="dobmonth" class="input-medium">
																			<cfloop from="1" to="12" index="month" step="1">
																				<option value="#month#"<cfif datepart( "m", leadsummary.borrowerdob ) eq month>selected</cfif>>#monthasstring(month)#</option>																			
																			</cfloop>																	
																		</select>&nbsp;
																		<select name="dobday" id="dobday" class="input-small">
																			<cfloop from="1" to="31" index="j">
																				<option value="#j#"<cfif datepart( "d", leadsummary.borrowerdob ) eq j>selected</cfif>>#j#</option>																			
																			</cfloop>																	
																		</select>&nbsp;
																		<select name="dobyear" id="dobyear" class="input-small">
																			<cfloop from="2013" to="1920" index="q" step="-1">
																				<option value="#q#"<cfif datepart( "yyyy", leadsummary.borrowerdob ) eq q>selected</cfif>>#q#</option>																			
																			</cfloop>																	
																		</select>
																	</div> <!-- /controls -->				
															</div> <!-- /control-group -->

															<div class="control-group">											
																<label class="control-label" for="borrowerdl">Drivers License ##</label>
																<div class="controls">
																	<input type="text" class="input-xlarge" name="borrowerdl" value="<cfif isdefined( "form.borrwerdl" )>#form.borrowerdl#<cfelse>#leadsummary.borrowerdl#</cfif>" />
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->
															
															
															<div class="control-group">											
																<label class="control-label" for="dlstate">DL State</label>
																<div class="controls">
																	<select name="dlstate" class="input-large">
																		<option value="">Select State</option>																				
																				<option value="AL"<cfif trim( leadsummary.dlstate ) is "AL">selected</cfif>>Alabama</option>
																				<option value="AK"<cfif trim( leadsummary.dlstate ) is "AK">selected</cfif>>Alaksa</option>
																				<option value="AZ"<cfif trim( leadsummary.dlstate ) is "AZ">selected</cfif>>Arizona</option>
																				<option value="AR"<cfif trim( leadsummary.dlstate ) is "AR">selected</cfif>>Arkansas</option>
																				<option value="CA"<cfif trim( leadsummary.dlstate ) is "CA">selected</cfif>>California</option>
																				<option value="CO"<cfif trim( leadsummary.dlstate ) is "CO">selected</cfif>>Colorado</option>
																				<option value="CT"<cfif trim( leadsummary.dlstate ) is "CT">selected</cfif>>Connecticut</option>
																				<option value="DE"<cfif trim( leadsummary.dlstate ) is "DE">selected</cfif>>Deleware</option>
																				<option value="FL"<cfif trim( leadsummary.dlstate ) is "FL">selected</cfif>>Florida</option>
																				<option value="GA"<cfif trim( leadsummary.dlstate ) is "GA">selected</cfif>>Georgia</option>
																				<option value="HI"<cfif trim( leadsummary.dlstate ) is "HI">selected</cfif>>Hawaii</option>
																				<option value="ID"<cfif trim( leadsummary.dlstate ) is "ID">selected</cfif>>Idaho</option>
																				<option value="IL"<cfif trim( leadsummary.dlstate ) is "IL">selected</cfif>>Illinois</option>
																				<option value="IN"<cfif trim( leadsummary.dlstate ) is "IN">selected</cfif>>Indiana</option>
																				<option value="IA"<cfif trim( leadsummary.dlstate ) is "IA">selected</cfif>>Iowa</option>
																				<option value="KS"<cfif trim( leadsummary.dlstate ) is "KS">selected</cfif>>Kansas</option>
																				<option value="KY"<cfif trim( leadsummary.dlstate ) is "KY">selected</cfif>>Kentucky</option>
																				<option value="LA"<cfif trim( leadsummary.dlstate ) is "LA">selected</cfif>>Louisiana</option>
																				<option value="ME"<cfif trim( leadsummary.dlstate ) is "ME">selected</cfif>>Maine</option>
																				<option value="MD"<cfif trim( leadsummary.dlstate ) is "MD">selected</cfif>>Maryland</option>
																				<option value="MA"<cfif trim( leadsummary.dlstate ) is "MA">selected</cfif>>Massachusetts</option>
																				<option value="MI"<cfif trim( leadsummary.dlstate ) is "MI">selected</cfif>>Michigan</option>
																				<option value="MN"<cfif trim( leadsummary.dlstate ) is "MN">selected</cfif>>Minnesota</option>
																				<option value="MS"<cfif trim( leadsummary.dlstate ) is "MS">selected</cfif>>Mississippi</option>
																				<option value="MO"<cfif trim( leadsummary.dlstate ) is "MO">selected</cfif>>Missouri</option>
																				<option value="MT"<cfif trim( leadsummary.dlstate ) is "MT">selected</cfif>>Montana</option>
																				<option value="NE"<cfif trim( leadsummary.dlstate ) is "NE">selected</cfif>>Nebraska</option>
																				<option value="NV"<cfif trim( leadsummary.dlstate ) is "NV">selected</cfif>>Nevada</option>
																				<option value="NH"<cfif trim( leadsummary.dlstate ) is "NH">selected</cfif>>New Hampshire</option>
																				<option value="NJ"<cfif trim( leadsummary.dlstate ) is "NJ">selected</cfif>>New Jersey</option>
																				<option value="NM"<cfif trim( leadsummary.dlstate ) is "NM">selected</cfif>>New Mexico</option>
																				<option value="NY"<cfif trim( leadsummary.dlstate ) is "NY">selected</cfif>>New York</option>
																				<option value="NC"<cfif trim( leadsummary.dlstate ) is "NC">selected</cfif>>North Carolina</option>
																				<option value="ND"<cfif trim( leadsummary.dlstate ) is "ND">selected</cfif>>North Dakota</option>
																				<option value="OH"<cfif trim( leadsummary.dlstate ) is "OH">selected</cfif>>Ohio</option>
																				<option value="OK"<cfif trim( leadsummary.dlstate ) is "OK">selected</cfif>>Oklahoma</option>
																				<option value="OR"<cfif trim( leadsummary.dlstate ) is "OR">selected</cfif>>Oregon</option>
																				<option value="PA"<cfif trim( leadsummary.dlstate ) is "PA">selected</cfif>>Pennsylvania</option>
																				<option value="RI"<cfif trim( leadsummary.dlstate ) is "RI">selected</cfif>>Rhode Island</option>
																				<option value="SC"<cfif trim( leadsummary.dlstate ) is "SC">selected</cfif>>South Carolina</option>
																				<option value="SD"<cfif trim( leadsummary.dlstate ) is "SD">selected</cfif>>South Dakota</option>
																				<option value="TN"<cfif trim( leadsummary.dlstate ) is "TN">selected</cfif>>Tennessee</option>
																				<option value="TX"<cfif trim( leadsummary.dlstate ) is "TX">selected</cfif>>Texas</option>
																				<option value="UT"<cfif trim( leadsummary.dlstate ) is "UT">selected</cfif>>Utah</option>
																				<option value="VT"<cfif trim( leadsummary.dlstate ) is "VT">selected</cfif>>Vermont</option>
																				<option value="VA"<cfif trim( leadsummary.dlstate ) is "VA">selected</cfif>>Virginia</option>
																				<option value="WA"<cfif trim( leadsummary.dlstate ) is "WA">selected</cfif>>Washington</option>
																				<option value="WV"<cfif trim( leadsummary.dlstate ) is "WV">selected</cfif>>West Virginia</option>
																				<option value="WI"<cfif trim( leadsummary.dlstate ) is "WI">selected</cfif>>Wisconsin</option>
																				<option value="WY"<cfif trim( leadsummary.dlstate ) is "WY">selected</cfif>>Wyoming</option>
																	</select>
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->
															
															<div class="control-group">											
																<label class="control-label" for="employer">Employer</label>
																<div class="controls">
																	<input type="text" class="input-large" name="employer" value="<cfif isdefined( "form.employer" )>#form.employer#<cfelse>#leadsummary.employer#</cfif>" />
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->
															
															<div class="control-group">											
																<label class="control-label" for="occupation">Occupation</label>
																<div class="controls">
																	<input type="text" class="input-large" name="occupation" value="<cfif isdefined( "form.occupation" )>#form.occupation#<cfelse>#leadsummary.occupation#</cfif>" />
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->

															<div class="control-group">											
																<label class="control-label" for="uploaddate">Work Phone</label>
																<div class="controls">
																	<input type="text" class="input-small" name="workphone" value="<cfif isdefined( "form.workphone" )>#form.workphone#<cfelse>#leadsummary.workphone#</cfif>" />&nbsp;<input type="text" class="input-mini" placeholder="Extension" name="workphoneext" value="<cfif isdefined( "form.workphoneext" )>#form.workphoneext#<cfelse>#leadsummary.workphoneext#</cfif>" />														
																</div> <!-- /controls -->				
															</div> <!-- /control-group -->
															
															<div class="control-group">
															<label class="control-label" for="rgworktype">Work Type</label>
															<div class="controls">
																<label class="radio">
																	<input type="radio" name="rgworktype" value="Full-Time" <cfif trim( leadsummary.worktype ) is "full-time">checked</cfif>>
																	Full-Time
																</label>
																<label class="radio">
																	<input type="radio" name="rgworktype" value="Part-Time" <cfif trim( leadsummary.worktype ) is "part-time">checked</cfif>>
																	Part Time
																</label>
															</div>
														</div>

														<div class="control-group">											
															<label class="control-label" for="avgworkhours">Avg Hours Per Week</label>
															<div class="controls">
																<input type="text" class="input-mini" name="avgworkhours" value="<cfif isdefined( "form.avgworkhours" )>#form.avgworkhours#<cfelse>#leadsummary.avgworkhours#</cfif>" />
																<p class="help-block">Enter the average number of work hours per week.</p>
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
															<input name="validate_require" type="hidden" value="leadid|'Lead ID' is a required field.;leadsummaryid|Opps, there was a problem and the form could not be posted.  Please check your data and try again.;borrowerfirstname|The borrower first name is required to save this record.;borrowerlastname|The borrower last name is also required.;borrowerssn|The borrower social security number is required." />															
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
		
		
		