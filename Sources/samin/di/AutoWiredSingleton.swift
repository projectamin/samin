import Foundation
#if canImport(FoundationXML)
import FoundationXML
#endif
import Inject

extension AutoWiredSingleton {
    init() {
        self.init(resolver: SaminDependencies.singletons)
    }
}
