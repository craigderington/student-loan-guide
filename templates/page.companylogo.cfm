








						<!doctype html>
						<html lang="en">
							<!--[if lt IE 7]> <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
							<!--[if IE 7]>    <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
							<!--[if IE 8]>    <html class="no-js lt-ie9" lang="en"> <![endif]-->
							<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
							<title>Company Logo</title>
								
								<head>
									<meta charset="utf-8">
									<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
									<meta name="apple-mobile-web-app-capable" content="yes"> 
									<link href="../css/bootstrap.min.css" rel="stylesheet" type="text/css" />
									<link href="../css/bootstrap-responsive.min.css" rel="stylesheet" type="text/css" />				
									<link href="../css/font-awesome.min.css" rel="stylesheet">
									<link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Open+Sans:400italic,600italic,400,600" >				
									<link href="../css/ui-lightness/jquery-ui-1.10.0.custom.min.css" rel="stylesheet">				
									<link href="../css/base-admin-2.css" rel="stylesheet">
									<link href="../css/base-admin-2-responsive.css" rel="stylesheet">
									<link href="../css/pages/dashboard.css" rel="stylesheet">				
									<link href="../css/custom.css" rel="stylesheet">
									<link href="../css/pages/reports.css" rel="stylesheet">					
									
									<!--- // auto-refresh the parent window when the child window closes --->
									<script language="JavaScript">
										<!--
											function refreshParent() {
												window.opener.location.href = window.opener.location.href;

												  if (window.opener.progressWindow)
														
												 {
													window.opener.progressWindow.close()
												  }
												  window.close();
												}
												//-->
									</script>
								
								</head>
								
								
								
							
							
									<body style="padding:25px;">
									
											
										<div class="widget stacked">
											
											<cfif structkeyexists( url, "compid" ) and isvalid( "integer", url.compid )>
												<cfinvoke component="apis.com.admin.companyadmingateway" method="getcompany" returnvariable="compdetail">
													<cfinvokeargument name="companyid" value="#url.compid#">
												</cfinvoke>
											</cfif>					
											
											<cfoutput>
												<div class="widget-header">		
													<i class="icon-globe"></i>							
													<h3>#session.companyname# Logo</h3>						
												</div>
											</cfoutput>										
											
											
											<div class="widget-content">


												
													
													<cfif structkeyexists( form, "savelogo" )>														
														
														<!--- define our structure and set form values --->
														<cfset comp = structnew() />											
														<cfset comp.compid = #form.compid# />
														<cfset comp.uploadpath = #form.fileuploadpath# />									
														<cfset today = #CreateODBCDateTime(now())# />							
														<cfset comp.allowedimages = "jpg,png,gif" />													
															
															<cfif comp.uploadpath is not "">														
															
																<!--- // write the file to the server --->								
																<cffile action="upload" source="#form.fileuploadpath#" destination="#expandpath( '\img\logos\' )#" nameconflict="makeunique" >
																	
																<!--- // get the server and client file name --->
																<cfset comp.thisimagename = cffile.serverfile />						
																
																<!--- // create the database record --->
																<cfquery datasource="#application.dsn#" name="logoupload">
																	update company
																	   set complogo = <cfqueryparam value="img/logos/#comp.thisimagename#" cfsqltype="cf_sql_varchar" />
																	 where companyid = <cfqueryparam value="#comp.compid#" cfsqltype="cf_sql_integer" />
																</cfquery>										
																		
																<!--- // log the activity --->
																<cfquery datasource="#application.dsn#" name="logact">
																	insert into activity(leadid, userid, activitydate, activitytype, activity)
																		values (
																				<cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
																				<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																				<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																				<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
																				<cfqueryparam value="#session.username# uploaded a company logo for #session.companyname#." cfsqltype="cf_sql_varchar" />
																				);
																</cfquery>				
																		
																
																<cflocation url="#cgi.script_name#?compid=#comp.compid#" addtoken="no">							
													
															<cfelse>
															
																<div class="alert alert-error">
																	<a class="close" data-dismiss="alert">&times;</a>
																		<h5><error>There were  errors in your submission:</error></h2>
																		<p>Sorry, there was a problem uploading your company logo...</p>
																</div>
															
															</cfif>
											
													</cfif>
																							
											
												<!--- // start the page --->
												<cfif not structkeyexists( url, "fuseaction" )>					
													
													<cfif compdetail.complogo is "">										
												
												
														<cfoutput>
															<h5><i style="color:red;" class="icon-warning-sign"></i> No Company Logo Image Saved.</h5>
															<p style="margin-top:75px;"><a href="#cgi.script_name#?compid=#url.compid#&fuseaction=upload" class="btn btn-small btn-secondary"><i class="icon-upload"></i>  Upload Company Logo</a></p>
														</cfoutput>
														
														
												
													<cfelse>
													
														<!--- // maybe next time
														<cfparam name="compimage" default="">
														<cfset compimage = imagenew( compdetail.complogo ) />
														<cfset imageresize( compimage, "50%", lanczos, 2 ) />
														--->
														
														
														<cfoutput>
															<div style="align:center;padding:50px;">
																<img src="../#compdetail.complogo#">
																<p style="margin-top:50px;"><a class="btn btn-default btn-mini" href="#cgi.script_name#?compid=#url.compid#&fuseaction=upload"><i class="icon-download-alt"></i> Change Logo</a><a style="margin-left:5px;" class="btn btn-default btn-mini" href="javascript:;" onclick="javascript:refreshParent();"><i class="icon-download"></i> Close Window</a></p>
															</div>
														</cfoutput>
													
													
													</cfif>								
												
												
												<cfelse>
												
												
													
													
													<cfoutput>
														<form id="upload-documents" class="form-horizontal" method="post" action="#cgi.script_name#?compid=#url.compid#&fuseaction=upload" enctype="multipart/form-data">
															<fieldset>
																
																<div class="control-group">
																	<label class="control-label" for="fileuploadpath">Browse for File</label>
																	<div class="controls">
																		<input type="file" name="fileuploadpath" class="input-large" id="fileuploadpath">
																	</div> <!-- /controls -->	
																</div> <!-- /control-group -->																																	
																
																<br />
																<div class="form-actions">													
																	<button type="submit" class="btn btn-secondary" name="savelogo"><i class="icon-save"></i> Save Logo</button>																										
																	<a name="cancel" class="btn btn-primary" onclick="location.href='#cgi.script_name#?compid=#url.compid#'"><i class="icon-remove-sign"></i> Cancel</a>													
																	<input type="hidden" name="compid" value="#url.compid#" />
																	<input name="utf8" type="hidden" value="&##955;">																								
																	<input type="hidden" name="__authToken" value="#randout#" />																	
																</div> <!-- /form-actions -->
															</fieldset>
														</form>
													</cfoutput>		
												
												
												
												</cfif>
												
												
											
												
											</div><!-- / .widget-content -->
										
										
										
										</div><!-- / .widget -->
										
										
										
										
										
										
										
										
									</body>		
						
						
						
						</html>