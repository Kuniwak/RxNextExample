enum ExampleScreen {
    case sharedModel
    case dynamicHierarchalViewModel


    var title: String {
        switch self {
        case .sharedModel:
            return "Shared Model"
        case .dynamicHierarchalViewModel:
            return "Dynamic Hierarchal ViewModel"
        }
    }


    static var all: [ExampleScreen] = [
        .sharedModel,
        .dynamicHierarchalViewModel,
    ]
}
