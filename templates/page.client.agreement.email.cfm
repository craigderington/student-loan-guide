


			


					<cfparam name="clientid" default="">
					<cfset clientid = session.leadid />
			
			
			
						<!--- // defaults params --->			
						<cfparam name="today" default="">
						<cfparam name="authkeytoken" default="">
						<cfparam name="ipaddress" default="">			
							
						<!--- // assign default values --->
						<cfset today = now() />			
						
							
							
							<!--- // get our data access components --->
							<cfinvoke component="apis.com.system.settingsgateway" method="getcompdetails" returnvariable="compdetails">
								<cfinvokeargument name="companyid" value="#session.companyid#">
							</cfinvoke>
			
							<cfinvoke component="apis.com.system.companysettings" method="getcompanydocs" returnvariable="companydocs">
								<cfinvokeargument name="companyid" value="#session.companyid#">
							</cfinvoke>			
							
							<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
								<cfinvokeargument name="leadid" value="#clientid#">
							</cfinvoke>
							
							<cfinvoke component="apis.com.esign.esigngateway" method="getesigninfo" returnvariable="esigninfo">
								<cfinvokeargument name="leadid" value="#clientid#">
							</cfinvoke>
							
							<cfinvoke component="apis.com.clients.clientgateway" method="getclientfees" returnvariable="clientfees">
								<cfinvokeargument name="leadid" value="#clientid#">
							</cfinvoke>						
							
							<!--- // define the pdf form params and set default values --->
							<cfparam name="CLIENTFIRSTNAME" default="#leaddetail.leadfirst#" />
							<cfparam name="CLIENTFULLNAME" default="#leaddetail.leadfirst# #leaddetail.leadlast#" />
							<cfparam name="DOCUMENTDATE" default="#dateformat( today, "mm/dd/yyyy" )#" />												
							<cfparam name="FIRSTPAYDATE" default="#dateformat( clientfees.feeduedate, "mm/dd/yyyy" )#" />						
							
							<cfif esigninfo.esignfeeoption eq 1>
								<cfparam name="MDAYOPTION1" default="#datepart( 'd', firstpaydate )#" />
								<cfparam name="PAYOPTION1" default="On" />
								<cfparam name="PAYOPTION2" default="Off" />
								<cfparam name="MDAYOPTION2" default="" />
								<cfparam name="NUMBERPAYMENTS" default="#clientfeetotals.numpayments#">
								<cfparam name="PAY1AMOUNT" default="#clientfeetotals.totalfees#">
								<cfparam name="PAY2AMOUNT" default="">
								<cfparam name="PAYTOTAL" default="">
								<cfparam name="FIRSTPAYAMOUNT" default="#clientfeetotals.totalfees#">
								<cfparam name="FIRSTPAYDATE" default="#dateformat( firstpaydate, "mm/dd/yyyy" )#">
							<cfelse>
								<cfparam name="PAYOPTION1" default="Off" />
								<cfparam name="MDAYOPTION1" default="" />
								<cfparam name="PAYOPTION2" default="On" />
								<cfparam name="MDAYOPTION2" default="#datepart( 'd', firstpaydate )#" />
								<cfparam name="NUMBERPAYMENTS" default="#clientfeetotals.numpayments#">
								<cfparam name="PAY2AMOUNT" default="#round( clientfeetotals.totalfees / clientfeetotals.numpayments )#">
								<cfparam name="PAY1AMOUNT" default="">
								<cfparam name="PAYTOTAL" default="#clientfeetotals.totalfees#">
								<cfparam name="FIRSTPAYAMOUNT" default="#round( clientfeetotals.totalfees / clientfeetotals.numpayments )#">
								<cfparam name="FIRSTPAYDATE" default="#dateformat( firstpaydate, "mm/dd/yyyy" )#">
							</cfif>				
							
							<!--- // pop the date for the documents sent to the client --->
							<cfquery datasource="#application.dsn#" name="savedocsummary">
								update slsummary
								   set slenrollclientdocsdate = <cfqueryparam value="#today#" cfsqltype="cf_sql_date" />
								 where leadid = <cfqueryparam value="#clientid#" cfsqltype="cf_sql_integer" />
							</cfquery>
												
							
							<!--- // 7-15-2014 // add company source document changes  --->	
							
							<!-- // default source document params -->
							<cfparam name="docsourceprefix" default="">
							<cfparam name="sourcedocpath" default="">
							<cfparam name="docsourcecompany" default="">
							<cfparam name="docsourcedocument" default="">
							<cfparam name="docsource" default="">
							
							<!--- // set default source document params --->			
							<cfset docsourceprefix = "D:\WWW\studentloanadvisoronline.com\library\company\" />
							<cfset sourcedocpath = companydocs.enrollagreepath />
							<cfset docsourcecompany = listfirst( sourcedocpath, "/" ) />
							<cfset docsourcedocument = listlast( sourcedocpath, "/" ) />
							
							<!--- // set the actual document source we will be using to generate the pdf document --->
							<cfset docsource = docsourceprefix & docsourcecompany & "\" & docsourcedocument />						
							
							<!--- // read the pdf and set a result variable 
							<cfpdfform action="read" source="#docsource#" result="formData"/>
							--->					
								
								<!--- // populate the pdf forms vars --->
								<cfpdfform action="populate" source="#docsource#" destination="#expandpath('library\clients\enrollment')#\#leaddetail.leadfirst#-#leaddetail.leadlast#-#leaddetail.leadid#-Student-Loan-Advisor-Agreement.pdf" overwrite="yes">
									
									<cfpdfformparam name="CLIENTFULLNAME" value="#clientfullname#" />
									<cfpdfformparam name="DOCUMENTDATE" value="#dateformat( documentdate, "mm/dd/yyyy" )#" />
									<cfpdfformparam name="FIRSTPAYAMOUNT" value="#numberformat( firstpayamount, "L999.99" )#" />
									<cfpdfformparam name="FIRSTPAYDATE" value="#dateformat( firstpaydate, "mm/dd/yyyy" )#" />
									<cfpdfformparam name="NUMBERPAYMENTS" value="#numberpayments#" />
									<cfpdfformparam name="PAY1AMOUNT" value="#numberformat( pay1amount, "L999.99" )#" />
									<cfpdfformparam name="PAY2AMOUNT" value="#numberformat( pay2amount, "L999.99" )#" />								
									<cfpdfformparam name="PAYOPTION1" value="#payoption1#" />
									<cfpdfformparam name="PAYOPTION2" value="#payoption2#" />	
									<cfpdfformparam name="PAYTOTAL" value="#numberformat( paytotal, "L999.99" )#" />
								
								</cfpdfform>							
								
								<!--- // all testing variables // 
								<cfdump var="#variables#" label="all vars">		
								<cfdump var="#formData#" label="formData" />							
								<cfdump var="#leaddetail#" label="lead">
								<cfdump var="#clientfees#" label="fees">
								<cfdump var="#esigninfo#" label="esign">
								<cfdump var="#clientfeetotals#" label="fees">						
								--->
								
								<!--- // now read the new document and attach it to our email 
								<cfpdf action="write" name="clientdocuments" source="#thisclientagreement#" />
								--->
								
								<cfmail 
									from="#compdetails.email#(#compdetails.dba#)" 
									to="#leaddetail.leademail#" 
									bcc="craig@efiscal.net" 
									subject="#form.msgsubject#" 
									type="HTML"><h4>*** IMPORTANT DOCUMENTS FROM YOUR STUDENT LOAN ADVISOR TEAM ARE ATTACHED ***<br /><br />

								
