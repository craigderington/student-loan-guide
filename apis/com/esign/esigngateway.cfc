


			<cfcomponent displayname="esigngateway">
		
				<cffunction name="init" access="public" output="false" returntype="esigngateway" hint="I create an initialized electronic signature gateway object.">
					<cfreturn this >
				</cffunction>
				
				
				<cffunction name="getesigninfo" access="public" output="false" hint="I get all of the client esign information.">
					<cfargument name="leadid" default="#session.leadid#" type="numeric" required="yes">					
					<cfset var esigninfo = "" />
						<cfquery datasource="#application.dsn#" name="esigninfo">
							select es.esid, es.esuuid, es.leadid, es.esdatestamp, es.esuserip, es.esconfirm, es.esconfirminitials, es.esconfirmfullname,
								   es.esignpaydate, es.esignpayamt, es.esignacctnumber, es.esignfeeoption, es.esignacctname, es.esignacctadd1, 
								   es.esignacctcity, es.esignacctstate, es.esignacctzipcode, es.esignaccttype, es.esignrouting, es.esignaccount, 
								   es.esignbankname, es.esignsignature, es.escompleted
							  from esign es
							 where es.leadid = <cfqueryparam value="#arguments.leadid#" cfsqltype="cf_sql_integer" />
						</cfquery>
					<cfreturn esigninfo>
				</cffunction>
			
				
			
			
			
			</cfcomponent>