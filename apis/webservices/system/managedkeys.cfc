<cffunction name="genAESKeyFromPW" access="public" returnType="string">
<cfargument name="password" type="string" required="true" />
<cfargument name="salt64" type="string" required="true" />
<cfargument name="length" type="numeric" required="true" default="128" />
<!--- Decode the salt value that was provided. --->
<cfset var salt = toString(toBinary(arguments.salt64)) />
<!--- Go fetch Java's secret key factory so we can generate a key. --->
<cfset var keyFactory = createObject("java", "javax.crypto.SecretKeyFactory").getInstance("PBKDF2WithHmacSHA1") />
<!--- Define a key specification based on the password and salt that were provided. --->
<cfset var keySpec = createObject("java", "javax.crypto.spec.PBEKeySpec").init(
arguments.password.toCharArray(), <!--- Convert the password to a character array (char[])--->
salt.getBytes(), <!--- Convert the salt to a byte array (byte[]) --->
javaCast("int", 1024), <!--- Iterations as Java int --->
javaCast("int", arguments.length) <!--- Key length as Java int (192 or 256 may be available depending on your JVM) --->
) />
<!--- Initialize the secret key based on the password/salt specification. --->
<cfset var tempSecret = keyFactory.generateSecret(keySpec) />
<!--- Generate the AES key based on our secret key. --->
<cfset var secretKey = createObject("java", "javax.crypto.spec.SecretKeySpec").init(tempSecret.getEncoded(), "AES") />
<!--- Return the generated key as a Base64-encoded string. --->
<cfreturn toBase64(secretKey.getEncoded()) /> 
</cffunction>

<!--- Password method, generates an AES key based on a password and salt. --->

<!--- User would provide their encryption password to the system. --->
<!--- Password is case-sensitive and could be passed through LCase() or UCase() to negate case. --->
<cfset myPassword = "this is the password" />

<!--- The system would generate a salt in Base64 for their account. --->
<!--- The salt is used by the key generator to help mitigate against dictionary attacks. --->
<!--- It's recommended to use a salt generated based on Java's SecureRandom object. Bill Shelton wrote a genSalt() function in CF to do just that, available at http://blog.mxunit.org/2009/06/look-ma-no-password-secure-hashing-in.html --->
<cfset mySalt64 = toBase64("some salt string") />

<!--- Call the password-based key generator with the password and salt. --->
<cfset generatedKey = genAESKeyFromPW(myPassword, mySalt64) />

<!--- The generated key drops right in where a key from generateSecretKey("AES") would normally go. ---> 
<cfset encrypted = encrypt("Hello World!", generatedKey, "AES", "Base64") />

<p><cfoutput>encrypted: #encrypted#</cfoutput></p>

<!--- Decryption works the same way. --->
<cfset decrypted = decrypt(encrypted, generatedKey, "AES", "Base64") />

<p><cfoutput>decrypted: #decrypted#</cfoutput></p>