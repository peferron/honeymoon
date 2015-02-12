//
//  GKSceneDelegate
//  GameKit
//
//  Created by Mat on 12/3/14.
//  Copyright (c) 2014 Mat. All rights reserved.
//

import SpriteKit

public protocol GKSceneDelegate {
    func didFinishForScene(scene: GKScene, nextSceneClass: GKScene.Type)
}
