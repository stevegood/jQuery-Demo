<cfcomponent output="false" persistent="true">
	
	<cfproperty name="lookupid" fieldtype="id" generator="native" />
	<cfproperty name="zip" type="string" required="true" />
	<cfproperty name="lookupDate" type="date" required="true" fieldtype="timestamp" />
	
</cfcomponent>