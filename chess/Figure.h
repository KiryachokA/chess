//
//  Figure.h
//  iChess
//
//  Created by svetlana on 04.12.14.
//  Copyright (c) 2014 Aleksei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#define CELL_SIZE 33

typedef enum _ColorFigure {
    Black,
    White
} ColorFigure;

typedef enum _TypeFigure {
    King ,      // король
    Queen,      // ферзь
    Rook ,      // ладья
    Elephant,   // слон
    Horse ,     // конь
    Pawn        // пешка
} TypeFigure;

@protocol IFigure <NSObject>

-(void) draw:(int) frameSize;
-(BOOL) canBeMovedToX:(int) i Y:(int) j;
-(void) setPositionX:(int) i Y:(int) j;
-(CGPoint) getPosition;


@property ColorFigure color;
@property TypeFigure type;
@end

@interface Figure : NSObject<IFigure> {
    CGImageRef image;
    CGRect rect;
    CGPoint point;
    ColorFigure colorFigure;
    TypeFigure typeFigure;
}

-(id) initWithType: ( TypeFigure)type Color:( ColorFigure)color;
-(void) draw:(int) frameSize;
-(BOOL) canBeMovedToX:(int) i Y:(int) j;
-(void) setPositionX:(int) i Y:(int) j;
-(CGPoint) getPosition;


//+(void) initRect;
//+(CGRect) getRect;

@property  ColorFigure color;
@property  TypeFigure type;

@end
