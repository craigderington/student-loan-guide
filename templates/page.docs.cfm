

			
			<!--- get our data components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.leads.documentgateway" method="getdoccats" returnvariable="doccats">				
			
			<cfinvoke component="apis.com.leads.documentgateway" method="getdocuments" returnvariable="doclist">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.esign.esigngateway" method="getesigninfo" returnvariable="esigninfo">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			
			
			
			<!--- // delete document function --->
			<cfif structkeyexists( url, "fuseaction" ) and url.fuseaction is "deletedocument">
				
				<cfparam name="docid" default="">
				<cfparam name="today" default="">
				<cfset docid = #url.docid# />
				<cfset today = #CreateODBCDateTime(Now())# />
				
					<cfif structkeyexists(url, "docid") and url.docid is not "" and isvalid("uuid", url.docid) >
						
						<!--- // get the record to log the activity --->						
						<cfquery datasource="#application.dsn#" name="getdoc">
							select d.docsid, d.docuuid, d.docname, d.doctype, d.docpath, l.leadid, l.leadfirst, l.leadlast
							  from documents d, leads l
							 where d.leadid = l.leadid
							   and d.docuuid = <cfqueryparam value="#docid#" cfsqltype="cf_sql_varchar" maxlength="35" />
						</cfquery>					
						
						<!--- // delete the file form the server path --->
						<cfif trim( getdoc.doctype ) is "S">						
							<cffile action="delete" file="#ExpandPath('library\clients\solutions')#\#getdoc.docpath#">						
						<cfelse>
							<cffile action="delete" file="#ExpandPath('library\clients\enrollment')#\#getdoc.docpath#">
						</cfif>
						
						<!--- // delete the document --->						
						<cfquery datasource="#application.dsn#" name="killdoc">
							delete
							  from documents
							 where docsid = <cfqueryparam value="#getdoc.docsid#" cfsqltype="cf_sql_integer" />
						</cfquery>
						
						<!--- // log the activity --->
						<cfquery datasource="#application.dsn#" name="logact">
							insert into activity(leadid, userid, activitydate, activitytype, activity)
								values (
										<cfqueryparam value="#getdoc.leadid#" cfsqltype="cf_sql_integer" />,
										<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
										<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
										<cfqueryparam value="Record Deleted" cfsqltype="cf_sql_varchar" />,
										<cfqueryparam value="The user deleted program enrollment document #getdoc.docname# for #getdoc.leadfirst# #getdoc.leadlast#." cfsqltype="cf_sql_varchar" />
										);
						</cfquery>																					
											
						<cflocation url="#application.root#?event=#url.event#&msg=deleted" addtoken="no">					
					
					<cfelse>
						
						<cfoutput>
							<script>
								alert("There was a problem with the database operation on the selected record and the operation was aborted...  Please try again.");
								self.location="#application.root#?event=#url.event#&msg=error"
							</script>
						</cfoutput>
						
					</cfif>
			
			</cfif>
			<!--- // end delete document function --->


			<!--- lead summary page --->
			
			
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
						
							<!--- system messages --->
							<cfif structkeyexists(url, "msg") and url.msg is "saved">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-info">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong><i class="icon-check"></i> UPLOAD SUCCESS!</strong>  The program enrollment document was successfully uploaded and saved to the client folder.  Please use the navigation in the sidebar to continue...
										</div>										
									</div>								
								</div>
							<cfelseif structkeyexists(url, "msg") and url.msg is "deleted">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-success">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong>DELETE SUCCESS!</strong>  The program enrollment document was successfully deleted from the client's folder.  Please use the navigation in the sidebar to continue...
										</div>										
									</div>								
								</div>
							<cfelseif structkeyexists(url, "msg") and url.msg is "error">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-error">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong>ERROR!</strong>  There was a problem with the selected document record and the operation was aborted.  Please use the navigation in the sidebar to continue...
										</div>										
									</div>								
								</div>
							</cfif>	
							
							<div class="widget stacked">
								<cfoutput>
								<div class="widget-header">		
									<i class="icon-book"></i>							
									<h3>Document Library for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
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
											<cfset lead.docuuid = #createuuid()# />
											<cfset lead.leadid = #form.leadid# />
											<cfset lead.uploadpath = #form.fileuploadpath# />									
											<cfset lead.doccat = #form.doccat# />
											<cfset lead.doccatother = trim( form.doccatother ) />
											
											<!--- // some other variables --->
											<cfset today = #CreateODBCDateTime(now())# />				
																		
											
													<!--- // check existing categories --->										
													<cfif lead.doccat eq 0 and ( lead.doccatother is not "" and lead.doccatother is not "Enter New Category" )>
													
															<cfquery datasource="#application.dsn#" name="checkdoccat">
																select top 1 doccatid, doccat
																  from doccategory
																 where doccat LIKE <cfqueryparam value="%#lead.doccatother#%" cfsqltype="cf_sql_varchar" />
															</cfquery>
													
													
															<cfif checkdoccat.recordcount eq 1>														
																<cfset lead.doccat = checkdoccat.doccatid />				
															<cfelse>																
																<!--- // add the new document category --->
																<cfquery datasource="#application.dsn#" name="adddoccat">
																	insert into doccategory( doccat )
																	 values(
																			<cfqueryparam value="#lead.doccatother#" cfsqltype="cf_sql_varchar" />
																			); select @@identity as newdoccatid
																</cfquery>																
																<cfset lead.doccat = adddoccat.newdoccatid />										
															</cfif>											
													</cfif>
													
													<!--- // write the file to the server --->										
													<cffile action="upload" source="#form.fileuploadpath#" destination="#expandpath( 'library\clients\enrollment\' )#" nameconflict="makeunique" >
													
													<!--- // get the server and client file name --->
													<cfset lead.doc = cffile.serverfile />
													<cfset lead.docname = listfirst( lead.doc, "." ) />
													<cfset lead.docfileext = listlast( lead.doc, "." ) />
											
											
													<!--- // create the database record --->
													<cfquery datasource="#application.dsn#" name="dodocupload">
														insert into documents(docuuid, leadid, docname, docfileext, docpath, docdate, docuploaddate, uploadedby, docactive, doccatid)
															values (
																	<cfqueryparam value="#lead.docuuid#" cfsqltype="cf_sql_varchar" maxlength="35" />,
																	<cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />,
																	<cfqueryparam value="#lead.docname#" cfsqltype="cf_sql_varchar" />,
																	<cfqueryparam value=".#lead.docfileext#" cfsqltype="cf_sql_varchar" />,
																	<cfqueryparam value="#lead.doc#" cfsqltype="cf_sql_varchar" />,
																	<cfqueryparam value="#today#" cfsqltype="cf_sql_date" />,
																	<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																	<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																	<cfqueryparam value="1" cfsqltype="cf_sql_bit" />,
																	<cfqueryparam value="#lead.doccat#" cfsqltype="cf_sql_integer" />
																   );
													</cfquery>

													<!--- // mark portal task complete --->
													<cfif isuserinrole( "bclient" )>
														<cfif lead.doccat eq 490741>													
															<cfinvoke component="apis.com.portal.portaltaskgateway" method="markportaltaskcompleted" returnvariable="taskstatusmsg">
																<cfinvokeargument name="portaltaskid" value="1409">
																<cfinvokeargument name="leadid" value="#session.leadid#">
															</cfinvoke>
														</cfif>
														<cfif lead.doccat eq 490742 or lead.doccat eq 490747>													
															<cfinvoke component="apis.com.portal.portaltaskgateway" method="markportaltaskcompleted" returnvariable="taskstatusmsg">
																<cfinvokeargument name="portaltaskid" value="1411">
																<cfinvokeargument name="leadid" value="#session.leadid#">
															</cfinvoke>
														</cfif>
														<cfif lead.doccat eq 490740 or lead.doccat eq 490744 or lead.doccat eq 490743>													
															<cfinvoke component="apis.com.portal.portaltaskgateway" method="markportaltaskcompleted" returnvariable="taskstatusmsg">
																<cfinvokeargument name="portaltaskid" value="1412">
																<cfinvokeargument name="leadid" value="#session.leadid#">
															</cfinvoke>
														</cfif>
													</cfif>
													<!--- // end portal task automation --->
													
													<!--- // log the activity --->
													<cfquery datasource="#application.dsn#" name="logact">
														insert into activity(leadid, userid, activitydate, activitytype, activity)
															values (
																	<cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />,
																	<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																	<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																	<cfqueryparam value="Record Added" cfsqltype="cf_sql_varchar" />,
																	<cfqueryparam value="#session.username# uploaded program enrollment document #lead.docname# for #leaddetail.leadfirst# #leaddetail.leadlast#." cfsqltype="cf_sql_varchar" />
																	);
													</cfquery>																					
													
													<cflocation url="#application.root#?event=#url.event#&msg=saved" addtoken="no">
												
											
											<!---<cfdump var="#lead#" label="document-details">--->				
										
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
											<cfinclude template="page.sidebar.nav.cfm">		
										</div> <!-- /.span3 -->
			
			
										<div class="span8">
											
											<div class="tab-content">
												
												<div class="tab-pane active" id="tab1">
													
													<cfif not structkeyexists(url, "fuseaction")>
														<cfoutput><h3><i class="icon-folder-open"></i> Document Library   <cfif esigninfo.escompleted eq 1><span class="pull-right"><a href="javascript:;" onclick="window.open('../templates/page.printdocs.cfm?clientid=#leaddetail.leadid#', '','scrollbars=yes,width=700,height=600');" class="btn btn-small btn-secondary" target="_blank"><i class="icon-print"></i> Print Enrollment Documents</a></span></cfif></h3></cfoutput>
													<cfelse>
														<h3><i class="icon-folder-open"></i> Upload New Document to Library</h3>
													</cfif>
													
													<cfif not isuserinrole( "bclient" )>
													<p>Generate and store client enrollment documents in the client document library.  You can also upload and save client student loan debt servicer statements for quick retrieval and access for later analysis by the Student Loan Debt Advisor.  The default document format is PDF, but you can also upload any type of file.</p>
													<cfelse>
													<p>Upload and save your NSLDS Student Loan text file, loan servicer statements and any important loan correspondence.  Click the Upload Document button below, browse for your files on your local computer and click Save Document.  The default document type is PDF.</p> 
													</cfif>
													<br>
														
													<cfif not structkeyexists(url, "fuseaction")>
														<cfif doclist.recordcount gt 0>
															<table class="table table-bordered table-striped table-highlight">
																<thead>
																	<tr>
																		<th width="18%">Actions</th>
																		<th width="20%">Date</th>
																		<th width="50%">Document Name</th>																		
																		<th width="12%">Access</th>
																	</tr>
																</thead>
																<tbody>
																	
																	<cfoutput query="doclist" group="doccat">
																		
																		<tr style="background-color:##f2f2f2;">
																			<td colspan="4"><strong>#doccat#</strong></td>
																		</tr>
																	
																			<cfoutput>
																				<tr>
																					<td class="actions">
																						
																							<cfif trim( doctype ) is "E">
																								<a href="library/clients/enrollment/#docpath#" class="btn btn-mini btn-warning" target="_blank">
																									<i class="btn-icon-only icon-ok"></i>										
																								</a>								
																							<cfelse>
																								<a href="library/clients/solutions/#docpath#" class="btn btn-mini btn-warning" target="_blank">
																									<i class="btn-icon-only icon-ok"></i>										
																								</a>
																							</cfif>
																							
																							<cfif not isuserinrole( "bClient" )>
																								<cfif trim( doctype ) is "E">
																									<a href="#application.root#?event=#url.event#&fuseaction=deletedocument&docid=#docuuid#" class="btn btn-mini btn-inverse" onclick="return confirmsubmit();">
																										<i class="btn-icon-only icon-trash"></i>										
																									</a>
																								</cfif>
																							</cfif>
																					
																						<a href="javascript:;" rel="popover" data-original-title="#docname#" data-content="Saved by #firstname# #lastname# on #dateformat(docuploaddate, "mm/dd/yyyy")#" class="btn btn-mini btn-default" ><i class="btn-icon-only icon-file-alt"></i></a>
																					</td>																	
																					<td>#dateformat(docdate, "mm/dd/yyyy")#</td>
																					<td>#docname#</td>																					
																					<td><a href="library/clients/enrollment/#docpath#" target="_blank" class="label label-inverse">Get Document</a></td>
																				</tr>
																			</cfoutput>
																	</cfoutput>										
																</tbody>
															</table>
														<cfelse>
															<div class="row">
																<div class="span8">										
																	<div class="alert alert-error">
																		<button type="button" class="close" data-dismiss="alert">&times;</button>
																		<strong>NO RECORDS FOUND!</strong>  No enrollment documents have been uploaded and saved to this client's folder.  Please use the Upload Document button below to get started...
																	</div>										
																</div>								
															</div>
														</cfif>
														
														
														<br />
														<cfoutput>
														<a href="#application.root#?event=page.docs&fuseaction=upload" class="btn btn-small btn-secondary"><i class="icon-download-alt"></i> Upload Document</a>
														</cfoutput>
													</cfif>
													
													
													<!--- // end document list --->						
													
													
													<!--- // show form to upload new documents --->
													
													<cfif structkeyexists(url, "fuseaction") and url.fuseaction is "upload">	
														<cfoutput>
														<form id="upload-documents" class="form-horizontal" method="post" action="#application.root#?event=page.docs&fuseaction=upload" enctype="multipart/form-data">
															<fieldset>
																
																<div class="control-group">
																	<label class="control-label" for="fileuploadpath">Browse for File</label>
																	<div class="controls">
																		<input type="file" name="fileuploadpath" class="input-large" id="fileuploadpath">
																	</div> <!-- /controls -->	
																</div> <!-- /control-group -->
																
																<div class="control-group">											
																	<label class="control-label" for="doccat" style="margin-right:10px;">Document Type</label>
																		<select name="doccat" class="input-xlarge" id="doccat">
																			<option value="0">Select Category or Enter</option>
																			<cfloop query="doccats">
																				<option value="#doccatid#"<cfif isdefined( "form.doccat" ) and form.doccat eq doccats.doccatid>selected</cfif>>#doccat#</option>
																			</cfloop>
																		</select> &nbsp; or 
																		&nbsp;<input type="text" name="doccatother" placeholder="Enter New Category" class="input-large" />
																	</div> <!-- /controls -->				
																</div> <!-- /control-group -->																																			
																
																<br />
																<div class="form-actions">													
																	<button type="submit" class="btn btn-secondary" name="savelead"><i class="icon-save"></i> Save Document</button>																										
																	<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.docs'"><i class="icon-remove-sign"></i> Cancel</a>													
																	<input name="utf8" type="hidden" value="&##955;">													
																	<input type="hidden" name="leadid" value="#leaddetail.leadid#" />																	
																	<input type="hidden" name="__authToken" value="#randout#" />
																	<input name="validate_require" type="hidden" value="leadid|Opps, sorry... the form can not be posted due to an internal error.  Please re-load the page and try again." />															
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
					
					<cfif doclist.recordcount lt 5>
						<div style="height:275px;"></div>			
					<cfelse>
						<div style="height:100px;"></div>	
					</cfif>
				
				</div> <!-- / .container -->
			
			</div> <!-- / .main -->
			
			<!--- // js for confirm/submit --->
			<script LANGUAGE="JavaScript">
				<!--
				// *** CLD - 2007-08-06 - Alert Confirm Delete
				function confirmsubmit()
				{
				var agree=confirm("Are you sure you want to delete this client document?");
				if (agree)
					return true ;
				else
					return false ;
				}
				// -->
			</script>

		
		
		