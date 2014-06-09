


		<cfcomponent displayname="assigngateway">
		
			<cffunction name="init" access="public" output="false" returntype="clientgateway" hint="Returns an initialized client assignment gateway function.">		
				<!--- // return This reference. --->
				<cfreturn this />
			</cffunction>
			
			
			<cffunction name="getallassignments" access="public" output="false" hint="I get the list of all client assignments.">
				<cfargument name="userid" default="#session.userid#" type="numeric">
				<cfset var clientassignments = "" />
				<cfquery datasource="#application.dsn#" name="clientassignments">
					select la.leadassignid, la.leadassigndate, la.leadassignleadid, la.leadassignuserid, la.leadassignrole, la.leadassignaccept,
					       la.leadassignacceptdate, la.leadassigntransfer, la.leadassigntransfertoid,
					       l.leaduuid, l.leadfirst, l.leadlast
				      from leadassignments la, leads l
				     where la.leadassignleadid = l.leadid
				       and la.leadassignuserid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />				       
				  order by la.leadassigndate desc 
				</cfquery>
				<cfreturn clientassignments >
			</cffunction>
			
			
			<cffunction name="assignintake" output="false" access="remote" hint="I get the list of intake counselors for lead assignement.">			
				<cfargument name="companyid" required="yes" default="#session.companyid#" type="numeric">			
				<cfargument name="leadid" required="yes" default="#session.leadid#" type="numeric">
								
					<!--- // query our datasource for the intake counselors --->				
					<cfquery datasource="#application.dsn#" name="intakers">
						select top 1 u.userid, u.role, u.email
						  from users u
						 where companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
						   and role LIKE <cfqueryparam value="%intake%" cfsqltype="cf_sql_varchar" />
					  order by rand((1000*u.userID)*datepart(millisecond, getDate()))
					</cfquery>

					<!--- // check existing lead assignments --->
					<cfquery datasource="#application.dsn#" name="checkintake">
						select leadassignid, leadassignuserid, leadassignleadid, leadassignrole
						  from leadassignments
						 where leadassignleadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
						   and leadassignrole = <cfqueryparam value="intake" cfsqltype="cf_sql_varchar" />
					</cfquery>
					
					<cfif checkintake.recordcount eq 0>					
						<!--- // now that we have a valid intake user id, assign the intake advisor to the lead --->
						<cfquery datasource="#application.dsn#" name="assignuser">
							insert into leadassignments(leadassigndate,leadassignleadid,leadassignuserid,leadassignrole)
								values(
									   <cfqueryparam value="#createodbcdatetime( now() )#" cfsqltype="cf_sql_timestamp" />,
									   <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />,
									   <cfqueryparam value="#intakers.userid#" cfsqltype="cf_sql_integer" />,
									   <cfqueryparam value="intake" cfsqltype="cf_sql_varchar" />
									  );
						</cfquery>

						<cfquery datasource="#application.dsn#" name="leaddetail">
							select l.leadfirst, l.leadlast
							  from leads l
							 where l.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
						</cfquery>
						
						<cfquery datasource="#application.dsn#" name="companyinfo">
							select l.leadid, c.companyid, c.companyname, c.email
							  from leads l, company c
							 where l.companyid = c.companyid
							   and l.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
						</cfquery>
						
						<!--- // send the formatted email to the intake advisor --->
						<cfmail from="#companyinfo.email# (#companyinfo.companyname#)" to="#intakers.email#" subject="SLA - New Client Assignment" type="HTML"><h2>*** AUTOMATED SYSTEM MESSAGE *** DO NOT REPLY ***</h2>
	<br /><br />											
	<p>You have been assigned a new client file.  Please login to the <a href="http://www.studentloanadvisoronline.com/">Student Loan Advisor Online</a> system to check the status of this new assignment. Details below.</p> 
	<br />												
	<cfoutput>
	<p>Client ID:  #session.leadid# <br />
	Client Name:  #leaddetail.leadfirst# #leaddetail.leadlast#</p>
	</cfoutput>
	<br /><br/><br /><br />
	<p>Please follow up with the client to complete the intake process.</p>
	<br /><br />
	
	<p><a href="http://www.studentloanadvisoronline.com/">Log In Now...</a></p>
	
	
	
	
	
	
	<p>This message was auto-generated from the Student Loan Advisor website on #dateformat( now(), "mm/dd/yyyy" )# at #timeformat( now(), "hh:mm tt" )#. </p> 
														
						</cfmail>

						
					</cfif>
						
			</cffunction>
			
			
			
			<cffunction name="assignsls" output="false" access="remote" hint="I get the list of SLS advisors for the lead assignement.">			
				<cfargument name="companyid" required="yes" default="#session.companyid#" type="numeric">			
				<cfargument name="leadid" required="yes" default="#session.leadid#" type="numeric">
								
					<!--- // query our datasource for the intake counselors --->				
					<cfquery datasource="#application.dsn#" name="slslist">
						select top 1 u.userid, u.role, u.email
						  from users u
						 where companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
						   and role LIKE <cfqueryparam value="%sls%" cfsqltype="cf_sql_varchar" />
					  order by rand((1000*u.userID)*datepart(millisecond, getDate()))
					</cfquery>

					<!--- // check existing lead assignments --->
					<cfquery datasource="#application.dsn#" name="checksls">
						select leadassignid, leadassignuserid, leadassignleadid, leadassignrole
						  from leadassignments
						 where leadassignleadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
						   and leadassignrole = <cfqueryparam value="sls" cfsqltype="cf_sql_varchar" />
					</cfquery>
					
					<cfif checksls.recordcount eq 0>					
						<!--- // now that we have a valid sls advisor user id, assign the sls advisor to the lead --->
						<cfquery datasource="#application.dsn#" name="assignuser">
							insert into leadassignments(leadassigndate,leadassignleadid,leadassignuserid,leadassignrole)
								values(
									   <cfqueryparam value="#createodbcdatetime( now() )#" cfsqltype="cf_sql_timestamp" />,
									   <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />,
									   <cfqueryparam value="#slslist.userid#" cfsqltype="cf_sql_integer" />,
									   <cfqueryparam value="sls" cfsqltype="cf_sql_varchar" />
									  );
						</cfquery>

						<cfquery datasource="#application.dsn#" name="leaddetail">
							select l.leadfirst, l.leadlast
							  from leads l
							 where l.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
						</cfquery>
						
						<!--- // send the formatted email to the intake advisor --->
						<cfmail from="#GetAuthUser()#" to="#slslist.email#" subject="SLA - New Client Assignment" type="HTML"><h2>*** AUTOMATED SYSTEM MESSAGE *** DO NOT REPLY ***</h2>
	<br /><br />											
	<p>You have been assigned a new client file.  Please login to the <a href="http://www.studentloanadvisoronline.com/">Student Loan Advisor Online</a> system to check the status of this new assignment. Details below.</p> 
	<br />												
	<cfoutput>
	<p>Client ID:  #session.leadid# <br />
	Client Name:  #leaddetail.leadfirst# #leaddetail.leadlast#</p>
	</cfoutput>
	<br /><br/><br /><br />
	<p>Please follow up with the client to complete the Student Loan Advisor process.</p>
	<br /><br />
	
	<p><a href="http://www.studentloanadvisoronline.com/">Log In Now...</a></p>
	
	
	
	
	
	
	<p>This message was auto-generated from the Student Loan Advisor website on #dateformat( now(), "mm/dd/yyyy" )# at #timeformat( now(), "hh:mm tt" )#. </p> 
														
						</cfmail>

						
					</cfif>
						
			</cffunction>
		
			
		
		
		
		</cfcomponent>