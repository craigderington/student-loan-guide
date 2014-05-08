


		<cfcomponent displayname="convogateway">
		
			<cffunction name="init" access="public" output="false" returntype="convogateway" hint="Returns an initialized conversation gateway function.">		
				<!--- // return This reference. --->
				<cfreturn this />
			</cffunction>
			
			
			<cffunction name="getadvisors" access="public" output="false" hint="I get the advisor team for the selected client.">
				<cfargument name="leadid" type="numeric" default="#session.leadid#">
				<cfset var advisorlist = "" />
				<cfquery datasource="#application.dsn#" name="advisorlist">
					select la.leadassigndate, la.leadassignrole, la.leadassignaccept,
					       u.firstname, u.lastname, u.userid, u.role
					  from leadassignments la, users u, leads l
					 where la.leadassignuserid = u.userid
					   and la.leadassignleadid = l.leadid
					   and la.leadassignleadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
				</cfquery>
				<cfreturn advisorlist >
			</cffunction>
			
			<cffunction name="getconvo" access="public" output="false" hint="I get the list of conversations">
				<cfargument name="leadid" type="numeric" default="#session.leadid#" required="yes">				
					<cfquery datasource="#application.dsn#" name="convolist">
						select c.convoid, c.convouuid, c.userid, c.advisorid, c.convodatetime, c.convostatus, c.convoclosed,
							   l.leadfirst, l.leadlast, u.firstname as advisorfirst, u.lastname as advisorlast,
							   (select count(*) from conversation_reply cr where cr.convoid = c.convoid and cr.replyread = 0 and cr.userid <> <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />) as totalnewmsgs
						  from conversation c, leads l, users u
						 where c.userid = l.leadid
						   and c.advisorid = u.userid
						   and l.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
						   and c.convoclosed = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />
					</cfquery>
				<cfreturn convolist>
			</cffunction>
			
			<cffunction name="getconvoclosed" access="public" output="false" hint="I get the list of conversations">
				<cfargument name="leadid" type="numeric" default="#session.leadid#" required="yes">				
					<cfquery datasource="#application.dsn#" name="convoclosedlist">
						select c.convoid, c.convouuid, c.userid, c.advisorid, c.convodatetime, c.convostatus, c.convoclosed,
							   l.leadfirst, l.leadlast, u.firstname as advisorfirst, u.lastname as advisorlast							   
						  from conversation c, leads l, users u
						 where c.userid = l.leadid
						   and c.advisorid = u.userid
						   and l.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
						   and c.convoclosed = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
					</cfquery>
				<cfreturn convoclosedlist>
			</cffunction>
			
			<cffunction name="getconvothread" access="public" output="false" hint="I get the convo thread">
				<cfargument name="thread" type="uuid" default="#url.thread#" required="yes">				
					<cfset var convothread = "" />
					
					<!--- // get the conversation --->
					<cfquery datasource="#application.dsn#" name="convodetail">
						select c.convoid, c.convouuid
						  from conversation c
						 where c.convouuid = <cfqueryparam value="#arguments.thread#" cfsqltype="cf_sql_varchar" maxlength="35" />
					</cfquery>				
					
					<!--- // then pass the convo id to the thread --->
					<cfquery datasource="#application.dsn#" name="convothread">
						select cr.convoreplyid, cr.convoid, cr.userid, cr.replytext, cr.replydatetime,
						       u.firstname, u.lastname, c.convodatetime, c.convostatus, c.convoclosed,
							   c.convouuid, l.leadfirst, l.leadlast, cr.threadwriter
						  from conversation_reply cr, conversation c, users u, leads l
						 where cr.convoid = c.convoid
						   and c.advisorid = u.userid
						   and cr.userid = l.leadid
						   and cr.convoid = <cfqueryparam value="#convodetail.convoid#" cfsqltype="cf_sql_integer" />
					  order by cr.convoreplyid desc, cr.replydatetime desc 
					</cfquery>
				<cfreturn convothread>				
			</cffunction>
			
			<cffunction name="markreplyread" access="public" output="false" hint="I mark the reply thread as read by the user">
				<cfargument name="thread" type="uuid" required="yes" default="#url.thread#">
				<cfargument name="userid" type="numeric" required="yes" default="#session.userid#">
				
				<!--- // get the conversation --->
				<cfquery datasource="#application.dsn#" name="convodetail2">
					select c.convoid, c.convouuid
					  from conversation c
					 where c.convouuid = <cfqueryparam value="#arguments.thread#" cfsqltype="cf_sql_varchar" maxlength="35" />
				</cfquery>			
				
				<cfquery datasource="#application.dsn#" name="getreplyid">
					select top 1 convoreplyid
					  from conversation_reply
					 where convoid = <cfqueryparam value="#convodetail2.convoid#" cfsqltype="cf_sql_integer" />
					   and replyread = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />
					   and userid <> <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
				</cfquery>
				
				<cfif getreplyid.recordcount gt 0>
					<cfquery datasource="#application.dsn#" name="markread">
						update conversation_reply
						   set replyread = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
						 where convoreplyid = <cfqueryparam value="#getreplyid.convoreplyid#" cfsqltype="cf_sql_integer" />
					</cfquery>				
					<cfset convothreadid = getreplyid.convoreplyid />
					<cfreturn convothreadid>
				<cfelse>
					<cfset convothreadid = 0 />
					<cfreturn convothreadid>
				</cfif>
				
			</cffunction>
			
			
			
			
			<cffunction name="sendemailnotification" access="public" output="false" hint="I send the email notification for the conversation process">
				<cfargument name="convoid" type="numeric" required="yes" default="0">
				<cfargument name="thisthreadid" type="numeric" required="yes" default="0">
				
					<cfquery datasource="#application.dsn#" name="getthisconvo">
						select c.convoid, c.convouuid, u.email, l.leademail
						  from conversation c, leads l, users u
						 where c.userid = l.leadid
						   and c.advisorid = u.userid
						   and c.convoid = <cfqueryparam value="#arguments.convoid#" cfsqltype="cf_sql_integer" />
					</cfquery>
					
					<cfquery datasource="#application.dsn#" name="getthisreply">
						select cr.convoid, cr.userid, cr.threadwriter, cr.replytext, cr.replydatetime
						  from conversation_reply cr
						 where cr.convoreplyid = <cfqueryparam value="#arguments.thisthreadid#" cfsqltype="cf_sql_integer" />
					</cfquery>			
							
					<cfset sender = "#getthisreply.threadwriter#" />	
				
						<cfif getthisconvo.recordcount gt 0>
						
							<cfmail from="Student Loan Advisor Online<system@efiscal.net>" to="#getthisconvo.email#,#getthisconvo.leademail#" cc="craig@efiscal.net" subject="New Reply Posted to Your Conversation" type="HTML">
							
										<html>
											<head>
												<title>Conversation Email</title>	    
											</head>
											<cfoutput>
											<body>
												<table width="60%"  border="0" cellspacing="0" cellpadding="25">
												  <tr>
													<td colspan="2"><div align="center"><img src="http://www.efiscal.net/images/sla-email-header-1.png" width="447" height="40"></div></td>
												  </tr>
												  <tr>
													<td colspan="2" style="font-family:Verdana:font-size:8px;">A new message was posted to your converstation by... </span></td>
												  </tr>
												  <tr>
													<td style="font-family:Verdana;font-size:12px;font-weight:bold;background-color:##f2f2f2;text-align:center;">#sender#</td>
													<td style="font-family:Verdana;font-size:12px;font-weight:bold;background-color:##f2f2f2;text-align:center;">Date: #dateformat( getthisreply.replydatetime, "long" )# #timeformat( getthisreply.replydatetime, "long" )#</td>
												  </tr>
												  <tr>
													<td colspan="2"><table width="100%"  border="0" cellspacing="0" cellpadding="25">
													  <tr>
														<td colspan="2">
															
															
															<blockquote style="padding:50px;background-color:##f2f2f2;">
																#urldecode( getthisreply.replytext )#
															</blockquote>
															
															<div align="center">
																<a href="http://www.studentloanadvisoronline.com/index.cfm?event=page.index">Reply Now</a>
															</div>
														
														
														</td>
													  </tr>
													  <tr>
														<td>&nbsp;</td>
														<td>&nbsp;</td>
													  </tr>
													  <tr>
														<td>&nbsp;</td>
														<td>&nbsp;</td>
													  </tr>
													</table></td>
												  </tr>
												  <tr>
													<td colspan="2"><div align="center">
													  <p style="font-family:Verdana:font-size:8px;text-align:center">This message is sent on behalf of <a href="http://www.studentloanadvisoronline.com" target="_blank">Student Loan Advisor Online</a></p>
													  </div></td>
												  </tr>
												</table>
											</body>
											</cfoutput>
										</html>

													
							</cfmail>
						<cfset msgstatus = "Successful Email Notification">
						<cfreturn msgstatus>
					<cfelse>	
						<cfset msgstatus = "Email Notification Failed">
						<cfreturn msgstatus>
					</cfif>				
				
			</cffunction>		
			
			
			<cffunction name="getmessagecenter" access="public" output="false" hint="I get the advisors questions">
				<cfargument name="myid" type="numeric" required="yes" default="0">				
					<cfset var msgcenter = "" />
					<cfquery datasource="#application.dsn#" name="msgcenter">
						select distinct(c.convoid), c.convouuid, c.convostatus, c.convoclosed, u.firstname, u.lastname, l.leadfirst, l.leadlast, l.leaduuid,
							  (select count(cr1.convoreplyid) from conversation_reply cr1 where c.convoid = cr1.convoid and cr1.userid <> <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" /> and cr1.replyread = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />) as totalnewmessages,
							  (select max(replydatetime) from conversation_reply cr1 where c.convoid = cr1.convoid) as lastmsgdate
						  from conversation c, conversation_reply cr, users u, leads l
						 where c.convoid = cr.convoid
						   and c.userid = l.leadid
						   and c.advisorid = u.userid
						   and c.advisorid = <cfqueryparam value="#arguments.myid#" cfsqltype="cf_sql_integer" />
						   and c.convoclosed = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />
					  order by lastmsgdate desc
					</cfquery>
				<cfreturn msgcenter>		
			</cffunction>
			
		
		</cfcomponent>