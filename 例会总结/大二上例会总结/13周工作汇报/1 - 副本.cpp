#include "stdafx.h"
#include <stdio.h>
//#include <iostream.h>
#include <memory.h>
#include <string.h>
//#include "malloc_image.h"

#ifndef imageProcess_h
#define imageProcess_h
#include "../imageProcess/imageProcess.h"
#endif

#include "../TraceCurve.h"

namespace _ThinEdge {

#define UPPER_LEFT 2
#define LOWER_RIGHT 6
#define UPPER_RIGHT 0
#define LOWER_LEFT 4

	bool change_flag = false;

	unsigned char **copied_pixels;
	unsigned char **target_pixels;


void pruneSpurs(unsigned char **_edge, int s0, int e0, int ss, int es, int dotimes)
{

	//   0  0  0  0
	//   0  0  0  0
	//   0  0  1  0
	//   0  0  0  0
#define checkTemp1(p) !p[1][1] && !p[1][2] && !p[1][3] && !p[2][1] && !p[2][3] && !p[3][1]


	int S = s0 + ss - 2;
	int E = e0 + es - 2;

	unsigned char ** rotatArea = getRotatArea<unsigned char>(1, 1);
	//	unsigned char ** tt = rotatn<unsigned char>((unsigned char**)image, 0, 0, 5, 5, 45);


	do{
		for(int s = s0 + 2; s < S; s++) {
			for(int e = e0 + 2; e < E; e++) {
				if(_edge[s][e] > 0) {
					for(int i=0; i<8; i++) {
						//順時針for 3×3 template
//						rotat45n<unsigned char>(_edge, s, e, 1, 1, i, rotatArea);
						if(checkTemp1(rotatArea)) {
							_edge[s][e] = 0;
							break;
						}

					}

				}

			}
		}

	}while(--dotimes > 0);

	free2d(rotatArea);



}

	//細線化のメソッド 细线化的方法
	void thinImage(int i, int j, int start){//このthinning algorithmからすると、_edge値を非0仮定しているが、具体的な値を仮定していない。

		unsigned char p[8];

		// 周辺のデータをコピーする  拷贝周边的数据
		p[0]=copied_pixels[i-1][j-1];
		p[1]=copied_pixels[i-1][j];
		p[2]=copied_pixels[i-1][j+1];
		p[3]=copied_pixels[i][j+1];
		p[4]=copied_pixels[i+1][j+1];
		p[5]=copied_pixels[i+1][j];
		p[6]=copied_pixels[i+1][j-1];
		p[7]=copied_pixels[i][j-1];

		// 周辺の黒（~0 /true）の三個連続と白（0 /false）の三個連続があれば、そのピクセルを白（false）にする
		//周围有连续3个黑的和白的的话，把它的像素变成白色（false）
		for(register int k=start; k<start+3; k++){
			bool not0 = (p[k % 8] != 0) && (p[(k+1) % 8] != 0) && (p[(k+2) % 8] != 0);
			bool not1 = (p[(k+4) % 8] == 0) && (p[(k+5) % 8] == 0) && (p[(k+6) % 8] == 0);
			if(not0 && not1){
				target_pixels[i][j] = 0;   // 消去する  消去
				change_flag = true;
				return;
			}

		}

	}

}

using namespace _ThinEdge;
//using namespace _Make2dMalloc;

// imageは２値データと見なされるが、0/1に限定されるわけではない。あらゆる　0 / >0 の画像値を２値画像と見なされる。
// 【アルゴリズムはunsigned char同士の論理andで実現しているので、画像データは unsigned charであるのは変更できない】
// ＃＃ ただし、入力変数そのもの利用してthinningを行うので、
// ＃＃ もし引数(s0, e0, doSS, doES)に指定されるthinning範囲が画像(image)の全域に渡って行われなければ、
// ＃＃ 元の画像データがimageに残るまま....thinning 結果(0/1画像値)と混在する！
// ❑　従って、「1の処のみ」はthinning結果である可能性はあるが、絶対ではない。

// 3-by-3 近隣pixs(3x3 matrix)を２進値に変換する。
// -----weightの振り付けはMATLABと違って、MATLABの実装に実際利用しているweightの振り付けを使用：
//   1    8     64
//   2   16    128
//   4   32    256

