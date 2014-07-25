


		<cfcomponent displayname="remindergateway">
			
			<cffunction name="init" access="public" output="false" returntype="remindergateway" hint="Returns an initialized task reminder function.">		
				<!--- // return This reference. --->
				<cfreturn this />
			</cffunction>
			
			<cffunction name="gettaskreminder" access="remote" returntype="query" output="false" hint="I get the task reminders">
				<cfargument name="taskid" default="#url.taskid#" type="any">
					<cfquery datasource="#application.dsn#" name="taskreminder">
						select r.reminderid, r.taskuuid, r.remindertext, r.reminderdate, r.remindertime, r.alerttype, 
						       r.alertdeltatype, r.alertdeltanum, r.alertsent, u.firstname, u.lastname, r.userid
						  from taskreminders r, tasks t, users u
						 where r.taskuuid = t.taskuuid
						   and r.userid = u.userid
						   and t.taskuuid = <cfqueryparam value="#arguments.taskid#" cfsqltype="cf_sql_varchar" maxlength="35" />
					</cfquery>
					<cfreturn taskreminder>
			</cffunction>
			
			<cffunction name="gettaskreminderdetail" access="remote" returntype="query" output="false" hint="I get the task reminders">
				<cfargument name="rmid" default="#url.rmid#" type="numeric" required="yes">
					<cfquery datasource="#application.dsn#" name="taskreminderdetail">
						select r.reminderid, r.taskuuid, r.remindertext, r.reminderdate, r.remindertime, r.alerttype, 
						       r.alertdeltatype, r.alertdeltanum, r.alertsent
						  from taskreminders r, tasks t
						 where r.taskuuid = t.taskuuid						   
						   and r.reminderid = <cfqueryparam value="#arguments.rmid#" cfsqltype="cf_sql_integer" />
					</cfquery>
					<cfreturn taskreminderdetail>
			</cffunction>
			
			
			<cffunction name="gettaskreminders" access="public" output="false" returntype="query" hint="I get the list of task reminders.">
				<cfargument name="userid" default="#session.userid#" type="numeric" required="yes">				
				<cfset var taskreminderlist = "" />				
				<cfquery datasource="#application.dsn#" name="taskreminderlist">
					select tr.reminderid, tr.taskuuid, tr.reminderdate, tr.remindertime, tr.alerttype, tr.alertdeltatype,
					       tr.alertdeltanum, tr.alertsent, t.taskid, t.leadid, t.taskname, t.taskstatus, t.taskduedate,
						   t.tasknotes, l.leadfirst, l.leadlast, mt.mtaskname, tr.remindertext, l.leadfirst, l.leadlast, l.leadid
					  from taskreminders tr, tasks t, mtask mt, leads l
					 where tr.taskuuid = t.taskuuid
					   and t.leadid = l.leadid
					   and t.mtaskid = mt.mtaskid
					   and t.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
					   and tr.showreminder = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
				  order by t.leadid
				</cfquery>
				<cfreturn taskreminderlist >
			</cffunction>
			
			
			<cffunction name="getreminder" access="public" output="false" returntype="query" hint="I get the list of task reminders.">
				<cfargument name="taskid" default="#url.taskid#" type="uuid" required="yes">				
				<cfset var rdetail = "" />				
				<cfquery datasource="#application.dsn#" name="rdetail">
					select tr.reminderid, tr.taskuuid, tr.reminderdate, tr.remindertime, tr.alerttype, tr.alertdeltatype,
					       tr.alertdeltanum, tr.alertsent, t.taskid, t.leadid, t.taskname, t.taskstatus, t.taskduedate,
						   t.tasknotes, l.leadfirst, l.leadlast
					  from taskreminders tr, tasks t, leads l
					 where tr.taskuuid = t.taskuuid
					   and t.leadid = l.leadid
					   and t.taskuuid = <cfqueryparam value="#arguments.taskid#" cfsqltype="cf_sql_varchar" maxlength="35" />				   
				</cfquery>
				<cfreturn rdetail>
			</cffunction>
			
			
			<cffunction name="getuserreminders" access="public" output="false" returntype="query" hint="I get the list of user reminders.">
				<cfargument name="userid" default="#session.userid#" type="numeric" required="yes">				
				<cfset var userreminderlist = "" />				
				<cfquery datasource="#application.dsn#" name="userreminderlist">
					select reminderuuid, userid, leadid, dateadded, reminderdate, remindertime, reminderampm,
					       remindertext, alerttype, alertdeltatype, alertdeltanum, alertsent
					  from userreminders
					 where userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
					   and showreminder = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
					order by reminderdate, remindertime asc
				</cfquery>
				<cfreturn userreminderlist>
			</cffunction>
			
			
			<cffunction name="getuserreminderdetail" access="public" output="false" returntype="query" hint="I get the user reminder detail.">
				<cfargument name="reminderid" default="#url.rmid#" type="uuid" required="yes">				
				<cfset var userreminderdetail = "" />				
				<cfquery datasource="#application.dsn#" name="userreminderdetail">
					select reminderuuid, userid, leadid, dateadded, reminderdate, remindertime, reminderampm,
					       remindertext, alerttype, alertdeltatype, alertdeltanum, alertsent
					  from userreminders
					 where reminderuuid = <cfqueryparam value="#arguments.reminderid#" cfsqltype="cf_sql_varchar" maxlength="35" />
					   and showreminder = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
				</cfquery>
				<cfreturn userreminderdetail>
			</cffunction>
			
			
			<cffunction name="senduserreminders" access="remote" output="false" hint="I send the user reminder by text message or email">
				
				<cfargument name="thisdate" required="yes" type="date" default="1/1/2014">
				<cfargument name="thisdatetime" type="date" default="1/1/2014 12:00:00">
				<cfargument name="alerttype" type="string" default="eml">
				<cfargument name="timedelta" type="date" default="1/1/2014 12:00:00">
				
				<cfset arguments.thisdatetime = now() />
				<cfset arguments.timedelta = dateadd( "n", 30, arguments.thisdatetime ) />
				<cfset var reminderinfo = "" />
				
				
				<!--- // get one reminder each time the scheduled task runs --->
				<cfquery datasource="#application.dsn#" name="getreminderdetail">
					select top 1 reminderid, reminderuuid, userid, leadid, dateadded, reminderdate, remindertime,
					       reminderampm, remindertext, alerttype, alertdeltatype, alertdeltanum, alertsent, showreminder
					  from userreminders
					 where alertsent = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />
					   and showreminder = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
					   and reminderdate = <cfqueryparam value="#arguments.thisdate#" cfsqltype="cf_sql_date" />
					   and remindertime between <cfqueryparam value="#arguments.thisdatetime#" cfsqltype="cf_sql_timestamp" /> and <cfqueryparam value="#arguments.timedelta#" cfsqltype="cf_sql_timestamp" />					   
				</cfquery>
				
				<!--- // if we have a valid reminder get our user --->
				<cfif getreminderdetail.recordcount eq 1 >
				
					<!--- // then get the user and company detail for the email --->
					<cfquery datasource="#application.dsn#" name="getuserinfo">
						select c.dba, c.email as companyemail, 
							   u.email as useremail, u.txtmsgaddress, 
							   u.txtmsgprovider
						  from company c, users u
						 where c.companyid = u.companyid
						   and u.userid = <cfqueryparam value="#getreminderdetail.userid#" cfsqltype="cf_sql_integer" />
					</cfquery>
				
					<cfif getuserinfo.recordcount eq 1 >
				
						<cfset arguments.alerttype = getreminderdetail.alerttype />
						<cfset reminderinfo = "#getreminderdetail.reminderuuid#-#getreminderdetail.remindertext#-#getuserinfo.useremail#" />
						
						
						<cfif trim( arguments.alerttype ) is "eml">
							<cfmail from="#getuserinfo.companyemail# (#getuserinfo.dba#)" to="#getuserinfo.useremail#" subject="Student Loan Advisor Online - Reminder" type="HTML"><h4>*** AUTOMATED SYSTEM MESSAGE.  PLEASE DO NOT REPLY ***</h4>
						
