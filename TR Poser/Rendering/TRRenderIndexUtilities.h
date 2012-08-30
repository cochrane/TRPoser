//
//  TRRenderIndexUtilities.h
//  TR Poser
//
//  Created by Torsten Kammer on 31.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#pragma once

#include <stdint.h>

void TRFillTriangle(uint16_t *array, unsigned long *elementsOffset, unsigned long *index, int isTwoSided);
void TRFillRectangle(uint16_t *array, unsigned long *elementsOffset, unsigned long *index, int isTwoSided);
