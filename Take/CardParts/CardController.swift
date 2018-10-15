import CardParts
import Foundation
import RxCocoa
import RxSwift
import RxDataSources
import RxGesture

class CardController: CardPartsViewController {

    var viewModel: CardViewModel = CardViewModel()
    var titlePart: CardPartTitleView = CardPartTitleView(type: .titleOnly)
    var textPart: CardPartTextView = CardPartTextView(type: .normal)

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.title.asObservable().bind(to: titlePart.reactive.title).disposed(by: bag)
        viewModel.text.asObservable().bind(to: textPart.reactive.text).disposed(by: bag)

        setupCardParts([titlePart, textPart])
    }
}

class CardViewModel {

    var title: Variable = Variable("")
    var text: Variable = Variable("")

    init() {

        // When these values change, the UI in the TestCardController
        // will automatically update
        title.value = "Hello, world!"
        text.value = "CardParts is awesome!"
    }
}
