#include "includes.h"



const uint8_t pwda[] ={};
const uint8_t pwdb[] ={};
const uint8_t pwdc[] ={};
const uint8_t  Math_2N_Table[] = {0x1,0x2,0x4,0x8,0x10,0x20,0x40,0x80};

unsigned char out[512];
u16 irinbuff[1000];					//学习脉宽buff
unsigned char pkg_data[100];	//智能匹配解码数据包
unsigned char out[512];			//脉宽压缩包BUFF


char CodeBufStr[256]={"BC,81,86,14,55,D1,87,B1,A5,88,39,4C,43,5B,06,34,51,8E,A8,B1,12,2B,A2,68,D7,14,A4,45,42,54,2B,C0,02,79,F3,67,E6,0D,DA,08,B3,F2"};
uint8_t ConvCodeHex[256];
/*
*********************************************************************************************************
*	函 数 名: Api_Ir_PwmCarrierControl
*	功能说明: pwm载波使能输出 
*	形    参：_NewState 输出控制
*	返 回 值: 无
*********************************************************************************************************
*/

void Api_Ir_PwmCarrierControl(OUT_PUT_STAT _NewState)
{
   if (_NewState != CLOSE)
   {
     /* Enable the TIM Counter */
     TIM3->CR1 |= TIM_CR1_CEN;
   }
   else
   {
     /* Disable the TIM Counter */
     TIM3->CNT=0;
     TIM3->CR1 &= (uint16_t)~TIM_CR1_CEN;
   }
}

/*
*********************************************************************************************************
*	函 数 名: Api_Ir_CarrierSend
*	功能说明: pwm载波发送 
*	形    参：_Hval _Lval 载波发送时间
*	返 回 值: 无
*********************************************************************************************************
*/
void	Api_Ir_CarrierSend(uint8_t _Hval,uint8_t _Lval)
{			
   
		unsigned short Time;
    
    Api_Ir_PwmCarrierControl(CLOSE);
		Time	= (((uint16_t)_Hval<<8) + (uint16_t)_Lval);
    if(Time>200){Time=Time-10;}
    
    __set_PRIMASK(1);     /* 关中断 */
    Api_Ir_PwmCarrierControl(OPEN);
    Api_Time_DelayUs(Time);
    Api_Ir_PwmCarrierControl(CLOSE);
    
    __set_PRIMASK(0);     /* 开中断 */
}
/*
*********************************************************************************************************
*	函 数 名: Api_Ir_SpaceSend
*	功能说明: pwm载波关闭
*	形    参：_Hval _Lval 载波关闭时间
*	返 回 值: 无
*********************************************************************************************************
*/
void Api_Ir_SpaceSend(uint8_t _Hval,uint8_t _Lval)
{
    unsigned short Time;
    __set_PRIMASK(1);     /* 开中断 */
    Api_Ir_PwmCarrierControl(CLOSE);
    Time  = (((uint16_t)_Hval<<8) + (uint16_t)_Lval);
    if(Time>200){Time=Time-80;}
    Api_Ir_PwmCarrierControl(CLOSE);
    Api_Time_DelayUs(Time);
    __set_PRIMASK(0);     /* 开中断 */
}
/*
*********************************************************************************************************
*	函 数 名: Api_Ir_ConvCode
*	功能说明: 红外解码
*	形    参：_SrcDat数据源，_Len 数据长度
*	返 回 值: 无
*********************************************************************************************************
*/
void Api_Ir_ConvCode(uint8_t *_SrcDat,uint16_t _Len)
{
 
}

