Shader "Unlit/02_Ambient"
{
    Properties
    {
        _Color("Base Color", Color) = (1, 0, 0, 1)
        _AmbientColor("Ambient Color", Color) = (0.2, 0.2, 0.2, 1)
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            fixed4 _Color;
            fixed4 _AmbientColor;

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // »·¾³¹â¤Î¤ß
                return _AmbientColor * _Color;
            }
            ENDCG
        }
    }
}
