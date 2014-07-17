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
						<cfset taskreminderinfo = "#getreminderdetail.reminderuuid#-#getreminderdetail.remindertext#-#getuserinfo.useremail#" />
						
						
						<cfif trim( arguments.alerttype ) is "eml">
							<cfmail from="#getuserinfo.companyemail# (#getuserinfo.dba#)" to="#getuserinfo.useremail#" subject="Student Loan Advisor Online - Reminder" type="HTML"><h4>*** AUTOMATED SYSTEM MESSAGE.  PLEASE DO NOT REPLY ***</h4>
						
<cfoutput>						
<p>This is an automated system message from Student Loan Advisor Online to remind you about a client task #getreminderdetail.mtaskname#.</p>

<div style="background-color:##f2f2f2;border:1px dotted lightgray;padding:20px;">
	<p style="margin-top:25px;"><small>Reminder Date: #dateformat( getreminderdetail.reminderdate, "mm/dd/yyyy" )# @ #timeformat( getreminderdetail.remindertime, "hh:mm tt" )#</small></p>
	<p><small>Reminder Type: <cfif trim( getreminderdetail.alerttype ) is "txt">Text Message<cfelse>Email Message</cfif></small></p>	
	<p><small>Task: #getreminderdetail.mtaskname#</small></p>
	<p><small>Task Status: #getreminderdetail.taskstatus#</small></p>
	<p><small>Last Updated: #dateformat( getreminderdetail.tasklastupdated, "mm/dd/yyyy" )# by #getreminderdetail.tasklastupdatedby#</small></p>
	<p><small>Task: #getreminderdetail.mtaskname#</small></p>	
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