


		<cfcomponent displayname="reportgateway">
		
			<cffunction name="init" access="public" output="false" returntype="reportgateway" hint="I create an initialized report gateway object.">
				<cfreturn this >
			</cffunction>
			
			<cffunction name="getcounselorlist" access="public" output="false" returntype="query" hint="I get the list of counselors for the all of the filters.">
				<cfargument name="companyid" default="#session.companyid#" type="numeric" required="yes">				
				<cfset var counselorlist = "" />
				<cfquery datasource="#application.dsn#" name="counselorlist">
					select distinct(u.userid), u.role, u.firstname, u.lastname
					  from users u, leads l
					 where u.userid = l.userid
					   and u.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />					   
				  order by u.lastname asc
				</cfquery>
				<cfreturn counselorlist>
			</cffunction>

			<cffunction name="getreportroles" access="public" output="false" returntype="query" hint="I get the roles for the reports filter.">
				<cfargument name="companyid" default="#session.companyid#" type="numeric" required="yes">
				<cfargument name="roletype" default="sls" type="string" required="yes">
				<cfset var reportroles = "" />
				<cfquery datasource="#application.dsn#" name="reportroles">
					select u.userid, u.role, u.firstname, u.lastname
					  from users u
					 where u.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
					   and u.role LIKE <cfqueryparam value="%#arguments.roletype#%" cfsqltype="cf_sql_varchar" />
				  order by u.lastname asc
				</cfquery>
				<cfreturn reportroles>
			</cffunction>
			
			<cffunction name="getlastnote" access="public" output="false" returntype="query" hint="I get the date of the last note for the reports">
				<cfargument name="companyid" default="#session.companyid#" type="numeric" required="yes">
				<cfset var listlastnote = "" />
				<cfquery datasource="#application.dsn#" name="listlastnote">
					select l.leadid, l.leadlast, l.leadfirst,
						   (select max(n.notedate) from notes n where n.leadid = l.leadid) as lastnote
					  from leads l
					 where companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
				  order by lastnote desc
				</cfquery>
				<cfreturn listlastnote>
			</cffunction>	
			
			<cffunction name="getleadagereport" access="public" output="false" returntype="query" hint="I get the lead age report">
				<cfargument name="companyid" default="#session.companyid#" type="numeric" required="yes">
				<cfargument name="thisdate" default="#createodbcdatetime( now() )#" type="date" required="yes" />
				<cfset var leadagereport = "" />				
				<cfquery datasource="#application.dsn#" name="leadagereport">
					select l.leadid, l.leaduuid, l.leadfirst, l.leadlast, l.leaddate,
					       datediff( day, l.leaddate, <cfqueryparam value="#arguments.thisdate#" cfsqltype="cf_sql_date" /> ) as leadage
					  from leads l
					 where companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
					   and l.leadconv = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />
					   and l.leadactive = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
				  order by leadage desc
				</cfquery>
				<cfreturn leadagereport >
			</cffunction>		
			
			<cffunction name="getenrollreport" access="public" output="false" hint="I get the outstanding enrollment report">
				<cfargument name="companyid" type="numeric" required="yes" default="#session.companyid#">
				<cfargument name="userid" type="numeric" required="no" default="#session.userid#">
				<cfargument name="thisdate" type="date" required="yes" default="1/1/2014">
				<cfset var enrollreport = "" />
				<cfquery datasource="#application.dsn#" name="enrollreport">
					select l.*, ls.leadsource, s.slenrolldate, s.slenrollcontacttype, s.slenrollclientmethod, s.slenrollclientdocsmethod,
						   s.slenrollclientdocsdate, s.sloutcome, s.slenrollreturndate, u.firstname + ' ' + u.lastname as enrolladvisor,
						   datediff( day, l.leaddate, <cfqueryparam value="#arguments.thisdate#" cfsqltype="cf_sql_date" /> ) as leadage, 
						   c.companyname, c.dba,
						   (select max(notedate) from notes n where l.leadid = n.leadid) as lastnotedate,
						   (select top 1 notetext from notes n where l.leadid = n.leadid order by noteid desc) as lastnotetext
					  from leads l, leadsource ls, slsummary s, company c, users u
					 where l.leadsourceid = ls.leadsourceid
					   and l.leadid = s.leadid
					   and l.companyid = c.companyid
					   and l.userid = u.userid
					   and c.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
					   and l.leadconv = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />
					   and l.leadactive = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
					   and s.slenrollclientdocsdate is not null

							<cfif structkeyexists( form, "filtermyresults" )>
								
								<cfif structkeyexists( form, "leadsource" ) and form.leadsource is not "" and form.leadsource is not "Select Lead Source">					   
									and ls.leadsourceid = <cfqueryparam value="#form.leadsource#" cfsqltype="cf_sql_integer" />
								</cfif>
								
								<cfif structkeyexists( form, "counselors" ) and form.counselors is not "" and form.counselors is not "Select Counselor">					   
									and l.userid = <cfqueryparam value="#form.counselors#" cfsqltype="cf_sql_integer" />
								</cfif>
								
								<cfif structkeyexists( form, "startdate" ) and form.startdate is not "" and form.startdate is not "Select Start Date" and structkeyexists( form, "enddate" ) and form.enddate is not "" and form.enddate is not "Select End Date">
									and s.slenrolldate between <cfqueryparam value="#form.startdate#" cfsqltype="cf_sql_date" /> and <cfqueryparam value="#form.enddate#" cfsqltype="cf_sql_date" />
								</cfif>												   
							
							</cfif>
							
							<cfif isuserinrole( "counselor" )>
								and l.userid = <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />
							</cfif>
					   
				  order by l.leaddate asc
				</cfquery>
				<cfreturn enrollreport>
			</cffunction>	
			
			
			<cffunction name="getleadsourcereport" access="public" output="false" hint="I get the outstanding enrollment report">				
				<cfargument name="companyid" type="numeric" required="yes" default="#session.companyid#">
				<cfargument name="userid" type="numeric" required="no" default="#session.userid#">
				<cfargument name="thisdate" type="date" required="yes" default="1/1/2014">
				<cfset var leadsourcereport = "" />
				<cfquery datasource="#application.dsn#" name="leadsourcereport">
					select l.*, ls.leadsource, s.slenrolldate, s.slenrollcontacttype, s.slenrollclientmethod, s.slenrollclientdocsmethod,
						   s.slenrollclientdocsdate, s.sloutcome, s.slenrollreturndate,
						   datediff( day, l.leaddate, <cfqueryparam value="#arguments.thisdate#" cfsqltype="cf_sql_date" /> ) as leadage, 
						   c.companyname, c.dba,
						   (select max(notedate) from notes n where l.leadid = n.leadid) as lastnotedate,
						   (select top 1 notetext from notes n where l.leadid = n.leadid order by noteid desc) as lastnotetext
					  from leads l, leadsource ls, slsummary s, company c
					 where l.leadsourceid = ls.leadsourceid
					   and l.leadid = s.leadid
					   and l.companyid = c.companyid
					   and c.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
					   and l.leadconv = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />
					   and l.leadactive = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
					   
							
							<cfif structkeyexists( form, "filtermyresults" )>
								
								<cfif structkeyexists( form, "leadsource" ) and form.leadsource is not "" and form.leadsource is not "Select Lead Source">
									and ls.leadsourceid = <cfqueryparam value="#form.leadsource#" cfsqltype="cf_sql_integer" />
								</cfif>							
								
								<cfif structkeyexists( form, "counselors" ) and form.counselors is not "" and form.counselors is not "Select Counselor">					   
									and l.userid = <cfqueryparam value="#form.counselors#" cfsqltype="cf_sql_integer" />
								</cfif>
								
								<cfif structkeyexists( form, "startdate" ) and form.startdate is not "" and form.startdate is not "Select Start Date" and structkeyexists( form, "enddate" ) and form.enddate is not "" and form.enddate is not "Select End Date">
									and s.slenrolldate between <cfqueryparam value="#form.startdate#" cfsqltype="cf_sql_date" /> and <cfqueryparam value="#form.enddate#" cfsqltype="cf_sql_date" />
								</cfif>
								
												   
							
							</cfif>
							
							<cfif isuserinrole( "counselor" )>
								and l.userid = <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />
							</cfif>
					   
				  order by l.leaddate asc
				</cfquery>
				<cfreturn leadsourcereport>
			</cffunction>
			
			
			
			<cffunction name="getintakecompletedreport" access="public" output="false" hint="I get the intake completed report">				
				<cfargument name="companyid" type="numeric" required="yes" default="#session.companyid#">
				<cfargument name="userid" type="numeric" required="no" default="#session.userid#">
				<cfargument name="thisdate" type="date" required="yes" default="1/1/2014">
				<cfset var intakecompletedreport = "" />
				<cfquery datasource="#application.dsn#" name="intakecompletedreport">
					select l.*, ls.leadsource, s.slenrolldate, s.slenrollcontacttype, s.slenrollclientmethod, s.slenrollclientdocsmethod,
						   s.slenrollclientdocsdate, s.sloutcome, s.slenrollreturndate,
						   datediff( day, l.leaddate, <cfqueryparam value="#arguments.thisdate#" cfsqltype="cf_sql_date" /> ) as leadage, 
						   c.companyname, c.dba, u.firstname as intakefirstname, u.lastname as intakelastname,
						   (select max(notedate) from notes n where l.leadid = n.leadid) as lastnotedate,
						   (select top 1 notetext from notes n where l.leadid = n.leadid order by noteid desc) as lastnotetext,
						   (select sum(feeamount) from fees f where l.leadid = f.leadid ) as totalfees,
                           (select sum(feepaid) from fees f where l.leadid = f.leadid ) as totalfeespaid,
						   (select max(feepaiddate) from fees f where l.leadid = f.leadid ) as lastpaymentdate
					  from leads l, leadsource ls, slsummary s, company c, leadassignments la, users u
					 where l.leadsourceid = ls.leadsourceid
					   and l.leadid = s.leadid
					   and l.companyid = c.companyid
					   and l.leadid = la.leadassignleadid
					   and la.leadassignuserid = u.userid
					   and c.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
					   and l.leadconv = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
					   and l.leadactive = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
					   and l.leadintakecompdate is not null
					   and l.leadintakecompby is not null
					   and la.leadassignrole = <cfqueryparam value="intake" cfsqltype="cf_sql_varchar" />
							
							
							<cfif structkeyexists( form, "filtermyresults" )>
								
								<cfif structkeyexists( form, "leadsource" )>
									and ls.leadsourceid = <cfqueryparam value="#form.leadsource#" cfsqltype="cf_sql_integer" />
								</cfif>
								
								<cfif structkeyexists( form, "counselors" ) and form.counselors is not "" and form.counselors is not "Select Intake Advisor">					   
									and la.leadassignuserid = <cfqueryparam value="#form.counselors#" cfsqltype="cf_sql_integer" />
									and la.leadassignrole = <cfqueryparam value="intake" cfsqltype="cf_sql_varchar" />
								</cfif>
								
								<cfif structkeyexists( form, "startdate" ) and form.startdate is not "" and form.startdate is not "Select Start Date" and structkeyexists( form, "enddate" ) and form.enddate is not "" and form.enddate is not "Select End Date">
									and l.leadintakecompdate between <cfqueryparam value="#form.startdate#" cfsqltype="cf_sql_date" /> and <cfqueryparam value="#form.enddate#" cfsqltype="cf_sql_date" />
								</cfif>								
													   
							
							</cfif>
							
							
							
				  order by l.leaddate asc
				</cfquery>
				<cfreturn intakecompletedreport>
			</cffunction>



			<cffunction name="getenrolledreport" access="public" output="false" hint="I get the intake completed report">				
				<cfargument name="companyid" type="numeric" required="yes" default="#session.companyid#">
				<cfargument name="userid" type="numeric" required="no" default="#session.userid#">
				<cfargument name="thisdate" type="date" required="yes" default="1/1/2014">
				<cfset var enrolledreport = "" />
				<cfquery datasource="#application.dsn#" name="enrolledreport">
					select l.*, ls.leadsource, s.slenrolldate, s.slenrollcontacttype, s.slenrollclientmethod, s.slenrollclientdocsmethod,
						   s.slenrollclientdocsdate, s.sloutcome, s.slenrollreturndate,
						   datediff( day, l.leaddate, <cfqueryparam value="#arguments.thisdate#" cfsqltype="cf_sql_date" /> ) as leadage, 
						   c.companyname, c.dba,
						   (select max(notedate) from notes n where l.leadid = n.leadid) as lastnotedate,
						   (select top 1 notetext from notes n where l.leadid = n.leadid order by noteid desc) as lastnotetext,
						   (select sum(feeamount) from fees f where l.leadid = f.leadid ) as totalfees                          
					  from leads l, leadsource ls, slsummary s, company c
					 where l.leadsourceid = ls.leadsourceid
					   and l.leadid = s.leadid
					   and l.companyid = c.companyid					   
					   and c.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
					   and l.leadconv = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
					   and l.leadactive = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
							
							<cfif structkeyexists( form, "filtermyresults" )>
								
								<cfif structkeyexists( form, "leadsource" ) and form.leadsource is not "" and form.leadsource is not "Select Lead Source">
									and ls.leadsourceid = <cfqueryparam value="#form.leadsource#" cfsqltype="cf_sql_integer" />
								</cfif>
								
								<cfif structkeyexists( form, "counselors" ) and form.counselors is not "" and form.counselors is not "Select Counselor">					   
									and l.userid = <cfqueryparam value="#form.counselors#" cfsqltype="cf_sql_integer" />									
								</cfif>
								
								<cfif structkeyexists( form, "startdate" ) and form.startdate is not "" and form.startdate is not "Select Start Date" and structkeyexists( form, "enddate" ) and form.enddate is not "" and form.enddate is not "Select End Date">
									and l.leaddate between <cfqueryparam value="#form.startdate#" cfsqltype="cf_sql_date" /> and <cfqueryparam value="#form.enddate#" cfsqltype="cf_sql_date" />
								</cfif>											   
							
							</cfif>
							
				  order by l.leaddate asc
				</cfquery>
				<cfreturn enrolledreport>
			</cffunction>


			<cffunction name="getintakepipelinereport" access="public" output="false" hint="I get the intake pipeline report">				
				<cfargument name="companyid" type="numeric" required="yes" default="#session.companyid#">
				<cfargument name="userid" type="numeric" required="no" default="#session.userid#">
				<cfargument name="thisdate" type="date" required="yes" default="1/1/2014">
				<cfset var intakepipelinereport = "" />
				<cfquery datasource="#application.dsn#" name="intakepipelinereport">
					select l.*, ls.leadsource, s.slenrolldate, s.slenrollcontacttype, s.slenrollclientmethod, s.slenrollclientdocsmethod,
						   s.slenrollclientdocsdate, s.sloutcome, s.slenrollreturndate,
						   datediff( day, l.leaddate, <cfqueryparam value="#arguments.thisdate#" cfsqltype="cf_sql_date" /> ) as leadage, 
						   c.companyname, c.dba, u.firstname as intakefirstname, u.lastname as intakelastname,
						   (select max(notedate) from notes n where l.leadid = n.leadid) as lastnotedate,
						   (select top 1 notetext from notes n where l.leadid = n.leadid order by noteid desc) as lastnotetext,
						   (select sum(feeamount) from fees f where l.leadid = f.leadid ) as totalfees,
                           (select sum(feepaid) from fees f where l.leadid = f.leadid ) as totalfeespaid,
						   (select max(feepaiddate) from fees f where l.leadid = f.leadid ) as lastpaymentdate,
						   (select count(*) from tasks t, mtask mt where t.leadid = l.leadid and t.mtaskid = mt.mtaskid and mt.mtasktype = <cfqueryparam value="N" cfsqltype="cf_sql_char" /> and t.taskstatus = <cfqueryparam value="Completed" cfsqltype="cf_sql_varchar" /> ) as totalcompletedtasks,
						   (select count(*) from tasks t, mtask mt where t.leadid = l.leadid and t.mtaskid = mt.mtaskid and mt.mtasktype = <cfqueryparam value="N" cfsqltype="cf_sql_char" /> and t.taskstatus <> <cfqueryparam value="Completed" cfsqltype="cf_sql_varchar" /> ) as totalincompletetasks
					  from leads l, leadsource ls, slsummary s, company c, leadassignments la, users u
					 where l.leadsourceid = ls.leadsourceid
					   and l.leadid = s.leadid
					   and l.companyid = c.companyid
					   and l.leadid = la.leadassignleadid
					   and la.leadassignuserid = u.userid
					   and c.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
					   and l.leadconv = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
					   and l.leadactive = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
					   and la.leadassignrole = <cfqueryparam value="intake" cfsqltype="cf_sql_varchar" />
							
							
							<cfif structkeyexists( form, "filtermyresults" )>
								
								<cfif structkeyexists( form, "leadsource" ) and form.leadsource is not "" and form.leadsource is not "Select Lead Source">
									and ls.leadsourceid = <cfqueryparam value="#form.leadsource#" cfsqltype="cf_sql_integer" />
								</cfif>
								
								<cfif structkeyexists( form, "counselors" ) and form.counselors is not "" and form.counselors is not "Select Intake Advisor">					   
									and la.leadassignuserid = <cfqueryparam value="#form.counselors#" cfsqltype="cf_sql_integer" />									
								</cfif>
								
								<cfif structkeyexists( form, "startdate" ) and form.startdate is not "" and form.startdate is not "Select Start Date" and structkeyexists( form, "enddate" ) and form.enddate is not "" and form.enddate is not "Select End Date">
									and l.leaddate between <cfqueryparam value="#form.startdate#" cfsqltype="cf_sql_date" /> and <cfqueryparam value="#form.enddate#" cfsqltype="cf_sql_date" />
								</cfif>											   
							
							</cfif>
							
				  order by l.leaddate asc
				</cfquery>
				<cfreturn intakepipelinereport>
			</cffunction>
			
			
			<cffunction name="getadvisoracceptedreport" access="public" output="false" hint="I get the advisor accepted report">				
				<cfargument name="companyid" type="numeric" required="yes" default="#session.companyid#">
				<cfargument name="userid" type="numeric" required="no" default="#session.userid#">
				<cfargument name="thisdate" type="date" required="yes" default="1/1/2014">
				<cfset var advisoracceptedreport = "" />
				<cfquery datasource="#application.dsn#" name="intakepipelinereport">
					select l.*, ls.leadsource, s.slenrolldate, s.slenrollcontacttype, s.slenrollclientmethod, s.slenrollclientdocsmethod,
						   s.slenrollclientdocsdate, s.sloutcome, s.slenrollreturndate, u.firstname as sladvisorfirst, u.lastname as sladvisorlast,
						   datediff( day, l.leaddate, <cfqueryparam value="#thisdate#" cfsqltype="cf_sql_date" />) as leadage,
						   c.companyname, c.dba, la.leadassigndate, la.leadassignacceptdate, la.leadassignaccept,

						   (select max(notedate) from notes n where l.leadid = n.leadid) as lastnotedate,
						   (select top 1 notetext from notes n where l.leadid = n.leadid order by noteid desc) as lastnotetext,

						   (select
								top 1 u.firstname + ' ' + u.lastname
								from users u, leadassignments la, leads l2
								where la.leadassignuserid = u.userid
								and l2.leadid = l.leadid
								and la.leadassignleadid = l.leadid
								and la.leadassignrole = 'intake') as intakeadvisorname


					from leads l, leadsource ls, leadassignments la, slsummary s, company c, users u
				   where l.leadsourceid = ls.leadsourceid
			         and l.leadid = la.leadassignleadid
					 and la.leadassignuserid = u.userid
					 and l.leadid = s.leadid
					 and l.companyid = c.companyid
					 and c.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
					 and l.leadconv = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
					 and l.leadactive = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
					 and la.leadassignrole = <cfqueryparam value="sls" cfsqltype="cf_sql_varchar" />
						 
						 					
							
							<cfif structkeyexists( form, "filtermyresults" )>
								
								<cfif structkeyexists( form, "rgaccept" ) and form.rgaccept is not "">
									and la.leadassignaccept = <cfqueryparam value="#form.rgaccept#" cfsqltype="cf_sql_integer" />
								</cfif>
								
								<cfif structkeyexists( form, "counselors" ) and form.counselors is not "" and form.counselors is not "Select Advisor">					   
									and la.leadassignuserid = <cfqueryparam value="#form.counselors#" cfsqltype="cf_sql_integer" />									
								</cfif>
								
								<cfif structkeyexists( form, "startdate" ) and form.startdate is not "" and form.startdate is not "Select Start Date" and structkeyexists( form, "enddate" ) and form.enddate is not "" and form.enddate is not "Select End Date">
									and l.leadintakecompdate between <cfqueryparam value="#form.startdate#" cfsqltype="cf_sql_date" /> and <cfqueryparam value="#form.enddate#" cfsqltype="cf_sql_date" />
								</cfif>											   
							
							</cfif>
							
				  order by l.leaddate asc
				</cfquery>
				<cfreturn intakepipelinereport>
			</cffunction>
			
			
			<cffunction name="getesignreport" access="public" output="false" hint="I get the e-follow up report.">				
				<cfargument name="companyid" type="numeric" required="yes" default="#session.companyid#">
				<cfargument name="userid" type="numeric" required="no" default="#session.userid#">
				<cfargument name="thisdate" type="date" required="yes" default="1/1/2014">
				<cfset var esignreport = "" />
				<cfquery datasource="#application.dsn#" name="esignreport">
					select l.*, e.*, 
					       ls.leadsource, s.slenrolldate, s.slenrollcontacttype, s.slenrollclientmethod, s.slenrollclientdocsmethod,
						   s.slenrollclientdocsdate, s.sloutcome, s.slenrollreturndate, u.firstname as enrollcounselorfirst, u.lastname as enrollcounselorlast,
						   datediff( day, l.leaddate, getdate()) as leadage,						  
						   (select max(notedate) from notes n where l.leadid = n.leadid) as lastnotedate,
						   (select top 1 notetext from notes n where l.leadid = n.leadid order by noteid desc) as lastnotetext
					from leads l, leadsource ls, esign e, slsummary s, company c, users u
				   where l.leadsourceid = ls.leadsourceid			         
					 and l.leadid = s.leadid
					 and l.companyid = c.companyid
					 and l.leadid = e.leadid
					 and l.userid = u.userid
					 and c.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />					 
					 and l.leadactive = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />				 
					 and s.slenrollclientdocsmethod = <cfqueryparam value="ESIGN" cfsqltype="cf_sql_varchar" />	 					
							
							<cfif structkeyexists( form, "filtermyresults" )>
								
								<cfif structkeyexists( form, "rgstat" ) and form.rgstat is not "">
									and e.escompleted = <cfqueryparam value="#form.rgstat#" cfsqltype="cf_sql_bit" />
								</cfif>
								
								<cfif structkeyexists( form, "leadsource" ) and form.leadsource is not "" and form.leadsource is not "Select Lead Source">
									and ls.leadsourceid = <cfqueryparam value="#form.leadsource#" cfsqltype="cf_sql_integer" />
								</cfif>
								
								<cfif structkeyexists( form, "counselors" ) and form.counselors is not "" and form.counselors is not "Select Advisor">					   
									and u.userid = <cfqueryparam value="#form.counselors#" cfsqltype="cf_sql_integer" />									
								</cfif>
								
								<cfif structkeyexists( form, "startdate" ) and form.startdate is not "" and form.startdate is not "Select Start Date" and structkeyexists( form, "enddate" ) and form.enddate is not "" and form.enddate is not "Select End Date">
									and l.leaddate between <cfqueryparam value="#form.startdate#" cfsqltype="cf_sql_date" /> and <cfqueryparam value="#form.enddate#" cfsqltype="cf_sql_date" />
								</cfif>											   
							
							</cfif>
							
							<cfif isuserinrole( "counselor" )>
								and l.userid = <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />
							</cfif>
							
				  order by l.leaddate asc
				</cfquery>
				<cfreturn esignreport>
			</cffunction>
			
			
			<cffunction name="getsolutionreport" access="public" output="false" hint="I get the solution center report">				
				<cfargument name="companyid" type="numeric" required="yes" default="#session.companyid#">
				<cfargument name="userid" type="numeric" required="no" default="#session.userid#">
				<cfargument name="thisdate" type="date" required="yes" default="1/1/2014">
				<cfset var solutionreport = "" />
				<cfquery datasource="#application.dsn#" name="solutionreport">
					select l.*, ls.leadsource, s.slenrolldate, s.slenrollcontacttype, s.slenrollclientmethod, s.slenrollclientdocsmethod,
                           s.slenrollclientdocsdate, s.sloutcome, s.slenrollreturndate, datediff( day, l.leaddate, getdate() ) as leadage,
                           c.companyname, c.dba, u.firstname as sladvisorfirst, u.lastname as sladvisorlast, la.leadassigndate, la.leadassignacceptdate,
                           (select max(notedate) from notes n where l.leadid = n.leadid) as lastnotedate,
                           (select top 1 notetext from notes n where l.leadid = n.leadid order by noteid desc) as lastnotetext,
                           (select count(worksheetid) from slworksheet sl where l.leadid = sl.leadid ) as totaldebts,
                           (select count(solutionid) from solution sn where l.leadid = sn.leadid and sn.solutioncompleted = <cfqueryparam value="1" cfsqltype="cf_sql_bit" /> ) as totalsolutions
                      from leads l, leadsource ls, leadassignments la, slsummary s, company c, users u
                     where l.leadsourceid = ls.leadsourceid
                       and l.leadid = s.leadid
                       and l.companyid = c.companyid
					   and l.leadid = la.leadassignleadid
					   and u.userid = la.leadassignuserid
                       and c.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
                       and l.leadconv = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
                       and l.leadactive = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
                       and la.leadassignrole = <cfqueryparam value="sls" cfsqltype="cf_sql_varchar" />         
							
							<cfif structkeyexists( form, "filtermyresults" )>
								
								<cfif structkeyexists( form, "leadsource" ) and form.leadsource is not "" and form.leadsource is not "Select Lead Source">
									and ls.leadsourceid = <cfqueryparam value="#form.leadsource#" cfsqltype="cf_sql_integer" />
								</cfif>
								
								<cfif structkeyexists( form, "counselors" ) and form.counselors is not "" and form.counselors is not "Select Counselor">					   
									and la.leadassignuserid = <cfqueryparam value="#form.counselors#" cfsqltype="cf_sql_integer" />
									and la.leadassignrole = <cfqueryparam value="sls" cfsqltype="cf_sql_varchar" />
								</cfif>
								
								<cfif structkeyexists( form, "startdate" ) and form.startdate is not "" and form.startdate is not "Select Start Date" and structkeyexists( form, "enddate" ) and form.enddate is not "" and form.enddate is not "Select End Date">
									and l.leaddate between <cfqueryparam value="#form.startdate#" cfsqltype="cf_sql_date" /> and <cfqueryparam value="#form.enddate#" cfsqltype="cf_sql_date" />
								</cfif>											   
							
							</cfif>
							
				  order by l.leaddate asc
				</cfquery>
				<cfreturn solutionreport>
			</cffunction>
			
			
			
			<cffunction name="getsolutionstatusreport" access="public" output="false" hint="I get the solution status report">				
				<cfargument name="companyid" type="numeric" required="yes" default="#session.companyid#">
				<cfargument name="userid" type="numeric" required="no" default="#session.userid#">
				<cfargument name="thisdate" type="date" required="yes" default="1/1/2014">
				<cfargument name="sdate" type="date" required="yes" default="1/1/2014">
				<cfargument name="edate" type="date" required="yes" default="1/1/2014">
				<cfset var solutionstatusreport = "" />
				<cfquery datasource="#application.dsn#" name="solutionstatusreport">
					select l.leadid, l.leaduuid, l.leadfirst, l.leadlast, l.leadphonenumber, l.leademail, s.*, 
						   sl.servname as nslservicer, sv.servname, sl.servicerid, sl.attendingschool,
						   u.firstname as sladvisorfirst, u.lastname as sladvisorlast
                      from leads l, company c, slworksheet sl, servicers sv, solution s, leadassignments la, users u
                     where l.companyid = c.companyid
                       and l.leadid = sl.leadid
                       and s.leadid = l.leadid
                       and sl.worksheetid = s.solutionworksheetid
					   and sl.servicerid = sv.servid
					   and l.leadid = la.leadassignleadid
					   and la.leadassignuserid = u.userid
                       and c.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
                       and l.leadconv = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
                       and l.leadactive = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
                       and sl.active = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
					   and la.leadassignrole = <cfqueryparam value="sls" cfsqltype="cf_sql_varchar" />
							
							<cfif structkeyexists( form, "filtermyresults" )>
								
								<cfif structkeyexists( form, "status" ) and form.status is not "" and form.status is not "Select Status">
									and s.solutioncompleted = <cfqueryparam value="#form.status#" cfsqltype="cf_sql_bit" />
									and sl.completed = <cfqueryparam value="#form.status#" cfsqltype="cf_sql_bit" /> 
								</cfif>
								
								<cfif structkeyexists( form, "counselors" ) and form.counselors is not "" and form.counselors is not "Select Counselor">									
									and la.leadassignuserid = <cfqueryparam value="#form.counselors#" cfsqltype="cf_sql_integer" />									
								</cfif>
								
								<cfif structkeyexists( form, "startdate" ) and form.startdate is not "" and form.startdate is not "Select Start Date" and structkeyexists( form, "enddate" ) and form.enddate is not "" and form.enddate is not "Select End Date">
									and s.solutiondate between <cfqueryparam value="#form.startdate#" cfsqltype="cf_sql_date" /> and <cfqueryparam value="#form.enddate#" cfsqltype="cf_sql_date" />
								</cfif>											   
							<cfelse>
								and s.solutioncompleted = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
								and sl.completed = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
								and s.solutiondate between <cfqueryparam value="#arguments.sdate#" cfsqltype="cf_sql_date" /> and <cfqueryparam value="#arguments.edate#" cfsqltype="cf_sql_date" />
							</cfif>
							
				  order by s.solutiondate asc
				</cfquery>
				<cfreturn solutionstatusreport>
			</cffunction>
			
			
			
			
			
			<cffunction name="getimplementationreport" access="public" output="false" hint="I get the implementation status report">				
				<cfargument name="companyid" type="numeric" required="yes" default="#session.companyid#">
				<cfargument name="userid" type="numeric" required="no" default="#session.userid#">
				<cfargument name="thisdate" type="date" required="yes" default="1/1/2014">
				<cfargument name="sdate" type="date" required="yes" default="1/1/2014">
				<cfargument name="edate" type="date" required="yes" default="1/1/2014">
				<cfset var implementationreport = "" />
				<cfquery datasource="#application.dsn#" name="implementationreport">
					   select l.leadid, l.leaduuid, l.leadfirst + ' ' + l.leadlast as clientname, 
					          i.implementid, i.planuuid, i.servid, i.solutionid, i.solutionoption, 
							  i.solutionsubcat, i.impstartdate, i.impenddate, i.impcompleted, i.plannotes, 
							  s.servname
						 from leads l, implement i, servicers s
						where l.leadid = i.leadid
						  and i.servid = s.servid
						  and l.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />		
						  and i.impstartdate between <cfqueryparam value="#arguments.sdate#" cfsqltype="cf_sql_date" /> and <cfqueryparam value="#arguments.edate#" cfsqltype="cf_sql_date" />
							
						<cfif structkeyexists( form, "filtermyresults" )>						
								
							<cfif structkeyexists( form, "counselors" ) and form.counselors is not "" and form.counselors is not "Select Counselor">									
								and l.userid = <cfqueryparam value="#form.counselors#" cfsqltype="cf_sql_integer" />									
							</cfif>						

							<cfif structkeyexists( form, "showthis" ) and form.showthis is true>									
								and i.impcompleted <> <cfqueryparam value="1" cfsqltype="cf_sql_bit" />									
							</cfif>
							
						</cfif>
					
						order by clientname asc
				 
				</cfquery>
				<cfreturn implementationreport>
			</cffunction>
			
			
			
			
			
			
			<!---
			<cffunction name="getsummaryreport" access="public" output="false" hint="I get the summary report data">
				<cfargument name="companyid" type="numeric" required="yes" default="#session.companyid#">
				<cfargument name="sdate" type="date" required="no" default="1/1/2014">
				<cfargument name="edate" type="date" required="no" default="12/31/2014">
				
				
				<cfset summary1 = structnew() />
				
				
				<!--- // start with count on leads --->
				<cfquery datasource="#application.dsn#" name="leads">
					   select count(*) as totalleads
						 from leads l
						where l.leadid						  
						  and l.leaddate between <cfqueryparam value="#arguments.sdate#" cfsqltype="cf_sql_date" /> and <cfqueryparam value="#arguments.edate" cfsqltype="cf_sql_date" />
				</cfquery>
				
				
			
			</cffunction>
			--->
			
			
			<cffunction name="getleadassignmentsbyrole" access="public" output="false" hint="I get the list of all lead role assignments.">
				<cfargument name="leadid" default="#url.leadid#" type="uuid" required="yes">
				<cfargument name="role" default="#url.role#" type="string" required="yes">
				<cfset var leadassignmentsbyrole = "" />
				<cfquery datasource="#application.dsn#" name="leadassignmentsbyrole">
					select la.leadassignid, la.leadassigndate, la.leadassignleadid, la.leadassignuserid, la.leadassignrole, la.leadassignaccept,
					       la.leadassignacceptdate, la.leadassigntransfer, la.leadassigntransfertoid, u.firstname, u.lastname,
					       l.leaduuid, l.leadfirst, l.leadlast
				      from leadassignments la, leads l, users u
				     where la.leadassignleadid = l.leadid
                       and la.leadassignuserid = u.userid
				       and l.leaduuid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_varchar" maxlength="35" />
	                   and la.leadassignrole = <cfqueryparam value="#arguments.role#" cfsqltype="cf_sql_varchar" />
					   and la.leadassigntransfer = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />
				  order by la.leadassigndate desc 
				</cfquery>
				<cfreturn leadassignmentsbyrole >
			</cffunction>


			<cffunction name="gettransferadvisorlist" access="public" output="false" returntype="query" hint="I get the transfer list and roles for the admin function.">
				<cfargument name="companyid" default="#session.companyid#" type="numeric" required="yes">
				<cfargument name="roletype" default="sls" type="string" required="yes">
				<cfargument name="currentadvisorid" default="0" type="numeric" required="yes">
				<cfset var transferadvisorlist = "" />
				<cfquery datasource="#application.dsn#" name="transferadvisorlist">
					select u.userid, u.role, u.firstname, u.lastname
					  from users u
					 where u.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
					   and u.role LIKE <cfqueryparam value="%#arguments.roletype#%" cfsqltype="cf_sql_varchar" />
					   and u.userid <> <cfqueryparam value="#arguments.currentadvisorid#" cfsqltype="cf_sql_integer" />
				  order by u.lastname asc
				</cfquery>
				<cfreturn transferadvisorlist>
			</cffunction>
			
			
			
		
		</cfcomponent>
		