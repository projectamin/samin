import Foundation
#if canImport(FoundationXML)
import FoundationXML
#endif

/**
 In Perl this used to do the filter ordering as well but was just as easy in swift to manage in the loading.
 */
class AminMachineDispatcher: XmlSaxBase {

    private var filterDispatcher: AminMachineFilterDispatcher;
    public required init() {
        filterDispatcher = AminMachineFilterDispatcher()
    }

    init(machineSpec: Spec!) {
        filterDispatcher = AminMachineFilterDispatcher()
        super.init()
        spec = machineSpec
        // Filters end up with no spec associated as they are dynamically created so assign ref to spec.
        spec?.filters?.forEach { (filter) in
            filter.spec = spec
        }

        // Load up our special dispatcher = we can't do magic stuff like in perl so do things the hard way.
        filterDispatcher.spec = machineSpec
        delegate = filterDispatcher
    }
}
