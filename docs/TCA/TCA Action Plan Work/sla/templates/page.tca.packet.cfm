


			<!--- // get all of our necessary client data access objects --->
				
				
			<!--- // include our data components and api --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
						
			<cfinvoke component="apis.com.clients.clientgateway" method="getclientfees" returnvariable="clientfees">
				<cfinvokeargument name="leadid" value="#clientid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.clients.clientgateway" method="getclientfeetotals" returnvariable="clientfeetotals">
				<cfinvokeargument name="leadid" value="#clientid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.worksheets.worksheetgateway" method="getworksheets" returnvariable="worksheetlist">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.solutions.tcasolutiongateway" method="gettcasolution" returnvariable="tcasolution">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.solutions.tcasolutiongateway" method="gettcasolutions" returnvariable="tcasolutions">
				<cfinvokeargument name="leadid" value="#session.leadid#">
			</cfinvoke>	
			
			
			
			<cfparam name="clientid" default="">
			
			<cfif structkeyexists( url, "clientid" )>
				<cfset clientid = #url.clientid# />
			<cfelse>
				<cfabort>
			</cfif>
			
			<!--- // defaults params --->			
			<cfparam name="today" default="">
			<cfparam name="authkeytoken" default="">
			<cfparam name="ipaddress" default="">
			<cfparam name="paytotal" default="0.00">
			
			<!--- // assign default values --->
			<cfset today = now() />			
			<cfset ipaddress = #cgi.remote_addr# />	
			
			
						
			
			<!--- // define the pdf form params --->
			<cfparam name="ACCOUNTNUMBER" default="#esigninfo.esignaccount#" />
			<cfparam name="ACCTTYPE" default="1" />
			<cfparam name="AUTHKEYTOKEN1" default="#esigninfo.esuuid#" />
			<cfparam name="AUTHKEYTOKEN2" default="#esigninfo.esuuid#" />	
			<cfparam name="AUTHORIZEDSIGNATURE" default="#leaddetail.leadfirst# #leaddetail.leadlast#" />
			<cfparam name="AUTHSIGDATE" default="#dateformat( esigninfo.esdatestamp, "mm/dd/yyyy" )#" />
			<cfparam name="CITY" default="#esigninfo.esignacctcity#" />
			<cfparam name="CLIENTACCOUNTNAME" default="#leaddetail.leadfirst# #leaddetail.leadlast# (#leaddetail.leadid#)" />
			<cfparam name="CLIENTSIGNATURE" default="#leaddetail.leadfirst# #leaddetail.leadlast#" />			
			<cfparam name="CLIENTFIRSTNAME" default="#leaddetail.leadfirst#" />
			<cfparam name="CLIENTFULLNAME" default="#leaddetail.leadfirst# #leaddetail.leadlast#" />
			<cfparam name="DOCUMENTDATE" default="#dateformat( esigninfo.esdatestamp, "mm/dd/yyyy" )#" />
			<cfparam name="FIRSTPAYDATE" default="#dateformat( clientfees.feeduedate, "mm/dd/yyyy" )#" />
			<cfparam name="IPADDRESS" default="#esigninfo.esuserip#" />
			<cfparam name="IPADDRESS2" default="#esigninfo.esuserip#" />
			<cfparam name="ROUTINGNUMBER" default="#esigninfo.esignrouting#" />			
			<cfparam name="SIGNATUREDATE1" default="#dateformat( esigninfo.esdatestamp, "mm/dd/yyyy" )#" />
			<cfparam name="SIGNATUREDATE2" default="#dateformat( esigninfo.esdatestamp, "mm/dd/yyyy" )#" />
			<cfparam name="SPOUSEFULLNAME" default="" />					
			<cfparam name="STATE" default="#esigninfo.esignacctstate#" />			
			<cfparam name="STREETADDRESS" default="#esigninfo.esignacctadd1#" />	
			<cfparam name="ZIPCODE" default="#esigninfo.esignacctzipcode#" />
			
			<cfif esigninfo.esignfeeoption eq 1>				
				<cfparam name="PAYOPTION" default="1" />								
				<cfparam name="NUMBERPAYMENTS" default="#clientfeetotals.numpayments#">
				<cfparam name="PAY1AMOUNT" default="#clientfeetotals.totalfees#">
				<cfparam name="PAY2AMOUNT" default="">
				<cfparam name="PAYTOTAL" default="">
				<cfparam name="FIRSTPAYAMOUNT" default="#clientfeetotals.totalfees#">
				<cfparam name="FIRSTPAYDATE" default="#dateformat( firstpaydate, "mm/dd/yyyy" )#">
			<cfelse>
				<cfparam name="PAYOPTION" default="2" />							
				<cfparam name="NUMBERPAYMENTS" default="#clientfeetotals.numpayments#">
				<cfparam name="PAY2AMOUNT" default="#round( clientfeetotals.totalfees / clientfeetotals.numpayments )#">
				<cfparam name="PAY1AMOUNT" default="">
				<cfparam name="PAYTOTAL" default="#clientfeetotals.totalfees#">
				<cfparam name="FIRSTPAYAMOUNT" default="#round( clientfeetotals.totalfees / clientfeetotals.numpayments )#">
				<cfparam name="FIRSTPAYDATE" default="#dateformat( firstpaydate, "mm/dd/yyyy" )#">
			</cfif>							
			
			<cfif trim( esigninfo.esignaccttype ) is "Checking">
				<cfparam name="ACCTTYPE" default="1" />			
			<cfelse>
				<cfparam name="ACCTTYPE" default="2" />				
			</cfif>			
		
			<!-- // default source document params -->
			<cfparam name="docsourceprefix" default="">
			<cfparam name="sourcedocpath" default="">
			<cfparam name="docsourcecompany" default="">
			<cfparam name="docsourcedocument" default="">
			<cfparam name="docsource" default="">
							
			<!--- // set default source document params --->			
			<cfset docsourceprefix = "D:\WWW\studentloanadvisoronline.com\library\company\" />
			<cfset sourcedocpath = companyportaldocs.esignagreepath1 />
			<cfset docsourcecompany = listfirst( sourcedocpath, "/" ) />
			<cfset docsourcedocument = listlast( sourcedocpath, "/" ) />
							
			<!--- // set the actual document source we will be using to generate the pdf document --->
			<cfset docsource = docsourceprefix & docsourcecompany & "\" & docsourcedocument />	
 
 
			<!--- // read the pdf and set a result variable --->
			<cfpdfform action="read" source="#docsource#" result="formData"/>				
				
			<!---<cfdump var="#formData#" label="formData" />--->				
				
				<!--- // populate the form --->
				<cfpdfform action="populate" source="#docsource#" overwrite="yes">
					<cfpdfformparam name="ACCOUNTNUMBER" value="#accountnumber#" />
					<cfpdfformparam name="ACCTTYPE" value="#accttype#" />
					<cfpdfformparam name="AUTHKEYTOKEN1" value="#authkeytoken1#" />
					<cfpdfformparam name="AUTHKEYTOKEN2" value="#authkeytoken2#" />	
					<cfpdfformparam name="AUTHORIZEDSIGNATURE" value="#clientfullname#" />
					<cfpdfformparam name="AUTHSIGDATE" value="#dateformat( esigninfo.esdatestamp, "mm/dd/yyyy" )#" />					
					<cfpdfformparam name="CITY" value="#city#" />
					<cfpdfformparam name="CLIENTACCOUNTNAME" value="#clientaccountname#" />	
					<cfpdfformparam name="CLIENTFULLNAME" value="#clientfullname#" />
					<cfpdfformparam name="CLIENTFIRSTNAME" value="#clientfirstname#" />
					<cfpdfformparam name="CLIENTSIGNATURE" value="#clientfullname#" />					
					<cfpdfformparam name="DOCUMENTDATE" value="#documentdate#" />
					<cfpdfformparam name="FIRSTPAYAMOUNT" value="#dollarformat( firstpayamount )#" />					
					<cfpdfformparam name="FIRSTPAYDATE" value="#dateformat( firstpaydate, "mm/dd/yyyy" )#" />
					<cfpdfformparam name="IPADDRESS" value="#ipaddress#" />					
					<cfpdfformparam name="IPADDRESS2" value="#ipaddress#" />			
					<cfpdfformparam name="NUMBERPAYMENTS" value="#numberpayments#" />									
					<cfpdfformparam name="PAY1AMOUNT" value="#dollarformat( pay1amount )#" />
					<cfpdfformparam name="PAY2AMOUNT" value="#dollarformat( pay2amount )#" />				
					<cfpdfformparam name="PAYOPTION" value="#payoption#" />					
					<cfpdfformparam name="PAYTOTAL" value="#dollarformat( paytotal )#" />					
					<cfpdfformparam name="ROUTINGNUMBER" value="#routingnumber#" />									
					<cfpdfformparam name="SIGNATUREDATE1" value="#dateformat( esigninfo.esdatestamp, "mm/dd/yyyy" )#" />
					<cfpdfformparam name="SIGNATUREDATE2" value="" />
					<cfpdfformparam name="SPOUSEFULLNAME" value="" />
					<cfpdfformparam name="STATE" value="#ucase( state )#" />
					<cfpdfformparam name="STREETADDRESS" value="#streetaddress#" />
					<cfpdfformparam name="ZIPCODE" value="#zipcode#" />		
					
				</cfpdfform>			
			
			
			
			
			
			
			
			
			
			
			
			
				<!--- // add the correct static PDF document based on the solutions 
				         selected by the user --->
						 
				<cfif trim( tcasolution.consol ) eq 'Y'>
					<cfpdf action="merge" source="#expandpath( 'library/company/tca/tca-consolidation.pdf' )#">										
				</cfif>
														
				<cfif trim( tcasolution.idrconsol ) eq 'Y'>
					<cfpdf action="merge" source="#expandpath( 'library/company/tca/tca-idr.pdf' )#">								
				</cfif>
														
				<cfif trim( tcasolution.pslfconsol ) eq 'Y'>
					<cfpdf action="merge" source="#expandpath( 'library/company/tca/tca-pslf-consolidation.pdf' )#">										
				</cfif>												
														
				<cfif trim( tcasolution.ibr ) eq 'Y'>
															
				</cfif>
														
				<cfif trim( tcasolution.icr ) eq 'Y'>
															
				</cfif>
														
				<cfif trim( tcasolution.paye ) eq 'Y'>
															
				</cfif>
														
				<cfif trim( tcasolution.rehab ) eq 'Y'>
															
				</cfif>
														
				<cfif trim( tcasolution.pslf ) eq 'Y'>
															
				</cfif>									
														
				<cfif trim( tcasolution.tlf ) eq 'Y'>
															
				</cfif>														
														
				<cfif trim( tcasolution.forbear ) eq 'Y'>
															
				</cfif>
														
				<cfif trim( tcasolution.unempdefer ) eq 'Y'>
															
				</cfif>
														
				<cfif trim( tcasolution.econdefer ) eq 'Y'>
															
				</cfif>
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				<!--- // add the footer and closing pages --->
				
				
				
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			