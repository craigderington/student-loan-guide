
						
							<!--- // restrict access to the financial section --->
							<cfif not isuserinrole( "admin" ) and not isuserinrole( "co-admin" )>
								<cflocation url="#application.root#?event-page.index&error=1" addtoken="yes">
							</cfif>

							
							
							
							<!--- set default start and end date values --->
							<cfparam name="thisdate" default="">
							<cfparam name="startdate" default="">
							<cfparam name="enddate" default="">
							<cfparam name="achtotals" default="0.00">
							<cfparam name="achpaidtotals" default="0.00">
							<cfset thisdate = now() />
							
							<!--- set default start and end date values for our query --->
							<cfif structkeyexists( form, "filtermyresults" )>								
								<cfset startdate = createodbcdate( createdate( year( form.startdate ), month( form.startdate ), day( form.startdate ) ) ) />
								<cfset enddate = createodbcdate( createdate( year( form.enddate ), month( form.enddate ), day( form.enddate ))) />
							<cfelse>							
								<cfset startdate = createodbcdate( createdate( year( thisdate ), month( thisdate ), 1 ) ) />
								<cfset enddate = createodbcdate( createdate( year( startdate ), month( startdate ), daysinmonth( startdate ))) />							
							</cfif>						
							
							<!--- // get our data access components --->
							<cfinvoke component="apis.com.admin.companybankinggateway" method="getachdata" returnvariable="achdata">
								<cfinvokeargument name="companyid" value="#session.companyid#">
								<cfinvokeargument name="startdate" value="#startdate#">
								<cfinvokeargument name="enddate" value="#enddate#">
							</cfinvoke>

							<cfinvoke component="apis.com.system.companysettings" method="getcompanysettings" returnvariable="companysettings">
								<cfinvokeargument name="companyid" value="#session.companyid#">
							</cfinvoke>
							
							<!--- // 7-2-2014 // add counselor list for filter --->
							<cfinvoke component="apis.com.reports.reportgateway" method="getcounselorlist" returnvariable="counselorlist">
								<cfinvokeargument name="companyid" value="#session.companyid#">			
							</cfinvoke>
							
							
							<cfif structkeyexists( form, "creatensf" ) and structkeyexists( form, "feeid" )>
								<cfparam name="feeid" default="">								
								<cfif isvalid( "uuid", form.feeid )>								
									<cfset feeid = form.feeid />									
									<cfquery datasource="#application.dsn#" name="getfeedetail">
										select f.feeid, f.feeuuid, f.leadid, f.feetype, f.createddate, f.feeduedate, f.feepaiddate, 
										       f.feeamount, f.feepaid, f.feestatus, f.userid, f.feenote, f.feecollected, f.feeprogram,
											   f.feepaytype, f.feereturnednsf, f.feetrans, f.feetransdate, l.leademail, l.leadfirst, l.leadlast
										  from fees f, leads l
										 where f.leadid = l.leadid
										   and feeuuid = <cfqueryparam value="#feeid#" cfsqltype="cf_sql_varchar" maxlength="35" />
									</cfquery>
									<cfset appendfeenote = getfeedetail.feenote />
									<cfset appendfeenote = appendfeenote & " - returned NSF" />
									
									<cfquery datasource="#application.dsn#" name="marknsf">
										update fees
										   set feepaiddate = <cfqueryparam value="#thisdate#" cfsqltype="cf_sql_date" />,
										       feepaid = <cfqueryparam value="#getfeedetail.feeamount#" cfsqltype="cf_sql_float" />,
											   feestatus = <cfqueryparam value="NSF" cfsqltype="cf_sql_varchar" />,
											   feenote = <cfqueryparam value="#appendfeenote#" cfsqltype="cf_sql_varchar" />,
											   feecollected = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />,
											   feereturnednsf = <cfqueryparam value="#thisdate#" cfsqltype="cf_sql_timestamp" />
										 where feeid = <cfqueryparam value="#getfeedetail.feeid#" cfsqltype="cf_sql_integer" />
									</cfquery>
									
									<cfquery datasource="#application.dsn#" name="creatensffee">
										insert into fees(feeuuid, leadid, feetype, createddate, feeduedate, feeamount, feepaiddate, feepaid, feenote, feestatus, feeprogram, feepaytype, feecollected, userid, feereturnednsf, nsfreasonid)
											values (
													<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar" />,
													<cfqueryparam value="#getfeedetail.leadid#" cfsqltype="cf_sql_integer" />,
													<cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
													<cfqueryparam value="#thisdate#" cfsqltype="cf_sql_timestamp" />,
													<cfqueryparam value="#thisdate#" cfsqltype="cf_sql_timestamp" />,
													<cfqueryparam value="-#getfeedetail.feeamount#" cfsqltype="cf_sql_float" />,
													<cfqueryparam value="#thisdate#" cfsqltype="cf_sql_timestamp" />,
													<cfqueryparam value="-#getfeedetail.feeamount#" cfsqltype="cf_sql_float" />,
													<cfqueryparam value="NSF generated receipt" cfsqltype="cf_sql_varchar" />,
													<cfqueryparam value="NSF" cfsqltype="cf_sql_varchar" />,
													<cfqueryparam value="n" cfsqltype="cf_sql_char" />,
													<cfqueryparam value="#getfeedetail.feepaytype#" cfsqltype="cf_sql_char" />,
													<cfqueryparam value="1" cfsqltype="cf_sql_bit" />,
													<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
													<cfqueryparam value="Y" cfsqltype="cf_sql_char" />,
													<cfqueryparam value="#form.nsfreason#" cfsqltype="cf_sql_integer" />
													);
									</cfquery>
									
										<!--- // if the user has selected the check box to send an email notification to the client, send it now --->
										<cfif structkeyexists( form, "chksendnotify" )>
											<cfinvoke component="apis.com.system.settingsgateway" method="getnsfreason" returnvariable="nsfreasondetail">
												<cfinvokeargument name="nsfreasonid" value="#form.nsfreason#">
											</cfinvoke>
											<cfinvoke component="apis.com.system.companysettings" method="getcompanysettings" returnvariable="companysettings">
												<cfinvokeargument name="companyid" value="#session.companyid#">
											</cfinvoke>
											
											<cfmail from="#companysettings.dba#<#companysettings.email#>" to="#getfeedetail.leademail#" cc="craig@efiscal.net,#getauthuser()#" subject="Notification - Payment Returned NSF">*** AUTOMATED SYSTEM NOTIFICATION *** UNATTENDED MAILBOX ***  PLEASE DO NOT REPLY

