//
// Created by swishy on 30/08/20.
//

import Foundation

public class Spec {

    // TODO have the created instances available on Spec.
    // TODO Machine/Handler/etc it should have failed or defaulted already.
    // TODO Amin used perl magic to allow variable over writing as the pipeline
    // TODO was setup but in typed land not the case.
    // TODO So we need to establish an interfaces and load as part of spec creation.

    // The name of the current machine.
    var name: String? = nil
    // The class to use as the XML generator.
    var generator: String? = nil
    //
    var handler: String? = nil
    var log: AminLog?
    // This maps filters to position keyed by name.
    var filters: [XmlSaxBase]?
    var writer: XmlSaxBase?
    var buffer: OutputStream? = nil

    // In perl land these two are updated to track the current element.
    // Not sure I'm happy about this but following suite atm to keep things easy.
    var prefix: String? = nil
    var localname: String? = nil

    // In perl this flag loads Amin::Machine::Handler::Empty and effectively does a no-op for the rest of the doc.
    var aminError: Bool = false

    init() {

    }

    deinit {
        print("Spec is being deinitialized")
    }
}