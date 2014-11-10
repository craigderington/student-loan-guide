



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
			
			<!--- // set our vaco client variables --->
			<cfset vancoiframeid = "DS2329-BK712" />
			<cfset vancoclientid = "DS2329-BK" />
			<cfset customerid = "99871" />
			<cfset customername = "Craig Derington" />
			<cfset customeraddress = "1234 Main Street" />
			<cfset customercity = "Orlando" />
			<cfset customerstate = "FL" />
			<cfset customerzip = "32808" />		
			<cfset returnurl = "http://67.79.186.26/efiscalv3/thistest4.cfm?vws=true" />
			
			<!-- url params --->			
			<cfparam name="nvpvar" default="" >
			<cfparam name="requesttype" default="" >
			<cfparam name="userid" default="" >
			<cfparam name="password" default="" />
			
			<!--- // set post url values --->
			<cfset posturl = "https://www.vancodev.com/cgi-bin/wsnvptest.vps?nvpvar=" />	
			<cfset requesttype = "login">
			<cfset userid = "DS2329-BK" />
			<cfset password = "v@nco2oo" />			
			<cfset thisrequestid = dateformat( now(), "mmddyy" ) & timeformat( now(), "mmss" ) & numberformat( randrange( 1,9999 ), "00000000" ) />
			
			
			
			
				<!--- // call vanco server for login and session id response --->
				<cfhttp url="#posturl#requesttype=#requesttype#&userid=#userid#&password=#password#&requestid=#thisrequestid#" 
					method="GET" 					
					throwonerror="yes"
					charset="utf-8"
					result="result">			
					
				</cfhttp>
	
	
				<br />

				<!--- // server response --->
				<cfset nvpvar = result.filecontent />
				<cfset nvpvarlen = len( nvpvar ) />				
				<cfset nvpvar2 = mid( nvpvar, 8, nvpvarlen ) />
				
				<br />
				
				<cfoutput>
					
					#nvpvar2#
				
					
					<br /><br /><br />
				
				
					#posturl#requesttype=#requesttype#&userid=#userid#&password=#password#&requestid=#thisrequestid#
				
				
				</cfoutput>
				
				<!--- // .net class library --->
				<cfobject
					type=".NET"				
					class="Cryption.CryptionUtils"
					assembly="#dotnetpath#"
					name="vanco">				
				
					<cfset vanco.init() />				
					<cfset message = nvpvar2 />
					<cfset setdecryptedmessage = vanco.DecryptAndDecodeMessage( message, theKey ) />
					<cfset thisencryptedmsg = replace( replace(  setdecryptedmessage, "+", "-", "all"), "/", "_", "all" )>
				
					<br />
					
					
					
					<br />
					
					<cfset newsessionid = listfirst( setdecryptedmessage, "&" ) />
					<cfset newrequestid = listlast( setdecryptedmessage, "&" ) />
					
					<br />
					
					<cfset newsessionid = listlast( newsessionid, "=" ) />
					<cfset newrequestid = listlast( newrequestid, "=" ) />
					
					<br />
				
					<!---
					<cfdump var="#vanco#" label="Vanco Cryption Utils">
					--->
				
				<!---
					
					<h3>Vanco Login Service</h3>
					
					<form name="thisform" action="#posturl#" method="get">
					
						<input type="button" name="pushthisbutton" value="Login">
						<input type="hidden" name="requesttype" value="login">						
						<input type="hidden" name="nvpvar" value="">
						<input type="hidden" name="userid" value="DS2329WS">
						<input type="hidden" name="password" value="v@nco2oo">
						<input type="hidden" name="requestid" value="ABC987TYRDS432NJ">
					
					</form>
				
				--->
				
				
					
				
				
				
				<!--- // remove for now --->
				
				<cfoutput>
				
					<div style="padding:50px;">
				
						<br /><br />
						<h4>Vanco Encryption Testing </h4>
						
						<p>String Input: #message# </p>
						
						<p>Key: #theKey#<p>
						
						<p>Output: #setdecryptedmessage#</p>			
				
						<p>#newsessionid# <br/>#newrequestid#</p>
				
				</cfoutput>		
						<!---
					
						<br /><br />
						
						<cfdump var="#vanco#" label="CryptionUtils: Methods and Properties">
					
						<br />
						
						
						<!--- // load the vanco web services iframe intergration --->
										
						<iframe id="#vancoiframeid#" seamless width="360" height="300" align="center" src="https://www.vancodev.com/cgi-bin/vancotest_ver3.vps?appver3=owQYbecXmO4hpXGzupWAdUh1eSX88q1BHSCftZwn1zOojaIITxf2k_u6ktwGL51sHmkP09_f-qHggHpYhdue-eHYwZh71bQ3xoCyFvDXsEmqwKqjhyRe8XhUeYHCPQew?&credentials=#thisencryptedmsg#&customername=John%20Doe&returnurl=#returnurl#" /></iframe>
					
					
					</div>
					
					
					
						--->
					
						<!--- // 

							<cfobject type=".NET" name="proc" class="System.Diagnostics.Process">  
							<cfset processes = proc.GetProcesses()> 
							<cfset arrLen = arrayLen(processes)> 
						 
							<table border=0 cellspacing="3" cellpadding="3"> 
								<tr bgcolor="#33CCCC"> 
									<td style="font-size:12px; font-weight:bold" nowrap>Process ID</td> 
									<td style="font-size:12px; font-weight:bold" nowrap>Name</td> 
									<td style="font-size:12px; font-weight:bold" nowrap>Memory (KB)</td> 
									<td style="font-size:12px; font-weight:bold" nowrap>Peak Memory (KB)</td> 
									<td style="font-size:12px; font-weight:bold" nowrap>Virtual Memory Size (KB)</td> 
									<td style="font-size:12px; font-weight:bold" nowrap>Start Time</td> 
									<td style="font-size:12px; font-weight:bold" nowrap>Total Processor Time</td> 
								</tr> 
								<cfloop from = 1 to="#arrLen#" index=i> 
									<cfset process = processes[i]> 
									<cfset id = process.Get_Id()> 
									<cfif id neq 0> 
										<cfoutput> 
										<tr> 
											<td align="right">#process.Get_Id()#</td> 
											<td>#process.Get_ProcessName()#</td> 
											<td align="right">#process.Get_PagedMemorySize()/1000#</td> 
											<td align="right">#process.Get_PeakPagedMemorySize()/1000#</td> 
											<td align="right">#process.Get_VirtualMemorySize()/1000#</td> 
											<td>#process.Get_StartTime()#</td> 
											<td>#process.Get_TotalProcessorTime()#</td> 
										</tr> 
										</cfoutput> 
									</cfif> 
								</cfloop> 
							</table>

						--->


