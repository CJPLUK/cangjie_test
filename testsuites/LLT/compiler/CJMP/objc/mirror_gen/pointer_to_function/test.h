/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// @C functions
typedef void CFun(void);
typedef void (*PCFunc)(void);
typedef void (**PPCFunc)(void);

// @ObjC functions
typedef id OCFunc(void);
typedef id (*POCFunc)(void);
typedef id (**PPOCFunc)(void);

// Blocks
typedef void (^Block)(void);
typedef void (^const* PBlock)(void);

// @C global function
CFun cfunc;
void cfunc1(CFun cfunc1, CFun* cfunc2, PCFunc cfunc3, PPCFunc pcfunc);
void cfunc2(void cfunc_1(void), void (*cfunc_2)(void), void (**pcfunc_)(void));

// @ObjC global function
OCFunc ocfunc;
void ocfunc1(OCFunc ocfunc1, OCFunc* ocfunc2, POCFunc ocfunc3, PPOCFunc pocfunc);
void ocfunc2(CFun^ block1, Block block2, PBlock pblock);
void ocfunc3(id ocfunc_1(void));
void ocfunc4(id (*ocfunc_2)(void));
void ocfunc5(id (**pocfunc_)(void));
void ocfunc6(void (^block_)(void), void (^*pblock_)(void));

// @C structure
struct CStruct {
    CFun* func1;
    PCFunc func2;
    PPCFunc pfunc;

    void (*func_)(void);
    void (**pfunc_)(void);
};

// @ObjC structure
struct OCStruct {
    // @C functions
    CFun* cfunc1;
    PCFunc cfunc2;
    PPCFunc pcfunc;
    void (*cfunc_)(void);
    void (**pcfunc_)(void);

    // @ObjC functions
    OCFunc* ocfunc1;
    POCFunc ocfunc2;
    PPOCFunc pocfunc;
    id (*ocfunc_)(void);
    id (**pocfunc_)(void);

    // Blocks
    CFun^ block1;
    Block block2;
    PBlock pblock;
    id (^block_)(void);
    id (^const* pblock_)(void);
};

@interface M {
    // @C functions
    CFun* cfunc1;
    PCFunc cfunc2;
    PPCFunc pcfunc;
    void (*cfunc_)(void);
    void (**pcfunc_)(void);

    // @ObjC functions
    OCFunc* ocfunc1;
    POCFunc ocfunc2;
    PPOCFunc pocfunc;
    id (*ocfunc_)(void);
    id (**pocfunc_)(void);

    // Blocks
    CFun^ block1;
    Block block2;
    PBlock pblock;
    id (^block_)(void);
    id (^const* pblock_)(void);
}
@end
