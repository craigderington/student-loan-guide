


			<!--- // protect the admin page --->
			<cfif not isuserinrole( "admin" )>
				<cflocation url="#application.root#?event=page.index&error=1" addtoken="no">
			</cfif>


			<!--- // get our data access components --->
			<cfinvoke component="apis.com.admin.companyadmingateway" method="getcompanies" returnvariable="complist">
			
			
			<!--- // check the query string param and return selected company detail --->
			<cfif structkeyexists( url, "fuseaction" ) and structkeyexists( url, "compid" )>
				<cfinvoke component="apis.com.admin.companyadmingateway" method="getcompany" returnvariable="compdetail">
					<cfinvokeargument name="compid" value="#url.compid#">
				</cfinvoke>
			</cfif>
			
			
			<!--- define forms vars --->
			<cfparam name="compid" default="">
			<cfparam name="compname" default="">
			<cfparam name="compadd1" default="">
			<cfparam name="compadd2" default="">
			<cfparam name="compcity" default="">
			<cfparam name="compstate" default="">
			<cfparam name="compzip" default="">
			<cfparam name="compphone" default="">
			<cfparam name="compfax" default="">
			<cfparam name="compemail" default="">
			
			
			
			
			
			
			
			<!--- // begin company administration page --->
			
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
						
							
							
							<!--- // show system messages --->
							
							<cfif structkeyexists(url, "msg") and url.msg is "saved">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-info">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong><i class="icon-check"></i> SUCCESS!</strong>  The company details were successfully saved.  Please select a company record to continue...
										</div>										
									</div>								
								</div>														
							</cfif>							
							
							
							
							
							
							
							
							
							
							
							
							
							<div class="widget stacked">
								
									<div class="widget-header">		
										<i class="icon-book"></i>							
										<h3>Company Administration <cfif structkeyexists( url, "compid" ) and url.compid eq 0> | Add New Company</cfif> <cfif structkeyexists( url, "compid" ) and url.compid neq 0> | Edit Company | <cfoutput>#compdetail.companyname#</cfoutput></cfif></h3>						
									</div> <!-- //.widget-header -->							
									
									
									<div class="widget-content">

										<!--- // begin form processing --->
										
										<cfif isDefined("form.fieldnames")>
											<cfscript>
												objValidation = createObject("component","apis.com.ui.validation").init();
												objValidation.setFields(form);
												objValidation.validate();
											</cfscript>

											<cfif objValidation.getErrorCount() is 0 >							
												
												<!--- define our structure and set form values --->
												<cfset comp = structnew() />
												<cfset comp.compid = #url.compid# />
												<cfset comp.compname = #form.compname# />
												<cfset comp.regcode = #createuuid()# />
												<cfset comp.add1 = #form.compadd1# />
												<cfset comp.add2 = #form.compadd2# />
												<cfset comp.city = #form.compcity# />
												<cfset comp.state = #ucase( form.compstate )# />
												<cfset comp.zip = #form.compzip# />
												<cfset comp.phone = rereplace( form.compphone, "[/\D+/]", "", "all" ) />
												<cfset comp.fax = rereplace( form.compfax, "[/\D+/]", "", "all" ) />
												<cfset comp.email = #form.compemail# />
												
												<cfif isdefined("form.chkstatus")>
													<cfset comp.status = 1 />
												<cfelse>
													<cfset comp.status = 0 />
												</cfif>
																							
												<!--- // some other variables --->
												<cfset today = #CreateODBCDateTime(now())# />					
												
													<!--- // check for duplicate department entry --->
													<cfquery datasource="#application.dsn#" name="checkdupecomp">
														select companyid, companyname
														  from company
														 where companyname = <cfqueryparam value="#comp.compname#" cfsqltype="cf_sql_varchar" />
													</cfquery>
													
													
													<!--- // check to make sure we are not allowing a duplicate department name for the same company --->
													<cfif checkdupecomp.recordcount eq 1 and comp.compid eq 0>
														
														<cfoutput>
															<script>
																alert('Sorry, #comp.compname# already exists for this company...');
																self.location="javascript:history.back(-1);"
															</script>
														</cfoutput>
													
													
													<cfelse>										
													
														<cfif comp.compid EQ 0>
														
															<!--- // create the database record --->
															<cfquery datasource="#application.dsn#" name="addcompany">
																insert into company(companyname, dba, address1, address2, city, state, zip, phone, fax, email, regcode, active)
																	values (
																			<cfqueryparam value="#comp.compname#" cfsqltype="cf_sql_varchar" />,
																			<cfqueryparam value="#comp.compname#" cfsqltype="cf_sql_varchar" />,
																			<cfqueryparam value="#comp.add1#" cfsqltype="cf_sql_varchar" />,
																			<cfqueryparam value="#comp.add2#" cfsqltype="cf_sql_varchar" />,
																			<cfqueryparam value="#comp.city#" cfsqltype="cf_sql_varchar" />,
																			<cfqueryparam value="#comp.state#" cfsqltype="cf_sql_varchar" />,
																			<cfqueryparam value="#comp.zip#" cfsqltype="cf_sql_varchar" />,
																			<cfqueryparam value="#comp.phone#" cfsqltype="cf_sql_varchar" />,
																			<cfqueryparam value="#comp.fax#" cfsqltype="cf_sql_varchar" />,
																			<cfqueryparam value="#comp.email#" cfsqltype="cf_sql_varchar" />,
																			<cfqueryparam value="#comp.regcode#" cfsqltype="cf_sql_varchar" maxlength="35" />,
																			<cfqueryparam value="1" cfsqltype="cf_sql_bit" />
																		   );
															</cfquery>											
															
															<!--- // log the activity --->
															<cfquery datasource="#application.dsn#" name="logact">
																insert into activity(leadid, userid, activitydate, activitytype, activity)
																	values (
																			<cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
																			<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																			<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																			<cfqueryparam value="Record Added" cfsqltype="cf_sql_varchar" />,
																			<cfqueryparam value="#session.username# added a new company to the system #comp.compname#." cfsqltype="cf_sql_varchar" />
																			);
															</cfquery>																					
															
															<cflocation url="#application.root#?event=#url.event#&msg=saved" addtoken="no">
													
														<cfelse>
															
															<!--- // update the database record --->
															<cfquery datasource="#application.dsn#" name="savecompany">
																update company
																   set companyname = <cfqueryparam value="#comp.compname#" cfsqltype="cf_sql_varchar" maxlength="50" />,
																	   address1 = <cfqueryparam value="#comp.add1#" cfsqltype="cf_sql_varchar" />,
																	   address2 = <cfqueryparam value="#comp.add2#" cfsqltype="cf_sql_varchar" />,
																	   city = <cfqueryparam value="#comp.city#" cfsqltype="cf_sql_varchar" />,
																	   state = <cfqueryparam value="#comp.state#" cfsqltype="cf_sql_varchar" />,
																	   zip = <cfqueryparam value="#comp.zip#" cfsqltype="cf_sql_varchar" />,
																	   phone = <cfqueryparam value="#comp.phone#" cfsqltype="cf_sql_varchar" />,
																	   fax = <cfqueryparam value="#comp.fax#" cfsqltype="cf_sql_varchar" />,
																	   email = <cfqueryparam value="#comp.email#" cfsqltype="cf_sql_varchar" />,
																	   active = <cfqueryparam value="#comp.status#" cfsqltype="cf_sql_bit" />
																 where companyid = <cfqueryparam value="#checkdupecomp.companyid#" cfsqltype="cf_sql_integer" />
															</cfquery>

															<!--- // if the company status is inactive // then inactivate all of their users --->
															<cfquery datasource="#application.dsn#" name="killusers">
																update users
																   set active = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />
																 where companyid = <cfqueryparam value="#checkdupecomp.companyid#" cfsqltype="cf_sql_integer" />
															</cfquery>
															
															<!--- // log the user activity --->
															<cfquery datasource="#application.dsn#" name="logact2">
																insert into activity(leadid, userid, activitydate, activitytype, activity)
																	values (
																			<cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
																			<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																			<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																			<cfqueryparam value="Record Updated" cfsqltype="cf_sql_varchar" />,
																			<cfqueryparam value="#session.username# updated the company details for #comp.compname#." cfsqltype="cf_sql_varchar" />
																			);
															</cfquery>																					
															
															<cflocation url="#application.root#?event=#url.event#&msg=saved" addtoken="no">
															
															
														</cfif>
													
													</cfif>
											
											
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
									
										<!-- // end form processing --->
										



































									
										<!--- company administration default data grid --->
										
										<cfif not structkeyexists( url, "fuseaction" )>
									
											<cfoutput>
												<h5><i class="icon-th-large"></i> Found #complist.recordcount# company records...  <span class="pull-right"><a href="#application.root#?event=page.admin" class="btn btn-small btn-secondary"><i class="icon-home"></i> Admin Home</a><a style="margin-left:5px;" href="#application.root#?event=#url.event#&fuseaction=add.company&compid=0" class="btn btn-small btn-default"><i class="icon-plus"></i> Add Company</a></span></h5>												
											</cfoutput>
											
											<table class="table table-bordered table-striped table-highlight">
												<thead>
													<tr>
														<th width="5%">Actions</th>
														<th>Company Name</th>
														<th>City, State</th>
														<th>Phone</th>
														<th>Email</th>
														<th>Status</th>
														<th>Manage</th>
													</tr>
												</thead>
												<tbody>
													<cfoutput query="complist">
														<cfinvoke component="apis.udfs.cleanphonenumber" method="formatphonenumber" returnvariable="phonenumber">
															<cfinvokeargument name="phonenumber" value="#complist.phone#">
														</cfinvoke>
														<tr>
															<td class="actions">																														
																<a href="#application.root#?event=#url.event#&fuseaction=edit.company&compid=#companyid#" class="btn btn-mini">
																	<i class="btn-icon-only icon-pencil"></i>										
																</a>														
															</td>													
															<td>#companyname#</td>
															<td>#city# #state#</td>
															<td><span class="label label-default">#phonenumber#</span></td>
															<td>#email#</td>
															<td><cfif active eq 1><span class="label label-success">Active</span><cfelse><span class="label label-important">Inactive</span></cfif></td>
															<td>
																<a href="#application.root#?event=#url.event#" class="btn btn-mini btn-warning" rel="popover" data-html="true" data-original-title="#companyname#" data-content="#address1# #address2#<br />#city#, #state#  #zip#<br />#phonenumber#<br />#email#<br />#regcode#">
																	<i class="btn-icon-only icon-ok"></i>										
																</a>
																<a href="#application.root#?event=page.getcompany&compid=#companyid#&manage=users" class="btn btn-mini btn-secondary">
																	<i class="btn-icon-only icon-user"></i>										
																</a>
																<a href="#application.root#?event=page.getcompany&compid=#companyid#&manage=depts" class="btn btn-mini btn-tertiary">
																	<i class="btn-icon-only icon-building"></i>										
																</a>
															</td>
														</tr>
													</cfoutput>
												</tbody>
											</table>
										</cfif>
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										<!--- // company administration add new company and edit company form designer --->
										
										<cfif structkeyexists( url, "fuseaction" ) and ( structkeyexists( url, "compid" ) and url.compid eq 0 )>
											<cfoutput>
												<br />
												<form id="add-company-admin" class="form-horizontal" method="post" action="#application.root#?event=#url.event#&fuseaction=#url.fuseaction#&compid=#url.compid#">
													<fieldset>						
																		
														<div class="control-group">											
															<label class="control-label" for="compname">Company Name</label>
																<div class="controls">
																	<input type="text" name="compname" class="input-large" />
																</div> <!-- /controls -->				
														</div> <!-- /control-group -->

														<div class="control-group">											
															<label class="control-label" for="compadd1">Address</label>
																<div class="controls">
																	<input type="text" name="compadd1" class="input-medium" />   <input type="text" name="compadd2" class="input-medium" />
																</div> <!-- /controls -->				
														</div> <!-- /control-group -->
														
														<div class="control-group">											
															<label class="control-label" for="compcity">City, State, Zip</label>
																<div class="controls">
																	<input type="text" name="compcity" class="input-medium" />   <input type="text" name="compstate" class="input-mini" onBlur="javascript:this.value=this.value.toUpperCase();" maxlength="2" />   <input type="text" name="compzip" class="input-small" maxlength="5" />   
																</div> <!-- /controls -->				
														</div> <!-- /control-group -->														
														
														<div class="control-group">											
															<label class="control-label" for="compphone">Phone</label>
																<div class="controls">
																	<input type="text" name="compphone" class="input-medium" />   
																</div> <!-- /controls -->				
														</div> <!-- /control-group -->
														
														<div class="control-group">											
															<label class="control-label" for="compfax">Fax</label>
																<div class="controls">
																	<input type="text" name="compfax" class="input-medium" />   
																</div> <!-- /controls -->				
														</div> <!-- /control-group -->
														
														<div class="control-group">											
															<label class="control-label" for="compemail">Email</label>
																<div class="controls">
																	<input type="text" name="compemail" class="input-large" />  
																</div> <!-- /controls -->				
														</div> <!-- /control-group -->
																																							
																		
														<br />
														<div class="form-actions">													
															<button type="submit" class="btn btn-secondary" name="savedept"><i class="icon-save"></i> Add Company</button>																										
															<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.admin.company'"><i class="icon-remove-sign"></i> Cancel</a>													
															<input name="utf8" type="hidden" value="&##955;">																											
															<input type="hidden" name="__authToken" value="#randout#" />
															<input name="validate_require" type="hidden" value="compname|Please enter the company name.;compadd1|Please enter the company address.;compcity|Please enter the company city.;">
													</fieldset>
												</form>										
											</cfoutput>
										
										
										
										
										
										
										<cfelseif structkeyexists( url, "fuseaction" ) and ( structkeyexists( url, "compid" ) and url.compid neq 0 )>
											
											<cfoutput>
												
												<br />
												<form id="edit-company-admin" class="form-horizontal" method="post" action="#application.root#?event=#url.event#&fuseaction=#url.fuseaction#&compid=#url.compid#">
													
													<fieldset>						
																		
														<div class="control-group">											
															<label class="control-label" for="compname">Company Name</label>
																<div class="controls">
																	<input type="text" name="compname" class="input-large" value="#compdetail.companyname#" />
																</div> <!-- /controls -->				
														</div> <!-- /control-group -->

														<div class="control-group">											
															<label class="control-label" for="compadd1">Address</label>
																<div class="controls">
																	<input type="text" name="compadd1" class="input-medium" value="#compdetail.address1#" />   <input type="text" name="compadd2" class="input-medium" value="#compdetail.address2#" />
																</div> <!-- /controls -->				
														</div> <!-- /control-group -->
														
														<div class="control-group">											
															<label class="control-label" for="compcity">City, State, Zip</label>
																<div class="controls">
																	<input type="text" name="compcity" class="input-medium" value="#compdetail.city#" />   <input type="text" name="compstate" class="input-mini" value="#compdetail.state#" onBlur="javascript:this.value=this.value.toUpperCase();" maxlength="2" />   <input type="text" name="compzip" class="input-small" maxlength="5" value="#compdetail.zip#"  />   
																</div> <!-- /controls -->				
														</div> <!-- /control-group -->														
														
														<div class="control-group">											
															<label class="control-label" for="compphone">Phone</label>
																<div class="controls">
																	<input type="text" name="compphone" class="input-medium" value="#compdetail.phone#" />   
																</div> <!-- /controls -->				
														</div> <!-- /control-group -->
														
														<div class="control-group">											
															<label class="control-label" for="compfax">Fax</label>
																<div class="controls">
																	<input type="text" name="compfax" class="input-medium" value="#compdetail.fax#" />   
																</div> <!-- /controls -->				
														</div> <!-- /control-group -->
														
														<div class="control-group">											
															<label class="control-label" for="compemail">Email</label>
																<div class="controls">
																	<input type="text" name="compemail" class="input-large" value="#compdetail.email#" />  
																</div> <!-- /controls -->				
														</div> <!-- /control-group -->
														
														<div class="control-group">
															<label class="control-label">Company Active</label>
																<div class="controls">
																	<label class="checkbox">
																		<input type="checkbox" name="chkstatus" value="1"<cfif compdetail.active eq 1>checked</cfif>>
																			<i>This company is active for use of the system</i>
																	</label>															
																</div>
														</div>
																																							
																		
														<br />
														<div class="form-actions">													
															<button type="submit" class="btn btn-secondary" name="savedept"><i class="icon-save"></i> Save Company Details</button>																										
															<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.admin.company'"><i class="icon-remove-sign"></i> Cancel</a>													
															<input name="utf8" type="hidden" value="&##955;">																											
															<input type="hidden" name="__authToken" value="#randout#" />
															<input name="validate_require" type="hidden" value="compname|Please enter the company name.;compadd1|Please enter the company address.;compcity|Please enter the company city.;">
													
													</fieldset>
												
												</form>										
											</cfoutput>
										
										
										
										
										
										</cfif>
										
										<!--- // end form designer --->
										
										
										
										
										
										
										
										
										
										

									<div class="clear"></div>
								
								
								</div> <!-- //.widget-content -->	
									
							</div> <!-- //.widget -->
							
						</div> <!-- //.span12 -->
						
					</div> <!-- //.row -->			
				
				
					<div style="height:300px;"></div>			
				
				</div> <!-- //.container -->
			
			</div> <!-- //.main -->