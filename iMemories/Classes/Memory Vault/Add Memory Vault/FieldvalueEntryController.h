//
//  FieldvalueEntryController.h
//  iMemoriesCore Data
//
//  Created by Lion Boney on 2/21/13.
//  Copyright (c) 2013 SurroundApps Inc. All rights reserved.
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
@interface FieldvalueEntryController : UIViewController<NLImageViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    TemplateType *_templateTypeModel;
    NLImageShowCase* _imageShowCase;
    NLImageViewer* _imageViewer;
    UIViewController * _imagViewController;
    UIActionSheet *_actionSheet;
    MAKTextField *_albmTitleTxtField;
    MAKTextView *_noteTxtView;
    NSMutableArray *_images;
}
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) Template *selectedTemplate;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollview;

@end
