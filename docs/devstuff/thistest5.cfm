
	
	
	
	
	
				<!--- // define variables --->
				<cfparam name="message" default="">
				<cfparam name="dotnetpath" default="">
				<cfparam name="theKey" default="">
				<cfparam name="thisencryptedmsg" default="" />				
				<cfparam name="result" default="">
							
				
				<!--- // define vanco url and post variables --->
				<cfparam name="posturl" default="">
				<cfparam name="returnurl" default="">
				<cfparam name="nvpvar" default="">
				<cfparam name="getencryptedmessage" default="">
				<cfparam name="setencryptedresponse" default="">
				<cfparam name="sessionid" default="">			
	
				<!--- // set .net class library path and encryption key --->
				<!--- // the key will be dynamic for each company --->
				<cfset dotnetpath = expandpath( "apis/dotnet/vanco/cryption.dll" ) />			
				<cfset theKey = "5b!R-j0E12LF9m6s8qzgNtMvBk74KX3T" />
				
				<cfparam name="sessionid" default="">
				<cfset sessionid = "f5a49bdd4e7320caaad8694033e381635dba10a7" />
				<cfset posturl = "https://www.vancodev.com/cgi-bin/wsnvptest.vps?" />
				
				<!--- // this needs to be encrypted --->
				
					<!--- / define params --->
					
					<cfparam name="requesttype" default="">
					<cfparam name="requestid" default="">
					<cfparam name="clientid" default="">
					<cfparam name="urltoredirect" default="">
					<cfparam name="customerid" default=""> 
					<cfparam name="customerref" default=""> 
					<cfparam name="isdebitcardonly" default="">
					
					<!--- // set vars --->
					<cfset requesttype = "efttransparentredirect" />
					<cfset requestid = dateformat( now(), "mmddyy" ) & timeformat( now(), "mmss" ) & numberformat( randrange( 1,9999 ), "00000000" ) />
					<cfset clientid = "DS2329-BK" />
					<cfset customerid = 99871 />
					<cfset urltoredirect = "http://67.79.186.26/efiscalv3/vancoResponse.cfm" />
					<cfset isdebitcardonly = "no" />			
				
				<!--- // end encrypted values --->
				
				
				
					<cfset nvpvar = "requesttype=" & requesttype & "&requestid=" & requestid & "&clientid=" & clientid & "&urltoredirect=" & urltoredirect & "&customerid=" & customerid & "&isdebitcardonly=" & isdebitcardonly />
					
					<!--- // call our .net library class --->
					
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
							<cfset accounttype = "CC" />
							<cfset accountnumber = "4111123456789012" />
							<cfset expmonth = "12" />
							<cfset expyear = "19" />
							<cfset name = "Doe,John" />
							<cfset email = "someone@domain.com" />
							<cfset billingaddr1 = urlencodedformat( "1234 Main Street" ) />
							<cfset billingcity = "Orlando" />
							<cfset billingstate = "FL" />
							<cfset billingzip = "32808" />
							<cfset name_on_card = urlencodedformat( "John Doe" ) />
							
							
							<br /><br /><br />
							
							<!--- // send vanco transaction --->
							<cfhttp url="#posturl#sessionid=#sessionid#&accounttype=#accounttype#&accountnumber=#accountnumber#&expmonth=#expmonth#&expyear=#expyear#&name=#name#&email=#email#&billingaddr1=#billingaddr1#&billingcity=#billingcity#&billingstate=#billingstate#&billingzip=#billingzip#&name_on_card=#name_on_card#&nvpvar=#nvpvar#" 
								method="GET" 					
								throwonerror="yes"
								charset="utf-8"
								result="result">			
								
							</cfhttp>			
									
							
							
							
							
							
							
							
							
							