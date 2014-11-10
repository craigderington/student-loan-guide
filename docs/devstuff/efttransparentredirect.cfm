
	
	
	
	
	
				<!--- // get our data access components --->
				
				<cfinvoke component="apis.com.leads.leadgateway" method="getleaddetail" returnvariable="leaddetail">
					<cfinvokeargument name="leadid" value="#session.leadid#">
				</cfinvoke>

				<cfinvoke component="apis.com.clients.clientgateway" method="getclientfees" returnvariable="clientfees">
					<cfinvokeargument name="leadid" value="#session.leadid#">
				</cfinvoke>
					
				
				
				
				
				
				<cfinvoke component="apis.dotnet.vanco.vanco-functions" method="getvancosettings" returnvariable="vancosettings">
					<cfinvokeargument name="companyid" value="#session.companyid#">
					<cfinvokeargument name="requesttype" value="efttransparentredirect">
				</cfinvoke>			
							
				
				<!--- // define vanco url and post variables --->
				<cfparam name="posturl" default="">
				<cfparam name="returnurl" default="">
				<cfparam name="nvpvar" default="">
				<cfparam name="getencryptedmessage" default="">
				<cfparam name="setencryptedresponse" default="">
				<cfparam name="sessionid" default="">		
				
				
				<cfset sessionid = vancosettings.webservicesessionid />			
				<cfset posturl = "https://www.vancodev.com/cgi-bin/wsnvptest.vps?" />
				
					
					
					<!--- // begin encrypted variables //
					     //  these variables must be encrypted --->
				
					<!--- // define params --->					
					<cfparam name="requesttype" default="">
					<cfparam name="requestid" default="">
					<cfparam name="clientid" default="">
					<cfparam name="urltoredirect" default="">
					<cfparam name="customerid" default=""> 
					<cfparam name="customerref" default=""> 
					<cfparam name="isdebitcardonly" default="">
					
					<!--- // set variables --->
					<cfset requesttype = vancosettings.webservicerequesttype />
					<cfset requestid = dateformat( now(), "mmddyy" ) & timeformat( now(), "mmss" ) & numberformat( randrange( 1,9999 ), "00000000" ) />
					<cfset clientid = vancosettings.webserviceclientid />
					<cfset customerid = leaddetail.leadid />
					<cfset urltoredirect = "http://67.79.186.26/sladmin/page.vanco.response.cfm?vws=true" />
					<cfset isdebitcardonly = "no" />				
					
					<!--- // end encrypted values --->
				
				
					<!--- // create our client variable "envpvar" string to be encrypted --->
					<cfset nvpvar = "requesttype=" & requesttype & "&requestid=" & requestid & "&clientid=" & clientid & "&urltoredirect=" & urltoredirect & "&customerid=" & customerid & "&isdebitcardonly=" & isdebitcardonly />
					
					
					<!--- // call the encryption component to encrypt our vanco nvpvar data packet --->				
					<cfinvoke component="apis.dotnet.vanco.vanco-functions" method="vancoencrypt" returnvariable="thisencryptedmessage">
						<cfinvokeargument name="companyid" value="#session.companyid#">
						<cfinvokeargument name="theKey" value="#vancosettings.webserviceapiencryptkey#" />
						<cfinvokeargument name="nvpvar" value="#nvpvar#">					
					</cfinvoke>
					
					
					
					<!--- // call our .net library class 
					
					<cfobject
						type=".NET"				
						class="Cryption.CryptionUtils"
						assembly="#dotnetpath#"
						name="vanco">				
					
						<cfset vanco.init() />				
						<cfset message = nvpvar />
						<cfset getencryptedmessage = vanco.EncryptAndEncodeMessage( message, theKey ) />
						<cfset thisencryptedmessage = replace( replace(  getencryptedmessage, "+", "-", "all"), "/", "_", "all" )>
						
						
						<cfoutput>
							Encrypted Data Packet: #thisencryptedmessage#
						</cfoutput>
						--->
						
				
							<!-- // define additional variables --->
							
							<cfparam name="accounttype" default="">
							<cfparam name="accountnumber" default="">
							<cfparam name="expmonth" default="">
							<cfparam name="expyear" default="">
							<cfparam name="name" default="">
							<cfparam name="email" default="">
							<cfparam name="billingaddr1" default="">
							<cfparam name="billingcity" default="">
							<cfparam name="billingstate" default="">
							<cfparam name="billingzip" default="">
							<cfparam name="name_on_card" default="">
							
							<!--- // set our variables --->
							
							<cfset nvpvar = thisencryptedmessage />						
							<cfset accounttype = form.paymethod />
							<cfset accountnumber = form.accountnumber />
							<cfset expmonth = form.expmonth />
							<cfset expyear = form.expyear />
							<cfset name = trim( form.firstname ) & " " & trim( form.lastname ) />
							<cfset email = trim( leaddetail.leademail ) />
							<cfset billingaddr1 = urlencodedformat( "form.billingaddr1" ) />
							<cfset billingcity = trim( form.billingcity ) />
							<cfset billingstate = trim( form.billingstate ) />
							<cfset billingzip = trim( form.billingzip ) />
							<cfset name_on_card = urlencodedformat( "form.name_on_card" ) />
							
							
							
							
							<!--- // send vanco transaction --->
							<cfhttp url="#posturl#sessionid=#sessionid#&accounttype=#accounttype#&accountnumber=#accountnumber#&expmonth=#expmonth#&expyear=#expyear#&name=#name#&email=#email#&billingaddr1=#billingaddr1#&billingcity=#billingcity#&billingstate=#billingstate#&billingzip=#billingzip#&name_on_card=#name_on_card#&nvpvar=#nvpvar#" 
								method="GET" 					
								throwonerror="yes"
								charset="utf-8"
								result="result"
								redirect="yes">			
								
							</cfhttp>			
									
							<cfset vanco_r = result.filecontent />
							<cfset nvpvar = listlast( vanco_r, "=" ) />
							<cfset nvpvar = listfirst( nvpvar, '"' ) />
							
							<cflocation url="page.vanco.response.cfm?nvpvar=#nvpvar#" />
							
							<!---
							<cfdump var="#result#" label="Response">
							--->
							
							
							
							
							
							
							