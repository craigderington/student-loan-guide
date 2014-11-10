



			<!--- // define variables --->
			<cfparam name="message" default="">
			<cfparam name="dotnetpath" default="">
			<cfparam name="theKey" default="">
			<cfparam name="thisencryptedmsg" default="" />
			<cfparam name="vancoframeid" default="">
			<cfparam name="vancoclientid" default="">
			<cfparam name="customerid" default="">
			<cfparam name="result" default="">
			<cfparam name="thisrequestid" default="">
			
			
			<!--- // define vanco url and post variables --->
			<cfparam name="posturl" default="">
			<cfparam name="returnurl" default="">
			<cfparam name="nvpvar" default="">
			<cfparam name="getencryptedmessage" default="">
			<cfparam name="setencryptedresponse" default="">
			<cfparam name="vancosessionid" default="">					
			
			<!--- // set .net class library path and encryption key --->
			<!--- // the key will be dynamic for each company --->
			<cfset dotnetpath = expandpath( "apis/dotnet/vanco/cryption.dll" ) />			
			<cfset theKey = "5b!R-j0E12LF9m6s8qzgNtMvBk74KX3T" <!--- "TzzFkjHRaOI2tp0U1XhaAQ3hf3EYU18n"---> />			
			
			<!--- customer information --->
			<cfparam name="customername" default="">
			<cfparam name="customeraddress" default="">
			<cfparam name="customercity" default="">
			<cfparam name="customerstate" default="">
			<cfparam name="customerzip" default="">					
			
			<!--- // set our vanco client variables --->			
			<cfset customerid = "99871" />
			<cfset customername = "Craig Derington" />
			<cfset customeraddress = "1234 Main Street" />
			<cfset customercity = "Orlando" />
			<cfset customerstate = "FL" />
			<cfset customerzip = "32808" />		
			<cfset returnurl = "http://67.79.186.26/efiscalv3/thistest4.cfm?vwsLogin=true" />
			
			<!-- url params --->			
			<cfparam name="nvpvar" default="" >
			<cfparam name="requesttype" default="" >
			<cfparam name="userid" default="" >
			<cfparam name="password" default="" />
			
			<!--- // set post url values --->
			<cfset posturl = "https://www.vancodev.com/cgi-bin/wsnvptest.vps?nvpvar=" />	
			<cfset requesttype = "login">
			<cfset userid = "DS2329BK" />
			<cfset password = "v@nco2oo" />			
			<cfset thisrequestid = dateformat( now(), "mmddyy" ) & timeformat( now(), "mmss" ) & numberformat( randrange( 1,9999 ), "00000000" ) />
			
			
			<!--- // call vanco server for login and session id response --->
			<cfhttp url="#posturl#requesttype=#requesttype#&userid=#userid#&password=#password#&requestid=#thisrequestid#" 
					method="GET" 					
					throwonerror="yes"
					charset="utf-8"
					result="result">			
					
			</cfhttp>			

			<!--- // set server response --->
			<cfset nvpvar = result.filecontent />
			<cfset nvpvarlen = len( nvpvar ) />				
			<cfset nvpvar2 = mid( nvpvar, 8, nvpvarlen ) />
				
				
				
			<cfoutput>
					
					#nvpvar2#
				
					
					<br /><br /><br />
				
				
					Full Post String:<br />
					#posturl#requesttype=#requesttype#&userid=#userid#&password=#password#&requestid=#thisrequestid#
				
				
				</cfoutput>
				
				
				
				
				
				<!--- // decrypt // .net class library --->
				<cfobject
					type=".NET"				
					class="Cryption.CryptionUtils"
					assembly="#dotnetpath#"
					name="vanco">				
				
					<cfset vanco.init() />				
					<cfset message = nvpvar2 />
					<cfset setdecryptedmessage = vanco.DecryptAndDecodeMessage( message, theKey ) />
					<cfset thisencryptedmsg = replace( replace(  setdecryptedmessage, "+", "-", "all"), "/", "_", "all" )>				
					
					<cfset newsessionid = listfirst( setdecryptedmessage, "&" ) />
					<cfset newrequestid = listlast( setdecryptedmessage, "&" ) />				
					
					<cfset newsessionid = listlast( newsessionid, "=" ) />
					<cfset newrequestid = listlast( newrequestid, "=" ) />
				
				
				<cfoutput>
				
					<div style="padding:50px;">
				
						<br /><br />
						<h4>Vanco Login &amp; Encryption Testing </h4>
						
						<p>String Input: #message# </p>
						
						<p>Key: #theKey#<p>
						
						<p>Output: #setdecryptedmessage#</p>			
				
						<p>#newsessionid# <br/>#newrequestid#</p>
				
				</cfoutput>		
						