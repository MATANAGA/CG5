Shader "Unlit/03_Specular"
{
    Properties
    {
        _Color("Color", Color) = (1, 1, 1, 1)
        _Shininess("Shininess", Range(1, 100)) = 20
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            fixed4 _Color;
            float _Shininess;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD0;
                float3 worldPosition : TEXCOORD1;
            };

            v2f vert(appdata v)
            {
                v2f o;
                // 顶点→裁剪空间
                o.vertex = UnityObjectToClipPos(v.vertex);
                // 法线→世界空间
                o.normal = UnityObjectToWorldNormal(v.normal);
                // 顶点→世界空间
                o.worldPosition = mul(unity_ObjectToWorld, v.vertex).xyz;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // 归一化向量
                float3 N = normalize(i.normal);
                float3 L = normalize(_WorldSpaceLightPos0.xyz);
                float3 V = normalize(_WorldSpaceCameraPos.xyz - i.worldPosition);

                // 反射方向
                float3 R = reflect(-L, N);

                // 镜面反射强度
                float spec = pow(saturate(dot(R, V)), _Shininess);

                // 镜面反射颜色
                fixed4 specular = spec * _LightColor0 * _Color;

                return specular;
            }
            ENDCG
        }
    }
}
