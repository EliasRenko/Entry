package utils;

import haxe.Exception;
import haxe.Json;
import sys.io.File;

class Resources {

    public static function getProject(path:String):Pro {
        
        // ** Local functions.

        function isNull<T>(name:String, value:T, defaultValue:T):T {
            
            if (value == null) {

                return defaultValue;
            }

            return value;
        }

        // **

        var _projectSource:String;

        var _projectJson:Dynamic;

        try {

            _projectSource = File.getContent('${path}project.json');
        }
        catch(e:Exception) {

            throw 'Project file does not exist: ${e}';
        }

        try {

            _projectJson = Json.parse(_projectSource);
        }
        catch(e:Exception) {

            throw 'Failed to parse the project file: ${e}';
        }

        var _project:Pro = {

            name: isNull('name', _projectJson.Project.Name, "default"),

            applicationId: isNull('applicationId', _projectJson.Project.App.Package, "Your name"),

            author: isNull('author', _projectJson.Project.Author, "Your name"),

            debug: null,

            dependencies: isNull('dependencies', _projectJson.Project.Build.Dependencies, []),

            flags: isNull('flags', _projectJson.Project.Build.Flags, []),

            mainClass: isNull('mainClass', _projectJson.Project.Build.MainClass, "Main"),

            path: path,

            sourcePath: isNull('source', _projectJson.Project.Build.SourceFolder, "src"),

            resourcePath: isNull('Resources', _projectJson.Project.Build.ResourcesFolder, "res"),

            version: isNull('Version', _projectJson.Project.Version, "0")
        };

        return _project;
    }
}