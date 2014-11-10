				
				
				
				<cfset ws = {
				clientID = "WS1187EFI",
				requestID = "110514410900000636",
				requestdate = "11/05/2014",
				clientstatus = "active",
				sortorder = "desc"				
				} />
				
				<cfset wsobj = serializejson( ws ) />
				
				
				
				<cfset thispath = "D:/WWW/studentloanadvisoronline.com/apis/dotnet/vanco/cryption.dll" />				
				<cfset thismessage = wsobj />
				<cfset theKey = "5b!R-j0E12LF9m6s8qzgNtMvBk74KX3T" />
				
				<!--- // create a new instance of our .net object and reference our new DLL path --->
				<cfobject
					type=".NET"				
					class="Cryption.CryptionUtils"
					assembly="D:/WWW/studentloanadvisoronline.com/apis/dotnet/vanco/cryption.dll"
					name="encryptLoginResponsePacket">				
							
					<!--- // intialize our custom vanco .net component --->
					<cfset encryptLoginResponsePacket.init() />				
					<cfset message = thismessage />
					<cfset getEncryptedMessage = encryptLoginResponsePacket.EncryptAndEncodeMessage( message, theKey ) />					
					<cfset thisEncryptedMessage = replace( replace(  getEncryptedMessage, "+", "-", "all"), "/", "_", "all" )>
				
				
					<cfoutput>					
						#thispath#
						<br />						
						#thisencryptedmessage#
					</cfoutput>