Please note that your payment for #dollarformat( getfeedetail.feeamount )# on #dateformat( getfeedetail.feeduedate, "mm/dd/yyyy" )# was returned by your bank for the following reason:

#nsfreasondetail.nsfreasondescr#








This email was automatically generated from the Student Loan Advisor Online system and sent on behalf of #companysettings.companyname# on #dateformat( now(), "mm/dd/yyyy" )# at #timeformat( now(), "hh:mm tt" )#.


											
												<cfmailparam name="Reply-To" value="#getauthuser()#">
											</cfmail>
										</cfif>
									
									<cflocation url="#application.root#?event=#url.event#" addtoken="no" />
								
								</cfif>					
							
							</cfif>
		
		
		
		
		
							<!--- // 7-9-2014 // Melissa requests function to mark money orders paid --->
							<cfif structkeyexists( url, "fuseaction" )>								
								<cfif trim( url.fuseaction ) is "setMOpaid">
									<cfparam name="feeid" default="">
									<cfif structkeyexists( url, "feeid" )>
										<cfparam name="feeid" default="">
										<cfparam name="paytypelist" default="">
										<cfset feeid = url.feeid />										
										<!--- // check for a valid fee id --->
										<cfif isvalid( "uuid", feeid )>
										
											<!--- // get fee detail --->
											<cfquery datasource="#application.dsn#" name="getfeedetail">
												select f.feeid, f.feeuuid, f.feestatus, f.feeamount, 
												       f.feecollected, f.feepaytype
												  from fees f
												 where f.feeuuid = <cfqueryparam value="#feeid#" cfsqltype="cf_sql_varchar" maxlength="35" />											       
											</cfquery>											
												<!--- set the new params --->
												<cfset mo = structnew() />
												<cfset mo.feeid = getfeedetail.feeid />
												<cfset mo.feepaytype = trim( getfeedetail.feepaytype ) />
												<cfset mo.feestatus = getfeedetail.feestatus />
												<cfset mo.feeamount = numberformat( getfeedetail.feeamount, "999.99" ) />
												<cfset mo.feepaiddate = now() />
												<cfset paytypelist = "MO,CHK,CSH" />
													<!--- // check to make sure we have a money order record --->
													<cfif listfind( paytypelist, mo.feepaytype, "," )>
														<!--- // set mark the fee paid and redirect --->
														<cfquery datasource="#application.dsn#" name="setfeepaid">
															update fees
															   set feepaid = <cfqueryparam value="#mo.feeamount#" cfsqltype="cf_sql_float" />,
																   feepaiddate = <cfqueryparam value="#mo.feepaiddate#" cfsqltype="cf_sql_timestamp" />,
																   feestatus = <cfqueryparam value="PAID" cfsqltype="cf_sql_varchar" />,
																   feecollected = <cfqueryparam value="1" cfsqltype="1" />
															 where feeid = <cfqueryparam value="#mo.feeid#" cfsqltype="cf_sql_integer" />
														</cfquery>												
														<cflocation url="#application.root#?event=#url.event#&msg=saved" addtoken="no">
													<cfelse>
														<!-- // alert user to operation error --->
														<script>
															alert('The fee record was found but is not the correct payment type.  Operation aborted!');
															self.location="javascript:history.back(-1);"
														</script>													
													</cfif>												
										<cfelse>									
											<!--- // alert user to no record and redirect --->
											<script>
												alert('The fee record can not be found!');
												self.location="javascript:history.back(-1);"
											</script>									
										</cfif>
									</cfif>
								</cfif>								
							</cfif>
							<!--- // end set money order function --->
		
		
							
							
							
							
							
							
							
		
		
		
		
		
		
		
		
							<!--- // begin admin baking page --->			
							<div class="main">

								<div class="container">				

									<div class="row">
									
										<div class="span12">
										
										
											<!--- // system messages --->
							
											<cfif structkeyexists( url, "msg" ) and url.msg is "saved">						
												<cfoutput>
													<div class="row">
														<div class="span12">										
															<div class="alert alert-info">
																<button type="button" class="close" data-dismiss="alert">&times;</button>
																<strong><i class="icon-check"></i>SUCCESS!</strong>  The client's money order was successfully marked paid as of #dateformat( now(), "mm/dd/yyyy" )# @ #timeformat( now(), "hh:mm:ss tt")#.  Please select another record to continue.
															</div>										
														</div>								
													</div>
												</cfoutput>
											</cfif>
											
											<div class="widget stacked">
												
												<cfoutput>	
												<div class="widget-header">
													<i class="icon-money"></i>
													<h3>Company Banking Center for #session.companyname#</h3>
												</div> <!-- /widget-header -->
												</cfoutput>
												
												<div class="widget-content">						
													
												
												<cfif not structkeyexists( url, "creatensf" ) and not structkeyexists( url, "fuseaction" )>
														
													<!--- // report filter --->						
													<cfoutput>
														<div class="well">
															<p><i class="icon-check"></i> Filter Your Results</p>
															<form class="form-inline" name="filterresults" method="post">					
																
																<select name="feetype" class="input-medium" onchange="javascript:this.form.submit();">
																	<option value="--">Filter by Fee Type</option>
																	<option value="A"<cfif isdefined( "form.feetype" ) and trim( form.feetype ) is "a">selected</cfif>>Advisory Only</option>
																	<option value="I"<cfif isdefined( "form.feetype" ) and trim( form.feetype ) is "i">selected</cfif>>Implementation Only</option>
																<select>

																<select name="paytype" class="input-medium" onchange="javascript:this.form.submit();">
																	<option value="--">Filter by Payment Type</option>
																	<option value="ACH"<cfif isdefined( "form.paytype" ) and trim( form.paytype ) is "ach">selected</cfif>>ACH</option>
																	<option value="CC"<cfif isdefined( "form.paytype" ) and trim( form.paytype ) is "cc">selected</cfif>>Credit Card</option>
																	<option value="MO"<cfif isdefined( "form.paytype" ) and trim( form.paytype ) is "mo">selected</cfif>>Money Order</option>
																	<option value="CHK"<cfif isdefined( "form.paytype" ) and trim( form.paytype ) is "chk">selected</cfif>>Check</option>
																	<option value="CSH"<cfif isdefined( "form.paytype" ) and trim( form.paytype ) is "csh">selected</cfif>>Cash</option>
																<select>
																
																<select name="counselors" style="margin-left:5px;" class="input-medium" onchange="javascript:this.form.submit();">
																	<option value="--">Select Counselor</option>
																	<cfloop query="counselorlist">
																		<option value="#userid#"<cfif isdefined( "form.counselors" ) and form.counselors eq counselorlist.userid>selected</cfif>>#firstname# #lastname#</option>
																	</cfloop>												
																</select>
																
																<input type="text" name="startdate" style="margin-left:5px;" class="input-small" placeholder="Start Date" id="datepicker-inline4" value="<cfif isdefined( "form.startdate" )>#dateformat( form.startdate, 'mm/dd/yyyy' )#<cfelse>#dateformat( startdate, 'mm/dd/yyyy' )#</cfif>">
																<input type="text" name="enddate" style="margin-left:5px;" class="input-small" placeholder="End Date" id="datepicker-inline5" value="<cfif isdefined( "form.enddate" )>#dateformat( form.enddate, 'mm/dd/yyyy' )#<cfelse>#dateformat( enddate, 'mm/dd/yyyy' )#</cfif>">
																<input type="hidden" name="filtermyresults">
																<button type="submit" style="margin-left:5px;" name="filterresults" class="btn btn-small btn-secondary"><i class="icon-search"></i> Filter Results</button>
																<cfif structkeyexists( form, "filtermyresults" )><button type="reset" onclick="location.href='#application.root#?event=#url.event#'" style="margin-left:5px;" class="btn btn-small btn-primary"><i class="icon-check"></i> Reset List</button></cfif>
																<br /><br />								
															</form>
														</div>
													</cfoutput>
													<!--- // end filter --->
													
													
													
													
													
													
													
													
													<cfif achdata.recordcount gt 0>				
													
													<cfoutput>
														<h5><i class="icon-th-large"></i> The banking center found #achdata.recordcount# fee<cfif achdata.recordcount gt 1>s</cfif> due between #dateformat( startdate, "mm/dd/yyyy" )# to #dateformat( enddate, "mm/dd/yyyy" )#  <span class="pull-right"><a href="#application.root#?event=page.admin" style="margin-bottom:5px;" class="btn btn-small btn-tertiary"><i class="icon-home"></i> Admin Home</a><a style="margin-left:5px;margin-bottom:5px;" href="#application.root#?event=#url.event#.summary" class="btn btn-small btn-default"><i class="icon-list-alt"></i> Financial Summary</a></span></h5>
													</cfoutput>
													
														<table id="tablesorter" class="table table-bordered table-striped table-highlight tablesorter" >
															<thead>
																<tr>
																	<th width="5%">Actions</th>
																	<th>Client Name</th>
																	<th>Fee Type</th>
																	<th>Pay Type</th>
																	<th>Due Date</th>
																	<th>Fee Amount</th>																	
																	<th>Paid Date</th>
																	<th>Paid Amount</th>
																	<th>Status</th>
																	<th>Collected</th>																																																					
																</tr>
															</thead>
															<tbody>
																<cfparam name="thispaytypelist" default="">
																<cfparam name="thisfeepaytype" default="">
																<cfset thispaytypelist = "MO,CHK,CSH" />
																<cfoutput query="achdata">																		
																		<cfset thisfeepaytype = trim( achdata.feepaytype ) />
																		<tr>																			
																			<td class="actions">
																				<a href="#application.root#?event=page.getlead&fuseaction=leadgen&leadid=#leaduuid#" class="btn btn-mini btn-warning" target="_blank">
																					<i class="btn-icon-only icon-ok"></i>										
																				</a>						
																			</td>																			
																			<td>#leadfirst# #leadlast#   <cfif leadactive neq 1><small><span style="color:red;margin-left:5px;">(Inactive)</span></small></cfif></td>
																			<td><cfif trim( feeprogram ) is "a">Advisory<cfelseif trim( feeprogram ) is "i">Implementation<cfelseif trim( feeprogram ) is "n"><span class="label label-important">NSF</span></cfif></td>																				
																			<td>#feepaytype#</td>
																			<td>#dateformat( feeduedate, "mm/dd/yyyy" )#</td>
																			<td>#dollarformat( feeamount )#  <cfif ( trim( feepaytype ) is "ach" ) and ( esignrouting is "" or esignaccount is "" )><a href="javascript;:" rel="popover" style="color:red;margin-left:5px;" data-original-title="Warning: Missing Banking Information" data-content="This client has fees due and no ACH or banking details saved.  No payments will be released for processing with missing or incomplete banking information."><i class="icon-warning-sign"></i></a></cfif> <cfif ( trim( feepaytype ) is "cc" ) and ( esignccnumber is "" or esignccexpdate is "" )><a href="javascript;:" rel="popover" style="color:red;margin-left:5px;" data-original-title="Warning: Missing Credit Card Information" data-content="This credit card client has fees due and no credit card information saved in the system.  No payments will be released for processing with missing or incomplete credit card information."><i class="icon-warning-sign"></i></a></cfif><cfif trim( leadachhold ) is "Y"><a href="javascript;:" rel="popover" style="color:blue;margin-left:5px;" data-original-title="ACH Hold" data-content="This client is currently on ACH Hold.  <br/><br/> Hold Date: #dateformat( leadachholddate, 'mm/dd/yyyy' )#<br />Hold Reason: #leadachholdreason#"><i class="icon-warning-sign"></i></a></cfif></td>
																			<td><cfif feepaiddate is not ""><span class="label label-default">#dateformat( feepaiddate, "mm/dd/yyyy" )#</span><cfelseif feestatus is "pending" and feetransdate is not ""><span class="label label-info">Sent on #dateformat( feetransdate, "mm/dd/yyyy" )#</span><cfelse><span class="label label-warning">Not Paid</span></cfif></td>															
																			<td>#dollarformat( feepaid )#  <cfif feetype neq 0 and trim( feereturnednsf ) eq "N" and feetransdate is not ""><span class="pull-right"><a href="#application.root#?event=#url.event#&creatensf=true&feeid=#feeuuid#" title="Create NSF"><i class="icon-cog"></i></a></span></cfif><cfif listfind( thispaytypelist, thisfeepaytype, "," ) and ( feepaiddate is "" )><span class="pull-right"><a href="#application.root#?event=#url.event#&fuseaction=setMOpaid&feeid=#feeuuid#" title="Mark Money Order Paid" onclick="javascript:return confirm('Mark Money Order Received?');"><i class="icon-money"></i></a></span></cfif></td>
																			<td><cfif trim( feestatus ) is "paid"><span class="label label-success">PAID</span><cfelseif trim( feestatus ) is "pending"><span class="label label-info">PENDING</span><cfelseif trim( feestatus ) is "unpaid"><span class="label label-warning">UNPAID</span><cfelseif trim( feestatus ) is "nsf"><span class="label label-important">NSF<cfif nsfreasondescr is not "none"> - #nsfreasondescr#</cfif></span></cfif></td>
																			<td><cfif feecollected eq 1><span class="label label-success">YES</span><cfelse><span class="label label-important">NO</span></cfif></td>																										
																		</tr>
																		<cfset achtotals = achtotals + feeamount />
																		<cfset achpaidtotals = achpaidtotals + feepaid />
																
																</cfoutput>
																
																<!--- // show the totals row --->
																<cfoutput>
																	<tr style="font-size:16px;font-weight:bold;" class="alert alert-info">
																		<td colspan="4">&nbsp;</td>
																		<td style="font-weight:bold;"><div align="left">TOTALS:</td>																		
																		<td style="font-weight:bold;">#dollarformat( achtotals )#</td>
																		<td style="font-weight:bold;">&nbsp;</td>
																		<td style="font-weight:bold;">#dollarformat( achpaidtotals )#</td>
																		<td colspan="2"><cfif achdata.recordcount gt 0><a href="templates/#companysettings.achdatafile#.cfm?sdate=#dateformat( startdate, "yyyy-mm-dd" )#&edate=#dateformat( enddate, "yyyy-mm-dd" )#" onclick="javascript:window.location.href=window.location.href;" class="btn btn-small btn-inverse"><i class="icon-file-alt"></i> Generate #companysettings.achprovider# Data File</cfif></td>
																	<tr>
																</cfoutput>
																
															</tbody>
														</table>
														<p class="tip">
															<span class="label label-info">TIP!</span> &nbsp; Click the column headers to sort the data.  You can sort multiple columns simultaneously by holding down the shift key and clicking a second, third or even fourth column header!
														</p>
														<p class="tip">
															<span class="label label-important">IMPORTANT!</span> &nbsp; No ACH or fee transactions will be processed for <span style="color:red;">inactive</span> clients, clients <span style="color:orange;">missing banking information</span> or clients on <span style="color:blue;">ACH Hold</span>. </span>
														</p>
													
													<cfelse>
													
														<h5><i class="icon-th-large"></i> No Records Found</h5>
														<div class="alert alert-block alert-error">
															<h5><strong>Sorry</strong>, the report can not find any clients matching the report input filter...</h5>
															<p><i class="icon-warning-sign"></i> That's OK!  The filter is most likely working correctly, however, no database records match your input filter. <br />  Please use the button below to reset the filters and restore the default report.</p>
															<p>&nbsp;</p>
															<cfoutput>
																<p><a href="#application.root#?event=#url.event#" class="btn btn-small btn-secondary"><i class="icon-retweet"></i> Reset Filter</a></p>
															</cfoutput>											
														</div>											
													
													</cfif>
												


												<cfelseif structkeyexists( url, "creatensf" ) and url.creatensf is true >
												
												
													<cfinvoke component="apis.com.clients.clientgateway" method="getfeedetail" returnvariable="feedetail">
														<cfinvokeargument name="feeid" value="#url.feeid#">
													</cfinvoke>
													
													<cfquery datasource="#application.dsn#" name="getclientname">
														select f.leadid, l.leadlast, l.leadfirst
														  from fees f, leads l
														 where f.leadid = l.leadid
														   and f.feeuuid = <cfqueryparam value="#url.feeid#" cfsqltype="cf_sql_varchar" maxlength="35" />
													</cfquery>
													
													<cfinvoke component="apis.com.system.settingsgateway" method="getnsfreasons" returnvariable="nsfreasonlist">
														<cfinvokeargument name="companyid" value="#session.companyid#">
													</cfinvoke>
													
													
													<h5><i class="icon-money"></i> Process Returned Bank Item</h5>
													
														<!--- // new advisor complete form --->
														<cfoutput>
															<cfif trim( feedetail.feereturnednsf ) is "N">
																<form class="form-inline" method="post" action="#cgi.script_name#?event=#url.event#">										
																	
																	<div class="well">
																	
																		<p>Client Name: #getclientname.leadfirst# #getclientname.leadlast#</p>
																		<p>Trans Date: #dateformat( feedetail.feetransdate, "mm/dd/yyyy" )#</p>
																		<p>Payment Amount: #dollarformat( feedetail.feeamount )#</p>																		
																																		
																		<br /><br />
																		
																		<select name="nsfreason" class="input-large" id="nsfreason">
																			<option value="" selected>Select Return Reason</option>
																				<cfloop query="nsfreasonlist">
																					<option value="#nsfreasonid#">#nsfreasondescr#</option>																			
																				</cfloop>
																		</select>
																		
																		<input type="text" name="nsfdate" class="input-medium" placeholder="Select Date" id="datepicker-inline4" value="<cfif isdefined( "form.nsfdate" )>#dateformat( form.nsfdate, 'mm/dd/yyyy' )#<cfelse>#dateformat( now(), "mm/dd/yyyy" )#</cfif>">
																							
																		
																		<label class="checkbox">
																			<input style="margin-left:5px;" name="chksendnotify" type="checkbox" value="1" checked> Send Email Notification
																		</label>																		
																		<button type="submit" style="margin-left:5px;" name="creatensf" class="btn btn-small btn-secondary"><i class="icon-save"></i> Process NSF</button>
																		<a href="#application.root#?event=#url.event#" class="btn btn-small btn-warning"><i class="icon-remove"></i> Cancel</a>																	
																		<input type="hidden" name="feeid" value="#feedetail.feeuuid#" />
																		<input type="hidden" name="leadid" value="#getclientname.leadid#" />
																		
																	</div>
																</form>
															<cfelse>
																<p style="color:##F00;">This item has already been marked returned on #dateformat( feedetail.feepaiddate, 'mm/dd/yyyy' )#.  Go Back!</p>
															</cfif>
														</cfoutput>
													
													
												
														<div style="margin-top:100px;"></div>
												
												</cfif>
													
												<!---<cfdump var="#achdata#" label="achinfo">--->
													
												</div> <!-- /widget-content -->
													
											</div> <!-- / .widget -->
											
										</div> <!-- /span12 -->
									
									</div> <!-- / .row -->
									
									
									<cfif ( achdata.recordcount lt 15 ) or ( structkeyexists( url, "creatensf" ))>
										<div style="margin-top:325px;"></div>
									<cfelse>
										<div style="margin-top:100px;"></div>
									</cfif>
									
								  
								</div> <!-- / .container -->
								
							</div> <!-- / .main -->
		
		
		
		
		
		
		
		
		