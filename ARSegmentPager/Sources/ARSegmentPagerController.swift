//
//  ARSegmentPagerController.swift
//  ARSegmentPager
//
//  Created by AugustRush on 5/9/16.
//  Copyright © 2016 August. All rights reserved.
//

import UIKit

class ARSegmentPagerController: UIViewController {
    @IBInspectable var headerHeight: CGFloat = 200
    @IBInspectable var segmentHeight: CGFloat = 44
    @IBInspectable var segmentMinTopInset: CGFloat = 64//just NavigationBar Height.should be greater than 0
    @IBInspectable var freezeenHeaderWhenReachMaxHeaderHeight: Bool = false//will not be streach when header's height is equal to the max value if it's true
    private(set) var segmentTopInset: CGFloat = 200//You can observer this value to make some changed for UI
    
    private(set) var controllers : [UIViewController] = Array()
    var selectedIndex: Int?
    
    //MARK: Life cycle methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    deinit {
    
    }
    
    //MARK: public methods
    
    func addPage<T: UIViewController where T: ARSegmentPagerProtocol>(page: T) {
        self.controllers.append(page)
    }
    
    func addPages<T: UIViewController where T: ARSegmentPagerProtocol>(pages: T...) {
        for page in pages {
            self.addPage(page)
        }
    }
    
    func currentDisplayController<T: UIViewController where T: ARSegmentPagerProtocol>() -> T? {
        if let index = self.selectedIndex {
            if index < self.controllers.count {
             return self.controllers[index] as? T   
            }
        }
        return nil
    }
    
    //MARK: private methods
    
    private func setUp() {
        
    }
}
