

				
							
				
				<!--- // get the clients NSLDS raw txt data by loan type ---> 
				<cfquery datasource="#application.dsn#" name="getdatasets">
					select distinct(n.datacontent), txtrowid
					  from nsltxtdata n, nsltxt nsl
					 where n.nsltxtid = nsl.nsltxtid
					   and nsl.leadid = <cfqueryparam value="#session.leadid#" cfsqltype="cf_sql_integer" />
					   and n.datalabel = <cfqueryparam value="Loan Type" cfsqltype="cf_sql_varchar" />
					   and n.nsltxtid = <cfqueryparam value="#session.nslds#" cfsqltype="cf_sql_integer" />	
				</cfquery>
				
				<!--- get the last record for the selected client --->
				<cfquery datasource="#application.dsn#" name="getmaxset">
					select max(txtrowid) as lastrecord
					  from nsltxtdata n, nsltxt nsl
					 where n.nsltxtid = nsl.nsltxtid
					   and nsl.leadid = <cfqueryparam value="#session.leadid#" cfsqltype="cf_sql_integer" />
					   and n.datalabel = <cfqueryparam value="Loan Contact Web Site Address" cfsqltype="cf_sql_varchar" />
					   and n.nsltxtid = <cfqueryparam value="#session.nslds#" cfsqltype="cf_sql_integer" />
				</cfquery>
				
				<!--- // create a list and assign the txtrowids --->
				<cfset ltlist = valuelist( getdatasets.txtrowid ) />					
							
					<!--- // now loop the length of the list --->
					<cfloop from="1" to="#listlen( ltlist )#" index="counter">													
								
						<!--- // check the length of our list, adjust the index according to the max index --->
						<cfif counter lt listlen( ltlist ) >
							<!--- // get the txtrowid of the next record in the list --->
							<cfset nextnumber = #listgetat( ltlist, counter + 1 )# />								
						<cfelse>
							<!--- // assign the txtrowid of the current positon in the list --->
							<cfset nextnumber = #listgetat( ltlist, counter )# />
						</cfif>							
									
							<!--- // create our dataset groups and txtrowid positions --->
							<cfset positionX = #listgetat( ltlist, counter )# />
							<cfset positionY = #nextnumber# />
							<cfset positionZ = #nextnumber# - 1	/>
							<cfset positionQ = #getmaxset.lastrecord# />
									
									<!--- // group the output and create a data structure --->
									<cfquery datasource="#application.dsn#" name="nslloantype">
										SELECT DATACONTENT as qLOANTYPE
										  FROM NSLTXTDATA
										 WHERE DATALABEL = 'LOAN TYPE'
										   AND ( txtrowid between #positionX# and 
										   <cfif counter lt listlen( ltlist )>
										   #positionZ#
										   <cfelse>
										   #positionQ#
										   </cfif>
										   )
									</cfquery>					

									<cfquery datasource="#application.dsn#" name="nslschool">
										SELECT DATACONTENT as qSCHOOL
										FROM NSLTXTDATA
										WHERE DATALABEL = 'LOAN ATTENDING SCHOOL NAME'
										AND ( txtrowid between #positionX# and 
										   <cfif counter lt listlen( ltlist )>
										   #positionZ#
										   <cfelse>
										   #positionQ#
										   </cfif>
										   )
									</cfquery>
									
									<cfquery datasource="#application.dsn#" name="nslopeid">
										SELECT DATACONTENT as qOPEID
										  FROM NSLTXTDATA
										 WHERE DATALABEL = 'LOAN ATTENDING SCHOOL OPEID'
										   AND ( txtrowid between #positionX# and 
										   <cfif counter lt listlen( ltlist )>
										   #positionZ#
										   <cfelse>
										   #positionQ#
										   </cfif>
										   )
									</cfquery>
										
									<cfquery datasource="#application.dsn#" name="nslloandate">
										SELECT DATACONTENT as qLOANDATE
										  FROM NSLTXTDATA
										 WHERE DATALABEL = 'LOAN DATE'
										   AND ( txtrowid between #positionX# and 
										   <cfif counter lt listlen( ltlist )>
										   #positionZ#
										   <cfelse>
										   #positionQ#
										   </cfif>
										   )
									</cfquery>
									
									<cfquery datasource="#application.dsn#" name="nslrepaybegindate">
										SELECT DATACONTENT as qREPAYBEGINDATE
										FROM NSLTXTDATA
										WHERE DATALABEL = 'LOAN REPAYMENT PLAN BEGIN DATE'
										AND ( txtrowid between #positionX# and 
										   <cfif counter lt listlen( ltlist )>
										   #positionZ#
										   <cfelse>
										   #positionQ#
										   </cfif>
										   )
									</cfquery>
											
									<cfquery datasource="#application.dsn#" name="nslrepayplanamt">
										SELECT DATACONTENT as qREPAYPLANAMT
										FROM NSLTXTDATA
										WHERE DATALABEL = 'Loan Repayment Plan Scheduled Amount'
										AND ( txtrowid between #positionX# and 
										   <cfif counter lt listlen( ltlist )>
										   #positionZ#
										   <cfelse>
										   #positionQ#
										   </cfif>
										   )
									</cfquery>							
									
									<cfquery datasource="#application.dsn#" name="nslloanstatusdate">
										SELECT top 1 DATACONTENT as qLOANSTATUSDATE
										FROM NSLTXTDATA
										WHERE DATALABEL = 'Loan Status Effective Date'
										  AND DATACONTENT < '1/1/2012' 
										  AND ( txtrowid between #positionX# and 
										   <cfif counter lt listlen( ltlist )>
										   #positionZ#
										   <cfelse>
										   #positionQ#
										   </cfif>
										   )
									  order by txtrowid asc
									</cfquery>

									<cfquery datasource="#application.dsn#" name="nslloanstatuscode">
										SELECT top 1 DATACONTENT as qLOANSTATUSCODE
										FROM NSLTXTDATA
										WHERE DATALABEL = 'Loan Status'										   
										  AND( txtrowid between #positionX# and 
										   <cfif counter lt listlen( ltlist )>
										   #positionZ#
										   <cfelse>
										   #positionQ#
										   </cfif>
										   )
									 order by txtrowid asc
									</cfquery>
									
									<cfquery datasource="#application.dsn#" name="nslloanstatus">
										SELECT top 1 DATACONTENT as qLOANSTATUS
										FROM NSLTXTDATA
										WHERE DATALABEL = 'Loan Status Description'										  
										  AND ( txtrowid between #positionX# and 
										   <cfif counter lt listlen( ltlist )>
										   #positionZ#
										   <cfelse>
										   #positionQ#
										   </cfif>
										   )
									      order by txtrowid asc
									</cfquery>								
											
									<cfquery datasource="#application.dsn#" name="nslloanbal">
										SELECT DATACONTENT as qLOANBAL
										FROM NSLTXTDATA
										WHERE DATALABEL = 'Loan Outstanding Principal Balance'
										AND ( txtrowid between #positionX# and 
										   <cfif counter lt listlen( ltlist )>
										   #positionZ#
										   <cfelse>
										   #positionQ#
										   </cfif>
										   )
									</cfquery>
										
									<cfquery datasource="#application.dsn#" name="nslloanintbal">
										SELECT DATACONTENT as qLOANINTBAL
										FROM NSLTXTDATA
										WHERE DATALABEL = 'Loan Outstanding Interest Balance'
										AND ( txtrowid between #positionX# and 
										   <cfif counter lt listlen( ltlist )>
										   #positionZ#
										   <cfelse>
										   #positionQ#
										   </cfif>
										   )
									</cfquery>
											
									<cfquery datasource="#application.dsn#" name="nslintratetype">
										SELECT DATACONTENT as qINTRATETYPE
										FROM NSLTXTDATA
										WHERE DATALABEL = 'Loan Interest Rate Type'
										AND ( txtrowid between #positionX# and 
										   <cfif counter lt listlen( ltlist )>
										   #positionZ#
										   <cfelse>
										   #positionQ#
										   </cfif>
										   )
									</cfquery>
											
									<cfquery datasource="#application.dsn#" name="nslintrate">
										SELECT DATACONTENT as qINTRATE
										FROM NSLTXTDATA
										WHERE DATALABEL = 'Loan Interest Rate'
										AND ( txtrowid between #positionX# and 
										   <cfif counter lt listlen( ltlist )>
										   #positionZ#
										   <cfelse>
										   #positionQ#
										   </cfif>
										   )
									</cfquery>	
											
									<cfquery datasource="#application.dsn#" name="nslloanservicertype">
										SELECT DATACONTENT as qLOANSERVICERTYPE
										FROM NSLTXTDATA
										WHERE DATALABEL = 'Loan Contact Type'
										AND DATACONTENT <> 'Current Lender'
										AND DATACONTENT <> 'Current Guaranty Agency'
										AND ( txtrowid between #positionX# and 
										   <cfif counter lt listlen( ltlist )>
										   #positionZ#
										   <cfelse>
										   #positionQ#
										   </cfif>
										   )
									</cfquery>
											
									<cfquery datasource="#application.dsn#" name="nslloanservicername">
										SELECT DATACONTENT as qLOANSERVICERNAME
										FROM NSLTXTDATA
										WHERE DATALABEL = 'Loan Contact Name'
										AND ( txtrowid between #positionX# and 
										   <cfif counter lt listlen( ltlist )>
										   #positionZ#
										   <cfelse>
										   #positionQ#
										   </cfif>
										   )
									</cfquery>
											
									<cfquery datasource="#application.dsn#" name="nslloanserviceradd1">
										SELECT DATACONTENT as qLOANSERVICERADD1
										FROM NSLTXTDATA
										WHERE DATALABEL = 'Loan Contact Street Address 1'
										AND ( txtrowid between #positionX# and 
										   <cfif counter lt listlen( ltlist )>
										   #positionZ#
										   <cfelse>
										   #positionQ#
										   </cfif>
										   )
									</cfquery>
											
									<cfquery datasource="#application.dsn#" name="nslloanserviceradd2">
										SELECT DATACONTENT as qLOANSERVICERADD2
										FROM NSLTXTDATA
										WHERE DATALABEL = 'Loan Contact Street Address 2'
										AND ( txtrowid between #positionX# and 
										   <cfif counter lt listlen( ltlist )>
										   #positionZ#
										   <cfelse>
										   #positionQ#
										   </cfif>
										   )
									</cfquery>
											
									<cfquery datasource="#application.dsn#" name="nslloanservicercity">
										SELECT DATACONTENT as qLOANSERVICERCITY
										FROM NSLTXTDATA
										WHERE DATALABEL = 'Loan Contact City'
										AND ( txtrowid between #positionX# and 
										   <cfif counter lt listlen( ltlist )>
										   #positionZ#
										   <cfelse>
										   #positionQ#
										   </cfif>
										   )
									</cfquery>
											
									<cfquery datasource="#application.dsn#" name="nslloanservicerstate">
										SELECT DATACONTENT as qLOANSERVICERSTATE
										FROM NSLTXTDATA
										WHERE DATALABEL = 'Loan Contact State Code'
										AND ( txtrowid between #positionX# and 
										   <cfif counter lt listlen( ltlist )>
										   #positionZ#
										   <cfelse>
										   #positionQ#
										   </cfif>
										   )
									</cfquery>
											
									<cfquery datasource="#application.dsn#" name="nslloanservicerzip">
										SELECT DATACONTENT as qLOANSERVICERZIP
										FROM NSLTXTDATA
										WHERE DATALABEL = 'Loan Contact Zip Code'
										AND ( txtrowid between #positionX# and 
										   <cfif counter lt listlen( ltlist )>
										   #positionZ#
										   <cfelse>
										   #positionQ#
										   </cfif>
										   )
									</cfquery>
											
									<cfquery datasource="#application.dsn#" name="nslloanservicerphone">
										SELECT DATACONTENT as qLOANSERVICERPHONE
										FROM NSLTXTDATA
										WHERE DATALABEL = 'Loan Contact Phone Number'
										AND ( txtrowid between #positionX# and 
										   <cfif counter lt listlen( ltlist )>
										   #positionZ#
										   <cfelse>
										   #positionQ#
										   </cfif>
										   )
									</cfquery>
											
									<cfquery datasource="#application.dsn#" name="nslloanservicerphoneext">
										SELECT DATACONTENT as qLOANSERVICERPHONEEXT
										FROM NSLTXTDATA
										WHERE DATALABEL = 'Loan Contact Phone Extension'
										AND ( txtrowid between #positionX# and 
										   <cfif counter lt listlen( ltlist )>
										   #positionZ#
										   <cfelse>
										   #positionQ#
										   </cfif>
										   )
									</cfquery>
											
									<cfquery datasource="#application.dsn#" name="nslloanserviceremail">
										SELECT DATACONTENT as qLOANSERVICEREMAIL
										FROM NSLTXTDATA
										WHERE DATALABEL = 'Loan Contact Email Address'
										AND ( txtrowid between #positionX# and 
										   <cfif counter lt listlen( ltlist )>
										   #positionZ#
										   <cfelse>
										   #positionQ#
										   </cfif>
										   )
									</cfquery>
									
									<cfquery datasource="#application.dsn#" name="nslloanservicerwebsite">
										SELECT DATACONTENT as qLOANSERVICERWEBSITE
										FROM NSLTXTDATA
										WHERE DATALABEL = 'Loan Contact Web Site Address'
										AND ( txtrowid between #positionX# and 
										   <cfif counter lt listlen( ltlist )>
										   #positionZ#
										   <cfelse>
										   #positionQ#
										   </cfif>
										   )
									</cfquery>		
								
								
									<!--- // now loop our data set and create our clean NSLDS database records --->
									<cfquery datasource="#application.dsn#" name="createmasternslds">
										insert into nslds(nsluuid, leadid, nslloantype, nslschool, nslloandate, nslloanbalance, nslintbalance, nslloanintrate, nslcurrentpay, nslservicer, converted, nslopeid, nslintratetype, nslservicertype, companyname, companyadd1, companyadd2, companycity, companystate, companyzip, companyphone, companyphoneext, companyemail, companyweb, nslrepaybegindate, nslloanstatus, nslloanstatuscode, nslloanstatusdate)
											values(										
												   <cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar" maxlength="35" />,
												   <cfqueryparam value="#session.leadid#" cfsqltype="cf_sql_integer" />,
												   <cfqueryparam value="#nslloantype.qloantype#" cfsqltype="cf_sql_varchar" />,
												   <cfqueryparam value="#nslschool.qschool#" cfsqltype="cf_sql_varchar" />,
												   <cfqueryparam value="#nslloandate.qloandate#" cfsqltype="cf_sql_date" />,
												   <cfqueryparam value="#rereplace( nslloanbal.qloanbal, "[\$,]", "", "all" )#" cfsqltype="cf_sql_float" />,
												   <cfqueryparam value="#rereplace( nslloanintbal.qloanintbal, "[\$,]", "", "all" )#" cfsqltype="cf_sql_float" />,												   
												   <cfif trim( nslintrate.qintrate ) is not "Loan Interest Rate">
												   <cfqueryparam value="#numberformat( replace( nslintrate.qintrate, "%", "", "all" ), "9.99" )#" cfsqltype="cf_sql_decimal" scale="2" />,											   
												   <cfelse>
												   <cfqueryparam value="0.00" cfsqltype="cf_sql_float" />,
												   </cfif>											   
												   <cfif trim( nslrepayplanamt.qrepayplanamt ) is not "Loan Repayment Plan Scheduled Amount">
												   <cfqueryparam value="#numberformat( rereplace( nslrepayplanamt.qrepayplanamt, "[\$,]", "", "all" ), "9.99" )#" cfsqltype="cf_sql_float" />,
												   <cfelse>
												   <cfqueryparam value="0.00" cfsqltype="cf_sql_float" />,												   
												   </cfif>												   
												   <cfqueryparam value="Field No Longer Used" cfsqltype="cf_sql_varchar" />,
												   <cfqueryparam value="0" cfsqltype="cf_sql_bit" />,
												   <cfqueryparam value="#nslopeid.qopeid#" cfsqltype="cf_sql_varchar" />,
												   <cfqueryparam value="#nslintratetype.qintratetype#" cfsqltype="cf_sql_varchar" />,
												   <cfqueryparam value="#nslloanservicertype.qloanservicertype#" cfsqltype="cf_sql_varchar" />,
												   <cfqueryparam value="#nslloanservicername.qloanservicername#" cfsqltype="cf_sql_varchar" />,
												   <cfqueryparam value="#nslloanserviceradd1.qloanserviceradd1#" cfsqltype="cf_sql_varchar" />,
												   <cfqueryparam value="#nslloanserviceradd2.qloanserviceradd2#" cfsqltype="cf_sql_varchar" />,
												   <cfqueryparam value="#nslloanservicercity.qloanservicercity#" cfsqltype="cf_sql_varchar" maxlength="50" />,
												   <cfqueryparam value="#left( nslloanservicerstate.qloanservicerstate, 2 )#" cfsqltype="cf_sql_varchar" />,
												   <cfqueryparam value="#nslloanservicerzip.qloanservicerzip#" cfsqltype="cf_sql_varchar" />,
												   <cfqueryparam value="#nslloanservicerphone.qloanservicerphone#" cfsqltype="cf_sql_varchar" />,
												   <cfqueryparam value="#nslloanservicerphoneext.qloanservicerphoneext#" cfsqltype="cf_sql_varchar" />,
												   <cfqueryparam value="#nslloanserviceremail.qloanserviceremail#" cfsqltype="cf_sql_varchar" />,
												   <cfqueryparam value="#nslloanservicerwebsite.qloanservicerwebsite#" cfsqltype="cf_sql_varchar" />,												   
												   <cfif trim( nslrepaybegindate.qrepaybegindate ) is not "Loan Repayment Plan Begin Date">
												   <cfqueryparam value="#nslrepaybegindate.qrepaybegindate#" cfsqltype="cf_sql_date" />,
												   <cfelse>
												   <cfqueryparam value="1/1/1900" cfsqltype="cf_sql_date" />,
												   </cfif>												   
												   <cfqueryparam value="#nslloanstatus.qloanstatus#" cfsqltype="cf_sql_varchar" />,
												   <cfqueryparam value="#nslloanstatuscode.qloanstatuscode#" cfsqltype="cf_sql_varchar" maxlength="50" />,
												   <cfqueryparam value="#nslloanstatusdate.qloanstatusdate#" cfsqltype="cf_sql_date" />										
												  );						
										
										
									</cfquery>
							<cfset nextnumber = 0 />	
					</cfloop>						
					
					
					<cflocation url="#application.root#?event=page.nslds.results" addtoken="no">
					
					
				
			