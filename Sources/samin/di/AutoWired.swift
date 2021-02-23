import Foundation
import FoundationXML
import Inject

extension AutoWired {
    init() {
        self.init(resolver: SaminDependencies.dependencies)
    }
}