#include <iostream>
using namespace std;

/*#include "Image.h"
#include "Template.h"
#include "AffineTrans.h"
#include "RotateTable.h"
#include "SelectShape.h"
#include "SortArray.h"
#include "ErrorCode.h"
#include "Histogram.h"
#include "HistogramSpec.h"
#include "Threshold.h"
#include "Binarize.h"
#include "Morphology.h"
#include "ConnectRegion.h"
#include "Flip.h"
#include "BoundingRect.h"
#include "FillUp.h"
#include "Moments.h"
#include "GeometryProperties.h"
#include "ImageShrink.h"
#include "HoughLine.h"
#include "CoordiSet.h"
#include "FeatureVecCalc.h"
#include "FeatureVecArray.h"
#include "ScanArray.h"*/
#include "Thinning.h"

#define ROUND_NUM 1

int main()
{
//-------WorkAndObjectMatch------------//
    // Image **images = new Image*[2];
    // int imagecount = 2;
    // ImageBasicOp::newImage(&images[0]);
    // ImageBasicOp::readFromFile("A8_64.bmp", images[0]);
    // ImageBasicOp::newImage(&images[1]);
    // ImageBasicOp::readFromFile("A8_128.bmp", images[1]);

    // Image *test;
    // ImageBasicOp::newImage(&test);
    // ImageBasicOp::readFromFile("test8_abc.bmp", test);

    // RotateTable rotatetable;
    // rotatetable.setMinAngle(10);
    // rotatetable.setMaxAngle(20);
    // rotatetable.setDetAngle(1);
    // rotatetable.setSizeX(images[0]->width * 2);
    // rotatetable.setSizeY(images[0]->height * 2);
    // cout << "min angle " << rotatetable.getMinAngle() << endl;
    // cout << "max angle " << rotatetable.getMaxAngle() << endl;

   // int dwidth = 32;
   // int dheight = 32;
   // int dx = 32;
   // int dy = 32;
    // int dwidth = images[0]->width * 1.5;
    // int dheight = images[0]->height * 1.5;
    // int dx = dwidth / 2;
    // int dy = dheight / 2;

    // RotateTable worktable;
    // worktable.setMinAngle(10);
    // worktable.setMaxAngle(20);
    // worktable.setDetAngle(1);
    // worktable.setSizeX(images[0]->width / 8 * 2);
    // worktable.setSizeY(images[0]->height / 8 * 2);

    // ImagesInfo workinfo;
    // workinfo.images = images;
    // workinfo.count = imagecount;
    // workinfo.rotateTable = &worktable;
    // workinfo.dWidth = test->width / 8;
    // workinfo.dHeight = test->height / 8;
    // workinfo.dX = workinfo.dWidth / 2;
    // workinfo.dY = workinfo.dHeight / 2;

    // ImagesInfo imagesinfo[2];
    // int imagesinfocount = 1;
    // for (int i = 0; i < imagesinfocount; i++) {
        // imagesinfo[i].images = images;
        // imagesinfo[i].count = imagecount;
        // imagesinfo[i].rotateTable = &rotatetable;
        // imagesinfo[i].dWidth = dwidth;
        // imagesinfo[i].dHeight = dheight;
        // imagesinfo[i].dX = dx;
        // imagesinfo[i].dY = dy;
    // }
   // Image *test;
   // ImageBasicOp::newImage(&test);
   // ImageBasicOp::readFromFile("test8_ab.bmp", test);
    // WorkAndObjectMatch objectmatch(&workinfo, imagesinfo, imagesinfocount,
                                   // 10);
    // MatchRes res[2];
    // int rescount = 1;
    // int errcode;
    // float rumtime;
    // cudaEvent_t start, stop;
    // cudaEventCreate(&start);
    // cudaEventCreate(&stop);
    // cudaEventRecord(start, 0);
    // errcode = objectmatch.workAndObjectMatch(test, res, rescount);
    // cudaEventRecord(stop, 0);
    // cudaEventSynchronize(stop);
    // cudaEventElapsedTime(&rumtime, start, stop);
    // if (errcode != NO_ERROR) {
        // cout << "error code is " << errcode << endl;
        // return -1;
    // }
    // cout << "success" << endl;
    // cout << "the time is " << (rumtime / ROUND_NUM) << " ms" << endl;
    // cout << "res:" << endl;
    // for (int i = 0; i < rescount; i++) {
        // cout << i << ":" << res[i].tplIndex << endl;
    // }

    // return 0;
    // RotateTable rt;
    // rt.setMinAngle(15);
    // rt.setMaxAngle(15);
    // rt.setDetAngle(0.2);
    // cout << rt.getAngleCount() << endl;
    // for (int i = 0; i < rt.getAngleCount(); i++)
        // cout << rt.getAngleVal(i) << ", ";
    // cout << endl;
    // cout << rt.getAngleIdx(15.05) << " " << rt.getAngleIdx(15.37) << endl;

        // Image *img, *img2;
//----Affine Transform----//    
    // AffineTrans at;
    // at.setAlpha(60.0f);
    // at.setX(320);
    // at.setY(240);
    // at.setImpType(SOFT_IPL);
    // //cout << at.getAlpha() << endl;
    
//----Select Shape----//
//    int areaRank[14] = {72266,127,73248,82,37966,195,61483,242,73248,215,74760,192,68600,42};
//    int pairsNum = 7;
//    int index = 2;
//    int value = 73248;
//    int minValue = 73248;
//    int maxValue = 74760;
//    SelectShape ss;
//    ss.setRank(areaRank);
//    ss.setPairsNum(pairsNum);
//    ss.setIndex(index);
//    ss.setValue(value);
//    ss.setMinValue(minValue);
//    ss.setMaxValue(maxValue);
    
    
//----Sort Array----//
//    SortArray sa;
//    int inarray[8] = {4,5,7,2,1,3,8,6};
//    int outarray[8] = {0};
//    sa.setLength(8);
//    sa.setLenSec(1);
//    sa.setSortFlag(1);
//    sa.setIsHost(1);
    
//    sa.bitonicSort(inarray, outarray);  
//    for (int i = 0; i < 8; i++)
//    {
//         cout<<outarray[i]<<endl;
//    }
  
//----Histogram----
//    Image *inimg;
//    ImageBasicOp::newImage(&inimg);
    
//    cout << "AA" << endl;
    
//    ImageBasicOp::readFromFile("hist_in.bmp", inimg);
    
//    Histogram hist;
//    unsigned int histogram[256] = {0};
//    bool onhostarray = true;
//    hist.histogram(inimg, histogram, onhostarray);
//    unsigned int sum = 0;
    
//    for (int i = 0; i < 256; i++)
//    {
//        sum += histogram[i];
//        cout << i << "=" << histogram[i] << endl;
//    }
    
//    cout << "The sum pixel is: " << sum << endl;
    
//----HistogramSpec----
//    Image *inimg;
//    ImageBasicOp::newImage(&inimg);
//    ImageBasicOp::readFromFile("hist_in.bmp", inimg);
    
//    Image *outimg;
//    ImageBasicOp::newImage(&outimg);
//    ImageBasicOp::makeAtHost(outimg, inimg->width, inimg->height);
    
//    Image *refimg;
//    ImageBasicOp::newImage(&refimg);
//    ImageBasicOp::readFromFile("hist_ref.bmp", refimg);
       
//    float histspec[256];
    
//    for (int j = 0; j < 256; j++) {
//        histspec[j] = (float)1 / 256;
//    }
    
//    HistogramSpec hs;
//    hs.setRefimg(refimg);
//    hs.setRefHisto(histspec);
//    //hs.HistogramEquilibrium(inimg, outimg);
//    //hs.HistogramSpecByImage(inimg, outimg);
//    hs.HistogramSpecByHisto(inimg, outimg);
    
//    ImageBasicOp::copyToHost(outimg);
//    //ImageBasicOp::writeToFile("hist_outequ.bmp", outimg);
//    //ImageBasicOp::writeToFile("hist_outimg.bmp", outimg);
//    ImageBasicOp::writeToFile("hist_outhist.bmp", outimg);
    
//    ImageBasicOp::deleteImage(inimg);
//    ImageBasicOp::deleteImage(outimg);
//    ImageBasicOp::deleteImage(refimg);
   
    
//    ImageBasicOp::newImage(&img);
//    ImageBasicOp::newImage(&img2);
    
//    cout << "AA" << endl;

//    ImageBasicOp::readFromFile("selectshape_in.bmp", img);
//    ImageBasicOp::readFromFile("selectshape_in.bmp", img2);
    
//    //img->roiX1 = 240;
//    //img->roiY1 = 50;

//    //cout<<ss.selectShapeByIndex(img, img2)<<endl;
//    //ImageBasicOp::makeAtCurrentDevice(img2, 640, 480);

//    //img2->roiY1 = 100;

//    //cout << "xx" << endl;

//    // cout << at.rotateCenter(img, img2) << endl;
//    //ImageBasicOp::copyToCurrentDevice(img, img2);
//    cout <<cudaGetErrorString(cudaGetLastError())<<endl;

//    //ImageBasicOp::writeToFile("selectshape_out.bmp", img2);

//    ImageBasicOp::deleteImage(img);
//    ImageBasicOp::deleteImage(img2);

//----LabelIslandSortArea----
//      Image *inimg;
//      ImageBasicOp::newImage(&inimg);
//      ImageBasicOp::readFromFile("selectshape_in.bmp", inimg);
//      unsigned int areaRank[256*2];
//      LabelIslandSortArea lisa;
//      lisa.setIsHost(1);
//      lisa.setMinArea(100);
//      lisa.setMaxArea(10000000);
//      lisa.setSortFlag(1);
//      lisa.labelIslandSortArea(inimg, areaRank);
      
//      for (int i=0;i<lisa.getLength();i++)
//      {
//           cout<<areaRank[2*i]<<"\t"<<areaRank[2*i+1]<<endl;
//      }

//----Binarize----
    // Image *inimg;
    // ImageBasicOp::newImage(&inimg);
    // ImageBasicOp::readFromFile("okano01.bmp", inimg);
    
    // Image *outimg;
    // ImageBasicOp::newImage(&outimg);
    // ImageBasicOp::makeAtHost(outimg, inimg->width, inimg->height);
    
	// unsigned char threshold = 20;
	// Binarize bi;
	// bi.setThreshold(threshold);
	
	// cout << "AA" << endl;
	// bi.binarize(inimg, outimg);
    
    // ImageBasicOp::copyToHost(outimg);
    // ImageBasicOp::writeToFile("okana02.bmp", outimg);
    
    // ImageBasicOp::deleteImage(inimg);
    // ImageBasicOp::deleteImage(outimg);

    // cout << "BB" << endl;
    
    // return 0;
	
	// --- ConnectRegion ---
//    Image *inimg;
//    ImageBasicOp::newImage(&inimg);
//    ImageBasicOp::readFromFile("okano01.bmp", inimg);
    
//    Image *outimg;
//    ImageBasicOp::newImage(&outimg);
//    ImageBasicOp::makeAtHost(outimg, inimg->width, inimg->height);
    
//    int threshold = 1;
//    int minArea = 1300;
//    int maxArea = 60000;
//    ConnectRegion cr;
//    cr.setThreshold(threshold);
//    cr.setMinArea(minArea);
//    cr.setMaxArea(maxArea);
	
//    cout << "AA" << endl;
//    cr.connectRegion(inimg, outimg);
    
//    ImageBasicOp::copyToHost(outimg);
//    ImageBasicOp::writeToFile("okano02.bmp", outimg);
    
//    ImageBasicOp::deleteImage(inimg);
//    ImageBasicOp::deleteImage(outimg);

//    cout << "BB" << endl;

// ----Flip----
//    int i;
//    cudaEvent_t start, stop;
//    cudaEventCreate(&start);
//    cudaEventCreate(&stop);
//    float runTime;
//
//    Image *inimg;
//    ImageBasicOp::newImage(&inimg);
//    ImageBasicOp::readFromFile("okano01.bmp", inimg);
//
//    Image *outimg;
//    ImageBasicOp::newImage(&outimg);
//    ImageBasicOp::makeAtHost(outimg, inimg->width, inimg->height);
//
//    Flip fi;
//    
//    cout << "123" << endl;
//
//    cudaEventRecord(start, 0);
//    for (i = 0; i < ROUND_NUM; i++) {
//        fi.flipHorizontal(inimg,outimg);
//    }
//    cudaEventRecord(stop, 0);
//    cudaEventSynchronize(stop);
//    cudaEventElapsedTime(&runTime, start, stop);
//
//    cout << "The total H_time is " << (runTime/ROUND_NUM) << " ms" << endl;
//
//    cudaEventRecord(start, 0);
//    for (i = 0; i < ROUND_NUM; i++) {
//        fi.flipVertical(inimg,outimg);
//    }
//    cudaEventRecord(stop, 0);
//    cudaEventSynchronize(stop);
//    cudaEventElapsedTime(&runTime, start, stop);
//
//    cout << "The total V_time is " << (runTime/ROUND_NUM) << " ms" << endl;
//
//    ImageBasicOp::copyToHost(outimg);
//    ImageBasicOp::writeToFile("okano02.bmp", outimg);
//
//    ImageBasicOp::deleteImage(inimg);
//    ImageBasicOp::deleteImage(outimg);
//
//    cout << "BB" << endl;
//    cudaEventDestroy(start);
//    cudaEventDestroy(stop);
//    return 0;
//}
// ----BoundingRect----
//   Image *inimg;
//    ImageBasicOp::newImage(&inimg);
//    ImageBasicOp::readFromFile("00.bmp", inimg);
    
//    unsigned char value = 253;
//    BoundingRect br;
//    Quadrangle qr;
//    DirectedRect dr;
//    br.setValue(value);
//    cout << "AA" << endl;
//    br.boundingRect(inimg, &qr);
	   
 //   cout << "Quadrangle information:" << endl;
//    cout << "angle:"<< qr.angle << endl;
 //   cout << "The four vertex:" << endl;
//    cout << "(" << qr.points[0][0] << "," << qr.points[0][1] << ")" << endl;
//    cout << "(" << qr.points[1][0] << "," << qr.points[1][1] << ")" << endl; 
 //   cout << "(" << qr.points[2][0] << "," << qr.points[2][1] << ")" << endl;
//    cout << "(" << qr.points[3][0] << "," << qr.points[3][1] << ")" << endl;
		
 //   br.boundingRect(inimg, &dr);
//    cout << "DirectedRect information:" << endl;
//    cout << "angle:" << qr.angle << endl;
//    cout << "center point is:" << dr.centerPoint[0] << "," << dr.centerPoint[1] 
 //        << endl;
 //   cout << "length1 is:" << dr.length1 << endl;
//    cout << "length2 is:" << dr.length2 << endl;
    
//    ImageBasicOp::deleteImage(inimg);
//
//    cout << "BB" << endl;

	//----FillUp----
/*
   Image *inimg;
    ImageBasicOp::newImage(&inimg);
    ImageBasicOp::readFromFile("fillup_in.bmp", inimg);
   
    Image *outimg;
    ImageBasicOp::newImage(&outimg);
    ImageBasicOp::makeAtHost(outimg, inimg->width, inimg->height);
    
    unsigned char l = 255;
    unsigned char v = 0;
   int maxw = 15;
   float r = 0.2;
  int stateflag = 0;
    Template *tm;
     
    TemplateBasicOp::newTemplate(&tm);
    TemplateBasicOp::makeAtHost(tm, maxw *maxw);
   
    for (int i = 0; i < maxw *maxw; i++) {
       
       tm->tplData[2 * i] = i % maxw-maxw / 2;
       tm->tplData[2 * i + 1] = i / maxw-maxw / 2;
   }

    FillUp fl;
    fl.setL(l);
    fl.setV(v);
    fl.setMaxw(maxw);
    fl.setR(r);
    fl.setTemplate(tm);
	
    cout << "AA" << endl;
   fl.fillUp(inimg, outimg);
  
    //fl.fillUpAdv(inimg, outimg, &stateflag);
    
    //cout << "stateflag = " << stateflag << endl;
   cout << "BB" << endl;
    
    ImageBasicOp::writeToFile("fillup_out.bmp", outimg);
    
    ImageBasicOp::deleteImage(inimg);
   ImageBasicOp::deleteImage(outimg);

     cout << "CC" << endl;
    
    // return 0;
*/
// ----Moments----
/*
    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    float runTime;
    int round = 1;
    
    Image *inimg;
    ImageBasicOp::newImage(&inimg);
    ImageBasicOp::readFromFile("momentsImage.bmp", inimg);

    Moments mom;
    MomentSet mset;
    mom.setIsconst(false);
    //float centers[2];
    //float angle;
    cudaEventRecord(start, 0);
    int i = 0;
    while(i < round ) {
         cout<<mom.spatialMoments(inimg, &mset)<<endl;
         i++;
    }
    cudaEventRecord(stop, 0);
    cudaEventSynchronize(stop);
    cudaEventElapsedTime(&runTime, start, stop);
    cout << "The total time is " << (runTime/round) << " ms" << endl;

    //cout<<"the centers is "<<centers[0]<<"\t"<<centers[1]<<endl;
    //cout<<"the angle is "<<angle<<endl;
    cout<<mset.m00<<endl;
    cout<<mset.m10<<endl;
    cout<<mset.m01<<endl;
    cout<<mset.m20<<endl;
    cout<<mset.m11<<endl;
    cout<<mset.m02<<endl;
    cout<<mset.m30<<endl;
    cout<<mset.m21<<endl;
    cout<<mset.m12<<endl;
    cout<<mset.m03<<endl;
*/

//// ---- GeometryProperties ----   

//    cudaEvent_t start, stop;
//    cudaEventCreate(&start);
//    cudaEventCreate(&stop);
//    float runTime;
//    int round = 100;
    
//    Image *inimg;
//    ImageBasicOp::newImage(&inimg);
//    ImageBasicOp::readFromFile("momentsImage.bmp", inimg);

//    GeometryProperties geoprop;
//    float length = 0.0f;
    
//    int i = 0;
//    while(i < round ) {
//    cudaEventRecord(start, 0);
//         cout<<geoprop.contourLength(inimg, &length)<<endl;
//         i++;
    
//    cudaEventRecord(stop, 0);
//    cudaEventSynchronize(stop);
//    cudaEventElapsedTime(&runTime, start, stop);
//    cout << "The  time is " << runTime<< " ms" << endl;
//    }
//    cout<<"the contour length is: "<<length<<endl;
    
//    ImageBasicOp::deleteImage(inimg);
//    cudaEventDestroy(start);
//    cudaEventDestroy(stop);

//    //----ImageShrink----
//    int times = 2;
//    ImageShrink shi;
//    shi.setTimes(times);
    
//    cudaEvent_t start, stop;
//    float elapsedTime = 0.0;
    
//    Image *inimg;
//    ImageBasicOp::newImage(&inimg);
//    ImageBasicOp::readFromFile("okano01.bmp", inimg);
    
//    Image *outimg;
//    ImageBasicOp::newImage(&outimg);
//    ImageBasicOp::makeAtHost(outimg, inimg->width / times, 
//                             inimg->height / times);
	
//    cout << "AA" << endl;
    
//    cudaEventCreate(&start);
//    cudaEventCreate(&stop);
//    cout << "Test start!" << endl;
    
//    cudaEventRecord(start, 0);
    
//    //shi.imageshrinkbyDom(inimg, outimg);
//    shi.imageshrinkbyPro(inimg, outimg);
    
//    cudaEventRecord(stop, 0);
//    cudaEventSynchronize(stop);
//    cudaEventElapsedTime(&elapsedTime, start, stop);

//    cout << "Test end!" << endl;
//    cout << "Execute time:" << (float)elapsedTime << "ms" << endl;
    
    
//    cudaEventDestroy(start);
//    cudaEventDestroy(stop);
    
//    ImageBasicOp::copyToHost(outimg);
//    ImageBasicOp::writeToFile("imageshrink_out.bmp", outimg);
    
//    ImageBasicOp::deleteImage(inimg);
//    ImageBasicOp::deleteImage(outimg);

    //-------HoughLine-------//
//    Image *inimg;
//    ImageBasicOp::newImage(&inimg);
//    ImageBasicOp::readFromFile("hough_in4.bmp", inimg); 
    
//    Image *outimg;
//    ImageBasicOp::newImage(&outimg);
//    ImageBasicOp::makeAtHost(outimg, inimg->width, inimg->height);
    
//    cout << "aa" << endl;
//    HoughLine hough;
    
//    double detheta = 1;
//    int threshold = 200;
//    int linenum = 10;
//    int thetasize = 5;
//    int rhosize = 10;
    
    
//    CoordiSet *coor;
//    coor = NULL;
    /*
    CoordiSetBasicOp::newCoordiSet(&coor);
    
    CoordiSetBasicOp::makeAtHost(coor, 1098);    
    
    int k = 0;
    for (int j = 0; j < inimg->height; j++) {
        for (int i = 0; i < inimg->width; i++) {
         
            int index = j * inimg->width + i;
            if (inimg->imgData[index] == 255) {
                coor->tplData[2 * k] =  i;
                coor->tplData[2 * k + 1] = j;  
                k++;
            }
        } 
    }
    */
    /*
    hough.setDeTheta(detheta);
    hough.setThreshold(threshold);
    hough.setLineNum(linenum);
    hough.setThetaSize(thetasize);
    hough.setRhoSize(rhosize);

    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    float runTime;
   
    cudaEventRecord(start, 0); 
    
    hough.houghline(inimg, coor, outimg);  

    cudaEventRecord(stop, 0);
    cudaEventSynchronize(stop);
    cudaEventElapsedTime(&runTime, start, stop);

    cout << "The total time is " << runTime << " ms" << endl;

    ImageBasicOp::copyToHost(outimg);
    ImageBasicOp::writeToFile("hough_out.bmp", outimg);
    
    ImageBasicOp::deleteImage(inimg);
    ImageBasicOp::deleteImage(outimg);
    
    cudaEventDestroy(start);
    cudaEventDestroy(stop);

    cout << "CC" << endl;    
    
    return 0;
    */
     // ---- FeatureVector ----

    // cout << "BB" << endl;

    // Image *inimg;
    // ImageBasicOp::newImage(&inimg);
    // ImageBasicOp::readFromFile("okano01.bmp", inimg);
    // int imgwidth = inimg->width;
    // int imgheight = inimg->height;
    
    ////选取一个 5 * 5 大小的方形区域作为坐标集
    // int width = 5; 
    // CoordiSet *incoordiset;
    // CoordiSetBasicOp::newCoordiSet(&incoordiset);
    // CoordiSetBasicOp::makeAtHost(incoordiset, width * width);

    // int x = imgwidth / 2 - width / 2;
    // int y = imgheight / 2 - width / 2;

    ////初始化坐标集，选取坐标中心
    // for (int i = 0; i < width * width; i++) {
       
       // incoordiset->tplData[2 * i] = x;
       // incoordiset->tplData[2 * i + 1] = y;

       // x++;
       // if ((i + 1) % width == 0){
           // x = imgwidth / 2 - width / 2;
           // y++;
       // }
   // }

   // FeatureVecArray  outfeaturevecarray;
   // FeatureVecArrayBasicOp::makeAtCurrentDevice(&outfeaturevecarray, 
                                               // width * width);
   
   // cout << outfeaturevecarray.count << endl;
   // if (&outfeaturevecarray == NULL)
       // cout << "NULL" << endl;
   // FeatureVecCalc featureveccalc (0.1, 0.1, 4, 2);
   // cudaEvent_t start, stop;
   // cudaEventCreate(&start);
   // cudaEventCreate(&stop);
   // float runTime;
   // cudaEventRecord(start, 0);
   // featureveccalc.calFeatureVector(inimg, incoordiset, &outfeaturevecarray);
   // cudaEventRecord(stop, 0);
   // cudaEventSynchronize(stop);
   // cudaEventElapsedTime(&runTime, start, stop);
   // cout << "The  time is " << runTime<< " ms" << endl;
    
   
    
   // ImageBasicOp::deleteImage(inimg);
   
   // TemplateBasicOp::deleteTemplate(incoordiset);
   // FeatureVecArrayBasicOp::deleteFeatureVecArray(&outfeaturevecarray);
   
   // cout << "CC" << endl;

   // return 0;

// -----SalientRegionDetect-----
/*
    cudaEvent_t start, stop;
    float elapsedTime = 0.0;

    Image *inimg, *outimg;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    ImageBasicOp::newImage(&inimg);
    ImageBasicOp::readFromFile("okano01.bmp", inimg);
    //ImageBasicOp::readFromFile("hist_in.bmp", inimg);
    ImageBasicOp::newImage(&outimg);
    ImageBasicOp::makeAtHost(outimg, inimg->width, inimg->height);

    SalientRegionDetect srd;
    int radius[10] = {5, 8, 13};
    int smoothWidth[10] = {3, 5};
    srd.setHighPercent(0.1);
    srd.setLowPercent(0.3);
    srd.setIterationSM1(1);
    srd.setIsSelect(false);
    srd.setIterationSM2(1);
    srd.setRadius(radius);
    srd.setSmoothWidth(smoothWidth);
    srd.setMeanTpl(3);
    srd.setWeightSM1(1);
    srd.setWeightSM2(0);
    srd.setMinRegion(50);
    srd.setMaxRegion(10000);
    srd.setSaliencyThred(1);
    cout<<"Test start!"<<endl;
    int i = 0;
    while (i < 1) {
        cudaEventRecord(start, 0);

        cout<<srd.saliencyRegionDetect(inimg, outimg)<<endl;
        
        cudaEventRecord(stop, 0);
        cudaEventSynchronize(stop);
        cudaEventElapsedTime(&elapsedTime, start, stop);
        cout<<elapsedTime<<endl;

        i++;
    }
    cout<<"Test end!"<<endl;

    ImageBasicOp::writeToFile("saliencyMap_smooth.bmp", outimg);
    ImageBasicOp::deleteImage(inimg);
    ImageBasicOp::deleteImage(outimg);
    cudaEventDestroy(start);
    cudaEventDestroy(stop);
*/
//---------------RobustEdgeDetection---------------//
//    int i;
//    int k = 3;
//    cudaEvent_t start, stop;
//    cudaEventCreate(&start);
//    cudaEventCreate(&stop);
//    float runTime;

//    Image *inimg;
//    ImageBasicOp::newImage(&inimg);
//    //ImageBasicOp::readFromFile("selectshape_in.bmp", inimg);
//    ImageBasicOp::readFromFile("hist_in.bmp", inimg);
//    //ImageBasicOp::readFromFile("1.bmp", inimg);

//    Image *outimg;
//    ImageBasicOp::newImage(&outimg);
//    ImageBasicOp::makeAtHost(outimg, inimg->width, inimg->height);

//    RobustEdgeDetection R;
    
//    R.setSearchScope(3);

//    cout << "123" << endl;

//    cudaEventRecord(start, 0);
//    //int errcode;
//    for (i = 0; i < ROUND_NUM; i++) {
//        R.detectEdgeSA(k,inimg,outimg,NULL);
//    }
//    cudaEventRecord(stop, 0);
//    cudaEventSynchronize(stop);
//    cudaEventElapsedTime(&runTime, start, stop);

//    cout << "The total H_time is " << (runTime/ROUND_NUM) << " ms" << endl;

////    cudaEventRecord(start, 0);
////    for (i = 0; i < ROUND_NUM; i++) {
////        f1.detectEdgeFV(inimg,outimg);
////    }
////    cudaEventRecord(stop, 0);
////    cudaEventSynchronize(stop);
////    cudaEventElapsedTime(&runTime, start, stop);
////
////    cout << "The total V_time is " << (runTime/ROUND_NUM) << " ms" << endl;
////
//    ImageBasicOp::copyToHost(outimg);
//    //ImageBasicOp::writeToFile("selectshape_out.bmp", outimg);
//    ImageBasicOp::writeToFile("hist_ref.bmp", outimg);
//    //ImageBasicOp::writeToFile("2.bmp", outimg);

//    ImageBasicOp::deleteImage(inimg);
//    ImageBasicOp::deleteImage(outimg);

//    cout << "BB" << endl;
//    cudaEventDestroy(start);
//    cudaEventDestroy(stop);
//    cout << "CC" << endl;

//-----------  OtsuBinarize  -------------
//     cudaEvent_t start, stop;
//     cudaEventCreate(&start);
//     cudaEventCreate(&stop);
//     float runTime;
//     Image *inimg;
//     ImageBasicOp::newImage(&inimg);
//     ImageBasicOp::readFromFile("hist_in.bmp", inimg);
    
//     Image *outimg;
//     ImageBasicOp::newImage(&outimg);
//     ImageBasicOp::makeAtHost(outimg, inimg->width, inimg->height);
    
//     OtsuBinarize ob;
//     cout << "AA" << endl;
//     cudaEventRecord(start, 0);
         
//     ob.otsuBinarize(inimg, outimg);
    
//     cudaEventRecord(stop, 0);
//     cudaEventSynchronize(stop);
//     cudaEventElapsedTime(&runTime, start, stop);

     
//     cout << "The total H_time is " << (runTime/ROUND_NUM) << " ms" << endl;

//     ImageBasicOp::copyToHost(outimg);
//     ImageBasicOp::writeToFile("OtsuBinarize_out.bmp", outimg);
     
    
//     ImageBasicOp::deleteImage(inimg);
     
//     ImageBasicOp::deleteImage(outimg);
/*
//-------Scan-------
    unsigned int num_elements = 4096;
    const unsigned int mem_size = sizeof(float) * num_elements;

    // allocate host memory to store the input data
    float *inarray = (float*)malloc(mem_size);
    float *outarray = (float*)malloc(mem_size);
  
    for( unsigned int i = 0; i < num_elements; ++i) 
    {
        inarray[i] = 3;
        outarray[i] = 4;
    }

    ScanArray sa;
    sa.setScanType(BETTER_SCAN);

    bool inhost, outhost;
    inhost = true;
    outhost = true;
    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    float runTime;
   
    cudaEventRecord(start, 0);
    int i = 0;
    while(i < ROUND_NUM ) {
        sa.scanArray(inarray, outarray, num_elements, inhost, outhost);
        i++;
    }
    cudaEventRecord(stop, 0);
    cudaEventSynchronize(stop);
    cudaEventElapsedTime(&runTime, start, stop);
   
    for( unsigned int i = 0; i < num_elements; ++i) 
    {
        cout << "the outarray " << i << " is " << outarray[i] << endl;
    }
    
    cout << "The  time is " << (runTime/ROUND_NUM) << " ms" << endl;
   
    cout << "CC" << endl;

    return 0;
*/
//-------ScanLargeArray-------
//    unsigned int num_elements = 2048;
//    const unsigned int mem_size = sizeof(float) * num_elements;

//    // allocate host memory to store the input data
//    float *inarray = (float*)malloc(mem_size);
//    float *outarray = (float*)malloc(mem_size);
  
//    for( unsigned int i = 0; i < num_elements; ++i) 
//    {
//        inarray[i] = 2;
//        outarray[i] = 0;
//    }

//    ScanLargeArray sla;
//    bool inhost, outhost;
//    inhost = true;
//    outhost = true;
//    cudaEvent_t start, stop;
//    cudaEventCreate(&start);
//    cudaEventCreate(&stop);
//    float runTime;
     
//    cout << "1111" << endl;
//    cudaEventRecord(start, 0);
//    int i = 0;
//    while(i < ROUND_NUM ) {
//        sla.scanLargeArray(inarray, outarray, num_elements, inhost, outhost);
//        i++;
//    }
//    cudaEventRecord(stop, 0);
//    cudaEventSynchronize(stop);
//    cudaEventElapsedTime(&runTime, start, stop);
   
//    for( unsigned int i = 0; i < num_elements; ++i) 
//    {
//        cout << "the outarray " << i << " is " << outarray[i] << endl;
//    }
    
//    cout << "The  time is " << (runTime/ROUND_NUM) << " ms" << endl;
//    cout << "CC" << endl;
//    return 0;

//------------------Thinning-----------------------//
    Thinning thin;
    
    CoordiSet *incst;
    CoordiSet *outcst;
    int num = 1000;
    int errcode;
    CoordiSetBasicOp::newCoordiSet(&incst);
    CoordiSetBasicOp::newCoordiSet(&outcst);
    errcode =CoordiSetBasicOp::makeAtHost(incst, num);
    errcode =CoordiSetBasicOp::makeAtHost(outcst, num);
    for (int i = 0; i < num; i += 1)
    {
        incst->tplData[2 * i] = 10;
        incst->tplData[2 * i + 1] = (i + 1) % 1000;
       
        
       

    }
    
    
    
    if (errcode != NO_ERROR) 
    {
        cout << "error: " << errcode << endl;
        return 0; 
    }

//    cudaEvent_t start, stop;
//    cudaEventCreate(&start);
//    cudaEventCreate(&stop);
//    float runTime;
//    for (int i = 0; i < 100; i++) {
//        cudaEventRecord(start, 0);
    
       cout<<thin.thinMatlabLike(incst, outcst)<<endl;
     
//        cudaEventRecord(stop, 0);
//        cudaEventSynchronize(stop);
//        cudaEventElapsedTime(&runTime, start, stop);
//        cout << "The total H_time is " << (runTime) << " ms" << endl;
//    }
    
    CoordiSetBasicOp::deleteCoordiSet(incst);
    CoordiSetBasicOp::deleteCoordiSet(outcst);


    /*Image *inimg;
//    ImageBasicOp::newImage(&inimg);
    int errcode;
    errcode = ImageBasicOp::readFromFile("thinImg.bmp", inimg);
    if (errcode != NO_ERROR) 
    {
        cout << "error: " << errcode << endl;
        return 0; 
    }
    
    Image *outimg;
    ImageBasicOp::newImage(&outimg);
    ImageBasicOp::makeAtHost(outimg, inimg->width, inimg->height);
    
    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    float runTime;
    for (int i = 0; i < 1; i++) {
		cudaEventRecord(start, 0);
	
		cout<<thin.thinMatlabLike(inimg, outimg)<<endl;
	
		cudaEventRecord(stop, 0);
		cudaEventSynchronize(stop);
		cudaEventElapsedTime(&runTime, start, stop);
		cout << "The total H_time is " << (runTime) << " ms" << endl;
    }

    ImageBasicOp::copyToHost(outimg);
    
    ImageBasicOp::writeToFile("thinningOut.bmp", outimg);  
    ImageBasicOp::deleteImage(inimg);
    ImageBasicOp::deleteImage(outimg);*/
    
    return 0;
}