/*
*********************************************************************************************************
*	函 数 名: Api_Ir_DataSend
*	功能说明: 红外数据发送
*	形    参：红外数据
*	返 回 值: 无
*********************************************************************************************************
*/
void Api_Ir_DataSend(uint8_t *_Data)
{
    unsigned short time_H;
    unsigned short time_L;
    unsigned short pbuf  = 0;
    unsigned char cnt = 15;
    unsigned char chr = _Data[15];
    unsigned char bytes = 0;
    unsigned short bits = 0;
    unsigned char Bytet;
    unsigned char Bitt;
    unsigned char j;
    unsigned short i;

    SetPWMFreq(_Data[6]);   //设置载波频率
    
    while (chr != 0) 
    {
      switch (chr)
      {
        case 0xC1:
          Api_Ir_CarrierSend(_Data[cnt+1],_Data[cnt+2]);
          cnt += 3;
        break;
        
        case 0xC2:
          for(j=0;j<_Data[cnt+1];j++)
          Api_Ir_SpaceSend(0xFF,0xF0);
          Api_Ir_SpaceSend(_Data[cnt+2],_Data[cnt+3]);
          cnt += 4;
        break;

        case 0xC3:
        {
          bits = ((unsigned short)(_Data[cnt + 1]) << 8) + (unsigned short)(_Data[cnt + 2]);
          for(i=0;i<bits;i++)
          {
            if((_Data[5] & 0xf) == 0x00) 
            {
              Bytet = i / 8;
              Bitt = i % 8;
            }
            else
            {
              Bytet = i / 8;
              Bitt = (~(i % 8)) & 0x7;
            }

            Bitt = Math_2N_Table[Bitt];

            if((_Data[cnt+3+Bytet] & Bitt) == 0)
            {
              if((_Data[7] & 0x80) == 0x80)
              {
                Api_Ir_CarrierSend(_Data[7] & 0x7F,_Data[8]);
                Api_Ir_SpaceSend(_Data[9] & 0x7F,_Data[10]);
              }
              else
              {
                Api_Ir_SpaceSend(_Data[7] & 0x7F,_Data[8]);
                Api_Ir_CarrierSend(_Data[9] & 0x7F,_Data[10]);
              }
            }
            else 
            {
              if((_Data[7] & 0x80) == 0x80)
              {
                Api_Ir_CarrierSend(_Data[11] & 0x7F,_Data[12]);
                Api_Ir_SpaceSend(_Data[13] & 0x7F,_Data[14]);
              }
              else
              {
                Api_Ir_SpaceSend(_Data[11] & 0x7F,_Data[12]);
                Api_Ir_CarrierSend(_Data[13] & 0x7F,_Data[14]);
              }
            }
          }

          if((_Data[5] & 0xF0) == 0)
            Api_Ir_CarrierSend(_Data[7] & 0x7F,_Data[8]);
          
          bytes = bits / 8;
          if (bits % 8 !=0)
            bytes = bytes+1;
          cnt = (cnt + bytes + 3);

        }
        break;

        default:
        taskEXIT_CRITICAL();
        //要发送的红外数据格式不正确
        return;
      }
      chr = _Data[cnt];
    }
    taskEXIT_CRITICAL();
    return;
}





