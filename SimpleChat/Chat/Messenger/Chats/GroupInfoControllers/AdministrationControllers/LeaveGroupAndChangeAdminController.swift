//
//  LeaveGroupAndChangeAdminController.swift
//  Subly
//
//  Created by Robert Brennan on 9/20/18.
//  Copyright © 2018 TechYes. All rights reserved.
//

import UIKit

class LeaveGroupAndChangeAdminController: SelectNewAdminTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRightBarButton(with: "Leave the group")
    }
    
    override func rightBarButtonTapped() {
        super.rightBarButtonTapped()
        leaveTheGroupAndSetAdmin()
    }
}
