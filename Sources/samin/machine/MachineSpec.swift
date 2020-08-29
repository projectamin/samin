//
// Created by swishy on 29/08/20.
//

import FoundationXML

class MachineSpec: XmlSaxBase {

    override func parserDidStartDocument(_ parser: XMLParser) {
        print("machine spec start doc")
    }

}