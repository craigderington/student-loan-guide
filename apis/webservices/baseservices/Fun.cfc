		
		
		
		
		
		<cfcomponent
			displayname="Fun"
			extends="BaseWebService"
			output="false"
			hint="Handles web services that are fun and experimental.">
		 
		 
			<cffunction
				name="GetCompliment"
				access="remote"
				returntype="string"
				output="false"
				hint="This returns a random compliment.">
		 
				<!--- Define arguments. --->
				<cfargument name="Gender" type="string" required="false" default="" />
		 
				<cfscript>
		 
					// Define the local scope.
					var LOCAL = StructNew();
		 
					// Set up non-gender based compliments.
					LOCAL.Universal = ArrayNew( 1 );
					LOCAL.Universal[ 1 ] = "You are a great person.";
					LOCAL.Universal[ 2 ] = "I wish I had more friends like you.";
					LOCAL.Universal[ 3 ] = "You are too nice to people.";
					LOCAL.Universal[ 4 ] = "You are my Go-To guy!";
					LOCAL.Universal[ 5 ] = "I really appreciate what you do.";
		 
					// Set up female compliments.
					LOCAL.Female = ArrayNew( 1 );
					LOCAL.Female[ 1 ] = "You're hair really looks nice today.";
					LOCAL.Female[ 2 ] = "Those are some great shoes!";
					LOCAL.Female[ 3 ] = "You are a great woman.";
		 
					// Set up male compliments.
					LOCAL.Male = ArrayNew( 1 );
					LOCAL.Male[ 1 ] = "You look great! Have you been working out?";
					LOCAL.Male[ 2 ] = "Dude, that's a rockin' mustache.";
					LOCAL.Male[ 3 ] = "You are a great dude.";
		 
					// Pick the type of compliment we will be doling out.
					switch ( ARGUMENTS.Gender ){
						case "M":
							LOCAL.Compliments = LOCAL.Male;
							break;
						case "F":
							LOCAL.Compliments = LOCAL.Female;
							break;
						default :
							LOCAL.Compliments = LOCAL.Universal;
							break;
					}
		 
					// Return a random compliment.
					return(
						LOCAL.Compliments[
							RandRange(
								1,
								ArrayLen( LOCAL.Compliments )
								)
							]
						);
		 
				</cfscript>
			</cffunction>
		 
		</cfcomponent>