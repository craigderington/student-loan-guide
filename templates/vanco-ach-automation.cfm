


									<cfinvoke component="apis.com.system.companysettings" method="getcompanysettings" returnvariable="companysettings">
										<cfinvokeargument name="companyid" value="#session.companyid#">
									</cfinvoke>
									
									
									
									<!--- // need some params --->
									<cfparam name="thisbr" default="">
									<cfparam name="startdate" default="">
									<cfparam name="enddate" default="">
									<cfset thisbr = "#chr(13)##chr(10)#" />
									<cfset startdate = url.sdate />
									<cfset enddate = url.edate />



									<!--- get our data access components --->
									<cfquery datasource="#application.dsn#" name="achdetails">
										select 	l.leadid, l.leaduuid, l.leadfirst, l.leadlast, l.leadadd1, l.leadcity, l.leadstate, l.leadzip, l.leadactive, l.leadachhold, l.leadachholdreason, l.leadachholddate,
												f.feeid, f.feeuuid, f.feeduedate, f.feepaiddate, f.feeamount, f.feepaid, f.feestatus, f.feenote, f.feecollected, f.feeprogram,
												e.esignrouting, e.esignaccount, e.esignaccttype, sl.slenrollreturndate, sl.slenrolldocsuploaddate
										  from  fees f, leads l, slsummary sl, esign e
										 where  f.leadid = l.leadid
										   and  l.leadid = sl.leadid
										   and  l.leadid = e.leadid
										   and  l.companyid = <cfqueryparam value="#session.companyid#" cfsqltype="cf_sql_integer" />
										   and  l.leadachhold = <cfqueryparam value="N" cfsqltype="cf_sql_char" />
										   and  l.leadactive = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
										   and  e.esignrouting <> ''										   
										   and  e.esignaccount <> ''
										   and  e.esignaccttype <> ''
										   and  sl.slenrollreturndate <> ''
										   and  sl.slenrolldocsuploaddate <> ''
										   and  ( f.feeduedate between <cfqueryparam value="#startdate#" cfsqltype="cf_sql_date" /> and <cfqueryparam value="#enddate#" cfsqltype="cf_sql_date" /> )										     
									  order by  f.feeduedate asc
									</cfquery>				
									
									<!--- get the unique ach automation counter id --->
									<cfquery datasource="#application.dsn#" name="achcounter">
										select achcountid
										  from achcounter
									</cfquery>

									<!--- // define and set our counter variable --->
									<cfparam name="thiscounter" default="">
									<cfparam name="thisspacer" default="">
									<cfset thiscounter = achcounter.achcountid />
									<cfset thisspacer = " " />

						









										<!--- Output the file in the Vanco API required data format ---> 
										<cfif achdetails.recordcount gt 0>
											
											<!--- CLD // 06-5-2014 //  Vanco Transaction Processing  // API Data Format to Text // 	--->
											<cfheader name="content-disposition" value="attachment; filename=#UCASE( session.companyname )#-#dateformat( now(), "mm-dd-yyyy" )#-VANCO-ACH-DATAFILE-#thiscounter#.txt"><cfcontent type="text/txt"><cfoutput query="achdetails">#companysettings.achprovideruniqueid#,#leadid#,#left( leadlast, 11 )#,#left( leadfirst, 11 )#,#left( leadadd1, 30 )#,#left( leadcity, 25 )#,#left( leadstate, 2 )#,#left( leadzip, 5 )#,#left( esignrouting,9 )#,#left( esignaccount, 17 )#,#left( ucase( esignaccttype ), 1 )#,,,#trim( numberformat( feeamount, "L99.99" ))#,M,#dateformat( feeduedate, "mm/dd/yyyy" )#,#dateformat( feeduedate, "mm/dd/yyyy" )#,#feeid##thisbr#
</cfoutput>										
											
											
											
											
											
											
											
											
											
											
											<!--- Update the ACH Status and Payment Received Dates
											<cfloop query="achdetails">
												<cfquery datasource="#application.dsn#" name="updatestatus">
													update fees
													   set achpulled = <cfqueryparam value="#CreateODBCDate(Now())#" cfsqltype="cf_sql_date" />,														    
														   feetrans = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />,
														   achbatchID = <cfqueryparam value="US-#thiscounter#" cfsqltype="cf_sql_varchar" />
													 where feeID = <cfqueryparam value="#achdetails.feeID#" cfsqltype="cf_sql_integer" />
												</cfquery>
											</cfloop>
											
											<cfset thiscounter = thiscounter + 1 />
											
											<!--- // update the counter --->
											<cfquery datasource="#application.dsn#" name="achcounter">
												update achcounter
												   set achcountid = <cfqueryparam value="#thiscounter#" cfsqltype="cf_sql_integer" />
											</cfquery>
											
												
										--->	
											
										<cfelse>				
											
											<script>
												alert("Sorry, there was a problem generating the ACH output file.  There are no ACH payments for the dates you selected...");
												self.location="javascript:history.back(-1);"
											</script>
											
											
										</cfif>
										
										
										
										<!---
										<cfdump var="#achdetails#" label="achdata dump">
										--->