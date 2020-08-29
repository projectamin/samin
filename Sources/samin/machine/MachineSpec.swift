//
// Created by swishy on 29/08/20.
//

import Foundation
import FoundationXML

class MachineSpec: XmlSaxBase {

    // TODO make this pluggable so we can pull from NSBundle on iOS
    func getMachineSpecPath() -> String {
        let fileManager = FileManager()
        if let home = ProcessInfo.processInfo.environment["HOME"] {
            if(fileManager.fileExists(atPath: home + "/.amin/machine_spec.xml")) {
                return home + "/.amin/machine_spec.xml"
            }
        }
        if let envSpec = ProcessInfo.processInfo.environment["AMIN_MACHINE_SPEC"] {
            if(fileManager.fileExists(atPath: envSpec)) {
                return envSpec
            }
        }
        return "/etc/machine_spec.xml"
    }

    override func parserDidStartDocument(_ parser: XMLParser) {
        print("machine spec start doc")

        var machineSpecUrl = URL(string: getMachineSpecPath())!
        print(machineSpecUrl)

        var handler = Document()
        var include = XInclude()
        include.delegate = handler

        var fileHandle = FileHandle(forReadingAtPath: getMachineSpecPath())

        if fileHandle != nil {
            let data = fileHandle?.readDataToEndOfFile()
            fileHandle?.closeFile()
            var parser = XMLParser(data: data!)
            parser.delegate = include
            parser.parse()
        }




    }

}