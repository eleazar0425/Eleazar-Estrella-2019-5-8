//
//  ScrollView+isNearBottomEdge.swift
//  Pelina Beer App
//
//  Created by Eleazar Estrella GB on 5/8/19.
//  Copyright © 2019 Eleazar Estrella. All rights reserved.
// SEE: https://github.com/jdisho/Papr/blob/develop/Papr/Utils/Extentions/Rx/UIScrollView+Rx.swift
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIScrollView {
    func reachedBottom(withOffset offset: CGFloat = 0.0) -> Observable<Bool> {
        let observable = contentOffset
            .map { [weak base] contentOffset -> Bool in
                guard let scrollView = base else { return false}
                let visibleHeight = scrollView.frame.height
                    - scrollView.contentInset.top
                    - scrollView.contentInset.bottom
                let y = contentOffset.y + scrollView.contentInset.top
                let threshold = max(offset, scrollView.contentSize.height - visibleHeight)
                
                return y > threshold
        }
        
        return observable.distinctUntilChanged()
    }
}
