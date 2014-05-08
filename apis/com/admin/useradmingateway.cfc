

		<cfcomponent displayname="useradmingateway">
			
			<cffunction name="init" access="public" output="false" returntype="useradmingateway" hint="I create an initialized instance of the user gateway object.">				
				<cfreturn this >			
			</cffunction>		
		
			<cffunction name="getusers" access="public" output="false" hint="I get the list of users for the company.">
				<cfargument name="companyid" default="#session.companyid#">				
				<cfset var userlist = "" />
				<cfquery datasource="#application.dsn#" name="userlist">
					select u.userid, u.useruuid, u.deptid, u.username, u.passcode, u.firstname, u.lastname, u.acl, u.role, u.active, 
						   u.lastlogindate, u.lastloginip, u.email, d.deptname, c.companyname
					  from users u, dept d, company c
					 where u.deptid = d.deptid
					   and u.companyid = c.companyid
					   and u.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
					   
					   
						    <cfif structkeyexists( form, "filtermyresults" )>
						   
								<cfif structkeyexists( form, "userlist" ) and form.userlist is not "" and trim( form.userlist ) is not "select user">
									and u.userid = <cfqueryparam value="#form.userlist#" cfsqltype="cf_sql_integer" />
								</cfif>
								
								<cfif structkeyexists( form, "username" ) and form.username is not "" and trim( form.username ) is not "filter by name">
									and u.firstname + u.lastname LIKE <cfqueryparam value="%#form.username#%" cfsqltype="cf_sql_varchar" />
								</cfif>
								
								<cfif structkeyexists( form, "userroles" ) and form.userroles is not "" and trim( form.userroles ) is not "filter by role">
									and u.role LIKE <cfqueryparam value="%#form.userroles#%" cfsqltype="cf_sql_varchar" />
								</cfif>				   
						   
						    </cfif>				   
					   
				  order by u.lastname asc 
				</cfquery>
				<cfreturn userlist >
			</cffunction>		
			
			
			<cffunction name="getuser" access="public" output="false" hint="I get the user detail info for user management.">
				<cfargument name="userid" default="#url.uid#">				
				<cfset var userdetail = "" />
				<cfquery datasource="#application.dsn#" name="userdetail">
					select u.userid, u.useruuid, u.deptid, u.username, u.passcode, u.firstname, u.lastname, u.acl, u.role, 
						   u.active, u.lastlogindate, u.lastloginip, u.email, d.deptname
					  from users u, dept d
					 where u.deptid = d.deptid
					   and u.useruuid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_varchar" maxlength="35" />				  
				</cfquery>
				<cfreturn userdetail >
			</cffunction>
			
		</cfcomponent>