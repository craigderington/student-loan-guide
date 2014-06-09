


			<!--- // this is the primary payroll deductions page --->
		
		
			<!--- get our data components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
				
			<cfinvoke component="apis.com.clients.budgetgateway" method="getbudget" returnvariable="budget">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
		
			
			<!--- // set our totals for the primary income payroll deductions --->
			<cfparam name="totalprimarydeductions" default="0.00">
			<cfset totalprimarydeductions = budget.primarywithholding + budget.primaryfica + budget.primarymedicare + budget.primary401k + budget.primarybenefits + budget.primarycitytax + budget.primarystatetax />
			<cfset totalprimarydeductions = numberformat ( totalprimarydeductions, "99.99" ) />
			
			
			
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
				<title>Primary Income Payroll Deductions</title>
					
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
							<h3>Primary Income &raquo; Payroll Deductions</h3>						
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
									
									<!--- // update the payroll deductions in the budget table --->
									<cfquery datasource="#application.dsn#" name="savepayrolldeduct">
										update budget
										   set primarywithholding = <cfqueryparam value="#pd.fedwith#" cfsqltype="cf_sql_float" />,
											   primaryfica = <cfqueryparam value="#pd.fica#" cfsqltype="cf_sql_float" />,
											   primarymedicare = <cfqueryparam value="#pd.medicare#" cfsqltype="cf_sql_float" />,
											   primary401k = <cfqueryparam value="#pd.invest401k#" cfsqltype="cf_sql_float" />,
											   primarybenefits = <cfqueryparam value="#pd.benefit#" cfsqltype="cf_sql_float" />,
											   primarycitytax = <cfqueryparam value="#pd.citytax#" cfsqltype="cf_sql_float" />,
											   primarystatetax = <cfqueryparam value="#pd.statetax#" cfsqltype="cf_sql_float" />
										 where budgetuuid = <cfqueryparam value="#pd.budgetid#" cfsqltype="cf_sql_varchar" maxlength="35" />
									</cfquery>
									
									<!--- after the database update, close the child window and refresh the parent --->
									<script>
										self.location="javascript:refreshParent();"
									</script>
								
								<cfelse>
								
									<script>
										alert('There was a problem posting the form.  This window will automatically close...');
										self.location="javascript:window.self.close();"
									</script>
								
								
								</cfif>
							
							
							</cfif>
							
							
							
							
							
							
							
							
							<!--- // output the payroll deductions and draw the form --->
							<cfoutput>
							<form id="payroll-deduct-primary" class="form-horizontal" method="post" action="#cgi.script_name#">					
								<fieldset>				
									
									<cfif totalprimarydeductions neq 0.00>
										<div class="control-group">											
										<label class="control-label" for="fedwith">Total Deductions</label>
											<div class="controls">
												<input type="text" name="totaldeduct" class="input-small" value="#totalprimarydeductions#" readonly="true" />
											</div> <!-- /controls -->				
									</div> <!-- /control-group -->
									</cfif>
									
									
									<div class="control-group">											
										<label class="control-label" for="fedwith">Federal Withholding</label>
											<div class="controls">
												<input type="text" class="input-small" name="fedwith" value="#numberformat( budget.primarywithholding, 'L99.99' )#" />
											</div> <!-- /controls -->				
									</div> <!-- /control-group -->
																			
									<div class="control-group">											
										<label class="control-label" for="fica">FICA</label>
											<div class="controls">
												<input type="text" class="input-small" name="fica" value="#numberformat( budget.primaryfica, 'L99.99' )#" />
											</div> <!-- /controls -->				
									</div> <!-- /control-group -->

									<div class="control-group">											
										<label class="control-label" for="medicare">Medicare</label>
											<div class="controls">
												<input type="text" class="input-small" name="medicare" value="#numberformat( budget.primarymedicare, 'L99.99' )#" />
											</div> <!-- /controls -->				
									</div> <!-- /control-group -->
																			
									<div class="control-group">											
										<label class="control-label" for="invest401k">Investments (401k)</label>
											<div class="controls">
												<input type="text" class="input-small" name="invest401k" value="#numberformat( budget.primary401k, 'L99.99' )#" />
											</div> <!-- /controls -->				
									</div> <!-- /control-group -->
																			
									<div class="control-group">											
										<label class="control-label" for="benefits">Benefits</label>
											<div class="controls">
												<input type="text" class="input-small" name="benefits" value="#numberformat( budget.primarybenefits, 'L99.99' )#" />
											</div> <!-- /controls -->				
									</div> <!-- /control-group -->
																			
									<div class="control-group">											
										<label class="control-label" for="citytax">City Tax</label>
											<div class="controls">
												<input type="text" class="input-small" name="citytax" value="#numberformat( budget.primarycitytax, 'L99.99' )#" />
											</div> <!-- /controls -->				
									</div> <!-- /control-group -->

									<div class="control-group">											
										<label class="control-label" for="statetax">State Tax</label>
											<div class="controls">
												<input type="text" class="input-small" name="statetax" value="#numberformat( budget.primarystatetax, 'L99.99' )#" />
											</div> <!-- /controls -->				
									</div> <!-- /control-group -->
																			
																										
									<div class="form-actions">													
										<button type="submit" class="btn btn-secondary" name="savepayrolldeduct"><i class="icon-save"></i> Save Payroll Deductions</button>																									
										<a name="cancel" class="btn btn-primary" onclick="javascript:refreshParent();"><i class="icon-remove-sign"></i> Cancel</a>													
										<input name="utf8" type="hidden" value="&##955;">													
										<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
										<input type="hidden" name="budgetuuid" value="#budget.budgetuuid#" />																													
									</div> <!-- /form-actions -->						
								</fieldset>						
							</form>
							</cfoutput>				
						
						</div>
					</div><!-- // .widget -->
					
				</body>		
			</html>