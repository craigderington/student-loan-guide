


	<cfcomponent displayname="worksheetgateway">
	
		<cffunction name="init" access="public" output="false" returntype="worksheetgateway" hint="Returns an initialized worksheet gateway function.">		
			<!--- // return This reference. --->
			<cfreturn this />
		</cffunction>
	
		<cffunction name="getworksheets" access="remote" output="false" returntype="query" hint="I get the list of student loan debt worksheets.">		
			<cfargument name="leadid" default="#session.leadid#" required="yes">			
				<cfset var worksheetlist = "">
				<cfquery datasource="#application.dsn#" name="worksheetlist">
					select sl.worksheetid, sl.worksheetuuid, sl.leadid, sl.dateadded, sl.loancodeid, sl.statuscodeid, sl.repaycodeid,
					       sl.servicerid, sl.acctnum, sl.loanbalance, sl.currentpayment, sl.intrate, sl.closeddate, sl.graceenddate, 
						   sl.paymentduedate, sl.prevconsol, sl.rehabafter, sl.active, lc.loancode, lc.codedescr, rc.repaycode, s.servid, 
						   s.servname, sc.statuscode, sc.statuscodedescr, sl.completed, sl.attendingschool, sl.servname as nslservicer
					  from slworksheet sl, loancodes lc, statuscodes sc, repaycodes rc, servicers s
					 where sl.loancodeid = lc.loancodeid
					   and sl.statuscodeid = sc.statuscodeid
					   and sl.repaycodeid = rc.repaycodeid
					   and sl.servicerid = s.servid
					   and sl.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
				  order by dateadded asc
				</cfquery>				
				<cfreturn worksheetlist >		
		</cffunction>
		
		
		<cffunction name="getworksheet" access="remote" output="false" returntype="query" hint="I get the student loan debt worksheet details.">		
			<cfargument name="worksheetid" default="#url.worksheetid#" required="yes">			
				<cfset var worksheet = "">
				<cfquery datasource="#application.dsn#" name="worksheet">
					select sl.worksheetid, sl.worksheetuuid, sl.leadid, sl.dateadded, sl.loancodeid, sl.statuscodeid, sl.repaycodeid,
					       sl.servicerid, sl.acctnum, sl.loanbalance, sl.currentpayment, sl.intrate, sl.closeddate, sl.graceenddate, 
						   sl.paymentduedate, sl.prevconsol, sl.rehabafter, sl.active, lc.loancode, rc.repaycode, s.servname, sc.statuscode,
						   sl.completed, sl.attendingschool
					  from slworksheet sl, loancodes lc, repaycodes rc, servicers s, statuscodes sc
					 where sl.loancodeid = lc.loancodeid
					   and sl.repaycodeid = rc.repaycodeid
					   and sl.statuscodeid = sc.statuscodeid
					   and sl.servicerid = s.servid
					   and sl.worksheetuuid = <cfqueryparam value="#arguments.worksheetid#" cfsqltype="cf_sql_varchar" maxlength="35" />
				  order by dateadded asc
				</cfquery>				
				<cfreturn worksheet >		
		</cffunction>

		<cffunction name="getdebttotal" access="remote" output="false" returntype="query" hint="I get the total amount of student loan debt.">
			<cfargument name="leadid" default="#session.leadid#" type="numeric">
			<cfset var totaldebt = "" />
			<cfquery datasource="#application.dsn#" name="totaldebt">
				select sum(loanbalance) as sltotal
				  from slworksheet
				 where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />		      
			</cfquery>			
			<cfreturn totaldebt >
		</cffunction>
		
		
		<cffunction name="getloancodes" access="remote" output="false" returntype="query" hint="I get the list of loan codes.">
			<cfset var loancodes = "" />
			<cfquery datasource="#application.dsn#" name="loancodes">
				select loancodeid, loancode, codedescr, codeactive
				  from loancodes
				 where codeactive = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
		      order by loancode asc 
			</cfquery>			
			<cfreturn loancodes >
		</cffunction>		
		
		<cffunction name="getrepaycodes" access="remote" output="false" returntype="query" hint="I get the list of repayment codes.">
			<cfset var repaycodes = "" />
			<cfquery datasource="#application.dsn#" name="repaycodes">
				select repaycodeid, repaycode, repaycodedescr, repayactive
				  from repaycodes
				 where repayactive = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
		      order by repaycode asc 
			</cfquery>			
			<cfreturn repaycodes >
		</cffunction>
		
		
		<cffunction name="getstatuscodes" access="remote" output="false" returntype="query" hint="I get the list of status codes.">
			<cfset var statuscodes = "" />
			<cfquery datasource="#application.dsn#" name="statuscodes">
				select statuscodeid, statuscode, statuscodedescr, statuscodeactive
				  from statuscodes
				 where statuscodeactive = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
		      order by statuscode asc 
			</cfquery>			
			<cfreturn statuscodes >
		</cffunction>
		
		
		<cffunction name="getsolutiondebts" access="remote" output="false" returntype="query" hint="I get the list of student loan debt worksheets for the solution page.">		
			<cfargument name="leadid" default="#session.leadid#" required="yes">
			<cfargument name="loancodes" default="'A','B'" required="yes">
			<cfargument name="statuscode" default="non" required="no" type="any">
				<cfset var solutiondebtlist = "">
				<cfquery datasource="#application.dsn#" name="solutiondebtlist">
					select sl.worksheetid, sl.worksheetuuid, sl.leadid, sl.dateadded, sl.loancodeid, sl.statuscodeid, sl.repaycodeid,
						   sl.servicerid, sl.acctnum, sl.loanbalance, sl.currentpayment, sl.intrate, sl.closeddate, sl.graceenddate,
						   sl.paymentduedate, sl.prevconsol, sl.rehabafter, sl.active, sl.attendingschool, lc.loancode, lc.codedescr, 
						   rc.repaycode, s.servid, s.servname, sc.statuscode, sl.servname as nslservicer

					  from slworksheet sl inner join loancodes lc on sl.loancodeid = lc.loancodeid
										  inner join statuscodes sc on sl.statuscodeid = sc.statuscodeid
										  inner join repaycodes rc on sl.repaycodeid = rc.repaycodeid
										  inner join servicers s on sl.servicerid = s.servid

						where not exists(

										 select sol.solutionworksheetid
										   from solution sol
										  where (sl.worksheetid = sol.solutionworksheetid))
						
					   and sl.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
					   and sl.completed = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />
					   
					   <cfif trim( arguments.loancodes ) is not "aa">
					   and sl.active = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
					   </cfif>
					   
					   <cfif trim( arguments.statuscode ) is "default">
					   and sc.statuscoderefer = <cfqueryparam value="df" cfsqltype="cf_sql_char" />
					   </cfif>
					   
					   and left(lc.loancode,2) IN( <cfqueryparam value="#arguments.loancodes#" list="yes" separator="," /> )
				  
				  order by dateadded asc
				</cfquery>				
				<cfreturn solutiondebtlist >		
		</cffunction>
		
		
		<cffunction name="getloansfortree" access="remote" output="false" returntype="query" hint="I get the list of direct loan codes.">
			<cfargument name="leadid" type="numeric" default="#session.leadid#" required="yes">
			<cfargument name="loancodes" type="any" default="AA" required="yes">
			<cfset var treeloans = "" />
			<cfquery datasource="#application.dsn#" name="treeloans">
				select s.servid, s.servname, sl.loanbalance, sl.acctnum, lc.loancode, sl.servname as nslservicer
				  from slworksheet sl, loancodes lc, servicers s
				 where sl.servicerid = s.servid
				   and sl.loancodeid = lc.loancodeid
				   and sl.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
				   and lc.loancode IN( <cfqueryparam value="#arguments.loancodes#" list="yes" separator="," /> )
				   and sl.completed = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />
		      order by s.servname asc 
			</cfquery>			
			<cfreturn treeloans >
		</cffunction>
		
		<cffunction name="getvariablerates" access="public" output="false" hint="I get the variable interest rates for lookup.">
			<cfargument name="plusloantype" type="any" required="no" default="none">
			<cfargument name="loandate" type="date" required="yes" default="1/1/2010">
			<cfargument name="loantype" type="any" required="yes" default="Stafford">
			<cfargument name="repaycode" type="string" required="yes" default="RP">
			<cfset var variablerate = "" />
			<cfquery datasource="#application.dsn#" name="variablerate">
				select variableid, variabletype, variablestartdate, variableenddate, 
				       variableschool, variablerepay, variableplustype
				  from variablerates
				 where 
			</cfquery>
		</cffunction>
		
	
	</cfcomponent>