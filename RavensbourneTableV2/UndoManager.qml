import QtQuick 2.7

QtObject {
    property bool canUndo: __command_index >= 0
    property bool canRedo: __command_index < __commands.length - 1

    readonly property string undoText: __undoText()
    readonly property string redoText: __redoText()

    readonly property bool clean: __isClean()

    property var __commands: []
    property int __command_index: -1
    property int __clean_index: -1

    function clear() {
        __clean_index = -1;
        __command_index = -1;
        __commands = [];
    }

    function push(action_text, params, redo_method, undo_method) {
        var command = {
            "action_text": action_text,
            "params": params,
            "redo_method": redo_method,
            "undo_method": undo_method
        };

        if (__command_index !== __commands.length - 1)
            __commands.splice(__command_index + 1, __commands.length);

        __commands.push(command);
        // TODO: restore this???
        // redo();
        __command_index += 1;
        canUndo = __command_index >= 0;
        canRedo = __command_index < __commands.length - 1;
    }

    function redo() {
        if (__canRedo()) {
            __command_index += 1;

            var command = __commands[__command_index];
            command.redo_method(command.params);

            canUndo = __command_index >= 0;
            canRedo = __command_index < __commands.length - 1;

        }
    }

    function undo() {
        if (__canUndo()) {
            var command = __commands[__command_index];
            command.undo_method(command.params);

            __command_index -= 1;

            canUndo = __command_index >= 0;
            canRedo = __command_index < __commands.length - 1;
        }
    }

    function setClean() {
        __clean_index = __command_index;
    }



    function __canUndo() {
        return __command_index >= 0;
    }

    function __canRedo() {
        return __command_index < __commands.length - 1;
    }

    function __undoText() {
        return __canUndo() ? __commands[__command_index].action_text : "";
    }

    function __redoText() {
        return __canRedo() ? __commands[__command_index + 1].action_text : "";
    }

    function __isClean() {
        return __command_index === __clean_index;
    }
}
