		
		
		
		
		
		 
		<cfset dotnetpath = expandpath( "apis/dotnet/vanco/cryption.dll" ) />
		<cfset theKey = "5b!R-j0E12LF9m6s8qzgNtMvBk74KX3T" />		
		<cfset vancoresponse = "ve5ANbBVpv2NHoZrXy7jF29D9gKntEkPCTc26DFfuDm-BCMxgG_HJDSsUvP7Jy9cybeVwBhKHsr63-YAX6XWMrF8RT4k804W1t58RgBxUCYJUZttMnQu0HYGSrrVM3DZQQjkMxGnwBKDWGXtTlAuUOJiGo5KknJCAa3SS11R4doJG8pcLdBxRQm7l8AWzLTlV1tVMDbaoL_TmQguJOagPg==" />

		<!--- // process server response --->					
							
							<cfobject
								type=".NET"				
								class="Cryption.CryptionUtils"
								assembly="#dotnetpath#"
								name="decryptVancoResponse">				
							
								<cfset decryptVancoResponse.init() />				
								<cfset newmessage = vancoresponse />
								<cfset setdecryptedmessage = decryptVancoResponse.DecryptAndDecodeMessage( newmessage, theKey ) />
									
							
								
							
							
								<cfoutput>
											
									
									#setdecryptedmessage#
									
								
								</cfoutput>
								
									
									
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		<!--- create a .NET Hashtable
		<cfset table = createObject(".NET", "System.Collections.Hashtable")>
		--->
		
		<!--- call HashTable.add(Object, Object) method for all primitives 
		<cfset table.add("shortVar", javacast("short", 10))> 
		<cfset table.add("sbyteVar", javacast("byte", 20))> 
		<cfset table.add("intVar", javacast("int", 123))> 
		<cfset table.add("longVar", javacast("long", 1234))> 
		<cfset table.add("floatVar", javacast("float", 123.4))> 
		<cfset table.add("doubleVar", javacast("double", 123.4))> 
		<cfset table.add("charVar", javacast("char", 'c'))> 
		<cfset table.add("booleanVar", javacast("boolean", "yes"))> 
		<cfset table.add("StringVar", "Hello World")> 
		<cfset table.add("decimalVar", javacast("bigdecimal", 123234234.505))> 
		 
		<!--- call HashTable.add(Object, Object) for unsigned primitive types. ---> 
		<cfset boxedByte = createObject(".NET", "System.BoxedByte").init(10)> 
		<cfset table.add("byteVar", boxedByte)> 
		 
		<cfset boxedUShort = createObject(".NET", "System.BoxedUShort").init(100)> 
		<cfset table.add("ushortVar", boxedUShort)> 
		 
		<cfset boxedUInt = createObject(".NET", "System.BoxedUInt").init(123)> 
		<cfset table.add("uintVar", boxedUInt)> 
		 
		<cfset boxedULong = createObject(".NET", "System.BoxedULong").init(123123)> 
		<cfset table.add("ulongVar", boxedULong)> 
		 
		<cfdump var="#DotNetToCFType(table)#">
		
		
		--->
		
		
		