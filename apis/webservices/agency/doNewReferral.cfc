<cfcomponent
	displayname="doNewReferral"
	extends="BaseAPI"
	output="false"
    hint="I am a web service with some remote access.">
 
    <cffunction	name="init">
        <cfreturn this>
    </cffunction>
	
	
	<cffunction
		name="processReferral"
		access="remote"
		returntype="struct"
		returnformat="json"
		output="false"
		hint="I add the new agency referral to the lead database.">
 
		<!--- define arguments for add new referral --->
		<cfargument
			name="apiKey"
			type="any"
			required="yes"
			hint="I am the API Key UUID of the agency."
			/>
 
		<cfargument
			name="agencyID"
			type="numeric"
			required="yes"
			hint="I am the agency ID for the new referral."
			/>
		
		<!---
		<cfargument
			name="userID"
			type="numeric"
			required="yes"
			hint="I am the default user ID system for the new referral."
			/>
		
		<cfargument
			name="referralsourceID"
			type="numeric"
			required="yes"
			hint="I am the referral source ID for the new referral."
			/>
		
		<cfargument
			name="referralstatusID"
			type="numeric"
			required="yes"
			hint="I am the referral status ID for the new referral."
			default="14"
			/>
		
		<cfargument
			name="referraldate"
			type="date"
			required="no"
			hint="I am the referral date."
			default="#now()#"
			/>
		
		<cfargument
			name="referralfirstname"
			type="string"
			required="yes"
			hint="I am the referral first name."
			/>
		
		<cfargument
			name="referrallastname"
			type="string"
			required="yes"
			hint="I am the referral last name."
			/>
		
		<cfargument
			name="referralemail"
			type="string"
			required="yes"
			hint="I am the referral email address."
			/>
		
		<cfargument
			name="referralphonetype"
			type="string"
			required="yes"
			hint="I am the referral phone type."
			default="Home"
			/>
		
		<cfargument
			name="referralphonenumber"
			type="string"
			required="yes"
			hint="I am the referral phone number."
			/>
		
		<cfargument
			name="referraladdress1"
			type="string"
			required="no"
			hint="I am the referral address 1."			
			/>
		
		<cfargument
			name="referraladdress2"
			type="string"
			required="no"
			hint="I am the referral address 2."			
			/>
		
		<cfargument
			name="referralcity"
			type="string"
			required="no"
			hint="I am the referral city."			
			/>
		
		<cfargument
			name="referralstate"
			type="string"
			required="no"
			hint="I am the referral state."			
			/>
		
		<cfargument
			name="referralzip"
			type="string"
			required="no"
			hint="I am the referral zip code."			
			/>
		
		<cfargument
			name="agencyuniqueID"
			type="string"
			required="no"
			hint="I am the referring agency unique client ID."			
			/>
			
		
 
		<!--- Define the local scope. --->
		<cfset var LOCAL = {} />
 
		<!--- Get a new API resposne. --->
		<cfset LOCAL.Response = THIS.GetNewResponse() />
 
 
		<!--- Check to see if all the data is defined. --->
		<cfif NOT Len( ARGUMENTS.apiKey )>
 
			<cfset ArrayAppend(
				LOCAL.Response.Errors,
				"Your HTTP POST structure must include your API Key.  Operation Aborted."
				) />
 
		</cfif>
 
		<cfif NOT Len( ARGUMENTS.agencyID )>
 
			<cfset ArrayAppend(
				LOCAL.Response.Errors,
				"Agency ID is required."
				) />
 
		</cfif>
		
		<cfif NOT Len( ARGUMENTS.userID )>
 
			<cfset ArrayAppend(
				LOCAL.Response.Errors,
				"Default User ID is required."
				) />
 
		</cfif>
		
		<cfif NOT Len( ARGUMENTS.referralsourceID )>
 
			<cfset ArrayAppend(
				LOCAL.Response.Errors,
				"Referral Source ID is required."
				) />
 
		</cfif>
		
		<cfif NOT Len( ARGUMENTS.referralstatusID )>
 
			<cfset ArrayAppend(
				LOCAL.Response.Errors,
				"Referral Status ID is required."
				) />
 
		</cfif>
		
		<cfif NOT Len( ARGUMENTS.referralfirstname )>
 
			<cfset ArrayAppend(
				LOCAL.Response.Errors,
				"Referral First Name is required."
				) />
 
		</cfif>
		
		<cfif NOT Len( ARGUMENTS.referrallastname )>
 
			<cfset ArrayAppend(
				LOCAL.Response.Errors,
				"Referral Last Name is required."
				) />
 
		</cfif>
		
		<cfif NOT Len( ARGUMENTS.referralemail )>
 
			<cfset ArrayAppend(
				LOCAL.Response.Errors,
				"Referral Email is required."
				) />
 
		</cfif>
		
		<cfif NOT Len( ARGUMENTS.referralphonetype )>
 
			<cfset ArrayAppend(
				LOCAL.Response.Errors,
				"Referral phone type is required."
				) />
 
		</cfif>
		
		<cfif NOT Len( ARGUMENTS.referralphonenumber )>
 
			<cfset ArrayAppend(
				LOCAL.Response.Errors,
				"Referral phone number is required."
				) />
 
		</cfif>
 
		--->
		
		<!---
			Check to see if their are any errors. If there are
			none, then we can process the API request.
		
		<cfif NOT ArrayLen( LOCAL.Response.Errors )>
		--->
			<cfquery datasource="#application.dsn#" name="checkAgencyKey">
				select companyid, regcode, useportal
				  from company
				 where regcode = <cfqueryparam value="#arguments.apiKey#" cfsqltype="cf_sql_varchar" maxlength="35" />
				   and companyid = <cfqueryparam value="#arguments.agencyID#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfset thisresponse = "" />
				<!---
				<cfif checkAgencyKey.recordcount EQ 1>
				
					<!--- // 11-20-2014 // call the add new lead function --->
					
					<!--- // manipulate some strings for proper case --->
					<cfset leadfirst = rereplace( arguments.referralfirstname , "\b(\S)(\S*)\b" , "\u\1\L\2" , "all" ) />
					<cfset leadlast = rereplace( arguments.referrallastname , "\b(\S)(\S*)\b" , "\u\1\L\2" , "all" ) />				
					<cfset today = now() />
					<!--- // first, let's check for duplicate data entries // do not allow duplicates --->
					<cfquery datasource="#application.dsn#" name="checkdupe">
						select l.leadid, l.leaduuid, l.leadlast, l.leadfirst
						  from leads l
						 where l.companyid = <cfqueryparam value="#arguments.agencyID#" cfsqltype="cf_sql_integer" />
						   and l.leadfirst = <cfqueryparam value="#leadfirst#" cfsqltype="cf_sql_varchar" />
					       and l.leadlast = <cfqueryparam value="#leadlast#" cfsqltype="cf_sql_varchar" />
					</cfquery>

					<!--- // if no duplicate entries are found, execute the insert statements --->
					<cfif checkdupe.recordcount eq 0>
					
						<cfif not structkeyexists( arguments, "referraladdress1" )>
							<cfset arguments.referraladdress1 = "" />
						</cfif>
						
						<cfif not structkeyexists( arguments, "referraladdress2" )>
							<cfset arguments.referraladdress2 = "" />
						</cfif>
						
						<cfif not structkeyexists( arguments, "referralcity" )>
							<cfset arguments.referralcity = "" />
						</cfif>
						
						<cfif not structkeyexists( arguments, "referralstate" )>
							<cfset arguments.referralstate = "" />
						</cfif>
						
						<cfif not structkeyexists( arguments, "referralzip" )>
							<cfset arguments.referralzip = "" />
						</cfif>
						
						<cfif not structkeyexists( arguments, "agencyuniqueid" )>
							<cfset arguments.agencyuniqueid = "" />
						</cfif>
					
					
													
						<cfquery datasource="#application.dsn#" name="createlead">
							insert into leads(leaduuid, companyid, userid, leadsourceid, leadstatusid, leaddate, leadfirst, leadlast, leademail, leadphonetype, leadphonenumber, leadactive, leadesign, agencyuniqueid, leadadd1, leadadd2, leadcity, leadstate, leadzip)
								values (
										<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar" maxlength="35" />,
										<cfqueryparam value="#arguments.agencyID#" cfsqltype="cf_sql_integer" />,
										<cfqueryparam value="#arguments.userID#" cfsqltype="cf_sql_integer" />,
										<cfqueryparam value="#arguments.referralsourceID#" cfsqltype="cf_sql_integer" />,
										<cfqueryparam value="#arguments.referralstatusID#" cfsqltype="cf_sql_integer" />,
										<cfqueryparam value="#arguments.referraldate#" cfsqltype="cf_sql_timestamp" />,
										<cfqueryparam value="#trim( leadfirst )#" cfsqltype="cf_sql_varchar" maxlength="50" />,
										<cfqueryparam value="#trim( leadlast )#" cfsqltype="cf_sql_varchar" maxlength="50" />,
										<cfqueryparam value="#trim( arguments.referralemail )#" cfsqltype="cf_sql_varchar" maxlength="80" />,
										<cfqueryparam value="#trim( arguments.referralphonetype )#" cfsqltype="cf_sql_varchar" maxlength="15" />,
										<cfqueryparam value="#trim( arguments.referralphonenumber )#" cfsqltype="cf_sql_varchar" maxlength="15" />,										
										<cfqueryparam value="1" cfsqltype="cf_sql_bit" />,
										<cfif checkAgencyKey.useportal eq 1> 
											<cfqueryparam value="0" cfsqltype="cf_sql_bit" />,
										<cfelse>
											<cfqueryparam value="1" cfsqltype="cf_sql_bit" />,
										</cfif>
										<cfqueryparam value="#trim( arguments.agencyuniqueid )#" cfsqltype="cf_sql_varchar" maxlength="20" />,
										<cfqueryparam value="#trim( arguments.referraladdress1 )#" cfsqltype="cf_sql_varchar" maxlength="50" />,
										<cfqueryparam value="#trim( arguments.referraladdress2 )#" cfsqltype="cf_sql_varchar" maxlength="50" />,
										<cfqueryparam value="#trim( arguments.referralcity )#" cfsqltype="cf_sql_varchar" maxlength="50" />,
										<cfqueryparam value="#trim( arguments.referralstate )#" cfsqltype="cf_sql_varchar" maxlength="2" />,
										<cfqueryparam value="#trim( arguments.referralzip )#" cfsqltype="cf_sql_varchar" maxlength="10" />
										); select @@identity as newleadid
						</cfquery>
													
						<!--- // create the lead summary --->
						<cfquery datasource="#application.dsn#" name="summary">
							insert into slsummary(leadid, slinquirydate, slreason, slbalance, slmonthly)
								values (
										<cfqueryparam value="#createlead.newleadid#" cfsqltype="cf_sql_integer" />,
										<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
										<cfqueryparam value="Student Loan Help" cfsqltype="cf_sql_varchar" />,
										<cfqueryparam value="0.00" cfsqltype="cf_sql_float" />,
										<cfqueryparam value="0.00" cfsqltype="cf_sql_float" />														
										); 
						</cfquery>

						<!--- // create the client budget --->
						<cfquery datasource="#application.dsn#" name="budget">
							insert into budget(budgetuuid, leadid, payfreq)
								values (
										<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar" maxlength="35" />,
										<cfqueryparam value="#createlead.newleadid#" cfsqltype="cf_sql_integer" />,															
										<cfqueryparam value="Bi-Weekly" cfsqltype="cf_sql_varchar" />																														
										); 
						</cfquery>
													
						<!--- // add client record to the esign table --->
						<cfquery datasource="#application.dsn#" name="esign1">
							insert into esign( esuuid, leadid, esdatestamp, escompleted )
								values(
										<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar" maxlength="35" />,
										<cfqueryparam value="#createlead.newleadid#" cfsqltype="cf_sql_integer" />,
										<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
										<cfif checkAgencyKey.useportal eq 1> 
											<cfqueryparam value="0" cfsqltype="cf_sql_bit" />
										<cfelse>
											<cfqueryparam value="1" cfsqltype="cf_sql_bit" />
										</cfif>
										);
						</cfquery>
													
						<!--- // create the lead master task list --->
						<cfloop query="mtasklist">
														
							<cfparam name="taskuuid" default="">												
							<cfparam name="taskstatus" default="">
							<cfparam name="taskduedate" default="">
							<cfparam name="nextdate" default="">
														
							<cfset taskuuid = #createuuid()# />
							<cfset taskstatus = "Assigned" />												
							<cfset nextdate = DateAdd( "d", 2, today ) />
														
								<cfquery datasource="#application.dsn#" name="mtasks">
									insert into tasks(taskuuid, mtaskid, leadid, userid, taskstatus, taskduedate, tasklastupdated, tasklastupdatedby)
										values (
												<cfqueryparam value="#taskuuid#" cfsqltype="cf_sql_varchar" />,
												<cfqueryparam value="#mtasklist.mtaskid#" cfsqltype="cf_sql_integer" />,
												<cfqueryparam value="#createlead.newleadid#" cfsqltype="cf_sql_integer" />,
												<cfqueryparam value="#arguments.userID#" cfsqltype="cf_sql_integer" />,
												<cfqueryparam value="#taskstatus#" cfsqltype="cf_sql_varchar" />,
												<cfqueryparam value="#nextdate#" cfsqltype="cf_sql_timestamp" />,
												<cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />,
												<cfqueryparam value="System Automation" cfsqltype="cf_sql_varchar" />														
									            );
								</cfquery>
														
						</cfloop>									
													
						<!--- // log the activity --->
						<cfquery datasource="#application.dsn#" name="logact">
							insert into activity(leadid, userid, activitydate, activitytype, activity)
								values (
										<cfqueryparam value="#createlead.newleadid#" cfsqltype="cf_sql_integer" />,
										<cfqueryparam value="#arguments.userID#" cfsqltype="cf_sql_integer" />,
										<cfqueryparam value="#today#" cfsqltype="cf_sql_date" />,
										<cfqueryparam value="Record Added" cfsqltype="cf_sql_varchar" />,
										<cfqueryparam value="New referral added via web services." cfsqltype="cf_sql_varchar" />
										);
						</cfquery>			
	 
						<!--- set the local response --->
						<cfset LOCAL.Response = "Success!  Record Added..." />					
					
					<cfelse>
					
						<cfset LOCAL.Response = "Duplicate Client Record Found.  Operation Aborted!" />
					
					</cfif>
				
				<cfelse>
				
					<cfset LOCAL.Response = "Agency Not Found.  Operation Aborted!" />
				
				</cfif>
				--->
				<!--- set the local response --->
				<cfset thisResponse = "Success!  Record Added..." />
		
 
 
		<!--- Check to see if we have any errors. 
		
		
		</cfif>
		<cfif ArrayLen( LOCAL.Response.Errors )>
 
			<!---
				At this point, if we have errors, we have to flag
				the request as not successful.
			--->
			<cfset LOCAL.Response.Success = false />
 
		</cfif>
		--->
		<!--- Return the response. --->
		<cfreturn thisResponse />
	</cffunction>
	
	
</cfcomponent>