<cfoutput>
<div style="background-color:##f2f2f2;border:1px dotted lightgray;padding:25px;">
	<p style="margin-top:25px;">#form.emailmsg#</p>
</div>
<p style="margin-top:75px;"><small>This message was auto-generated from the <a href="https://www.studentloanadvisoronline.com/">Student Loan Advisor</a> website on #dateformat( now(), "mm/dd/yyyy" )# at #timeformat( now(), "hh:mm tt" )#.</small></p>
</cfoutput>
									
									
									
									
									
									
									<!--- // atatch the newly created enrollment agreement --->
									<cfmailparam 
										file="#expandpath('library\clients\enrollment')#\#leaddetail.leadfirst#-#leaddetail.leadlast#-#leaddetail.leadid#-Student-Loan-Advisor-Agreement.pdf"
										type="application/pdf"										
										/>
								
																		<cfmailparam
										name="Reply-To" 
										value="#getauthuser()#"
										/>
								
								
								
								
								</cfmail>
								
								
								
								<!--- // save the document to the clients document library --->
								<!--- // only save the document if there is not already a document in the library --->
								<!--- // so we have to check to see if there is already an existing document --->
								
								<cfquery datasource="#application.dsn#" name="checklibrary">
									select count(*) as totaldocs
									  from documents
									 where leadid = <cfqueryparam value="#leaddetail.leadid#" cfsqltype="cf_sql_integer" />
									   and doccatid = <cfqueryparam value="490762" cfsqltype="cf_sql_integer" />
								</cfquery>
								
								<cfparam name="thisdocpath" default="">
								<cfset thisdocpath = leaddetail.leadfirst & "-" & leaddetail.leadlast & "-" & leaddetail.leadid & "-" & "Student-Loan-Advisor-Agreement.pdf" />
								
								<!--- // only save the document if there is not already a document in the library ---> 
								<cfif checklibrary.totaldocs eq 0>
								
									<cfquery datasource="#application.dsn#" name="savethisdoc">
										insert into documents(docuuid, leadid, docname, docfileext, docpath, docdate, docuploaddate, uploadedby, docactive, doccatid)
											 values (
													<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar" maxlength="35" />,
													<cfqueryparam value="#leaddetail.leadid#" cfsqltype="cf_sql_integer" />,
													<cfqueryparam value="#leaddetail.leadfirst#-#leaddetail.leadlast#-#leaddetail.leadid#-Enrollment-Agreement" cfsqltype="cf_sql_varchar" />,
													<cfqueryparam value=".pdf" cfsqltype="cf_sql_varchar" />,
													<cfqueryparam value="#thisdocpath#" cfsqltype="cf_sql_varchar" />,
													<cfqueryparam value="#today#" cfsqltype="cf_sql_date" />,
													<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
													<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
													<cfqueryparam value="1" cfsqltype="cf_sql_bit" />,
													<cfqueryparam value="490762" cfsqltype="cf_sql_integer" />
													);
									</cfquery>
								
								</cfif>
								
								
								<!--- // redirect upon successful email and document save --->
								<cflocation url="#application.root#?event=page.enroll.status&msg=email&status=sent" addtoken="no">
							