

			<!--- get our data components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>		
			
			<cfinvoke component="apis.com.clients.budgetgateway" method="getbudget" returnvariable="budget">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>

			<cfinvoke component="apis.com.worksheets.worksheetgateway" method="getdebttotal" returnvariable="totaldebt">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			
			<!--- // default our variables to zero values for empty strings --->
			<cfparam name="totalstudentloandebt" default="0.00">
			<cfparam name="debttoincome" default="0.00">
			<cfparam name="expensetoincome" default="0.00">			
			<cfparam name="primarytotalincome" default="0.00">
			<cfparam name="secondarytotalincome" default="0.00">
			<cfparam name="combinedtotalincome" default="0.00">
			<cfparam name="totaldeductions" default="0.00">
			<cfparam name="netincome" default="0.00">
			<cfparam name="totalexpenses" default="0.00">
			<cfparam name="totalassets" default="0.00">
			<cfparam name="totalliabilities" default="0.00">
			<cfparam name="networth" default="0.00">
			
			<!--- // define income vars and set default values --->
			<cfif budget.primarytotalincome is "">
				<cfset primarytotalincome = 0.00 />
			<cfelse>
				<cfset primarytotalincome = budget.primarytotalincome />
			</cfif>
			
			<cfif budget.secondarytotalincome is "">
				<cfset secondarytotalincome = 0.00 />
			<cfelse>
				<cfset secondarytotalincome = budget.secondarytotalincome />
			</cfif>
			
			<cfif budget.combinedtotalincome is "">
				<cfset combinedtotalincome = 0.00 />
			<cfelse>
				<cfset combinedtotalincome = budget.primarytotalincome + budget.secondarytotalincome />
			</cfif>		
			
			<cfif totaldebt.sltotal is "">
				<cfset totalstudentloandebt = 0.00 />
			<cfelse>
				<cfset totalstudentloandebt = totaldebt.sltotal />
			</cfif>
			
			<cfset totalexpenses = budget.sheltertotal + budget.autototal + budget.utilitytotal + budget.transtotal + budget.foodtotal + budget.medtotal + budget.insurancetotal + budget.domesticorder + budget.childcaretotal + budget.misctotal />
			<cfset totaldeductions = budget.primarywithholding + budget.primaryfica + budget.primarymedicare + budget.primary401k + budget.primarybenefits + budget.primarycitytax + budget.primarystatetax + budget.secondarywithholding + budget.secondaryfica + budget.secondarymedicare + budget.secondary401k + budget.secondarybenefits + budget.secondarycitytax + budget.secondarystatetax />
			
			
			<cfif totalexpenses neq 0.00 and combinedtotalincome neq 0.00>
				<cfset expensetoincome = ( totalexpenses / combinedtotalincome ) * 100.00 />
			<cfelse>
				<cfset expensetoincome = 0 />
			</cfif>
			
			<cfif totalstudentloandebt neq 0.00>
				<cfset debttoincome = ( combinedtotalincome / totalstudentloandebt ) * 100.00 />
			<cfelse>
				<cfset debttoincome = 0.00 />
			</cfif>
			
			
			
			
			
			
			<!--- // begin financial and budget summary --->
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
											<strong>SAVE SUCCESS!</strong>  The monthly budget employer details were successfully updated in the client profile.  Please use the form to continue...
										</div>										
									</div>								
								</div>
							<cfelseif structkeyexists(url, "msg") and url.msg is "deleted">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-success">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong>DELETE SUCCESS!</strong>  The budget item was successfully deleted from the client's profile.  Please use the navigation in the sidebar to continue...
										</div>										
									</div>								
								</div>
							<cfelseif structkeyexists(url, "msg") and url.msg is "error">						
								<div class="row">
									<div class="span12">										
										<div class="alert alert-error">
											<button type="button" class="close" data-dismiss="alert">&times;</button>
											<strong>ERROR!</strong>  Sorry, there was a problem with the selected record and the operation was aborted.  Please use the navigation in the sidebar to continue...
										</div>										
									</div>								
								</div>
							</cfif>						
						
							<!--- // begin widget --->
							<div class="widget stacked">
								<cfoutput>	
								<div class="widget-header">		
									<i class="icon-list-alt"></i>							
									<h3>Monthly Budget Details for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
								</div> <!-- //.widget-header -->
								</cfoutput>	
							
								<div class="widget-content">							
								
										<!--- // include the side bar nav --->
										<div class="span3">					
											<cfinclude template="page.sidebar.nav.cfm">		
										</div> <!-- /.span3 -->
			
			
										<div class="span8">
										
											<div class="tabbable">										
											
												<div class="tab-content">
													
													<div class="tab-pane active" id="tab1">
														
														<h3><i class="icon-list-alt"></i> Financial Budget and Employment Summary</h3>										
														
															<cfoutput>
															<ul class="nav nav-tabs">
																<li class="active"><a href="#application.root#?event=#url.event#">Summary</a></li>
																<li><a href="#application.root#?event=#url.event#.employment">Employment</a></li>															
																<li><a href="#application.root#?event=page.budget.income">Primary Income</a></li>
																<li><a href="#application.root#?event=page.budget.income2">Spouse/Co-Borrower Income</a></li>
																<li><a href="#application.root#?event=page.budget.expenses">Expenses</a></li>																
															</ul>
															
															<p>The budget summary will display a snapshot of the overall financial picture.  To add income, deductions and expenses, <strong><i>please click on the tabs above and navigate through each section</i></strong> enterting the financial budget details. </p>
															
															<!--- show income and deductions --->
															<div class="widget big-stats-container stacked">
						
																<div class="widget-content">
																	
																	<div id="big_stats" class="cf">
																		<div class="stat">								
																			<h4>Total Monthly Gross Income</h4>
																			<span class="value">#dollarformat( combinedtotalincome )#</span>								
																		</div> <!-- .stat -->
																		
																		<div class="stat">								
																			<h4>Total Monthly Net Income</h4>
																			<span class="value">#dollarformat( combinedtotalincome - totaldeductions )#</span>																		
																		</div> <!-- .stat -->

																		<div class="stat">								
																			<h4>Total Monthly Disposable Income</h4>
																			<span class="value">#dollarformat( combinedtotalincome - totaldeductions - totalexpenses )#</span>								
																		</div> <!-- .stat -->
																		
																	</div>	

																	<br />
																	
																	<div id="big_stats" class="cf">
																		<div class="stat">								
																			<h4>Total Monthly Expenses</h4>
																			<span class="value">#dollarformat( totalexpenses )#</span>								
																		</div> <!-- .stat -->
																		
																		<div class="stat">								
																			<h4>Expenses As A Percentage of Income</h4>
																			<span class="value">#numberformat( expensetoincome, "999.99" )#%</span>																		
																		</div> <!-- .stat -->

																		<div class="stat">								
																			<h4>Debt to Income Ratio</h4>
																			<span class="value">#numberformat( debttoincome, "999.99" )#%</span>								
																		</div> <!-- .stat -->
																		
																	</div>	
																	
																
																</div> <!-- /widget-content -->
																
															</div> <!-- /widget -->													
															
															</cfoutput>				
														
																		
													</div> <!-- / .tab1 -->										 
												
												</div> <!-- / .tab-content -->
										
											</div><!-- // .tabbable -->
											
										</div> <!-- / .span8 -->
									
					
								</div> <!-- / .widget-content -->
							
							</div> <!-- / .widget-stacked -->							
							
						</div><!-- / .span12 -->
					
					</div> <!-- / .row -->
				
				</div> <!-- / .container -->
			
			</div> <!-- / .main -->
		
		
		