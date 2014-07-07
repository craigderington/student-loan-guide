


			<!--- -// admin dashboard --->
			<cfcomponent displayname="companybankinggateway">
		
				<cffunction name="init" access="public" output="false" returntype="companybankinggateway" hint="I create an initialized company banking gateway object.">
					<cfreturn this >
				</cffunction>
				
				
				<cffunction name="getachdata" access="public" output="false" returntype="query" hint="I get the client ach data.">
					<cfargument name="companyid" default="#session.companyid#" type="numeric" required="yes">
					<cfargument name="startdate" default="1/1/2014" type="date" required="yes">
					<cfargument name="enddate" default="12/31/2014" type="date" required="yes">
					<cfset var achdata = "" />
					<cfquery datasource="#application.dsn#" name="achdata">
						select 	l.leadid, l.leaduuid, l.leadfirst, l.leadlast, l.leadactive, l.leadachhold, l.leadachholdreason, 
								l.leadachholddate, f.feeid, f.feeuuid, f.feeduedate, f.feepaiddate, f.feeamount, f.feepaid, f.feetype, 
								f.feestatus, f.feenote, f.feecollected, f.feeprogram, e.esignrouting, e.esignaccount, e.esignccnumber, 
								e.esignccexpdate, e.esignccv2, e.esignccname, e.esignpaytype, sl.slenrollreturndate, sl.slenrolldocsuploaddate, 
								f.feetransdate, f.feetrans, f.feereturnednsf, f.feepaytype, f.achbatchid, f.nsfreasonid, n.nsfreasondescr
						  from  fees f, leads l, slsummary sl, esign e, nsfreasons n
						 where  f.leadid = l.leadid
						   and  l.leadid = sl.leadid
						   and  l.leadid = e.leadid
						   and  f.nsfreasonid = n.nsfreasonid
                           and  l.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
                           and  ( f.feeduedate between <cfqueryparam value="#arguments.startdate#" cfsqltype="cf_sql_date" /> and <cfqueryparam value="#arguments.enddate#" cfsqltype="cf_sql_date" /> )
						   and  sl.slenrollreturndate <> ''
						   and  sl.slenrolldocsuploaddate <> ''
								<cfif structkeyexists( form, "filtermyresults" )>								
									<cfif structkeyexists( form, "feetype" ) and form.feetype is not "--">
										and f.feeprogram = <cfqueryparam value="#trim( form.feetype )#" cfsqltype="cf_sql_char" />
									</cfif>
									<cfif structkeyexists( form, "paytype" ) and form.paytype is not "--">
										and f.feepaytype = <cfqueryparam value="#trim( form.paytype )#" cfsqltype="cf_sql_char" />
									</cfif>
									<cfif structkeyexists( form, "counselors" ) and form.counselors is not "--">
										and l.userid = <cfqueryparam value="#trim( form.counselors )#" cfsqltype="cf_sql_integer" />
									</cfif>
								</cfif>				   
						   
                      order by  f.feeduedate asc
					</cfquery>
					<cfreturn achdata>
				</cffunction>
				
				
				<cffunction name="getachsummarydata" access="public" output="false" returntype="query" hint="I get the client ach data.">
					<cfargument name="companyid" default="#session.companyid#" type="numeric" required="yes">
					<cfargument name="startdate" default="1/1/2014" type="date" required="yes">
					<cfargument name="enddate" default="12/31/2014" type="date" required="yes">
					<cfset var achsummarydata = "" />
					<cfquery datasource="#application.dsn#" name="achsummarydata">			
						select
							count(*) as totalfeecount,
							sum(feeamount) as totalfeesdue,
							sum(feepaid) as totalfeespaid,
							(select sum(feeamount) from fees f2, leads l2 where f2.leadid = l2.leadid and l2.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" /> and f2.feeduedate > <cfqueryparam value="#arguments.enddate#" cfsqltype="cf_sql_date" /> ) as totalprojectedfees,
							(select sum(feepaid) from fees f3, leads l3 where f3.leadid = l3.leadid and l3.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" /> and f3.feecollected = <cfqueryparam value="1" cfsqltype="cf_sql_bit" /> ) as totalfeescollected,
							(select sum(feepaid) from fees f4, leads l4 where f4.leadid = l4.leadid and l4.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" /> and f4.feecollected = <cfqueryparam value="0" cfsqltype="cf_sql_bit" /> ) as totaluncollectedfees,
							(select count(*) from fees f5, leads l5 where f5.leadid = l5.leadid and l5.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" /> and f5.feecollected = <cfqueryparam value="0" cfsqltype="cf_sql_bit" /> ) as totaluncollectedfeecount,
							(select sum(feeamount) from fees f6, leads l6 where f6.leadid = l6.leadid and l6.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" /> and f6.feestatus = <cfqueryparam value="pending" cfsqltype="cf_sql_varchar" /> ) as totalpendingpayments,
							(select count(*) from fees f7, leads l7 where f7.leadid = l7.leadid and l7.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" /> and f7.feestatus = <cfqueryparam value="pending" cfsqltype="cf_sql_varchar" /> ) as totalpendingpaycount
							from  fees f, leads l
							where  f.leadid = l.leadid
							and  l.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
							and  ( f.feeduedate between <cfqueryparam value="#arguments.startdate#" cfsqltype="cf_sql_date" /> and <cfqueryparam value="#arguments.enddate#" cfsqltype="cf_sql_date" /> )                
							<cfif structkeyexists( form, "filtermyresults" )>
								
								and l.userid = <cfqueryparam value="#form.counselors#" cfsqltype="cf_sql_integer" />
								
							</cfif>
					</cfquery>
					<cfreturn achsummarydata>
				</cffunction>
				
				<cffunction name="markfeespaid" access="public" output="false" hint="I mark each companies fees paid based on date and ach hold days.">
					<cfargument name="daystohold" type="numeric" required="no" default="3">
					<cfargument name="triggerdate" type="date" required="no" default="1/1/2014">
					<cfargument name="thisdate" type="date" required="no" default="1/1/2014">					
					<cfset var companyfees = "" />
						
						<!--- // get our list of active company ID's --->
						<cfquery datasource="#application.dsn#" name="companyach">
							select companyid, dba, achdaystohold, email
							  from company
							 where companyid = <cfqueryparam value="446" cfsqltype="cf_sql_integer" />
						</cfquery>
						
						
							<cfif companyach.recordcount gt 0>
						
								<cfloop query="companyach">
									<cfset arguments.thisdate = now() />
									<cfset arguments.daystohold = companyach.achdaystohold />
									<cfset arguments.triggerdate = dateadd( "d", -arguments.daystohold, thisdate ) />
									<cfquery datasource="#application.dsn#" name="companyfees">
										select l.leadid, l.leaduuid, l.leadfirst, l.leadlast,
											   f.feeid, f.feeuuid, f.feetype, f.feeduedate, f.feepaiddate, f.feetrans,
											   f.feeamount, f.feepaid, f.feestatus, f.feepaytype, f.feetransdate, f.achbatchid
										  from leads l, fees f
										 where l.leadid = f.leadid
										   and l.companyid = <cfqueryparam value="#companyach.companyid#" cfsqltype="cf_sql_integer" />
										   and f.feetransdate < <cfqueryparam value="7/12/2014" cfsqltype="cf_sql_date" />
										   and f.feetrans = <cfqueryparam value="Y" cfsqltype="cf_sql_char" />
										   and f.achbatchid is not null
										   and f.nsfreasonid = <cfqueryparam value="0" cfsqltype="cf_sql_integer" />
										   and f.feepaytype = <cfqueryparam value="ach" cfsqltype="cf_sql_varchar" />
										   and f.feestatus = <cfqueryparam value="pending" cfsqltype="cf_sql_varchar" />							   
									</cfquery>
									
									
									<!--- // if the company has clients with fee payments ready to be marked paid, do it --->
									<cfif companyfees.recordcount gt 0>
									
										<cfloop query="companyfees">
											
											<cfquery datasource="#application.dsn#" name="markclientfeespaid">
												update fees
												   set feepaiddate = <cfqueryparam value="#arguments.thisdate#" cfsqltype="cf_sql_timestamp" />,
													   feepaid = <cfqueryparam value="#companyfees.feeamount#" cfsqltype="cf_sql_float" />,
													   feecollected = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />,
													   feestatus = <cfqueryparam value="PAID" cfsqltype="cf_sql_varchar" />
											     where feeid = <cfqueryparam value="#companyfees.feeid#" cfsqltype="cf_sql_integer" />
											</cfquery>
										
										</cfloop>								
									
									
										<cfmail from="#companyach.email# (#companyach.dba#)" to="#companyach.email#"  bcc="craig@efiscal.net" subject="SLA Banking Automation - Notification of Payments Marked Paid" type="HTML"><h3>*** AUTOMATED SYSTEM MESSAGE *** PLEASE DO NOT REPLY ***</h3>

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
									
									
									</cfif><!--- // end the if on the company fees section --->
									
								
								
								</cfloop><!--- // close the company loop --->
							</cfif>
									
						<cfreturn companyfees>
					
				</cffunction>
				
				
				
				
			</cfcomponent>