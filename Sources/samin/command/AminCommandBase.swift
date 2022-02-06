import Foundation
#if canImport(FoundationXML)
import FoundationXML
#endif

// This is reflective of Amin::Elt - just found the original naming confusing.
class AminCommandBase: XmlSaxBase {

    public var directory: String?
    public var flags = [String]()
    public var source = [String]()
    public var parameters = [String]()
    public var command: String?
    public var commandName: String?
    public var attributes: [String : String]?
    public var environmentVariables = [String: String]()
    public var element: String?

    public override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        let prefix = spec?.prefix ?? ""
        let localName = spec?.localname ?? ""
        attributes = attributeDict
        let element = getElement(fullElement: elementName)
        // We double check the current prefix/localname to prevent for example amin::mkdir being executed
        // instead of my_corp::mkdir
        if(element.prefix == prefix && element.localName == localName) {
            if let name = attributeDict["name"] {
                command = name
            } else {
                command = element.localName
            }
        }
        self.element = elementName
        super.parser(_: parser, didStartElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName, attributes: attributeDict)
    }


    func commandMessage(command: String, success: String?, result: CommandResult) {
        // TODO Dumps success message  / OUT / Error to Log.
        let log = spec?.log
        if let status = result.status {
            // TODO implement support for>
            // TODO spec.aminError = "red"
            log?.aminError(message: result.error!)
            if let error = result.error {
                log?.error(message: error)
            }
            if let out = result.out {
                log?.aminOut(message: out)
            }
        } else {
            log?.success(message: success!)
            log?.aminOut(message: result.out!)
        }
    }

    func launchCommand() -> CommandResult {

        var arguments = ["\(command!)"]
        arguments.append(contentsOf: flags)
        arguments.append(contentsOf: parameters)

        // TODO Support debug.
        // TODO get pipe to spec.buffer
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        let task = Process()
        task.environment = environmentVariables
        task.launchPath = "/usr/bin/env"
        task.arguments = arguments
        task.standardError = errorPipe
        task.standardOutput = outputPipe
        task.launch()
        task.waitUntilExit()
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: outputData, encoding: String.Encoding.utf8)
        let error = String(data: errorData, encoding: String.Encoding.utf8)
        let result = CommandResult()
        result.out = output
        result.error = error
        result.status = task.terminationStatus
        if (error != nil && output != nil) {
            result.type = CommandType.both
        } else if (error == nil && output != nil) {
            result.type = CommandType.out
        } else if (error != nil && output == nil) {
            result.type = CommandType.error
        } else {
            // This is for commands like mkdir which dont return anything on success.
            result.type = CommandType.out
        }

        return result
    }
}
