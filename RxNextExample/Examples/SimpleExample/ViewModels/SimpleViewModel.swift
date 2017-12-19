import RxSwift
import RxCocoa



class SimpleViewModel {
    let outputText: RxCocoa.Driver<String?>


    init(input inputText: RxCocoa.Driver<String?>) {
        self.outputText = inputText
            .map { text in text?.uppercased() }
            .asDriver()
    }
}