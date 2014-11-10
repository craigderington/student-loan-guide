


				


					
			<!--- // declare some variables we need for the Vanco iFrame URL --->
			<cfparam name="vancostruct" default="">
			<cfparam name="vancoiframeid" default="">			
			<cfparam name="vancoclientid" default="">
			<cfparam name="customerid" default="">
			<cfparam name="customername" default="">
			<cfparam name="customeraddress" default="">
			<cfparam name="customercity" default="">
			<cfparam name="customerstate" default="">
			<cfparam name="customerzip" default="">
			<cfparam name="returnURL" default="">
			<cfparam name="vancocreds" default="">
			
			
			<!--- // get our data access components 
			
			<cfinvoke component="apis.com.system.companysettings" method="getcompanysettings" returnvariable="companysettings">
				<cfinvokeargument name="companyid" value="#session.companyid#">
			</cfinvoke>
			
			<cfset vancoenckey = companysettings.vancoenckey />
			<cfset vancoappver3 = listgetat( companysettings.vancourlpath, 2, "?" ) />
			<cfset vancoappver3 = removechars( vancoappver3, 1, 8 ) />
			
			
			--->
			
			
			<cfset vancoenckey = tobase64( "jfhdusywlf83jx@37$2idksu9Kdheokq" ) />
			<cfset vancoiframeid = "DS2329-BK712" />
			<cfset vancoclientid = "DS2329-BK" />
			<cfset customerid = "99871" />
			<cfset customername = "Craig Derington" />
			<cfset customeraddress = "1234 Main Street" />
			<cfset customercity = "Orlando" />
			<cfset customerstate = "FL" />
			<cfset customerzip = "32808" />		
			<cfset returnurl = "http://67.79.186.26/efiscalv3/thistest.cfm?vws=true" />
			
					
			
			<cfscript>			 
				 vancostruct = structnew();
					structinsert( vancostruct, "iframeid", vancoiframeid );
					structinsert( vancostruct, "clientid", vancoclientid );
					structinsert( vancostruct, "customerid", customerid );					
					// structinsert( vancostruct, "customername", customername );
					// structinsert( vancostruct, "returnurl", returnurl );
			 </cfscript>
			 
			
			<!--- // remove for test --->
			<cfset vancopacket = serializejson( vancostruct ) />
			
			
			<!--- // begin compression using the jzlib library --->
			<cfobject 
					class = "com.jcraft.jzlib.Deflate"
					type = "Java" 
					name = "zlib" 
					action = "create"
				>			
			<!--- use the Java object to deflate our vanco packet, which is a json string, 
            ---> 
			
			<cfset compr = zlib.deflate() /> 
			<cfset thisnewvalue = compr( vancopacket ) /> 
			
			<!--- 
			<cfset IntVal = obj.Add(JavaCast("int",20),JavaCast("int",30))> 
			<cfset FloatVal = obj.Add(JavaCast("float",2.56),JavaCast("float",3.51))> 
			--->
			
			<!--- Display the results ---> 
			<cfoutput> 
				<br> 
				New String Value: #thisnewvalue#<br>				
				<br> 
			</cfoutput> 
						
			

			
			
			
			
						
			<!--- // the vanco web services credentials and query string values 
			<cfset vancocreds = encrypt( vancopacket, vancoenckey, "AES/CBC/PKCS5Padding", "base64" ) />				
			<cfset vancocreds = urlencodedformat( vancocreds ) />
			--->
			
			
			<div class="main">	
				
				<div class="container">
					
					<div class="row">
			
						<div class="span12">
						
							<div class="widget stacked">
								
								<div class="widget-header">
									<i class="icon-money"></i>
									<h3> Test Vanco Web Services Integration</h3>								
								</div>
								
								<div class="widget-content">
								
								
								
									<cfoutput>
										
										
										<!--- // load the vanco web services iframe intergration 
										
										<iframe id="#vancoiframeid#" seamless width="360" height="300" align="center" src="https://www.vancodev.com/cgi-bin/vancotest_ver3.vps?appver3=owQYbecXmO4hpXGzupWAdUh1eSX88q1BHSCftZwn1zOojaIITxf2k_u6ktwGL51sHmkP09_f-qHggHpYhdue-eHYwZh71bQ3xoCyFvDXsEmqwKqjhyRe8XhUeYHCPQew?&credentials=#vancocreds#" />
										
										</iframe>					
										---> 
										<br />
										<br />
										
										<p>Vanco Encryption Key:  #vancoenckey#</p>
										
										<br />
										
										<!--- // 
										Vanco Full URL Encoded/Encrypted Data Packet: #vancocreds#
										
										<br />
										
										--->
										
										Vanco JSON Formatted String: #vancopacket#
										
										<br />
										
										
										<p>
										   <cfdump var="#vancostruct#" label="this-struct">
										</p>
										
										<br />
										
										#compr#
									
									</cfoutput>					
								</div>
							</div>
						
						</div>
					
					</div>
				
				</div>
			
			
			</div>