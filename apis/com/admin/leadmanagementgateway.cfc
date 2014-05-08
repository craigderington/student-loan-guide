


		<cfcomponent displayname="leadmanagementgateway">
			
			<cffunction name="init" access="public" output="false" hint="I create an initialized instance of the lead management gateway object.">				
				<cfreturn this >			
			</cffunction>
			
			
			<cffunction name="getleadlist" access="public" output="false" hint="I get the list of all lead settings for the company to manage.">				
				<cfargument name="companyid" type="numeric" required="yes" default="#session.companyid#">
				<cfset var leadlist = "" />				
				<cfquery datasource="#application.dsn#" name="leadlist">	 
					select l.*, ls.leadsource
					  from leads l, leadsource ls
					 where l.leadsourceid = ls.leadsourceid					  
					   and l.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />					       
							
							<cfif structkeyexists( form, "filtermyresults" )>
								
								<cfif structkeyexists( form, "leadname" ) and form.leadname is not "" and form.leadname is not "filter by name">
									and	leadfirst + leadlast LIKE <cfqueryparam value="%#form.leadname#%" cfsqltype="cf_sql_varchar" />	
								</cfif>
								
								<cfif structkeyexists( form, "leaddate" ) and form.leaddate is not "" and form.leaddate is not "filter by date">
									and l.leaddate <= <cfqueryparam value="#form.leaddate#" cfsqltype="cf_sql_date" />
								</cfif>
								
								<cfif structkeyexists( form, "leadsource" ) and form.leadsource is not "" and form.leadsource is not "filter lead source">
									and l.leadsourceid = <cfqueryparam value="#form.leadsource#" cfsqltype="cf_sql_integer" />
								</cfif>
								
							</cfif>
							
					order by l.leadlast asc
				</cfquery>				
				<cfreturn leadlist>
			</cffunction>	
			
			
			
			<cffunction name="killallleaddata" access="public" returntype="string" output="false" hint="I kill all lead data...">
				<cfargument name="leadid" type="uuid" required="yes">
				<cfset var killstat = "" />
					
					<cfquery datasource="#application.dsn#" name="getleaddetail">
						select l.leadid, l.leaduuid, l.leadactive
						  from leads l
						 where l.leaduuid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_varchar" maxlength="35" />
					</cfquery>
					
						<cfif getleaddetail.recordcount eq 1>
						
							<!--- // begin purge --->
							<cfquery datasource="#application.dsn#" name="killleaddata">							
								delete 
								  from tasks 
								 where leadid = <cfqueryparam value="#getleaddetail.leadid#" cfsqltype="cf_sql_integer" />
							
								delete 
								  from solution 
								 where leadid = <cfqueryparam value="#getleaddetail.leadid#" cfsqltype="cf_sql_integer" />
							
								delete 
								  from slworksheet 
								 where leadid = <cfqueryparam value="#getleaddetail.leadid#" cfsqltype="cf_sql_integer" />
							
								delete 
								  from slanswer
								 where leadid = <cfqueryparam value="#getleaddetail.leadid#" cfsqltype="cf_sql_integer" />						
							
								delete 
								  from nslds
								 where leadid = <cfqueryparam value="#getleaddetail.leadid#" cfsqltype="cf_sql_integer" />						
							
								delete 
								  from notes
								 where leadid = <cfqueryparam value="#getleaddetail.leadid#" cfsqltype="cf_sql_integer" />
							
								delete 
								  from leadtasks
								 where leadid = <cfqueryparam value="#getleaddetail.leadid#" cfsqltype="cf_sql_integer" />
							
								delete 
								  from esign
								 where leadid = <cfqueryparam value="#getleaddetail.leadid#" cfsqltype="cf_sql_integer" />
								 
								delete 
								  from documents
								 where leadid = <cfqueryparam value="#getleaddetail.leadid#" cfsqltype="cf_sql_integer" />							
								
								delete 
								  from activity
								 where leadid = <cfqueryparam value="#getleaddetail.leadid#" cfsqltype="cf_sql_integer" />					
								
								delete 
								  from users
								 where leadid = <cfqueryparam value="#getleaddetail.leadid#" cfsqltype="cf_sql_integer" />
								 
								delete 
								  from slsummary
								 where leadid = <cfqueryparam value="#getleaddetail.leadid#" cfsqltype="cf_sql_integer" />
								
								delete 
								  from leads
								 where leadid = <cfqueryparam value="#getleaddetail.leadid#" cfsqltype="cf_sql_integer" />
									
							</cfquery>
							
							<cfset killstat = "success" />
						
						<cfelse>
						
							<!--- // if the lead ID can not be found, return false --->
							<cfset killstat = "killfail" />		
						
						
						</cfif>
		
					<cfreturn killstat>
		
			</cffunction>
			
			
			
			
			<cffunction name="getleaddetail" access="public" output="false" hint="I get the list of all lead settings for selected record.">
				<cfargument name="leadid" type="uuid" required="yes" default="">				
				<cfset var leaddetail = "" />				
				<cfquery datasource="#application.dsn#" name="leaddetail">	 
					select l.*, ls.leadsource
					  from leads l, leadsource ls
					 where l.leadsourceid = ls.leadsourceid					  
					   and l.leaduuid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_varchar" maxlength="35" />
				</cfquery>
				<cfreturn leaddetail>
			</cffunction>
			
			
			<cffunction name="getenrollmentcounselors" access="public" output="false" hint="I get the list of enrollment counselors for the company.">
				<cfargument name="companyid" type="numeric" required="yes" default="0">				
				<cfset var enrollmentcounselors = "" />				
				<cfquery datasource="#application.dsn#" name="enrollmentcounselors">	 
					select u.userid, u.firstname, u.lastname
					  from users u
					 where u.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
					   and u.role LIKE <cfqueryparam value="%counselor%" cfsqltype="cf_sql_varchar" />
				  order by u.lastname asc
				</cfquery>
				<cfreturn enrollmentcounselors>
			</cffunction>	
			
			<cffunction name="getintakeadvisors" access="public" output="false" hint="I get the list of intake advisors for the company.">
				<cfargument name="companyid" type="numeric" required="yes" default="0">				
				<cfset var intakeadvisors = "" />				
				<cfquery datasource="#application.dsn#" name="intakeadvisors">	 
					select u.userid, u.firstname, u.lastname
					  from users u
					 where u.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
					   and u.role LIKE <cfqueryparam value="%intake%" cfsqltype="cf_sql_varchar" />
				  order by u.lastname asc
				</cfquery>
				<cfreturn intakeadvisors>
			</cffunction>
			
			<cffunction name="getslsadvisors" access="public" output="false" hint="I get the list of sl specialists counselors for the company.">
				<cfargument name="companyid" type="numeric" required="yes" default="0">				
				<cfset var slsadvisors = "" />				
				<cfquery datasource="#application.dsn#" name="slsadvisors">	 
					select u.userid, u.firstname, u.lastname
					  from users u
					  where u.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
					   and u.role LIKE <cfqueryparam value="%sls%" cfsqltype="cf_sql_varchar" />
				  order by u.lastname asc
				</cfquery>
				<cfreturn slsadvisors>
			</cffunction>
			
			
			
			
			
			
			
		
		</cfcomponent>