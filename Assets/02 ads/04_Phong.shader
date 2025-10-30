Shader "Unlit/04_Phong"
{
    Properties
    {
        _Color("Base Color", Color) = (1, 1, 1, 1)
        _AmbientColor("Ambient Color", Color) = (0.2, 0.2, 0.2, 1)
        _Shininess("Shininess", Range(1, 100)) = 20
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

            fixed4 _Color;
            fixed4 _AmbientColor;
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
                // ���� �� �ü��ռ�
                o.vertex = UnityObjectToClipPos(v.vertex);
                // ���� �� ����ռ�
                o.normal = UnityObjectToWorldNormal(v.normal);
                // ���� �� ����ռ�
                o.worldPosition = mul(unity_ObjectToWorld, v.vertex).xyz;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // ������
                fixed4 ambient = _AmbientColor * _Color;

                // ��һ������
                float3 N = normalize(i.normal);
                float3 L = normalize(_WorldSpaceLightPos0.xyz);
                float3 V = normalize(_WorldSpaceCameraPos.xyz - i.worldPosition);

                // ������ (Lambert)
                float diffuseIntensity = saturate(dot(N, L));
                fixed4 diffuse = _Color * diffuseIntensity * _LightColor0;

                // ���淴�� (Specular)
                float3 R = reflect(-L, N);
                float spec = pow(saturate(dot(R, V)), _Shininess);
                fixed4 specular = spec * _LightColor0 * _Color;

                // ADS �ϳ�
                fixed4 finalColor = ambient + diffuse + specular;
                finalColor.a = 1.0;

                return finalColor;
            }
            ENDCG
        }
    }
}
