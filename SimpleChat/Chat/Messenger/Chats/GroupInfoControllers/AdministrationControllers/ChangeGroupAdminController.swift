//
//  ChangeGroupAdminController.swift
//  Subly
//
//  Created by Robert Brennan on 9/20/18.
//  Copyright © 2018 TechYes. All rights reserved.
//

import UIKit

class ChangeGroupAdminController: SelectNewAdminTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRightBarButton(with: "Change administrator")
    }
    
    override func rightBarButtonTapped() {
        super.rightBarButtonTapped()
        setNewAdmin(membersIDs: getMembersIDs())
    }
}
