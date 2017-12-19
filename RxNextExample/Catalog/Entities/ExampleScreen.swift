enum ExampleScreen {
    case simple
    case sharedModel
    case dynamicHierarchalViewModel


    var title: String {
        switch self {
        case .simple:
            return "Simple"
        case .sharedModel:
            return "Shared Model"
        case .dynamicHierarchalViewModel:
            return "Dynamic Hierarchal ViewModel"
        }
    }


    static var all: [ExampleScreen] = [
        .simple,
        .sharedModel,
        .dynamicHierarchalViewModel,
    ]
}
