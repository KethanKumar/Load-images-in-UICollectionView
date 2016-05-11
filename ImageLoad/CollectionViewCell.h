//
//  CollectionViewCell.h
//  ImageLoad
//
//  Created by Software on 10/05/16.
//  Copyright © 2016 Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell
{
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property(weak, nonatomic) IBOutlet UIView *backSideView;
@property(readwrite) BOOL isRed;
@property (weak, nonatomic) IBOutlet UILabel *imageNameLbl;

@end
