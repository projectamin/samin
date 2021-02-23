//
// Created by swishy on 2/23/21.
//
import Foundation
import Inject
extension Inject {
    init() {
        self.init(resolver: SaminDependencies.dependencies)
    }
}