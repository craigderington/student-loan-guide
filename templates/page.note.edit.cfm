

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
			<cfparam name="notetext" default="">
			<cfparam name="leadid" default="">


			<!--- lead notes page --->			
			
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">					
							
							<!--- // begin widget --->
							
							<div class="widget stacked">
								
								<cfoutput>	
								<div class="widget-header">		
									<i class="icon-comments"></i>							
									<h3>Edit Enrollment Note for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
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
											<cfset lead.noteuuid = #createuuid()# />
											<cfset lead.notetext = #urlencodedformat(form.notetext)# />											
																						
											<!--- // some other variables --->
											<cfset today = #CreateODBCDateTime(now())# />											
																						
											<!--- // create the database record --->
											<cfquery datasource="#application.dsn#" name="editnote">
												update notes
												   set notetext = <cfqueryparam value="#lead.notetext#" cfsqltype="cf_sql_varchar" />,
												       noteuuid = <cfqueryparam value="#lead.noteuuid#" cfsqltype="cf_sql_varchar" />
												 where noteid = <cfqueryparam value="#lead.noteid#" cfsqltype="cf_sql_integer" />													   
											</cfquery>											
											
											<!--- // log the activity --->
											<cfquery datasource="#application.dsn#" name="logact">
												insert into activity(leadid, userid, activitydate, activitytype, activity)
													values (
															<cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
															<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#session.username# edited a note for #leaddetail.leadfirst# #leaddetail.leadlast#." cfsqltype="cf_sql_varchar" />
															);
											</cfquery>																					
											
											<cflocation url="#application.root#?event=page.notes&msg=saved" addtoken="no">
								
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
												
												<h3><i class="icon-comments"></i> Edit Note</h3>
												
												<div class="tab-pane active" id="tab1">										
													
													
														<!--- // show form to edit note --->												
														
														<cfoutput>
															<br />
															<form id="edit-note-lead" class="form-horizontal" method="post" action="#application.root#?event=page.note.edit&noteid=#notedetail.noteuuid#">
																<fieldset>						

																	<div class="control-group">											
																		<label class="control-label" for="docdate">Edit Note Content</label>
																		<div class="controls">
																			<textarea name="notetext" id="notetext" class="input-large span6" rows="10">#urldecode(notedetail.notetext)#</textarea>
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->															
																																						
																	
																	<br /><br />
																	<div class="form-actions">													
																		<button type="submit" class="btn btn-secondary" name="savelead"><i class="icon-save"></i> Save Note</button>																									
																		<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.notes'"><i class="icon-remove-sign"></i> Cancel</a>													
																		<input name="utf8" type="hidden" value="&##955;">													
																		<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
																		<input type="hidden" name="noteid" value="#notedetail.noteid#" />
																		<input type="hidden" name="noteuuid" value="#notedetail.noteuuid#" />
																		<input type="hidden" name="__authToken" value="#randout#" />
																		<input name="validate_require" type="hidden" value="noteid|Opps, sorry... the form can not be posted due to an internal error.  Please re-load the page and try again.;notetext|Please enter text for the note.  The field can not be blank." />															
																	</div> <!-- /form-actions -->
																	
																</fieldset>
															</form>
														</cfoutput>													
													
																	
												</div> <!-- /#tab1 -->										 
											
											</div> <!-- /.tab-content -->
											
										</div> <!-- /.span8 -->	
									
					
								</div> <!-- /. widget-content -->
							
							</div> <!-- /. widget-stacked -->
						
						</div><!-- / .span12 -->
					
					</div> <!-- / .row -->						
				
				</div> <!-- / .container -->
			
			</div> <!-- / .main -->	
		