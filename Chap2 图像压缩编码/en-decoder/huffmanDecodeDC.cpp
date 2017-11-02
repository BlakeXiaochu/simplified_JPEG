#include "mex.h"
#include <stdio.h>

typedef unsigned char uint8;

void decodeDC(uint8* codeDC, int codeLen, int* decodeTree, int* diffDC)
{   
    int decodeNum = 0;      //��¼�ѽ���ķ�����
    int pos = 0;            //��¼����λ��
    int node = 0;           //��¼����������ڵ�
    
    while(pos < (codeLen - 1))
    {
        //�������ڵ�
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
                //�������Ʒ���ת��Ϊʮ����
                int Mag = 0;
                uint8* mag = new uint8[category];
                for(int i = 0; i < category; i++)
                    mag[i] = codeDC[pos + i];
                
                int flag = (mag[0] == 0) ? -1 : 1;      //�жϷ��ȵ�����
                int wt = 1 << (category - 1);           //������λȨ
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

        //δ�������ڵ㣬�������·ֲ�
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
    
    //���룬���������diffDC��
    plhs[0] = mxCreateNumericMatrix(1, blockNum, mxINT32_CLASS, mxREAL);
    int* diffDC = (int*)mxGetData(plhs[0]);
    decodeDC(codeDC, codeLen, decodeTree, diffDC);
}