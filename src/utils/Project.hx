package utils;

import haxe.io.Path;
import sys.io.Process;
import sys.io.File;
import utils.Log;
import haxe.Json;
import sys.FileSystem;
import utils.Common;

class Project {

    // ** Publics.
    
    public var appName:String;

    public var appPackage:String;

    public var assetsDirectory:String;

    public var author:String;

    public var dependencies:Array<String> = new Array<String>();

    public var debug:Bool = false;

    public var fileDirectories:Array<String> = new Array<String>();

    public var flags:Array<String> = new Array<String>();

    public var folders:Array<String> = new Array<String>();

    public var path(get, null):String;

    public var mainClass:String;

    public var name:String;

    public var sourceDirectory:String;

    public var version:String;

    public var nodes:Map<String, String> = new Map<String, String>();

    // ** Privates.

    /** @private **/ private var __path:String;

    public function new(path:String) {

        __path = path;
    }

    public function parse():Bool {

        //var _files:Array<String> = FileSystem.readDirectory(__path);

        var _project:Dynamic;

        var _projectSource:String = File.getContent(__path + 'project.json');

        try {

            _project = Json.parse(_projectSource);

        }
        catch(message:String) {

            Log.print('Failed to parse the project file.');

            return false;
        }

        /** The name of the project. **/

        name = isNull('Project name', _project.Project.Name, "defaultProject");

        nodes.set("name", isNull('Project name', _project.Project.Name, "defaultProject"));

        /** The author of the project. **/

        author = isNull('Author', _project.Project.Author, "Your name");

        nodes.set('author', isNull('Author', _project.Project.Author, "Your name"));

        /** The build version of the project. **/

        version = isNull('Version', _project.Project.Version, "0.0.1");

        nodes.set('version', isNull('Version', _project.Project.Version, "0.0.1"));

        /** The name of the application. **/

        appName = isNull('App name', _project.Project.App.Name, "template");

        nodes.set('title', isNull('Title', _project.Project.App.name, "template"));

        /** The package of the application. **/

        appPackage = isNull('Package', _project.Project.App.Package, "org.drc.template");

        nodes.set('package', isNull('Package', _project.Project.App.Package, "org.drc.template"));

        /** The main class of the application. **/

        mainClass = isNull('Main class', _project.Project.Build.MainClass, "Main");

        nodes.set('main', isNull('Main class', _project.Project.Build.MainClass, "Main"));

        /** The source director of the project. **/

        sourceDirectory = isNull('Source', _project.Project.Build.SourceFolder, "src");

        nodes.set('source', isNull('Source', _project.Project.Build.SourceFolder, "src"));
        
        /** The asset directory of the project. **/

        assetsDirectory = isNull('Resources', _project.Project.Build.ResourcesFolder, "res");

        nodes.set('assets', isNull('Resources', _project.Project.Build.SourceFolder, "res"));
		
		var _folders:Dynamic = Reflect.field(_project.Project, "Folders");
		
		for (i in 0..._folders.lenght) 
		{
			folders.push(_folders[i]);
		}
		
        var _dependencies:Dynamic = Reflect.field(_project.Project.Build, 'Dependencies');

        for (i in 0..._dependencies.length) {

            var _dependency:String = _dependencies[i];

            dependencies.push(_dependency);

            var _dependencyPath:String = new Process('haxelib', ['libpath', _dependency]).stdout.readAll().toString();
        }

        var _flags:Dynamic = Reflect.field(_project.Project.Build, 'Flags');

        for (i in 0..._flags.length) {

            var _flag:String = _flags[i];

            flags.push(_flag);

            if (flags[i].toLowerCase() == '-debug') debug = true;
        }

        Log.print('Project file has been imported.');

        return true;
    }

    public function generate():Bool {

        var srcPath:String = haxe.io.Path.directory(Sys.programPath()) + '/res/project.json';

        var dstPath:String = __path + 'project.json';

        try {

            sys.io.File.copy(srcPath, dstPath);
        }
        catch (message:String) {

            Log.print('Error occurred: ' + message);

            return false;
        }

        //var file = sys.io.File.getContent(srcPath);

        //sys.io.File.saveContent(__path + 'project.json', file);

        Log.print('A new project file has been generated.');

        return true;
    }

    private function isNull(name:String, value:String, defaultValue:String) {

        if (Common.isNull(value)) {

            Log.print('Attribute: `${name}` does not have a value.');

            return value = defaultValue;
        }

        return value;
    }

    private function __getHaxelib(name:String):Array<String> {

        var _dependencies:Array<String> = new Array<String>();

        return dependencies;
    }

    //** Getters and setters. **/

    public function get_path():String {

        return __path;
    }
}