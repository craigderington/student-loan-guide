<!--- create a .NET Hashtable --->
		<cfset table = createObject(".NET", "System.Collections.Hashtable")>
		
		
		<!--- call HashTable.add(Object, Object) method for all primitives --->
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
		
		
	
		
		
		