//======================================================================================
// 红外编码，从时间脉宽变成按键码,用于红外遥控智能匹配，把pkg_data 上报服务器返回遥控器ID
//入口 ir_data
//     wlen : ir_data长度、
//出口 pkg_data
//======================================================================================
int Check_PPM(unsigned short *ir_data, unsigned short wlen, unsigned char *pkg_data)
{
  unsigned short i,j,k=0,n=0,cnt = 0, Complement=0;
	unsigned short *str = ir_data;
	unsigned short ir_low, ir_high;
	unsigned short ir_h_data[100];// = malloc(sizeof(unsigned short)*100);
	unsigned short ir_l_data[100];// = malloc(sizeof(unsigned short)*100);
	 
	unsigned short ir_h_len[100];// = malloc(sizeof(unsigned short)*100);
	unsigned short ir_l_len[100];// = malloc(sizeof(unsigned short)*100);
	
	 
//	if(ir_h_data==NULL || ir_l_data==NULL ||\
//		 ir_h_len==NULL || ir_l_len==NULL)
//	{
//		free(ir_l_data);
//		free(ir_h_data);
//		free(ir_h_len);
//		free(ir_l_len);
//		return 0;
//	}
	for(j=0; j<100; j++)
		ir_h_data[j] = 0;
	for(j=0; j<100; j++)
		ir_l_data[j] = 0;
	for(j=0; j<100; j++)
		ir_h_len[j] = 0;
	for(j=0; j<100; j++)
		ir_l_len[j] = 0;
	
	for(i=0;i<wlen-1;i++)
	{
		for(int j=i+1;j<wlen;j++)
		{
			float brt = (float)str[i]/str[j];
			if(brt>1)
			{
				brt=1/brt;
			}
			if(brt>0.7)
			{
				str[j]=str[i];
			}
		}
	}
	
	 for(i=0; i<wlen-1; i++)
	{
		if(i%2 == 0)
		{
			for(j=0; j<cnt; j++)
			 if( ir_h_data[j] == str[i] )
				break;

			if( j == cnt )
			{
					ir_h_data[cnt++] = str[i];
					ir_h_len[cnt-1]++;
			}
			else
			{
					ir_h_len[j]++;	//????????????
			}
		}
	}
	
	for(i=0; i<cnt-1; i++)		//??????????
	 for(j=0; j<cnt-1-i; j++)
	 {
		 unsigned short t;

		 if( ir_h_len[j] < ir_h_len[j+1] )
		 {
			 t = ir_h_len[j];
			 ir_h_len[j] = ir_h_len[j+1];
			 ir_h_len[j+1] = t;
		 
			 t = ir_h_data[j];
			 ir_h_data[j] = ir_h_data[j+1];
			 ir_h_data[j+1] = t;
		 }
	 }
	 
	cnt = 0;

	for(i=0; i<wlen-1; i++)
	{
		if(i%2 != 0)
		{
			for(j=0; j<cnt; j++)
			 if( ir_l_data[j] == str[i] )
				break;

			 
			if( j == cnt )
			{
					ir_l_data[cnt++] = str[i];
					ir_l_len[cnt-1]++;
			}
			else
			{
					ir_l_len[j]++;  //?????????
			}
		}
	}

	for(i=0; i<cnt-1; i++)		//???????????
	 for(j=0; j<cnt-1-i; j++)
	 {
		 unsigned short t;

		 if( ir_l_len[j] < ir_l_len[j+1] )
		 {
			 t = ir_l_len[j];
			 ir_l_len[j] = ir_l_len[j+1];
			 ir_l_len[j+1] = t;
		 
			 t = ir_l_data[j];
			 ir_l_data[j] = ir_l_data[j+1];
			 ir_l_data[j+1] = t;
		 }
	 }
	 
	unsigned short str_new[1000];
  //unsigned short *str_new = malloc(sizeof(unsigned short)*wlen);
	unsigned short count = 0;
	unsigned short ir_revice_0;
	unsigned short ir_revice_1;
	ir_revice_0 = ir_l_data[0] + ir_h_data[0];
	ir_revice_1 = ir_l_data[1] + ir_h_data[0];
	for(i=0; i<wlen; ){
		unsigned short mark = 0;
		/*** ????????????? ????**/
		if(((str[i]+str[i+1]) != ir_revice_0) && ((str[i]+str[i+1]) != ir_revice_1)){
			  mark = 1;
			
					
			/*** ????????????????,??????????????????***/					
			if( (str[i] != ir_h_data[0]) && (str[i+1] != ir_h_data[0])){
				
								if(count % 8 != 0){
											Complement = 8 - (count % 8);    //????
											for(j = 0; j < Complement; j++){
													str_new[count++] = ir_h_data[0];
											}
								}
						i += 2;
				}
			else if((str[i] == ir_h_data[0]) && (str[i+1] != ir_h_data[0])){
				
								if(count % 8 != 0){
											Complement = 8 - (count % 8);    //????
											for(j = 0; j < Complement; j++){
													str_new[count++] = ir_h_data[0];
											}
								}
					i +=2;
			}
				/*** ???????????,??????????????????***/
			else if((str[i] != ir_h_data[0]) && (str[i+1] == ir_h_data[0])){
				
							if(count % 8 != 0){
											Complement = 8 - (count % 8);    //????
											for(j = 0; j < Complement; j++){
													str_new[count++] = ir_h_data[0];
											}
							}
					i += 1;
			}
			else{
				i +=1;
			}
//			else if( (str[i+1] != ir_l_data[0]) || (str[i+1] != ir_l_data[1]) ){
//					mark = 1;
//					i += 2;
//			}
		}
		if(mark == 0){	
			//str_new[count] = str[i];
			str_new[count] = str[i+1];
			i += 2;
			count += 1; 
		}
	}
	
	if(ir_l_data[0] > (ir_h_data[0]*2))
	{
		ir_low = ir_l_data[0];
		ir_high = ir_l_data[1];
	}
	else
	{
		ir_low = ir_l_data[1];
		ir_high = ir_l_data[0];
	}

	cnt = 0;
//** ????????MSB??
//		unsigned short remainder = 0;
//	remainder = count % 8;
//	for(i = 0,n = 0; i< (count- (count % 8)); i++){
//		cnt += 1;
//		if(str_new[i] == ir_low){
//				pkg_data[k] |= 1<<n;
//		}
//		n += 1;
//		if(n >= 8){
//			n = 0;
//			k += 1;
//		}
//	}
//		for(i = 0; i < 8; i++){
//			if(i < count%8){
//				if(str_new[count-remainder+i] == ir_low){
//							if(i == 0){
//									pkg_data[k] |= 1;
//							}
//							else	
//								pkg_data[k] <<= 1;
//								pkg_data[k] |= 1;
//				}
//				else if(str_new[count-remainder+i] == 0 || str_new[count-remainder+i] == ir_high){
//							pkg_data[k] <<= 1;
//				}	
//			}
//			else pkg_data[k] <<= 1;
//		}
//		k += 1;
	for(i = 0,n = 0; i<count; i++){
		cnt += 1;
		if(str_new[i] == ir_low){
			pkg_data[k] |= 1<<n;
		}
		n += 1;
		if(n >= 8){
			n = 0;
			k += 1;
		}
	}
	
	if(n % 8 != 0){
			k += 1;
	}
	
//	free(ir_l_data);
//	free(ir_h_data);
//	free(ir_h_len);
//	free(ir_l_len);
	return k;
}

