//
// Created by swishy on 30/08/20.
//

import Foundation

public class Spec {
    // The name of the current machine.
    var name: String? = nil
    // The class to use as the XML generator.
    var generator: String? = nil
    //
    var handler: String? = nil
    var log: String? = nil
    // This maps filters to position keyed by name.
    var filters = Dictionary<String, Dictionary<String, XmlSaxBase>>()

    init() {
        // TODO Make dynamic?
        filters["begin"] = Dictionary<String, XmlSaxBase>()
        filters["permanent"] = Dictionary<String, XmlSaxBase>()
        filters["middle"] = Dictionary<String, XmlSaxBase>()
        filters["end"] = Dictionary<String, XmlSaxBase>()
    }
}