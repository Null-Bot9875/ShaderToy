Shader "Unlit/01Rain"
{   
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

        //Custom
        _Size ("Size",float) = 1
        _T ("Time",float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;


            float _Size,_T;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                /*目前还不理解的点
                1、如何切割成多个小的box的？ ->把纹理坐标(uv)乘以一个较大的值（_Size * aspect），再计算出其小数部分（frac(uv)）。这样，纹理坐标空间就被分割成了许多小的坐标系，因此得到了多个水滴的效果。
                2、trail为什么会生成一串？      trailPos.y = (frac(trailPos.y * 8) -.5)/8; 类似上述切割小box的部分，先把trail的位置信息乘以一个很大的值，然后在除以一个值，得到一串水珠。
                3、水珠怎么产生弧度的？
                4、水滴之下不产生水痕是怎么做的？

                时间轴25 :34
                ref:https://www.youtube.com/watch?v=EBrAdahFtuo
                */


                //Unity内置的时间
                float t = _Time.y*0 + _T;

                fixed4 col = 0;

                float2 aspect = float2(2,1);
                //i输出的uv坐标是什么？ ->纹理坐标
                float2 uv = i.uv * _Size * aspect; // (0,0) -> (Size*2 , Size *1) 的范围
                //让y持续下降抵消sin函数的上升
                uv.y += t *.25; 
                //frac是什么 ->frac函数返回标量或每个矢量中各分量的小数部分。
                /*
                So
                frac(0.5) = 0.5
                frac(1.25) = 0.25
                frac(100.75) = 0.75
                frac(9.1) = 0.1
                */

                float2 gv = frac(uv) -.5; // 把原点放到中心 
                
                float w = i.uv.y * 10;
                float x = sin(3*w) * pow(sin(w),6)*.45;
                float y = -sin(t + sin(t + sin(t) *.5))*.45;
                y -= (gv.x -x) *(gv.x -x);
                float2 dropPos = (gv-float2(x,y))/aspect;
                //smoothstep是什么？ -> 线性映射到一个范围内的值 https://blog.csdn.net/woodengm/article/details/125597326
                //length是什么？ -> 	Returns the length of the vector v. 返回向量长度
                float drop = smoothstep(.05,.03,length(dropPos));
/*

                //减去之前的增量来取消移动
                float2 trailPos = (gv-float2(x,t *.25)); 
                trailPos.y = (frac(trailPos.y * 8) -.5)/8;
                float trail = smoothstep(.03,.01,length(trailPos));
                //水滴之下不产生水痕
                trail *= smoothstep(-.05,.05, dropPos.y);
                //水痕消失
                trail *= smoothstep(0.5,y, gv.y);

                col += trail;
  */
                col += drop;

                //辅助线
                if(gv.x > .48 || gv.y > .49)
                    col = float4(1,0,0,1);
                return col;
            }
            ENDCG
        }
    }
}
