Shader "Unlit/05_Phong_Texture"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Color("Base Color", Color) = (1,1,1,1)
        _AmbientColor("Ambient Color", Color) = (0.2,0.2,0.2,1)
        _DiffuseScale("Diffuse Scale", Range(0,2)) = 1
        _SpecularScale("Specular Scale", Range(0,2)) = 1
        _Shininess("Shininess", Range(1,100)) = 20
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
            #include "Lighting.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Color;
            fixed4 _AmbientColor;
            float _DiffuseScale;
            float _SpecularScale;
            float _Shininess;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD0;
                float3 worldPosition : TEXCOORD1;
                float2 uv : TEXCOORD2;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.worldPosition = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // --- 光照 ---
                float3 N = normalize(i.normal);
                float3 L = normalize(_WorldSpaceLightPos0.xyz);
                float3 V = normalize(_WorldSpaceCameraPos.xyz - i.worldPosition);

                fixed4 ambient = _AmbientColor * _Color;
                float diffuseIntensity = saturate(dot(N,L)) * _DiffuseScale;
                fixed4 diffuse = _Color * diffuseIntensity * _LightColor0;

                float3 R = reflect(-L, N);
                float spec = pow(saturate(dot(R,V)), _Shininess) * _SpecularScale;
                fixed4 specular = spec * _LightColor0 * _Color;

                fixed4 lighting = ambient + diffuse + specular;

                // --- 贴图采样 ---
                fixed4 texColor = tex2D(_MainTex, i.uv);

                // --- 合成 ---
                fixed4 finalColor = texColor * lighting;
                finalColor.a = 1.0;
                return finalColor;
            }
            ENDCG
        }
    }
}
