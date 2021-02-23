import Foundation
import FoundationXML
import Inject

enum SaminDependencies {
    static let dependencies: DependencyResolver = DefaultDependencyResolver()
    static let singletons: SingletonResolver = DefaultSingletonResolver()
}