//=============================================================================
// 发送函数调用例子

void Api_Ir_Send(void)
{
   uint16_t len=0,i=0;
	  len= Api_StringToHex((uint8_t *)CodeBufStr,ConvCodeHex,strlen(CodeBufStr));
		Api_Ir_ConvCode(ConvCodeHex,len );
    for(i=0;i<len;i++)
      printf("%02x ",ConvCodeHex[i]);
    Api_Ir_DataSend(ConvCodeHex);
}

//=============================================================================
//作用：将接收到的红外脉宽进行简单压缩
//入口 wawa 接收到的红外脉宽数组 inbuff[1000]
//     wlen wawa 长度
//出口 out  压缩后的数据
//=============================================================================
int encode(unsigned short *wava,unsigned short wlen,unsigned char *out)
{
	wlen--;
	//unsigned short *dump = malloc(sizeof(unsigned short)*wlen);
	//unsigned char *bitstr = malloc(sizeof(unsigned char)*wlen);
  unsigned short dump[1000];
	unsigned char bitstr[1000];
	unsigned short i=0,j=0,k=0,cnt=0;

	for(i=0; i<wlen; i++)
	{
		dump[i] = 0x00;
	}

	for(i=0; i<wlen; i++)
	{
		bitstr[i] = 0x00;
	}

//	fcycle = round(1);
//	for (i = 1; i < wlen; i++) {
//		int ws = round(wava[i]*fcycle);
//		wava[i] = ws;
//	}

	for (i = 0; i < wlen -1 ; i++) {
		for (int j = i + 1; j < wlen ; j++) {
			float brt = (float) wava[i] / wava[j];
			if (brt > 1) {
				brt = 1 / brt;
			}
			if (brt > 0.65) {
				wava[j] = wava[i];
			}
		}
	}

	for (i = 0; i < wlen ; i++) {
		unsigned char finds = 0;
		for (j = 0; j < cnt; j++) {
			if(wava[i] == dump[j]){
				finds = 1;
				break;
			}
		}

		if (finds == 0) {
			dump[cnt] = wava[i];
			cnt++;
		}
	}

	cnt--;

	for (i = 0; i <= cnt - 1; i++) {
		for (j = i + 1; j <= cnt; j++) {
			if ( dump[i] > dump[j] ) {
				unsigned short tmp = dump[i];
				dump[i] = dump[j];
				dump[j] = tmp;
			}
		}
	}

	for (i = 0; i < wlen; i++) {
		for (j = 0; j <= cnt; j++) {
			if(wava[i] == dump[j]){
				bitstr[k] = j+1; //????bitstr ???  <= cnt,cnt???? wava????????,?? cnt <= wlen
				k++;
				break;
			}
		}

		if (j == cnt + 1) {
		//	printf("abc No Samples ");
		}
	}

	int bcnt = 0;
	for (i = 0; i < 16; i++) {
		long dumpi = dump[i];
		int samps = (int) dumpi / 100;
		out[bcnt] = samps/256;
		out[bcnt + 1] = samps%256;
		bcnt += 2;
	}

	unsigned short bits = k;
	out[bcnt] = bits / 256;
	out[bcnt + 1] = bits % 256;
	bcnt += 2;

	for (i = 0; i < bits;) {
		unsigned char bi = bitstr[i];
		unsigned char bi1 =bitstr[i + 1];
    out[bcnt]=bi*16+bi1;
		if(out[bcnt] == 0){
			break;
		}
		bcnt++;
		i+=2;
	}
//free(bitstr);
//	free(dump);
	return bcnt+1;
}

//=============================================================================
void Api_Ir_StudyDataSend(uint8_t *_Data,u16 len)
{
 u16 pause;
 u8 pauseH,pauseL;
	decode();
	
 for (i=0;i<=len;i++)
 {
 		pause=_Data(i);
 		pauseH=pause/256;
 		pauseL=pause%256;
 	if (i%2==0) 		
 		Api_Ir_CarrierSend(pauseH,pauseL);
  else
    Api_Ir_SpaceSend(pauseH,pauseL);		
 }
}