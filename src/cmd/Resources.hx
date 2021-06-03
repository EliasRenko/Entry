package cmd;

import sys.FileSystem;
import sys.io.Process;
import utils.Common;
import utils.Project;
import utils.Log;

class Resources {

    // ** Publics.

    /** @private **/ private var __directoryName:String;

    /** @private **/ private var __project:Project;

    public function new(project:Project):Void {

        __project = project;
    }

    public function run(arg:String):Bool {

        switch (arg) {

            case 'windows':

                __directoryName = 'windows';

            case 'web':

                __directoryName = 'web';

            case _:
        }

        if (__project.debug) __directoryName += '.debug';

        for (i in 0...__project.dependencies.length) {

            var _dependencyPath:String = new Process('haxelib', ['libpath', __project.dependencies[i]]).stdout.readAll().toString();

            if (FileSystem.exists(_dependencyPath + 'project.json')) {

                var _dependencyProject:Project = new Project(_dependencyPath + 'project.json');

                Common.copyResources(_dependencyProject, __directoryName);
            }
        }

        Common.copyResources(__project, __directoryName);

        Log.print('Resources has been copied.');

        return true;
    }
}