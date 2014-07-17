


			


			<cfparam name="clientid" default="">
			<cfset clientid = #url.clientid# />
			
			<cfif structkeyexists( url, "clientid" )>		
					
				<cfif session.leadid eq clientid>
					
					<cfif structkeyexists( url, "fuseaction" ) and url.fuseaction is "generatedocuments"> --->
			
							<!--- // defaults params --->			
							<cfparam name="today" default="">
							<cfparam name="authkeytoken" default="">
							<cfparam name="ipaddress" default="">			
							
							<!--- // assign default values --->
							<cfset today = now() />			
							<cfset ipaddress = #cgi.remote_addr# />	
							
							
							<!--- // get our data access components --->
							
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
							
							<cfinvoke component="apis.com.clients.clientgateway" method="getclientfeetotals" returnvariable="clientfeetotals">
								<cfinvokeargument name="leadid" value="#clientid#">
							</cfinvoke>	
							
							
							<!--- // define the pdf form params and set default values --->
							<cfparam name="CLIENTFIRSTNAME" default="#leaddetail.leadfirst#" />
							<cfparam name="CLIENTFULLNAME" default="#leaddetail.leadfirst# #leaddetail.leadlast#" />
							<cfparam name="DOCUMENTDATE" default="#dateformat( today, "mm/dd/yyyy" )#" />
							<cfparam name="CLIENTSIGNATUREPRIMARY" default="#leaddetail.leadfirst# #leaddetail.leadlast#" />
							<cfparam name="COSIGNERIFAPP" default="" />
							<cfparam name="SIGNATUREDATE1" default="#dateformat( today, "mm/dd/yyyy" )#" />
							<cfparam name="SIGNATURE2DATE" default="#dateformat( today, "mm/dd/yyyy" )#" />
							<cfparam name="AUTHKEYTOKEN" default="#esigninfo.esuuid#" />
							<cfparam name="IPADDRESS" default="#esigninfo.esuserip#" />					
							<cfparam name="CLIENTACCOUNTNUMBER" default="#leaddetail.leadfirst# #leaddetail.leadlast# (#leaddetail.leadid#)" />						
							<cfparam name="FIRSTPAYDATE" default="#dateformat( clientfees.feeduedate, "mm/dd/yyyy" )#" />
							<cfparam name="NAMEONACCOUNT" default="#esigninfo.esignacctname#" />
							<cfparam name="ADDRESS" default="#esigninfo.esignacctadd1#" />
							<cfparam name="CITY" default="#esigninfo.esignacctcity#" />
							<cfparam name="STATE" default="#esigninfo.esignacctstate#" />
							<cfparam name="ZIPCODE" default="#esigninfo.esignacctzipcode#" />
							<cfparam name="ROUTINGNUMBER" default="#esigninfo.esignrouting#" />
							<cfparam name="ACCOUNTNUMBER" default="#esigninfo.esignaccount#" />
							<cfparam name="AUTHORIZEDSIGNATURE" default="#leaddetail.leadfirst# #leaddetail.leadlast#" />					
							<cfparam name="AUTHKEYTOKEN2" default="#esigninfo.esuuid#" />
							<cfparam name="SIGNATUREDATE" default="#dateformat( today, "mm/dd/yyyy" )#" />
							<cfparam name="IPADDRESS2" default="#ipaddress#" />
							
							
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
							
							<!---
							<cfif trim( esigninfo.esignaccttype ) is "Checking">
								<cfparam name="CHECKINGACCOUNT" default="On" />
								<cfparam name="SAVINGSACCOUNT" default="Off" />
							<cfelse>
								<cfparam name="SAVINGSACCOUNT" default="On" />
								<cfparam name="CHECKINGACCOUNT" default="Off" />
							</cfif>
							--->
							
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
							
							<!--- // read the pdf and set a result variable --->
							<cfpdfform action="read" source="#docsource#" result="formData"/>				
								
								
								
								<!--- // populate the pdf forms vars --->
								<cfpdfform action="populate" source="#docsource#" overwrite="yes">
									
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
							
								
			
						
						<cfelse>
						
							<script>
								alert('Missing required parameters...');
								self.location="javascript:history.back(-1);" 
							</script>							
						
						</cfif>
						<!--- // close fuseaction request on query string --->
					
					<cfelse>
					
						<cfset clientID = session.leadid />
						
							<script>
								self.location="javascript:location.reload();"
							</script>
					
					</cfif>
					<!--- // close check to make sure the existing lead is the current document being generated and if not, swapping the ID's and re-loading the page.--->
				
					
				<cfelse>
					
					<cfabort>
				
				</cfif> <!--- // close check on valid client id --->