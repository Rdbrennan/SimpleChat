//
//  SelectGroupMembersController.swift
//  Subly
//
//  Created by Robert Brennan on 9/20/18.
//  Copyright © 2018 TechYes. All rights reserved.
//

import UIKit


class SelectGroupMembersController: SelectParticipantsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRightBarButton(with: "Next")
        setupNavigationItemTitle(title: "New group")
    }
    
    override func rightBarButtonTapped() {
        super.rightBarButtonTapped()
        
        createGroup()
    }
}
