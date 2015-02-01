	
	
	<cfcomponent displayname="leadgateway">
		
		<cffunction name="init" access="public" output="false" returntype="leadgateway" hint="Returns an initialized lead gateway function.">		
			<!--- // return This reference. --->
			<cfreturn this />
		</cffunction>
		
		<cffunction name="getleadsources" output="false" access="remote" hint="I get the list of lead sources">			
			<cfargument name="companyid" required="yes" default="#session.companyid#">
			<cfset var leadsources = "" />
				<cfquery datasource="#application.dsn#" name="leadsources">
					select ls.leadsourceid, ls.leadsource, ls.active
					  from leadsource ls
					 where ls.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
				  order by ls.leadsource asc 
				</cfquery>				
			<cfreturn leadsources>			
		</cffunction>
		
		<cffunction name="getleadstatus" output="false" access="remote" hint="I get the list of lead statuses.">
			<cfset var leadstatus = "" />
				<cfquery datasource="#application.dsn#" name="leadstatus">
					select ls.leadstatusid, ls.leadstatus
					  from leadstatus ls				 
				  order by ls.leadstatus asc
				</cfquery>				
			<cfreturn leadstatus>			
		</cffunction>
		
		<cffunction name="getrecentactivity" output="false" access="remote" hint="I get the list of recent lead activity.">			
			<cfargument name="companyid" required="yes" default="#session.companyid#">
			<cfargument name="userid" required="no" default="#session.userid#" type="numeric">
			<cfset var logrecent = "" />
				<cfquery datasource="#application.dsn#" name="logrecent">
					select r.recentid, r.recentdate, a.activity, a.activitytype, l.leadid, l.leaduuid, 
					       l.leadfirst, l.leadlast, u.firstname, u.lastname
                      from recent r, activity a, leads l, users u, company c
                     where r.activityid = a.activityid
                       and r.leadid = l.leadid
                       and a.userid = u.userid
                       and u.companyid = c.companyid
                       and l.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
					   <cfif not isuserinrole( "admin" ) and not isuserinrole( "co-admin" )>
					   and l.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
					   </cfif>
                  order by r.recentid desc
				</cfquery>				
			<cfreturn logrecent>			
		</cffunction>
		
		<cffunction name="leadsbyage" output="false" access="remote" hint="I get the list of leads by age.">			
			<cfargument name="userid" required="yes" default="#session.userid#">
			<cfargument name="companyid" required="yes" default="#session.companyid#">
			<cfargument name="today" required="yes" default="#Now()#">
			<cfset var leadslist = "" />
				<cfquery datasource="#application.dsn#" name="leadslist">
					select l.leadid, l.leaduuid, ls.leadsource, l.leaddate, l.leadfirst, l.leadlast, l.leademail,
					       l.leadphonenumber, l.leadphonetype
					  from leads l, leadsource ls
					 where l.leadsourceid = ls.leadsourceid
					   and ls.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
					   <cfif not isuserinrole( "co-admin" ) and not isuserinrole( "admin" )>
					   and l.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
					   </cfif>
					   and l.leadconv = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />
					   and l.leadactive = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
				  order by l.leaddate desc  
				</cfquery>				
			<cfreturn leadslist>			
		</cffunction>

		
		<cffunction name="getmleadlist" output="false" access="remote" hint="I get the list of new program enrollment inquiries.">			
			<cfargument name="userid" required="yes" default="#session.userid#">
			<cfargument name="companyid" required="yes" default="#session.companyid#">
			<cfargument name="thisdate" required="yes" default="#now()#">
			<cfset var mleadlist = "" />
				<cfquery datasource="#application.dsn#" name="mleadlist">
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
						    
							<cfif not isuserinrole( "co-admin" ) and not isuserinrole( "admin" )>
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
								
								<cfif structkeyexists( form, "startleaddate" ) and form.startleaddate is not "" and form.startleaddate is not "Select Start Date" and structkeyexists( form, "endleaddate" ) and form.endleaddate is not "" and form.endleaddate is not "Select End Date">
									and l.leaddate between <cfqueryparam value="#form.startleaddate#" cfsqltype="cf_sql_date" /> and <cfqueryparam value="#form.endleaddate#" cfsqltype="cf_sql_date" />
								</cfif>					   
							
							</cfif>
					   
				  order by l.leadlast asc
				</cfquery>				
			<cfreturn mleadlist>			
		</cffunction>
		
			
		
		<cffunction name="getleadsearch" output="false" access="remote" hint="I get the list of leads by age.">			
			<cfargument name="search" required="yes" default="#form.search#">
			<cfargument name="userid" required="yes" default="#session.userid#">
			<cfargument name="companyid" required="yes" default="#session.companyid#">
			
			<cfset var leadsearch = "" />
			<cfset arguments.search = listfirst(arguments.search, " ") />
				
				<!--- // query our datasource for the results --->				
				<cfquery datasource="#application.dsn#" name="leadsearch">
					select l.leadid, l.leaduuid, ls.leadsource, l.leaddate, l.leadfirst, l.leadlast, l.leademail,
					       l.leadphonenumber, l.leadphonetype, l.leadactive
					  from leads l, leadsource ls
					 where l.leadsourceid = ls.leadsourceid
					   				   
							<cfif isnumeric( arguments.search )>					   
						
								and	l.leadid = <cfqueryparam value="#arguments.search#" cfsqltype="cf_sql_integer" />
					        
							<cfelse>
						
								and	l.leadfirst + l.leadlast like <cfqueryparam value="%#arguments.search#%" cfsqltype="cf_sql_varchar" />
							
							</cfif>
							
								and l.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
					        
							<!---
							<cfif not isuserinrole( "co-admin" ) and not isuserinrole( "admin" )>
					    
								and l.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
					        
							</cfif>
							--->
					   
				  order by l.leadlast asc 
				</cfquery>				
			<cfreturn leadsearch>			
		</cffunction>		
		
		<cffunction name="getleaddetail" output="false" access="remote" hint="I get the lead details for the summary and settings.">			
			<cfargument name="leadid" required="yes" default="#session.leadid#" type="numeric">			
			<cfset var leaddetail = "" />				
				<cfquery datasource="#application.dsn#" name="leaddetail">
					select l.leadid, l.leaduuid, ls.leadsource, l.leaddate, l.leadfirst, l.leadlast, l.leademail,
					       l.leadphonenumber, l.leadphonetype, l.leadactive, l.leadconv, l.leadpassword, l.agencyuniqueid,
						   l.leadusername, l.leadphonetype2, l.leadphonenumber2, l.leadsourceid, l.leadadd1,
						   l.leadadd2, l.leadcity, l.leadstate, l.leadzip, l.leadmobileprovider, l.leadachhold, 
						   l.leadachholdreason, l.leadachholddate, l.leaddobmonth, l.leaddobday, l.leaddobyear, 
						   l.leadimp, l.leadintakecompdate, l.leadwelcomehome, l.leadintakecompby, l.leadesign, 
						   c.companyid, c.companyname, c.dba, c.email as companyprimarycontact, l.leadadvisorycompdate,
						   l.leadadvisorycompby, u.firstname + ' ' + u.lastname as enrolladvisor
					  from leads l, leadsource ls, company c, users u
					 where l.leadsourceid = ls.leadsourceid
					   and l.companyid = c.companyid
					   and l.userid = u.userid
					   and l.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />			   
				</cfquery>				
			<cfreturn leaddetail>			
		</cffunction>
		
		<cffunction name="getleaddetailbyuuid" output="false" access="remote" hint="I get the lead details for the reports and other admin resources.">			
			<cfargument name="leadid" required="yes" default="#url.leadid#" type="uuid">			
			<cfset var leaddetailbyuuid = "" />				
				<cfquery datasource="#application.dsn#" name="leaddetailbyuuid">
					select l.leadid, l.leaduuid, ls.leadsource, l.leaddate, l.leadfirst, l.leadlast, l.leademail,
					       l.leadphonenumber, l.leadphonetype, l.leadactive, l.leadconv, l.leadpassword, 
						   l.leadusername, l.leadphonetype2, l.leadphonenumber2, l.leadsourceid, l.leadadd1,
						   l.leadadd2, l.leadcity, l.leadstate, l.leadzip, l.leadmobileprovider, l.leadachhold, 
						   l.leadachholdreason, l.leadachholddate, l.leaddobmonth, l.leaddobday, l.leaddobyear, 
						   l.leadimp, l.leadintakecompdate, l.leadwelcomehome, leadintakecompby, l.leadesign, 
						   c.companyid, c.companyname, c.dba, c.email as companyprimarycontact
					  from leads l, leadsource ls, company c
					 where l.leadsourceid = ls.leadsourceid
					   and l.companyid = c.companyid
					   and l.leaduuid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_varchar" maxlength="35" />			   
				</cfquery>				
			<cfreturn leaddetailbyuuid>			
		</cffunction>

		<cffunction name="getsls" output="false" access="remote" hint="I get the student loan specialists from the users table.">			
			<cfargument name="companyid" required="yes" default="#session.companyid#" type="numeric">			
			<cfset var slslist = "" />				
				<cfquery datasource="#application.dsn#" name="slslist">
					select userid, firstname, lastname, role
					  from users
					 where companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
					   and role = <cfqueryparam value="sls" cfsqltype="cf_sql_varchar" />
					   and active = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
				  order by lastname asc
				</cfquery>				
			<cfreturn slslist>			
		</cffunction>

		<cffunction name="getleadloginprofile" access="remote" output="false" hint="I get the lead login user profile data.">
			<cfargument name="leadid" required="yes" type="numeric" default="#session.leadid#">				
			<cfset var qleadlogin = "">
			<cfquery datasource="#application.dsn#" name="qleadlogin">
				select username, firstname, lastname, passcode, active, email, leadid, leadwelcome
				  from users
				 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />				
			</cfquery>				
			<cfreturn qleadlogin>			
		</cffunction>
		
		<cffunction name="getleadsummary" output="false" access="remote" hint="I get the student loan lead summary information and details.">			
			<cfargument name="leadid" required="yes" default="#session.leadid#" type="numeric">			
			<cfset var leadsummary = "" />				
				<cfquery datasource="#application.dsn#" name="leadsummary">
					select summaryid, leadid, slsid, slq1, slq2, slbalance, slmonthly, slinquirydate, slreason, sloutcome, 
					       slenrolldate, slenrollcontacttype, slenrollclientmethod, slenrollclientdocsdate,
						   slenrollreturndate, slenrolldocsuploaddate, slsassigndate, slscontactdate, 
						   slinfoclientmethod, slinfodate, slinforeturndate, slinfocounseldate, slinfocounselmethod,
						   slinfouploaddate, slsanalysisdate, slscompanalysisdate, slspresentdate,
						   slsanalysisuploaddate, slsolutionclientdate, slauthdocagencydate, slconfirmauthdate,
						   slmbgdate, slenrollclientdocsmethod, primaryagi, secondaryagi, filingstatus, familysize, 
						   mfj, repaymentplan, repaymenttermsmos, eda, spousedebt, finsaved,
						   implenrolldate, implenrolldocsendmethod, implenrolldocsubmitdate,
						   implenrolldocreturndate, implenrolldocuploaddate, implenrollcomp,
						   borrowerfirstname, borrowerlastname, borrowerssn, borrowerdob, borrowerdl, dlstate, employer,
						   occupation, workphone, workphoneext, worktype, avgworkhours, spousefirstname, 
						   spouselastname, spousessn, spousedob, spouseemployer, spouseoccupation						  
					  from slsummary
					 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />				  
				</cfquery>				
			<cfreturn leadsummary>			
		</cffunction>		
		
		<cffunction name="getleadactivity" output="false" access="remote" hint="I get the lead activity details.">			
			<cfargument name="leadid" required="yes" default="#session.leadid#" type="numeric">			
			<cfset var leadact = "" />				
				<cfquery datasource="#application.dsn#" name="leadact">
					select a.activityid, a.leadid, a.userid, a.activitydate, a.activitytype, a.activity, 
					       u.firstname, u.lastname
					  from activity a, users u
					 where a.userid = u.userid
					   and a.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
				  order by a.activitydate desc 
				</cfquery>				
			<cfreturn leadact>			
		</cffunction>		
		
		<cffunction name="getleadnotes" output="false" access="remote" hint="I get the list of lead notes.">			
			<cfargument name="leadid" required="yes" default="#session.leadid#" type="numeric">			
			<cfset var leadnotes = "" />				
				<cfquery datasource="#application.dsn#" name="leadnotes">
					select n.noteid, n.leadid, n.userid, n.notedate, n.notetext, n.removed,
					       u.firstname, u.lastname, n.noteuuid, n.systemnote
					  from notes n, users u
					 where n.userid = u.userid
					   and n.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and n.removed = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />
				  order by n.notedate desc 
				</cfquery>				
			<cfreturn leadnotes>			
		</cffunction>		
		
		<cffunction name="getnotedetail" output="false" access="remote" hint="I get specific note detail for the selected client and note.">			
			<cfargument name="leadid" required="yes" default="#session.leadid#" type="numeric" >
			<cfargument name="noteid" required="yes" default="#url.noteid#" type="uuid" >
			<cfset var notedetail = "" />				
				<cfquery datasource="#application.dsn#" name="notedetail">
					select n.noteid, n.leadid, n.userid, n.notedate, n.notetext, n.removed,
					       u.firstname, u.lastname, n.noteuuid
					  from notes n, users u
					 where n.userid = u.userid
					   and n.noteuuid = <cfqueryparam value="#arguments.noteid#" cfsqltype="cf_sql_varchar" />
					   and n.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />				  
				</cfquery>				
			<cfreturn notedetail>			
		</cffunction>		
		
		<cffunction name="getmtasks" output="false" access="remote" hint="I get the master list of tasks to create the lead task list.">			
			<cfargument name="companyid" required="yes" default="#session.companyid#" type="numeric">			
			<cfset var mtasklist = "" />				
				<cfquery datasource="#application.dsn#" name="mtasklist">
					select mtaskid, mtaskuuid, companyid, mtasktype, mtaskorder, mtaskname, mtaskdescr
					  from mtask
					 where mtaskactive = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />					   
				  order by mtasktype, mtaskorder asc		  
				</cfquery>				
			<cfreturn mtasklist>			
		</cffunction>		
		
		<cffunction name="getleadtasks" output="false" access="remote" hint="I get the list of tasks for the lead task.">			
			<cfargument name="leadid" required="yes" default="#session.leadid#" type="numeric">			
			<cfset var tasklist = "" />				
				<cfquery datasource="#application.dsn#" name="tasklist">
					select t.taskid, t.taskuuid, mt.mtasktype, mt.mtaskname, mt.mtaskdescr, t.userid, t.taskname, t.taskstatus,
					       t.tasklastupdated, t.tasklastupdatedby, t.taskduedate, t.taskcompleteddate, t.taskcompletedby, t.tasknotes
					  from tasks t, mtask mt
					 where t.mtaskid = mt.mtaskid
					   and t.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_varchar" />
					   and mt.mtasktype <> <cfqueryparam value="S" cfsqltype="cf_sql_char" />
					   and mt.mtaskid NOT IN(<cfqueryparam value="9889,9892,9893,9903,9909" cfsqltype="cf_sql_integer" list="yes">)
					   <cfif structkeyexists( form, "filtertasks" )>
							and ( mt.mtasktype = <cfqueryparam value="#trim( form.rgtasktype )#" cfsqltype="cf_sql_char" />	)
					   <cfelse>
							and ( mt.mtasktype = <cfqueryparam value="E" cfsqltype="cf_sql_char" />					    
							   <cfif structkeyexists( session, "leadconv" )>
								or mt.mtasktype = <cfqueryparam value="N" cfsqltype="cf_sql_char" />
								or mt.mtasktype = <cfqueryparam value="O" cfsqltype="cf_sql_char" />											   			   
							   </cfif>					   
							   <cfif structkeyexists( session, "implement" )>
								or mt.mtasktype = <cfqueryparam value="S" cfsqltype="cf_sql_char" />					   			   
							   </cfif>					   
						    )
						</cfif>
				  order by mt.mtasktype, mt.mtaskorder asc
				</cfquery>				
			<cfreturn tasklist>			
		</cffunction>
		
		<cffunction name="gettaskprogress" output="false" access="remote" hint="I get the task progress for the lead task page.">			
			<cfargument name="leadid" required="yes" default="#session.leadid#" type="numeric">			
			<cfset var taskprogress = "" />				
				<cfquery datasource="#application.dsn#" name="taskprogress">
					select count(t.taskid) as totaltasks,
						   sum(case when t.taskstatus = 'Completed' then 1 else 0 end) as taskcomp,
						   sum(case when t.taskstatus = 'Assigned' then 1 else 0 end) as taskassigned,
						   sum(case when t.taskstatus = 'In Progress' then 1 else 0 end) as taskinpg,
						   sum(case when t.taskstatus = 'Pending' then 1 else 0 end) as taskpend
					  from tasks t, mtask mt
					 where t.mtaskid = mt.mtaskid
					   and t.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and mt.mtasktype <> <cfqueryparam value="S" cfsqltype="cf_sql_char" />
					   and mt.mtaskid NOT IN(<cfqueryparam value="9889,9892,9893,9903,9909" cfsqltype="cf_sql_integer" list="yes">)
					   and ( mt.mtasktype = <cfqueryparam value="E" cfsqltype="cf_sql_char" />					    
					   <cfif structkeyexists( session, "leadconv" )>
					    or mt.mtasktype = <cfqueryparam value="N" cfsqltype="cf_sql_char" />
						or mt.mtasktype = <cfqueryparam value="O" cfsqltype="cf_sql_char" />											   			   
					   </cfif>				   
					   )	
				</cfquery>				
			<cfreturn taskprogress>			
		</cffunction>
		
		<cffunction name="getintaketasks" output="false" access="remote" hint="I get the list of intake tasks for the lead.">			
			<cfargument name="leadid" required="yes" default="#session.leadid#" type="numeric">			
			<cfset var intaketasklist = "" />				
				<cfquery datasource="#application.dsn#" name="intaketasklist">
					select t.taskid, t.taskuuid, mt.mtasktype, mt.mtaskname, mt.mtaskdescr, t.userid, t.taskname, t.taskstatus,
					       t.tasklastupdated, t.tasklastupdatedby, t.taskduedate, t.taskcompleteddate, t.taskcompletedby, t.tasknotes,
						   mt.mtaskid
					  from tasks t, mtask mt
					 where t.mtaskid = mt.mtaskid
					   and t.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_varchar" />
					   and mt.mtasktype = <cfqueryparam value="N" cfsqltype="cf_sql_char" />
					   and mt.mtaskid <> <cfqueryparam value="9905" cfsqltype="cf_sql_integer" />
				  order by mt.mtasktype, mt.mtaskorder asc
				</cfquery>				
			<cfreturn intaketasklist>			
		</cffunction>
		
		
		<cffunction name="getadvisortasks" output="false" access="remote" hint="I get the list of advisor tasks for the review.">			
			<cfargument name="leadid" required="yes" default="#session.leadid#" type="numeric">			
			<cfset var advisortasklist = "" />				
				<cfquery datasource="#application.dsn#" name="advisortasklist">
					select t.taskid, t.taskuuid, mt.mtasktype, mt.mtaskname, mt.mtaskdescr, t.userid, t.taskname, t.taskstatus,
					       t.tasklastupdated, t.tasklastupdatedby, t.taskduedate, t.taskcompleteddate, t.taskcompletedby, t.tasknotes,
						   mt.mtaskid
					  from tasks t, mtask mt
					 where t.mtaskid = mt.mtaskid
					   and t.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_varchar" />
					   and mt.mtasktype = <cfqueryparam value="O" cfsqltype="cf_sql_char" />
					   and mt.mtaskid <> <cfqueryparam value="9905" cfsqltype="cf_sql_integer" />
				  order by mt.mtasktype, mt.mtaskorder asc
				</cfquery>				
			<cfreturn advisortasklist>			
		</cffunction>
		
		<cffunction name="getvancotransactions" output="false" access="remote" hint="I get the list of Vanco transactions for the client.">			
			<cfargument name="leadid" required="yes" default="#session.leadid#" type="numeric">			
			<cfset var vancotransactions = "" />				
				<cfquery datasource="#application.dsn#" name="vancotransactions">
					select vancotranslogid, leadid, transdatetime, customerref, paymentmethodref, 
						   requestid, sessionid, visamctype, cardtype, name_on_card, expmonth, 
						   expyear, billingaddr1, billingcity, billingstate, billingzip, name, 
						   last4, reqtype, accttype, ipaddress, customerid
					  from vancotranslog
					 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />					    
				  order by vancotranslogid asc
				</cfquery>				
			<cfreturn vancotransactions>			
		</cffunction>
		
		<cffunction name="getvancocharges" output="false" access="remote" hint="I get the list of Vanco crediot carsd charges and transactions for the client.">			
			<cfargument name="leadid" required="yes" default="#session.leadid#" type="numeric">			
			<cfset var vancochargelist = "" />				
				<cfquery datasource="#application.dsn#" name="vancochargelist">
					select vancotransactionid, vancotranslogid, vancouuid, leadid, customerref,
					       paymentmethodref, transactionref, requestid, requestdate, paymentamount, 
						   ccauthcode, cardtype
					  from vancotransactions
					 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />					    
				  order by vancotransactionid asc
				</cfquery>				
			<cfreturn vancochargelist>			
		</cffunction>
		
		
	</cfcomponent>