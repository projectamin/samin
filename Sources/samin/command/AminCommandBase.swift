import Foundation
import FoundationXML

// This is reflective of Amin::Elt - just found the original naming confusing.
class AminCommandBase: XmlSaxBase {



    func commandMessage() {
        // TODO Dumps success message  / OUT / Error to Log.
    }

    func launchCommand() {

        // TODO Support debug.

        let task = Process()
        // task.launchPath
        // task.arguments =
        // task.environment = // array of var / value
        // task.standardError = // Pipe object - valid on iOS also...
        // task.standardOutput = // Pipe object
    }
}
