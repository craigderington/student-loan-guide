

	<cfcomponent displayname="solutiongateway">
	
		<cffunction name="init" access="public" output="false" returntype="solutiongateway" hint="Returns an initialized solution gateway function.">		
			<!--- // return This reference. --->
			<cfreturn this />
		</cffunction>
			
		<cffunction name="getsolutionnotes" access="remote" output="false" hint="I get the list of solutioon notes.">
			<cfargument name="tree" default="#url.tree#" type="numeric" required="yes">
			<cfargument name="solution" default="#url.solution#" type="any" required="yes">
				<cfset var solutionnotes = "" />
				<cfquery datasource="#application.dsn#" name="solutionnotes">
					select solutionnoteid, solutiontree, solutionoption, solutionnotetext
					  from solutionnotes
					 where solutiontree LIKE <cfqueryparam value="%#arguments.tree#%" cfsqltype="cf_sql_varchar" />
					   and solutionoption LIKE <cfqueryparam value="%#arguments.solution#%" cfsqltype="cf_sql_varchar" />
				</cfquery>				
			<cfreturn solutionnotes >
		</cffunction>
		
		
		<cffunction name="getloancodes" access="remote" output="false" hint="I get the list of loans codes for each solution type.">			
			<cfargument name="tree" default="#url.tree#" required="yes" type="any">		
			<cfset var loancodelist = "" />			
			
			<cfif arguments.tree eq 1 >
				<cfset loancodelist = "D,L,I,AC,AD" />
			<cfelseif arguments.tree eq 2>
				<cfset loancodelist = "A,B,C,G,H,O,P,S,J,AB,AF" />		
			<cfelseif arguments.tree eq 3>
				<cfset loancodelist = "F,M,N,AE" />
			<cfelseif arguments.tree eq 4>
				<cfset loancodelist = "E,K,V" />
			<cfelseif arguments.tree eq 5>
				<cfset loancodelist = "Q,R,Y,Z" />
			<cfelseif arguments.tree eq 6>
				<cfset loancodelist = "T,U,X" />
			<cfelseif arguments.tree eq 7>
				<cfset loancodelist = "AA" />		
			</cfif>			
			
			<cfreturn loancodelist>			
		</cffunction>
		
		
		<cffunction name="getsolutiontypes" access="remote" output="false" hint="I get the list of solution type.">			
			<cfargument name="option" default="#url.option#" required="yes" type="any">
			<cfargument name="solution" default="#url.solution#" required="yes" type="any">
			
			<cfset solutiontype = structnew() />						
			
				<!--- // Option Tree --->
				<cfif arguments.option is "cancel">
					<cfset optiontype = "Cancellation" />
				<cfelseif arguments.option is "forgive">
					<cfset optiontype = "Forgiveness" />
				<cfelseif arguments.option is "default">
					<cfset optiontype = "Default Intervention" />
				<cfelseif arguments.option is "bk">
					<cfset optiontype = "Bankruptcy" />
				<cfelseif arguments.option is "repay">
					<cfset optiontype = "Repayment Plan" />
				<cfelseif arguments.option is "oic">
					<cfset optiontype = "Offer In Compromise" />
				<cfelseif arguments.option is "post">
					<cfset optiontype = "Postponement" />
				<cfelse>
					<cfset optiontype = "" />
				</cfif>
				
				<!--- Solution Types --->
				<cfif arguments.solution is "school">
					<cfset soltype = "Closed School" />
				<cfelseif arguments.solution is "death">
					<cfset soltype = "Death" />
				<cfelseif arguments.solution is "disability">
					<cfset soltype = "Disability" />
				<cfelseif arguments.solution is "atb">
					<cfset soltype = "Ability to Benefit" />
				<cfelseif arguments.solution is "refund">
					<cfset soltype = "Unpaid Refund" />
				<cfelseif arguments.solution is "911">
					<cfset soltype = "9/11" />
				<cfelseif arguments.solution is "cert">
					<cfset soltype = "False Certification" />
				<cfelseif arguments.solution is "age">
					<cfset soltype = "Legal Age" />
				<cfelseif arguments.solution is "mixed">
					<cfset soltype = "Mixed Use Loans" />
				<cfelseif arguments.solution is "ftc">
					<cfset soltype = "FTC Holder Rule" />
				<cfelseif arguments.solution is "theft">
					<cfset soltype = "Identity Theft" />
				<cfelseif arguments.solution is "statute">
					<cfset soltype = "Statute of Limitations on Collections" />
				<cfelseif arguments.solution is "debtval">
					<cfset soltype = "Debt Validation" />
				<cfelseif arguments.solution is "pslf">
					<cfset soltype = "Public Service Loan" />
				<cfelseif arguments.solution is "tlf">
					<cfset soltype = "Teacher Loan" />
				<cfelseif arguments.solution is "oc">
					<cfset soltype = "Occupational" />
				<cfelseif arguments.solution is "to">
					<cfset soltype = "Tax Offset" />
				<cfelseif arguments.solution is "wg">
					<cfset soltype = "Wage Garnishment" />
				<cfelseif arguments.solution is "rehab">
					<cfset soltype = "Rehabilitation" />
				<cfelseif arguments.solution is "consol">
					<cfset soltype = "Consolidation" />
				<cfelseif arguments.solution is "nonconsol">
					<cfset soltype = "Non-Consolidation" />
				<cfelseif arguments.solution is "hardship">
					<cfset soltype = "Hardship Eligibility" />
				<cfelseif arguments.solution is "mod">
					<cfset soltype = "Modifications" />
				<cfelseif arguments.solution is "ext">
					<cfset soltype = "Extensions" />
				<cfelseif arguments.solution is "forbear">
					<cfset soltype = "Forbearance" />
				<cfelseif arguments.solution is "defer">
					<cfset soltype = "Deferment" />				
				<cfelseif arguments.solution is "oic">
					<cfset soltype = "Offer in Compromise" />
				<cfelseif arguments.solution is "bk">
					<cfset soltype = "Bankruptcy" />
				<cfelse>
					<cfset soltype = "" />
				</cfif>			
			
			<cfset optiontype = structinsert( solutiontype, "optiontype", optiontype ) />
			<cfset soltype = structinsert( solutiontype, "soltype", soltype ) />		
			
			<cfreturn solutiontype >			
		</cffunction>
		
		
		<cffunction name="getsolutions" access="remote" output="false" hint="I get the list of chosen client solutions.">			
			<cfargument name="leadid" default="#session.leadid#" type="numeric">			
			<cfquery datasource="#application.dsn#" name="solutionlist">
				select s.solutionid, s.solutionuuid, s.leadid, s.solutiondate, s.solutionoptiontree, s.solutionoption, s.solutionworksheetid, 
				       s.solutionnotes, s.solutionselectedby, s.solutionsubcat, srv.servid, srv.servname, 
					   sl.loanbalance, sl.acctnum, sl.attendingschool, sl.servname as nslservicer, 
					   sl.intrate, sl.active, sl.incconsol, u.firstname, u.lastname
				  from solution s, slworksheet sl, servicers srv, users u
				 where s.solutionworksheetid = sl.worksheetid
				   and s.solutionselectedby = u.userid
				   and sl.servicerid = srv.servid
				   and sl.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
				   and s.solutioncompdate is null
				   and s.solutioncompleted <> <cfqueryparam value="1" cfsqltype="cf_sql_bit" />				   
			</cfquery>			
			<cfreturn solutionlist >		
		</cffunction>



		<cffunction name="getsolutiondetails" access="remote" output="false" hint="I get the selected client student loan solution detail.">			
			<cfargument name="sid" default="#url.sid#" type="uuid">			
			<cfset var solutiondetails = "" />
			<cfquery datasource="#application.dsn#" name="solutiondetails">
				select s.solutionid, s.solutionuuid, s.leadid, s.solutiondate, s.solutionoptiontree, s.solutionoption, s.solutionsubcat, 
				       s.solutionworksheetid, s.solutionnotes, s.solutionselectedby, sl.statuscodeid, srv.servid, sl.servname as nslservicer,			  
					   srv.servname, sl.loanbalance, sl.acctnum, sl.intrate, u.firstname, u.lastname
				  from solution s, slworksheet sl, servicers srv, users u
				 where s.solutionworksheetid = sl.worksheetid
				   and s.solutionselectedby = u.userid
				   and sl.servicerid = srv.servid
				   and s.solutionuuid = <cfqueryparam value="#arguments.sid#" cfsqltype="cf_sql_varchar" maxlength="35" />
			</cfquery>			
			<cfreturn solutiondetails >			
		</cffunction>
		
		
		<cffunction name="getsolutiontasks" access="remote" output="false" hint="I get the selected student loan solution follow up task list.">			
			<cfargument name="sid" default="#url.sid#" type="uuid">			
			<cfset var solutiontasks = "" />
			<cfquery datasource="#application.dsn#" name="solutiontasks">
				select s.solutionid, s.solutionuuid, s.leadid, s.solutiondate, s.solutionoptiontree, s.solutionoption, s.solutionworksheetid, 
				       s.solutionnotes, s.solutionselectedby,
					   st.solutiontaskid, st.soltaskname, st.soltaskdate, st.soltaskcompdate
				  from solution s, solutiontasks st
				 where s.solutionid = st.solutionid				   
				   and s.solutionuuid = <cfqueryparam value="#arguments.sid#" cfsqltype="cf_sql_varchar" maxlength="35" />
			</cfquery>			
			<cfreturn solutiontasks >			
		</cffunction>
		
		
		<cffunction name="getsolutionsforpresentation" access="remote" returntype="query" output="false" hint="I get the list of chosen client solutions for the client presentation document.">			
			<cfargument name="leadid" default="#session.leadid#" type="numeric" required="yes">
			<cfargument name="solcomp" default="0" required="yes">
			<cfset var solutionpresent = "" />
			<cfquery datasource="#application.dsn#" name="solutionpresent">
				select s.solutionid, s.solutionuuid, s.leadid, s.solutiondate, s.solutionoptiontree, s.solutionoption, s.solutionnotes,
				       s.solutionsubcat, s.solutionworksheetid, srv.servname, sl.acctnum,
					   sl.statuscodeid, srv.servid, sl.servname as nslservicer			  
				  from solution s, slworksheet sl, servicers srv
				 where s.solutionworksheetid = sl.worksheetid
				   and sl.servicerid = srv.servid
				   and s.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
				   and s.solutioncompleted = <cfqueryparam value="#arguments.solcomp#" cfsqltype="cf_sql_bit" />
				   and s.solutioncompdate is null				   
			</cfquery>			
			<cfreturn solutionpresent >		
		</cffunction>		
		
		
		<cffunction name="getcompletedsolutions" access="remote" returntype="query" output="false" hint="I get the list of completed client solutions for the final page.">			
			<cfargument name="leadid" default="#session.leadid#" type="numeric" required="yes">
			<cfargument name="solcomp" default="1" required="yes">
			<cfset var completedsolutions = "" />
			<cfquery datasource="#application.dsn#" name="completedsolutions">
				select s.solutionid, s.solutionuuid, s.leadid, s.solutiondate, s.solutionoptiontree, s.solutionoption, s.solutionnotes,
				       s.solutionsubcat, s.solutionworksheetid, srv.servname, sl.acctnum, sl.statuscodeid, lc.codedescr,
					   srv.servid, sl.servname as nslservicer			  
				  from solution s, slworksheet sl, servicers srv, loancodes lc
				 where s.solutionworksheetid = sl.worksheetid
				   and sl.servicerid = srv.servid
				   and sl.loancodeid = lc.loancodeid
				   and s.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
				   and s.solutioncompleted = <cfqueryparam value="#arguments.solcomp#" cfsqltype="cf_sql_bit" />
				   and s.solutioncompdate is not null				   
			</cfquery>			
			<cfreturn completedsolutions >		
		</cffunction>
	
	</cfcomponent>