


			<!--- // this is the primary payroll deductions page --->
		
		
			<!--- get our data components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.implementation.implementgateway" method="getplannotes" returnvariable="notesdetail">
				<cfinvokeargument name="planid" value="#url.planid#">
			</cfinvoke>
				
			
			
			<!--- // a few page vars --->
			<cfparam name="today" default="">
			<cfparam name="mysubstring" default="">
			<cfparam name="mystringlen" default="">
			
			<cfset today = now() />
		
			
			
			
			
			
					<!--- // declare our form vars --->
					<cfparam name="plannotes" default="">
			
							<!--- // process the form update the plan notes--->
							<cfif structkeyexists( form, "saveplannotes" )>
							
								<!--- // create our structure for our database action and bind form elements --->
								<cfset plannotesupdate = #urlencodedformat( form.mytextarea )# />
								<cfset planid = #form.planid# />			
								<cfset mysubstring = "<p><small>#session.username# wrote on #dateformat( today , 'mm/dd/yyyy' )#</small></p>" />
								<cfset mysubstring = urlencodedformat( mysubstring ) />
								<cfset mystringlen = len( plannotesupdate ) />
								
								<cfset plannotesupdate = insert( mysubstring, plannotesupdate, mystringlen ) /> 
								

								
								<!--- // update the implementation notes --->
								<cfquery datasource="#application.dsn#" name="updateplannotes">
									update implement
									   set plannotes = <cfqueryparam value="#plannotesupdate#" cfsqltype="cf_sql_varchar" />											   
									 where planuuid = <cfqueryparam value="#planid#" cfsqltype="cf_sql_varchar" maxlength="35" />
								</cfquery>			
									
								<cflocation url="#cgi.script_name#?planid=#planid#" addtoken="yes">
							
							</cfif>
				
		
		
		
		
			<!doctype html>
			<html lang="en">
				<!--[if lt IE 7]> <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
				<!--[if IE 7]>    <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
				<!--[if IE 8]>    <html class="no-js lt-ie9" lang="en"> <![endif]-->
				<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
				<cfoutput>
					<title>Implementation Plan Notes for #leaddetail.leadfirst# #leaddetail.leadlast# | Plan ID: #trim( url.planid )#</title>
				</cfoutput>
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
					
					<!--- // include the tinymce js path --->
					<script src="//tinymce.cachefly.net/4.0/tinymce.min.js"></script>
					
					
					
					<!--- // initialize tinymce for the rich text editor --->
					<script type="text/javascript">
						tinymce.init({
							selector: "textarea",
							auto_focus: "plannotes",
							width: 680,
							height: 350
						 });
					</script>
					
					
					
					</head>
					
					
					
				
				
				<body style="padding:10px;">
					
					
					<div class="widget stacked">
						<cfoutput>
							<div class="widget-header">		
								<i class="icon-copy"></i>							
								<h3>Implementation Notes Section for Plan ID: #notesdetail.planuuid#</h3>						
							</div>				
						</cfoutput>
						<div class="widget-content">						
							
							
							
							
							
							
							
							
							
							
							<!--- // output the payroll deductions and draw the form --->
							<cfoutput>
							<form class="form-horizontal" method="post" action="#cgi.script_name#?planid=#notesdetail.planuuid#">					
								<fieldset>
									
									<cfif structkeyexists( url, "cfid" ) and structkeyexists( url, "jsessionid" )>
										<div class="alert alert-info">											
											<strong><i class="icon-check"></i> NOTES SAVED!</strong>
										</div>
									</cfif>
									
									
									<div class="control-group">											
										<label class="control-label" for="plannotessection">Plan Notes</label>
											<div class="controls">
												<textarea name="mytextarea" id="plannotes">#urldecode( notesdetail.plannotes )#</textarea>
											</div> <!-- /controls -->				
									</div> <!-- /control-group -->
																			
									
																			
									
																			
																										
									<div class="form-actions">													
										<button type="submit" class="btn btn-secondary" name="saveplannotes"><i class="icon-save"></i> Save Notes</button>																									
										<a name="cancel" class="btn btn-default" onclick="javascript:refreshParent();"><i class="icon-remove-sign"></i> Close Window</a>													
										<input name="utf8" type="hidden" value="&##955;">													
										<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
										<input type="hidden" name="planid" value="#notesdetail.planuuid#" />
									</div> <!-- /form-actions -->						
								</fieldset>						
							</form>
							</cfoutput>				
						
						</div>
					</div><!-- // .widget -->
					
				</body>		
			</html>