// s0, e0 : _edge の左上からのoffset...start位置
// doSS, doES : thinningを実行する縦幅と横幅....imageの高と寛そのものではない！！

// 入力画像は２値画像ではあるが、0/1画像である必要はない、ただ、
// 出力画像は0/1画像になる。

// ★★ 引数として下記関係を保証しなければならない！！
// s0 + doSS < height of image
// e0 + doES < width of image

unsigned int thin_MATLABLike(unsigned char **image, int s0, int e0, int doSS, int doES)
{
	unsigned char lutthin1[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0};
	unsigned char lutthin2[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0};
	unsigned char lutthin3[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
	unsigned char lutthin4[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0};

	static unsigned char ** workImg;

	if(workImg == NULL) {
		workImg = make2d0<unsigned char>(doSS, doES);
		if(workImg == NULL) return -1;

	}

	unsigned int changedCount = 0;

	int maxs = doSS-1;    // 行
	int maxe = doES-1;    // 列

	{
		for(int s = 1; s < maxs; s++) {// 境界上のpix に3-by-3 近隣がないに注意！  従って、その3-by-3 近隣パターンに対応する２進値もない。
			                           //注意附近没有 像素边界上的pix 3 - by - 3!因此,3 - by - 3附近方式应对2进值也达到了。
			for(int e = 1; e < maxe; e++) {// imageの(1,1)に対応するindexは存在しない！  不要图像（1,1）对应的目录
				int S = s + s0;
				int E = e + e0;
				int index = 0;
				if(image[S-1][E-1] > 0) index += 1;
				if(image[S][E-1] > 0)   index += 2;
				if(image[S+1][E-1] > 0) index += 4;
                
				if(image[S-1][E] > 0)   index += 8;
				if(image[S][E] > 0)     index += 16;
				if(image[S+1][E] > 0)   index += 32;
                
				if(image[S-1][E+1] > 0) index += 64;
				if(image[S][E+1] > 0)   index += 128;
				if(image[S+1][E+1] > 0) index += 256;

				unsigned char replacedPix1 = lutthin1[index];
				unsigned char replacedPix2 = lutthin2[index];
				unsigned char replacedPix3 = lutthin3[index];

				workImg[s][e] = image[S][E] && !(replacedPix1 && replacedPix2 && replacedPix3);

			}

		}

	}


	{
		for(int s = 1; s < maxs; s++) {// 境界上のpix に3-by-3 近隣がないに注意！  従って、その3-by-3 近隣パターンに対応する２進値もない。
        // 注意3-3接近的边界像素的情况下！因此，不存在对应的二进制值的3-3模式，接近。
			for(int e = 1; e < maxe; e++) {// imageの(1,1)に対応するindexは存在しない！ 不存在索引，对应于（1,1）的图像！
				int index = 0;
				if(workImg[s-1][e-1] > 0) index += 1;
				if(workImg[s][e-1] > 0)   index += 2;
				if(workImg[s+1][e-1] > 0) index += 4;
				if(workImg[s-1][e] > 0)   index += 8;
				if(workImg[s][e] > 0)     index += 16;
				if(workImg[s+1][e] > 0)   index += 32;
				if(workImg[s-1][e+1] > 0) index += 64;
				if(workImg[s][e+1] > 0)   index += 128;
				if(workImg[s+1][e+1] > 0) index += 256;

				unsigned char replacedPix1 = lutthin1[index];
				unsigned char replacedPix2 = lutthin2[index];
				unsigned char replacedPix4 = lutthin4[index];

				unsigned char niv = workImg[s][e] && !(replacedPix1 && replacedPix2 && replacedPix4);

				int S = s + s0;
				int E = e + e0;

				if(niv != image[S][E]) {
					image[S][E] = niv;
					changedCount++;
				}


			}

		}

	}

//	free2d(workImg);

	return changedCount;


}


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//  元の画像データがimageに残らないように一定水準(imgThred)以下の画素値を0にする....thinning 結果(0/1画像値)と混在する可能性がある！
// ❑　従って、「画素値= thinvの処のみ」はthinning結果である可能性はあるが、絶対ではない。
// thinning結果の出力画像は結果線のところ指定した値：thinvになる。
//unsigned int thin_MATLABLike(unsigned char **image, int s0, int e0, int doSS, int doES, unsigned char imgThred, unsigned char thinv, unsigned char ** workImg)
/***
为了使原来的图像数据在image里没有残留，选择一定的水平(imgthred)以下的像素,0。…可能混在thinning结果(0 / 0图像值)中!
因此,在“像素值只是thinv”的地方 有thinning结果的可能性存在，但不是绝对的
thinning输出的结果，图像在结果线的地方指定的值,变成了thinv:

****/


unsigned int thin_MATLABLike(unsigned char **image,
							 int s0, int e0,
							 int doSS, int doES,
							 unsigned char imgThred,
							 unsigned char thinv)
{
	unsigned char lutthin1[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0};
	unsigned char lutthin2[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0};
	unsigned char lutthin3[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
	unsigned char lutthin4[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0};


//	bool makeWorkImgFlag = false;


	static unsigned char ** workImg;

	if(workImg == NULL) {
		workImg = make2d0<unsigned char>(doSS, doES);
		if(workImg == NULL) return -1;

	}

	unsigned int changedCount = 0;

	int maxs = doSS-1;
	int maxe = doES-1;

	{// workImage matrixの範囲で操作  在workimage matrix的基础上操作
		for(int s = 1; s < maxs; s++) {// 境界上のpix に3-by-3 近隣がないに注意！  従って、その3-by-3 近隣パターンに対応する２進値もない。
			for(int e = 1; e < maxe; e++) {// imageの(1,1)に対応するindexは存在しない！


				int S = s + s0;
				int E = e + e0;

				if(image[S][E] > imgThred) {

					int index = 0;
					if(image[S-1][E-1] > imgThred) index += 1;
					if(image[S][E-1] > imgThred)   index += 2;
					if(image[S+1][E-1] > imgThred) index += 4;
					if(image[S-1][E] > imgThred)   index += 8;
					if(image[S][E] > imgThred)     index += 16;
					if(image[S+1][E] > imgThred)   index += 32;
					if(image[S-1][E+1] > imgThred) index += 64;
					if(image[S][E+1] > imgThred)   index += 128;
					if(image[S+1][E+1] > imgThred) index += 256;

					unsigned char replacedPix1 = lutthin1[index];
					unsigned char replacedPix2 = lutthin2[index];
					unsigned char replacedPix3 = lutthin3[index];

					workImg[s][e] = !(replacedPix1 && replacedPix2 && replacedPix3);// 論理値0/1が設定される。  设置0/1的理论值

				}

				else{
					image[S][E] = 0;
					workImg[s][e] = 0;
				}

			}

		}

	}


	{
		for(int s = 1; s < maxs; s++) {// 境界上のpix に3-by-3 近隣がないに注意！  従って、その3-by-3 近隣パターンに対応する２進値もない。
			for(int e = 1; e < maxe; e++) {// imageの(1,1)に対応するindexは存在しない！

				int S = s + s0;
				int E = e + e0;


				if(workImg[s][e]==0 && image[S][E]!=0) {
					image[S][E]=0;
					changedCount++;
					continue;
				}

				if(image[S][E]<imgThred) continue;

				int index = 0;
				if(workImg[s-1][e-1] > 0) index += 1;
				if(workImg[s][e-1] > 0)   index += 2;
				if(workImg[s+1][e-1] > 0) index += 4;
				if(workImg[s-1][e] > 0)   index += 8;
				if(workImg[s][e] > 0)     index += 16;
				if(workImg[s+1][e] > 0)   index += 32;
				if(workImg[s-1][e+1] > 0) index += 64;
				if(workImg[s][e+1] > 0)   index += 128;
				if(workImg[s+1][e+1] > 0) index += 256;

				unsigned char replacedPix1 = lutthin1[index];
				unsigned char replacedPix2 = lutthin2[index];
				unsigned char replacedPix4 = lutthin4[index];

				unsigned char niv = (!(replacedPix1 && replacedPix2 && replacedPix4))*thinv;

				if(niv != image[S][E]) {
					image[S][E] = niv;
					changedCount++;
				}


			}

		}

	}

//	if(makeWorkImgFlag)free2d(workImg);

	return changedCount;


}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

long countNon0Pix(unsigned char **image, int s0, int e0, int ss, int es)
{
	long count = 0;
	for(int s = s0; s < ss; s++){
		for(int e = e0; e < es; e++){
			if(image[s][e]>0) count++;
		}

	}

	return count;

}



int thin(unsigned char **image, int s0, int e0, int doSS, int doES)
{
	//	if(image == NULL) return -1;
	if(s0 < 0 || e0 < 0 || doSS < 10 || doES < 10 ) {
		return -1;
	}

	if(thin_MATLABLike(image, s0, e0, doSS, doES) == 0) {
		thin_MATLABLike(image, s0, e0, doSS, doES); // ?????? thinning結果画像に３近傍点が存在するため、余分の一回試したい
                                                    //结果因为画面上3近傍的点存在,因此想再试一试

		return 0;
	}

	return 0;


}


// 入力画像：２値画像で、0/1画像である必要はない。   输入画像：用2个数值图像,没必要要0/1图像。

// 出力画像：0/1画像                                 输出画像：0/1图像
// times : thinningの回数指定....能率がいい          指定次数，效率会好（效率怎么办呢）
// thinningの結果としての線の太さが1より大きくてもOKの場合に利用される。 作为thinning的结果的线，比1大的场合也可以加以利用
int thin(unsigned char **image, int s0, int e0, int doSS, int doES, int times)
{
#ifdef DEBUG
	//	if(image == NULL) return -1;
	if(s0 < 0 || e0 < 0 || doSS < 10 || doES < 10 ) {
		return -1;
	}
#endif

	while(times-- > 0){
		if(thin_MATLABLike(image, s0, e0, doSS, doES)==0) return 0;
	}


	return 0;


}

unsigned int thin_MATLABLike(unsigned char **image, int s0, int e0, int doSS, int doES, unsigned char imgThred, unsigned char thinv);


int thin(unsigned char **image,
		  int s0, int e0,
		  int doSS, int doES,
		  unsigned char imgThred,
		  unsigned char thinv,
		  int times)
{

#ifdef DEBUG
	if(image == NULL) return -1;
	if(s0 < 0 || e0 < 0 || doSS < 10 || doES < 10) {
		return -2;
	}
#endif

	while(times-- > 0){
		if(thin_MATLABLike(image, s0, e0, doSS, doES, imgThred, thinv)==0) break;
	}

	return 0;
}





// 入力画像：２値画像で、0/1画像である必要はない。
// 出力画像：入力画像と同じ２値画像           输出图像：和输入图像一样的2像素的图像
// short s0, e0 : _edge の左上からのoffset    左上角开始
int thinEdge(unsigned char **_edge, int s0, int e0, int ss, int es)
{
	if(_edge == NULL) return -1;
	if(s0 < 0 || e0 < 0 || ss < 10 || es < 10 ) {
		return -2;
	}

	if((copied_pixels = make2d<unsigned char>(ss, es, 0)) == NULL){
		return -3;
	}

	if((target_pixels = make2d<unsigned char>(ss, es, 0)) == NULL){
		return -4;
	}


	{//まずはオリジナルの_edge内容をtarget_pixels[][]へコピー 首先把视频连接的边缘内容拷贝到target_pixels[][]
		for(int s = 0; s < ss; s++){
			for(int e = 0; e < es; e++){
				target_pixels[s][e] = _edge[ s0 + s ][ e0 + e ];//画像でエッジを確認しやすいために、二値化しないで(ここでのthinngアルゴリズムには特に対象の値を仮定していない)
				                                                //这里为了使图像的边缘好确认，所以请不要2进制化（这种情况下对thinning的算法，不要特意假定对象的值）
			}

		}
	}
	// ↑：☆後でこれをやれー！！！！！！！！！！！ 之后让我们简化下面的程式吧！！！
	// memcpy(target_pixels[0], _edge[0], sizeof(unsigned char)*ss*es);


	//細線化を実行する        实例化细线
	int size = ss * es * sizeof(unsigned char);
	do{
		change_flag = false;
		register int j,i;
		//左上から         从左上角开始
		//copyTargetToCopied();
		memcpy(copied_pixels[0], target_pixels[0], size);
		for(j=1;j < es; j++){
			for(i=1; i < ss; i++)
				if(copied_pixels[i][j]) thinImage(i,j,UPPER_LEFT);
		}
		//右下から        从右上角开始
		//copyTargetToCopied();
		memcpy(copied_pixels[0], target_pixels[0], size);
		for(j = es-1;j>=1;j--){
			for(i = ss-1;i>=1;i--)
				if(copied_pixels[i][j]) thinImage(i,j,LOWER_RIGHT);
		}
		//右上から
		//copyTargetToCopied();
		memcpy(copied_pixels[0], target_pixels[0], size);
		for(j=1; j < es;j++){
			for( i = ss-1;i>=1;i--)
				if(copied_pixels[i][j]) thinImage(i,j,UPPER_RIGHT);
		}
		//左下から
		//copyTargetToCopied();
		memcpy(copied_pixels[0], target_pixels[0], size);
		for(j=es-1;j>=1;j--){
			for(i=1; i < ss;i++)
				if(copied_pixels[i][j]) thinImage(i,j,LOWER_LEFT);
		}


	}while(change_flag);


	{//thinning結果を元の_edge領域に複製  复制thinning结果原来的边缘
		for(register int s = 0; s < ss; s++){
			for(register int e = 0; e < es; e++){
				_edge[ s0 + s ][ e0 + e ] = target_pixels[s][e];
			}

		}
	}

	free2d<unsigned char>(copied_pixels);
	free2d<unsigned char>(target_pixels);


	return 0;
}


int thresholdEdge(unsigned char **_edge, double **magnitude, int x0, int y0, int width, int height, double highThre){

	for(register int x = x0+2; x < width-2; x++) {
		for(register int y = y0+2; x < height-2; y++) {

			if(_edge[x][y] < highThre) {

				_edge[x][y] = 0;;
			}

		}

	}

	return 0;

}


inline void setEdge(unsigned char **tempEdge, TraceCurve::TracedCurve *tcp, unsigned char edgeValue, int x0, int y0)
{
	for(register unsigned int i = 0; i < tcp->length; i++) {
		tempEdge[tcp->x[i]-x0][tcp->y[i]-y0] = edgeValue;
	}


}

//extern 	CurveTracing(FloatImage *image, float minIndecateValue, float maxIndecateValue);

void getTrueEdge(unsigned char *_edge, int x0, int y0, int width, int height, unsigned int maxEdgeLength, unsigned char edgeValue)
{

	unsigned char **tempEdge = make2d<unsigned char>(height-y0+1, width-x0+1, 0);
	if(tempEdge==NULL) throw -1;

	TraceCurve::TracedCurve tcp;
	tcp.x = new int[maxEdgeLength+1];
	tcp.y = new int[maxEdgeLength+1];
	tcp.lengthMaxLimit = maxEdgeLength;


	Image1D image;

	image.type= &typeid(unsigned char);
	image.value1D = _edge;
	image.width = width;
	image.height = height;
	image.size = width*height;
	image.concatDir = COL_CONCATENAT;

	//	CurveTracing<unsigned char> ct(&image,UCHAR_MAX, UCHAR_MAX);

	TraceCurve ct(&image, (unsigned char)UCHAR_MAX, (unsigned char)UCHAR_MAX, false, 25, 25,(unsigned char)0);

	for(register int x = x0+2; x < width-2; x++) {
		for(register int y = y0+2; x < height-2; y++) {

//			int p[2] = {x, y};
			ct.startTraceCurve(x,y, &tcp);
			if(tcp.length > maxEdgeLength) {
				setEdge(tempEdge, &tcp, edgeValue, x0, y0);
			}

		}

	}

	//	copyEdge(_edge, tempEdge, x0, y0);


}


inline bool checkMask(unsigned char *p)
{
	// X 0 0 0 X 1 1 1
	bool b1 = (!p[1] && !p[2] && !p[3] &&  p[5] &&  p[6] &&  p[7]);

	// 1 1 X 0 0 0 X 1
	bool b2 = ( p[0] &&  p[1] && !p[3] && !p[4] && !p[5] &&  p[7]);

	// X 1 1 1 X 0 0 0
	bool b3 = ( p[1] &&  p[2] &&  p[3] && !p[5] && !p[6] && !p[7]);

	// 0 0 X 1 1 1 X 0
	bool b4 = (!p[0] && !p[1] &&  p[3] &&  p[4] &&  p[5] && !p[7]);


	return b1 || b2 || b3 || b4;

}







void clockwiseCopy(unsigned char **image, int x0, int y0, int w, int h, unsigned char *p);


// 順時針for 5×5 template     顺时针~~
// 中心画素をspursとして消去する。  删除作为spurs的中心画素
#define ifPrune(_edge, s0, e0, w, h, p)\
	clockwiseCopy(_edge, s0, e0, w, h, p);\
	if(checkMask(p)) {\
	_edge[s][e] = 0;\
	continue;\
	}\




void clockwiseCopy(unsigned char **image, int x0, int y0, int w, int h, unsigned char *p)
{
	register int i=0;
	int upper = 0;
	int under = h-1;
	int left = 0;
	int right = w-1;

trans:
	register int x=x0;
	register int y=y0;
	register int c=0;
	int size = ((w-1)+(h-1))*2;

	while(1) {

		if(y == upper) {
			for(; x <= right-1; x++){
				p[i++] = image[x][y];
				if(++c>=size) goto next;
			}
		}
		else
			if(y == under) {
				for(; x >=left+1; x--){
					p[i++] = image[x][y];
					if(++c>=size) goto next;
				}
			}


			if(x == left){
				for(; y >=upper+1; y--){
					p[i++] = image[x][y];
					if(++c>=size) goto next;
				}
			}
			else
				if(x == right){
					for(; y <= under-1; y++){
						p[i++] = image[x][y];
						if(++c>=size) goto next;
					}

				}

	}

next:
	if(x0==0) x0++;
	if(x0==w-1) x0--;
	if(y0==0) y0++;
	if(y0==h-1) y0--;

	upper++;
	under--;;
	left++;
	right--;

	w -=2;
	h -=2;


	if(w < 2 || h < 2 )	return;
	goto trans;


}

namespace PRUNE
{
	unsigned char **_edge = NULL;
	int s0;
	int e0;
	int segSize;
	int eleSize;
	int *chainS = NULL;
	int *chainE = NULL;
	int limitSize;
	int length;
	unsigned char ** tracedMap = NULL;
}

//using namespace PRUNE;
using namespace PRUNE;
// rest is count == 2, it is for continue;
#define checkDivergence(s1, e1)\
{\
	bool cond1 = (s1 > s0 + 2) && (s1 < s0 + segSize - 2);\
	bool cond2 = (e1 > e0 + 2) && (e1 < e0 + eleSize - 2);\
	bool cond3 = _edge[s1][e1] > 0;\
	bool cond4 = tracedMap[s1-s0][e1-e0] != 1;\
	if(cond1 && cond2 && cond3 && cond4) {\
	tracedMap[s1-s0][e1-e0] = 1;\
	int count=0;\
	count8N(_edge, s1, e1, count);\
	if(count > 0) {\
	chainS[length] = s1;\
	chainE[length] = e1;\
	if(length++ > limitSize) return;\
	if(count == 2){\
	traceUnlessDivergence(s1, e1);\
	} else {\
	if(count > 2) return;\
	}\
	}\
	}\
}\


void traceUnlessDivergence(int s, int e)
{
	checkDivergence(s-1, e-1);
	checkDivergence(s-1,   e);
	checkDivergence(s-1, e+1);
	checkDivergence(s,   e-1);
	checkDivergence(s,   e+1);
	checkDivergence(s+1, e-1);
	checkDivergence(s+1,   e);
	checkDivergence(s+1, e+1);

}


#define erase(setv)\
{\
	for(int i=0; i < PRUNE::length; i++) {\
	PRUNE::_edge[PRUNE::chainS[i]][PRUNE::chainE[i]] = 0;\
	}\
}\



void setSelectedEdge(unsigned char ** selectedEdge)
{
	for(int i=0; i < PRUNE::length; i++) {
		selectedEdge[PRUNE::chainS[i]][PRUNE::chainE[i]] = 200;
	}
}



unsigned char ** __prune(unsigned char **	_edge, int img_segs, int img_eles,  int s0, int e0, int sSize, int eSize, char edgev, int limitSize, unsigned char setv)
{
	int * chainS = new int[limitSize+10];
	int * chainE = new int[limitSize+10];
	PRUNE::_edge = _edge;
	PRUNE::s0 = s0;
	PRUNE::e0 = e0;
	PRUNE::segSize = sSize;
	PRUNE::eleSize = eSize;
	PRUNE::chainS = chainS;
	PRUNE::chainE = chainE;
	PRUNE::limitSize = limitSize;
	PRUNE:: tracedMap = make2d<unsigned char>(sSize, eSize, 0);

	//	unsigned char ** selectedEdge = make2d<unsigned char>(img_segs, img_eles, 0);

	int count = 0;

	for(int s = s0; s < sSize; s++) {
		for(int e = s0; e < eSize; e++) {
			if(_edge[s][e] >= edgev) {
				count8N(_edge,s,e,count);
				if(count==0) {//孤立点
					_edge[s][e] = setv;
					continue;
				}
				//				if(count != 2) {
				PRUNE::length = 0;
				traceUnlessDivergence(s,e);
				//					if (PRUNE::length > 1 && PRUNE::length < 7) {
				//						erase(setv);
				//					}

				if (PRUNE::length < 5) {
					erase(setv);
				}
				//				else
				//				if (PRUNE::length > 20) {
				//					printf("%d,  ", PRUNE::length);
				//					setSelectedEdge(selectedEdge);
				//				}

				//				}

			}


		}

	}

	//	return selectedEdge;
	return NULL;

}

// _edge : 処理対象とする画像(通常はエッジ画像)  处理对象和影像(通常是边缘边图像)
// img_segs, img_eles : _edgeのフルサイズ  的影像
// s0,e0：実際処理の開始位置      实际的处理开始的位置
// sSize, eSize：実際処理の範囲 sSize <= img_segs; eSize <= img_eles    实际处理的范围
// edgev：_edgeの有効画像値(エッジ値)     有效地画像的值（边缘值）
// limitSize：追跡の長さがこれ以上であれば、有効エッジと認められ、これ以上の追跡を停止
//轨迹长度在这之上的话,将有效的跳跃,认可有效地边缘,停止在这之上的轨迹

// setv : 非有効エッジとして消去に使う値    作为非有效地边缘删除他的使用值
void __shave(unsigned char **	_edge, int img_segs, int img_eles,  int s0, int e0, int sSize, int eSize, char edgev, int limitSize, unsigned char setv)
{
	int * chainS = new int[limitSize+10];
	int * chainE = new int[limitSize+10];
	PRUNE::_edge = _edge;
	PRUNE::s0 = s0;
	PRUNE::e0 = e0;
	PRUNE::segSize = sSize;
	PRUNE::eleSize = eSize;
	PRUNE::chainS = chainS;
	PRUNE::chainE = chainE;
	PRUNE::limitSize = limitSize;
	PRUNE:: tracedMap = make2d<unsigned char>(sSize, eSize, 0);

	int count = 0;

	for(int s = s0; s < sSize; s++) {
		for(int e = s0; e < eSize; e++) {
			if(_edge[s][e] >= edgev) {
				count8N(_edge,s,e,count);
				if(count == 0) { // 孤立点
					_edge[s][e] = setv;
					continue;
				}
				if(count == 1) { // 端点
					PRUNE::length = 0;
					traceUnlessDivergence(s,e);
					if (PRUNE::length > 1 && PRUNE::length < limitSize) {
						erase(setv);
					}

				}

			}

		}
	}

}


#define remove(_edge, length, setv)\
{\
	for(int i=0; i < length; i++) {\
	_edge[chainS[i]][chainE[i]] = setv;\
	}\
}\


