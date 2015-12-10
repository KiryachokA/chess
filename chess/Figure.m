//
//  Figure.m
//  iChess
//
//  Created by svetlana on 04.12.14.
//  Copyright (c) 2014 Aleksei. All rights reserved.
//

#import "Figure.h"
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@implementation Figure
@synthesize color = colorFigure;
@synthesize type = typeFigure;

- (NSString*) getNameForColor: ( ColorFigure) c Type:( TypeFigure) f {
 
    NSString *white[6] = {
        @"wking.png",
        @"wqueen.png",
        @"wrook.png",
        @"welephant.png",
        @"whorse.png",
        @"wpawn.png"
    };
    
    NSString *black[] = {
        @"bking.png",
        @"bqueen.png",
        @"brook.png",
        @"belephant.png",
        @"bhorse.png",
        @"bpawn.png"
    };
    
    return (c == White ? white[f] : black[f]);
}

- (void) getImageForColor: ( ColorFigure) c Type:( TypeFigure) f {
    
    NSString *filename = [self getNameForColor: c Type :f ];
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource: filename ofType: nil];
    
    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfFile:imagePath]];
    image = CGImageRetain(img.CGImage);
}

-(id) initWithType:( TypeFigure)type Color:( ColorFigure)color {
    self = [super init];
    if (self != nil) {
        colorFigure = color;
        typeFigure = type;
        [self getImageForColor:color Type:type];
    }

    return self;
}

-(void) draw:(int) frameSize {
    CGRect imageRect;
    imageRect.size = CGSizeMake(frameSize, frameSize);
    imageRect.origin = CGPointMake(frameSize*point.y, frameSize*point.x);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), imageRect, image);
}

-(BOOL) canBeMovedToX:(int) i Y:(int) j {
    return FALSE;
}

-(void) setPositionX:(int)i Y:(int)j {
    point.x=i;
    point.y=j;
}

-(CGPoint) getPosition {
    return point;
}

/*
+(void) initRect {
    rect = CGRectMake(0.5, 0.5, 33, 33);
}

+(CGRect) getRect {
    return rect;
}
*/

@end
