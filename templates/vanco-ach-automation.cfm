


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
										select 	l.leadid, l.leaduuid, l.leadfirst, l.leadlast, l.leadactive, l.leadachhold, 
												l.leadachholdreason, l.leadachholddate, f.feeid, f.feeuuid, f.feeduedate, f.feepaiddate, f.feeamount, f.feepaid, f.feestatus, 
												f.feenote, f.feecollected, f.feeprogram, f.feepaytype, e.esignrouting, e.esignaccount, e.esignaccttype, sl.slenrollreturndate, 
												sl.slenrolldocsuploaddate, e.esignpaytype, e.esignccname, e.esignccnumber, e.esignccv2, e.esignccexpdate, 
												e.esignacctname, e.esignacctadd1, e.esignacctcity, e.esignacctstate, e.esignacctzipcode
										  from  fees f, leads l, slsummary sl, esign e
										 where  f.leadid = l.leadid
										   and  l.leadid = sl.leadid
										   and  l.leadid = e.leadid
										   and  l.companyid = <cfqueryparam value="#session.companyid#" cfsqltype="cf_sql_integer" />
										   and  l.leadachhold = <cfqueryparam value="N" cfsqltype="cf_sql_char" />
										   and  l.leadactive = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
										   <!--- // 7-20-2014 // not a good idea, but we have to remove this for CC payments
										   and  e.esignrouting <> ''										   
										   and  e.esignaccount <> ''
										   and  e.esignaccttype <> '' 
										   --->
										   and  sl.slenrollreturndate <> ''
										   and  sl.slenrolldocsuploaddate <> ''
										   and  ( f.feepaytype = <cfqueryparam value="ACH" cfsqltype="cf_sql_char" /> OR
										          f.feepaytype = <cfqueryparam value="CC" cfsqltype="cf_sql_char" /> )
										   and  f.feetrans = <cfqueryparam value="N" cfsqltype="cf_sql_char" />
										   and  f.feetransdate is null
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
											<cfheader name="content-disposition" value="attachment; filename=#UCASE( session.companyname )#-#dateformat( now(), "mm-dd-yyyy" )#-VANCO-ACH-DATAFILE-#thiscounter#.txt"><cfcontent type="text/txt"><cfoutput query="achdetails">#companysettings.achprovideruniqueid#,#leadid#,#left( listfirst( esignacctname, " " ), 11 )#,#left( listlast( esignacctname, " " ), 11 )#,#left( esignacctadd1, 30 )#,#left( esignacctcity, 25 )#,#left( esignacctstate, 2 )#,#left( esignacctzipcode, 5 )#,<cfif trim( feepaytype ) is "ach">#left( esignrouting, 9 )#,#left( esignaccount, 17 )#,#left( ucase( esignaccttype ), 1 )#,,,<cfelseif trim( feepaytype ) is "cc">,,,#esignccnumber#,#esignccexpdate#,</cfif>#trim( numberformat( feeamount, "L99.99" ))#,M,#dateformat( feeduedate, "mm/dd/yyyy" )#,#dateformat( feeduedate, "mm/dd/yyyy" )#,#feeid##thisbr#
</cfoutput>									
											
											
											
											
											
											
											
											
											
											
											<!--- update the ach status and fee payment pending dates --->
											<cfloop query="achdetails">
												<cfquery datasource="#application.dsn#" name="updatestatus">
													update fees
													   set feestatus = <cfqueryparam value="Pending" cfsqltype="cf_sql_varchar" />,														   
														   feetrans = <cfqueryparam value="Y" cfsqltype="cf_sql_char" />,														    
														   feetransdate = <cfqueryparam value="#CreateODBCDate(Now())#" cfsqltype="cf_sql_timestamp" />,
														   achbatchID = <cfqueryparam value="#thiscounter#" cfsqltype="cf_sql_integer" />
													 where feeid = <cfqueryparam value="#achdetails.feeid#" cfsqltype="cf_sql_integer" />
												</cfquery>
											</cfloop>
											
											<cfset thiscounter = thiscounter + 1 />
											
											<!--- // update the counter --->
											<cfquery datasource="#application.dsn#" name="achcounter">
												update achcounter
												   set achcountid = <cfqueryparam value="#thiscounter#" cfsqltype="cf_sql_integer" />
											</cfquery>
											
												
											
											
										<cfelse>				
											
											<script>
												alert("Sorry, there was a problem generating the ACH output file.  There are no ACH payments for the dates you selected...");
												self.location="javascript:history.back(-1);"
											</script>
											
											
										</cfif>
										
										
										
										<!---
										<cfdump var="#achdetails#" label="achdata dump">
										--->