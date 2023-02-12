Shader "Unlit/01Rain"
{   
    /*
    一些unity内置函数:
        http://www.cppblog.com/lai3d/archive/2008/10/23/64889.html
    */
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Size ("Size",float) = 1
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


            float _Size;

            v2f vert (appdata v)
            {
                //对象空间转换为所谓的“裁剪空间” https://docs.unity3d.com/cn/2019.4/Manual/SL-VertexFragmentShaderExamples.html
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                //TRANSFORM_TEX方法比较简单，就是将模型顶点的uv和Tiling、Offset两个变量进行运算，计算出实际显示用的定点uv。
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = 0;

                float2 aspect = float2(2,1);
                //输出的uv坐标是什么？ ->纹理坐标
                float2 uv = i.uv * _Size * aspect;

                //frac是什么 ->frac函数返回标量或每个矢量中各分量的小数部分。
                /*
                So
                frac(0.5) = 0.5
                frac(1.25) = 0.25
                frac(100.75) = 0.75
                frac(9.1) = 0.1
                */
                float2 gv = frac(uv) -.5; // 把原点放到中心
                
                //smoothstep是什么？ -> 线性映射到一个范围内的值 https://blog.csdn.net/woodengm/article/details/125597326

                float drop = smoothstep();
                //col.rg = gv;
                if(gv.x > .49 || gv.y > .49) col = float4(1,0,0,1);
                return col;
            }
            ENDCG
        }
    }
}
