	
	
			
			<!--- // get our data access components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">			
			</cfinvoke>
			
			<cfinvoke component="apis.com.clients.clientgateway" method="getclientfees" returnvariable="clientfees">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.clients.clientgateway" method="getclientfeetotals" returnvariable="clientfeetotals">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.esign.esigngateway" method="getesigninfo" returnvariable="esigninfo">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			
			
			
			
			
			
			<cfparam name="today" default="">
			<cfparam name="totalfees" default="0.00">			
			<cfset today = createodbcdatetime( now() ) />
			
			<!--- page to enroll and e-sign the enrollment documents --->
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">				
							
							<div class="widget stacked">
								
								<cfoutput>	
									<div class="widget-header">		
										<i class="icon-pencil"></i>							
										<h3>Student Loan Program Enrollment Documents | Electronic Signature for #leaddetail.leadfirst# #leaddetail.leadlast# <cfif structkeyexists( url, "step" )> | Step #url.step#</cfif></h3>						
									</div> <!-- //.widget-header -->
								</cfoutput>	
							
								<div class="widget-content">
									
									<!--- validate.cfc form processing --->
									<cfif isDefined("form.fieldnames")>
										<cfscript>
											objValidation = createObject("component","apis.com.ui.validation").init();
											objValidation.setFields(form);
											objValidation.validate();
										</cfscript>

											<cfif objValidation.getErrorCount() is 0>
												
													<cfset lead = structnew() />
													<cfset lead.leadid = #form.leadid# />												
													<cfset lead.step = #form.stepnumber# />
													<cfset lead.nextstep = #form.stepnumber# + 1 />
													<cfset lead.userip = #cgi.remote_addr# />
													<cfset lead.esid = #esigninfo.esid# />											
												
														<cfif lead.step eq 1>														
															
															<cfquery datasource="#application.dsn#" name="leadesign1">
																update esign
																   set esdatestamp = <cfqueryparam value="#today#" cfsqltype="cf_sql_date" />,
																       esuserip = <cfqueryparam value="#lead.userip#" cfsqltype="cf_sql_varchar" maxlength="15" />																	   
																 where esid = <cfqueryparam value="#lead.esid#" cfsqltype="cf_sql_integer" />														   
															</cfquery>
															
															<cflocation url="#application.root#?event=#url.event#&fuseaction=donext&step=#lead.nextstep#" addtoken="yes">
															
														<cfelseif lead.step eq 2>
														
															<cfquery datasource="#application.dsn#" name="leadesign2">
																update esign
																   set esconfirm = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
																 where esid = <cfqueryparam value="#lead.esid#" cfsqltype="cf_sql_integer" />														   
															</cfquery>
															
															<cflocation url="#application.root#?event=#url.event#&fuseaction=donext&step=#lead.nextstep#" addtoken="yes">
														
														<cfelseif lead.step eq 3>
															
															<cfset lead.initials = "#ucase( form.esconfirminitials )#" />
																<cfquery datasource="#application.dsn#" name="leadesign3">
																	update esign
																	   set esconfirminitials = <cfqueryparam value="#lead.initials#" cfsqltype="cf_sql_varchar" />
																	 where esid = <cfqueryparam value="#lead.esid#" cfsqltype="cf_sql_integer" />														   
																</cfquery>													
															
															<cflocation url="#application.root#?event=#url.event#&fuseaction=donext&step=#lead.nextstep#" addtoken="yes">
														
														<cfelseif lead.step eq 4>
														
															<cfset lead.dlnumber = #form.dlnumber# />
															<cfset lead.dlstate = #left( form.dlstate, 2 )# />
															<cfset lead.routing = #trim( form.routingnumber )# />
															<cfset lead.acctnumber = #trim( form.accountnumber )# />
															<cfset lead.accountname = "#trim( form.firstname )# #trim( form.lastname )#" />
															<cfset lead.accttype = #trim( form.accounttype )# />
															<cfset lead.address = #trim( form.streetaddress )# />
															<cfset lead.city = #trim( form.city )# />
															<cfset lead.state = #trim( ucase( form.state ))# />
															<cfset lead.zipcode = #trim( form.zipcode )# />
															<cfset lead.payoption = #form.mpayoption# />
															
															<cfquery datasource="#application.dsn#" name="leadesign4">
																update esign
																   set esconfirmfullname = <cfqueryparam value="#lead.accountname#" cfsqltype="cf_sql_varchar" />,
																	   esignaccttype = <cfqueryparam value="#lead.accttype#" cfsqltype="cf_sql_varchar" />,
																	   esdriverslicensenumber = <cfqueryparam value="#lead.dlnumber#" cfsqltype="cf_sql_varchar" />,
																	   esdriverslicensestate = <cfqueryparam value="#lead.dlstate#" cfsqltype="cf_sql_varchar" />,
																	   esignrouting = <cfqueryparam value="#lead.routing#" cfsqltype="cf_sql_varchar" />,
																	   esignaccount = <cfqueryparam value="#lead.acctnumber#" cfsqltype="cf_sql_varchar" />,
																	   esignacctnumber = <cfqueryparam value="#lead.accountname# (#lead.leadid#)" cfsqltype="cf_sql_varchar" />,
																	   esignacctname = <cfqueryparam value="#lead.accountname#" cfsqltype="cf_sql_varchar" />,
																	   esignfeeoption = <cfqueryparam value="#lead.payoption#" cfsqltype="cf_sql_numeric" />,
																	   esignacctadd1 = <cfqueryparam value="#lead.address#" cfsqltype="cf_sql_varchar" />,
																	   esignacctcity = <cfqueryparam value="#lead.city#" cfsqltype="cf_sql_varchar" />,
																	   esignacctstate = <cfqueryparam value="#lead.state#" cfsqltype="cf_sql_varchar" />,
																	   esignacctzipcode = <cfqueryparam value="#lead.zipcode#" cfsqltype="cf_sql_varchar" />,
																	   escompleted = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
																 where esid = <cfqueryparam value="#lead.esid#" cfsqltype="cf_sql_integer" />														   
															</cfquery>
															
															<!-- // flag the lead as having completed e-sign -->
															<cfquery datasource="#application.dsn#" name="updateleadsummary">
																update leads
																   set leadesign = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />,
																       leadconv = <cfqueryparam value="1" cfsqltype="cf_sql_bit" /> 
																 where leadid = <cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />														   
															</cfquery>
															
															<!--- // mark the portal task complete --->
															<cfinvoke component="apis.com.portal.portaltaskgateway" method="markportaltaskcompleted" returnvariable="taskstatusmsg">
																<cfinvokeargument name="portaltaskid" value="1406">
																<cfinvokeargument name="leadid" value="#session.leadid#">
															</cfinvoke>
															
															<!--- // flag the lead summary as docs returned and signed --->
															<cfquery datasource="#application.dsn#" name="summary">
																update slsummary																	   
																   set slenrollreturndate = <cfqueryparam value="#today#" cfsqltype="cf_sql_date" />,
																	   slenrolldocsuploaddate = <cfqueryparam value="#today#" cfsqltype="cf_sql_date" />																		   
																 where leadid = <cfqueryparam value="#lead.leadid#" cfsqltype="cf_sql_integer" />
															</cfquery>
															
															<cfset session.leadesign = 1 />
															
															<cflocation url="#application.root#?event=#url.event#" addtoken="no">
														
															
														
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
									
									
									

									<div class="tab-content">
												
										<div class="tab-pane active" id="tab1">											
											
											<!--- // show an infram with embedded enrollment documemnt --->
											<div class="span5" style="margin-top:25px;">													
												<iframe name="enrollagreement" src="../docs/sla-client-agreement.pdf" width="400" height="475" align="left" seamless></iframe>												
											</div>
											
											
											<div class="span6" style="margin-left:10px;margin-top:25px;padding:5px;">
														
												<div class="well">


													<cfif esigninfo.escompleted neq 1>
													
														<cfif not structkeyexists( url, "fuseaction" )>
															<cfoutput>
																	<h4><i class="icon-user"></i> Your Information <span style="float:right;font-size:14px;">Entered On: #dateformat(leaddetail.leaddate, "mm/dd/yyyy")#</span></h4>										
																	<p style="color:##ff0000;">* Denotes a required field</p>
																	<br>
																	
																	<form id="edit-lead-profile" class="form-horizontal" method="post" action="#application.root#?event=#url.event#">
																		<fieldset>													

																			<div class="control-group">											
																				<label class="control-label" for="firstname">First Name <span style="color:##ff0000;">*</span></label>
																				<div class="controls">
																					<input type="text" class="input-large" name="firstname" id="firstname" value="<cfif isdefined( "form.firstname" )>#trim( form.firstname )#<cfelse>#leaddetail.leadfirst#</cfif>">
																				</div> <!-- /controls -->				
																			</div> <!-- /control-group -->															
																			
																			<div class="control-group">											
																				<label class="control-label" for="lastname">Last Name <span style="color:##ff0000;">*</span></label>
																				<div class="controls">
																					<input type="text" class="input-large" name="lastname" id="lastname" value="<cfif isdefined( "form.lastname" )>#trim( form.lastname )#<cfelse>#leaddetail.leadlast#</cfif>">
																				</div> <!-- /controls -->				
																			</div> <!-- /control-group -->
																			
																			<div class="control-group">											
																				<label class="control-label" for="lastname">Address <span style="color:##ff0000;">*</span></label>
																				<div class="controls">
																					<input type="text" class="input-large" name="streetaddress" id="streetaddress" value="<cfif isdefined( "form.streetaddress" )>#trim( form.streetaddress )#<cfelse>#leaddetail.leadadd1#</cfif>">																	
																				</div> <!-- /controls -->				
																			</div> <!-- /control-group -->															
																			
																			<div class="control-group">											
																				<label class="control-label" for="lastname">City, State, Zip <span style="color:##ff0000;">*</span></label>
																				<div class="controls">																	
																					<input type="text" class="input-medium" name="city" id="city" value="<cfif isdefined( "form.city" )>#trim( form.city )#<cfelse>#leaddetail.leadcity#</cfif>">
																					<input type="text" class="input-small span1" name="state" id="state" value="<cfif isdefined( "form.state" )>#trim( form.state )#<cfelse>#leaddetail.leadstate#</cfif>">&nbsp;&nbsp;
																					<input type="text" class="input-small span1" name="zipcode" id="zipcode" value="<cfif isdefined( "form.zipcode" )>#trim( form.zipcode )#<cfelse>#leaddetail.leadzip#</cfif>">
																				</div> <!-- /controls -->			
																			</div> <!-- /control-group -->														
																			
																			<div class="control-group">											
																				<label class="control-label" for="email">Email Address <span style="color:##ff0000;">*</span></label>
																				<div class="controls">
																					<input type="text" class="input-large" name="email" id="email" value="<cfif isdefined( "form.email" )>#trim( form.email )#<cfelse>#leaddetail.leademail#</cfif>">																		
																				</div> <!-- /controls -->				
																			</div> <!-- /control-group -->												
																			
																			<br />											
																			
																			<div class="form-actions">													
																				<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.portal.home'"><i class="icon-remove-sign"></i> Cancel</a>
																				<button type="submit" class="btn btn-secondary" name="savelead"> Continue <i class="icon-circle-arrow-right"></i></button>											
																				<input name="utf8" type="hidden" value="&##955;">													
																				<input type="hidden" name="leadid" value="#leaddetail.leadid#" />																		
																				<input type="hidden" name="stepnumber" value="1" />
																				<input type="hidden" name="__authToken" value="#randout#" />																
																			</div> <!-- /form-actions -->
																			
																		</fieldset>
																	</form>
																	</cfoutput>
																
														<cfelseif structkeyexists( url, "fuseaction" )>
															
															<cfif url.step eq 2>
																
																
																
																<cfoutput>
																					<h4><i class="icon-edit"></i> Electronic Signature Disclosures</h4>										
																					<p style="color:##ff0000;"></p>
																					<br>
																									
																					<form id="edit-lead-profile" class="form-horizontal" method="post" action="#application.root#?event=#url.event#&fuseaction=donext&step=#url.step#">
																					<fieldset>													

																					<textarea rows="20" style="height:512px;width:525px;">Electronic Disclosure and Electronic Signature Agreement
