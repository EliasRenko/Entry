package cmd;

import sys.FileSystem;
import sys.io.File;
import utils.Project;
import utils.Log;

class Setup {

    /** Privates. **/

    /* @private */ private var __project:Project;

    /* @private */ private var __directoryName:String;

    public function new(project:Project) {
        
        __project = project;
    }

    public function run(arg:String):Bool {

        switch(arg) {

            case 'default':

            default:

                Log.print('Invalid argument found.');

                return false;
        }

        try {

        }
        catch(message:String) {

            Log.print('Error at setup task: ' + message);

            return false;
        }

        return true;
    }
}