


		<cfcomponent displayname="budgetgateway">
		
			<cffunction name="init" access="public" output="false" returntype="budgetgateway" hint="Returns an initialized budget gateway function.">		
				<!--- // return This reference. --->
				<cfreturn this />
			</cffunction>
		
			<cffunction name="getincomecategories" access="remote" output="false" returntype="query" hint="I get the list of income categories.">
				<cfquery datasource="#application.dsn#" name="incomecat">
					select incomecatid, incomecatname
					  from incomecategories
					 where incomecatid <> <cfqueryparam value="-1" cfsqltype="cf_sql_integer" /> 
				  order by incomecatname asc
				</cfquery>
				<cfreturn incomecat>
			</cffunction>			
			
			<cffunction name="getexpensecategories" access="remote" output="false" returntype="query" hint="I get the list of expense categories.">
				<cfquery datasource="#application.dsn#" name="expensecat">
					select expensecatid, expensecatname
					  from expensecategories
					 where expensecatid <> <cfqueryparam value="-1" cfsqltype="cf_sql_integer" /> 
				  order by expensecatname asc
				</cfquery>
				<cfreturn expensecat>
			</cffunction>

			<cffunction name="getdeductiontypes" access="remote" output="false" returntype="query" hint="I get the list of deduction types.">
				<cfquery datasource="#application.dsn#" name="deducttypes">
					select deducttypeid, deducttypename
					  from deductiontypes					 
				  order by deducttypename asc
				</cfquery>
				<cfreturn deducttypes>
			</cffunction>		
			
			<cffunction name="getbudget" access="remote" output="false" hint="I get all of the budget detail income and expenses.">
				<cfargument name="leadid" required="yes" type="numeric" default="#session.leadid#">
				<cfquery datasource="#application.dsn#" name="budget">
					select budgetid, budgetuuid, leadid, payfreq, employername, employeradd1, employeradd2, employercity,
						   employerstate, employerzip, numdependents, currentjob, dateemployed, spousename, spousesocial,
						   primarygrossmonthly, primarywithholding, primaryfica, primarymedicare, primary401k, primarybenefits,
						   primarycitytax, primarystatetax, primaryincomeothera, primaryincomeotherb, primaryincomeotherc,
						   primaryincomeotherd, primaryincomeotheradescr, primaryincomeotherbdescr, primaryincomeothercdescr,
						   primaryincomeotherddescr, primarynetincome, secondarypayfreq, secondarygrossmonthly, secondarywithholding,
						   secondaryfica, secondarymedicare, secondary401k, secondarybenefits, secondarycitytax, secondarystatetax,
						   secondaryincomeothera, secondaryincomeotherb, secondaryincomeotherc, secondaryincomeotherd, 
						   secondaryincomeotheradescr, secondaryincomeotherbdescr, secondaryincomeothercdescr, 
						   secondaryincomeotherddescr, secondarynetincome, primarypension, secondarypension, primarychildsupport, 
						   secondarychildsupport, primaryssi, secondaryssi, primaryfoodstamps, secondaryfoodstamps, primaryrentalproperty, 
						   secondaryrentalproperty, primaryparttimejob, primaryparttimejobdescr, secondaryparttimejob,
						   secondaryparttimejobdescr, primarytotalincome, secondarytotalincome, combinedtotalincome,						   
						   ownorrent, mortgage1, mortgage2, mortgage3, mortgage4, realestatetax, hoacondodues, yardmaint,
						   pestcontrol, sheltertotal, auto1, auto2, auto3, auto4, leasepurch1, leasepurch2, leasepurch3, leasepurch4,
						   autototal, water, electric, trash, gas, cable, internet, phone, cellular, securitysystem, utilitytotal,
						   gasoline, tolls, autorepairs, autotags, publictrans, transtotal, homesupply, tobacco, groceries, mealsoutnonent, 
						   mealsoutent, schoollunch, foodtotal, lifeinsurance, medicaldental, autoinsurance, homerentinsurance, 
						   longtermcare, hsaacct, insurancetotal, prescriptions, copaydeduct, overcounterpills, medtotal, alimony,
						   banklevy, childsupport, domesticorder, familyexpenseother, familyexpenseotherdescr, childcare, aftercare, 
						   clothing, recreation, donations, memberships, studentloans, familyloans, personalgrooming, drycleaning, miscothera,
						   miscotheradescr, miscotherb, miscotherbdescr, miscotherc, miscothercdescr, miscotherd, miscotherddescr,
						   misctotal, subtotalexpenses, debttoincomeratio, discincome, childactivity, childcaretotal						   
                      from budget
                     where leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
				</cfquery>
				<cfreturn budget>
			</cffunction>

			<cffunction name="getincome" access="remote" output="false" hint="I get all of the budget income detail.">
				<cfargument name="budgetid" required="yes" type="numeric" default="#budget.budgetid#">
				<cfquery datasource="#application.dsn#" name="income">
					select i.incomeid, i.budgetid, ic.incomecatname, i.incomeother, i.incomeamount, i.incomedescr
                      from income i, incomecategories ic
                     where i.incomecatid = ic.incomecatid
					   and i.budgetid = <cfqueryparam value="#arguments.budgetid#" cfsqltype="cf_sql_integer" />
				</cfquery>
				<cfreturn income>
			</cffunction>
			
			<cffunction name="getdeductions" access="remote" output="false" hint="I get all of the budget income detail.">
				<cfargument name="budgetid" required="yes" type="numeric" default="#budget.budgetid#">
				<cfquery datasource="#application.dsn#" name="deductions">
					select d.deductid, d.budgetid, dt.deducttypename, d.deducttypeother, d.deductamount, d.deductdescr
                      from deductions d, deductiontypes dt
                     where d.deducttypeid = dt.deducttypeid
					   and d.budgetid = <cfqueryparam value="#arguments.budgetid#" cfsqltype="cf_sql_integer" />
				</cfquery>
				<cfreturn deductions>
			</cffunction>
			
			<cffunction name="getexpenses" access="remote" output="false" hint="I get all of the budget expenses detail.">
				<cfargument name="budgetid" required="yes" type="numeric" default="#budget.budgetid#">
				<cfquery datasource="#application.dsn#" name="expenses">
					select e.expenseid, e.budgetid, ec.expensecatname, e.expenseother, e.expensedescr, e.expenseamount
                      from expenses e, expensecategories ec
                     where e.expensecatid = ec.expensecatid
					   and e.budgetid = <cfqueryparam value="#arguments.budgetid#" cfsqltype="cf_sql_integer" />
				</cfquery>
				<cfreturn expenses>
			</cffunction>
			
			<cffunction name="getexpensesbycat" access="remote" output="false" hint="I get all of the budget expenses detail.">
				<cfargument name="budgetid" required="yes" type="numeric" default="#budget.budgetid#">
				<cfquery datasource="#application.dsn#" name="expensesbycat">
					select ec.expensecatname, count(ec.expensecatid) as totalexpitems, sum(e.expenseamount) as totalexpensecat
					  from expenses e, expensecategories ec
					 where e.expensecatid = ec.expensecatid
					   and e.budgetid = <cfqueryparam value="#arguments.budgetid#" cfsqltype="cf_sql_integer" />
				  group by ec.expensecatname
				  order by ec.expensecatname asc
				</cfquery>
				<cfreturn expensesbycat>
			</cffunction>
			
			<cffunction name="getincometotals" access="remote" output="false" hint="I get all of the budget income detail.">
				<cfargument name="budgetid" required="yes" type="numeric" default="#budget.budgetid#">
				<cfquery datasource="#application.dsn#" name="incometotals">
					select b.leadid,
					       (select sum(incomeamount) from income i where i.budgetid = b.budgetid and i.budgetid = <cfqueryparam value="#arguments.budgetid#" cfsqltype="cf_sql_integer" />) as totalincome,
						   (select sum(deductamount) from deductions d where d.budgetid = b.budgetid and d.budgetid = <cfqueryparam value="#arguments.budgetid#" cfsqltype="cf_sql_integer" />) as totaldeductions,
						   (select sum(expenseamount) from expenses e where e.budgetid = b.budgetid and e.budgetid = <cfqueryparam value="#arguments.budgetid#" cfsqltype="cf_sql_integer" />) as totalexpenses
                      from budget b
                     where b.budgetid = <cfqueryparam value="#arguments.budgetid#" cfsqltype="cf_sql_integer" />
				</cfquery>
				<cfreturn incometotals>
			</cffunction>
			
			
		</cfcomponent>