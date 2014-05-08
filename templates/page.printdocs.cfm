


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
			
			<!--- // assign default values --->
			<cfset today = now() />			
			<cfset ipaddress = #cgi.remote_addr# />	
			
			
			<!--- // get our data access components --->
			<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
				<cfinvokeargument name="leadid" value="#clientid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.esign.esigngateway" method="getesigninfo" returnvariable="esigninfo">
				<cfinvokeargument name="leadid" value="#clientid#">
			</cfinvoke>
			
			<cfinvoke component="apis.com.clients.clientgateway" method="getclientfees" returnvariable="clientfees">
				<cfinvokeargument name="leadid" value="#clientid#">
			</cfinvoke>
			

			
			
			
			<!--- // define the pdf form params --->
			<cfparam name="CLIENTFIRSTNAME" default="#leaddetail.leadfirst#" />
			<cfparam name="CLIENTFULLNAME" default="#leaddetail.leadfirst# #leaddetail.leadlast#" />
			<cfparam name="DOCUMENTDATE" default="#dateformat( esigninfo.esdatestamp, "mm/dd/yyyy" )#" />
			<cfparam name="CLIENTSIGNATUREPRIMARY" default="#leaddetail.leadfirst# #leaddetail.leadlast#" />
			<cfparam name="COSIGNERIFAPP" default="" />
			<cfparam name="SIGNATUREDATE1" default="#dateformat( esigninfo.esdatestamp, "mm/dd/yyyy" )#" />
			<cfparam name="SIGNATURE2DATE" default="#dateformat( esigninfo.esdatestamp, "mm/dd/yyyy" )#" />
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
			<cfparam name="SIGNATUREDATE" default="#dateformat( esigninfo.esdatestamp, "mm/dd/yyyy" )#" />
			<cfparam name="IPADDRESS2" default="#ipaddress#" />
			
			
			<cfif esigninfo.esignfeeoption eq 1>
				<cfparam name="MDAYOPTION1" default="#datepart( 'd', firstpaydate )#" />
				<cfparam name="PAYOPTION1" default="On" />
				<cfparam name="PAYOPTION2" default="Off" />
				<cfparam name="MDAYOPTION2" default="" />
			<cfelse>
				<cfparam name="PAYOPTION1" default="Off" />
				<cfparam name="MDAYOPTION1" default="" />
				<cfparam name="PAYOPTION2" default="On" />
				<cfparam name="MDAYOPTION2" default="#datepart( 'd', firstpaydate )#" />
			</cfif>
			
			<cfif trim( esigninfo.esignaccttype ) is "Checking">
				<cfparam name="CHECKINGACCOUNT" default="On" />
				<cfparam name="SAVINGSACCOUNT" default="Off" />
			<cfelse>
				<cfparam name="SAVINGSACCOUNT" default="On" />
				<cfparam name="CHECKINGACCOUNT" default="Off" />
			</cfif>
			
			
			
		
			<!-- // default param -->
			<cfparam name="docsource" default="">			
			
			<!--- // source pdf document --->
			<cfset docsource = "D:\WWW\studentloanadvisoronline.com\docs\sla-client-agreement5.pdf" />
 
 
			<!--- // read the pdf and set a result variable --->
			<cfpdfform action="read" source="#docsource#" result="formData"/>
				
				
				<!----<cfdump var="#formData#" label="formData" />--->		
				
				
				
				<cfpdfform action="populate" source="#docsource#" overwrite="yes">
					<cfpdfformparam name="CLIENTFIRSTNAME" value="#clientfirstname#" />
					<cfpdfformparam name="CLIENTFULLNAME" value="#clientfullname#" />
					<cfpdfformparam name="DOCUMENTDATE" value="#documentdate#" />
					<cfpdfformparam name="CLIENTSIGNATUREPRIMARY" value="#clientfullname#" />
					<cfpdfformparam name="COSIGNERIFAPP" value="" />
					<cfpdfformparam name="SIGNATUREDATE1" value="#dateformat( esigninfo.esdatestamp, "mm/dd/yyyy" )#" />
					<cfpdfformparam name="SIGNATURE2DATE" value="#dateformat( esigninfo.esdatestamp, "mm/dd/yyyy" )#" />
					<cfpdfformparam name="AUTHKEYTOKEN" value="#authkeytoken#" />
					<cfpdfformparam name="IPADDRESS" value="#ipaddress#" />					
					<cfpdfformparam name="CLIENTACCOUNTNUMBER" value="#clientaccountnumber#" />
					<cfpdfformparam name="MDAYOPTION1" value="#mdayoption1#" />
					<cfpdfformparam name="PAYOPTION1" value="#payoption1#" />
					<cfpdfformparam name="PAYOPTION2" value="#payoption2#" />
					<cfpdfformparam name="MDAYOPTION2" value="#mdayoption2#" />					
					<cfpdfformparam name="FIRSTPAYDATE" value="#dateformat( firstpaydate, "mm/dd/yyyy" )#" />
					<cfpdfformparam name="NAMEONACCOUNT" value="#clientfullname#" />
					<cfpdfformparam name="ADDRESS" value="#address#" />
					<cfpdfformparam name="CITY" value="#city#" />
					<cfpdfformparam name="STATE" value="#state#" />
					<cfpdfformparam name="ZIPCODE" value="#zipcode#" />
					<cfpdfformparam name="CHECKINGACCOUNT" value="#checkingaccount#" />
					<cfpdfformparam name="SAVINGSACCOUNT" value="#savingsaccount#" />
					<cfpdfformparam name="ROUTINGNUMBER" value="#routingnumber#" />
					<cfpdfformparam name="ACCOUNTNUMBER" value="#accountnumber#" />
					<cfpdfformparam name="AUTHORIZEDSIGNATURE" value="#clientfullname#" />
					<cfpdfformparam name="SIGNATUREDATE" value="#dateformat( esigninfo.esdatestamp, "mm/dd/yyyy" )#" />
					<cfpdfformparam name="AUTHKEYTOKEN2" value="#authkeytoken2#" />					
					<cfpdfformparam name="IPADDRESS2" value="#ipaddress#" />
				</cfpdfform>
			
			
			<!---
			
			
			<cfpdf action="read" name="pdfData" source="testPDF.pdf" />
			
			
			<cfdump var="#leaddetail#" label="lead">
			<cfdump var="#clientfees#" label="fees">
			<cfdump var="#esigninfo#" label="esign">
			--->