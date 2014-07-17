

			
			<!--- // get our data access components --->
			<cfinvoke component="apis.com.solutions.solutiongateway" method="getsolutionnotes" returnvariable="solutionnotes">
				<cfinvokeargument name="tree" value="#url.tree#">
				<cfinvokeargument name="solution" value="#url.solution#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.solutions.solutiongateway" method="getsolutiontypes" returnvariable="solutiontype">
				<cfinvokeargument name="option" value="#url.option#">
				<cfinvokeargument name="solution" value="#url.solution#">
			</cfinvoke>		
			
			<!--- // define some page vars --->
			<cfparam name="treenum" default="">
			<cfparam name="solname" default="">
			<cfset treenum = #url.tree# />
			<cfset solname = #url.solution# />
			
			<!--- // get our formatted list of loan codes --->
			<cfinvoke component="apis.com.solutions.solutiongateway" method="getloancodes" returnvariable="loancodelist">
				<cfinvokeargument name="tree" value="#url.tree#">
			</cfinvoke>			
			
			<!--- // get our student loan debt worksheets matching the loan code for the selected solution type --->
			<cfinvoke component="apis.com.worksheets.worksheetgateway" method="getsolutiondebts" returnvariable="solutiondebtlist">
				<cfinvokeargument name="leadid" value="#session.leadid#">
				<cfinvokeargument name="loancodes" value="#loancodelist#">
				<cfinvokeargument name="statuscode" value="#url.option#">
			</cfinvoke>			
			
			<!--- // create our default form vars --->
			<cfparam name="debtid" default="">
			
					
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
							
							<div class="widget stacked">
								<cfoutput>
								<div class="widget-header">		
									<i class="icon-check"></i>							
									<h3 style="font-weight:bold;">Please select individual debt worksheets for <strong>#solutiontype.soltype#</strong>.</h3>					
								</div> <!-- //.widget-header -->
								</cfoutput>
								
								
								<div class="widget-content">

									<!--- // form processing --->
									<cfif isDefined("form.fieldnames")>
										<cfscript>
											objValidation = createObject("component","apis.com.ui.validation").init();
											objValidation.setFields(form);
											objValidation.validate();
										</cfscript>

										<cfif objValidation.getErrorCount() is 0>										
											
											<!--- // prepare array to loop over worksheet IDs  --->
											<cfparam name="slworksheetarray" default="">				
											<cfparam name="refpage" default="">
											<cfset refpage = #form.refpage# />
											<cfset treenum = #form.treenum# />
											<cfset soloption = "#form.soltype#" />
											<cfset optioncat = "#form.optioncat#" />
											<cfset slworksheetarray = listtoarray( form.debtid ) />
											<cfset slidarray = listtoarray( form.sid ) />
																						
											<!--- // some other variables --->
											<cfset today = #CreateODBCDateTime(now())# />										
												
												<!--- // start loop and begin adding debt worksheets to solution --->
												<cfloop from="1" to="#arraylen( slworksheetarray )#" step="1" index="i">													
													<cfquery datasource="#application.dsn#" name="solutionworksheets">
														insert into solution(solutionuuid, leadid,solutiondate,solutionoptiontree,solutionoption,solutionsubcat,solutionworksheetid,solutionnotes,solutionselectedby)
															values	(																	
																	<cfqueryparam value="#slidarray[i]#" cfsqltype="cf_sql_varchar" maxlength="35" />,
																	<cfqueryparam value="#session.leadid#" cfsqltype="cf_sql_integer" />,
																	<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																	<cfqueryparam value="#treenum#" cfsqltype="cf_sql_numeric" />,
																	<cfqueryparam value="#optioncat#" cfsqltype="cf_sql_varchar" />,
																	<cfqueryparam value="#soloption#" cfsqltype="cf_sql_varchar" />,																	
																	<cfqueryparam value="#slworksheetarray[i]#" cfsqltype="cf_sql_integer" />,
																	<cfqueryparam value="None Entered" cfsqltype="cf_sql_varchar" />,
																	<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />																	
																	);
													</cfquery>												
												</cfloop>
												<!--- // end loop --->										
											
												<!--- // log the client activity --->
												<cfquery datasource="#application.dsn#" name="logact">
													insert into activity(leadid, userid, activitydate, activitytype, activity)
														values (
																<cfqueryparam value="#session.leadid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
																<cfqueryparam value="Record Created" cfsqltype="cf_sql_varchar" />,
																<cfqueryparam value="#session.username# selected solution #soloption# and added it to the solution cart." cfsqltype="cf_sql_varchar" />
																); select @@identity as newactid
												</cfquery>
												
												<cfquery datasource="#application.dsn#">
													insert into recent(userid, leadid, activityid, recentdate)
														values (
																<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#session.leadid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#logact.newactid#" cfsqltype="cf_sql_integer" />,
																<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />
																);
												</cfquery>											
											
											<cfif structkeyexists( form, "savesolution" )>
											
												<cflocation url="#refpage#" addtoken="no">
												
											<cfelseif structkeyexists( form, "savesolutioncheckout" )>
											
												<cflocation url="#application.root#?event=page.solution" addtoken="no">			
											
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
								
									<!--- // 5-17-2014 // show solution special notes - system generated 
									<cfif solutionnotes.recordcount gt 0>									
										<div class="alert alert-success">
											<a class="close" data-dismiss="alert">&times;</a>
												<h5><i class="icon-info-sign"></i>&nbsp;&nbsp; DEBT WORKSHEET SPECIAL INSTRUCTIONS</h5>
												<ul>
													<cfoutput query="solutionnotes">
														<li class="formerror">#solutionnotetext#</li>
													</cfoutput>
												</ul>
										</div>					
									</cfif>
									// --->
									
									<!--- // begin list of debt worksheets --->
									<cfif solutiondebtlist.recordcount gt 0>
										
										<form name="solution-cart" action="" method="post">
											<fieldset>	
												<table class="table table-bordered table-striped table-highlight">
													<thead>
														<tr>
															<th width="2%"><div align="center">Select</div></th>
															<th>Loan Type</th>
															<th>Servicer</th>																												
															<th>Balance</th>
															<th>Payment</th>																	
															<th>Origination Date</th>
															<th>Rate</th>													
														</tr>
													</thead>
													<tbody>																		
														<cfoutput query="solutiondebtlist">
														<tr>
															<td><div align="center"><input type="checkbox" name="debtid" value="#worksheetid#"><input type="hidden" name="sid" value="#createuuid()#" /></div></td>
															<td>#codedescr#</td>
															<td><cfif servid neq -1>#servname#<cfelse>#nslservicer#</cfif></td>																										
															<td>#dollarformat( loanbalance )#</td>
															<td>#dollarformat( currentpayment )#</td>
															<td>#dateformat( closeddate, 'mm/dd/yyyy' )#</td>
															<td><span class="label">#numberformat( intrate, '999.99' )#%</span></td>																																												
														</tr>																
														</cfoutput>									
													</tbody>
												</table>
											
												<cfoutput>
												<div class="form-actions">													
													<button type="submit" class="btn btn-secondary" name="savesolution"><i class="icon-shopping-cart"></i> Add to Solution Cart</button>																										
													<button type="submit" class="btn btn-tertiary" name="savesolutioncheckout"><i class="icon-shopping-cart"></i> Add to Solution Cart &amp; Checkout</button>
													<a name="cancel" class="btn btn-primary" onclick="location.href='#cgi.http_referer#'"><i class="icon-remove-sign"></i> Cancel</a>													
													<input type="hidden" name="treenum" value="#url.tree#" />
													<input type="hidden" name="soltype" value="#solutiontype.soltype#" />
													<input type="hidden" name="optioncat" value="#solutiontype.optiontype#" />
													<input type="hidden" name="refpage" value="#cgi.http_referer#" />
													<input name="utf8" type="hidden" value="&##955;">													
													<input type="hidden" name="leadid" value="#session.leadid#" />																	
													<input type="hidden" name="__authToken" value="#randout#" />
													<input name="validate_require" type="hidden" value="debtid|You must select at least one student loan debt worksheet to add to the solution cart." />  
												</div> <!-- /form-actions -->
												</cfoutput>
											
										</fieldset>	
										</form>
									
									
									<cfelse>
									
									
										<!--- // if recordset is empty - show alert --->									
										<div class="alert alert-error">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong><i class="icon-warning-sign"></i>&nbsp;&nbsp;  ALL DEBTS HAVE SOLUTIONS!</strong>  All of the existing student loan debt worksheets already have a solution chosen.  You are ready to check out and complete the process...
										</div>
										
										<div class="row" style="margin-top: 50px;">
											<cfoutput>
												<div class="span12">
													<a name="cancel" class="btn btn-secondary" onclick="location.href='#cgi.http_referer#'"><i class="icon-circle-arrow-left"></i> Go Back</a>
													<a name="cancel" class="btn btn-tertiary" onclick="location.href='#application.root#?event=page.tree'"><i class="icon-sitemap"></i> View Option Trees</a>
													<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.solution'"><i class="icon-shopping-cart"></i> View Solution Cart</a>													
												</div>
											</cfoutput>
										</div>						
									
									</cfif>			

									<div class="clear"></div>
								</div> <!-- //.widget-content -->	
									
							</div> <!-- //.widget -->
							
						</div> <!-- //.span12 -->
						
					</div> <!-- //.row -->				
				
					<div style="height:325px;"></div>			
				
				</div> <!-- //.container -->
			
			</div> <!-- //.main -->