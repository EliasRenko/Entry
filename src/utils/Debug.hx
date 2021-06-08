package utils;

import haxe.macro.Context;
import haxe.macro.Expr;

class Debug {

    macro static public function assert(expr:Expr, message:ExprOf<String>):Expr {

        return macro @:pos(Context.currentPos()) {

            if(!$expr) throw utils.Debug.DebugError.assertion($message);
        }

        return macro null;
    }

    macro static public function assertnull(value:Expr, message:ExprOf<String>):Expr {

        return macro @:pos(Context.currentPos()) {

            if($value == null) throw utils.Debug.DebugError.null_assertion($message);
        }

        return macro null;
    }
}

enum DebugError {

    assertion(expr:String);

    null_assertion(expr:String);
}