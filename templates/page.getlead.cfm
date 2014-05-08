


			<!--- capture lead or client id from url query string and start session, then redirect to the appropriate page --->
			
			<cfif structkeyexists(url, "fuseaction") and url.fuseaction is "leadgen">				
				
				<cfif structkeyexists(url, "leadid") and isvalid( "uuid", url.leadid )>
				
					<!--- // define some vars --->
					<cfparam name="leadid" default="">
					<cfparam name="today" default="">
					<cfset leadid = #url.leadid# />	
					<cfset today = #now()# />		
							
							
							<!--- // query the database to get the selected lead company --->
							<cfquery datasource="#application.dsn#" name="checklead">
								select companyid, userid
								  from leads
								 where leaduuid = <cfqueryparam value="#leadid#" cfsqltype="cf_sql_varchar" maxlength="35" /> 
							</cfquery>
							
							<!--- do a quick check to make sure the lead belongs to the correct company accessing the file --->
							<cfif session.companyid eq checklead.companyid>					
								
								<!--- // check the lead status --->
								<cfquery datasource="#application.dsn#" name="leadstat">
									select leadid, leaduuid, leadconv, leadimp
									  from leads
									 where leaduuid = <cfqueryparam value="#leadid#" cfsqltype="cf_sql_varchar" maxlength="35" />
								</cfquery>							
								
								<!--- // log the activity --->
								<cfquery datasource="#application.dsn#" name="logact">
									insert into activity(leadid, userid, activitydate, activitytype, activity)
										values (
												<cfqueryparam value="#leadstat.leadid#" cfsqltype="cf_sql_integer" />,
												<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
												<cfqueryparam value="#today#" cfsqltype="cf_sql_date" />,
												<cfqueryparam value="Record Selected" cfsqltype="cf_sql_varchar" />,
												<cfqueryparam value="#session.username# selected the client record for case review." cfsqltype="cf_sql_varchar" />
												); select @@identity as newactid
								</cfquery>
								
								<!--- // add to recent table --->					
								<cfquery datasource="#application.dsn#">
									insert into recent(userid, leadid, activityid, recentdate)
										values (
												<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />,
												<cfqueryparam value="#leadstat.leadid#" cfsqltype="cf_sql_integer" />,
												<cfqueryparam value="#logact.newactid#" cfsqltype="cf_sql_integer" />,
												<cfqueryparam value="#today#" cfsqltype="cf_sql_date" />
												);
								</cfquery>
								
								<!--- // if the lead assignment is accepted by the intake advisor, update the record --->
								<cfif structkeyexists( url, "acceptassignment" ) and url.acceptassignment is "1">
									<cfquery datasource="#application.dsn#" name="leadassign">
										select leadassignid, leadassignleadid, leadassignuserid
										  from leadassignments
										 where leadassignleadid = <cfqueryparam value="#leadstat.leadid#" cfsqltype="cf_sql_integer" />
										   and leadassignuserid = <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_interger" />
										   and ( leadassignrole = <cfqueryparam value="intake" cfsqltype="cf_sql_varchar" />
										    or leadassignrole = <cfqueryparam value="sls" cfsqltype="cf_sql_varchar" /> )
										   and leadassignacceptdate is null
										   and leadassignaccept = <cfqueryparam value="0" cfsqltype="cf_sql_integer" />
									</cfquery>
									
									<cfif leadassign.recordcount gt 0>
										<cfquery datasource="#application.dsn#" name="updateleadassign">
											update leadassignments
											   set leadassignaccept = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />,
											       leadassignacceptdate = <cfqueryparam value="#today#" cfsqltype="cf_sql_timestamp" />
											 where leadassignid = <cfqueryparam value="#leadassign.leadassignid#" cfsqltype="cf_sql_integer" />
										</cfquery>
									</cfif>
								</cfif>
								
								<!--- // start the client sessions --->
								<cfif leadstat.leadconv EQ 1>
									<cfset session.leadconv = 1 />
								</cfif>
								<cfif leadstat.leadimp eq 1>
									<cfset session.leadimp = 1 />
								</cfif>
								
								
								<!--- // define the default redirect --->
								<cfif structkeyexists( url, "ref" )>
									<cfset page.event = #url.ref# />
								<cfelse>
									<cfset page.event = "page.tasks" />
								</cfif>
							
								
								<cfset session.leadid = #leadstat.leadid# />
								
								<cfif structkeyexists( url, "thread" ) and isvalid( "uuid", url.thread )>
									<!--- // redirect to the conversation page --->	
									<cflocation url="#application.root#?event=page.conversation&fuseaction=thread&thread=#url.thread#" addtoken="yes">
								<cfelse>
									<!--- // redirect to the summary page --->						
									<cflocation url="#application.root#?event=#page.event#" addtoken="no">
								</cfif>
							
							<cfelse>
						
								<!--- // if the lead company and the user company do not match, redirect to error page --->
								<cflocation url="#application.root#?event=page.index&error=1" addtoken="no">
						
							</cfif>

						
					
				<cfelse>
					
					<!--- // throw error if the lead id is not numeric or an empty string --->
					<script>
						alert('Sorry, there was a problem starting the lead session.  The lead ID is malformed.  Please try again!');
						self-location="javascript:history.back(-1);"
					</script>
					
				</cfif>
			
			
			<cfelse>
				
				<!--- // if the fuseaction is not defined - redirect to index.cfm --->
				<cflocation url="#application.root#?event=page.index" addtoken="no">
			
			</cfif>