Effective: August 16, 2013

The Electronic Signatures in Global and National Commerce Act (ESIGN) requires your approval before we can provide services to you electronically. Please read this Electronic Signature Disclosure and Agreement carefully and save or print a copy for your records.

Terms: This Disclosure and Agreement (“Agreement”) is the contract which covers your and our rights and responsibilities concerning the service offered to you by Consumer Debt Counselors, LLC. The service permits you to electronically sign your enrollment agreement, manage the data provided to Consumer Debt Counselors, LLC. for your student loans, communicate with Advisors, and to electronically receive disclosures and records regarding your account(s) with SLA. In this Agreement, the words “you,” “your,” and “yours” mean those who request and use the service, including any joint owners or any person authorized to use your services. The words “we,” “us,” and “our” mean SLA. By using the service, each of you, jointly and severally, agree to the terms and conditions of this Agreement, and any amendments.  The terms of this Agreement are in addition to the terms of any other client agreements you have with us, including but not limited to the: a) Client Enrollment Agreement for Student Loan Advisory Services; and b) Fee Disclosures, Privacy Notice and Electronic Fund Transfers Agreement, and any change of terms notices.

Electronic Signature (e-Signature): You consent and agree that your use of a key pad, mouse or other device to select an item, button, icon or similar act/action while using any electronic service we offer; or in accessing or making any transactions regarding any agreement, acknowledgement, consent, terms, disclosures or conditions constitutes your signature, acceptance and agreement as if actually signed by you in writing. Further, you agree that no certification authority or other third party verification is necessary to validate your electronic signature; and that the lack of such certification or third party verification will not in any way affect the enforceability of your signature or resulting contract between you and Student Loan Advisor Online. You understand and agree that your e-Signature executed in conjunction with the electronic submission of your application shall be legally binding and such transaction shall be considered authorized by you.