<cfoutput>						
<p>This is an automated system message from Student Loan Advisor Online to remind you about #getreminderdetail.remindertext#.</p>

<div style="background-color:##f2f2f2;border:1px dotted lightgray;padding:20px;">
	<p style="margin-top:25px;"><small>Reminder Date: #dateformat( getreminderdetail.reminderdate, "mm/dd/yyyy" )# @ #timeformat( getreminderdetail.remindertime, "hh:mm tt" )#</small></p>
	<p><small>Reminder Type: <cfif trim( getreminderdetail.alerttype ) is "txt">Text Message<cfelse>Email Message</cfif></small></p>
	<p><small>Reminder ID: #getreminderdetail.reminderuuid#</small></p>
	<p style="margin-bottom:25px;"><small>Reminder Text: #getreminderdetail.remindertext#</small></p>
</div>

<p style="margin-top:75px;"><small>This message was auto-generated from the <a href="https://www.studentloanadvisoronline.com/">Student Loan Advisor</a> website on #dateformat( now(), "mm/dd/yyyy" )# at #timeformat( now(), "hh:mm tt" )#.</small></p>
</cfoutput>						

						
						
							</cfmail>
						<cfelseif trim( arguments.alerttype ) is "txt">
							<cfmail from="#getuserinfo.companyemail#" to="#getuserinfo.txtmsgaddress##getuserinfo.txtmsgprovider#" subject="SLA - Reminder"><cfoutput>#left( getreminderdetail.remindertext,100 )#</cfoutput></cfmail>
						</cfif>					
					
						<!--- // now update the reminder and flag it as having already been sent --->
						<cfquery datasource="#application.dsn#" name="savereminderflag">
							update userreminders
							   set alertsent = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
							 where reminderid = <cfqueryparam value="#getreminderdetail.reminderid#" cfsqltype="cf_sql_integer" />
						</cfquery>				
						
						
						
						
					</cfif>
				</cfif>
			
				<cfreturn reminderinfo>
			
			</cffunction>
			
			
			
			<cffunction name="sendtaskreminders" access="remote" output="false" hint="I send the user reminder by text message or email">
				
				<cfargument name="thisdate" required="yes" type="date" default="1/1/2014">
				<cfargument name="thisdatetime" type="date" default="1/1/2014 12:00:00">
				<cfargument name="alerttype" type="string" default="eml">
				<cfargument name="timedelta" type="date" default="1/1/2014 12:00:00">
				
				<cfset arguments.thisdatetime = now() />
				<cfset arguments.timedelta = dateadd( "n", 30, arguments.thisdatetime ) />
				<cfset var taskreminderinfo = "" />
				
				
				<!--- // get one reminder each time the scheduled task runs --->
				<cfquery datasource="#application.dsn#" name="getreminderdetail">
					select top 1 tr.reminderid, tr.taskuuid, tr.userid, tr.reminderdate, tr.remindertime,
					       tr.remindertext, tr.alerttype, tr.alertsent,
						   t.taskduedate, t.taskstatus, t.tasklastupdated, t.tasklastupdatedby, 
						   mt.mtaskname
					  from taskreminders tr, tasks t, mtask mt					  
					 where tr.taskuuid = t.taskuuid
					   and t.mtaskid = mt.mtaskid
					   and tr.alertsent = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />					  
					   and tr.reminderdate = <cfqueryparam value="#arguments.thisdate#" cfsqltype="cf_sql_date" />
					   and tr.remindertime between <cfqueryparam value="#arguments.thisdatetime#" cfsqltype="cf_sql_timestamp" /> and <cfqueryparam value="#arguments.timedelta#" cfsqltype="cf_sql_timestamp" />					   
				</cfquery>
				
				<!--- // if we have a valid reminder get our user --->
				<cfif getreminderdetail.recordcount eq 1 >
				
					<!--- // then get the user and company detail for the email --->
					<cfquery datasource="#application.dsn#" name="getuserinfo">
						select c.dba, c.email as companyemail, 
							   u.email as useremail, u.txtmsgaddress, 
							   u.txtmsgprovider
						  from company c, users u
						 where c.companyid = u.companyid
						   and u.userid = <cfqueryparam value="#getreminderdetail.userid#" cfsqltype="cf_sql_integer" />
					</cfquery>
				
					<cfif getuserinfo.recordcount eq 1 >
				
						<cfset arguments.alerttype = getreminderdetail.alerttype />
						<cfset taskreminderinfo = "#getreminderdetail.taskuuid#-#getreminderdetail.remindertext#-#getuserinfo.useremail#" />
						
						
						<cfif trim( arguments.alerttype ) is "eml">
							<cfmail from="#getuserinfo.companyemail# (#getuserinfo.dba#)" to="#getuserinfo.useremail#" subject="Student Loan Advisor Online - Reminder" type="HTML"><h4>*** AUTOMATED SYSTEM MESSAGE.  PLEASE DO NOT REPLY ***</h4>
						
