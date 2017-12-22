//
//  AppDelegate.m
//  WaterFlowLayout
//
//  Created by warron on 2017/12/22.
//  Copyright © 2017年 warron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlowLayout : UICollectionViewFlowLayout

//传width，然后根据高宽比获得 高度 比如 H = h/w * width
@property(nonatomic,copy)CGFloat(^heightByRatioWidth)(UICollectionView *collectionView,FlowLayout*layout,CGFloat width,NSIndexPath*indexPath);

//传section过去，获取对应头视图高度
@property(nonatomic,copy)CGSize(^headerSizeInSection)(UICollectionView *collectionView,FlowLayout*layout,NSInteger section);

//传section过去，获取对应脚视图高度
@property(nonatomic,copy)CGSize(^footerSizeInSection)(UICollectionView *collectionView,FlowLayout*layout,NSInteger section);

//行间距
@property(nonatomic, assign)CGFloat rowSpacing;

 //列间距
@property(nonatomic, assign)CGFloat columnSpacing;

//列的总数
@property(nonatomic, assign)CGFloat colCount;

//整个显示cell的layout总高度
@property (nonatomic, strong) void (^layoutHeight)(float heaght);

@end