Your Consent is Required: By enrolling, you are agreeing to receive documents electronically including disclosures and notices we may need to provide you, including, but not limited to: Client Enrollment Agreement and Account Disclosures (as described above). You also agree to receive an e-mail with a link to enroll for electronic statements (e-Statements) for any account(s) you have with us where you are the primary user.

If you do not wish to receive e-Statements, disregard the e-mails and paper statements will be sent to you.

System Requirements: To receive the applicable disclosures and statements electronically you will need:


&bull; A personal computer or other device which is capable of accessing the Internet.
&bull; An active Internet Service Provider.
&bull; An Internet Web Browser with capabilities to support a minimum 128-bit encryption. An “A-Class Browser Support Chart” can be found at http://yuilibrary.com/yui/environments/.
&bull; The ability to download or print agreements, disclosures, and e-Statements.
&bull; Software which permits you to receive and access Portable Document Format (PDF) files, such as Adobe Acrobat Reader® (you will need one of the last three versions.)


Adobe Acrobat is free software available at www.adobe.com.  Please note: e-Statements will only be available in PDF formatting.

System Requirements to Retain Disclosures: To retain disclosures and e-Statements for your records, your system must have the ability to either download to your hard disk drive or print PDF files.

Requesting Paper Copies of Disclosures: If, after consenting to receive applicable disclosures electronically you would like paper copies of the disclosures or statements, we will send them to you. Refer to the Truth-in-Savings Disclosures for fees for copies of statements. Copies of disclosures are at no cost. There is no charge to convert from electronic disclosures and statements to paper disclosures and statements. If you would like to receive future disclosures or statements by paper instead of electronically; or you need copies of these disclosures, contact us using the following information:

E-mail: info@studentloanadvisoronline.com
Telephone: 800-820-9232 to speak to a Member Advisor
Postal mail: 
Consumer Debt Counselors, LLC.
Attn: e-Signature Services
831 West Morse Blvd.
Winter Park, FL 32789

Updating Your Personal Information: You are responsible for keeping your e-mail address updated. You should keep us informed of any changes in your telephone number, mailing address, or e-mail address by contacting us using one of the methods listed above.
</textarea>
																											
																					<br /><br />											
																											
																											<label class="checkbox">
																												<input style="margin-left:5px;" name="chkcertify" type="checkbox"> &nbsp;I have read and agree with the Electronic Signature Disclosure.
																											</label>
																											
																											
																											<div class="form-actions">													
																												<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.portal.home'"><i class="icon-remove-sign"></i> Cancel</a>
																												<button type="submit" class="btn btn-secondary" name="savelead"><i class="icon-circle-arrow-right"></i> Continue </button>											
																												<input name="utf8" type="hidden" value="&##955;">													
																												<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
																												<input type="hidden" name="__authToken" value="#randout#" />
																												<input type="hidden" name="stepnumber" value="2" />
																												<input name="validate_require" type="hidden" value="chkcertify|'You must agree' in order to continue..." />
																											</div> <!-- /form-actions -->
																											
																										</fieldset>
																									</form>
																									</cfoutput>
															<cfelseif url.step eq 3>
															
																<cfif clientfees.recordcount gt 0>
																	
																			<h4><i class="icon-money"></i> Fee Schedule</h4>										
																					
																			<br>
																					
																			<table class="table table-bordered table-striped table-highlight">
																				<thead>
																					<tr>																																			
																						<th>Fee Dates</th>
																						<th>Amount</th>
																						<th>Status</th>
																					</tr>
																				</thead>
																				<tbody>
																					<cfoutput query="clientfees">
																						<tr>											
																							<td>#dateformat(feeduedate, "mm/dd/yyyy")#</td>
																							<td>#dollarformat(feeamount)#</td>																	
																							<td><cfif trim(feestatus) is "paid"><span class="label label-success">#feestatus#</span><cfelse><span class="label label-error">#feestatus#</span></cfif></td>
																						</tr>
																						<cfset totalfees = totalfees + feeamount />																				
																					</cfoutput>
																								
																					<!--- // show the totals row --->	
																					<tr>
																						<td>Total Fees: </td>
																						<td colspan="2"><cfoutput>#dollarformat( totalfees )#</cfoutput>																				
																					</tr>
																				</tbody>
																			</table>
																			
																			<span style="float:right;"><cfoutput><small>The enrollment fee schedule was created on #dateformat(clientfees.createddate, "mm/dd/yyyy")# by #clientfees.firstname# #clientfees.lastname#.</small></cfoutput></span>
																					
																			<br />
																					<cfoutput>
																					<form class="form-inline" method="post" action="#cgi.script_name#?event=#url.event#&fuseaction=donext&step=#url.step#">											
																																								
																						
																						<label class="checkbox">
																							<input style="margin-left:5px;" name="feeagree" type="checkbox"> I Agree to the above fee schedule.
																						</label>
																						<br />
																						
																						
																						<input style="margin-top:10px;margin-bottom:10px;" type="text" name="esconfirminitials" class="input-medium" placeholder="Enter Initials" value="<cfif isdefined( "form.esconfirminitials" )>#form.esconfirminitials#</cfif>">
																						
																						<br />
																						
																						<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.portal.home'"><i class="icon-remove-sign"></i> Cancel</a>
																						<button type="submit" style="margin-left:5px;" name="saveintake" class="btn btn-secondary"><i class="icon-circle-arrow-right"></i> Continue</button>																		
																						<p style="margin-top:5px;">By checking I Agree, you hereby certify that you will pay the agreed to fee schedule for the Student Loan Advisory Services.																		
																						<input type="hidden" name="stepnumber" value="3" />
																						<input type="hidden" name="leadid" value="#leaddetail.leadid#" />
																						<input name="validate_require" type="hidden" value="leadid|'Lead ID' is a required field.;feeagree|You must select I agree to continue.;esconfirminitials|Please enter your initials.">
																					</form>
																					</cfoutput>								
																				
																				
																		</cfif><!-- / / .client-fees -->
															
															
															
															<cfelseif url.step eq 4>
															
																<cfoutput>
																					<h4><i class="icon-user"></i> Payment Information</h4>										
																					<p style="color:##ff0000;">* Denotes a required field</p>
																					<br>
																					
																					<form id="edit-lead-profile" class="form-horizontal" method="post" action="#application.root#?event=#url.event#&fuseaction=donext&step=#url.step#">
																						<fieldset>													

																							<div class="control-group">											
																								<label class="control-label" for="firstname">First Name <span style="color:##ff0000;">*</span></label>
																								<div class="controls">
																									<input type="text" class="input-large" name="firstname" id="firstname" value="<cfif isdefined( "form.firstname" )>#trim( form.firstname )#<cfelse>#leaddetail.leadfirst#</cfif>">
																								</div> <!-- /controls -->				
																							</div> <!-- /control-group -->															
																							
																							<div class="control-group">											
																								<label class="control-label" for="lastname">Last Name <span style="color:##ff0000;">*</span></label>
																								<div class="controls">
																									<input type="text" class="input-large" name="lastname" id="lastname" value="<cfif isdefined( "form.lastname" )>#trim( form.lastname )#<cfelse>#leaddetail.leadlast#</cfif>">
																								</div> <!-- /controls -->				
																							</div> <!-- /control-group -->
																							
																							<div class="control-group">											
																								<label class="control-label" for="lastname">Address <span style="color:##ff0000;">*</span></label>
																								<div class="controls">
																									<input type="text" class="input-large" name="streetaddress" id="streetaddress" value="<cfif isdefined( "form.streetaddress" )>#trim( form.streetaddress )#<cfelse>#leaddetail.leadadd1#</cfif>">																	
																								</div> <!-- /controls -->				
																							</div> <!-- /control-group -->															
																							
																							<div class="control-group">											
																								<label class="control-label" for="lastname">City, State, Zip <span style="color:##ff0000;">*</span></label>
																								<div class="controls">																	
																									<input type="text" class="input-medium" name="city" id="city" value="<cfif isdefined( "form.city" )>#trim( form.city )#<cfelse>#leaddetail.leadcity#</cfif>">
																									<input type="text" class="input-small span1" name="state" id="state" value="<cfif isdefined( "form.state" )>#trim( form.state )#<cfelse>#leaddetail.leadstate#</cfif>">&nbsp;&nbsp;
																									<input type="text" class="input-small span1" name="zipcode" id="zipcode" value="<cfif isdefined( "form.zipcode" )>#trim( form.zipcode )#<cfelse>#leaddetail.leadzip#</cfif>">
																								</div> <!-- /controls -->			
																							</div> <!-- /control-group -->

																							<div class="control-group">
																									<label class="control-label" for="mpayoption">Pay Option</label>
																									<div class="controls">
																										<label class="radio">
																											<input type="radio" name="mpayoption" value="1" checked="checked" id="mpayoption">
																											Pay Option 1 (1 payment of  #dollarformat( clientfeetotals.totalfees )#)
																										</label>
																										<label class="radio">
																											<input type="radio" name="mpayoption" value="2">
																											Pay Option 2 (#numberformat( clientfeetotals.numpayments, "9" )# payments of #dollarformat( clientfeetotals.totalfees / clientfeetotals.numpayments )# = #dollarformat( clientfeetotals.totalfees )#)
																										</label>
																									</div>
																								</div>
																							
																							<br /><br />
																							
																							<h5>Banking Details</h5>

																								<div class="control-group">
																									<label class="control-label" for="accounttype">Account Type</label>
																									<div class="controls">
																										<label class="radio">
																											<input type="radio" name="accounttype" value="Checking" checked="checked">
																											Checking
																										</label>
																										<label class="radio">
																											<input type="radio" name="accounttype" value="Savings">
																											Savings
																										</label>
																									</div>
																								</div>
																								
																								<div class="control-group">											
																									<label class="control-label" for="email">Routing Number<span style="color:##ff0000;">*</span></label>
																									<div class="controls">
																										<input type="password" class="input-large" name="routingnumber" id="routingnumber" value="<cfif isdefined( "form.routingnumber" )>#form.routingnumber#</cfif>">																		
																									</div> <!-- /controls -->				
																								</div> <!-- /control-group -->

																								<div class="control-group">											
																									<label class="control-label" for="email">Account Number<span style="color:##ff0000;">*</span></label>
																									<div class="controls">
																										<input type="password" class="input-large" name="accountnumber" id="accountnumber" value="<cfif isdefined( "form.accountnumber" )>#form.accountnumber#</cfif>">																		
																									</div> <!-- /controls -->				
																								</div> <!-- /control-group -->
																								
																								<br />
																								
																								<h5>Drivers License Number and State of Issue</h5>
																								
																								<div class="control-group">											
																									<label class="control-label" for="email">DL Number<span style="color:##ff0000;">*</span></label>
																									<div class="controls">
																										<input type="text" class="input-large" name="dlnumber" id="dlnumber" value="<cfif isdefined( "form.dlnumber" )>#form.dlnumber#</cfif>">																		
																									</div> <!-- /controls -->				
																								</div> <!-- /control-group -->

																								<div class="control-group">											
																									<label class="control-label" for="email">State<span style="color:##ff0000;">*</span></label>
																									<div class="controls">
																										<input type="text" class="input-small span1" name="dlstate" id="dlstate" value="<cfif isdefined( "form.dlstate" )>#form.dlstate#</cfif>">																		
																									</div> <!-- /controls -->				
																								</div> <!-- /control-group -->
																								
																							
																								<br />											
																							
																								<div class="form-actions">													
																									<a name="cancel" class="btn btn-primary" onclick="location.href='#application.root#?event=page.portal.home'"><i class="icon-remove-sign"></i> Cancel</a>
																									<button type="submit" class="btn btn-secondary" name="savelead"> Continue <i class="icon-circle-arrow-right"></i></button>											
																									<input name="utf8" type="hidden" value="&##955;">													
																									<input type="hidden" name="stepnumber" value="4" />
																									<input type="hidden" name="leadid" value="#leaddetail.leadid#" />																					
																									<input type="hidden" name="__authToken" value="#randout#" />
																									<input name="validate_require" type="hidden" value="leadid|'Lead ID' is a required field.;accounttype|Please select your type of bank account.;routingnumber|Please enter your routing number.;accountnumber|Please enter your account number.;dlnumber|Please enter your drivers license number.;dlstate|Please enter your drivers license State of Issue.">
																								</div> <!-- /form-actions -->
																							
																						</fieldset>
																					</form>
																				</cfoutput>
															
															</cfif>
															
														</cfif>												
													
													
													<cfelse>
														
														
														<cfoutput>
																								
																			<div class="alert alert-success">															
																				<i class="icon-check"></i> &nbsp; <strong>You electronically signed your documents on #dateformat( esigninfo.esdatestamp, "mm/dd/yyyy" )#</strong>
																				
																				<p style="margin-top:5px;">Your student loan enrollment agreement was signed electronically on the date above using the following credentials:
																					<ul>																
																						<li>Full Name: #esigninfo.esconfirmfullname#</li>
																						<li>Initials: #esigninfo.esconfirminitials#</li>
																						<li>Date: #dateformat( esigninfo.esdatestamp, "mm/dd/yyyy" )#</li>
																						<li>Confirmation Key: #esigninfo.esuuid#</li>
																						<li>E-Sign From IP: #esigninfo.esuserip#</li>
																					</ul>
																				</p>
																			</div>
																			
																			<div style="margin-top:10px;">
																				<a href="javascript:;" onclick="window.open('../templates/page.printdocs.cfm?clientid=#leaddetail.leadid#', '','scrollbars=yes,width=700,height=600');" class="btn btn-medium btn-secondary" target="_blank"><i class="icon-print"></i> Print Enrollment Documents</a><a style="margin-left:5px;" href="#application.root#?event=page.portal.home" class="btn btn-medium btn-primary"><i class="icon-refresh"></i> Return to Portal Home</a>
																			</div>
													
													
														</cfoutput>	
													
													
													</cfif>
												
												
												
												</div><!-- / .well -->
											</div><!-- / .span6 -->

													
											
											
											
											
										</div> <!-- / .tab1 -->										 
											
									</div> <!-- / .tab-content -->
									
					
								</div> <!-- / .widget-content -->
							
							</div> <!-- / .widget-stacked -->
						
						</div><!-- / .span12 -->
					
					</div> <!-- / .row -->
					<div style="margin-top:125px;"></div>
				</div> <!-- / .container -->
			
			</div> <!-- / .main -->
		