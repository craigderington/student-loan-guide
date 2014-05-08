

	<cfcomponent displayname="surveygateway">
	
		<cffunction name="init" access="public" output="false" returntype="surveygateway" hint="Returns an initialized survey gateway function.">		
			<!--- // return This reference. --->
			<cfreturn this />
		</cffunction>
		
		<cffunction name="getsurvey" access="remote" output="false" returntype="query" hint="I get the list of survey questions.">			
			<cfset var survey = "" />
			<cfquery datasource="#application.dsn#" name="survey1">
				select *
				  from slquestionnaire
				 where active = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
			  order by slqid asc 
			</cfquery>			
			<cfreturn survey1>			
		</cffunction>
		
		<cffunction name="getsurveydetail" access="remote" output="false" returntype="query" hint="I get the detail for a specific survey question.">			
			<cfargument name="slqid" default="#url.surveyid#" required="yes">			
			<cfset var surveydetail = "" />
			<cfquery datasource="#application.dsn#" name="surveydetail">
				select *
				  from slquestionnaire
				 where slqid = <cfqueryparam value="#arguments.slqid#" cfsqltype="cf_sql_integer" />			  
			</cfquery>			
			<cfreturn surveydetail>			
		</cffunction>		
		
		<cffunction name="getQ13" access="remote" output="false" returntype="query" hint="I get the list of jobs types for survey question 13.">	
			<cfset var Q13 = "" />
			<cfquery datasource="#application.dsn#" name="Q13">
				   select jobtypeid, jobtypecat, jobtype, active
					 from jobtypes
					where active = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
				 order by jobtypecat asc
			</cfquery>			
			<cfreturn Q13>			
		</cffunction>
		
		<cffunction name="getQ15" access="remote" output="false" returntype="query" hint="I get the list of perkins cancel jobs types for survey question 15.">	
			<cfset var Q15 = "" />
			<cfquery datasource="#application.dsn#" name="Q15">
				   select perkinscancelid, perkinscanceljob, perkinscat3a, perkinscat3b, perkinscancelm, perkinscanceln
					 from perkinscancel
				 order by perkinscanceljob
			</cfquery>			
			<cfreturn Q15>			
		</cffunction>
		
		<cffunction name="getQ16" access="remote" output="false" returntype="query" hint="I get the list of perkins deferments pre 1980 for survey question 16.">	
			<cfset var Q16 = "" />
			<cfquery datasource="#application.dsn#" name="Q16">
				  select conditionid, condition
					from conditions
				   where perkinspre80 = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
				order by condition asc
			</cfquery>			
			<cfreturn Q16>			
		</cffunction>
		
		<cffunction name="getQ17" access="remote" output="false" returntype="query" hint="I get the list of perkins deferments 1980-1987 for survey question 17.">	
			<cfset var Q17 = "" />
			<cfquery datasource="#application.dsn#" name="Q17">
				  select conditionid, condition
					from conditions
				   where perkins8087 = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
				order by condition asc
			</cfquery>			
			<cfreturn Q17>			
		</cffunction>
		
		<cffunction name="getQ18" access="remote" output="false" returntype="query" hint="I get the list of perkins deferments 1987-1993 for survey question 18.">	
			<cfset var Q18 = "" />
			<cfquery datasource="#application.dsn#" name="Q18">
				  select conditionid, condition
					from conditions
				   where perkins8793 = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
				order by condition asc
			</cfquery>			
			<cfreturn Q18>			
		</cffunction>
		
		<cffunction name="getQ19" access="remote" output="false" returntype="query" hint="I get the list of perkins deferments after 1993 for survey question 19.">	
			<cfset var Q19 = "" />
			<cfquery datasource="#application.dsn#" name="Q19">
				  select conditionid, condition
					from conditions
				   where perkinsafter93 = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
				order by condition asc
			</cfquery>			
			<cfreturn Q19>			
		</cffunction>
		
		<cffunction name="getQ20" access="remote" output="false" returntype="query" hint="I get the list of jobs for survey question 20.">	
			<cfset var Q20 = "" />
			<cfquery datasource="#application.dsn#" name="Q20">
				select defertypeid, defertype, deferquestion, defermax, subcat1, subcat2, subcat4, subcat6a, subcat6b, subcat6c
				  from defertypes
				 where deferquestion = <cfqueryparam value="20" cfsqltype="cf_sql_numeric" />
			  order by defertype asc 
			</cfquery>			
			<cfreturn Q20>			
		</cffunction>
		
		<cffunction name="getQ21" access="remote" output="false" returntype="query" hint="I get the list of jobs for survey question 21.">	
			<cfset var Q21 = "" />
			<cfquery datasource="#application.dsn#" name="Q21">
				select defertypeid, defertype, deferquestion, defermax, subcat1, subcat2, subcat4, subcat6a, subcat6b, subcat6c
				  from defertypes
				 where deferquestion = <cfqueryparam value="21" cfsqltype="cf_sql_numeric" />
			  order by defertype asc
			</cfquery>			
			<cfreturn Q21>			
		</cffunction>
		
		<cffunction name="getQ22" access="remote" output="false" returntype="query" hint="I get the list of jobs for survey question 22.">	
			<cfset var Q22 = "" />
			<cfquery datasource="#application.dsn#" name="Q22">
				select defertypeid, defertype, deferquestion, defermax, subcat1, subcat2, subcat4, subcat6a, subcat6b, subcat6c
				  from defertypes
				 where deferquestion = <cfqueryparam value="22" cfsqltype="cf_sql_numeric" />
			  order by defertype asc
			</cfquery>			
			<cfreturn Q22>			
		</cffunction>
		
		<cffunction name="getQ23" access="remote" output="false" returntype="query" hint="I get the list of forbearance types for survey question 23.">	
			<cfset var Q23 = "" />
			<cfquery datasource="#application.dsn#" name="Q23">
				select forbearid, forbeartype, duration, maxtime, subcat1, subcat2, subcat4
				  from forbearance
			  order by forbeartype asc 
			</cfquery>			
			<cfreturn Q23>			
		</cffunction>
		
		<cffunction name="getQ31" access="remote" output="false" returntype="query" hint="I get the list of forbearance types for survey question 31.">	
			<cfset var Q31 = "" />
			<cfquery datasource="#application.dsn#" name="Q31">
				select forbearcat5id, forbearcat5type, maxtime, subcat5
				  from forbearcat5
			  order by forbearcat5type asc 
			</cfquery>			
			<cfreturn Q31>			
		</cffunction>
	
	</cfcomponent>