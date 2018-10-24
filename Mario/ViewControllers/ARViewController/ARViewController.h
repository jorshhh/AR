//
//  ViewController.h
//  Mario
//
//  Created by Jorge Rangel on 10/24/18.
//  Copyright © 2018 IDQR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>
#import "SVProgressHUD.h"

@interface ARViewController : UIViewController<ARSCNViewDelegate>

@property (nonatomic, strong) IBOutlet ARSCNView *sceneView;

@end
