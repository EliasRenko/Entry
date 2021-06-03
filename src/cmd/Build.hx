package cmd;

import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
import utils.Common;
import utils.Log;
import utils.Project;

class Build {

    // ** Privates.

    /** @private **/ private var __directoryName:String;

    /** @private **/ private var __project:Project;

    public function new(project:Project):Void {

        __project = project;
    }

    public function run(arg:String):Bool {

        var _hxmlArgs:Array<String> = [];

        _hxmlArgs.push('-main');

        _hxmlArgs.push('drc.core.App');

        _hxmlArgs.push('-cp');

        _hxmlArgs.push(__project.path + __project.sourceDirectory);

        switch(arg) {

            case 'web':

                __directoryName = 'web';

                if (__project.debug) __directoryName += '.debug';

                _hxmlArgs.push('-js');

                _hxmlArgs.push(__project.path + 'bin/' + __directoryName + '/main.js');

            case 'windows':

                __directoryName = 'windows';

                if (__project.debug) __directoryName += '.debug';

                _hxmlArgs.push('-cpp');

                _hxmlArgs.push(__project.path + 'bin/' + __directoryName);

            case _:
        }

        // ** ---

        for (i in 0...__project.dependencies.length) {

            var _dependencyPath:String = new Process('haxelib', ['libpath', __project.dependencies[i]]).stdout.readAll().toString();

            if (FileSystem.exists(_dependencyPath + 'project.json')) {

                var _dependencyProject:Project = new Project(_dependencyPath + 'project.json');

                Common.copyResources(_dependencyProject, __directoryName);
            }
        }

        Common.copyResources(__project, __directoryName);
		
        for (i in 0...__project.dependencies.length) {

            _hxmlArgs.push('-lib');

            _hxmlArgs.push(__project.dependencies[i]);
        }

        for (i in 0...__project.flags.length) {

            var _r = ~/[ ]+/g;

            var _flags:Array<String> = _r.split(__project.flags[i]);

            for (j in 0..._flags.length) {

                _hxmlArgs.push(_flags[j]);
            }
        }

        if (!sys.FileSystem.exists(__project.path + 'bin/' + __directoryName)) {

            sys.FileSystem.createDirectory(__project.path + 'bin/' + __directoryName);
        }

        //_hxmlArgs.push("-D");

        //_hxmlArgs.push("mingw");

        _hxmlArgs.push("--macro");

        //_hxmlArgs.push("include(\"src/" + __project.mainClass + "\", true)");

        _hxmlArgs.push("keep(\"src/" + __project.mainClass + "\")");

        _hxmlArgs.push(__project.mainClass);

        //--macro keep(?path:String, ?paths:Array<String>, recursive=true)

        var _result:Int = Sys.command('haxe', _hxmlArgs);

        var _hxml:String = "";

        _hxmlArgs.pop();

        for (i in 0..._hxmlArgs.length) {

            _hxml += _hxmlArgs[i] + " ";

            if (i < _hxmlArgs.length - 1) {

                if (_hxmlArgs[i + 1].charAt(0) == "-") {

                    _hxml += "\n";
                }
            }
        }

        /** If result... **/

        if (_result != 0) {

            /** Log Error. **/

            Log.print('Build failed with compilation errors.');

            return false;
        }

        File.saveContent(__project.path + "/build.hxml", _hxml);

        /** Succsesfull compilation. **/

        Log.print('Build success without compilation errors.');

        if (arg == 'web') {

            Common.createWebHeader(__project.path);
        }

        if (arg == 'windows' && __project.debug) {

            var _appName:String = "";

            if(__project.debug) {

                _appName = '/App-debug.exe';
            }
            else {

                _appName = '/App.exe';
            }

            //Sys.command(__project.path + 'bin/' + __directoryName + _appName);
        }

        return true;
    }
}