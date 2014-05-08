<cffunction name="formatPhoneNumber">

   <cfargument name="phoneNumber" required="true" />

   <cfif len(phoneNumber) EQ 10>
       <!--- This only works with 10-digit US/Canada phone numbers --->
       <cfreturn "(#left(phoneNumber,3)#) #mid(phoneNumber,4,3)#-#right(phoneNumber,4)#" />
   <cfelse>
       <cfreturn phoneNumber />
   </cfif>
</cffunction>

<cffunction name="formatPhoneNumber2">

   <cfargument name="phoneNumber2" required="true" />

   <cfif len(phoneNumber2) EQ 10>
       <!--- This only works with 10-digit US/Canada phone numbers --->
       <cfreturn "(#left(phoneNumber2,3)#) #mid(phoneNumber2,4,3)#-#right(phoneNumber2,4)#" />
   <cfelse>
       <cfreturn phoneNumber2 />
   </cfif>
</cffunction>

<cffunction name="formatOfficeNumber">

   <cfargument name="officeNumber" required="true" />

   <cfif len(officeNumber) EQ 10>
       <!--- This only works with 10-digit US/Canada phone numbers --->
       <cfreturn "(#left(officeNumber,3)#) #mid(officeNumber,4,3)#-#right(officeNumber,4)#" />
   <cfelse>
       <cfreturn officeNumber />
   </cfif>
</cffunction>

<cffunction name="formatMobileNumber">

   <cfargument name="mobileNumber" required="true" />

   <cfif len(mobileNumber) EQ 10>
       <!--- This only works with 10-digit US/Canada phone numbers --->
       <cfreturn "(#left(mobileNumber,3)#) #mid(mobileNumber,4,3)#-#right(mobileNumber,4)#" />
   <cfelse>
       <cfreturn mobileNumber />
   </cfif>
</cffunction>

<cffunction name="formatFaxNumber">

   <cfargument name="faxNumber" required="true" />

   <cfif len(faxNumber) EQ 10>
       <!--- This only works with 10-digit US/Canada phone numbers --->
       <cfreturn "(#left(faxNumber,3)#) #mid(faxNumber,4,3)#-#right(faxNumber,4)#" />
   <cfelse>
       <cfreturn faxNumber />
   </cfif>
</cffunction>