


		<!--- // get our data access components --->
		<cfinvoke component="apis.com.system.librarygateway" method="getformslist" returnvariable="formslist">
			<cfinvokeargument name="companyid" value="#session.companyid#">
		</cfinvoke>
			

		<!--- // some form vars --->
		<cfparam name="docname" default="">
		<cfparam name="doccat" default="">
		<cfparam name="docdescr" default="">
		<cfparam name="docdate" default="">
		<cfparam name="fileuploadpath" default="">
		<cfparam name="filetype" default="">







		
			<!--- // begin new form upload --->	
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
							
							<div class="widget stacked">
								
								<cfoutput>
								<div class="widget-header">		
									<i class="icon-book"></i>							
									<h3>#session.companyname# Forms Library | Upload a New Form</h3>						
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
											<cfset lib = structnew() />
											<cfset lib.libuuid = #createuuid()# />											
											<cfset lib.uploadpath = #form.fileuploadpath# />
											<cfset lib.docname = #form.docname# />
											<cfset lib.doccat = #form.doccat# />
											<cfset lib.docdate = #form.docdate# />
											<cfset lib.filetype = #form.filetype# />
											<cfset lib.docdescr = #form.docdescr# />
											
											<!--- // some other variables --->
											<cfset today = #CreateODBCDateTime(now())# />
											
											<!--- // write the file to the server --->									
											<cffile action="copy" source="#form.fileuploadpath#" destination="#expandpath('library\forms')#\#lib.docname##lib.filetype#">
												
											<!--- // create the database record --->
											<cfquery datasource="#application.dsn#" name="dodocupload">
												insert into library(libuuid, companyid, doccat, docdate, docname, docdescr, docpath, docactive)
													values (
															<cfqueryparam value="#lib.libuuid#" cfsqltype="cf_sql_varchar" maxlength="35" />,
															<cfqueryparam value="#session.companyid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#lib.doccat#" cfsqltype="cf_sql_varchar" />,															
															<cfqueryparam value="#lib.docdate#" cfsqltype="cf_sql_date" />,
															<cfqueryparam value="#lib.docname#" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#lib.docdescr#" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#lib.docname##lib.filetype#" cfsqltype="cf_sql_varchar" />,															
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
															<cfqueryparam value="#session.username# uploaded a new form to the forms library." cfsqltype="cf_sql_varchar" />
															);
											</cfquery>																					
											
											<cflocation url="#application.root#?event=page.library.forms&msg=saved" addtoken="no">
								
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





















								
									
									<cfoutput>
										<form id="upload-forms" class="form-horizontal" method="post" action="#application.root#?event=page.library.forms.upload" enctype="multipart/form-data">
												
												<br />
												<fieldset>
																
													<div class="control-group">
														<label class="control-label" for="fileuploadpath">Browse for File</label>
															<div class="controls">
																<input type="file" name="fileuploadpath" class="input-large" id="fileuploadpath">
															</div> <!-- /controls -->	
													</div> <!-- /control-group -->
													
													<div class="control-group">											
														<label class="control-label" for="doccat">Document Category</label>
															<div class="controls">
																<input type="text" class="input-large" name="doccat" id="doccat">																		
															</div> <!-- /controls -->				
													</div> <!-- /control-group -->
														
													<div class="control-group">											
														<label class="control-label" for="docname">Document Name</label>
															<div class="controls">
																<input type="text" class="input-large" name="docname" id="docname">																		
															</div> <!-- /controls -->				
													</div> <!-- /control-group -->
													
													<div class="control-group">											
														<label class="control-label" for="docdescr">Description</label>
															<div class="controls">
																<input type="text" class="input-xlarge" class="span8" name="docdescr" id="docdescr">																		
															</div> <!-- /controls -->				
													</div> <!-- /control-group -->
																
													<div class="control-group">											
														<label class="control-label" for="docdate">Document Date</label>
															<div class="controls">
																<input type="text" class="input-small" name="docdate" id="datepicker-inline7">
															</div> <!-- /controls -->				
													</div> <!-- /control-group -->
																
													<div class="control-group">
														<label class="control-label" for="filetype">Document Type</label>
															<div class="controls">
																<label class="radio">
																	<input type="radio" name="filetype" value=".pdf" checked="checked" id="filetype">
																	PDF
																</label>
																<label class="radio">
																	<input type="radio" name="filetype" value=".doc">
																	Word Document
																</label>
																<label class="radio">
																	<input type="radio" name="filetype" value=".txt">
																	Text Document
																</label>
																<label class="radio">
																	<input type="radio" name="filetype" value=".xls">
																	Excel Document
																</label>
																<label class="radio">
																	<input type="radio" name="filetype" value=".msg">
																	Email Message (Outlook)
																</label>
															</div>
													</div>																						
																
													<br />
													<div class="form-actions">													
														<button type="submit" class="btn btn-secondary" name="savelead"><i class="icon-save"></i> Save Form</button>																										
														<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.library.forms'"><i class="icon-remove-sign"></i> Cancel</a>													
														<input name="utf8" type="hidden" value="&##955;">																												
														<input type="hidden" name="__authToken" value="#randout#" />
														<input name="validate_require" type="hidden" value="docname|The document must have a valid name to upload.;docdate|Please select a document date.;fileuploadpath|Please select a file to upload...;doccat|Please enter a document category for this new form." />															
													</div> <!-- /form-actions -->
												</fieldset>
										</form>
									</cfoutput>
									

									<div class="clear"></div>
								</div> <!-- //.widget-content -->	
									
							</div> <!-- //.widget -->
							
						</div> <!-- //.span12 -->
						
					</div> <!-- //.row -->				
				
					<div style="height:200px;"></div>			
					
				</div> <!-- //.container -->
			
			</div> <!-- //.main -->
			
			
			
			