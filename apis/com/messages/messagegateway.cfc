

	<cfcomponent displayname="messagegateway">
	
		<cffunction name="init" access="public" output="false" returntype="messagegateway" hint="Returns an initialized message gateway function.">		
			<!--- // return This reference. --->
			<cfreturn this />
		</cffunction>
	
		<cffunction name="getmessages" access="remote" returntype="query" output="false" hint="I get the list of system messages for the email library.">			
			<cfargument name="companyid" required="yes" default="#session.companyid#">
			<cfargument name="deptid" required="no" default="#session.deptid#">			
			<cfset var msglist = "" />
			<cfquery datasource="#application.dsn#" name="msglist">
				select *
				  from messages
				 where companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
				 <cfif isuserinrole("sls") or isuserinrole("counselor")>
				   and deptid = <cfqueryparam value="#arguments.deptid#" cfsqltype="cf_sql_integer" />
				 </cfif>
				   and active = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
			  order by msgname asc
			</cfquery>			
			<cfreturn msglist>		
		</cffunction>
		
		<cffunction name="getmessage" access="remote" returntype="query" output="false" hint="I get the message detail for a message in the library.">			
			<cfargument name="msgid" required="yes" default="#url.msgid#">			
			<cfset var msgdetail = "" />
			<cfquery datasource="#application.dsn#" name="msgdetail">
				select *
				  from messages
				 where msgid = <cfqueryparam value="#arguments.msgid#" cfsqltype="cf_sql_integer" />		  
			</cfquery>			
			<cfreturn msgdetail>		
		</cffunction>


		<cffunction name="gettextmessages" access="remote" returntype="query" output="false" hint="I get the list of text messages for the text messagelibrary.">			
			<cfargument name="companyid" required="yes" default="#session.companyid#">
			<cfargument name="deptid" required="no" default="#session.deptid#">			
			<cfset var txtmsglist = "" />
			<cfquery datasource="#application.dsn#" name="txtmsglist">
				select *
				  from messages
				 where msgtype = <cfqueryparam value="Text" cfsqltype="cf_sql_varchar" />
				   and companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
				   and active = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
				   <cfif isuserinrole("sls") or isuserinrole("counselor")>
				      and deptid = <cfqueryparam value="#arguments.deptid#" cfsqltype="cf_sql_integer" />
				   </cfif>
			  order by msgname asc
			</cfquery>			
			<cfreturn txtmsglist>		
		</cffunction>
		
		<cffunction name="gettextmessage" access="remote" returntype="query" output="false" hint="I get the text message detail for a text message in the system library.">			
			<cfargument name="msgid" required="yes" default="#url.msgid#">			
			<cfset var txtmsgdetail = "" />
			<cfquery datasource="#application.dsn#" name="txtmsgdetail">
				select *
				  from messages
				 where msgid = <cfqueryparam value="#arguments.msgid#" cfsqltype="cf_sql_integer" />		  
			</cfquery>			
			<cfreturn txtmsgdetail>		
		</cffunction>
	
	</cfcomponent>