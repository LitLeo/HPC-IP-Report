// Thinning.cu
// 实现二值图像的细化算法。

#include"ErrorCode.h"
#include"Thinning.h"
#include<iostream>
#include<stdio.h>
using namespace std;

// 宏：DEF_BLOCK_X 和 DEF_BLOCK_Y
// 定义了默认的线程块尺寸。
#define DEF_BLOCK_X  32
#define DEF_BLOCK_Y   8


unsigned char lutthin1[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0};
unsigned char lutthin2[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0};
unsigned char lutthin3[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
unsigned char lutthin4[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0};




// static 变量：_defLookTableData[18]
// 删除规则是由五十个 3×3 的模版组成，命名为细化查询表由于模版中的坐标
// 已经固定，所以在函数外直接定义这五十个模版的坐标，方便直接赋值。
static int _defLookTableData[18] = 
        {   
            -1,-1,  0,-1,  1,-1,  
            -1, 0,  0, 0,  1, 0,
            -1, 1,  0, 1,  1, 1,
        };

// static 变量：_defLookTableAttachedData[50][9]
// 按河边所给的 Thinning 算法文档中的描述，删除模版中有对应的数据，
// 在此利用 Template 中的 AttachedData （坐标点附带的数据）来存储
// 所给数据，且由于模版中的数据已经在算法文档中给出，所以在函数外
// 直接定义五十个个模版中的数据，方便为默认模版的附带数据数组赋值。
// 另外，因为图像是二值图像所以用 1 表示 HEIGHT PIXEL ,用 0 表示 
// LOW PIXEL。
static float _defLookTableAttachedData[50][9] = {
        // 模版内有 9 个数据
        // [0]
        {
            0.000000, 1.000000, 1.000000, 
            0.000000, 1.000000, 0.000000,
            0.000000, 0.000000, 0.000000
        },
        // [1]
        {
            0.000000, 0.000000, 1.000000,
            0.000000, 1.000000, 1.000000, 
            0.000000, 0.000000, 0.000000
        },
        // [2]
        {
            0.000000, 0.000000, 0.000000,
            0.000000, 1.000000, 1.000000,
            0.000000, 0.000000, 1.000000
        },
        // [3]
        {
            0.000000, 0.000000, 0.000000, 
            0.000000, 1.000000, 0.000000, 
            0.000000, 1.000000, 1.000000
        },
        //[4]
        {
            0.000000, 0.000000, 0.000000,
            0.000000, 1.000000, 0.000000,
            1.000000, 1.000000, 0.000000
        },
        // [5]
        {
            0.000000, 0.000000, 0.000000,
            1.000000, 1.000000, 0.000000,
            1.000000, 0.000000, 0.000000
        },
        // [6]
        {
            1.000000, 0.000000, 0.000000,
            1.000000, 1.000000, 0.000000, 
            0.000000, 0.000000, 0.000000
        },
        // [7]
        {
            1.000000, 1.000000, 0.000000,
            0.000000, 1.000000, 0.000000,
            0.000000, 0.000000, 0.000000
        },
        // 模版内有四个数据
        // [8]
        {
            1.000000, 1.000000, 1.000000, 
            0.000000, 1.000000, 0.000000,
            0.000000, 0.000000, 0.000000
        },
        // [9]
        {
            0.000000, 1.000000, 1.000000, 
            0.000000, 1.000000, 1.000000, 
            0.000000, 0.000000, 0.000000
        },
        // [10]
        {
            0.000000, 0.000000, 1.000000,
            0.000000, 1.000000, 1.000000,
            0.000000, 0.000000, 1.000000
        },
        // [11]
        {
            0.000000, 0.000000, 0.000000,
            0.000000, 1.000000, 1.000000,
            0.000000, 1.000000, 1.000000
        },
        // [12]
        {
            0.000000, 0.000000, 0.000000,
            0.000000, 1.000000, 0.000000, 
            1.000000, 1.000000, 1.000000
        },
        // [13]
        {
            0.000000, 0.000000, 0.000000,
            1.000000, 1.000000, 0.000000,
            1.000000, 1.000000, 0.000000
        },
        // [14]
        {
            1.000000, 0.000000, 0.000000,
            1.000000, 1.000000, 0.000000,
            1.000000, 0.000000, 0.000000
        },
        // [15]
        {
            1.000000, 1.000000, 0.000000,
            1.000000, 1.000000, 0.000000,
            0.000000, 0.000000, 0.000000
        },
        // [16]
        {
            0.000000, 1.000000, 0.000000,
            1.000000, 1.000000, 0.000000, 
            1.000000, 0.000000, 0.000000
        },
        // [17]
        {
            0.000000, 1.000000, 0.000000,
            0.000000, 1.000000, 1.000000,
            0.000000, 0.000000, 1.000000
        },
        // [18]
        {
            1.000000, 1.000000, 0.000000,
            0.000000, 1.000000, 1.000000,
            0.000000, 0.000000, 0.000000
        },
        // [19]
        {
            0.000000, 1.000000, 1.000000,
            1.000000, 1.000000, 0.000000,
            0.000000, 0.000000, 0.000000
        },
        // 模版内有5个数据
        // [20]
        {
            1.000000, 1.000000, 1.000000,
            0.000000, 1.000000, 1.000000,
            0.000000, 0.000000, 0.000000
        },
        // [21]
        {
            0.000000, 1.000000, 1.000000,
            0.000000, 1.000000, 1.000000,
            0.000000, 0.000000, 1.000000
        },
        // [22]
        {
            0.000000, 0.000000, 1.000000,
            0.000000, 1.000000, 1.000000,
            0.000000, 1.000000, 1.000000
        },
        // [23]
        {
            0.000000, 0.000000, 0.000000,
            0.000000, 1.000000, 1.000000,
            1.000000, 1.000000, 1.000000
        },
        // [24]
        {
            0.000000, 0.000000, 0.000000,
            1.000000, 1.000000, 0.000000,
            1.000000, 1.000000, 1.000000
        },
        // [25]
        {
            1.000000, 0.000000, 0.000000,
            1.000000, 1.000000, 0.000000,
            1.000000, 1.000000, 0.000000
        },
        // [26]
        {
            1.000000, 1.000000, 0.000000, 
            1.000000, 1.000000, 0.000000,
            1.000000, 0.000000, 0.000000
        },
        // [27]
        {
            1.000000, 1.000000, 1.000000,
            1.000000, 1.000000, 0.000000,
            0.000000, 0.000000, 0.000000
        },
        // [28]
        {
            1.000000, 1.000000, 0.000000,
            0.000000 ,1.000000, 1.000000, 
            0.000000, 0.000000, 1.000000
        },
        // [29]
        {
            0.000000, 1.000000, 1.000000, 
            1.000000, 1.000000, 0.000000,
            1.000000, 0.000000, 0.000000
        },
        // 模板内有六个数据
        // [30]
        {
            1.000000, 1.000000, 1.000000,
            0.000000, 1.000000, 1.000000,
            0.000000, 0.000000, 1.000000
        },
        // [31]
        {
            0.000000, 1.000000, 1.000000, 
            0.000000, 1.000000, 1.000000,
            0.000000, 1.000000, 1.000000
        },
        // [32]
        {
            0.000000, 0.000000, 1.000000,
            0.000000, 1.000000, 1.000000,
            1.000000, 1.000000, 1.000000
        },
        // [33]
        {
            0.000000, 0.000000, 0.000000,
            1.000000, 1.000000, 1.000000,
            1.000000, 1.000000, 1.000000
        },
        // [34]
        {
            1.000000, 0.000000, 0.000000,
            1.000000, 1.000000, 0.000000,
            1.000000, 1.000000, 1.000000
        },
        // [35]
        {
            1.000000, 1.000000, 0.000000, 
            1.000000, 1.000000, 0.000000,
            1.000000, 1.000000, 0.000000
        },
        // [36]
        {
            1.000000, 1.000000, 1.000000,
            1.000000, 1.000000, 0.000000,
            1.000000, 0.000000, 0.000000
        },
        // [37]
        {
            1.000000, 1.000000, 1.000000,
            1.000000, 1.000000, 1.000000,
            0.000000, 0.000000, 0.000000
        },
        // 模版内有7个像素
        // [38]
         {
            1.000000, 1.000000, 1.000000,
            0.000000, 1.000000, 1.000000,
            0.000000, 0.000000, 1.000000
        },
        // [39]
        {
            0.000000, 1.000000, 1.000000, 
            0.000000, 1.000000, 1.000000,
            1.000000, 1.000000, 1.000000
        },
        // [40]
        {
            0.000000, 0.000000, 1.000000,
            1.000000, 1.000000, 1.000000,
            1.000000, 1.000000, 1.000000
        },
        // [41]
        {
            1.000000, 0.000000, 0.000000,
            1.000000, 1.000000, 1.000000,
            1.000000, 1.000000, 1.000000
        },
        // [42]
        {
            1.000000, 1.000000, 0.000000,
            1.000000, 1.000000, 0.000000,
            1.000000, 1.000000, 1.000000
        },
        // [43]
        {
            1.000000, 1.000000, 1.000000, 
            1.000000, 1.000000, 0.000000,
            1.000000, 1.000000, 0.000000
        },
        // [44]
        {
            1.000000, 1.000000, 1.000000,
            1.000000, 1.000000, 1.000000,
            1.000000, 0.000000, 0.000000
        },
        // [45]
        {
            1.000000, 1.000000, 1.000000,
            1.000000, 1.000000, 1.000000,
            0.000000, 0.000000, 1.000000
        },
        // 模版内有八个元素
        // [46]
        {
            1.000000, 1.000000, 1.000000,
            1.000000, 1.000000, 1.000000,
            1.000000, 0.000000, 1.000000
        },
        // [47]
        {
            1.000000, 1.000000, 1.000000,
            0.000000, 1.000000, 1.000000,
            1.000000, 1.000000, 1.000000
        },
        // [48]
        {
            1.000000, 0.000000, 1.000000,
            1.000000, 1.000000, 1.000000,
            1.000000, 1.000000, 1.000000
        },
        // [49]
        {
            1.000000, 1.000000, 1.000000,
            1.000000, 1.000000, 0.000000,
            1.000000, 1.000000, 1.000000
        }
};


// static 变量：_defTemplateData[7][32]
// 由于模版中的坐标已经固定，所以在函数外直接定义这七个模版坐标,
// 方便为默认模版坐标赋值。
static int _defTemplateData[7][32] = {
        // 3*4（1） 模版一
        // [0]
        {   -1,-1,  0,-1,  1,-1,  
            -1, 0,  0, 0,  1, 0,
            -1, 1,  0, 1,  1, 1,
            -1, 2,  0, 2,  1, 2
        },
        // 3*4（2） 模版二
        // [1]
        {   -1,-2,  0,-2,  1,-2,
            -1,-1,  0,-1,  1,-1,
            -1, 0,  0, 0,  1, 0,
            -1, 1,  0, 1,  1, 1
        },
        // 3*4（3） 模版三
        // [2]
        {   -1,-1,  0,-1,  1,-1,  
            -1, 0,  0, 0,  1, 0,
            -1, 1,  0, 1,  1, 1,
            -1, 2,  0, 2,  1, 2
        },
        // 4*3（1） 模版四
        // [3]
        {  -1,-1,  0,-1,  1,-1,  2,-1,
           -1, 0,  0, 0,  1, 0,  2, 0,
           -1, 1,  0, 1,  1, 1,  2, 1
        },
        // 4*3（2） 模版五
        // [4]
        {  -1,-1,  0,-1,  1,-1,  2,-1,
           -1, 0,  0, 0,  1, 0,  2, 0,
           -1, 1,  0, 1,  1, 1,  2, 1
        },
        // 4*3（3） 模版六
        // [5]
        {  -2,-1,  -1,-1,  0,-1,  1,-1,
           -2, 0,  -1, 0,  0, 0,  1, 0,
           -2, 1,  -1, 1,  0, 1,  1, 1
        },
        // 4*4（1） 模版七
        // [6]
        {  -1,-1,  0,-1,  1,-1,  2,-1,
           -1, 0,  0, 0,  1, 0,  2, 0,
           -1, 1,  0, 1,  1, 1,  2, 1,
           -1, 2,  0, 2,  1, 2,  2, 2
        }
};

// static 变量：_defTemplateAttachedData[7][50]
// 按河边所给的 Thinning 算法文档中的描述，删除模版中有对应的数据，
// 在此利用 Template 中的 AttachedData （坐标点附带的数据）来存储
// 所给数据，且由于模版中的数据已经在算法文档中给出，所以在函数外
// 直接定义七个模版中的数据，方便为默认模版的附带数据数组赋值。
// 另外，因为图像是二值图像并且所给数据中有无关数据（即忽略该点数
// 据对模版的影响）,所以用 1 表示HEIGHT PIXEL ,用 0 表示 LOW PIXEL，
// 用 -1 表示无关数据。
static float _defTemplateAttachedData[7][16] = {
        // 模版一数据
       {  -1.000000,  0.000000, -1.000000,
           1.000000,  1.000000,  1.000000,
           1.000000,  1.000000,  1.000000,
          -1.000000,  0.000000, -1.000000
       },
        // 模版二数据
       {  -1.000000,  0.000000,  0.000000,
           1.000000,  1.000000,  0.000000,
           0.000000,  1.000000,  0.000000,
           0.000000,  0.000000, -1.000000
       },
        // 模版三数据
       {  -1.000000,  0.000000,  0.000000,
           0.000000,  1.000000,  0.000000,
           0.000000,  1.000000,  1.000000,
           0.000000,  0.000000, -1.000000
       },
        // 模版四数据
       {  -1.000000,  0.000000,  0.000000,  0.000000,
           0.000000,  1.000000,  1.000000,  0.000000,
           0.000000,  0.000000,  1.000000, -1.000000
       },
        // 模版五数据
       {  -1.000000,  1.000000,  1.000000, -1.000000,
           0.000000,  1.000000,  1.000000,  0.000000,
          -1.000000,  1.000000,  1.000000, -1.000000
       },
        // 模版六数据
       {   0.000000,  0.000000,  0.000000, -1.000000,
           0.000000,  1.000000,  1.000000,  0.000000,
          -1.000000,  1.000000,  0.000000,  0.000000
       },
        // 模版七数据
       {   0.000000,  0.000000,  0.000000,  0.000000,
           0.000000,  1.000000,  1.000000,  0.000000,
           0.000000,  1.000000,  1.000000,  0.000000,
           0.000000,  0.000000,  0.000000,  0.000000
       }
};

// Kernel 函数：_thinningKer（实现Thining算法操作）
// 在调用此 kernel 函数时，已经将输入图像拷贝到输出图像
// 所以在参数里直接对输出图像进行操作
static __global__ void                // Kernel 函数无返回值
_thinningKer(
        ImageCuda outimg,             // 输出图像
        TemplateCuda **tableTplCuda,  // 细化查询表
        TemplateCuda **tplCuda,       // 删除模板数组
        int deleteTemplateLen ,       // 删除模版数组的长度
        int lookTableLen,             // 细化查询表的长度
        int *TabArray                 // 标记数组
);

// Kernel 函数：_deleteImageKer（实现删除算法操作）
// 调用此函数，根据标记数组 TabArray 的值判断该点是否应该被删除,
// 因为会迭代调用此核函数，isIteration 为结束的迭代的标记。
static __global__ void
_deleteImageKer(
        ImageCuda outimg,             // 输出图像
        int *TabArray,                // 标记数组
        bool *isIteration             // 结束迭代的标记

);


static __global__ void _thin_MATLABLike_FsubKer(
        ImageCuda outimg,
        ImageCuda tempimg,
        char *lutthin1_dev,
        char *lutthin2_dev,
        char *lutthin3_dev
        );


static __global__ void _thin_MATLABLike_SsubKer(
        ImageCuda tempimg,
        ImageCuda outimg,
        char *lutthin1_dev,
        char *lutthin2_dev,
        char *lutthin4_dev,
        int *dev_changedCount
        );

// 构造函数：Thinning
__host__ Thinning::Thinning()
{
    setLookTableLen(50);              // 初始化删除模版数组
                                      // 的长度为默认的 50。
    setDeleteTemplateLen(7);          // 初始化细化查询表的长度为 7。
}

// 成员方法：getLookTableLen
__host__ int Thinning::getLookTableLen() const
{
    // 如果 lookTableLen 不为负值，则返回lookTableLen.
    // if (lookTableLen >= 0)
        return lookTableLen;
}


// 成员方法：setLookTableLen
__host__ void Thinning::setLookTableLen(int _lookTableLen)
{
    // if (_lookTableLen >= 0)
        lookTableLen = _lookTableLen;
}

 // 成员方法：getDeleteTemplateLen
 __host__ int Thinning::getDeleteTemplateLen() const
 {
    // 如果 deleteTemplateLen 不为负值，则返回deleteTemplateLen。
    // if (deleteTemplateLen >= 0)
        return deleteTemplateLen;
 }

// 成员方法：setDeleteTemplateLen
 __host__ void Thinning::setDeleteTemplateLen(int _deleteTemplateLen)
 {
    // if (_deleteTemplateLen >= 0)
        deleteTemplateLen = _deleteTemplateLen;
 }

// Kernel 函数：_thinningKer（实现细化算法操作）
static __global__ void _thinningKer(ImageCuda outimg, 
                                TemplateCuda **tableTplCuda, 
                                TemplateCuda **tplCuda, 
                                int deleteTemplateLen,
                                int lookTableLen,
                                int *TabArray)
{
    // dstc 和 dstr 分别表示线程处理的像素点的坐标的 x 和 y 分量 （其中，
    // c 表示 column， r 表示 row ）。
    int dstc = blockIdx.x * blockDim.x + threadIdx.x;
    int dstr = blockIdx.y * blockDim.y + threadIdx.y;

    // 检查第一个像素点是否越界，如果越界，则不进行处理，一方面节省计算
    // 资源，另一方面防止由于段错误导致程序崩溃。
    if (dstc >= outimg.imgMeta.width || dstr >= outimg.imgMeta.height)
        return;

    // 用来保存临时像素点的坐标的 x 和 y 分量。
    int dx, dy;     
    
    // 定义输出图像位置的指针。
    unsigned char *outptr;
    
    // 存放模版像素点所在位置的指针。
    unsigned char *pixel;
    
	// 定义标记变量，其值为 1 或 0 ，当目标像素点不符合某一模版时，其值
	// 置为 1，且跳出当前模版循环，继续遍历下一模版。直至目标点符合某一
    // 模版或遍历模版结束。
    int sign ;
    
    // 获取当前当前像素点在图像中的相对位置。
    int curpos = dstr * outimg.pitchBytes + dstc;

    // 获取对应的第一个输出图像的位置。
    outptr = outimg.imgMeta.imgData + curpos;

    // 初始化该像素点对应标记数组的值为 0 ，即不删除。
    TabArray[curpos] = 0;

    // 因为无论是细化查询表还是删除模版数组，目标点的值都为 1 ，
    // 所以像素为 0 的像素点不执行细化查询表和删除模版数组的遍历。
    if (*outptr > 0)
    {  
        // 扫描细化查询表内的所有模板。
        for (int i=0; i<lookTableLen; i++)
        {
            // 每一个模版循环开始时，定义 sign 的值为 0，若该点不符合该模版，则使 sign = 1，
            // 并跳出当前模版循环，跳出后对 sign 的值进行判断，如果 sign 的值为 0， 则代表
            // 该点符合该模版，使其对应的标记数组的值为 1。
            sign = 0;

            // 扫描细化查询表范围内的每个输入图像的像素点。
            for (int j = 0; j < tableTplCuda[i]->tplMeta.count; j++)
            {
                // 计算当前模板位置所在像素的 x 和 y 分量，模板使用相邻的两个下标的
                // 数组表示一个点，所以使当前模板位置的指针作加一操作 。
                dx = dstc + (tableTplCuda[i]->tplMeta.tplData[j*2]);
                dy = dstr + (tableTplCuda[i]->tplMeta.tplData[j*2+1]);
    
                // 先判断当前像素的 x 分量和 y 分量是否越界，如果越界，则跳过，扫描
                // 下一个模板点。
                if (dx >= 0 && dx < outimg.imgMeta.width && 
                    dy >= 0 && dy < outimg.imgMeta.height) 
                {
                    // 根据 dx 和 dy 获取第一个像素的位置。
                    pixel = outimg.imgMeta.imgData + dx + dy * outimg.imgMeta.width;
                        
                    // 将目标点模版范围的像素点的值转化成二值并与模版附属数据值进行
                    // 匹配。
                    if ( (*pixel > 0) != tableTplCuda[i]->attachedData[j] )
                    {
                        // 如果某一点不符合，则该模版不匹配该像素点， 将 sign 置为 1 
                        //并跳出该模版的循环，进入下一循环。
                         sign = 1; 
                         break;
                    }
                }  
            }

            // 遍历完一个模版后，如果 sign 值为 0，则代表目标点与该模版相匹配，将该点
            // 对应的标记数组的值置为 1，并跳出模版循环。
            if(sign == 0)
            {
              TabArray[curpos] = 1;
              break;
            }
        }

        // 当模版遍历结束时，如果 TabArray[curpos] 的值为 1，代表目标点与细化查询表
        // 内的所有模版都不匹配，则进行删除模版的循环，如果当前像素满足任何一个模版，
        // 则不删除此像素（即使其满足步骤 2 中的删除条件）。
        if (TabArray[curpos] == 1)
        {
            for (int i=0; i<deleteTemplateLen; i++)
            {
                // 重复使用 sign ，功能与前者相同。
                sign = 0;

                // 扫描模板范围内的每个输入图像的像素点。
                for (int j = 0; j < tplCuda[i]->tplMeta.count; j++)
                {
                    // 计算当前模板位置所在像素的 x 和 y 分量，模板使用相邻的两个下标的
                    // 数组表示一个点，所以使当前模板位置的指针作加一操作 。
                    dx = dstc + (tplCuda[i]->tplMeta.tplData[j*2]);
                    dy = dstr + (tplCuda[i]->tplMeta.tplData[j*2+1]);
            
                    // 先判断当前像素的 x 分量和 y 分量是否越界，如果越界，则跳过，扫描
                    // 下一个模板点。
                    if (dx >= 0 && dx < outimg.imgMeta.width && 
                    dy >= 0 && dy < outimg.imgMeta.height) 
                    {
                        // 根据 dx 和 dy 获取第一个像素的位置。
                        pixel = outimg.imgMeta.imgData + dx + dy * outimg.imgMeta.width;
                
                        // 将目标点模版范围的像素点的值转化成二值并与模版附属数据值
                        // 进行匹配。
                        if ( tplCuda[i]->attachedData[j]>-1 && 
                        (*pixel > 0) != tplCuda[i]->attachedData[j] )
                        {
                            // 如果某一点不符合，则该模版不匹配该像素点，将 sign 置为 1 
                            // 并跳出该模版的循环，进入下一循环。
                            sign = 1;
                            break;
                        }
                    }  
                }
                // 遍历完一个模版后，如果 sign 值为 0，则代表目标点与该模版相匹配，
                // 将 TabArray[curpos] 置为0，并跳出模版循环。
                if(sign == 0)
                {
                    TabArray[curpos] = 0;
                    break;
                }
            }
        } 
    } 
 }  

// Kernel 函数：_deleteImageKer（实现删除图像算法操作）
static __global__ void _deleteImageKer(ImageCuda outimg, int *TabArray, bool *isIteration)
 {
    // dstc 和 dstr 分别表示线程处理的像素点的坐标的 x 和 y 分量 （其中，
    // c 表示 column， r 表示 row）。
    int dstc = blockIdx.x * blockDim.x + threadIdx.x;
    int dstr = blockIdx.y * blockDim.y + threadIdx.y;

    // 检查第一个像素点是否越界，如果越界，则不进行处理，一方面节省计算
    // 资源，另一方面防止由于段错误导致程序崩溃。
    if (dstc >= outimg.imgMeta.width || dstr >= outimg.imgMeta.height)
        return;

    // 定义输出图像位置的指针。
    unsigned char *outptr;

    // 获取当前像素点在图像中的相对位置。
    int curpos = dstr * outimg.pitchBytes + dstc;

    // 获取当前像素点在图像中的绝对位置。
    outptr = outimg.imgMeta.imgData + curpos ;

    // 如果该点对应的标记数组的值为 1，则删除干像素点并将 TabArray[curpos]
    // 值重新置为 0。
    if (TabArray[curpos] == 1)
    {

        *outptr = 0;
        // 标记迭代的变量，已初始化置为 false，若图像中有至少一个一个像素点
        // 被删除，则置 isIteration 为 true ，表示继续迭代。
        *isIteration = true;
        TabArray[curpos] = 0;
    }
 }


static __global__ void _thin_MATLABLike_FsubKer(
        ImageCuda outimg,
        ImageCuda tempimg,
        char *lutthin1_dev,
        char *lutthin2_dev,
        char *lutthin3_dev
        )
{

// printf("1 ");
    // dstc 和 dstr 分别表示线程处理的像素点的坐标的 x 和 y 分量 （其中，
    // c 表示 column， r 表示 row）。
    int dstc = blockIdx.x * blockDim.x + threadIdx.x;
    int dstr = blockIdx.y * blockDim.y + threadIdx.y;

    // 检查第一个像素点是否越界，如果越界，则不进行处理，一方面节省计算
    // 资源，另一方面防止由于段错误导致程序崩溃。
    if (dstc >= outimg.imgMeta.width-1 || dstr >= outimg.imgMeta.height-1 ||
        dstc < 1 || dstr < 1)
        return;
        // printf("2 ");
        

    // 定义输出图像位置的指针。
    unsigned char *outptr;

    // 获取当前像素点在图像中的相对位置。
    // int curpos = dstr * outimg.imgMeta.width + dstc;
    int curpos = dstr *  outimg.pitchBytes + dstc;

    // 获取当前像素点在图像中的绝对位置。
    outptr = outimg.imgMeta.imgData + curpos ;
//printf("1 ");
if(*outptr > 0)
{
    int index = 0;
//printf("%d ", *outptr);
    if(outimg.imgMeta.imgData[dstc-1 + (dstr-1) * outimg.pitchBytes] > 0) index += 1;
    if(outimg.imgMeta.imgData[dstc-1 + (dstr  ) * outimg.pitchBytes] > 0) index += 2;
    if(outimg.imgMeta.imgData[dstc-1 + (dstr+1) * outimg.pitchBytes] > 0) index += 4;
// printf("1 ");
    if(outimg.imgMeta.imgData[dstc + (dstr-1) * outimg.pitchBytes] > 0) index += 8;
    if(outimg.imgMeta.imgData[dstc + (dstr) * outimg.pitchBytes] > 0) index += 16;
    if(outimg.imgMeta.imgData[dstc + (dstr+1) * outimg.pitchBytes] > 0) index += 32;

    if(outimg.imgMeta.imgData[dstc+1 + (dstr-1) * outimg.pitchBytes] > 0) index += 64;
    if(outimg.imgMeta.imgData[dstc+1 + (dstr) * outimg.pitchBytes] > 0) index += 128;
    if(outimg.imgMeta.imgData[dstc+1 + (dstr+1) * outimg.pitchBytes] > 0) index += 256;

    unsigned char replacedPix1 = lutthin1_dev[index];
    unsigned char replacedPix2 = lutthin2_dev[index];
    unsigned char replacedPix3 = lutthin3_dev[index];
    //printf("2 ");
    tempimg.imgMeta.imgData[curpos] = *outptr && !(replacedPix1 && replacedPix2 && replacedPix3);
    }
    else
    {
    tempimg.imgMeta.imgData[curpos] = 0;
    }
}

static __global__ void _thin_MATLABLike_SsubKer(
        ImageCuda tempimg,
        ImageCuda outimg,
        char *lutthin1_dev,
        char *lutthin2_dev,
        char *lutthin4_dev,
        int *dev_changedCount
        )
{
// printf("%d ", *dev_changedCount);
    // *dev_changedCount = 0;
    // dstc 和 dstr 分别表示线程处理的像素点的坐标的 x 和 y 分量 （其中，
    // c 表示 column， r 表示 row）。
    int dstc = blockIdx.x * blockDim.x + threadIdx.x;
    int dstr = blockIdx.y * blockDim.y + threadIdx.y;

    // 检查第一个像素点是否越界，如果越界，则不进行处理，一方面节省计算
    // 资源，另一方面防止由于段错误导致程序崩溃。
    if (dstc >= tempimg.imgMeta.width-1 || dstr >= tempimg.imgMeta.height-1 ||
        dstc < 1 || dstr < 1)
        return;

    // 定义输出图像位置的指针。
    unsigned char *outptr;

    // 获取当前像素点在图像中的相对位置。
    // int curpos = dstr * outimg.imgMeta.width + dstc;
    int curpos = dstr * outimg.pitchBytes + dstc;
    
    // 获取当前像素点在图像中的绝对位置。
    outptr = tempimg.imgMeta.imgData + curpos ;

    int index = 0;

    if(tempimg.imgMeta.imgData[dstc-1 + (dstr-1) * tempimg.pitchBytes] > 0) index += 1;
    if(tempimg.imgMeta.imgData[dstc-1 + (dstr  ) * tempimg.pitchBytes] > 0) index += 2;
    if(tempimg.imgMeta.imgData[dstc-1 + (dstr+1) * tempimg.pitchBytes] > 0) index += 4;

    if(tempimg.imgMeta.imgData[dstc + (dstr-1) * tempimg.pitchBytes] > 0) index += 8;
    if(tempimg.imgMeta.imgData[dstc + (dstr  ) * tempimg.pitchBytes] > 0) index += 16;
    if(tempimg.imgMeta.imgData[dstc + (dstr+1) * tempimg.pitchBytes] > 0) index += 32;

    if(tempimg.imgMeta.imgData[dstc+1 + (dstr-1) * tempimg.pitchBytes] > 0) index += 64;
    if(tempimg.imgMeta.imgData[dstc+1 + (dstr  ) * tempimg.pitchBytes] > 0) index += 128;
    if(tempimg.imgMeta.imgData[dstc+1 + (dstr+1) * tempimg.pitchBytes] > 0) index += 256;

    unsigned char replacedPix1 = lutthin1_dev[index];
    unsigned char replacedPix2 = lutthin2_dev[index];
    unsigned char replacedPix4 = lutthin4_dev[index];

    unsigned char niv = *outptr && !(replacedPix1 && replacedPix2 && replacedPix4);

    if (niv != (outimg.imgMeta.imgData[curpos]>0))
    {
        if (niv)
            outimg.imgMeta.imgData[curpos] = 255;
        else
            outimg.imgMeta.imgData[curpos] = niv;
        // (*dev_changedCount) ++;
        //  printf("%d ", *dev_changedCount);
        atomicAdd(dev_changedCount,1);
    }
  
}



 
 
// 成员方法：thinEdge
__host__ int Thinning::thinEdge(Image *inimg, Image *outimg)
{
    int errcode;  // 局部变量，错误码。
    dim3 gridsize;
    dim3 blocksize;
    
    // 由于将细化查询表和删除模版的数据拷进 device 比较复杂,
    // 在这里对细化查询表和模版数组各定义三个二维模版指针变量来执行此操作。
    TemplateCuda *tplCudaHost[7] = {NULL}; 
    TemplateCuda **tplCuda;
    TemplateCuda *tplCudaTemp[7];

    TemplateCuda *lookTableCudaHost[50] = {NULL};
    TemplateCuda **lookTableCuda;
    TemplateCuda *lookTableCudaTemp[50];

    int *TabArray;                    // 标记数组
    bool *isIteration = new bool();   // 位于 host 端的标记迭代的变量。
    bool *dev_isIteration;            // 位于 device 端的标记迭代的变量。

    // 检查输入图像，输出图像，以及模板是否为空。
    if (inimg == NULL || outimg == NULL || deleteTemplate == NULL)
        return NULL_POINTER;

    // 将输入输出图像拷贝到 Device 内存中。
    errcode = ImageBasicOp::copyToCurrentDevice(inimg, outimg);
    if (errcode != NO_ERROR)
        return errcode;          
        
     // 为细化查询表内的模版开空间并为其赋值。
    for (int i = 0; i < lookTableLen; ++i)
    {
        TemplateBasicOp::newTemplate(&lookTable[i]);
        TemplateBasicOp::makeAtHost(lookTable[i], 9);
        lookTableCudaHost[i] = TEMPLATE_CUDA(lookTable[i]);
        for (int j = 0; j < lookTable[0]->count; ++j)
        {
            // 为模版的坐标数据赋值。
            lookTable[i]->tplData[2*j] = _defLookTableData[2*j];
            lookTable[i]->tplData[2*j +1] = _defLookTableData[2*j + 1];
            
            // 为模版的附属数据赋值。
            lookTableCudaHost[i]->attachedData[j] = _defLookTableAttachedData[i][j];
        }
    }

    // 为删除模版数组内的模版赋值。因为前六个模版的大小相同，
    // 所以用一个 for 循环为其开空间。
    for (int i=0; i<deleteTemplateLen; i++)
    {
        TemplateBasicOp::newTemplate(&(deleteTemplate[i]));
        TemplateBasicOp::makeAtHost(deleteTemplate[i], 12);
    }
    
    // 第七个模版的大小为 16，再次单独为其开空间。
    TemplateBasicOp::newTemplate(&deleteTemplate[6]);
    TemplateBasicOp::makeAtHost(deleteTemplate[6], 16);
    
    // 通过调用前面定义的 _defTemplateData 数组和 _defTemplateAttachedData 
    // 数组为七个删除模版的坐标数据和附属数据赋值。
    for(int i=0; i<deleteTemplateLen; i++)
    {
        tplCudaHost[i] = TEMPLATE_CUDA(deleteTemplate[i]);
        for(int j=0; j<deleteTemplate[i]->count; j++)   
        {
            // 为模版的坐标数据赋值。
            deleteTemplate[i]->tplData[j] = _defTemplateData[i][j*2];
            deleteTemplate[i]->tplData[j] = _defTemplateData[i][j*2+1];

            // 为模版的附属数据赋值。
            tplCudaHost[i]->attachedData[j] = _defTemplateAttachedData[i][j];   
        }    
    }

    // 将细化查询表内模版的坐标数据和附属数据拷贝到 device 端。
    for (int i = 0; i < lookTableLen; ++i)
    {
        errcode = TemplateBasicOp::copyToCurrentDevice(lookTable[i]);
        if (errcode != NO_ERROR)
            return errcode;
    }

    // 将模版数组的坐标数据和附属数据拷贝到 device 端。
    for(int i=0; i<deleteTemplateLen; i++)
    { 
        errcode = TemplateBasicOp::copyToCurrentDevice(deleteTemplate[i]);
        if (errcode != NO_ERROR)
            return errcode; 
    }

    // 因为 copyToCurrentDevice 函数只能将模版的坐标数据和附属数据拷贝到 device 端，
    // 而其他如 count 等数据还在 host 端，则需要一个中间变量将其他数据也拷到 device 端
    // 通过 lookTableCudaTemp 将细化查询表的其他数据拷到 device 端。
    for (int i = 0; i < lookTableLen; ++i)
    {
        cudaMalloc((void **)&lookTableCudaTemp[i],
                    sizeof(TemplateCuda) );
        cudaMemcpy( lookTableCudaTemp[i] , 
                    lookTableCudaHost[i],
                    sizeof(TemplateCuda),
                    cudaMemcpyHostToDevice );
    }

    cudaMalloc((void **)&tplCudaTemp, 
                sizeof(TemplateCuda) * deleteTemplateLen);
    // 通过 tplCudaTemp 将细化查询表的其他数据拷到 device 端。
    for(int i=0; i<deleteTemplateLen; i++)
    {
		
		cudaMemcpy(tplCudaTemp[i], tplCudaHost[i], 
                            sizeof(TemplateCuda), 
                            cudaMemcpyHostToDevice);
    }

    // 将模版的坐标数据、附属数据和其他数据拷进 device 端后，指向每个模版的指针数据还在 host 端，
    // 通过 lookTableCuda 将细化查询表里指向模版的指针数据拷进 device 端。
    cudaMalloc((void **)&lookTableCuda,
                sizeof(TemplateCuda *) * lookTableLen );
    cudaMemcpy (lookTableCuda, lookTableCudaTemp,
                sizeof(TemplateCuda *) * lookTableLen,
                cudaMemcpyHostToDevice );
    
    // 通过 tplCuda 将删除模版数组里指向模版的指针数据拷进 device 端。
    cudaMalloc((void **)&tplCuda, 
                sizeof(TemplateCuda *) * deleteTemplateLen);
    cudaMemcpy( tplCuda, tplCudaTemp, 
                sizeof(TemplateCuda *) * deleteTemplateLen, 
                cudaMemcpyHostToDevice);

    // 为标记数组开空间，大小与图像大小相同。
    cudaMalloc((void **)&TabArray,
                inimg->width * inimg->height);
    
    // 为标记迭代的标记变量开空间。
    cudaMalloc((void **)&dev_isIteration,
                sizeof(bool));

    // 提取输出图像
    ImageCuda outsubimgCud;
    errcode = ImageBasicOp::roiSubImage(outimg, &outsubimgCud);
    if (errcode != NO_ERROR)
        return errcode;

    // blocksize 使用默认的尺寸
    blocksize.x = DEF_BLOCK_X;
    blocksize.y = DEF_BLOCK_Y;

    // 使用最普通的方法划分 Grid 。
    gridsize.x = (outsubimgCud.imgMeta.width + blocksize.x - 1) / blocksize.x;
    gridsize.y = (outsubimgCud.imgMeta.height + blocksize.y - 1) / blocksize.y;
    
    // 为 isIteration 赋值为 true。
    *isIteration = true;

    // 开始迭代
    while(*isIteration)
    {
        // 赋值 isIteration 为 false。
        *isIteration = false;

        // 每次迭代都将 dev_isIteration 赋值为 false。
         cudaMemcpy(dev_isIteration, isIteration,
                sizeof(bool),
                cudaMemcpyHostToDevice);
                
                
        // 调用 Kernel 函数进行细化操作。
        _thinningKer<<<gridsize, blocksize>>>(outsubimgCud, 
                                      lookTableCuda,
                                      tplCuda, 
                                      deleteTemplateLen,
                                      lookTableLen,
                                      TabArray
                                      );
        if (cudaGetLastError() != cudaSuccess)
            return CUDA_ERROR;

        // 调用 Kernel 函数进行删除图像操作。
        _deleteImageKer<<<gridsize, blocksize>>>(outsubimgCud, TabArray, dev_isIteration);
        if (cudaGetLastError() != cudaSuccess)
            return CUDA_ERROR;
        
        // 将 dev_isIteration 的值拷到 host 端并赋值给 isIteration ，从而判断是否继续迭代。
        cudaMemcpy(isIteration, dev_isIteration,
                sizeof(bool),
                cudaMemcpyDeviceToHost);
    }

    // 迭代结束，释放前面申请的空间防止内存能泄露。
    cudaFree(tplCuda);
    for (int i = 0; i < deleteTemplateLen; ++i)
        cudaFree(tplCudaTemp[i]);

    cudaFree(lookTableCuda);
    for (int i = 0; i < lookTableLen; ++i)
        cudaFree(lookTableCudaTemp[i]);
        
    cudaFree(TabArray);
    cudaFree(dev_isIteration);

    // 将输出图像拷贝到 Host 上。
    errcode = ImageBasicOp::copyToHost(outimg);
    return errcode;
}

__host__ int Thinning::thin_MATLABLike(
            Image *inimg,    // 输入图像
            Image *outimg    // 输出图像
    )
{
    int errcode;  // 局部变量，错误码。
    dim3 gridsize;
    dim3 blocksize;
    int *changedCount = new int();
    int *dev_changedCount;
    
    
    
    // cout << *changedCount << endl;
    
    cudaMalloc((void **)&dev_changedCount, sizeof(int));
    
    
    char *lutthin1_dev;
    char *lutthin2_dev;
    char *lutthin3_dev;
    char *lutthin4_dev;
//cout << "1" << endl;
    cudaMalloc((void **)&lutthin1_dev, 512);
    cudaMalloc((void **)&lutthin2_dev, 512);
    cudaMalloc((void **)&lutthin3_dev, 512);
    cudaMalloc((void **)&lutthin4_dev, 512);

    cudaMemcpy (lutthin1_dev, lutthin1,
                512,
                cudaMemcpyHostToDevice );
    cudaMemcpy (lutthin2_dev, lutthin2,
                512,
                cudaMemcpyHostToDevice );
    cudaMemcpy (lutthin3_dev, lutthin3,
                512,
                cudaMemcpyHostToDevice );
    cudaMemcpy (lutthin4_dev, lutthin4,
                512,
                cudaMemcpyHostToDevice );

//cout << "2" << endl;
    Image *tempimg;
    ImageBasicOp::newImage(&tempimg);
    ImageBasicOp::makeAtCurrentDevice(tempimg, inimg->width, inimg->height);

    ImageBasicOp::copyToCurrentDevice(inimg,outimg);

    // 提取输出图像
    ImageCuda outsubimgCud;
    errcode = ImageBasicOp::roiSubImage(outimg, &outsubimgCud);
    if (errcode != NO_ERROR)
        return errcode;

    // 提取输出图像
    ImageCuda tempsubimgCud;
    errcode = ImageBasicOp::roiSubImage(tempimg, &tempsubimgCud);
    if (errcode != NO_ERROR)
        return errcode;

    // blocksize 使用默认的尺寸
    blocksize.x = DEF_BLOCK_X;
    blocksize.y = DEF_BLOCK_Y;

    // 使用最普通的方法划分 Grid 。
    gridsize.x = (outsubimgCud.imgMeta.width + blocksize.x - 1) / blocksize.x;
    gridsize.y = (outsubimgCud.imgMeta.height + blocksize.y - 1) / blocksize.y;

    *changedCount = 1;
//cout << "3" << endl;
    while(*changedCount)
     //for(int i=0; i<5; i++)
    {
    *changedCount = 0;
    cudaMemcpy (dev_changedCount, changedCount,
                sizeof(int),
                cudaMemcpyHostToDevice );
        
//cout << "4" << endl;
        _thin_MATLABLike_FsubKer<<<gridsize, blocksize>>>(
        outsubimgCud,
        tempsubimgCud,
        lutthin1_dev,
        lutthin2_dev,
        lutthin3_dev
        );
// cout << "5" << endl;
         _thin_MATLABLike_SsubKer<<<gridsize, blocksize>>>(
        tempsubimgCud,
        outsubimgCud,
        lutthin1_dev,
        lutthin2_dev,
        lutthin4_dev,
        dev_changedCount
        );
        // cout << "6" << endl;
    
    cudaMemcpy ( changedCount,dev_changedCount,
                sizeof(int),
                cudaMemcpyDeviceToHost );
                // cout << *changedCount << "j"<<endl;
    
   }

    



    cudaFree(lutthin1_dev);
    cudaFree(lutthin2_dev);
    cudaFree(lutthin3_dev);
    cudaFree(lutthin4_dev);

    ImageBasicOp::deleteImage(tempimg);
	return 0;
  
}

           __host__ int 
    Thinning::_ser_thin_MATLABLike(
            // Image *inimg,    // 输入图像
            Image *inimg    // 输出图像
    ){
    char * workImg = new char[40000];

    unsigned int changedCount = 0;
    
    

    for(int s = 1; s < 199; s++) {// 境界上のpix に3-by-3 近隣がないに注意！  従って、その3-by-3 近隣パターンに対応する２進値もない。
                                       //注意附近没有 像素边界上的pix 3 - by - 3!因此,3 - by - 3附近方式应对2进值也达到了。
            for(int e = 1; e < 199; e++) {// imageの(1,1)に対応するindexは存在しない！  不要图像（1,1）对应的目录
                int S = s;// + s0;
                int E = e;// + e0;
                int index = 0;
                if(inimg->imgData[(S-1)*200 + E-1] > 0) index += 1;
                if(inimg->imgData[(S  )*200 + E-1] > 0)   index += 2;
                if(inimg->imgData[(S+1)*200 + E-1] > 0) index += 4;
                
                if(inimg->imgData[(S-1)*200 + E] > 0)   index += 8;
                if(inimg->imgData[(S  )*200 + E] > 0)     index += 16;
                if(inimg->imgData[(S+1)*200 + E] > 0)   index += 32;
                
                if(inimg->imgData[(S-1)*200 + E+1] > 0) index += 64;
                if(inimg->imgData[(S  )*200 + E+1] > 0)   index += 128;
                if(inimg->imgData[(S+1)*200 + E+1] > 0) index += 256;

                unsigned char replacedPix1 = lutthin1[index];
                unsigned char replacedPix2 = lutthin2[index];
                unsigned char replacedPix3 = lutthin3[index];

                workImg[s*200 + e] = inimg->imgData[S*200 + E] && !(replacedPix1 && replacedPix2 && replacedPix3);

            }

    }


    for(int s = 1; s < 199; s++) {// 境界上のpix に3-by-3 近隣がないに注意！  従って、その3-by-3 近隣パターンに対応する２進値もない。
        // 注意3-3接近的边界像素的情况下！因此，不存在对应的二进制值的3-3模式，接近。
            for(int e = 1; e < 199; e++) {// imageの(1,1)に対応するindexは存在しない！ 不存在索引，对应于（1,1）的图像！
                int index = 0;
                if(workImg[(s-1)*200 + e-1] > 0) index += 1;
                if(workImg[(s  )*200 + e-1] > 0)   index += 2;
                if(workImg[(s+1)*200 + e-1] > 0) index += 4;
                
                if(workImg[(s-1)*200 + e] > 0)   index += 8;
                if(workImg[(s  )*200 + e] > 0)     index += 16;
                if(workImg[(s+1)*200 + e] > 0)   index += 32;
                
                if(workImg[(s-1)*200 + e+1] > 0) index += 64;
                if(workImg[(s  )*200 + e+1] > 0)   index += 128;
                if(workImg[(s+1)*200 + e+1] > 0) index += 256;

                unsigned char replacedPix1 = lutthin1[index];
                unsigned char replacedPix2 = lutthin2[index];
                unsigned char replacedPix4 = lutthin4[index];

                unsigned char niv = workImg[s*200 + e] && !(replacedPix1 && replacedPix2 && replacedPix4);

                int S = s;
                int E = e;// + e0;

                if(niv != (inimg->imgData[(S)*200 + E] > 0)) {
		    if(niv > 0)
			inimg->imgData[(S)*200 + E] = 255;//(niv>0)?255:0;
                    else
			inimg->imgData[(S)*200 + E] = niv;
                    changedCount++;
                }


            }

        }
        // cout << changedCount << "f" << endl;

    return  changedCount;
    
    }
               __host__ int 
    Thinning::ser_thin_MATLABLike(
            Image *inimg,    // 输入图像
            Image *outimg    // 输出图像
    )
    {
    // cout << "1" << endl;
	ImageBasicOp::copyToHost(inimg,outimg);
	
	// cout << "1" << endl;
		while(_ser_thin_MATLABLike(outimg) > 0);
	return 0;
    }
    


