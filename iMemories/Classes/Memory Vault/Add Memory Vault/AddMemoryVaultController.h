//
//  AddMemoryVaultController.h
//  iMemories
//
//  Created by Lion Boney on 2/15/13.
//  Copyright (c) 2013 surroundapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateType.h"
#import "Template.h"
#import "Field.h"
#import "MAKTextField.h"
#import "MAKTextView.h"
#import "FieldValue.h"
#import "MAKControlView.h"
#import "NLImageShowCase.h"
#import "NLImageViewDataSource.h"
#import "NLImageViewer.h"
#import <QuartzCore/QuartzCore.h>
#import "Utility.h"
#import "MAKScrollView.h"
#import "PhotoManager.h"
#import "MBProgressHUD.h"
@interface AddMemoryVaultController : UIViewController<NLImageViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate,PhotoManagerDelegate,MBProgressHUDDelegate>
{

    TemplateType *_templateTypeModel;
    NLImageShowCase* _imageShowCase;
    NLImageViewer* _imageViewer;
    UIViewController * _imagViewController;
    UIActionSheet *_actionSheet;
    MAKTextField *_albmTitleTxtField;
    MAKTextView *_noteTxtView;
    NSMutableArray *_images;
    NSMutableArray *_textFields;
    
    BOOL _isViewUP;
    double _totalDisplacement;
    CGPoint _lastPoint;
    
    MBProgressHUD *HUD;
}
@property (nonatomic, retain)  IBOutlet UILabel *tlable;
@property (nonatomic, retain) Template *selectedTemplate;
@property (nonatomic, retain) FieldValue *selectedFieldValue;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet MAKScrollView *scrollview;
@property (retain) PhotoManager *photoManager;
- (IBAction)addBtnTapped:(id)sender;
- (IBAction)cancelBtnTapped:(id)sender;
@end
