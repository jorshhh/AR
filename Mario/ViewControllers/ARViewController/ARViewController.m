//
//  ViewController.m
//  Mario
//
//  Created by Jorge Rangel on 10/24/18.
//  Copyright © 2018 IDQR. All rights reserved.
//

#import "ARViewController.h"
    
@implementation ARViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    SCNScene *scene = [SCNScene new];
    self.sceneView.scene = scene;
    
    // Set the view's delegate
    self.sceneView.delegate = self;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Setting up reference images
    NSSet<ARReferenceImage *> *reference = [ARReferenceImage referenceImagesInGroupNamed:@"AR Resources"
                                                                         bundle:nil];
    
    // Create a session configuration
    ARWorldTrackingConfiguration *configuration = [ARWorldTrackingConfiguration new];
    configuration.detectionImages = reference;


    // Run the view's session
    [self.sceneView.session runWithConfiguration:configuration];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Pause the view's session
    [self.sceneView.session pause];
}



#pragma mark - ARSCNViewDelegate


// Override to create and configure nodes for anchors added to the view's session.
-(void) renderer:(id<SCNSceneRenderer>)renderer didAddNode:(nonnull SCNNode *)node forAnchor:(nonnull ARAnchor *)anchor {
    
    
    //SHADERS
    
    NSMutableDictionary *shaders = [NSMutableDictionary new];
    
    NSError *error;
    
    NSString *code = [[NSString alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"holo" withExtension:@"shader"] encoding:NSUTF8StringEncoding error:&error];
    
    NSLog(@"%@",error);
    
    shaders[SCNShaderModifierEntryPointSurface] = code;
    
    SCNMaterial *material = [SCNMaterial material];
    material.shaderModifiers = shaders;
    
    SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/scene.scn"];
    SCNNode *newNode = [scene rootNode];
    newNode.position = SCNVector3Make(anchor.transform.columns[3].x, anchor.transform.columns[3].y, anchor.transform.columns[3].z);
    newNode.scale = SCNVector3Make(0.25, 0.25, 0.25);

    [node addChildNode:newNode];
    
    [SVProgressHUD showSuccessWithStatus:@"ANCLA ENCONTRADA"];
    
}


- (void)session:(ARSession *)session didFailWithError:(NSError *)error {
    // Present an error message to the user
    NSLog(@"%@",error);
}

- (void)sessionWasInterrupted:(ARSession *)session {
    // Inform the user that the session has been interrupted, for example, by presenting an overlay
    
}

- (void)sessionInterruptionEnded:(ARSession *)session {
    // Reset tracking and/or remove existing anchors if consistent tracking is required
    
}

@end
