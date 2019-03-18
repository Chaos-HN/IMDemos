//
//  UIImage+IMImg.m
//  IMDemos
//
//  Created by oumeng on 2019/3/5.
//  Copyright © 2019 OYKM. All rights reserved.
//

#import "UIImage+IMImg.h"

#define MAX_IMAGE_W 141.0
#define MAX_IMAGE_H 228.0
@implementation UIImage (IMImg)
/*
 判断图片长度&宽度
 
 */
-(CGSize)imageShowSize{
    
    CGFloat imageWith=self.size.width;
    CGFloat imageHeight=self.size.height;
    
    
    //宽度大于高度
    if (imageWith >= imageHeight) {
        // 宽度超过标准宽度
        /**/
        if (imageWith > MAX_IMAGE_W)
        {
            return CGSizeMake(MAX_IMAGE_W, imageHeight*MAX_IMAGE_W/imageWith);
        }
        else
        {
            return self.size;
        }
    }
    else
    {
        /**/
        if (imageHeight > MAX_IMAGE_H)
        {
            return CGSizeMake(imageWith*MAX_IMAGE_W/imageHeight, MAX_IMAGE_W);
        }
        else
        {
            return self.size;
        }
    }
    return CGSizeZero;
}

@end
