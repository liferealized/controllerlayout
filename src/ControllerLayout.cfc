<cfcomponent>

	<cffunction name="init" access="public" output="false">
		<cfscript>
			if (StructKeyExists(application, "layoutFiles"))
				StructDelete(application, "layoutFiles");
			
			this.version = "1.0";
		</cfscript>
		<cfreturn this />
	</cffunction>
	
	<cffunction name="layout" output="false" access="public" returntype="void" mixin="controller">
		<cfargument name="layout" required="true" type="string" />
		<cfscript>
			layouts(arguments.layout);
		</cfscript>
	</cffunction>
	
	<cffunction name="layouts" output="false" access="public" returntype="void" mixin="controller">
		<cfargument name="layout" required="true" type="string" />
		<cfscript>
			$checkApplicationLayoutStructExists();
			application.layoutFiles[variables.wheels.name]["default"] = arguments.layout;
		</cfscript>
	</cffunction>

	<cffunction name="ajaxLayouts" output="false" access="public" returntype="void" mixin="controller">
		<cfargument name="layout" required="true" type="string" />
		<cfscript>
			$checkApplicationLayoutStructExists();
			application.layoutFiles[variables.wheels.name]["ajax"] = arguments.layout;
		</cfscript>
	</cffunction>
	
	<cffunction name="renderPage" returntype="void" access="public" output="false" mixin="controller">
		<cfargument name="controller" type="string" required="false" default="#variables.params.controller#" hint="Controller to include the view page for">
		<cfargument name="action" type="string" required="false" default="#variables.params.action#" hint="Action to include the view page for">
		<cfargument name="template" type="string" required="false" default="" hint="A specific template to render">
		<cfargument name="layout" type="any" required="false" default="" hint="The layout to wrap the content in">
		<cfargument name="cache" type="any" required="false" default="" hint="Minutes to cache the content for">
		<cfargument name="returnAs" type="string" required="false" default="" hint="Set to `string` to return the result to the controller instead of sending it to the browser immediately">
		<cfargument name="$showDebugInformation" type="any" required="false" default="#application.wheels.showDebugInformation#">
		<cfscript>
			$checkApplicationLayoutStructExists();
		
			if (not Len(arguments.layout)) {
				// no layout was specified so lets see if we have called layout()
				if (StructKeyExists(application, "layoutFiles")) {
					
					if (isAjax() and StructKeyExists(application.layoutFiles[variables.wheels.name], "ajax")) {
					
						arguments.$showDebugInformation = false;
						arguments.layout = application.layoutFiles[variables.wheels.name]["ajax"];
						
					} else if (StructKeyExists(application.layoutFiles[variables.wheels.name], "default")) {
					
						arguments.layout = application.layoutFiles[variables.wheels.name]["default"];
						
					} else {
					
						arguments.layout = application.wheels.functions.renderPage.layout;
					}
				} else {
				
					arguments.layout = application.wheels.functions.renderPage.layout;
				}			
			}
			
			core.renderPage(arguments.controller, arguments.action, arguments.template, arguments.layout, arguments.cache, arguments.returnAs, arguments.$showDebugInformation);
		</cfscript>
	</cffunction>
	
	<cffunction name="$checkApplicationLayoutStructExists" output="false" access="public" returntype="void" mixin="controller">
		<cfscript>
			if (not StructKeyExists(application, "layoutFiles"))
				application.layoutFiles = {};
			if (not StructKeyExists(application.layoutFiles, variables.wheels.name))
				application.layoutFiles[variables.wheels.name] = {};
		</cfscript>
	</cffunction>

</cfcomponent>