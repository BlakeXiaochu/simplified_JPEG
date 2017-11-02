#include "mex.h"

typedef unsigned char uint8;

void decodeAC(uint8*  codeAC, int codeLen, int* decodeTree, int* quantAC)
{
    int decodeNum = 0;      //记录一个block中已解码的分量数
    int decodeBlock = 0;    //记录已解码的block数
    int pos = 0;            //记录解码位置
    int node = 0;           //记录二叉解码树节点
    
    while(pos < (codeLen - 1))
    {
        //到达编码节点
        if(decodeTree[node] != -1)
        {
            int runSize = decodeTree[node];
            
            //EOB
            if(runSize == 0)
            {
                for(int i = decodeNum; i < 63; i++)
                {
                    quantAC[decodeBlock * 63 + i] = 0;
                }
                decodeBlock += 1;
                decodeNum = 0;
            }
            //ZRL
            else if(runSize == 161)
            {
                for(int i = 0; i < 16; i++)
                {
                    quantAC[decodeBlock * 63 + decodeNum + i] = 0;
                }
                decodeNum += 16;
            }
            //others
            else
            {
                int Run = (runSize - 1) / 10;
                int Size = ((runSize - 1) % 10) + 1;
                
                //写入0
                for(int i = 0; i < Run; i++)
                {
                    quantAC[decodeBlock * 63 + decodeNum + i] = 0;
                }
                decodeNum += Run;
                
                //写入非0值
                //将二进制幅度转化为十进制
                int Amp = 0;
                uint8* amp = new uint8[Size];
                for(int i = 0; i < Size; i++)
                    amp[i] = codeAC[pos + i];
                
                int flag = (amp[0] == 0) ? -1 : 1;      //判断幅度的正负
                int wt = 1 << (Size - 1);               //二进制位权
                for(int i = 0; i < Size; i++)
                {
                   Amp += ((flag == -1) ? (- !amp[i] * wt) : (amp[i]*wt));
                   wt /= 2;
                }
                
                delete []amp;
                quantAC[decodeBlock * 63 + decodeNum] = Amp;
                decodeNum += 1;
                pos += Size;
            }
            node = 0;
            continue;
        }

        //未到达编码节点，继续往下分叉
        if(codeAC[pos] == 1) {node = node * 2 + 2; pos += 1;}
        else {node = node * 2 + 1; pos += 1;}
    }
}

void mexFunction(int nlhs, mxArray* plhs[], int nrhs, const mxArray* prhs[])
{
    int blockNum;
    blockNum = *( mxGetPr(prhs[0]) );
    //blockNum = *( (int*)mxGetData(prhs[0]) );
    int codeLen = mxGetN(prhs[1]);
    uint8* codeAC;
    codeAC = (uint8*)mxGetData(prhs[1]);
    int* decodeTree;
    decodeTree = (int*)mxGetData(prhs[2]);
    
    //解码，结果保存在quantAC中
    plhs[0] = mxCreateNumericMatrix(63, blockNum, mxINT32_CLASS, mxREAL);   //cpp与matlab中二维数组互为转置
    int* quantAC = (int*)mxGetData(plhs[0]);
    decodeAC(codeAC, codeLen, decodeTree, quantAC);
}