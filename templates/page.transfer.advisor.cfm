


			<!doctype html>
					<html lang="en">
						<!--[if lt IE 7]> <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
						<!--[if IE 7]>    <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
						<!--[if IE 8]>    <html class="no-js lt-ie9" lang="en"> <![endif]-->
						<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
						<title>Transfer Advisor</title>
							
							<head>
								<meta charset="utf-8">
								<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
								<meta name="apple-mobile-web-app-capable" content="yes"> 
								<link href="../css/bootstrap.min.css" rel="stylesheet" type="text/css" />
								<link href="../css/bootstrap-responsive.min.css" rel="stylesheet" type="text/css" />				
								<link href="../css/font-awesome.min.css" rel="stylesheet">
								<link rel="stylesheet" type="text/css" href="//fonts.googleapis.com/css?family=Open+Sans:400italic,600italic,400,600" >				
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
							
							
							
						
						
								<body style="padding:15px;">
								
									<!--- // get the data access components --->
									<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetailbyuuid" returnvariable="leaddetailbyuuid">
										<cfinvokeargument name="leadid" value="#url.leadid#">
									</cfinvoke>		
									
									<cfinvoke component="apis.com.reports.reportgateway" method="getleadassignmentsbyrole" returnvariable="leadassignmentsbyrole">
										<cfinvokeargument name="leadid" value="#url.leadid#">
										<cfinvokeargument name="role" value="#url.role#">
									</cfinvoke>
									
									<cfparam name="thisrole" default="">
									<cfparam name="currentadvisorid" default="">
									<cfparam name="currentassignid" default="">
									<cfset thisrole = #url.role# />
									<cfset currentadvisorid = #leadassignmentsbyrole.leadassignuserid# />
									<cfset currentassignid = #leadassignmentsbyrole.leadassignid# />
									
									<cfinvoke component="apis.com.reports.reportgateway" method="gettransferadvisorlist" returnvariable="transferadvisorlist">
										<cfinvokeargument name="companyid" value="#session.companyid#">
										<cfinvokeargument name="roletype" value="#url.role#">
										<cfinvokeargument name="currentadvisorid" value="#currentadvisorid#">
									</cfinvoke>
									
									
									
									
									
									
									
										<div class="widget stacked">
											
											<cfoutput>
											<div class="widget-header">		
												<i class="icon-exchange"></i>							
												<h3>Transfer #ucase( thisrole )# Advisor</h3>						
											</div>				
											</cfoutput>
											
											
											<div class="widget-content">
											
												<!--- // validate CFC Form Processing --->						
									
													<cfif isDefined( "form.fieldnames" )>
														<cfscript>
															objValidation = createobject( "component","apis.com.ui.validation" ).init();
															objValidation.setFields( form );
															objValidation.validate();
														</cfscript>

														<cfif objValidation.getErrorCount() is 0>							
															
															<!--- define our structure and set form values--->
															<cfset transfer = structnew() />
															<cfset transfer.userid = form.rgadvisorlist />
																
																
															<!--- // update the existing assignment and mark as transferred --->
															<cfquery datasource="#application.dsn#" name="saveassignmentdetails">
																	update leadassignments
																	   set leadassignuserid = <cfqueryparam value="#transfer.userid#" cfsqltype="cf_sql_integer" />,
																		   leadassigntransfer = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />,
																		   leadassigntransfertoid = <cfqueryparam value="#currentadvisorid#" cfsqltype="cf_sql_integer" />,
																		   leadassigntransferdate = <cfqueryparam value="#createodbcdatetime( now() )#" cfsqltype="cf_sql_timestamp" />														   														   
																	 where leadassignid = <cfqueryparam value="#currentassignid#" cfsqltype="cf_sql_integer" />
															</cfquery>			
																
															<!--- // log the activity --->
															<cfquery datasource="#application.dsn#" name="logact">
																insert into activity(leadid, userid, activitydate, activitytype, activity)
																	values (
																			<cfqueryparam value="#leaddetailbyuuid.leadid#" cfsqltype="cf_sql_integer" />,
																			<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																			<cfqueryparam value="#createodbcdatetime( now() )#" cfsqltype="cf_sql_timestamp" />,
																			<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
																			<cfqueryparam value="#session.username# transferred the case file to a new #thisrole# advisor for #leaddetailbyuuid.leadfirst# #leaddetailbyuuid.leadlast#." cfsqltype="cf_sql_varchar" />
																			);
															</cfquery>
															
															
															<script>
																self.location="javascript:refreshParent();"
															</script>
															
															
															
												
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
									
									
									
									
									
									
									
									
									
									
									
									
									
									
									
									
									
									
									
									
												
												<cfoutput>
													
													
													<form id="transfer-advisor" class="form-horizontal" method="post" action="#cgi.script_name#?leadid=#url.leadid#&role=#thisrole#">
															<fieldset style="padding:15px;">
																
																<h5>Current Advisor</h5>
																<p>#leadassignmentsbyrole.firstname# #leadassignmentsbyrole.lastname#</p>
																							
																<br />	
																<br />
																
																<cfif transferadvisorlist.recordcount gt 0>
																	
																	<div class="control-group">
																		<label class="control-label" for="advisorlist">Transfer To</label>
																		<div class="controls">
																			<cfloop query="transferadvisorlist">
																				<label class="checkbox">
																					<input type="radio" name="rgadvisorlist" value="#userid#" />  #firstname# #lastname#
																				</label>
																			</cfloop>
																		</div>
																	</div>
																	
																
																
																	<br />											
																	
																	<!---
																	#currentassignid# <br />
																	#thisrole# <br />
																	#currentadvisorid#
																	--->
																	
																	
																	
																	<div class="form-actions">													
																		<button type="submit" class="btn btn-secondary" name="savetransfer"><i class="icon-save"></i> Transfer</button>
																		<a href="javascript:refreshParent();" class="btn btn-primary"><i class="icon-remove"></i> Cancel</a>	
																		<input name="validate_require" type="hidden" value="rgadvisorlist|'You must select an advisor to complete the transfer...'" />
																	</div> <!-- /form-actions -->
																
																<cfelse>
																
																	<div class="alert alert-error">
																		<a class="close" data-dismiss="alert">&times;</a>
																			<h5><error>Sorry, there are no other users with roles of #ucase( thisrole )# defined for your company...</error></h5>
																			<p>The record can not be transferred because there are no other users defined in the system with the role of #ucase( thisrole )#.  Please check with your company administrator about setting up additional roles for your users.</p>
																			<br />
																			<a href="javascript:refreshParent();" class="btn btn-secondary"><i class="icon-refresh"></i> Close Window</a>
																	</div>
																	
																</cfif>
																
															</fieldset>
														</form>
														
														
														
														
												</cfoutput>
											
											
											</div>
										</div>
								
								
								
								
								
								</body>		
					</html>
		
		
		
		
