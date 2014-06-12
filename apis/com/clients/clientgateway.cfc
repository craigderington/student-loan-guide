

	<cfcomponent displayname="clientgateway">
	
		<cffunction name="init" access="public" output="false" returntype="clientgateway" hint="Returns an initialized client gateway function.">		
			<!--- // return This reference. --->
			<cfreturn this />
		</cffunction>
	
		<cffunction name="getclientlist" access="remote" output="false" returntype="query" hint="I get the list of clients from the database.">		
			<cfargument name="companyid" default="#session.companyid#" type="numeric">
			<cfargument name="userid" type="numeric" required="no" default="#session.userid#">
			<cfset var clientlist = "">
			<cfquery datasource="#application.dsn#" name="clientlist">
				select distinct(l.leadid), l.leaduuid, l.leadsourceid, l.leaddate, l.leadfirst, l.leadlast, ls.leadsource, 
				       l.leadphonetype, l.leadphonenumber, l.leademail, sl.slenrollreturndate, 
					   sls.firstname, sls.lastname, l.leadactive
				  from leads l, leadsource ls, slsummary sl, users sls <cfif isuserinrole( "intake" ) or isuserinrole( "sls" )>, leadassignments la </cfif>
				 where l.leadsourceid = ls.leadsourceid
				   and l.leadid = sl.leadid
				   and l.userid = sls.userid
				   and l.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
				   and l.leadconv = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
				   and l.leadactive = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
				   <cfif isuserinrole( "intake" ) or isuserinrole( "sls" )> 
				   and l.leadid = la.leadassignleadid
				   and (la.leadassignuserid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" /> and ( la.leadassignrole = 'intake' or la.leadassignrole = 'sls'))
				   <cfelseif isuserinrole( "counselor" )>
				   and l.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
				   </cfif>
			  order by leaddate desc 
			</cfquery>			
			<cfreturn clientlist >	
		</cffunction>

		
		<cffunction name="getmclientlist" access="remote" output="false" returntype="query" hint="I get the new master list of clients from the database.">		
			<cfargument name="companyid" required="yes" default="#session.companyid#" type="numeric">
			<cfargument name="userid" type="numeric" required="yes" default="#session.userid#">
			<cfargument name="thisdate" type="date" required="yes" default="1/1/2014">
			<cfset var mclientlist = "">
			<cfquery datasource="#application.dsn#" name="mclientlist">				
				select l.*, ls.leadsource, sl.slenrolldate, sl.slenrollcontacttype, sl.slenrollclientmethod, sl.slenrollclientdocsmethod,
						   sl.slenrollclientdocsdate, sl.sloutcome, sl.slenrollreturndate, sls.firstname, sls.lastname,
						   datediff( day, l.leaddate, <cfqueryparam value="#arguments.thisdate#" cfsqltype="cf_sql_date" /> ) as leadage, 
						   c.companyname, c.dba,
						   (select max(notedate) from notes n where l.leadid = n.leadid) as lastnotedate,
						   (select top 1 notetext from notes n where l.leadid = n.leadid order by noteid desc) as lastnotetext,
						   (select sum(feeamount) from fees f where l.leadid = f.leadid ) as totalfees                          
					  from leads l, leadsource ls, slsummary sl, company c, users sls <cfif isuserinrole( "intake" ) or isuserinrole( "sls" )>, leadassignments la </cfif>
					 where l.leadsourceid = ls.leadsourceid
					   and l.leadid = sl.leadid
					   and l.companyid = c.companyid
					   and l.userid = sls.userid
					   and c.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
					   and l.leadconv = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
					   and l.leadactive = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
							
							
							<cfif isuserinrole( "sls" )> 
							   and l.leadid = la.leadassignleadid
							   and ( la.leadassignuserid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" /> and la.leadassignrole = <cfqueryparam value="sls" cfsqltype="cf_sql_char" /> )
							<cfelseif isuserinrole( "intake" )> 
							   and l.leadid = la.leadassignleadid
							   and ( la.leadassignuserid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" /> and la.leadassignrole = <cfqueryparam value="intake" cfsqltype="cf_sql_char" /> )							
							<cfelseif isuserinrole( "counselor" )>
							   and l.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
							</cfif>
							
							
							<cfif structkeyexists( form, "filtermyresults" )>
								
								<cfif structkeyexists( form, "leadsource" ) and form.leadsource is not "" and form.leadsource is not "Select Lead Source">
									and ls.leadsourceid = <cfqueryparam value="#form.leadsource#" cfsqltype="cf_sql_integer" />
								</cfif>
								
								<cfif structkeyexists( form, "filterbyname" ) and form.filterbyname is not "" and form.filterbyname is not "Filter By Name">					   
									and l.leadfirst + l.leadlast LIKE <cfqueryparam value="%#form.filterbyname#%" cfsqltype="cf_sql_varchar" />
								</cfif>
								
								<cfif structkeyexists( form, "counselors" ) and form.counselors is not "" and form.counselors is not "Select Counselor">					   
									and l.userid = <cfqueryparam value="#form.counselors#" cfsqltype="cf_sql_integer" />									
								</cfif>
								
								<cfif structkeyexists( form, "startdate" ) and form.startdate is not "" and form.startdate is not "Select Start Date" and structkeyexists( form, "enddate" ) and form.enddate is not "" and form.enddate is not "Select End Date">
									and l.leaddate between <cfqueryparam value="#form.startdate#" cfsqltype="cf_sql_date" /> and <cfqueryparam value="#form.enddate#" cfsqltype="cf_sql_date" />
								</cfif>					   
							
							</cfif>				   
					   
			    order by l.leadlast desc 
			</cfquery>			
			<cfreturn mclientlist >	
		</cffunction>
			
		
		<cffunction name="getclientsearch" output="false" access="remote" hint="I get the client search results.">			
			<cfargument name="search" required="yes" default="#form.search#">
			<cfargument name="userid" required="yes" default="#session.userid#">
			<cfargument name="companyid" required="yes" default="#session.companyid#">
			
			<cfset var clientsearch = "" />
			<cfset arguments.search = listfirst( arguments.search, " " ) />
				
				<!--- // query our datasource for the results --->				
				<cfquery datasource="#application.dsn#" name="clientsearch">
					select l.leadid, l.leaduuid, ls.leadsource, l.leaddate, l.leadfirst, l.leadlast, l.leademail,
					       l.leadphonenumber, l.leadphonetype, leadactive
					  from leads l, leadsource ls
					 where l.leadsourceid = ls.leadsourceid
					   				   
							<cfif isnumeric( arguments.search )>					   
						
								and	l.leadid = <cfqueryparam value="#arguments.search#" cfsqltype="cf_sql_integer" />
					        
							<cfelse>
						
								and	l.leadfirst + l.leadlast like <cfqueryparam value="%#arguments.search#%" cfsqltype="cf_sql_varchar" />
							
							</cfif>
							
								and l.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
					        
							<!---
							<cfif not isuserinrole("co-admin") and not isuserinrole("admin")>
					    
								and l.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
					        
							</cfif>
							--->
					   
					   and l.leadconv = <cfqueryparam value="1" cfsqltype="cf_sql_integer" />
				  order by l.leadlast asc 
				</cfquery>				
				<cfreturn clientsearch>			
		</cffunction>
		
		
		
		<cffunction name="getclientfees" output="false" access="remote" hint="I get the client fee schedule.">			
			<cfargument name="leadid" required="yes" default="#session.leadid#">						
			<cfset var clientfees = "" />			
				<!--- // query our datasource for the results --->				
				<cfquery datasource="#application.dsn#" name="clientfees">
					select l.leadid, l.leaduuid, l.leadfirst, l.leadlast, f.feeid, f.feeuuid, f.feetype, 
					       f.createddate, f.feeduedate, f.feepaiddate, f.feeamount, f.feepaid, f.feestatus, 
						   f.userid, f.feenote, f.feecollected, u.firstname, u.lastname
					  from leads l, fees f, users u
					 where l.leadid = f.leadid
					   and f.userid = u.userid
					   and l.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
				  order by f.feeduedate asc 
				</cfquery>				
				<cfreturn clientfees>			
		</cffunction>
		
		<cffunction name="getclientfeetotals" output="false" access="remote" hint="I get the client fee totals.">			
			<cfargument name="leadid" required="yes" default="#session.leadid#">						
			<cfset var clientfeetotals = "" />			
				<!--- // query our datasource for the results --->				
				<cfquery datasource="#application.dsn#" name="clientfeetotals">
					select sum(feeamount) as totalfees, count(feeid) as numpayments 
					  from leads l, fees f, users u
					 where l.leadid = f.leadid
					   and f.userid = u.userid
					   and l.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />				  
				</cfquery>				
				<cfreturn clientfeetotals>			
		</cffunction>

		<cffunction name="getfeedetail" output="false" access="remote" hint="I get the specific client fee record for an edit opeation.">			
			<cfargument name="feeid" required="yes" type="uuid" default="#url.feeid#">						
			<cfset var feedetail = "" />			
				<!--- // query our datasource for the results --->				
				<cfquery datasource="#application.dsn#" name="feedetail">
					select f.feeid, f.feeuuid, f.feetype, f.createddate, f.feeduedate, f.feepaiddate, 
					       f.feeamount, f.feepaid, f.feestatus, f.feecollected
					  from fees f
					 where feeuuid = <cfqueryparam value="#arguments.feeid#" cfsqltype="cf_sql_varchar" maxlength="35" />				   
				</cfquery>				
				<cfreturn feedetail>			
		</cffunction>
		
		<cffunction name="getclientsurvey" output="false" access="remote" hint="I get the client questionnaire answers.">			
			<cfargument name="leadid" required="yes" default="#session.leadid#" type="numeric">			
			<cfargument name="step" required="no" type="numeric">			
			<cfset var clientsurvey = "" />			
				<!--- // query our datasource for the results --->				
				<cfquery datasource="#application.dsn#" name="clientsurvey">
					select sla.slqaid, sla.leadid, sla.slqid, slq.slqtext, sla.slqa
					  from slanswer sla, slquestionnaire slq
					 where sla.slqid = slq.slqid					   
					   and sla.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   <cfif isdefined("arguments.step") and arguments.step neq 0>
					   and sla.slqid = <cfqueryparam value="#arguments.step#" cfsqltype="cf_sql_numeric" />
					   </cfif>
				  order by sla.slqid asc 
				</cfquery>				
				<cfreturn clientsurvey>			
		</cffunction>		
		
		<cffunction name="checkforsurvey" output="false" access="remote" hint="I get the client questionnaire answers.">			
			<cfargument name="leadid" required="yes" default="#session.leadid#" type="numeric">			
			<cfset var checksurvey = "" />			
				<!--- // query our datasource for the survey results --->				
				<cfquery datasource="#application.dsn#" name="checksurvey">
					select count(slqaid) as totalquestions
					  from slanswer sla
					 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and sla.slqa IS NULL				   
				</cfquery>				
				<cfreturn checksurvey>			
		</cffunction>
	</cfcomponent>