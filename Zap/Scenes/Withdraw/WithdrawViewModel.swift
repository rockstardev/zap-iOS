//
//  Zap
//
//  Created by Otto Suess on 06.02.18.
//  Copyright © 2018 Otto Suess. All rights reserved.
//

import Bond
import BTCUtil
import Foundation

final class WithdrawViewModel {
    private let viewModel: ViewModel
    
    let sendEnabled = Observable(false)
    var address = Observable<String?>(nil)
    var amount = Observable<Satoshi>(100)
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    func paste() {
        if let string = UIPasteboard.general.string {
            address.value = string
        }
    }
    
    func send() {
        guard let address = address.value else { return }
        _ = viewModel.sendCoins(address: address, amount: amount.value)
    }
    
    func selectAll() {
        amount.value = viewModel.balance.value
    }
}
