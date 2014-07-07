						
					
					
					
					
					
					<!--- for production, we only need to call the component and pass in the current date --->
							
					<cfinvoke component="apis.com.admin.companybankinggateway" method="markfeespaid" returnvariable="companyfees">
						<cfinvokeargument name="thisdate" value="#now()#">
					</cfinvoke>			
					
					
					
					
					
					
						
						
						
					<!--- // for testing only // see banking automation component for production services 
					
					<cfparam name="daystohold" default="2">
					<cfparam name="triggerdate" default="1/1/2014">
					<cfparam name="thisdate" default="">					
					
						
						
						<!--- // CDC company settings --->
						<cfquery datasource="#application.dsn#" name="companyach">
							select companyid, dba, achdaystohold, email
							  from company
							 where companyid = <cfqueryparam value="446" cfsqltype="cf_sql_integer" />
						</cfquery>
							
							
							
								<cfset daystohold = companyach.achdaystohold />
								<cfset thisdate = now() />
								<cfset triggerdate = dateadd( "d", 0, thisdate ) />
								
								
								
								<cfquery datasource="#application.dsn#" name="companyfees">
									select l.leadid, l.leaduuid, l.leadfirst, l.leadlast,
										   f.feeid, f.feeuuid, f.feetype, f.feeduedate, f.feepaiddate, f.feetrans,
										   f.feeamount, f.feepaid, f.feestatus, f.feepaytype, f.feetransdate, f.achbatchid
									  from leads l, fees f
									 where l.leadid = f.leadid
									   and l.companyid = <cfqueryparam value="#companyach.companyid#" cfsqltype="cf_sql_integer" />
									   and f.feetransdate < '7/10/2014'
									   and f.feetrans = <cfqueryparam value="Y" cfsqltype="cf_sql_char" />
									   and f.achbatchid is not null
									   and f.nsfreasonid = <cfqueryparam value="0" cfsqltype="cf_sql_integer" />
									   and f.feepaytype = <cfqueryparam value="ach" cfsqltype="cf_sql_varchar" />
									   and f.feestatus = <cfqueryparam value="pending" cfsqltype="cf_sql_varchar" />							   
								</cfquery>
								
								
									<!--- // if the companies have clients with fee payments ready to be marked paid, do it 
									<cfif companyfees.recordcount gt 0>
									
										<cfloop query="companyfees">
											
											<cfset thisdate = createodbcdatetime( now() ) />
												<cfquery datasource="#application.dsn#" name="markclientfeespaid">
													update fees
													   set feepaiddate = <cfqueryparam value="#thisdate#" cfsqltype="cf_sql_timestamp" />,
														   feepaid = <cfqueryparam value="#companyfees.feeamount#" cfsqltype="cf_sql_float" />,
														   feecollected = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />,
														   feestatus = <cfqueryparam value="PAID" cfsqltype="cf_sql_varchar" />
													 where feeid = <cfqueryparam value="#companyfees.feeid#" cfsqltype="cf_sql_integer" />
												</cfquery>
										
										</cfloop>								
									
									</cfif>
									--->
								<cfmail from="#companyach.email# (#companyach.dba#)" to="#companyach.email#"  bcc="craig@efiscal.net" subject="SLA Banking Automation - Notification of Payments Marked Paid" type="HTML"><h3>*** AUTOMATED SYSTEM MESSAGE *** UNATTENDED MAILBOX *** PLEASE DO NOT REPLY ***</h3>

									<cfoutput>								
<p style="margin-top:10px;">The Student Loan Advisor Online system banking automation has marked the following client ACH fee payments as paid with a transaction date before #dateformat( triggerdate, "mm/dd/yyyy" )#:</p>


	<ul>
	
		<cfloop query="companyfees">
			<li>#leadfirst# #leadlast# - #dollarformat( feeamount )# - Due Date: #dateformat( feeduedate, "mm/dd/yyyy" )# - Paid Date: #dateformat( thisdate, "mm/dd/yyyy" )#</li>
		</cfloop>
	
	</ul>	




<p style="margin-top:50px;">This message was auto-generated from the <a href="https://www.studentloanadvisoronline.com">Student Loan Advisor Online</a> website on #dateformat( now(), "mm/dd/yyyy" )# at #timeformat( now(), "hh:mm tt" )#. </p> 							
									</cfoutput>							


</cfmail>
							
							
							
							
							--->
						
							
							
							<cfdump var="#companyfees#" label="companyfees">
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
						