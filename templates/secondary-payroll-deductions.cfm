


			<!--- // this is the secondary payroll deductions page --->
		
		
			<!--- get our data components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
				
			<cfinvoke component="apis.com.clients.budgetgateway" method="getbudget" returnvariable="budget">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<!--- get our authtoken random key generator --->
			<cfinvoke component="apis.udfs.genAlpha" method="genRandomAlphaString" returnvariable="randout">
		
			
			<!--- // set our totals for the primary income payroll deductions --->
			<cfparam name="totalprimarydeductions" default="0.00">
			<cfset totalsecondarydeductions = budget.secondarywithholding + budget.secondaryfica + budget.secondarymedicare + budget.secondary401k + budget.secondarybenefits + budget.secondarycitytax + budget.secondarystatetax />
			<cfset totalsecondarydeductions = numberformat ( totalsecondarydeductions, "99.99" ) />
			
			
			
			<!--- // declare our form vars --->
			<cfparam name="fedwith" default="">
			<cfparam name="fica" default="">
			<cfparam name="medicare" default="">
			<cfparam name="invest401k" default="">
			<cfparam name="benefits" default="">
			<cfparam name="citytax" default="">
			<cfparam name="statetax" default="">	
		
		
		
		
			<!doctype html>
			<html lang="en">
				<!--[if lt IE 7]> <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
				<!--[if IE 7]>    <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
				<!--[if IE 8]>    <html class="no-js lt-ie9" lang="en"> <![endif]-->
				<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
				<title>Secondary Income Payroll Deductions</title>
					
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
					
					
					
				
				
				<body style="padding:10px;">
					
					
					<div class="widget stacked">
						
						<div class="widget-header">		
							<i class="icon-money"></i>							
							<h3>Secondary Income &raquo; Payroll Deductions</h3>						
						</div>				
						
						<div class="widget-content">						
							
							<!--- // process the form and refresh the parent window --->
							<cfif structkeyexists( form, "savepayrolldeduct" )>
							
								<!--- // create our structure for our database action and bind form elements --->
								<cfset pd = structnew() />
								<cfset pd.budgetid = trim( form.budgetuuid ) />
								<cfset pd.fedwith = rereplace( form.fedwith, "[\$,]", "", "all" ) />
								<cfset pd.fica = rereplace( form.fica, "[\$,]", "", "all" ) />
								<cfset pd.medicare = rereplace( form.medicare, "[\$,]", "", "all" ) />
								<cfset pd.invest401k = rereplace( form.invest401k, "[\$,]", "", "all" ) />
								<cfset pd.benefit = rereplace( form.benefits, "[\$,]", "", "all" ) />
								<cfset pd.citytax = rereplace( form.citytax, "[\$,]", "", "all" ) />
								<cfset pd.statetax = rereplace( form.statetax, "[\$,]", "", "all" ) />
								
								
								<!--- check to make surew we have our authtoken key in our form struct --->
								<cfif structkeyexists( form, "budgetuuid" ) and isvalid( "uuid", form.budgetuuid )>									
									
									<cfif structkeyexists( form, "__authToken" ) and len( form.__authToken ) eq 20 >									
									
										<!--- // update the payroll deductions in the budget table --->
										<cfquery datasource="#application.dsn#" name="savepayrolldeduct">
											update budget
											   set secondarywithholding = <cfqueryparam value="#pd.fedwith#" cfsqltype="cf_sql_float" />,
												   secondaryfica = <cfqueryparam value="#pd.fica#" cfsqltype="cf_sql_float" />,
												   secondarymedicare = <cfqueryparam value="#pd.medicare#" cfsqltype="cf_sql_float" />,
												   secondary401k = <cfqueryparam value="#pd.invest401k#" cfsqltype="cf_sql_float" />,
												   secondarybenefits = <cfqueryparam value="#pd.benefit#" cfsqltype="cf_sql_float" />,
												   secondarycitytax = <cfqueryparam value="#pd.citytax#" cfsqltype="cf_sql_float" />,
												   secondarystatetax = <cfqueryparam value="#pd.statetax#" cfsqltype="cf_sql_float" />
											 where budgetuuid = <cfqueryparam value="#pd.budgetid#" cfsqltype="cf_sql_varchar" maxlength="35" />
										</cfquery>
										
										<!--- after the database update, close the child window and refresh the parent --->
										<script>
											self.location="javascript:refreshParent();"
										</script>
									
									<cfelse>
									
										<script>
											alert('Sorry, there are required form fields missing in the form data submission.  This window will automatically close...');
											self.location="javascript:window.self.close();"
										</script>									
									
									</cfif>
									
								<cfelse>
								
									<script>
										alert('There was a problem posting the form.  This window will automatically close...');
										self.location="javascript:window.self.close();"
									</script>
								
								
								</cfif>
							
							
							</cfif>
							
							
							
							
							
							
							
							
							<!--- // output the payroll deductions and draw the form --->
							<cfoutput>
							<form id="payroll-deduct-secondary" class="form-horizontal" method="post" action="#cgi.script_name#">					
								<fieldset>				
									
									<cfif totalsecondarydeductions neq 0.00>
										<div class="control-group">											
										<label class="control-label" for="fedwith">Total Deductions</label>
											<div class="controls">
												<input type="text" name="totaldeduct" class="input-small" value="#totalsecondarydeductions#" readonly="true" />
											</div> <!-- /controls -->				
									</div> <!-- /control-group -->
									</cfif>
									
									
									<div class="control-group">											
										<label class="control-label" for="fedwith">Federal Withholding</label>
											<div class="controls">
												<input type="text" class="input-small" name="fedwith" value="#numberformat( budget.secondarywithholding, 'L99.99' )#" />
											</div> <!-- /controls -->				
									</div> <!-- /control-group -->
																			
									<div class="control-group">											
										<label class="control-label" for="fica">FICA</label>
											<div class="controls">
												<input type="text" class="input-small" name="fica" value="#numberformat( budget.secondaryfica, 'L99.99' )#" />
											</div> <!-- /controls -->				
									</div> <!-- /control-group -->

									<div class="control-group">											
										<label class="control-label" for="medicare">Medicare</label>
											<div class="controls">
												<input type="text" class="input-small" name="medicare" value="#numberformat( budget.secondarymedicare, 'L99.99' )#" />
											</div> <!-- /controls -->				
									</div> <!-- /control-group -->
																			
									<div class="control-group">											
										<label class="control-label" for="invest401k">Investments (401k)</label>
											<div class="controls">
												<input type="text" class="input-small" name="invest401k" value="#numberformat( budget.secondary401k, 'L99.99' )#" />
											</div> <!-- /controls -->				
									</div> <!-- /control-group -->
																			
									<div class="control-group">											
										<label class="control-label" for="benefits">Benefits</label>
											<div class="controls">
												<input type="text" class="input-small" name="benefits" value="#numberformat( budget.secondarybenefits, 'L99.99' )#" />
											</div> <!-- /controls -->				
									</div> <!-- /control-group -->
																			
									<div class="control-group">											
										<label class="control-label" for="citytax">City Tax</label>
											<div class="controls">
												<input type="text" class="input-small" name="citytax" value="#numberformat( budget.secondarycitytax, 'L99.99' )#" />
											</div> <!-- /controls -->				
									</div> <!-- /control-group -->

									<div class="control-group">											
										<label class="control-label" for="statetax">State Tax</label>
											<div class="controls">
												<input type="text" class="input-small" name="statetax" value="#numberformat( budget.secondarystatetax, 'L99.99' )#" />
											</div> <!-- /controls -->				
									</div> <!-- /control-group -->
																			
																										
									<div class="form-actions">													
										<button type="submit" class="btn btn-secondary" name="savepayrolldeduct"><i class="icon-save"></i> Save Payroll Deductions</button>																									
										<a name="cancel" class="btn btn-primary" onclick="javascript:refreshParent();"><i class="icon-remove-sign"></i> Cancel</a>													
										<input name="utf8" type="hidden" value="&##955;">													
										<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
										<input type="hidden" name="__authToken" value="#randout#" />
										<input type="hidden" name="budgetuuid" value="#budget.budgetuuid#" />																													
									</div> <!-- /form-actions -->						
								</fieldset>						
							</form>
							</cfoutput>				
						
						</div>
					</div><!-- // .widget -->
					
				</body>		
			</html>