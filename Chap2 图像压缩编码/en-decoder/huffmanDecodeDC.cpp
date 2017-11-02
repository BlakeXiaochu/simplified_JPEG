#include "mex.h"
#include <stdio.h>

typedef unsigned char uint8;

void decodeDC(uint8* codeDC, int codeLen, int* decodeTree, int* diffDC)
{   
    int decodeNum = 0;      //记录已解码的分量数
    int pos = 0;            //记录解码位置
    int node = 0;           //记录二叉解码树节点
    
    while(pos < (codeLen - 1))
    {
        //到达编码节点
        if(decodeTree[node] != -1)
        {
            int category = decodeTree[node];
            //category0
            if(category == 0)
            {
                diffDC[decodeNum] = 0;
                pos += 1;
            }
            //others
            else
            {
                //将二进制幅度转化为十进制
                int Mag = 0;
                uint8* mag = new uint8[category];
                for(int i = 0; i < category; i++)
                    mag[i] = codeDC[pos + i];
                
                int flag = (mag[0] == 0) ? -1 : 1;      //判断幅度的正负
                int wt = 1 << (category - 1);           //二进制位权
                for(int i = 0; i < category; i++)
                {
                   Mag += ((flag == -1) ? (- !mag[i] * wt) : (mag[i]*wt));
                   wt /= 2;
                }
                
                delete []mag;
                diffDC[decodeNum] = Mag;
                pos += category;
            }
            node = 0;
            decodeNum += 1;
            continue;
        }

        //未到达编码节点，继续往下分叉
        if(codeDC[pos] == 1) {node = node * 2 + 2; pos += 1;}
        else {node = node * 2 + 1; pos += 1;}
    }
}

void mexFunction(int nlhs, mxArray* plhs[], int nrhs, const mxArray* prhs[])
{
    int blockNum;
    blockNum = *( mxGetPr(prhs[0]) );
    //blockNum = *( (int*)mxGetData(prhs[0]) );
    int codeLen = mxGetN(prhs[1]);
    uint8* codeDC;
    codeDC = (uint8*)mxGetData(prhs[1]);
    int* decodeTree;
    decodeTree = (int*)mxGetData(prhs[2]);
    
    //解码，结果保存在diffDC中
    plhs[0] = mxCreateNumericMatrix(1, blockNum, mxINT32_CLASS, mxREAL);
    int* diffDC = (int*)mxGetData(plhs[0]);
    decodeDC(codeDC, codeLen, decodeTree, diffDC);
}