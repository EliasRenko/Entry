package cmd;

import sys.FileSystem;
import utils.Project;
import utils.Log;

class Clean {

    /** Privates. **/

    /* @private */ private var __directoryName:String;

    /* @private */ private var __project:Project;

    public function new(project:Project) {

        __project = project;
    }

    public function run(arg:String):Bool {

        switch(arg) {

            case 'web':

                __directoryName = 'web';

            case 'windows':

                __directoryName = 'windows';

            default:
        }

        try {

            var _directory:String = __project.path + 'bin/' + __directoryName;

            var _files:Array<String> = FileSystem.readDirectory(_directory);

            clearDirectory(_directory, _files);
        }
        catch(message:String) {

            Log.print('Error at clean task: ' + message);

            return false;
        }

        return true;
    }

    public function clearDirectory(directory:String, files:Array<String>):Void {

        for (i in 0...files.length)
        {
            if (FileSystem.isDirectory(directory + '/' + files[i])) {

                var _files:Array<String> = FileSystem.readDirectory(directory + '/' + files[i]);

                clearDirectory(directory + '/' + files[i], _files);

                FileSystem.deleteDirectory(directory + '/' + files[i]);
            }
            else {

                FileSystem.deleteFile(directory + '/' + files[i]);
            }
        }
    }
}