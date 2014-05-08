


			<cfcomponent displayname="datasecure">		
				<cffunction name="init" access="public" output="false" returntype="datasecure" hint="Returns an initialized datasecure function.">		
					<!--- // return This reference. --->
					<cfreturn this />
				</cffunction>				
				<cffunction name="getsecretkey" output="false" access="remote" hint="I get the secret key for encrypt and decrypt functions.">
					<cfquery datasource="chromium" name="mysecretkey">
						select cryptoid, thekey, thekeydate, thekeyexpiration
						  from chromium
					</cfquery>	
					<cfreturn mysecretkey>				
				</cffunction>				
			</cfcomponent>