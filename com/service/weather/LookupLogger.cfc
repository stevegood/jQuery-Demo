<cfcomponent output="false">
	
	<cffunction name="init" access="public" returntype="LookupLogger" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="recordLookup" access="public" returntype="void" output="false">
		<cfargument name="zip" type="string" required="true" />
		
		<cfset local.lookup = new Lookup() />
		<cfset local.lookup.setLookupDate(now()) />
		<cfset local.lookup.setZip(arguments.zip) />
		<cfset entitySave(local.lookup) />
		
	</cffunction>
	
	<cffunction name="getRecentLookups" access="public" returntype="array" output="false">
		<cfargument name="count" type="numeric" required="true" />
		
		<cfset local.lookups = entityLoad("Lookup",{}, "lookupid desc",{maxresults=arguments.count}) />
		
		<cfif !structKeyExists(local,'lookups') || isNull(local.lookups)>
			<cfreturn [] />
		</cfif>
		
		<cfreturn local.lookups />
	</cffunction>
	
</cfcomponent>