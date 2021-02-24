import Foundation
#if canImport(FoundationXML)
import FoundationXML
#endif
import Inject

enum SaminDependencies {
    static let dependencies: DependencyResolver = DefaultDependencyResolver()
    static let singletons: SingletonResolver = DefaultSingletonResolver()
}
