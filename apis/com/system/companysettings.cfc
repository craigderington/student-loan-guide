


		<cfcomponent displayname="companysettings">
	
				<cffunction name="init" access="public" output="false" returntype="activitylog" hint="Returns an initialized company settings object function.">		
					<!--- // return this reference. --->
					<cfreturn this />
				</cffunction>
				
				
				<cffunction name="getcompanysettings" access="public" output="false" hint="I get the company settings.">
					<cfargument name="companyid" type="numeric" required="yes" default="#session.companyid#">
					<cfset var companysettings = "" />
					<cfquery datasource="#application.dsn#" name="companysettings">
						 select c.companyid, c.companyname, c.dba, c.address1, c.address2, c.city,
								c.state, c.zip, c.phone, c.fax, c.email, c.regcode, c.active, c.complogo,
								c.advisory, c.implement, c.comptype, c.achprovider, c.achdatafile, 
								c.luckyorangecode, c.escrowservice, c.trustaccountbankname, 
								c.trustaccountnumber, c.trustaccountrouting, c.achprovideruniqueid, 
								c.numlicenses, c.achdaystohold, c.enrollagreepath, c.implagreepath, 
								c.esignagreepath1, c.esignagreepath2, c.useportal, c.vancowebserviceid, 
								c.vancourlpath, c.vancoframeid, c.vancoenckey, c.vancows, c.useportalconvo,
								c.useportalactlog
						   from company c
						  where c.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
					</cfquery>
					<cfreturn companysettings >
				</cffunction>
				
				<cffunction name="getclientsettings" access="public" output="false" hint="I get the client company settings.">
					<cfargument name="leadid" type="numeric" required="yes" default="#session.leadid#">
					<cfset var clientsettings = "" />
					<cfquery datasource="#application.dsn#" name="clientsettings">
						select c.*, l.leadid
						  from company c, leads l
						 where c.companyid = l.companyid
						   and l.leadid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
					</cfquery>
					<cfreturn clientsettings >
				</cffunction>
				
				<cffunction name="getcompanydocs" access="public" output="false" hint="I get the company document paths for enroll and impl agreements.">
					<cfargument name="companyid" type="numeric" required="yes" default="#session.companyid#">
					<cfset var companydocs = "" />
					<cfquery datasource="#application.dsn#" name="companydocs">
						select c.companyid, c.dba, c.companyname, 
						       c.enrollagreepath, c.implagreepath,
							   c.esignagreepath1, c.esignagreepath2
						  from company c
						 where c.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
					</cfquery>
					<cfreturn companydocs >
				</cffunction>
				
				<cffunction name="getcompanypaytypes" access="public" output="false" hint="I get the company payment types allowed for each company for client portal and fees.">
					<cfargument name="companyid" type="numeric" required="yes" default="#session.companyid#">
					<cfset var companypaytypes = "" />
					<cfquery datasource="#application.dsn#" name="companypaytypes">
						select cpt.companypaytypeid, cpt.companypaytypedescr, cpt.companypaytypeactive
						  from companypaytypes cpt
					     where cpt.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
						   and cpt.companypaytypeactive = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
					</cfquery>
					<cfreturn companypaytypes >
				</cffunction>

				<cffunction name="getcompanywelcomemessage" access="public" output="false" hint="I get the company welcome message.">
					<cfargument name="companyid" type="numeric" required="yes" default="#session.companyid#">
					<cfset var companywelcomemessage = "" />
					<cfquery datasource="#application.dsn#" name="companywelcomemessage">
						select wm.welcomemessageid, wm.companyid, wm.welcomemessagetext
						  from welcomemessage wm
						 where wm.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
					</cfquery>					
					<cfreturn companywelcomemessage >
				</cffunction>
				
				<cffunction name="getcompanydisclosure" access="public" output="false" hint="I get the company esign disclosure statement.">
					<cfargument name="companyid" type="numeric" required="yes" default="#session.companyid#">
					<cfset var companydisclosure = "" />
					<cfquery datasource="#application.dsn#" name="companydisclosure">
						select ds.disclosureid, ds.companyid, ds.disclosuretext, ds.lastupdated, ds.lastupdatedby,
						       u.firstname, u.lastname
						  from disclosurestatement ds, users u
						 where ds.lastupdatedby = u.userid 
						   and ds.companyid = <cfqueryparam value="#arguments.companyid#" cfsqltype="cf_sql_integer" />
					</cfquery>					
					<cfreturn companydisclosure >
				</cffunction>
				
				
				
		</cfcomponent>