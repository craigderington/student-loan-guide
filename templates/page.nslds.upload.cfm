


			<!--- // 1-24-2014 // newpage to upload and parse NSLDS text file to add student loan debt worksheets --->
			<!--- // 3-26-2014 // modifications added to the upload and import workflow --->				
			
			<!--- // check to see if we have an existing NSLDS session ID, if so - remove it --->
			<cfif structkeyexists( session, "nslds" )>
				<cfparam name="tempQ" default="">
				<cfset tempQ = structdelete( session, "nslds" ) />
			</cfif>
			
			
			<!--- get our data components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>			
			
			<cfinvoke component="apis.com.nslds.nsldsgateway" method="getnsldslist" returnvariable="nsldslist">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.nslds.nsldsgateway" method="getuploadsbyid" returnvariable="muploadbyid">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			
			
			
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
						
							<div class="widget stacked">
								<cfoutput>	
								<div class="widget-header">		
									<i class="icon-upload"></i>							
									<h3>Upload NSLDS Student Loan Text File for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
								</div> <!-- //.widget-header -->
								</cfoutput>	
							
								<div class="widget-content">								
									
									<!--- // begin form processing --->
									<cfif isDefined( "form.fieldnames" )>
										<cfscript>
											objValidation = createObject( "component","apis.com.ui.validation" ).init();
											objValidation.setFields(form);
											objValidation.validate();
										</cfscript>

										<cfif objValidation.getErrorCount() is 0>							
											
											<!--- // declare filepath variables --->
											<cfparam name="fileuploadpath" default="">
											<cfparam name="filecheck" default="">
											<cfparam name="linecount" default="0">
											<cfparam name="errorcount" default="0">
											<cfparam name="line" default="">
											<cfparam name="today" default="">
											<cfparam name="leadid" default="">									
											
											
											<!--- check to make sure the file upload path is not an empty string --->
											<cfif trim( form.fileuploadpath ) is "">
											
												<div class="alert alert-error">
													<a class="close" data-dismiss="alert">&times;</a>
														<h5><error>There were errors in your submission:</error></h2>
															<ul>
																<li>You did not select a file to upload.  The process has terminated...</li>															
															</ul>
												</div>
												
											<cfelse>
											
											
												<!--- // do this --->
												<cffile action="read" file="#fileuploadpath#" variable="filecontents">						
			
												<!--- windows o/s new line characters --->
												<cfset newLine	 = chr(13) & chr(10) />			
											
											
													<!--- // start a new upload session and create a unique id to relate to this upload --->
													<cfquery datasource="SLAdmin" name="txtupload">
															insert into nsltxt(nsltxtuuid,leadid,nsltxtdate,nsltxtby,nsltxtcomp)
																values(
																	   <cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar" maxlength="35" />,
																	   <cfqueryparam value="#session.leadid#" cfsqltype="cf_sql_integer" />,
																	   <cfqueryparam value="#createodbcdatetime( now() )#" cfsqltype="cf_sql_timestamp" />,
																	   <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																	   <cfqueryparam value="1" cfsqltype="cf_sql_bit" />								
																	   ); select @@identity as newuploadid						
													</cfquery>
												
												
												
													<!--- // loop the file contents and insert the entire file to the database as rows --->
													<cfloop list="#filecontents#" index="line" delimiters="#newLine#">
														<cfquery datasource="SLAdmin" name="addtextdata">
															insert into nsltxtdata(nsltxtid, datalabel, datacontent)
																values(
																	   <cfqueryparam value="#txtupload.newuploadid#" cfsqltype="cf_sql_integer" />,
																	   <cfqueryparam value="#listfirst( line, ":" )#" cfsqltype="cf_sql_varchar" />,
																	   <cfqueryparam value="#listlast( line, ":" )#" cfsqltype="cf_sql_varchar" />								
																	   );							     
														</cfquery>
													</cfloop>
												
													<cfset session.nslds = #txtupload.newuploadid# />
												
												
													<cfif isuserinrole( "bclient" )>
														<cfinvoke component="apis.com.portal.portaltaskgateway" method="markportaltaskcompleted" returnvariable="taskstatusmsg">
															<cfinvokeargument name="portaltaskid" value="1408">
															<cfinvokeargument name="leadid" value="#session.leadid#">
														</cfinvoke>
														<cfinvoke component="apis.com.portal.portaltaskgateway" method="markportaltaskcompleted" returnvariable="taskstatusmsg">
															<cfinvokeargument name="portaltaskid" value="1409">
															<cfinvokeargument name="leadid" value="#session.leadid#">
														</cfinvoke>
													</cfif>							
												
													<!--- // create a short pause --->
													<cfscript>
														thread = createobject( "java", "java.lang.Thread" );
														thread.sleep(5000);
													</cfscript>				
													
													<!--- // then redirect to the next step in the process --->															
													<cflocation url="#application.root#?event=page.nslds.analyze" addtoken="yes">
											
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
									<!--- // end form processing --->
									
									
									
									<h4><i class="icon-upload-alt"></i> Upload Your NSLDS Text File</h4> 
									
									<p>This form will allow you to upload and parse the National Student Loan Data System (NSLDS) text file generated from the NSLDS website.  Only official Department of Education NSLDS text files may be used to create student loan debt worksheets.</p>
									
									<br /><br />
										
									<cfoutput>
										<form id="upload-documents" class="form-horizontal" method="post" action="#application.root#?event=page.nslds.upload" enctype="multipart/form-data">
											<fieldset>
																
												<div class="control-group">
													<label class="control-label" for="fileuploadpath">Browse for File</label>
														<div class="controls">
															<input type="file" name="fileuploadpath" class="input-large" id="fileuploadpath">
														</div> <!-- /controls -->	
												</div> <!-- /control-group -->																																				
																
												<br />
														
												<div class="form-actions">													
													<button type="submit" class="btn btn-secondary msgbox-info" name="savelead"><i class="icon-upload-alt"></i> Process NSLDS File</button>																										
													<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.worksheet'"><i class="icon-remove-sign"></i> Cancel</a>													
													<input name="utf8" type="hidden" value="&##955;">													
													<input type="hidden" name="leadid" value="#leaddetail.leadid#" />																	
													<input type="hidden" name="__authToken" value="#randout#" />
													<input name="validate_require" type="hidden" value="leadid|Opps, sorry... the form can not be posted due to an internal error.  Please re-load the page and try again." />
													<!---
													<input name="validate_file" type="hidden" value="document|txt|The NSLDS text file must be in the proper file format.  Please check your file and try again..." />
													--->
												</div> <!-- /form-actions -->
											</fieldset>
										</form>
										
									</cfoutput>
														
						
						
								</div><!-- /.widget-content -->
							
							</div><!-- /.widget -->						
							
						</div><!-- /.span12 -->
						
					</div><!-- /.row -->
					
					
					<cfif nsldslist.recordcount gt 0>
						<!--- // show previously uploaded nslds text files --->
						<div class="row">
							<div class="span12">
								<div class="widget stacked">
										
									<div class="widget-header">		
										<i class="icon-upload"></i>							
										<h3>Previous NSLDS Files Uploaded</h3>						
									</div>

									<div class="widget-content">
										<cfoutput query="muploadbyid">
											<a href="#application.root#?event=page.nslds.history&fuseaction=doanalysis&nsldsid=#muploadbyid.nsltxtuuid#" class="btn btn-mini btn-primary" style="margin-bottom:5px;"><i class="icon-upload-alt btn-icon-only"></i></a> &nbsp;<strong>#firstname# #lastname#</strong> uploaded a NSLDS text file on <strong>#dateformat( nsltxtdate, "mm/dd/yyyy" )#</strong> <br />
										</cfoutput>
									</div>
								</div>
							</div>
						</div>
						<div style="margin-top:100px;"></div>
					<cfelse>
						<div style="margin-top:200px;"></div>					
					</cfif>				
					
				
				</div><!-- /.container -->
			
			</div><!-- /.main -->