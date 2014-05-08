


				<!--- // create an array to store the id's from the nslds form fields --->				
				<cfset nslidarr = listtoarray( nslID )>		
				
					<!--- // loop over the nslds array getting the data for each loan --->
					<cfloop from="1" to="#arrayLen( nslidarr )#" step="1" index="position">						
						
						<!--- // get the loan information for each loan identified --->
						<cfquery datasource="#application.dsn#" name="loandata">
							select nslid, nsluuid, leadid, nslloantype, nslschool, nslloandate, nslloanbalance,
								   nslintbalance, nslloanintrate, nslcurrentpay, nslservicer, converted
							  from nslds
							 where nslid = <cfqueryparam value="#nslidarr[position]#" cfsqltype="cf_sql_integer" />
						</cfquery>
					
						<!--- // try and match the servicer --->
						<cfquery datasource="#application.dsn#" name="chksrv">
							select top 1 servid
							  from servicers
							 where servname LIKE <cfqueryparam value="%#loandata.nslservicer#%" cfsqltype="cf_sql_varchar" />
						</cfquery>
						
						<!--- // try and match the loan type --->
						<cfquery datasource="#application.dsn#" name="getloancode">
							select top 1 loancodeid
							  from loancodes
							 where codedescr LIKE <cfqueryparam value="%#loandata.nslloantype#%" cfsqltype="cf_sql_varchar" />
						</cfquery>
						
						
						<cfquery datasource="#application.dsn#" name="createdebtworksheets">
							insert into slworksheet(worksheetuuid, leadid, dateadded, loancodeid, statuscodeid, repaycodeid, servicerid, acctnum, loanbalance, currentpayment, intrate, closeddate, attendingschool)
								values(
										<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar" maxlength="35" />,
										<cfqueryparam value="#session.leadid#" cfsqltype="cf_sql_integer" />,
										<cfqueryparam value="#CreateODBCDate(Now())#" cfsqltype="cf_sql_date" />,
										<cfqueryparam value="#getloancode.loancodeid#" cfsqltype="cf_sql_integer" />,
										<cfqueryparam value="121" cfsqltype="cf_sql_integer" />,
										<cfqueryparam value="22" cfsqltype="cf_sql_integer" />,
										<cfqueryparam value="#chksrv.servid#" cfsqltype="cf_sql_integer" />,
										<cfqueryparam value="#leaddetail.leadlast#" cfsqltype="cf_sql_integer" />,
										<cfqueryparam value="#loandata.nslloanbal#" cfsqltype="cf_sql_float" />,
										<cfqueryparam value="#loandata.nslcurrentpay#" cfsqltype="cf_sql_float" />,
										<cfqueryparam value="#loandata.nslloanintrate#" cfsqltype="cf_sql_decimal" scale="2" />,
										<cfqueryparam value="#loandata.nslloandate#" cfsqltype="cf_sql_date" />,
										<cfqueryparam value="#loandata.nslschool#" cfsqltype="cf_sql_varchar" />
									   );
						</cfquery>					
						
							
						<!--- // after debt worksheets are created, update the nslds data as converted --->
						<cfquery datasource="#application.dsn#" name="updatenslds">
							update nslds
							   set converted = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
							 where nslid = <cfqueryparam value="#nslidarr[position]#" cfsqltype="cf_sql_integer" />
						</cfquery>				
							
						
					</cfloop>
					
					<cfscript>
						thread = createobject( "java", "java.lang.Thread" );
						thread.sleep(5000);
					</cfscript>
					
					
					<cflocation url="#application.root#?event=page.worksheet" addtoken="no" >