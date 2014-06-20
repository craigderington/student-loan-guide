


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
								l.leadachholddate, f.feeid, f.feeuuid, f.feeduedate, f.feepaiddate, f.feeamount, f.feepaid, 
								f.feestatus, f.feenote, f.feecollected, f.feeprogram, e.esignrouting, e.esignaccount, e.esignccnumber, 
								e.esignccexpdate, e.esignccv2, e.esignccname, e.esignpaytype, sl.slenrollreturndate, sl.slenrolldocsuploaddate, 
								f.feetransdate, f.feetrans, f.feereturnednsf, f.feepaytype, achbatchid
						  from  fees f, leads l, slsummary sl, esign e
						 where  f.leadid = l.leadid
						   and  l.leadid = sl.leadid
						   and  l.leadid = e.leadid
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
					</cfquery>
					<cfreturn achsummarydata>
				</cffunction>
				
				
				
				
			</cfcomponent>