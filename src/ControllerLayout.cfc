<cfcomponent>

	<cffunction name="init" access="public">
		<cfset this.version = "0.9.4">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="layout">
		<cfargument name="layout" required="true" type="string" />
		<cfscript>
			layouts(arguments.layout);
		</cfscript>
	</cffunction>

	<cffunction name="layouts">
		<cfargument name="layout" required="true" type="string" />
		<cfscript>
			$checkApplicationLayoutStructExists();
			application.layoutFiles[variables.wheels.name]["default"] = arguments.layout;
		</cfscript>
	</cffunction>

	<cffunction name="ajaxLayout">
		<cfargument name="layout" required="true" type="string" />
		<cfscript>
			ajaxLayouts(arguments.layout);
		</cfscript>
	</cffunction>

	<cffunction name="ajaxLayouts">
		<cfargument name="layout" required="true" type="string" />
		<cfscript>
			$checkApplicationLayoutStructExists();
			application.layoutFiles[variables.wheels.name]["ajax"] = arguments.layout;
		</cfscript>
	</cffunction>
	
	<cffunction name="renderPage" returntype="void" access="public" output="false" hint="Renders content to the browser by including the view page for the specified controller and action.">
		<cfargument name="controller" type="string" required="false" default="#variables.params.controller#" hint="Controller to include the view page for">
		<cfargument name="action" type="string" required="false" default="#variables.params.action#" hint="Action to include the view page for">
		<cfargument name="template" type="string" required="false" default="" hint="A specific template to render">
		<cfargument name="layout" type="any" required="false" default="" hint="The layout to wrap the content in">
		<cfargument name="cache" type="any" required="false" default="" hint="Minutes to cache the content for">
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
					
						arguments.layout = application.wheels.renderPage.layout;
					}
				} else {
				
					arguments.layout = application.wheels.renderPage.layout;
				}			
			}
			
			core.renderPage(arguments.controller, arguments.action, arguments.template, arguments.layout, arguments.cache, arguments.$showDebugInformation);
		</cfscript>
	</cffunction>
	
	<cffunction name="$checkApplicationLayoutStructExists">
		<cfscript>
			if (not StructKeyExists(application, "layoutFiles"))
				application.layoutFiles = {};
			if (not StructKeyExists(application.layoutFiles, variables.wheels.name))
				application.layoutFiles[variables.wheels.name] = {};
		</cfscript>
	</cffunction>

</cfcomponent>