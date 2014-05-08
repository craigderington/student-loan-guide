


			<cfcomponent displayname="activitylog">
	
				<cffunction name="init" access="public" output="false" returntype="activitylog" hint="Returns an initialized activity log object function.">		
					<!--- // return this reference. --->
					<cfreturn this />
				</cffunction>
				
				<cffunction name="getsystemactivity" access="public" output="false" hint="I get the system activity log.">
					<cfquery datasource="#application.dsn#" name="systemactivity">
						select a.activityid, a.userid, a.activitydate, a.activitytype, a.activity,
						       u.firstname, u.lastname
						  from activity a, users u
						 where a.userid = u.userid
						   and a.leadid = <cfqueryparam value="0" cfsqltype="cf_sql_integer" />
						 
						 
								<cfif structkeyexists( form, "filtermyresults" )>
								
									<cfif structkeyexists( form, "userid" ) and form.userid is not "" and form.userid neq 0>					   
										and u.userid = <cfqueryparam value="#form.userid#" cfsqltype="cf_sql_integer" />
									</cfif>
									
									<cfif structkeyexists( form, "acttype" ) and form.acttype is not "" and form.acttype is not "Filter By Activity Type">					   
										and a.activitytype = <cfqueryparam value="#trim( form.acttype )#" cfsqltype="cf_sql_varchar" />
									</cfif>
									
									<cfif structkeyexists( form, "username" ) and form.username is not "" and form.username is not "Filter By Name">					   
										
										<cfset thisusername = #trim( form.username )# />
										<cfset thisfirstname = #listfirst( thisusername, " " )# />
										<cfset thislastname = #listrest( thisusername, " " )# />						
										
										and u.firstname LIKE <cfqueryparam value="%#thisfirstname#%" cfsqltype="cf_sql_varchar" />
										and u.lastname LIKE <cfqueryparam value="%#thislastname#%" cfsqltype="cf_sql_varchar" />
									</cfif>
									
									<cfif structkeyexists( form, "startdate" ) and form.startdate is not "" and form.startdate is not "Select Start Date" and structkeyexists( form, "enddate" ) and form.enddate is not "" and form.enddate is not "Select End Date">
										and a.activitydate between <cfqueryparam value="#form.startdate#" cfsqltype="cf_sql_date" /> and <cfqueryparam value="#form.endddate#" cfsqltype="cf_sql_date" />
									</cfif>					   
							
								</cfif>	 
						 
					  order by a.activitydate desc
					</cfquery>
					<cfreturn systemactivity>
				</cffunction>
				
				<cffunction name="getactivitytypes" access="public" output="false" hint="I get the system activity types for the filter for the log.">
					<cfset var a1 = "" />
					<cfquery datasource="#application.dsn#" name="a1">
						select distinct(activitytype) as acttype
						  from activity
						 where leadid = <cfqueryparam value="0" cfsqltype="cf_sql_integer" />
					  order by activitytype asc
					</cfquery>
					<cfreturn a1>
				</cffunction>
				
				<cffunction name="getsystemusers" access="public" output="false" hint="I get all system users to search the system activity log.">
					<cfset var userlist = "" />
					<cfquery datasource="#application.dsn#" name="userlist">
						select u.userid, u.firstname, u.lastname, c.dba
						  from users u, company c
						 where u.companyid = c.companyid
						   and c.companyid <> <cfqueryparam value="445" cfsqltype="cf_sql_integer" />
					  order by u.lastname asc
					</cfquery>
					<cfreturn userlist>
				</cffunction>
				
				
				<cffunction name="getcompanyuseractivity" access="public" output="false" hint="I get the company specific activity log.">
					<cfargument name="companyid" type="numeric" required="yes" default="#session.companyid#">
					<cfquery datasource="#application.dsn#" name="companyuseractivity">
						select a.activityid, a.userid, a.activitydate, a.activitytype, a.activity,
						       l.leadfirst, l.leadlast, l.leadid, u.firstname, u.lastname
						  from activity a, leads l, users u
						 where a.leadid = l.leadid
						   and a.userid = u.userid
						   and l.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
						   
								
								<cfif structkeyexists( form, "filtermyresults" )>
									<cfif structkeyexists( form, "leadid" ) and form.leadid is not "" and form.leadid is not "filter by name">
										and a.leadid = <cfqueryparam value="#form.leadid#" cfsqltype="cf_sql_integer" />
									</cfif>
									
									<cfif structkeyexists( form, "thisuser" ) and form.thisuser is not "" and form.thisuser is not "filter by user">
										and a.userid = <cfqueryparam value="#form.thisuser#" cfsqltype="cf_sql_integer" />
									</cfif>
									
									<cfif structkeyexists( form, "filterstartdate" ) and structkeyexists( form, "filterenddate" )>
										<cfif form.filterstartdate is not "" and form.filterenddate is not "">
											and a.activitydate between <cfqueryparam value="#form.filterstartdate#" cfsqltype="cf_sql_date" /> and <cfqueryparam value="#form.filterenddate#" cfsqltype="cf_sql_date" />
										</cfif>
									</cfif>
								</cfif>
								
					  order by a.activitydate desc
					</cfquery>
					<cfreturn companyuseractivity>
				</cffunction>
				
			</cfcomponent>