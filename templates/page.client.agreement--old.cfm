


			<cfdocument 
				format = "PDF"			
				fontEmbed = "yes"				
				localUrl = "yes" 
				marginBottom = "0.5" 
				marginLeft = "0.5" 
				marginRight = "0.5" 
				marginTop = "0.5" 
				mimeType = "text/plain" 
				name = "clientagreement" 				
				orientation = "portrait" 
				overwrite = "yes"				
				saveAsName = "client-agreement.pdf"				
				srcfile = "D:\wwwroot\studentloanadvisoronline.com\docs\SLA-Client-Agreement.rtf">	
				
				
			</cfdocument>
			
			<cfcontent type="application/pdf" reset="true" variable="#tobinary( clientagreement )#">