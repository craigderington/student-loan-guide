

			<!--- get our data components --->
			<cfinvoke component="apis.com.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.leadgateway" method="getleadsummary" returnvariable="leadsummary">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.clientloanoptions" method="getclientloaninfo" returnvariable="cloaninfo">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<!--- // determine the loan term // this is needed for other functions --->
			<cfparam name="cloanterm" default="0">
			<cfif cloaninfo.totalloanamount LT 10000>
				<cfset cloanterm = 144 />
			<cfelseif cloaninfo.totalloanamount GT 10000 AND cloaninfo.totalloanamount LTE 19999>
				<cfset cloanterm = 180 />
			<cfelseif cloaninfo.totalloanamount GT 19999 AND cloaninfo.totalloanamount LTE 39999>
				<cfset cloanterm = 240 />
			<cfelseif cloaninfo.totalloanamount GT 39999 AND cloaninfo.totalloanamount LTE 59999>
				<cfset cloanterm = 300 />
			<cfelse>
				<cfset cloanterm = 360 />
			</cfif>

			<!--- // student loan repayment page --->		
					
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
											<strong>SUCCESS!</strong>  The financial information was successfully saved to the client's profile.  Please use the navigation in the sidebar to continue...
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
									<i class="icon-retweet"></i>							
									<h3>Student Loan Repayment Options for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
								</div> <!-- //.widget-header -->
								</cfoutput>
								
								
								<div class="widget-content">

									<!--- // begin form processing --->
									<cfif isDefined("form.fieldnames")>
										<cfscript>
											objValidation = createObject("component","apis.com.validation").init();
											objValidation.setFields(form);
											objValidation.validate();
										</cfscript>

										<cfif objValidation.getErrorCount() is 0>							
											
											<!--- define our structure and set form values --->
											<cfset leadincome = structnew() />
											<cfset leadincome.leadid = #form.leadid# />
											<cfset leadincome.pagi = #rereplace( form.primaryagi, "[\$,]", "", "all" )# />
											<cfset leadincome.sagi = #rereplace( form.secondaryagi, "[\$,]", "", "all" )# />
											<cfset leadincome.spousedebt = rereplace( form.spousedebt, "[\$,]", "", "all" ) />
											<cfset leadincome.filingstatus = #form.filingstatus# />											
											<cfset leadincome.eda = #form.eda# />
											<cfset leadincome.famsize = #form.familysize# />
											<cfif isdefined( "form.mfj" )>
												<cfset leadincome.mfj = "YES" />
											<cfelse>
												<cfset leadincome.mfj = "NO" />
											</cfif>
																						
											<!--- // some other variables --->
											<cfset today = #CreateODBCDateTime(now())# />											
																						
											<!--- // create the database record --->
											<cfquery datasource="#application.dsn#" name="saveincome">
												update slsummary
												   set primaryagi = <cfqueryparam value="#leadincome.pagi#" cfsqltype="cf_sql_float" />,
												       secondaryagi = <cfqueryparam value="#leadincome.sagi#" cfsqltype="cf_sql_float" />,
													   filingstatus = <cfqueryparam value="#leadincome.filingstatus#" cfsqltype="cf_sql_varchar" />,
													   familysize = <cfqueryparam value="#leadincome.famsize#" cfsqltype="cf_sql_numeric" />,
													   mfj = <cfqueryparam value="#leadincome.mfj#" cfsqltype="cf_sql_varchar" />,
													   eda = <cfqueryparam value="#leadincome.eda#" cfsqltype="cf_sql_varchar" />,
													   spousedebt = <cfqueryparam value="#leadincome.spousedebt#" cfsqltype="cf_sql_float" />
												 where leadid = <cfqueryparam value="#leadincome.leadid#" cfsqltype="cf_sql_integer" />													  
											</cfquery>											
											
											<!--- // log the activity --->
											<cfquery datasource="#application.dsn#" name="logact">
												insert into activity(leadid, userid, activitydate, activitytype, activity)
													values (
															<cfqueryparam value="#leadincome.leadid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
															<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
															<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
															<cfqueryparam value="#session.username# saved the loan calculator's financial details for #leaddetail.leadfirst# #leaddetail.leadlast#." cfsqltype="cf_sql_varchar" />
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
								
									
									<!--- // include the sidebar navigation --->
									<div class="span3">
										<cfinclude template="page.sidebar.nav.cfm">
									</div>
									
									
									<div class="span8">
										<cfoutput>
										<h3><i class="icon-retweet"></i> Student Loan Repayment Options <cfif leadsummary.primaryagi is not ""><span style="float:right;"><a href="#application.root#?event=#url.event#&fuseaction=financials" class="btn btn-small btn-primary"><i class="icon-money"></i> Edit Income</a></cfif></h3>
										</cfoutput>
									
										<cfif ( leadsummary.primaryagi is "" and leadsummary.filingstatus is "" ) or ( structkeyexists( url, "fuseaction" ) and url.fuseaction is "financials" )>
											<cfoutput>
											<br />
											<form id="lead-financials" class="form-horizontal" method="post" action="#application.root#?event=page.repayments">
												<fieldset>						
																	
													
													<div class="control-group">										
														<label class="control-label" for="docdate">Debit Authorization</label>
														<div class="controls">
															<select id="eda" name="eda" class="input-medium">
																<option value="YES"<cfif trim( leadsummary.eda ) is "yes">selected</cfif>>Yes</option>
																<option value="NO"<cfif trim( leadsummary.eda ) is "no">selected</cfif>>No</option>																
															</select>
														</div> <!-- /controls -->				
													</div> <!-- /control-group -->
													
													
													<div class="control-group">											
														<label class="control-label" for="docdate">Adjusted Gross Income</label>
														<div class="controls">
															<input type="text" id="primaryagi" name="primaryagi" class="input-small" value="#numberformat( leadsummary.primaryagi, 'L999999.99' )#">															
														</div> <!-- /controls -->				
													</div> <!-- /control-group -->

													<div class="control-group">											
														<label class="control-label" for="docdate">AGI (if married)</label>
														<div class="controls">
															<input type="text" id="secondaryagi" name="secondaryagi" class="input-small" value="#numberformat( leadsummary.secondaryagi, 'L999999.99' )#">															
														</div> <!-- /controls -->				
													</div> <!-- /control-group -->
													
													<div class="control-group">										
														<label class="control-label" for="docdate">Filing Status</label>
														<div class="controls">
															<select id="filingstatus" name="filingstatus" class="input-medium">
																<option value="Single"<cfif trim( leadsummary.filingstatus ) is "single">selected</cfif>>Single</option>
																<option value="Married"<cfif trim( leadsummary.filingstatus ) is "married">selected</cfif>>Married</option>																
															</select>
														</div> <!-- /controls -->				
													</div> <!-- /control-group -->
													
													<div class="control-group">											
														<label class="control-label" for="docdate">Family Size</label>
														<div class="controls">
															<input type="text" id="familysize" name="familysize" class="input-small span1" value="#leadsummary.familysize#">															
														</div> <!-- /controls -->				
													</div> <!-- /control-group -->
													
													<div class="control-group">											
														<label class="control-label" for="docdate">Married Filing Joint</label>
														<div class="controls">
															<input type="checkbox" id="mfj" name="mfj" class="input-small"<cfif trim( leadsummary.mfj ) is "yes">checked</cfif>>															
														</div> <!-- /controls -->				
													</div> <!-- /control-group -->
													
													<div class="control-group">											
														<label class="control-label" for="docdate">Spouse Indebtedness</label>
														<div class="controls">
															<input type="text" id="spousedebt" name="spousedebt" class="input-small" value="#numberformat( leadsummary.spousedebt, 'L999999.99' )#">															
														</div> <!-- /controls -->				
													</div> <!-- /control-group -->
																																						
																	
													<br />
													<div class="form-actions">													
														<button type="submit" class="btn btn-secondary" name="savelead"><i class="icon-save"></i> Save Income</button>																										
														<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.repayments'"><i class="icon-remove-sign"></i> Cancel</a>													
														<input name="utf8" type="hidden" value="&##955;">													
														<input type="hidden" name="leadid" value="#leaddetail.leadid#" />																	
														<input type="hidden" name="__authToken" value="#randout#" />
														<input name="validate_require" type="hidden" value="leadid|Opps, sorry... the form can not be posted due to an internal error.  Please re-load the page and try again.;primaryagi|The Primary Agjusted Gross Income can not be blank.;familysize|The family size can not be blank." />															
														</div> <!-- /form-actions -->
												</fieldset>
											</form>
											</cfoutput>
										
										<cfelse>
										
											<!--- // qualify the client based on the poverty lookup --->
											<cfinvoke component="apis.com.studentloancalculator" method="qualifyclient" returnvariable="qualifyThisClient">
												<cfinvokeargument name="agi" value="#leadsummary.primaryagi#">
												<cfinvokeargument name="famsize" value="#leadsummary.familysize#">
												<cfif trim( leaddetail.leadstate ) IS "AK">
													<cfinvokeargument name="region" value="AK">
												<cfelseif trim( leaddetail.leadstate ) IS "HI">
													<cfinvokeargument name="region" value="AK">
												<cfelse>
													<cfinvokeargument name="region" value="CS">
												</cfif>
											</cfinvoke>
											
											<!--- // calculate the income based plan --->
											<cfinvoke component="apis.com.studentloancalculator" method="calcIBR" returnvariable="mIBR">
												<cfinvokeargument name="agi" value="#leadsummary.primaryagi#">
												<cfinvokeargument name="famsize" value="#leadsummary.familysize#">
												<cfif trim( leaddetail.leadstate ) IS "AK">
													<cfinvokeargument name="region" value="AK">
												<cfelseif trim( leaddetail.leadstate ) IS "HI">
													<cfinvokeargument name="region" value="AK">
												<cfelse>
													<cfinvokeargument name="region" value="CS">
												</cfif>
											</cfinvoke>
											
											
											<!--- // calculate the income contingent plan --->
											<cfinvoke component="apis.com.studentloancalculator" method="calcICR" returnvariable="monthlyPaymentICR">
												<cfinvokeargument name="agi" value="#leadsummary.primaryagi#">
												<cfinvokeargument name="famsize" value="#leadsummary.familysize#">
												<cfinvokeargument name="maritalstatus" value="#leadsummary.filingstatus#">		
												<cfinvokeargument name="leadid" value="#leaddetail.leadid#">
												
												<cfif trim( leaddetail.leadstate ) IS "AK">
													<cfinvokeargument name="region" value="AK">
												<cfelseif trim( leaddetail.leadstate ) IS "HI">
													<cfinvokeargument name="region" value="AK">
												<cfelse>
													<cfinvokeargument name="region" value="CS">
												</cfif>
											</cfinvoke>
											
											<!--- // calculate the income sensitive plan (ISR) 
											<cfinvoke component="apis.com.studentloancalculator" method="calcISR" returnvariable="isrPayment">
												<cfinvokeargument name="agi" value="#leadsummary.primaryagi#">
												<cfinvokeargument name="loanterm" value="#cloanterm#">			
											</cfinvoke>
											--->
											
											<!--- Standard --->
											<cfinvoke component="apis.com.studentloancalculator" method="calcSTD" returnvariable="monthlyPaymentStd">
												<cfinvokeargument name="loanterm" value="#cloanterm#">
												<cfinvokeargument name="leadid" value="#leaddetail.leadid#">
											</cfinvoke>
													
											<!--- Extended --->
											<cfinvoke component="apis.com.studentloancalculator" method="calcExt" returnvariable="mExtPay">
												<cfinvokeargument name="loanterm" value="#cloanterm#">
												<cfinvokeargument name="leadid" value="#leaddetail.leadid#">
											</cfinvoke>
												
											<!--- Graduated --->
											<cfinvoke component="apis.com.studentloancalculator" method="calcGrad" returnvariable="gradInitialPayAmt">
												<cfinvokeargument name="loanterm" value="#cloanterm#">
												<cfinvokeargument name="leadid" value="#leaddetail.leadid#">
											</cfinvoke>
												
											<!--- Extended Graduated --->
											<cfinvoke component="apis.com.studentloancalculator" method="calcExtGrad" returnvariable="strExtGrad">
												<cfinvokeargument name="loanterm" value="#cloanterm#">
												<cfinvokeargument name="leadid" value="#leaddetail.leadid#">
											</cfinvoke>
											
											<!--- // end data components for calculators --->				
										
										
											<br />
											<h5><i class="icon-folder-open"></i> <strong>Student Loan Debt Summary:</strong></h5>
											<cfoutput>												
												<p><strong>Estimated Consolidation Interest Rate:</strong> #numberformat( cloaninfo.weightrate, '99.99' )#%</p>
												<p><strong>Estimated Total Loan Balances:</strong> #dollarformat( cloaninfo.totalloanamount )#</p>
												<p><strong>Total Loans for Consolidation:</strong> #numberformat( cloaninfo.totalloans, '99' )#</p>
												<p><strong>Total Education Indebtedness:</strong> #dollarformat( cloaninfo.totalloandebt )#</p>
											
												<br />
											
												<p><h5><i class="icon-money"></i><strong> Select Repayment Option:</strong></h5></p>
													
													
													<!--- Allow the SLS to select the repayment option and save it to the database --->
													<form id="lead-repayment-options" class="form-horizontal" method="post" action="#application.root#?event=page.repayments">
														
														<table class="table table-bordered table-striped table-highlight">
															<thead>
																<tr>
																	<th width="7%"><div align="center">Select</div></th>
																	<th>Repayment Plan</th>
																	<th>Months in Repayment</th>
																	<th>Monthly Payment</th>
																	<th>Total Payments</th>
																	<th>Details</th>
																</tr>
															</thead>
															<tbody>
																<!--- // standard repayment --->
																
																<tr>
																	<td class="actions"><div align="center"><input type="radio" name="STD" id="STD"></div></td>																					
																	<td>Standard</td>
																	<td>#cloanterm#</td>
																	<td>#dollarformat( monthlyPaymentStd )#</td>
																	<td>#dollarformat( monthlyPaymentStd * cloanterm )#</td>
																	<td><span class="label label-default">View Detail</span></td>
																</tr>
																<!--- graduated --->
																<tr>
																	<td class="actions"><div align="center"><input type="radio" name="grad" id="grad"></div></td>																					
																	<td>Graduated</td>
																	<td>#cloanterm#</td>
																	<td>#dollarformat( gradInitialPayAmt )#</td>
																	<td>#dollarformat( gradInitialPayAmt * cloanterm )#</td>
																	<td><span class="label label-default">View Detail</span>&nbsp;<span class="label label-inverse">See Note 1</span></td>
																</tr>
																<!--- // extended --->
																<cfif cloaninfo.totalloanamount GT 30000 >
																<tr>
																	<td class="actions"><div align="center"><input type="radio" name="extstd" id="extstd"></div></td>																					
																	<td>Extended</td>
																	<td>#mExtPay.mExtTerm#</td>
																	<td>#dollarformat( mExtPay.mExtPayAmt )#</td>
																	<td>#dollarformat( mExtPay.mExtPayAmt * mExtPay.mExtTerm )#</td>
																	<td><span class="label label-default">View Detail</span></td>
																</tr>
																<!--- // extended graduated --->
																<tr>
																	<td class="actions"><div align="center"><input type="radio" name="extgrad" id="extgrad"></div></td>																					
																	<td>Extended Graduated</td>
																	<td>#strExtGrad.newloanterm#</td>
																	<td>#dollarformat( strExtGrad.gradExtInitialPayAmt )#</td>
																	<td>#dollarformat( strExtGrad.gradExtInitialPayAmt * strExtGrad.newloanterm )#</td>
																	<td><span class="label label-default">View Detail</span></td>
																</tr>
																</cfif>
																<!--- // pay as you earn --->
																<tr>
																	<td class="actions"><div align="center"><input type="radio" name="PAYE" id="PAYE"></div></td>																					
																	<td>Pay As You Earn</td>
																	<td><span class="label label-warning">See Note 2</span></td>
																	<td>#dollarformat( mIBR.mIBRPAYE )#</td>
																	<td>#dollarformat( mIBR.mIBRPAYE * 300 )#</td>
																	<td><span class="label label-default">View Detail</span></td>
																</tr>
																<!--- // income contingent --->
																<tr>
																	<td class="actions"><div align="center"><input type="radio" name="ICR" id="ICR"<cfif qualifythisclient is false>disabled</cfif>></div></td>																					
																	<td>Income Contingent</td>
																	<td><span class="label label-warning">See Note 2</span></td>
																	<td>#dollarformat( monthlyPaymentICR )#</td>
																	<td>#dollarformat( monthlyPaymentICR * 300 )#</td>
																	<td><cfif qualifythisclient is true><span class="label label-default">View Detail</span><cfelse><span class="label label-important">Not Qualified</span></cfif></td>
																</tr>
																<!--- // income based --->
																<tr>
																	<td class="actions"><div align="center"><input type="radio" name="IBR" id="IBR"<cfif qualifythisclient is false>disabled</cfif>></div></td>																					
																	<td>Income Based</td>
																	<td><span class="label label-warning">See Note 2</span></td>
																	<td>#dollarformat( mIBR.mIBRPayAmt )#</td>
																	<td>#dollarformat( mIBR.mIBRPayAmt * 300 )#</td>
																	<td><cfif qualifythisclient is true><span class="label label-default">View Detail</span><cfelse><span class="label label-important">Not Qualified</span></cfif></td>
																</tr>
															</tbody>
														</table>																		
															
														<div class="form-actions">													
															<button type="submit" class="btn btn-secondary" name="savelead"><i class="icon-save"></i> Save Repayment</button>																										
															<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.repayments'"><i class="icon-remove-sign"></i> Cancel</a>													
															<input name="utf8" type="hidden" value="&##955;">													
															<input type="hidden" name="leadid" value="#leaddetail.leadid#" />																	
															<input type="hidden" name="__authToken" value="#randout#" />
															<input name="validate_require" type="hidden" value="leadid|Opps, sorry... the form can not be posted due to an intrnal error.  Please re-load the page and try again.;notetext|Please enter text for the note.  The field can not be blank." />															
														</div> <!-- /form-actions -->
														
													</form>										
											</cfoutput>
											
												<br />
											
												<div class="well" style="padding:15px;">
													<span class="small">
													<p><strong>Note 1:</strong>
													This is an estimated monthly payment amount for the first two years of the term. The monthly payment amount generally will increase every two years, based on a gradation factor. 
													</p>						  
																			  
													<p><strong>Note 2:</strong>	
													This is an estimated repayment amount for the first year and total loan payment, based on the information you provided. 
													This repayment amount will be recalculated annually based on your income (and the Poverty Guidelines for your family size as determined by the U.S Dept of Health & Human Service for ICR and your family size for IBR). 
													The ICR and IBR Plans have a maximum term of 25 years.
													</p>													
																			  
													<p><strong>Note 3:</strong>
													You are not eligible for the IBR Plan because you included ineligible PLUS loans. If you want to repay under the IBR Plan, you need to exclude your parent PLUS Loan(s).
													</p>						 
																			  
													<p><strong>Note 4:</strong>
													You are not eligible for the IBR Plan because you do not have a partial financial hardship based on the income and family size information you provided.
													</p>						 
																			  
													<p><strong>Note 5:</strong>
													The IBR Plan Estimated Total Loan Balances include your spouse's total indebtedness, if applicable.
													</p>
													</small>
												</div>
										
										</cfif>
										
									</div><!-- //.span8 -->
									
									<div class="clear"></div>
								</div> <!-- //.widget-content -->	
									
							</div> <!-- //.widget -->
							
						</div> <!-- //.span12 -->
						
					</div> <!-- //.row -->				
				
					<div style="height:100px;"></div>			
				
				</div> <!-- //.container -->
			
			</div> <!-- //.main -->