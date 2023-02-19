Shader "Unlit/00.2BrightnessSatruationAndConstrast"
{
    Properties  {
        _MainTex  ("Base  (RGB)",  2D)  =  "white"  {}
        _Brightness  ("Brightness",  Float)  =  1
        _Saturation("Saturation",  Float)  =  1
        _Contrast("Contrast",  Float)  =  1
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

            sampler2D  _MainTex;
            float4 _MainTex_ST;
            float  _Brightness, _Saturation,  _Contrast;

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
                fixed4  renderTex  =  tex2D(_MainTex,  i.uv);
                //亮度的调整非常简单，我们只需要把原颜色乘以亮度系数_Brightness即可.
                //  Apply  brightness
                fixed3  finalColor  =  renderTex.rgb  *  _Brightness;

                //计算亮度值
                //  Apply  saturation
                fixed luminance = 0.2125 * renderTex.r + 0.7154 * renderTex.g + 0.0721 * renderTex.b;
                fixed3  luminanceColor  =  fixed3(luminance,  luminance,  luminance);
                //饱和度
                finalColor  =  lerp(luminanceColor,  finalColor,  _Saturation);

                // 对比度
                // Apply  contrast
                fixed3  avgColor  =  fixed3(0.5,  0.5,  0.5);
                finalColor  =  lerp(avgColor,  finalColor,  _Contrast);

                return fixed4(finalColor,  renderTex.a);
            }
            ENDCG
        }
    }
}