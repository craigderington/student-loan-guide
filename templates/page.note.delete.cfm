

			<!--- get our data components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>

			<cfinvoke component="apis.com.leads.leadgateway" method="getnotedetail" returnvariable="notedetail">				
				<cfinvokeargument name="noteid" value="#url.noteid#">
			</cfinvoke>


			<!-- // define form vars --->
			<cfparam name="noteid" default="">
			<cfparam name="noteuuid" default="">
			<cfparam name="leadid" default="">


			<!--- delete lead note page --->			
			
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">						
							
							<!--- // begin widget --->
							
							<div class="widget stacked">
								<cfoutput>	
								<div class="widget-header">		
									<i class="icon-comments"></i>							
									<h3>Delete Enrollment Note for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
								</div> <!-- //.widget-header -->
								</cfoutput>	
							
								<div class="widget-content">
								
									<!--- // begin form processing --->
									<cfif isDefined("form.fieldnames")>
										<cfscript>
											objValidation = createObject("component","apis.com.ui.validation").init();
											objValidation.setFields(form);
											objValidation.validate();
										</cfscript>

										<cfif objValidation.getErrorCount() is 0>							
											
											<!--- define our structure and set form values --->
											<cfset lead = structnew() />
											<cfset lead.leadid = #form.leadid# />
											<cfset lead.noteid = #form.noteid# />
											<cfset lead.noteuuid = #form.noteuuid# />
																						
											<!--- // some other variables --->
											<cfset today = #CreateODBCDateTime(now())# />											
																						
											<!--- // update the database record --->
											<cfquery datasource="#application.dsn#" name="killnote">
												update notes
												   set removed = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />															
												 where noteid = <cfqueryparam value="#lead.noteid#" cfsqltype="cf_sql_integer" />
											</cfquery>											
											
											<!--- // log the activity --->
											<cfquery datasource="#application.dsn#" name="logact">
												insert into activity(leadid, userid, activitydate, activitytype, activity)
													values (
															<cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
															<cfqueryparam value="Record Deleted" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#session.username# deleted a note for #leaddetail.leadfirst# #leaddetail.leadlast#." cfsqltype="cf_sql_varchar" />
															);
											</cfquery>																					
											
											<cflocation url="#application.root#?event=page.notes&msg=deleted" addtoken="no">
								
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
								
										<div class="span3">					
											<cfinclude template="page.sidebar.nav.cfm">		
										</div> <!-- /.span3 -->
			
			
										<div class="span8">
											
											<div class="tab-content">												
												
												<h3><i class="icon-comments"></i> Delete Note</h3>
												
												<cfoutput>	
												<form id="killlead-note" class="form-horizontal" method="post" action="#application.root#?event=#url.event#&noteid=#notedetail.noteuuid#">
													<fieldset>													
														<div class="form">
															<h5 style="font-weight:bold;">Are you absolutley sure you want to delete this client note?  
															<br />
															
															<h4><small>Note Date: #dateformat(notedetail.notedate, "mm/dd/yyyy")#</small></h4>
																<p>
																	#urldecode(notedetail.notetext)#
																</p>
															
															<br />
															
															<h5 style="font-weight:bold;color:red;"><i class="icon-warning-sign"></i> This action can not be undone...</h5>												
														</div>											
															
														<br /><br />
														
														<div class="form-actions">													
															<button type="submit" class="btn btn-danger" name="killservicer"><i class="icon-save"></i> Delete Note</button>																										
															<a name="cancel" class="btn btn-secondary" onclick="location.href='#application.root#?event=page.notes'"><i class="icon-remove-sign"></i> Cancel</a>													
															<input name="utf8" type="hidden" value="&##955;">												
															<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
															<input type="hidden" name="noteid" value="#notedetail.noteid#" />
															<input type="hidden" name="noteuuid" value="#notedetail.noteuuid#" />
															<input type="hidden" name="__authToken" value="#randout#" />
															<input name="validate_require" type="hidden" value="noteid|'The note ID' and identifier is required for this function. The operation aborted." />												
														</div> <!-- /form-actions -->
														
													</fieldset>
												</form>
												</cfoutput>																			 
											
											</div> <!-- /.tab-content -->
											
										</div> <!-- /.span8 -->								
					
								</div> <!-- /. widget-content -->
							
							</div> <!-- /. widget-stacked -->
						
						</div><!-- / .span12 -->
					
					</div> <!-- / .row -->

					<div style="margin-top:150px;"></div>
				
				</div> <!-- / .container -->
			
			</div> <!-- / .main -->
			
			
		
		
		