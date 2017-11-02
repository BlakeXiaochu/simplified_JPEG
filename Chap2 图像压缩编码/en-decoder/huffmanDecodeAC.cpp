#include "mex.h"

typedef unsigned char uint8;

void decodeAC(uint8*  codeAC, int codeLen, int* decodeTree, int* quantAC)
{
    int decodeNum = 0;      //��¼һ��block���ѽ���ķ�����
    int decodeBlock = 0;    //��¼�ѽ����block��
    int pos = 0;            //��¼����λ��
    int node = 0;           //��¼����������ڵ�
    
    while(pos < (codeLen - 1))
    {
        //�������ڵ�
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
                
                //д��0
                for(int i = 0; i < Run; i++)
                {
                    quantAC[decodeBlock * 63 + decodeNum + i] = 0;
                }
                decodeNum += Run;
                
                //д���0ֵ
                //�������Ʒ���ת��Ϊʮ����
                int Amp = 0;
                uint8* amp = new uint8[Size];
                for(int i = 0; i < Size; i++)
                    amp[i] = codeAC[pos + i];
                
                int flag = (amp[0] == 0) ? -1 : 1;      //�жϷ��ȵ�����
                int wt = 1 << (Size - 1);               //������λȨ
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

        //δ�������ڵ㣬�������·ֲ�
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
    
    //���룬���������quantAC��
    plhs[0] = mxCreateNumericMatrix(63, blockNum, mxINT32_CLASS, mxREAL);   //cpp��matlab�ж�ά���黥Ϊת��
    int* quantAC = (int*)mxGetData(plhs[0]);
    decodeAC(codeAC, codeLen, decodeTree, quantAC);
}