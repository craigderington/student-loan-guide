


		<cfcomponent displayname="usergateway">
		
			<cffunction name="init" access="public" output="false" returntype="usergateway" hint="Returns an initialized user gateway function.">		
				<!--- // return This reference. --->
				<cfreturn this />
			</cffunction>
			
			<cffunction name="getloginhistory" access="remote" output="false" hint="I generate the list of user login dates and ip addresses">
				<cfargument name="userid" required="yes" type="numeric" default="#session.userid#">
				<cfset var qloginhistory = "" />
				<cfquery datasource="#application.dsn#" name="qloginhistory">
					select l.loginid, l.userid, l.logindate, l.loginip, l.username
					  from loginhistory l
					 where l.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
				  order by l.logindate desc 
				</cfquery>				
				<cfreturn qloginhistory>			
			</cffunction>

			<cffunction name="getloginsummary" access="public" output="false" hint="I get the users login history summary">
				<cfargument name="userid" default="#session.userid#" type="numeric" required="yes">
				<cfset var qloginsum = "" />
				<cfquery datasource="#application.dsn#" name="qloginsum">
					select loginip, count(*) as totallogins
					  from loginhistory
					 where userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
				  group by loginip
				</cfquery>
				<cfreturn qloginsum >
			</cffunction>
			
			
			<cffunction name="getloginsbymonth" access="public" output="false" hint="I get the users login history dates and summary">
				<cfargument name="userid" default="#session.userid#" type="numeric" required="yes">
				<cfset var qloginmonths = "" />
				<cfquery datasource="#application.dsn#" name="qloginmonths">
					select datepart(m, logindate) as thismonth,
						   datepart(yyyy, logindate) as thisyear,
					       count(*) as totalmonths
					  from loginhistory
					 where userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
				  group by datepart(m, logindate), datepart(yyyy, logindate)
				  order by datepart(m, logindate) asc
				</cfquery>
				<cfreturn qloginmonths >
			</cffunction>
			
			
			<cffunction name="getuserprofile" access="remote" output="false" hint="I get the user profile data.">
				<cfargument name="userid" required="yes" type="numeric" default="#session.userid#">				
				<cfset var quserprofile = "">
				<cfquery datasource="#application.dsn#" name="quserprofile">
					select username, firstname, lastname, passcode, email, txtmsgaddress, txtmsgprovider
					  from users
					 where userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />				
				</cfquery>				
				<cfreturn quserprofile>			
			</cffunction>
		
		
		</cfcomponent>