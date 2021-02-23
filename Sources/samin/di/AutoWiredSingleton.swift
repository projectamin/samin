//
// Created by swishy on 2/23/21.
//

import Foundation
import FoundationXML
import Inject

extension AutoWiredSingleton {
    init() {
        self.init(resolver: SaminDependencies.singletons)
    }
}
