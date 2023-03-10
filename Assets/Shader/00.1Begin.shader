/*
    许愿：
        1、下雨的窗:
            ref:https://www.youtube.com/watch?v=EBrAdahFtuo
                https://www.youtube.com/watch?v=0flY11lVCwY&t=1s
        2、草海，碰撞，燃烧
        3、毛玻璃,马赛克玻璃等
            https://blog.csdn.net/weixin_45023328/article/details/115448067
            https://blog.csdn.net/poem_qianmo/article/details/51871531#:~:text=%E9%AB%98%E6%96%AF%E6%A8%A1%E7%B3%8A%E7%9A%84%E5%85%B7%E4%BD%93%E6%93%8D,%E4%B8%AD%E5%BF%83%E5%83%8F%E7%B4%A0%E7%82%B9%E7%9A%84%E5%80%BC%E3%80%82
        4、2d spriteRender常用效果
            https://blog.csdn.net/ynnmnm/article/details/69791337
        5、恶灵特效模拟
        6、消融效果
            https://imgtec.eetrend.com/blog/2020/100052999.html
        7、扭曲效果，水珠效果和一些火的效果都可以这么实现
            https://blog.csdn.net/linjf520/article/details/104962646

    
    笔记在这：
    begin:
        https://docs.unity3d.com/cn/2019.4/Manual/SL-VertexFragmentShaderExamples.html

    一些unity内置函数:
        http://www.cppblog.com/lai3d/archive/2008/10/23/64889.html

    一个数学曲线网站,可以通过这些来查看曲线的图像,根据图像获得想要的效果:
        https://www.desmos.com/calculator?lang=zh-CN


 */
Shader "Unlit/00Begin"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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

            v2f vert (appdata v)
            {
                //对象空间转换为所谓的“裁剪空间” 
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                //TRANSFORM_TEX方法比较简单，就是将模型顶点的uv和Tiling、Offset两个变量进行运算，计算出实际显示用的定点uv。
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {

                //fixed4 col = tex2D(_MainTex, i.uv);

                //左下角 00 右上角 11
                // float2 uv = i.uv;// 0~1
                // fixed4 col =  float4(uv.x,uv.y,0,1);

                //uv到左下角00的距离
                float2 uv = i.uv -.5;// -.5~.5;
                float distance = length(uv);;
                float r = .3;

                float c = smoothstep(r, r-.1,distance);


                // if(distance < r)
                //     c = 1;
                    
                fixed4 col =  float4(float3(c,c,c),1);



                return col;
            }
            ENDCG
        }
    }
}
