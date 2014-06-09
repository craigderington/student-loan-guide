


			<!--- // 1-24-2014 // newpage to upload and parse NSLDS text file to add student loan debt worksheets --->
			
			
			<!--- get our data components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>

			<cfinvoke component="apis.com.nslds.nsldsgateway" method="getloantypes" returnvariable="loantypes">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.nslds.nsldsgateway" method="getnsldslist" returnvariable="nsldslist">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.nslds.nsldsgateway" method="getnsldszerobal" returnvariable="nsldszerobal">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			
			<!--- // update import flag to null --->
			<cfif structkeyexists( url, "fuseaction" ) and url.fuseaction is "reset">				
				<cfif structkeyexists( url, "nslid" ) and isvalid( "uuid", url.nslid ) >
					<cfparam name="nslid" default="">
					<cfset nslid = #url.nslid# />
					<cfquery datasource="#application.dsn#" name="resetconverted">
						update nslds
						   set converted = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />
						 where nsluuid = <cfqueryparam value="#nslid#" cfsqltype="cf_sql_varchar" maxlength="35" />
					</cfquery>
				</cfif>
				<cflocation url="#application.root#?event=page.nslds.results" addtoken="no">
			</cfif>
			
			
			
			
			
			
			
			<!--- // create a few variables --->
			<cfparam name="nslidarr" default="">
			<cfparam name="servicer" default="">
			<cfparam name="loancode" default="">
			<cfparam name="counter" default="">
			<cfparam name="mloantype" default="">
			<cfparam name="mloandate" default="">
			<cfparam name="mvarrate" default="">
			<cfparam name="totalprincipalbalance" default="0.00">
			<cfparam name="totalinterestbalance" default="0.00">
			<cfparam name="totalrepaymentamount" default="0.00">
			<cfparam name="totalintrate" default="0.00">
			<cfparam name="avgintrate" default="0.00">
			
			<!--- // if our form is submitted, check the structure for keys --->
			<cfif structkeyexists( form, "createworksheets" ) and structkeyexists( form, "__authToken" )>
			
				<!--- // create an array to store the id's from the nslds form fields --->				
				<cfset nslidarr = listtoarray( chkdebt )>		
				
					<!--- // loop over the nslds array getting the data for each loan --->
					<cfloop from="1" to="#arraylen( nslidarr )#" index="i" step="1" >						
						
						<!--- // get the loan information for each loan identified --->
						<cfquery datasource="#application.dsn#" name="loandata">
							select nslid, nsluuid, leadid, nslloantype, nslschool, nslloandate, nslloanbalance,
								   nslintbalance, nslloanintrate, nslloanstatus, nslcurrentpay, nslservicer, companyname, 
								   converted, nslintratetype
							  from nslds
							 where nslid = <cfqueryparam value="#nslidarr[i]#" cfsqltype="cf_sql_integer" />
						</cfquery>
						
						<cfset servicer = listlast( loandata.nslservicer, "/" ) />
					
						<!--- // try and match the servicer --->
						<cfquery datasource="#application.dsn#" name="chksrv">
							select top 1 servid
							  from servicers
							 where servname LIKE <cfqueryparam value="%#trim( loandata.companyname )#%" cfsqltype="cf_sql_varchar" />
						</cfquery>
						
						<cfif chksrv.recordcount eq 0>
							<cfset servicer = -1 />
						<cfelse>
							<cfset servicer = chksrv.servid />
						</cfif>
						
						<!--- // try and match the loan type --->
						<cfquery datasource="#application.dsn#" name="getloancode">
							select top 1 loancodeid
							  from loancodes
							 where codedescr LIKE <cfqueryparam value="%#trim( loandata.nslloantype )#%" cfsqltype="cf_sql_varchar" />
						</cfquery>
						
						<cfif getloancode.recordcount eq 0>
							<cfset loancode = 21 />
						<cfelse>
							<cfset loancode = getloancode.loancodeid />
						</cfif>
						
						<!--- // try and match the repayment status --->
						<cfquery datasource="#application.dsn#" name="getstatus">
							select top 1 statuscodeid
							  from statuscodes
							 where statuscodedescr LIKE <cfqueryparam value="#trim( loandata.nslloanstatus )#" cfsqltype="cf_sql_varchar" />
						</cfquery>
						
						<cfif getstatus.recordcount eq 0>
							<cfset loanstatus = 121 />
						<cfelse>
							<cfset loanstatus = getstatus.statuscodeid />
						</cfif>
						
						<!--- // variable rate look up --->
						<cfif trim( loandata.nslintratetype ) is "variable" and loandata.nslloanintrate eq 0.00>
							<cfset mloandate = loandata.nslloandate />
								<cfif trim( loandata.nslloantype ) contains "PLUS">
									<cfset mloantype = "PLUS" />
								<cfelse>
									<cfset mloantype = "Stafford" />
								</cfif>
							
								<cfquery datasource="#application.dsn#" name="chkvarrate">
									select variablerepay
									  from variablerates
									 where variabletype = <cfqueryparam value="#mloantype#" cfsqltype="cf_sql_varchar" />
									   and variablestartdate <= <cfqueryparam value="#mloandate#" cfsqltype="cf_sql_date" />
									   and variableenddate >= <cfqueryparam value="#mloandate#" cfsqltype="cf_sql_date" />
								</cfquery>
								
								<!--- // set the value of the variable rate from the lookup; or set the defaulr rate if the lookup fails --->
								<cfif chkvarrate.recordcount gt 0>
									<cfset mvarrate = numberformat( chkvarrate.variablerepay, '9.99' ) />
								<cfelse>
									<cfset mvarrate = 0.00 />
								</cfif>
							
						</cfif>
						
						
						<!--- // create our debt worksheets --->
						<cfquery datasource="#application.dsn#" name="createdebtworksheets">
							insert into slworksheet(worksheetuuid, leadid, dateadded, loancodeid, statuscodeid, repaycodeid, servicerid, servname, acctnum, loanbalance, currentpayment, intrate, closeddate, attendingschool)
								values(
										<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar" maxlength="35" />,
										<cfqueryparam value="#session.leadid#" cfsqltype="cf_sql_integer" />,
										<cfqueryparam value="#CreateODBCDate( Now() )#" cfsqltype="cf_sql_date" />,
										<cfqueryparam value="#loancode#" cfsqltype="cf_sql_integer" />,
										<cfqueryparam value="#loanstatus#" cfsqltype="cf_sql_integer" />,
										<cfqueryparam value="22" cfsqltype="cf_sql_integer" />,
										<cfqueryparam value="#servicer#" cfsqltype="cf_sql_integer" />,
										<cfqueryparam value="#loandata.companyname#" cfsqltype="cf_sql_varchar" />,
										<cfqueryparam value="#leaddetail.leadlast#" cfsqltype="cf_sql_varchar" />,
										<cfqueryparam value="#loandata.nslloanbalance + loandata.nslintbalance#" cfsqltype="cf_sql_float" />,
										<cfqueryparam value="#loandata.nslcurrentpay#" cfsqltype="cf_sql_float" />,
										<cfif trim( loandata.nslintratetype ) is "VARIABLE" and loandata.nslloanintrate eq 0.00>
											<cfqueryparam value="#mvarrate#" cfsqltype="cf_sql_decimal" scale="2" />,											
										<cfelse>
											<cfqueryparam value="#loandata.nslloanintrate#" cfsqltype="cf_sql_decimal" scale="2" />,
										</cfif>
										<cfqueryparam value="#loandata.nslloandate#" cfsqltype="cf_sql_date" />,
										<cfqueryparam value="#loandata.nslschool#" cfsqltype="cf_sql_varchar" />
									   );
						</cfquery>					
						
						<!--- // task automation --->
						<cfinvoke component="apis.com.tasks.taskautomation" method="marktaskcompleted" returnvariable="taskmsg">
							<cfinvokeargument name="leadid" value="#session.leadid#">
							<cfinvokeargument name="taskref" value="debtwksht">
						</cfinvoke>
						
						<!--- // mark portal task complete --->
						<cfif isuserinrole( "bclient" )>
							<cfinvoke component="apis.com.portal.portaltaskgateway" method="markportaltaskcompleted" returnvariable="taskstatusmsg">
								<cfinvokeargument name="portaltaskid" value="1410">
								<cfinvokeargument name="leadid" value="#session.leadid#">
							</cfinvoke>
						</cfif>
						
						<!--- // after debt worksheets are created, update the nslds record as converted --->
						<cfquery datasource="#application.dsn#" name="updatenslds">
							update nslds
							   set converted = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
							 where nslid = <cfqueryparam value="#nslidarr[i]#" cfsqltype="cf_sql_integer" />
						</cfquery>				
							
						
					</cfloop>
					
					<cfscript>
						thread = createobject( "java", "java.lang.Thread" );
						thread.sleep(5000);
					</cfscript>
					
					
					<cflocation url="#application.root#?event=page.worksheet" addtoken="no" >
			
			
				<!--- // dump our array variable
				<cfdump var="#nslidarr#" label="NSL ID Array">
				--->
			
			
			</cfif>
			
			
			<!--- // add some client side js to toggle check all --->
			<script type="text/javascript">				
				function do_this(){

					var checkboxes = document.getElementsByName('chkdebt');
					var button = document.getElementById('toggle');

					if(button.value == 'Check All'){
						for (var i in checkboxes){
							checkboxes[i].checked = 'FALSE';
						}
						button.value = 'Uncheck All'
					}else{
						for (var i in checkboxes){
							checkboxes[i].checked = '';
						}
						button.value = 'Check All';
					}
				}
			</script>
			
			
			
			
			
			
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
						
							<div class="widget stacked">
								<cfoutput>	
								<div class="widget-header">		
									<i class="icon-upload"></i>							
									<h3>NSLDS Student Loan Text File Import Results for #leaddetail.leadfirst# #leaddetail.leadlast#</h3>						
								</div> <!-- //.widget-header -->
								</cfoutput>	
							
								<div class="widget-content">							
									
									<h4><i class="icon-upload-alt"></i> NSLDS Import Results</h4> 
									
									
									<cfif nsldslist.recordcount gt 0>
									
									
									<p>The following records were created during the National Student Loan Data System (NSLDS) text file import.  Please review the import results below and select which student loans you want to convert into debt worksheets.</p>
									
									<cfoutput>
									<div class="well">
										<p><i class="icon-check"></i> Filter Your NSLDS Results</p>
										<form class="form-inline" name="filterresults" method="post">
											<select name="loantypes" style="margin-left:5px;" class="input-xlarge" onchange="javascript:this.form.submit();">
												<option value="">Filter Loan Types</option>
												<cfloop query="loantypes">
													<option value="#datacontent#"<cfif isdefined( "form.loantypes" ) and form.loantypes eq loantypes.datacontent>selected</cfif>>#datacontent#</option>
												</cfloop>												
											</select>
											<input type="text" name="loandates" style="margin-left:5px;" class="input-medium" placeholder="Select Date Filter" id="datepicker-inline4" value="<cfif isdefined( "form.loandates" )>#dateformat( form.loandates, 'mm/dd/yyyy' )#</cfif>">											
											<input type="hidden" name="filtermyresults">
											<button type="submit" style="margin-left:5px;" name="filterresults" class="btn btn-small btn-secondary"><i class="icon-search"></i> Filter NSLDS</button>
											<cfif structkeyexists( form, "filtermyresults" )><button type="reset" onclick="location.href='#application.root#?event=page.nslds.results'" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-check"></i> Reset List</button></cfif>
										</form>
									</div>
									</cfoutput>
									
										<cfset counter = 1 />
										<cfoutput>
											<h5><i class="icon-folder-open"></i> Showing #nsldslist.recordcount# NSLDS Loan<cfif nsldslist.recordcount gt 1>s</cfif>  <span class="pull-right"><cfif nsldszerobal.recordcount GT 0><i class="icon-warning-sign" style="color:red;margin-left:10px;"></i> Not showing #nsldszerobal.recordcount# loan<cfif nsldszerobal.recordcount gt 1>s</cfif> with zero balance<cfif nsldszerobal.recordcount gt 1>s</cfif>.  <cfif not structkeyexists( url, "dozerobal" )><a style="margin-left:10px;" href="#application.root#?event=#url.event#&dozerobal=1">Show Zero Balance Loans</a><cfelse><a style="margin-left:10px;" href="#application.root#?event=#url.event#">Hide Zero Balance Loans</a></cfif></cfif></span></h5>
										</cfoutput>
										
										<form id="nslds" name="nslds" method="post">
											<fieldset>
												<table class="table table-bordered table-striped table-highlight">
													<thead>
														<tr>
															<th width="5%" style="text-align:center;">Select Loan</th>
															<th>Loan Number</th>
															<th>Loan Type</th>
															<th>Loan Status</th>
															<th>Loan Status Date</th>
															<th>Loan Origination Date</th>
															<th>Outstanding Principal Balance</th>
															<th>Outstanding Interest Balance</th>
															<th>Interest Rate/Type</th>															
															<th>Repayment Amount</th>																							
															<th>Company Info</th>															
															<th>Attending School</th>
														</tr>
													</thead>
													<tbody>
														<cfoutput query="nsldslist">
														<tr>
															<td class="actions"><div align="center"><cfif converted eq 0><input type="checkbox" name="chkdebt" value="#nslid#"><cfelse><cfif isuserinrole( "admin" ) or isuserinrole( "co-admin" )><a href="#application.root#?event=#url.event#&fuseaction=reset&nslid=#nsluuid#" title="Reset Converted" class="btn btn-tertiary btn-mini" onclick="return confirm('This will reset the NSLDS record so it can be imported again, do you wish to continue?');"><i class="btn-icon-only icon-unlock"></i></a><cfelse><a href="javascript;:" rel="popover" data-original-title="NSLDS Loan Converted" data-content="This student loan can not be selected because it has already been converted to a debt worksheet."><i class="icon-info-sign" style="color:##ff0000;"></i></a></cfif></cfif></div></td>														
															<td>#counter#</td>
															<td>#nslloantype#</td>
															<td>#nslloanstatus#</td>
															<td><cfif nslloanstatusdate is not "1/1/1900" and nslloanstatusdate is not "">#dateformat ( nslloanstatusdate, "mm/dd/yyyy" )#<cfelse>Undefined</cfif></td>
															<td>#dateformat( nslloandate, "mm/dd/yyyy" )#
															<td>#dollarformat( nslloanbalance )#</td>
															<td>#dollarformat( nslintbalance )#</td>
															<td><cfif nslintratetype is not "" and trim( nslintratetype ) is not "Loan Interest Rate Type">#nslintratetype#<cfelse>FIXED</cfif> / #numberformat( nslloanintrate, "9.99" )#%</td>												
															<td>#dollarformat( nslcurrentpay )#</td>																													
															<td>#nslservicertype# <br />#companyname# <a href="javascript:;" style="margin-left;3px;" rel="popover" data-content="#companyname#<br/>Address: #companyadd1#&nbsp;&nbsp;<cfif trim( companyadd2 ) is not "Loan Contact Street Address 2" and companyadd2 is not "">#companyadd2#</cfif><br/>City,State: #companycity#, #companystate#   <cfif len( companyzip ) gt 5>#left( companyzip, 5 )#-#right( companyzip, 4 )#<cfelse>#companyzip#</cfif><br/>Phone: #companyphone# <cfif companyphoneext is not "" and companyphoneext is not "Loan Contact Phone Extension">ext: #companyphoneext#</cfif><br />Email: #companyemail#<br />Website: #companyweb#" data-original-title="<strong>#companyname#</strong>"><i class="icon-exclamation-sign"></i></a></td>													
															<td>#nslschool#</td>
														</tr>
															<cfset counter = counter + 1 />
															<!---// generate the totals for the table --->
															<cfset totalprincipalbalance = totalprincipalbalance + nslloanbalance />
															<cfset totalinterestbalance = totalinterestbalance + nslintbalance />
															<cfset totalrepaymentamount = totalrepaymentamount + nslcurrentpay />
															<cfset totalintrate = totalintrate + nslloanintrate />
															<cfset avgintrate = totalintrate / nsldslist.recordcount />
															
														</cfoutput>
														
														<!--- // do sub totals and average interest rate --->
														<cfoutput>
															<tr style="font-weight:bold;" class="alert alert-notice">
																<td colspan="6" style="color:black;text-align:right;">TOTALS:</td>
																<td style="color:black;">#dollarformat( totalprincipalbalance )#</td>
																<td style="color:black;">#dollarformat( totalinterestbalance )#</td>
																<td><span class="label">#numberformat( avgintrate, "9.99" )#%</span></td>
																<td><span class="label">#dollarformat( totalrepaymentamount )#</span></td>
																<td>&nbsp;</td>
																<td>&nbsp;</td>																
															</tr>
														</cfoutput>														
													</tbody>
												</table>
												<div style="margin-left:5px;margin-top:3px;">
													<input type="button" id="toggle" onclick="do_this();" value="Check All" class="btn btn-mini btn-default"> 
												</div>
											</fieldset>
											
											<br />
											
											<cfoutput>
												<div class="form-actions">													
													<button type="submit" class="btn btn-secondary" name="createworksheets"><i class="icon-refresh"></i> Create Debt Worksheets</button>																										
													<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.worksheet'"><i class="icon-remove-sign"></i> Cancel</a>													
													<input name="utf8" type="hidden" value="&##955;">													
													<input type="hidden" name="leadid" value="#leaddetail.leadid#" />																	
													<input type="hidden" name="__authToken" value="#randout#" />												
												</div> <!-- /form-actions -->
											</cfoutput>
										
										</form>
										
									<cfelse>					
									
										<div class="alert alert-error">
											<a class="close" data-dismiss="alert">&times;</a>
												<h5><error>Sorry, the NSLDS text file import feature did not find any loans to create...</error></h5>
												<p>The system was able to read the text file, however, no student loan data met the criteria to be imported from the text file.  Please click here to return to the <a href="index.cfm?event=page.worksheet">Debt Worksheet</a>.</p>						
										</div>
									
									</cfif>
						
								</div><!-- /.widget-content -->
							
							</div><!-- /.widget -->
							
							<cfif nsldslist.recordcount lt 5>
							<div style="margin-top:375px;"></div>
							<cfelse>
							<div style="margin-top:150px;"></div>
							</cfif>
						</div><!-- /.span12 -->
						
					</div><!-- /.row -->	
					
				
				</div><!-- /.container -->
			
			</div><!-- /.main -->