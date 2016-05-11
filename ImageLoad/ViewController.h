//
//  ViewController.h
//  ImageLoad
//
//  Created by Software on 10/05/16.
//  Copyright © 2016 Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionViewCell.h"
@interface ViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    IBOutlet UICollectionView *collectionViewImage;
}

@end
