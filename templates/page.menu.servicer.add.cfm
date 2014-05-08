
				
					
				
				
				<!--- define our form variables --->
				<cfparam name="servname" default="">
				<cfparam name="servtype" default="">
				<cfparam name="servadd1" default="">
				<cfparam name="servadd2" default="">
				<cfparam name="servcity" default="">
				<cfparam name="servstate" default="">
				<cfparam name="servzip" default="">
				<cfparam name="servphone" default="">
				<cfparam name="servphone2" default="">
				<cfparam name="servfax" default="">
				<cfparam name="servfax2" default="">
				<cfparam name="servemail" default="">
				
				
				
				<!--- // create new lead inquiry --->	
			
				<div class="container">
					<div class="row">
			
						<div class="span12">
							
							<div class="widget stacked">
								
								<div class="widget-header">		
									<i class="icon-user"></i>							
									<h3>Add New Loan Servicer</h3>						
								</div> <!-- /.widget-header -->
								
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
											<cfset serv = structnew() />
											<cfset serv.type = #form.servtype# />
											<cfset serv.name = #form.servname# />
											<cfset serv.add1 = #form.servadd1# />
											<cfset serv.add2 = #form.servadd2# />
											<cfset serv.city = #form.servcity# />
											<cfset serv.state = #ucase(form.servstate)# />
											<cfset serv.zip = #form.servzip# />
											<cfset serv.email = #form.servemail# />
											<cfset serv.phone = #form.servphone# />
											<cfset serv.phone2 = #form.servphone2# />
											<cfset serv.fax = #form.servfax# />
											<cfset serv.fax2 = #form.servfax2# />	
											
											<!--- // manipulate some strings for proper case --->											
											<cfset serv.phone = rereplace(serv.phone, "[-]", "", "all") />
											<cfset serv.phone2 = rereplace(serv.phone2, "[-]", "", "all") />
											<cfset serv.fax = rereplace(serv.fax, "[-]", "", "all") />
											<cfset serv.fax2 = rereplace(serv.fax2, "[-]", "", "all") />
											<cfset today = #CreateODBCDateTime(now())# />
										
											<cfquery datasource="#application.dsn#" name="addservicer">
												insert into servicers(servname, servtype, servadd1, servadd2, servcity, servstate, servzip, servphone, servphone2, servfax, servfax2, servemail, servactive)
													values (
															<cfqueryparam value="#serv.name#" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#serv.type#" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#serv.add1#" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#serv.add2#" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#serv.city#" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#serv.state#" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#serv.zip#" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#serv.phone#" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#serv.phone2#" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#serv.fax#" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#serv.fax2#" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#serv.email#" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="1" cfsqltype="cf_sql_bit" />
														   ); 
											</cfquery>
											
											<cfquery datasource="#application.dsn#" name="logact">
												insert into activity(leadid, userid, activitydate, activitytype, activity)
													values (
															<cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#today#" cfsqltype="cf_sql_date" />,
															<cfqueryparam value="Record Added" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#session.username# added a new loan servicer to the system" cfsqltype="cf_sql_varchar" />
															);
											</cfquery>

											<cflocation url="#application.root#?event=page.menu.servicers&msg=added" addtoken="no">
								
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
									
									
									<div class="tab-pane active" id="newservicer">
										<cfoutput>	
										<form id="newservicer-profile" class="form-horizontal" method="post" action="#cgi.script_name#?event=#url.event#">
											<fieldset>									
												<br />
												
												<div class="control-group">									
													<label class="control-label" for="servtype">Servicer Type</label>
													<div class="controls">
														<select name="servtype" id="servtype">
															<option value="Federal" selected>Federal</option>
															<option value="Private">Private</option>
															<option value="Consolidation">Loan Consolidation</option>
														</select>
													</div> <!-- /controls -->				
												</div> <!-- /control-group -->
												
												<div class="control-group">											
													<label class="control-label" for="servname">Servicer Name</label>
													<div class="controls">
														<input type="text" class="input-medium span3" id="servname" name="servname">
													</div> <!-- /controls -->				
												</div> <!-- /control-group -->
													
													
												<div class="control-group">											
													<label class="control-label" for="servadd1">Address 1</label>
													<div class="controls">
														<input type="text" class="input-medium" id="servadd1" name="servadd1">
													</div> <!-- /controls -->				
												</div> <!-- /control-group -->
												
												<div class="control-group">											
													<label class="control-label" for="servadd2">Address 2</label>
													<div class="controls">
														<input type="text" class="input-medium" id="servadd2" name="servadd2">
													</div> <!-- /controls -->				
												</div> <!-- /control-group -->
												
												<div class="control-group">											
													<label class="control-label" for="servcity">City, State, Zip</label>
													<div class="controls">
														<input type="text" class="input-medium" id="servcity" name="servcity">
														<input type="text" class="input-small span1" id="servstate" name="servstate" maxlength="2">
														<input type="text" class="input-small span1" id="servzip" name="servzip" size="6" maxlength="5">													
													</div> <!-- /controls -->				
												</div> <!-- /control-group -->
												
												<div class="control-group">											
													<label class="control-label" for="servphone">Phone</label>
													<div class="controls">
														<input type="text" class="input-medium" id="servphone" name="servphone"> &nbsp; OR &nbsp; <input type="text" class="input-medium" id="servphone2" name="servphone2">
													</div> <!-- /controls -->				
												</div> <!-- /control-group -->
												
												<div class="control-group">											
													<label class="control-label" for="servfax">Fax</label>
													<div class="controls">
														<input type="text" class="input-medium" id="servfax" name="servfax"> &nbsp; OR &nbsp; <input type="text" class="input-medium" id="servfax2" name="servfax2">
													</div> <!-- /controls -->				
												</div> <!-- /control-group -->
													
													
												<div class="control-group">											
													<label class="control-label" for="servemail">Email Address</label>
													<div class="controls">
														<input type="text" class="input-large" id="servemail" name="servemail">
													</div> <!-- /controls -->				
												</div> <!-- /control-group -->							
													
												<br />												
														
												<div class="form-actions">													
													<button type="submit" class="btn btn-secondary" name="saveservicer"><i class="icon-save"></i> Save Servicer</button>																										
													<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.menu.servicers'"><i class="icon-remove-sign"></i> Cancel</a>													
													<input name="utf8" type="hidden" value="&##955;">													
													<input type="hidden" name="__authToken" value="#randout#" />
													<input name="validate_require" type="hidden" value="servtype|'Loan Servicer Type' is a required field.;servname|'Loan Servicer Name' is a required field.;servadd1|'Loan Servicer Address 1' is a required field.;servcity|'Loan Servicer City' is a required field.;servstate|'Loan Servicer State' is a required field.;servzip|'Loan Servicer Zip Code' is a required field.;servphone|'Loan Servicer Phone' is a required field." />									
													<input name="validate_email" type="hidden" value="servemail|'Loan Servicer E-mail Address' must be a valid e-mail address." />
												</div> <!-- /form-actions -->
											</fieldset>
										</form>
										</cfoutput>
									</div>							
									
									
								</div> <!-- /.widget-content -->	
									
							</div> <!-- /.widget -->
							
						</div> <!-- /.span12 -->					
					
					</div> <!-- /.row -->			
				
					
				
					<div style="height:100px;"></div>
				
				
				</div><!-- /container -->