<cfoutput>						
<p>This is an automated system message from Student Loan Advisor Online to remind you about a client task #getreminderdetail.mtaskname#.</p>

<div style="background-color:##f2f2f2;border:1px dotted lightgray;padding:25px;">
	<p style="margin-top:25px;"><small>Reminder Date: #dateformat( getreminderdetail.reminderdate, "mm/dd/yyyy" )# @ #timeformat( getreminderdetail.remindertime, "hh:mm tt" )#</small></p>
	<p><small>Reminder Type: <cfif trim( getreminderdetail.alerttype ) is "txt">Text Message<cfelse>Email Message</cfif></small></p>	
	<p><small>Task: #getreminderdetail.mtaskname#</small></p>
	<p><small>Task Status: #getreminderdetail.taskstatus#</small></p>
	<p><small>Last Updated: #dateformat( getreminderdetail.tasklastupdated, "mm/dd/yyyy" )# by #getreminderdetail.tasklastupdatedby#</small></p>	
	<p style="margin-bottom:25px;"><small>Reminder Text: #getreminderdetail.remindertext#</small></p>
</div>

<p style="margin-top:75px;"><small>This message was auto-generated from the <a href="https://www.studentloanadvisoronline.com/">Student Loan Advisor</a> website on #dateformat( now(), "mm/dd/yyyy" )# at #timeformat( now(), "hh:mm tt" )#.</small></p>
</cfoutput>						

						
						
							</cfmail>
						<cfelseif trim( arguments.alerttype ) is "txt">
							<cfmail from="#getuserinfo.companyemail#" to="#getuserinfo.txtmsgaddress##getuserinfo.txtmsgprovider#" subject="SLA - Reminder"><cfoutput>#left( getreminderdetail.remindertext,100 )#</cfoutput></cfmail>
						</cfif>					
					
						<!--- // now update the reminder and flag it as having already been sent --->
						<cfquery datasource="#application.dsn#" name="savereminderflag">
							update taskreminders
							   set alertsent = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
							 where reminderid = <cfqueryparam value="#getreminderdetail.reminderid#" cfsqltype="cf_sql_integer" />
						</cfquery>				
						
						
						
						
					</cfif>
				</cfif>
			
				<cfreturn taskreminderinfo>
			
			</cffunction>
			
					
		</cfcomponent>