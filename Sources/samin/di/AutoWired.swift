import Foundation
#if canImport(FoundationXML)
import FoundationXML
#endif
import Inject

extension AutoWired {
    init() {
        self.init(resolver: SaminDependencies.dependencies)
    }
}
