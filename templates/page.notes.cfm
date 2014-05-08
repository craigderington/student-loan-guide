

			<!--- get our data components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>

			<cfinvoke component="apis.com.leads.leadgateway" method="getleadnotes" returnvariable="leadnotes">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>	


			<!--- lead notes page --->			
			
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
											<strong><i class="icon-check"></i> SUCCESS!</strong>  The note was successfully saved to the client's profile.  Please use the navigation in the sidebar to continue...
										</div>										
									</div>								
								</div>
							<cfelseif structkeyexists(url, "msg") and url.msg is "deleted">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-success">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong>SUCCESS!</strong>  The note was successfully deleted from the client's profile.  Please use the navigation in the sidebar to continue...
										</div>										
									</div>								
								</div>
							<cfelseif structkeyexists(url, "msg") and url.msg is "error">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-error">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong>SYSTEM ERROR!</strong>  Sorry, the note could not be deleted due to a system error.  Please use the navigation in the sidebar to continue...
										</div>										
									</div>								
								</div>
							</cfif>
							
							
							<!--- // begin widget --->
							
							<div class="widget stacked">
								<cfoutput>	
								<div class="widget-header">		
									<i class="icon-comments"></i>							
									<h3>Notes for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
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
											<cfset lead.noteuuid = #createuuid()# />
											<cfset lead.notetext = #urlencodedformat(form.notetext)# />											
																						
											<!--- // some other variables --->
											<cfset today = #CreateODBCDateTime(now())# />											
																						
											<!--- // create the database record --->
											<cfquery datasource="#application.dsn#" name="addnote">
												insert into notes(leadid, noteuuid, userid, notedate, notetext, removed, systemnote)
													values (
															<cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#lead.noteuuid#" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
															<cfqueryparam value="#lead.notetext#" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="0" cfsqltype="cf_sql_bit" />,
															<cfqueryparam value="0" cfsqltype="cf_sql_bit" />
														   );
											</cfquery>											
											
											<!--- // log the activity --->
											<cfquery datasource="#application.dsn#" name="logact">
												insert into activity(leadid, userid, activitydate, activitytype, activity)
													values (
															<cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
															<cfqueryparam value="Record Added" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#session.username# added a note for #leaddetail.leadfirst# #leaddetail.leadlast#." cfsqltype="cf_sql_varchar" />
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
									<!-- // end form processing --->
								
										<div class="span3">					
											<cfinclude template="page.sidebar.nav.cfm">		
										</div> <!-- /.span3 -->
			
			
										<div class="span8">
											
											<div class="tab-content">
												
												<div class="tab-pane active" id="tab1">
													<cfif not structkeyexists(url, "fuseaction")>
														<cfoutput>
														<h3><i class="icon-comments"></i> Notes <span style="float:right;"><a href="#application.root#?event=#url.event#&fuseaction=addnote" class="btn btn-small btn-primary"><i class="icon-comments"></i> Add New Note</a></span></h3>
														</cfoutput>
													<cfelse>
														<h3><i class="icon-comments"></i> Add Note</h3>
													</cfif>
													
													<cfif not structkeyexists(url, "fuseaction")>
													
														<p>The following table displays all enrollment notes for the selected client.  Please use the information below as historical documentation for the client's enrollment process.  Record interactions with the client by documenting conversations.  Add new notes by clicking the add new note button.  System generated messages will appear in the notes section automatically.</p>
														
														<br>
														
														<cfif leadnotes.recordcount gt 0>
															<cfparam name="url.startRow" default="1" >
															<cfparam name="url.rowsPerPage" default="10" >
															<cfparam name="currentPage" default="1" >
															<cfparam name="totalPages" default="0" >
																<table class="table table-bordered table-striped table-highlight">
																	<thead>
																		<tr>
																			<cfif isuserinrole("admin") or isuserinrole("sls")>																			
																			<th width="12%" style="align:center;">Actions</th>																			
																			</cfif>
																			<th width="15%">Date</th>																		
																			<th width="15%">Entered By</th>
																			<th>Note</th>																	
																		</tr>
																	</thead>
																	<tbody>																		
																		<cfoutput query="leadnotes" startrow="#url.startrow#" maxrows="#url.rowsperpage#">
																		<tr>
																			<cfif isuserinrole("admin") or isuserinrole("sls")>																			
																			<td>																						
																				<cfif systemnote neq 1>
																					<a href="#application.root#?event=page.note.edit&noteid=#noteuuid#" class="btn btn-mini btn-primary">
																						<i class="btn-icon-only icon-pencil"></i>										
																					</a>
																					
																					<a style="margin-top:3px;" href="#application.root#?event=page.note.delete&noteid=#noteuuid#" class="btn btn-mini btn-inverse">
																						<i class="btn-icon-only icon-trash"></i>										
																					</a>
																				<cfelse>
																					<a href="javascript:;" class="btn btn-mini btn-default" rel="popover" data-original-title="System Generated Note" data-content="System generated notes can not be edited or deleted...">
																						<i class="btn-icon-only icon-exclamation-sign"></i>										
																					</a>
																				</cfif>
																			</td>																			
																			</cfif>
																			<td>#dateformat( notedate, "mm/dd/yyyy" )# &##64; #timeformat( notedate, "hh:mm tt" )# </td>									
																			<td>#firstname# #lastname#</td>
																			<td>#urldecode( notetext )#</td>																	
																		</tr>		
																		</cfoutput>											
																	</tbody>
																</table>
																
																<br />
																
																<!--- // 7-26-2013 // new pagination ++ page number links --->
														
																<cfset totalRecords = leadnotes.recordcount >
																<cfset totalPages = totalRecords / rowsPerPage >
																<cfset endRow = (startRow + rowsPerPage) - 1 >													

																	<!--- If the endrow is greater than the total, set the end row to to total --->
																	<cfif endRow GT totalRecords>
																	   <cfset endRow = totalRecords>
																	</cfif>

																	<!--- Add an extra page if you have leftovers --->
																	<cfif (totalRecords MOD rowsPerPage) GT 0 >
																	   <cfset totalPages = totalPages + 1 >
																	</cfif>

																	<!--- Display all of the pages --->
																	<cfif totalPages gte 2>
																		<div class="pagination">
																			<ul>
																				<cfloop from="1" to="#totalPages#" index="i">
																					<cfset startRow = ((i - 1) * rowsPerPage) + 1>
																					<cfif currentPage neq i>
																						<cfoutput><li><a href="#cgi.script_name#?event=#url.event#&startRow=#startRow#&currentPage=#i#">#i#</a></li></cfoutput>
																					<cfelse>
																						<cfoutput><li class="active"><a href="javascript:;">#i#</a></li></cfoutput>
																					</cfif>													
																			   </cfloop>
																			</ul>
																		</div>
																	</cfif>
																
														<cfelse>
															<div class="row">
																<div class="span8">										
																	<div class="alert alert-error">
																		<button type="button" class="close" data-dismiss="alert">&times;</button>
																		<strong>NO RECORDS FOUND!</strong>  Sorry, there are no saved notes in the system for the selected client.  Please use the button below to add a new note or use the navigation sidebar to continue...
																	</div>										
																</div>								
															</div>
														</cfif>
													
													
													<cfelse>
													
														<!--- // show form to add new notes --->												
														
														<cfoutput>
															<br />
															<form id="addnotes-lead" class="form-horizontal" method="post" action="#application.root#?event=page.notes&fuseaction=addnote">
																<fieldset>						
																	
																	<div class="control-group">											
																		<label class="control-label" for="docdate">Enter Note</label>
																		<div class="controls">
																			<textarea name="notetext" id="notetext" class="input-large span6" rows="10"></textarea>
																		</div> <!-- /controls -->				
																	</div> <!-- /control-group -->															
																																						
																	
																	<br />
																	<div class="form-actions">													
																		<button type="submit" class="btn btn-secondary" name="savelead"><i class="icon-save"></i> Save Note</button>																										
																		<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.notes'"><i class="icon-remove-sign"></i> Cancel</a>													
																		<input name="utf8" type="hidden" value="&##955;">													
																		<input type="hidden" name="leadid" value="#leaddetail.leadid#" />																	
																		<input type="hidden" name="__authToken" value="#randout#" />
																		<input name="validate_require" type="hidden" value="leadid|Opps, sorry... the form can not be posted due to an intrnal error.  Please re-load the page and try again.;notetext|Please enter text for the note.  The field can not be blank." />															
																	</div> <!-- /form-actions -->
																</fieldset>
															</form>
															</cfoutput>
														
													
													</cfif>
																	
												</div> <!-- /#tab1 -->										 
											
											</div> <!-- /.tab-content -->
											
										</div> <!-- /.span8 -->	
									
					
								</div> <!-- /. widget-content -->
							
							</div> <!-- /. widget-stacked -->
						
						</div><!-- / .span12 -->
					
					</div> <!-- / .row -->
					
					<cfif leadnotes.recordcount lt 5>
						<div style="margin-top:200px;"></div>
					<cfelse>
						<div style="margin-top:25px;"></div>
					</cfif>				
				
				</div> <!-- / .container -->
			
			</div> <!-- / .main -->
		