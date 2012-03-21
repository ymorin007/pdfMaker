<!--- 

Author : YaNnIcK MoRiN
Find me at : Google+, Github or at the beach.

 --->

<cfcomponent output="false" mixin="controller">

	<cffunction name="init">
		<cfset this.version = "1.1.4">
		<cfreturn this>
	</cffunction>

	<cffunction name="createPDF" hint="Hummmm....I think I will create a PDF today!!!">
		
		<cfargument name="doctype" type="string" default="partial" required="false" hint="choose the type of content to print to the pdf.  You can choose between : partial | url | text.">
		
		<cfargument name="partial" type="any" required="false"
					hint="The name of the partial file to be used for the content. ONLY if you have selected type(partial)">

		<cfargument name="url" type="string" required="false" 
					hint="The url to grab for the document content. Default is the current page. ONLY if you have selected type(url).">

		<cfargument name="text" type="string" required="false"
					hint="The text to grab for the document content. ONLY if you have selected type(text).">

		<cfargument name="sendToFile" type="string" required="false" default="browser"
					hint="Save to file.  Otherwise send to browser">

		<cfargument name="pathTofilename" type="string" required="false"
					hint="Path to the filename. By default its /files. ONLY if you have selected sendToFile(true)">

		<cfargument name="filename" type="string" required="false" default="browser"
					hint="Name of a file to contain the PDF. ONLY if you have selected sendToFile(true)">

		<cfargument name="overwrite" type="boolean" required="false" default="false"
					hint="Specifies whether we should overwrites an existing file. Used in conjunction with the filename attribute. ONLY if you have selected sendToFile(true)">

		<cfargument name="orientation" type="string" required="false" default="portrait"
					hint="Page orientation: portrait | landscape">

		<cfargument name="footer" type="string" required="false" default=""
					hint="Text to add to the footer">

		<cfargument name="header" type="string" required="false" default=""
					hint="Text to add to the header">

		<cfset var loc = {}>
		
		<cfset loc.thisPath = ExpandPath("*.*")>
		<cfset loc.thisDirectory = GetDirectoryFromPath(loc.thisPath)>
		<cfset loc.filename = "browser">
		<cfset loc.document = "">
		<cfset docheader = arguments.header>
		<cfset docfooter = arguments.footer>
		
		<cfset loc.pathToFilename = loc.thisDirectory & application.wheels.filePath>
		
		<cfif StructKeyExists(arguments, "filename")>
			<cfset loc.filename = arguments.filename>
		</cfif>	
		
		<!--- Get the document to print to pdf --->
		<cfif arguments.doctype EQ "partial" AND arguments.partial NEQ "">
			<cfif arguments.sendToFile EQ "true">
				<cfdocument format="pdf" filename="#loc.pathToFilename#/#loc.filename#.pdf" overwrite="#arguments.overwrite#" orientation="#arguments.orientation#">
					<cfoutput>
						<cfdocumentitem type="header">#docheader#</cfdocumentitem>
						<cfset c=0>
						<cfloop list="#arguments.partial#" index="i">
							<cfset c=c+1>
							<cfoutput>#includePartial("#i#")#</cfoutput>
							<cfif listLen(arguments.partial) NEQ c>
								<cfdocumentitem type="pagebreak"/>
							</cfif>
						</cfloop>
						<cfdocumentitem type="footer">#docfooter#</cfdocumentitem> 						
					</cfoutput>
				</cfdocument>				
			<cfelse><!--- Send to browser --->
				<cfdocument format="pdf" orientation="#arguments.orientation#">
					<cfoutput>
					<cfdocumentitem type="header">#docheader#</cfdocumentitem>						
					<cfset c=0>
					<cfloop list="#arguments.partial#" index="i">
						<cfset c=c+1>
						<cfoutput>#includePartial("#i#")#</cfoutput>
						<cfif listLen(arguments.partial) NEQ c>
							<cfdocumentitem type="pagebreak"/>
						</cfif>
					</cfloop>
					<cfdocumentitem type="footer">#docfooter#</cfdocumentitem>
					</cfoutput>
				</cfdocument>	
			</cfif>	
		<cfelseif arguments.doctype EQ "url">
			<cfif arguments.url EQ "">
				<cfhttp url="#GetCurrentURL()#" method="get" resolveURL="true">
			<cfelse>	
				<cfhttp url="#arguments.url#" method="get" resolveURL="true">
			</cfif>
			<cfset loc.document = cfhttp.filecontent>
			<cfif arguments.sendToFile EQ "true">
				<cfdocument format="pdf" filename="#loc.pathToFilename#/#loc.filename#.pdf" overwrite="#arguments.overwrite#" orientation="#arguments.orientation#">
					<cfoutput>#loc.document#</cfoutput>
				</cfdocument>				
			<cfelse><!--- Send to browser --->
				<cfdocument format="pdf" orientation="#arguments.orientation#">
					<cfoutput>#loc.document#</cfoutput>
				</cfdocument>	
			</cfif>				
		<cfelseif arguments.doctype EQ "text" AND arguments.text NEQ "">
			<cfif arguments.sendToFile EQ "true">
				<cfdocument format="pdf" filename="#loc.pathToFilename#/#loc.filename#.pdf" overwrite="#arguments.overwrite#" orientation="#arguments.orientation#">
					<cfoutput>#loc.document#</cfoutput>
				</cfdocument>				
			<cfelse><!--- Send to browser --->
				<cfdocument format="pdf" orientation="#arguments.orientation#">
					<cfoutput>#loc.document#</cfoutput>
				</cfdocument>	
			</cfif>	
		</cfif>	
	</cffunction>	
	
	<cffunction name="GetCurrentURL" output="No" access="private">
	    
	    <cfset var theURL = "http">
	    
	    <cfif (cgi.https EQ "on" )><cfset theURL = "https"></cfif>
	    
	    <cfset theURL = theURL & "://#cgi.server_name#">
	    
	    <cfif cgi.server_port IS NOT 80 AND CGI.server_port IS NOT 443>
	        <cfset theURL = theURL & ":#cgi.server_port#">
	    </cfif>
	    
	    <cfset theURL = theURL & getPageContext().getRequest().getRequestURI()>
	    
	    <cfif len(cgi.query_string)><cfset theURL = theURL & "?#cgi.query_string#"></cfif>
	
	    <cfreturn theURL>
	
	</cffunction>	

</cfcomponent>	