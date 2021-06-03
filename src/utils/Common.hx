package utils;

import sys.FileStat;
import sys.io.File;
import sys.FileSystem;
import utils.Log;

class Common {

    public static function copyResources(__project:Project, __directoryName:String):Bool {

        var _assetsDirectory:String = __project.path + __project.assetsDirectory;

        if (FileSystem.exists(_assetsDirectory)) {

            if (!FileSystem.isDirectory(_assetsDirectory)) {

                Log.print('Assigned asset folder: ' + __project.assetsDirectory + ', is missing.');
            }
        }
        else {

            Log.print('Assigned asset folder: ' + __project.assetsDirectory + ', is missing.');

            return false;
        }

		var _assetsFolders:Array<String> = FileSystem.readDirectory(__project.path + __project.assetsDirectory);

        for (i in 0..._assetsFolders.length) {

            var currentDir:String = __project.path + __project.assetsDirectory + '/' + _assetsFolders[i];

            if (FileSystem.isDirectory(currentDir)) {

                if (!FileSystem.exists(__project.path + 'bin/' + __directoryName + '/' + __project.assetsDirectory + '/' + _assetsFolders[i])) {

                    FileSystem.createDirectory(__project.path + 'bin/' + __directoryName + '/' + __project.assetsDirectory + '/' + _assetsFolders[i]);
                }

                var files:Array<String> = FileSystem.readDirectory(currentDir);

                for (j in 0...files.length) {

                    if (!FileSystem.isDirectory(currentDir + '/' + files[j])) {

                        var _destFile:String = __project.path + 'bin/' + __directoryName + '/' + __project.assetsDirectory + '/' + _assetsFolders[i] + '/' + files[j];

                        var _sourceFileStat:FileStat = FileSystem.stat(currentDir + '/' + files[j]);

                        if (FileSystem.exists(_destFile)) {

                            var _destFileStat:FileStat = FileSystem.stat(_destFile);

                            if(!(_sourceFileStat.mtime.getTime() > _destFileStat.mtime.getTime())) {

                                continue;
                            }
                        }
                        
                        File.copy(currentDir + '/' + files[j], _destFile);
                    }
                }
            }
        }

        return true;
    }

    public static function isNull(value:String):Bool {

        if (value == null || value == '') {

            return true;
        }

        return false;
    }

    public static function createWebHeader(path:String):Bool {

        var color:String = '#111111';

        var jsSource:String = 'main.js';

        var indexSource:String = 

        '<!DOCTYPE html>

        <html lang="en">
        
            <head>
        
                <link rel="icon" href="favicon.png"/>
        
                <meta charset="utf-8">
        
                <style>
        
                    #app {
        
                        display: block;
        
                        position: relative;
        
                        margin: 2em auto 0 auto;
                    }
        
                </style>
        
            </head>
        
            <body style="padding: 0; margin: 0; background-color: ${color};">
        
                <script type="text/javascript" src="./${jsSource}"></script>
        
            </body>
        
        </html>';

        var dstPath:String = path + 'bin/web.debug/' + 'index.html';

        try {

            sys.io.File.saveContent(dstPath, indexSource);
        }
        catch (message:String) {

            Log.print('Error on generating a header file: ' + message);

            return false;
        }

        return true;
    }
}