package;

import cmd.Build;
import cmd.Clean;
import cmd.Resources;
import cmd.Setup;
import utils.Common;
import utils.Log;
import utils.Project;

/** 

    Build: 

    Clean:

    Resources:

    Setup:

**/

class Entry {

    public static function main() {
        
        var _args:Array<String> = Sys.args();

        var _result:Bool = true;

        var _project:Project = new Project(_args[_args.length - 1]);

        _args.pop();

        if (_args[0] != null) {

            if (_project.parse()) {

                switch(_args[0]) {
                
                    case 'build':
                    
                        if (runResources(_project, _args[1])) {

                            _result = runBuild(_project, _args[1]);
                        }

                        if (_project.debug) {

                            //runClean(_project, _args[1]);
                        }
                        
                    case 'clean':
                        
                        _result = runClean(_project, _args[1]);

                    case '_setup':

                        _result = runSetup(_project, _args[1]);

                        //project.generate();

                    case 'resources':

                        _result = runResources(_project, _args[1]);

                    default:
        
                        /** If argument is not supported... **/

                        Log.print('Invalid argument found.');
                }
            }
            else {

                /** Invalid project file has been found... **/

                Log.print('Invalid project file.');

                /** Exit the application. **/
                
                Sys.exit(0);
            }
        }
        else {

            /** If no argument has been found... **/

            Log.print('No argument has been found. No task to complete.');

            /** Exit the application. **/
            
            Sys.exit(0);
        }

        if (_result) {

            /** If the action was successful... **/

            Log.print('Task `'+ _args[0] + '` has been successfully completed.');

        }
        else {

            /** If not... **/

            Log.print('Task has been stopped due an error.');
        }

        //** Sleep 1 sec. **/

        //Sys.sleep(1);

        /** Exit the application. **/
            
        Sys.exit(0);
    }

    public static function runBuild(project:Project, arg:String):Bool {

        if (arg == null) {

            Log.print('Null argument for `build`.');

            return false;
        }

        var _build:Build = new Build(project);

        return _build.run(arg);
    }

    public static function runClean(project:Project, arg:String) {
        
        var clean:Clean;

        var result:Bool = false;

        if (project.parse()) {

            var _arg:String = 'windows';

            clean = new Clean(project);

            if (_arg != null) {

                _arg = arg;
            }

            result = clean.run(arg);
        }

        return result;
    }

    public static function runResources(project:Project, arg:String):Bool {

        if (arg == null) {

            Log.print('Null argument for `resources`.');

            return false;
        }

        var resources:Resources = new Resources(project);

        return resources.run(arg);
    }

    public static function runSetup(project:Project, arg:String):Bool {

        var setup:Setup;

        var result:Bool = false;

        if (!Common.isNull(project.path)) {

            var _arg:String = 'default';

            setup = new Setup(project);

            if (_arg != null) {

                _arg = arg;
            }

            result = setup.run(arg);
        }

        return result;
    }
}