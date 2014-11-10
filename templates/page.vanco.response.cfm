		
		
		
				
				
				
				<!--- // define and scope response variable --->
				<cfparam name="vancoresponse" default="">	
				<cfset nvpvar = url.nvpvar />
				
				<cfinvoke component="apis.dotnet.vanco.vanco-functions" method="getvancosettings" returnvariable="vancosettings">
					<cfinvokeargument name="companyid" value="#session.companyid#">
					<cfinvokeargument name="requesttype" value="efttransparentredirect">
				</cfinvoke>			

				<!--- // call the decryption component to decrypt the vanco response --->				
				<cfinvoke component="apis.dotnet.vanco.vanco-functions" method="vancodecrypt" returnvariable="thisdecryptedmessage">				
					<cfinvokeargument name="theKey" value="#vancosettings.webserviceapiencryptkey#" />
					<cfinvokeargument name="nvpvar" value="#nvpvar#">					
				</cfinvoke>
									
				<!--- // some variables we'll need for the next step --->			
				<cfset vancoresponse = thisdecryptedmessage />			
				<cfset thisarr = listtoarray( vancoresponse, "&", false, true ) />			
				<cfset thistransuuid = #createuuid()#  />
				<cfset thisleadid = session.leadid />
				<cfset today = now() />
				
				<!--- // since the decrypted variable is a simple string, we need to break apart the string 
				     // and place our key pair values into a simple array,  we can then loop over the array 
					 // inserting the key pair values and labels into the database for later usage, showing
					 // the payment method, client number assigned by vanco and the payment method reference
					 // number that must now accompany the next step in the transaction.
				--->	 
				
				<cfloop array="#thisarr#" index="j">
					<cfset item = listfirst( j, "=" ) />
					<cfset thisitemvalue = listlast( j, "=" ) /> 					
					<!--- // save the decrypted vanco data so we can use it in our application ---> 
					<cfquery datasource="#application.dsn#" name="savevancodecryptdata">
						insert into vancodecryptdata(vancouuid, leadid, vancolabel, vancovalue)
							values(
									<cfqueryparam value="#thistransuuid#" cfsqltype="cf_sql_varchar" maxlength="35" />,
									<cfqueryparam value="#thisleadid#" cfsqltype="cf_sql_integer" />,
									<cfqueryparam value="#item#" cfsqltype="cf_sql_varchar" />,
									<cfqueryparam value="#trim( thisitemvalue )#" cfsqltype="cf_sql_varchar" maxlength="250" />							
								   );
					</cfquery>		
					
					<!--- // for testing 
					<cfoutput>
						#item# :: #thisitemvalue# <br />	
					</cfoutput>
					--->
					
					
					
				</cfloop>
				
				<!--- // 
						 ****************************************************************
					     CLD 10-29-2014
						 now that we have looped over our response struct and added the 
						 decrypted data to the data table, we need to now insert the 
						 decrypted data to our vanco transaction log 
				         
						 first get our required vanco data for the selected client and 
						 the unique transaction id and create a data structure for insert 
						 into our vanco transaction log table
						 
						 ****************************************************************
				--->	
				
				<!--- // get the individual values and create a structure --->			
				<cfquery datasource="#application.dsn#" name="getvancodata">					
					select leadid as thisvancolead,							
							(select vancovalue from vancodecryptdata where vancolabel = <cfqueryparam value="errorlist" cfsqltype="cf_sql_varchar" /> and leadid = <cfqueryparam value="#thisleadid#" cfsqltype="cf_sql_integer" /> and vancouuid = <cfqueryparam value="#thistransuuid#" cfsqltype="cf_sql_varchar" maxlength="35" /> ) as thiserrorlist,
							(select vancovalue from vancodecryptdata where vancolabel = <cfqueryparam value="paymentmethodref" cfsqltype="cf_sql_varchar" /> and leadid = <cfqueryparam value="#thisleadid#" cfsqltype="cf_sql_integer" /> and vancouuid = <cfqueryparam value="#thistransuuid#" cfsqltype="cf_sql_varchar" maxlength="35" /> ) as thispaymethref,
							(select vancovalue from vancodecryptdata where vancolabel = <cfqueryparam value="customerref" cfsqltype="cf_sql_varchar" /> and leadid = <cfqueryparam value="#thisleadid#" cfsqltype="cf_sql_integer" /> and vancouuid = <cfqueryparam value="#thistransuuid#" cfsqltype="cf_sql_varchar" maxlength="35" /> ) as thiscustref,
							(select vancovalue from vancodecryptdata where vancolabel = <cfqueryparam value="requestid" cfsqltype="cf_sql_varchar" /> and leadid = <cfqueryparam value="#thisleadid#" cfsqltype="cf_sql_integer" /> and vancouuid = <cfqueryparam value="#thistransuuid#" cfsqltype="cf_sql_varchar" maxlength="35" /> ) as thisreqid,
							(select vancovalue from vancodecryptdata where vancolabel = <cfqueryparam value="sessionid" cfsqltype="cf_sql_varchar" /> and leadid = <cfqueryparam value="#thisleadid#" cfsqltype="cf_sql_integer" /> and vancouuid = <cfqueryparam value="#thistransuuid#" cfsqltype="cf_sql_varchar" maxlength="35" /> ) as thissessionid,
							(select vancovalue from vancodecryptdata where vancolabel = <cfqueryparam value="visamctype" cfsqltype="cf_sql_varchar" /> and leadid = <cfqueryparam value="#thisleadid#" cfsqltype="cf_sql_integer" /> and vancouuid = <cfqueryparam value="#thistransuuid#" cfsqltype="cf_sql_varchar" maxlength="35" /> ) as thisvisamctype,
							(select vancovalue from vancodecryptdata where vancolabel = <cfqueryparam value="cardtype" cfsqltype="cf_sql_varchar" /> and leadid = <cfqueryparam value="#thisleadid#" cfsqltype="cf_sql_integer" /> and vancouuid = <cfqueryparam value="#thistransuuid#" cfsqltype="cf_sql_varchar" maxlength="35" /> ) as thiscardtype,
							(select vancovalue from vancodecryptdata where vancolabel = <cfqueryparam value="name_on_card" cfsqltype="cf_sql_varchar" /> and leadid = <cfqueryparam value="#thisleadid#" cfsqltype="cf_sql_integer" /> and vancouuid = <cfqueryparam value="#thistransuuid#" cfsqltype="cf_sql_varchar" maxlength="35" /> ) as thisnameoncard,
							(select vancovalue from vancodecryptdata where vancolabel = <cfqueryparam value="expmonth" cfsqltype="cf_sql_varchar" /> and leadid = <cfqueryparam value="#thisleadid#" cfsqltype="cf_sql_integer" /> and vancouuid = <cfqueryparam value="#thistransuuid#" cfsqltype="cf_sql_varchar" maxlength="35" /> ) as thisexpmonth,
							(select vancovalue from vancodecryptdata where vancolabel = <cfqueryparam value="expyear" cfsqltype="cf_sql_varchar" /> and leadid = <cfqueryparam value="#thisleadid#" cfsqltype="cf_sql_integer" /> and vancouuid = <cfqueryparam value="#thistransuuid#" cfsqltype="cf_sql_varchar" maxlength="35" /> ) as thisexpyear,
							(select vancovalue from vancodecryptdata where vancolabel = <cfqueryparam value="billingaddr1" cfsqltype="cf_sql_varchar" /> and leadid = <cfqueryparam value="#thisleadid#" cfsqltype="cf_sql_integer" /> and vancouuid = <cfqueryparam value="#thistransuuid#" cfsqltype="cf_sql_varchar" maxlength="35" /> ) as thisbillingaddr1,
							(select vancovalue from vancodecryptdata where vancolabel = <cfqueryparam value="billingcity" cfsqltype="cf_sql_varchar" /> and leadid = <cfqueryparam value="#thisleadid#" cfsqltype="cf_sql_integer" /> and vancouuid = <cfqueryparam value="#thistransuuid#" cfsqltype="cf_sql_varchar" maxlength="35" /> ) as thisbillingcity,
							(select vancovalue from vancodecryptdata where vancolabel = <cfqueryparam value="billingstate" cfsqltype="cf_sql_varchar" /> and leadid = <cfqueryparam value="#thisleadid#" cfsqltype="cf_sql_integer" /> and vancouuid = <cfqueryparam value="#thistransuuid#" cfsqltype="cf_sql_varchar" maxlength="35" /> ) as thisbillingstate,
							(select vancovalue from vancodecryptdata where vancolabel = <cfqueryparam value="billingzip" cfsqltype="cf_sql_varchar" /> and leadid = <cfqueryparam value="#thisleadid#" cfsqltype="cf_sql_integer" /> and vancouuid = <cfqueryparam value="#thistransuuid#" cfsqltype="cf_sql_varchar" maxlength="35" /> ) as thisbillingzip,
							(select vancovalue from vancodecryptdata where vancolabel = <cfqueryparam value="last4" cfsqltype="cf_sql_varchar" /> and leadid = <cfqueryparam value="#thisleadid#" cfsqltype="cf_sql_integer" /> and vancouuid = <cfqueryparam value="#thistransuuid#" cfsqltype="cf_sql_varchar" maxlength="35" /> ) as thislast4,
							(select vancovalue from vancodecryptdata where vancolabel = <cfqueryparam value="requesttype" cfsqltype="cf_sql_varchar" /> and leadid = <cfqueryparam value="#thisleadid#" cfsqltype="cf_sql_integer" /> and vancouuid = <cfqueryparam value="#thistransuuid#" cfsqltype="cf_sql_varchar" maxlength="35" /> ) as thisreqtype,
							(select vancovalue from vancodecryptdata where vancolabel = <cfqueryparam value="accounttype" cfsqltype="cf_sql_varchar" /> and leadid = <cfqueryparam value="#thisleadid#" cfsqltype="cf_sql_integer" /> and vancouuid = <cfqueryparam value="#thistransuuid#" cfsqltype="cf_sql_varchar" maxlength="35" /> ) as thisaccttype,
							(select vancovalue from vancodecryptdata where vancolabel = <cfqueryparam value="ipaddress" cfsqltype="cf_sql_varchar" /> and leadid = <cfqueryparam value="#thisleadid#" cfsqltype="cf_sql_integer" /> and vancouuid = <cfqueryparam value="#thistransuuid#" cfsqltype="cf_sql_varchar" maxlength="35" /> ) as thisipaddress,
							(select vancovalue from vancodecryptdata where vancolabel = <cfqueryparam value="customerid" cfsqltype="cf_sql_varchar" /> and leadid = <cfqueryparam value="#thisleadid#" cfsqltype="cf_sql_integer" /> and vancouuid = <cfqueryparam value="#thistransuuid#" cfsqltype="cf_sql_varchar" maxlength="35" /> ) as thiscustomerid,
							(select vancovalue from vancodecryptdata where vancolabel = <cfqueryparam value="name" cfsqltype="cf_sql_varchar" /> and leadid = <cfqueryparam value="#thisleadid#" cfsqltype="cf_sql_integer" /> and vancouuid = <cfqueryparam value="#thistransuuid#" cfsqltype="cf_sql_varchar" maxlength="35" /> ) as thisname
					  from vancodecryptdata
					 where leadid = <cfqueryparam value="#thisleadid#" cfsqltype="cf_sql_integer" />
					   and vancouuid = <cfqueryparam value="#thistransuuid#" cfsqltype="cf_sql_varchar" maxlength="35" />
				  group by leadid				 
				</cfquery>
				
				<!--- // for testing dump decrypted vanco data variable 
				<cfdump var="#getvancodata#" label="vanco-data">
				--->
				
				
				
				<!--- // check for errors in the response struct --->
				<cfif trim( getvancodata.thiserrorlist ) eq "errorlist">
				
					<!--- // great, we have no errors, so let's go ahead and insert our response object data values --->
					<cfquery datasource="#application.dsn#" name="savevancotransaction">
						insert into vancotranslog(leadid, transdatetime, customerref, paymentmethodref, requestid, sessionid, visamctype, cardtype, name_on_card, expmonth, expyear, billingaddr1, billingcity, billingstate, billingzip, name, last4, reqtype, accttype, ipaddress, customerid)
							values(
								   <cfqueryparam value="#getvancodata.thisvancolead#" cfsqltype="cf_sql_integer" />,
								   <cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
								   <cfqueryparam value="#getvancodata.thiscustref#" cfsqltype="cf_sql_varchar" />,
								   <cfqueryparam value="#getvancodata.thispaymethref#" cfsqltype="cf_sql_varchar" />,
								   <cfqueryparam value="#getvancodata.thisreqid#" cfsqltype="cf_sql_varchar" />,
								   <cfqueryparam value="#getvancodata.thissessionid#" cfsqltype="cf_sql_varchar" />,
								   <cfqueryparam value="#getvancodata.thisvisamctype#" cfsqltype="cf_sql_varchar" />,
								   <cfqueryparam value="#getvancodata.thiscardtype#" cfsqltype="cf_sql_varchar" />,
								   <cfqueryparam value="#getvancodata.thisnameoncard#" cfsqltype="cf_sql_varchar" />,								  
								   <cfqueryparam value="#getvancodata.thisexpmonth#" cfsqltype="cf_sql_varchar" />,
								   <cfqueryparam value="#getvancodata.thisexpyear#" cfsqltype="cf_sql_varchar" />,								   
								   <cfqueryparam value="#getvancodata.thisbillingaddr1#" cfsqltype="cf_sql_varchar" />,
								   <cfqueryparam value="#getvancodata.thisbillingcity#" cfsqltype="cf_sql_varchar" />,
								   <cfqueryparam value="#getvancodata.thisbillingstate#" cfsqltype="cf_sql_varchar" />,
								   <cfqueryparam value="#getvancodata.thisbillingzip#" cfsqltype="cf_sql_varchar" />,
								   <cfqueryparam value="#getvancodata.thisname#" cfsqltype="cf_sql_varchar" />,
								   <cfqueryparam value="#trim( getvancodata.thislast4 )#" cfsqltype="cf_sql_varchar" maxlength="4" />,
								   <cfqueryparam value="#getvancodata.thisreqtype#" cfsqltype="cf_sql_varchar" />,
								   <cfqueryparam value="#getvancodata.thisaccttype#" cfsqltype="cf_sql_varchar" />,
								   <cfqueryparam value="#getvancodata.thisipaddress#" cfsqltype="cf_sql_varchar" />,
								   <cfqueryparam value="#getvancodata.thiscustomerid#" cfsqltype="cf_sql_integer" />
								  );
					</cfquery>		
					
					<!--- // log the activity --->
					<cfquery datasource="#application.dsn#" name="logact">
						insert into activity(leadid, userid, activitydate, activitytype, activity)
							values (
									<cfqueryparam value="#getvancodata.thisvancolead#" cfsqltype="cf_sql_integer" />,
									<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
									<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
									<cfqueryparam value="Record Modified" cfsqltype="cf_sql_varchar" />,
									<cfqueryparam value="#session.username# saved the Vanco client payment method for #getvancodata.thisnameoncard#" cfsqltype="cf_sql_varchar" />
									); select @@identity as newactid
					</cfquery>											

					<!--- // log the activity as recent --->
					<cfquery datasource="#application.dsn#">
						insert into recent(userid, leadid, activityid, recentdate)
							values (
									<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
									<cfqueryparam value="#getvancodata.thisvancolead#" cfsqltype="cf_sql_integer" />,
									<cfqueryparam value="#logact.newactid#" cfsqltype="cf_sql_integer" />,
									<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />
									);
					</cfquery>				
					
					<!--- // redirect to the vanco payment page --->				
					<cflocation url="#application.root#?event=page.vanco&reqtype=#getvancodata.thisreqtype#&status=ok" addtoken="no">
				
				<cfelse>
				
					<!--- // redirect to vanco page with error list --->
					<cflocation url="#application.root#?event=page.vanco&vws_error=#getvancodata.thiserrorlist#" addtoken="no">
				
				</cfif>
					
				
				
				
				
				
				
				
					
					
					
					
		
		
				
		
		
		
		
		
		
		
		
		
		
		
		