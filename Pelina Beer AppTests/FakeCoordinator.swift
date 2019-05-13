//
//  FakeCoordinator.swift
//  Pelina Beer AppTests
//
//  Created by Eleazar Estrella GB on 5/13/19.
//  Copyright © 2019 Eleazar Estrella. All rights reserved.
//

import Foundation

@testable import Pelina_Beer_App

class FakeCoordinator: Coordinator {
    func transition(to target: TargetSource) {}
    func pop(animated: Bool) {}
    func presentSimpleDialog(alertViewModel: AlertViewModel) {}
}
