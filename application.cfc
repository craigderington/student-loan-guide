<cfcomponent
	displayname="Application"
	output="true"
	hint="Handle the application.">	
	
	<!--- Setup the application --->
	<cfscript>
       this.name = hash( getcurrenttemplatepath() );
       this.applicationTimeout = createtimespan(1,0,0,0);
       this.clientmanagement = "true";       
       this.sessionmanagement = "true";
       this.sessiontimeout = createtimespan(0,23,59,0);
       this.loginstorage = "session";
	   this.setclientcookies = "false";       
       this.scriptprotect = "all";    
   </cfscript>
	
 
	<!--- Define the page request properties. --->
	<cfsetting
		requesttimeout="120"
		showdebugoutput="true"
		enablecfoutputonly="false"
		/>
 
 
	<cffunction
		name="OnApplicationStart"
		access="public"
		returntype="boolean"
		output="false"
		hint="Fires when the application is first created.">	
		
		 <cfscript>
			//set your app vars for the application          
			application.dsn = "SLAdmin";
			application.title = "Student Loan Advisor Online";
			application.developer = "eFiscal Networks, LLC.";
			application.bootver = "v 2.3.1";
			application.softver = "v 1.0.1 Beta";
			application.root = "index.cfm";
			application.sessions = 0;
		</cfscript>
		
		<cftry>
            <!--- Test whether the DB is accessible by selecting some data. --->
            <cfquery name="testdb" datasource="#application.dsn#" maxrows="2">
                select count(userid) 
                  from users
            </cfquery>
            <!--- If we get a database error, report an error to the user, log the error information, and do not start the application. --->
            <cfcatch type="database">
                <cflog file="#this.name#" type="error" 
                     text="DB not available. message: #cfcatch.message# Detail: #cfcatch.detail# Native Error: #cfcatch.NativeErrorCode#" >
            
                <cfthrow message="This application encountered an error connecting to the database. Please contact support." />      
            
                <cfreturn false>
            </cfcatch>
       </cftry>
       
       <cflog file="#this.name#" type="Information" text="Application #this.name# Started">
 
		<!--- Return out. --->
		<cfreturn true />
	</cffunction>
 
 
	<cffunction
		name="OnSessionStart"
		access="public"
		returntype="void"
		output="false"
		hint="Fires when the session is first created.">
			
			
			<!--- Store date the session was created. --->
			<cfset session.dateInitialized = now() />
			
			
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
 
 
	<cffunction
		name="OnRequestStart"
		access="public"
		returntype="boolean"
		output="false"
		hint="Fires at first part of page processing.">
 
		<!--- Define arguments. --->
		<cfargument
			name="TargetPage"
			type="string"
			required="true"
			/>			
			
			<!--- // if the URL query string contains a reinit param, restart all application vars --->
			<cfif structkeyexists( url, "reinit" ) and url.reinit is "true" >
				<cfset onApplicationStart() />
			</cfif>
		
			<cflogin>
				<cfif NOT IsDefined("cflogin")>
					<cfinclude template="login.cfm">
					<cfabort>
				<cfelse>
					<cfif cflogin.name IS "" OR cflogin.password IS "">
						<cfset REQUEST.badlogin = true />
						<cfinclude template="login.cfm">
						<cfabort>
					<cfelse>
						<cfquery datasource="#application.dsn#" name="loginquery">
							SELECT u.userid, u.username, u.passcode, u.role, u.firstname, u.lastname, 
							       u.acl, u.deptid, c.companyid, c.dba, u.lastlogindate, u.lastloginip, 
								   d.deptname, c.advisory, c.implement, u.leadid
							  FROM users u, company c, dept d
							 WHERE u.companyid = c.companyid
							   AND u.deptid = d.deptid
							   AND u.username = <cfqueryparam value="#cflogin.name#" cfsqltype="cf_sql_varchar" />
							   AND u.passcode = <cfqueryparam value="#hash( cflogin.password, "SHA-384", "UTF-8" )#" cfsqltype="cf_sql_clob" maxlength="255" />
							   AND u.active = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
							   AND c.active = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
						</cfquery>
						<cfif loginquery.userid NEQ "">
							<cfloginuser 
								name = "#cflogin.name#" 
								password = "#cflogin.password#" 
								roles="#loginquery.role#">
								
								<!--- Start a few session vars we will require for our queries --->
								<cfset session.companyid = #loginquery.companyid# />
								<cfset session.companyname = "#loginquery.dba#" />
								<cfset session.userid = #loginquery.userid# />
								<cfset session.deptid = #loginquery.deptid# />
								<cfset session.username = "#loginquery.firstname# #loginquery.lastname#" />
								<cfset session.acl = #loginquery.acl# />
								<cfset session.lastip = "#loginquery.lastloginip#" />
								<cfset session.lastdate = "#loginquery.lastlogindate#" />
								<cfset session.deptname = "#loginquery.deptname#" />								
								<cfset session.welcomehomesess = 0 />								

								<cfif loginquery.advisory eq 1 and loginquery.implement eq 1>
									<cfset session.companyforms = true />
								</cfif>							
								
								<!--- // if the role is bClient, then get the host company name to display in the header --->
								<!--- // co-brand the client portal website --->
								<cfif loginquery.role is "bClient">
									<cfif loginquery.leadid neq 0>
										<cfquery datasource="#application.dsn#" name="clientcompany">
											select l.leadid, c.companyid, c.dba
											  from leads l, company c
											 where l.companyid = c.companyid
											   and l.leadid = <cfqueryparam value="#loginquery.leadid#" cfsqltype="cf_sql_integer" />
										</cfquery>
										<cfset session.companyname = "#clientcompany.dba#" />
									</cfif>
								</cfif>
								
								<!--- Log this users activity to the database ---> 
								<cfquery datasource="#application.dsn#" name="logUser">
									update users
									   set lastlogindate = <cfqueryparam value="#CreateODBCDateTime(Now())#" cfsqltype="cf_sql_timestamp" />,
									       lastloginip = <cfqueryparam value="#cgi.remote_addr#" cfsqltype="cf_sql_varchar" />
									 where userid = <cfqueryparam value="#loginquery.userid#" cfsqltype="cf_sql_integer" />									   
						        </cfquery>
							   
							    <!--- Log this users activity to the login history table ---> 
								<cfquery datasource="#application.dsn#" name="logUser">
									   insert into loginhistory(userid, logindate, loginip, username)
											 values(
													<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer" />, 
													<cfqueryparam value="#CreateODBCDateTime(Now())#" cfsqltype="cf_sql_timestamp" />, 
													<cfqueryparam value="#cgi.remote_addr#" cfsqltype="cf_sql_varchar" />, 
													<cfqueryparam value="#session.username#" cfsqltype="cf_sql_varchar" />												
													);
									 									   
						       </cfquery>						   		   
						<cfelse>
							<cfset REQUEST.badlogin = true />    
							<cfinclude template="login.cfm">
							<cfabort>
						</cfif>
					</cfif>    
				</cfif>
			</cflogin>
		
			<cfif GetAuthUser() NEQ "">
				<cfoutput>
					 <form action="securitytest.cfm" method="Post">
						<input type="submit" Name="Logout" value="Logout">
					</form>
				</cfoutput>
			</cfif>	
		
		<!--- Return out. --->
		<cfreturn true />
	</cffunction>
 
 
	<cffunction
		name="OnRequest"
		access="public"
		returntype="void"
		output="true"
		hint="Fires after pre page processing is complete.">
 
		<!--- Define arguments. --->
		<cfargument
			name="TargetPage"
			type="string"
			required="true"
			/>
 
		<!--- Include the requested page. --->
		<cfinclude template="#ARGUMENTS.TargetPage#" />
 
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
 
 
	<cffunction
		name="OnRequestEnd"
		access="public"
		returntype="void"
		output="true"
		hint="Fires after the page processing is complete."> 
		
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
 
 
	<cffunction
		name="OnSessionEnd"
		access="public"
		returntype="void"
		output="false"
		hint="Fires when the session is terminated.">
 
		<!--- Define arguments. --->
		<cfargument
			name="sessionScope"
			type="struct"
			required="true"
			/>			
			
		<cfargument
			name="applicationScope"
			type="struct"
			required="false"
			default="#StructNew()#"
			/>
			
		<!--- output the cfid and cftoken values to the log. --->
		<cffile
			action="append"
			file="#getDirectoryFromPath( getCurrentTemplatePath() )#log.cfm"
			output="ENDED: #arguments.sessionScope.cfid#<br />"
			/>			
			
				
		<!--- Return out. --->
		<cfreturn />
	</cffunction>	
 
	<cffunction
		name="OnApplicationEnd"
		access="public"
		returntype="void"
		output="false"
		hint="Fires when the application is terminated.">
 
		<!--- Define arguments. --->
		<cfargument
			name="ApplicationScope"
			type="struct"
			required="false"
			default="#StructNew()#">	
 
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
 
 
	<cffunction
		name="OnError"
		access="public"
		returntype="void"
		output="true"
		hint="Fires when an exception occures that is not caught by a try/catch.">
 
		<!--- Define arguments. --->
		<cfargument
			name="Exception"
			type="any"
			required="true"			
			/>
 
		<cfargument
			name="EventName"
			type="string"
			required="false"
			default=""
			/>			
			
			<!--- log the error 
			<cfif cgi.server_name neq "localhost" and cgi.server_name neq "127.0.0.1">
				<!--- // if this is the live production server, handle the error --->
				<cfinclude template="cferror.cfm">
					<cflog file="#this.name#" type="error" text="Event Name: #arguments.eventname#" >
					<cflog file="#this.name#" type="error" text="Message: #arguments.exception.message#">
					<cflog file="#this.name#" type="error" text="Root Cause Message: #arguments.exception.rootcause.message#">			
			<cfelse>
				<cfif len( arguments.eventname )>
					<cfdump var="#arguments.eventname#" label="Error Event Name"/>
				</cfif>
				<cfdump var="#arguments.exception#" label="Error Exception" />			
			</cfif>
			
			--->
			
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
 
</cfcomponent>